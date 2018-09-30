// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module tesla.polyfill;

import core.exception;
import watt.text.format : format;
import io = watt.io;

import lib.llvm;
import wasm = wasm;

import tesla.polyfill.funcs;


class Func
{
public:
	name: string;
	ft: FuncType;
	ftIndex: u32;
	isImport: bool;
	llvmFunc: LLVMValueRef;


public:
	this(name: string, ft: FuncType, index: u32, isImport: bool)
	{
		this.name = name;
		this.ft = ft;
		this.ftIndex = index;
		this.isImport = isImport;
	}

	this(ft: FuncType, index: u32)
	{
		this.ft = ft;
		this.ftIndex = index;
	}
}

class Global
{
	llvmValue: LLVMValueRef;
	initExpr: wasm.InitExpr;

	type: wasm.Type;
	isImport: bool;
	isPointer: bool;
}

class FuncType
{
public:
	argTypes: wasm.Type[];
	retType: wasm.Type;
	llvmType: LLVMTypeRef;

	@property fn hasRet() wasm.Type
	{ return retType != wasm.Type.Void; }
}

class Polyfill : wasm.Reader
{
public:
	ctx: LLVMContextRef;
	mod: LLVMModuleRef;
	builder: LLVMBuilderRef;

	funcPrefix: string;
	funcAnonFmtStr: string;

	codeSection: const(u8)[];

	lastSection: wasm.Section;

	hasProccessedType: bool;
	hasProccessedImport: bool;
	hasProccessedFunction: bool;
	hasProccessedTable: bool;
	hasProccessedMemory: bool;
	hasProccessedGlobal: bool;
	hasProccessedExport: bool;
	hasProccessedStart: bool;
	hasProccessedElement: bool;
	hasProccessedCode: bool;
	hasProccessedData: bool;

	numFuncImports: u32;
	numGlobalImports: u32;

	startIndex: u32;
	typeVoid: LLVMTypeRef;
	typeI1: LLVMTypeRef;
	typeI8: LLVMTypeRef;
	typeI16: LLVMTypeRef;
	typeI32: LLVMTypeRef;
	typeI64: LLVMTypeRef;
	typeF32: LLVMTypeRef;
	typeF64: LLVMTypeRef;

	funcs: Func[];
	funcTypes: FuncType[];

	globals: Global[];

	valueStack: ValueStack;
	blockStack: BlockStack;
	currentFunc: Func;
	currentBlock: LLVMBasicBlockRef;
	currentLocals: LLVMValueRef[];
	currentLocalTypes: wasm.Type[];

	globalTeslaStack: LLVMValueRef;

	fns: InbuiltFuncs;


	// Hack for now.
	@property fn isLinkable() bool { return true; }

public:
	this()
	{
		funcPrefix = "_t_";
		funcAnonFmtStr = "_t%s";

		this.valueStack.poly = this;
		this.ctx = LLVMContextCreate();
		this.mod = LLVMModuleCreateWithNameInContext("polyfill", this.ctx);
		this.builder = LLVMCreateBuilderInContext(this.ctx);
		this.typeVoid = LLVMVoidTypeInContext(this.ctx);
		this.typeI1 = LLVMInt1TypeInContext(this.ctx);
		this.typeI8 = LLVMInt8TypeInContext(this.ctx);
		this.typeI16 = LLVMInt16TypeInContext(this.ctx);
		this.typeI32 = LLVMInt32TypeInContext(this.ctx);
		this.typeI64 = LLVMInt64TypeInContext(this.ctx);
		this.typeF32 = LLVMFloatTypeInContext(this.ctx);
		this.typeF64 = LLVMDoubleTypeInContext(this.ctx);

		makeInbuilt();
	}

	fn printToString() string
	{
		return LLVMPrintModuleToString(this.mod);
	}

	fn writeToFile(filename: string)
	{
		LLVMWriteBitcodeToFile(this.mod, filename);
	}

	fn close()
	{
		this.typeVoid = null;
		this.typeI1 = null;
		this.typeI8 = null;
		this.typeI16 = null;
		this.typeI32 = null;
		this.typeI64 = null;
		this.typeF32 = null;
		this.typeF64 = null;
		this.funcTypes = null;
		LLVMDisposeBuilder(this.builder);
		LLVMDisposeModule(this.mod);
		LLVMContextDispose(this.ctx);
		this.builder = null;
		this.mod = null;
		this.ctx = null;
	}


	/*
	 *
	 * Helpers.
	 *
	 */

	fn makeInbuilt()
	{
		fns.setup(this.mod, typeVoid, typeI32, typeI64, typeF32, typeF64);

		globalTeslaStack = LLVMAddGlobal(this.mod, typeI32, "__tesla_stack_ptr");
		LLVMSetInitializer(globalTeslaStack, LLVMConstNull(typeI32));
	}

	fn toLLVMFromValueType(t: wasm.Type) LLVMTypeRef
	{
		switch (t) with (wasm.Type) {
		case I32: return typeI32;
		case I64: return typeI64;
		case F32: return typeF32;
		case F64: return typeF64;
		default: onError("invalid value_type");
		}
		return null;
	}

	fn toLLVMFromValueTypeOrVoid(t: wasm.Type) LLVMTypeRef
	{
		switch (t) with (wasm.Type) {
		case Void: return typeVoid;
		case I32: return typeI32;
		case I64: return typeI64;
		case F32: return typeF32;
		case F64: return typeF64;
		default: onError("invalid value_type or void");
		}
		return null;
	}


	/*
	 *
	 * Readers.
	 *
	 */

	override fn onSection(id: wasm.Section, data: const(u8)[]) wasm.SkipOrParse
	{
		if (id != wasm.Section.Custom) {
			ensureSectionOrder(id);
			lastSection = id;
		}

		switch (id) with (wasm.Section) {
		case Element: return wasm.SkipOrParse.Skip;
		case Code: codeSection = data; return wasm.SkipOrParse.Skip;
		case Data: return wasm.SkipOrParse.Skip;
		default: return wasm.SkipOrParse.Parse;
		}
	}


	/*
	 *
	 * Reading the types section.
	 *
	 */

	override fn onTypeSection(count: u32)
	{
		hasProccessedType = true;
		funcTypes = new FuncType[](count);
	}

	override fn onTypeEntry(num: u32, from: wasm.Type, args: wasm.Type[], ret: wasm.Type)
	{
		ensureValidFuncTypeIndex(num, "type entry");

		llvmRet := toLLVMFromValueTypeOrVoid(ret);
		llvmArgs := new LLVMTypeRef[](args.length);
		foreach (i, ref t; llvmArgs) {
			t = toLLVMFromValueType(args[i]);
		}
		ft := new FuncType();
		ft.argTypes = args;
		ft.retType = ret;
		ft.llvmType = LLVMFunctionType(llvmRet, llvmArgs, false);
		funcTypes[num] = ft;
	}


	/*
	 *
	 * Reading the import section.
	 *
	 */

	override fn onImportSection(count: u32)
	{
		ensureTypeSection("import");
		hasProccessedImport = true;
	}

	override fn onImportGlobal(num: u32, mod: string, field: string, t: wasm.Type, mut: bool)
	{
		g := new Global();
		g.type = t;
		g.isImport = true;
		globals ~= g;
	}

	override fn onImportFunc(num: u32, mod: string, field: string, index: u32)
	{
		// This should be enforced by the section order logic.
		assert(!hasProccessedFunction);

		if (mod != "env") {
			return onError("invalid import");
		}

		ensureValidFuncTypeIndex(index, "import entry");

		ft := funcTypes[index];
		funcs ~= new Func(field, ft, index, true);
	}


	/*
	 *
	 * Reading the function section.
	 *
	 */

	override fn onFunctionSection(count: u32)
	{
		ensureTypeSection("function");
		hasProccessedFunction = true;

		numFuncImports = cast(u32)funcs.length;
		funcs = funcs ~ new Func[](count);
	}

	override fn onFunctionEntry(num: u32, index: u32)
	{
		realNum := numFuncImports + num;

		ensureValidFuncIndex(realNum, "function entry");
		ensureValidFuncTypeIndex(index, "function entry");

		ft := funcTypes[index];
		name := format(funcAnonFmtStr, num); // May be overridden by export.
		funcs[realNum] = new Func(ft, index);
	}


	/*
	 *
	 * Reading the table section.
	 *
	 */

	override fn onTableSection(count: u32)
	{
		hasProccessedTable = true;
		ensureOneEntry(count, "table");
	}

	override fn onTableEntry(num: u32, elem_type: wasm.Type, l: wasm.Limits)
	{

	}


	/*
	 *
	 * Reading the table section.
	 *
	 */

	override fn onMemorySection(count: u32)
	{
		hasProccessedMemory = true;
		ensureOneEntry(count, "memory");
	}

	override fn onMemoryEntry(num: u32, l: wasm.Limits)
	{

	}


	/*
	 *
	 * Reading the global section.
	 *
	 */

	override fn onGlobalSection(count: u32)
	{
		hasProccessedGlobal = true;

		numGlobalImports = cast(u32)globals.length;
		globals = globals ~ new Global[](count);
	}

	override fn onGlobalEntry(num: u32, type: wasm.Type, mut: bool, exp: wasm.InitExpr)
	{
		realNum := numGlobalImports + num;

		ensureValidGlobalIndex(realNum, "global entry");

		g := new Global();
		g.type = type;
		g.initExpr = exp;

		if (mut) {
			g.isPointer = true;
			llvmType := toLLVMFromValueType(type);
			cname := format("__tesla_global_%s\0", realNum).ptr;
			LLVMAddGlobal(this.mod, llvmType, cname);
			// TODO initExpr.
		} else {
			// TODO value.
		}
	}


	/*
	 *
	 * Reading the export section.
	 *
	 */

	override fn onExportSection(count: u32)
	{
		hasProccessedType = true;
	}

	override fn onExportEntry(num: u32, name: string, kind: wasm.ExternalKind, index: u32)
	{
		final switch(kind) with (wasm.ExternalKind) {
		case Memory, Table, Global: break; // Nop.
		case Function:
			ensureNotImportFuncIndex(index, "export entry");
			ensureValidFuncIndex(index, "export entry");
			funcs[index].name = funcPrefix ~ name;
			break;
		}
	}


	/*
	 *
	 * Reloc section.
	 *
	 */

	override fn onRelocSection(section: wasm.Section, name: string, count: u32) {}
	override fn onRelocEntry(num: u32, type: wasm.RelocType, offset: u32, index: u32, addend: u32) {}
	override fn onRelocSectionEnd() {}


	/*
	 *
	 * Misc.
	 *
	 */

	override fn onReadError(err: string)
	{
		onError(format("read error \"%s\"", err));
	}

	fn onError(err: string, loc: string = __LOCATION__)
	{
		io.output.writefln("%s", printToString());
		io.output.flush();
		str := format("%s: error: %s", loc, err);
		io.error.writefln("%s", str);
		io.error.flush();
		throw new Exception(str);
	}

	override fn onEOF()
	{
		foreach (i, f; funcs) {
			llvmType := f.ft.llvmType;
			f.llvmFunc = LLVMAddFunction(this.mod, f.name, llvmType);
		}

		wasm.readCodeSection(this, codeSection);
	}


	/*
	 *
	 * Function bodies.
	 *
	 */

	override fn onFunctionBody(num: u32, types: wasm.Type[], counts: u32[])
	{
		numLocals: u32;
		foreach (c; counts) {
			numLocals += c;
		}

		f := funcs[numFuncImports + num];
		currentFunc = f;
		currentBlock = buildBlock("entry");
		LLVMPositionBuilderAtEnd(builder, currentBlock);

		// Arguments are locals as well.
		numLocals += cast(u32)f.ft.argTypes.length;
		if (numLocals > 0) {
			pos: u32;
			currentLocals = new LLVMValueRef[](numLocals);
			currentLocalTypes = new wasm.Type[](numLocals);

			foreach (i, type; f.ft.argTypes) {
				llvmType := toLLVMFromValueType(type);
				ptr := LLVMBuildAlloca(builder, llvmType, null);
				v := LLVMGetParam(f.llvmFunc, cast(u32)i);
				LLVMBuildStore(builder, v, ptr);
				currentLocalTypes[pos] = type;
				currentLocals[pos++] = ptr;
			}

			foreach (i, c; counts) {
				type := types[i];
				llvmType := toLLVMFromValueType(type);
				foreach (k; 0 .. c) {
					ptr := LLVMBuildAlloca(builder, llvmType, null);
					currentLocalTypes[pos] = type;
					currentLocals[pos++] = ptr;
				}
			}
		}
	}

	override fn onFunctionBodyEnd(num: u32)
	{
		//io.writefln("end");

		buildRet();
		currentBlock = null;
		currentLocals = null;
		currentLocalTypes = null;
	}

	override fn onOpI32Const(v: i32)
	{
		//io.writefln("i32.const");

		ensureBlock(wasm.Opcode.I32Const);

		llvmValue := LLVMConstInt(typeI32, cast(u64)v, false);
		valueStack.push(wasm.Type.I32, llvmValue);
	}

	override fn onOpI64Const(v: i64)
	{
		//io.writefln("i64.const");

		ensureBlock(wasm.Opcode.I64Const);

		llvmValue := LLVMConstInt(typeI64, cast(u64)v, false);
		valueStack.push(wasm.Type.I64, llvmValue);
	}

	override fn onOpF32Const(v: f32)
	{
		//io.writefln("f32.const");

		ensureBlock(wasm.Opcode.F32Const);

		llvmValue := LLVMConstReal(typeF32, v);
		valueStack.push(wasm.Type.F32, llvmValue);
	}

	override fn onOpF64Const(v: f64)
	{
		//io.writefln("f64.const");

		ensureBlock(wasm.Opcode.F64Const);

		llvmValue := LLVMConstReal(typeF64, v);
		valueStack.push(wasm.Type.F64, llvmValue);
	}

	override fn onControl(op: wasm.Opcode, t: wasm.Type)
	{
		//io.writefln("%s", wasm.opToString(op));

		if (t != wasm.Type.Void) {
			return onError("can not handle control with return type");
		}

		switch (op) with (wasm.Opcode) {
		case Unreachable:
			break;
		case Block:
			ensureBlock(op);

			be: BlockEntry;
			be.block = buildBlock("block_end");
			blockStack.push(t, be);
			break;
		case Loop:
			ensureBlock(op);

			be: BlockEntry;
			be.block = buildBlock("loop");
			LLVMMoveBasicBlockAfter(be.block, currentBlock);

			be.isLoop = true;
			blockStack.push(t, be);
			LLVMBuildBr(builder, be.block);
			currentBlock = be.block;
			LLVMPositionBuilderAtEnd(builder, currentBlock);
			break;
		case End:
			// Ends may be after terminating instructions.

			be := blockStack.pop();
			if (be.isLoop) {
				break;
			}
			if (currentBlock !is null) {
				LLVMBuildBr(builder, be.block);
				LLVMMoveBasicBlockAfter(be.block, currentBlock);
			}
			currentBlock = be.block;
			after := LLVMGetLastBasicBlock(currentFunc.llvmFunc);
			LLVMMoveBasicBlockAfter(currentBlock, after);
			LLVMPositionBuilderAtEnd(builder, currentBlock);
			break;
		case Return:
			buildRet();
			currentBlock = null;
			break;
		default:
			unhandledOp(op, "control");
		}
	}

	override fn onBranch(op: wasm.Opcode, relative_depth: u32)
	{
		//io.writefln("%s", wasm.opToString(op));

		ensureBlock(op);

		switch (op) with (wasm.Opcode) {
		case Br:
			type: wasm.Type;
			be: BlockEntry;
			blockStack.getRelative(relative_depth, out type, out be);
			LLVMBuildBr(builder, be.block);

			currentBlock = null;
			break;
		case BrIf:
			v := valueStack.pop(wasm.Type.I32);
			v = LLVMBuildTruncOrBitCast(builder, v, typeI1, "");

			type: wasm.Type;
			be: BlockEntry;
			blockStack.getRelative(relative_depth, out type, out be);

			then := buildBlock("then");
			LLVMBuildCondBr(builder, v, be.block, then);
			currentBlock = then;
			LLVMPositionBuilderAtEnd(builder, currentBlock);
			break;
		default:
			unhandledOp(op, "break");
		}
	}

	override fn onCall(index: u32)
	{
		//io.writefln("%s", wasm.opToString(wasm.Opcode.Call));

		ensureBlock(wasm.Opcode.Call);

		f := funcs[index];
		ft := f.ft;
		args: LLVMValueRef[];

		if (ft.argTypes.length > 0) {
			args = new LLVMValueRef[](ft.argTypes.length);
			c := args.length;
			foreach_reverse (i, a; ft.argTypes) {
				args[i] = valueStack.pop(a);
			}
		}

		v := LLVMBuildCall(builder, f.llvmFunc, args);
		if (ft.hasRet) {
			valueStack.push(ft.retType, v);
		}
	}

	override fn onCallIndirect(typeIndex: u32)
	{
		//io.writefln("call_indirect %s", typeIndex);

		ensureValidFuncTypeIndex(typeIndex, "call_indirect");

		ft := funcTypes[typeIndex];
		args: LLVMValueRef[];

		if (ft.argTypes.length > 0) {
			args = new LLVMValueRef[](ft.argTypes.length);
			foreach_reverse (i, a; ft.argTypes) {
				args[i] = valueStack.pop(a);
			}
		}

		if (ft.hasRet) {
			onOpI32Const(0);
		}
	}

	override fn onOp(op: wasm.Opcode)
	{
		//io.writefln("%s", wasm.opToString(op));

		ensureBlock(op);

		switch (op) with (wasm.Opcode) {
		case Drop: valueStack.pop(); break;
		case Select:
			c := valueStack.pop(wasm.Type.I32);
			t := valueStack.topType();
			l := valueStack.pop(t);
			r := valueStack.pop(t);
			v := LLVMBuildSelect(builder, c, l, r, "");
			valueStack.push(t, v);
			break;

		// 32-bit integer.
		case I32Add: buildBinOp(wasm.Type.I32, LLVMOpcode.Add); break;
		case I32Sub: buildBinOp(wasm.Type.I32, LLVMOpcode.Sub); break;
		case I32Mul: buildBinOp(wasm.Type.I32, LLVMOpcode.Mul); break;
		case I32DivU: buildBinCall(wasm.Type.I32, fns.fnI32DivU); break;
		case I32DivS: buildBinCall(wasm.Type.I32, fns.fnI32DivS); break;
		case I32RemU: buildBinCall(wasm.Type.I32, fns.fnI32RemU); break;
		case I32RemS: buildBinCall(wasm.Type.I32, fns.fnI32RemS); break;
		case I32And: buildBinOp(wasm.Type.I32, LLVMOpcode.And); break;
		case I32Or: buildBinOp(wasm.Type.I32, LLVMOpcode.Or); break;
		case I32Xor: buildBinOp(wasm.Type.I32, LLVMOpcode.Xor); break;
		case I32Shl: buildBinOp(wasm.Type.I32, LLVMOpcode.Shl); break;
		case I32ShrU: buildBinOp(wasm.Type.I32, LLVMOpcode.LShr); break;
		case I32ShrS: buildBinOp(wasm.Type.I32, LLVMOpcode.AShr); break;
		case I32Rotl: buildBinCall(wasm.Type.I32, fns.fnI32Rotl); break;
		case I32Rotr: buildBinCall(wasm.Type.I32, fns.fnI32Rotr); break;
		case I32Clz: buildUnaryCall(wasm.Type.I32, fns.fnI32Clz); break;
		case I32Ctz: buildUnaryCall(wasm.Type.I32, fns.fnI32Ctz); break;
		case I32Popcnt: buildUnaryCall(wasm.Type.I32, fns.fn_ctpop_i32); break;
		case I32Eq: buildICmp(wasm.Type.I32, LLVMIntPredicate.EQ); break;
		case I32Ne: buildICmp(wasm.Type.I32, LLVMIntPredicate.NE); break;
		case I32LeU: buildICmp(wasm.Type.I32, LLVMIntPredicate.ULE); break;
		case I32LeS: buildICmp(wasm.Type.I32, LLVMIntPredicate.SLE); break;
		case I32LtU: buildICmp(wasm.Type.I32, LLVMIntPredicate.ULT); break;
		case I32LtS: buildICmp(wasm.Type.I32, LLVMIntPredicate.SLT); break;
		case I32GeU: buildICmp(wasm.Type.I32, LLVMIntPredicate.UGE); break;
		case I32GeS: buildICmp(wasm.Type.I32, LLVMIntPredicate.SGE); break;
		case I32GtU: buildICmp(wasm.Type.I32, LLVMIntPredicate.UGT); break;
		case I32GtS: buildICmp(wasm.Type.I32, LLVMIntPredicate.SGT); break;
		case I32Eqz:
			valueStack.push(wasm.Type.I32, LLVMConstInt(typeI32, 0, false));
			buildICmp(wasm.Type.I32, LLVMIntPredicate.EQ);
			break;

		case F32Eq: buildFCmp(wasm.Type.F32, LLVMRealPredicate.OEQ); break;
		case F32Ne: buildFCmp(wasm.Type.F32, LLVMRealPredicate.ONE); break;
		case F32Lt: buildFCmp(wasm.Type.F32, LLVMRealPredicate.OLT); break;
		case F32Gt: buildFCmp(wasm.Type.F32, LLVMRealPredicate.OGT); break;
		case F32Le: buildFCmp(wasm.Type.F32, LLVMRealPredicate.OLE); break;
		case F32Ge: buildFCmp(wasm.Type.F32, LLVMRealPredicate.OGE); break;
		case F64Eq: buildFCmp(wasm.Type.F64, LLVMRealPredicate.OEQ); break;
		case F64Ne: buildFCmp(wasm.Type.F64, LLVMRealPredicate.ONE); break;
		case F64Lt: buildFCmp(wasm.Type.F64, LLVMRealPredicate.OLT); break;
		case F64Gt: buildFCmp(wasm.Type.F64, LLVMRealPredicate.OGT); break;
		case F64Le: buildFCmp(wasm.Type.F64, LLVMRealPredicate.OLE); break;
		case F64Ge: buildFCmp(wasm.Type.F64, LLVMRealPredicate.OGE); break;

		// 64-bit integer.
		case I64Add: buildBinOp(wasm.Type.I64, LLVMOpcode.Add); break;
		case I64Sub: buildBinOp(wasm.Type.I64, LLVMOpcode.Sub); break;
		case I64Mul: buildBinOp(wasm.Type.I64, LLVMOpcode.Mul); break;
		case I64DivU: buildBinCall(wasm.Type.I64, fns.fnI64DivU); break;
		case I64DivS: buildBinCall(wasm.Type.I64, fns.fnI64DivS); break;
		case I64RemU: buildBinCall(wasm.Type.I64, fns.fnI64RemU); break;
		case I64RemS: buildBinCall(wasm.Type.I64, fns.fnI64RemS); break;
		case I64And: buildBinOp(wasm.Type.I64, LLVMOpcode.And); break;
		case I64Or: buildBinOp(wasm.Type.I64, LLVMOpcode.Or); break;
		case I64Xor: buildBinOp(wasm.Type.I64, LLVMOpcode.Xor); break;
		case I64Shl: buildBinOp(wasm.Type.I64, LLVMOpcode.Shl); break;
		case I64ShrU: buildBinOp(wasm.Type.I64, LLVMOpcode.LShr); break;
		case I64ShrS: buildBinOp(wasm.Type.I64, LLVMOpcode.AShr); break;
		case I64Rotl: buildBinCall(wasm.Type.I64, fns.fnI64Rotl); break;
		case I64Rotr: buildBinCall(wasm.Type.I64, fns.fnI64Rotr); break;
		case I64Clz: buildUnaryCall(wasm.Type.I64, fns.fnI64Clz); break;
		case I64Ctz: buildUnaryCall(wasm.Type.I64, fns.fnI64Ctz); break;
		case I64Popcnt: buildUnaryCall(wasm.Type.I64, fns.fn_ctpop_i64); break;
		case I64Eq: buildICmp(wasm.Type.I64, LLVMIntPredicate.EQ); break;
		case I64Ne: buildICmp(wasm.Type.I64, LLVMIntPredicate.NE); break;
		case I64LeU: buildICmp(wasm.Type.I64, LLVMIntPredicate.ULE); break;
		case I64LeS: buildICmp(wasm.Type.I64, LLVMIntPredicate.SLE); break;
		case I64LtU: buildICmp(wasm.Type.I64, LLVMIntPredicate.ULT); break;
		case I64LtS: buildICmp(wasm.Type.I64, LLVMIntPredicate.SLT); break;
		case I64GeU: buildICmp(wasm.Type.I64, LLVMIntPredicate.UGE); break;
		case I64GeS: buildICmp(wasm.Type.I64, LLVMIntPredicate.SGE); break;
		case I64GtU: buildICmp(wasm.Type.I64, LLVMIntPredicate.UGT); break;
		case I64GtS: buildICmp(wasm.Type.I64, LLVMIntPredicate.SGT); break;
		case I64Eqz:
			valueStack.push(wasm.Type.I64, LLVMConstInt(typeI64, 0, false));
			buildICmp(wasm.Type.I64, LLVMIntPredicate.EQ);
			break;

		// FLoating ops
		case F32Abs: buildUnaryCall(wasm.Type.F32, fns.fn_fabs_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Neg:
			zero := LLVMConstReal(typeF32, 0.0);
			v := valueStack.pop(wasm.Type.F32);
			v = LLVMBuildBinOp(builder, LLVMOpcode.FSub, zero, v, "");
			valueStack.push(wasm.Type.F32, v);
			break;
		case F32Ceil: buildUnaryCall(wasm.Type.F32, fns.fn_ceil_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Floor: buildUnaryCall(wasm.Type.F32, fns.fn_floor_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Trunc: buildUnaryCall(wasm.Type.F32, fns.fn_trunc_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Nearest: buildUnaryCall(wasm.Type.F32, fns.fn_nearbyint_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Sqrt: buildUnaryCall(wasm.Type.F32, fns.fn_sqrt_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Add: buildBinOp(wasm.Type.F32, LLVMOpcode.FAdd); valueStack.checkTop(wasm.Type.F32); break;
		case F32Sub: buildBinOp(wasm.Type.F32, LLVMOpcode.FSub); valueStack.checkTop(wasm.Type.F32); break;
		case F32Mul: buildBinOp(wasm.Type.F32, LLVMOpcode.FMul); valueStack.checkTop(wasm.Type.F32); break;
		case F32Div: buildBinCall(wasm.Type.F32, fns.fnF32Div); valueStack.checkTop(wasm.Type.F32); break;
		case F32Min: buildBinCall(wasm.Type.F32, fns.fn_minnum_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Max: buildBinCall(wasm.Type.F32, fns.fn_maxnum_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F32Copysign: buildBinCall(wasm.Type.F32, fns.fn_copysign_f32); valueStack.checkTop(wasm.Type.F32); break;
		case F64Abs: buildUnaryCall(wasm.Type.F64, fns.fn_fabs_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Neg:
			zero := LLVMConstReal(typeF64, 0.0);
			v := valueStack.pop(wasm.Type.F64);
			v = LLVMBuildBinOp(builder, LLVMOpcode.FSub, zero, v, "");
			valueStack.push(wasm.Type.F64, v);
			break;
		case F64Ceil: buildUnaryCall(wasm.Type.F64, fns.fn_ceil_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Floor: buildUnaryCall(wasm.Type.F64, fns.fn_floor_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Trunc: buildUnaryCall(wasm.Type.F64, fns.fn_trunc_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Nearest: buildUnaryCall(wasm.Type.F64, fns.fn_nearbyint_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Sqrt: buildUnaryCall(wasm.Type.F64, fns.fn_sqrt_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Add: buildBinOp(wasm.Type.F64, LLVMOpcode.FAdd); valueStack.checkTop(wasm.Type.F64); break;
		case F64Sub: buildBinOp(wasm.Type.F64, LLVMOpcode.FSub); valueStack.checkTop(wasm.Type.F64); break;
		case F64Mul: buildBinOp(wasm.Type.F64, LLVMOpcode.FMul); valueStack.checkTop(wasm.Type.F64); break;
		case F64Div: buildBinCall(wasm.Type.F64, fns.fnF64Div); valueStack.checkTop(wasm.Type.F64); break;
		case F64Min: buildBinCall(wasm.Type.F64, fns.fn_minnum_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Max: buildBinCall(wasm.Type.F64, fns.fn_maxnum_f64); valueStack.checkTop(wasm.Type.F64); break;
		case F64Copysign: buildBinCall(wasm.Type.F64, fns.fn_copysign_f64); valueStack.checkTop(wasm.Type.F64); break;

		// Conversions
		case I32WrapI64: buildBitCast(wasm.Type.I64, wasm.Type.I32, typeI32); valueStack.checkTop(wasm.Type.I32); break;
		case I32TruncSF32: buildConvCall(wasm.Type.F32, wasm.Type.I32, fns.fnI32TruncSF32); valueStack.checkTop(wasm.Type.I32); break;
		case I32TruncUF32: buildConvCall(wasm.Type.F32, wasm.Type.I32, fns.fnI32TruncUF32); valueStack.checkTop(wasm.Type.I32); break;
		case I32TruncSF64: buildConvCall(wasm.Type.F64, wasm.Type.I32, fns.fnI32TruncSF64); valueStack.checkTop(wasm.Type.I32); break;
		case I32TruncUF64: buildConvCall(wasm.Type.F64, wasm.Type.I32, fns.fnI32TruncUF64); valueStack.checkTop(wasm.Type.I32); break;
		case I64ExtendSI32: buildCast(wasm.Type.I32, wasm.Type.I64, typeI64, LLVMOpcode.SExt); valueStack.checkTop(wasm.Type.I64); break;
		case I64ExtendUI32: buildCast(wasm.Type.I32, wasm.Type.I64, typeI64, LLVMOpcode.ZExt); valueStack.checkTop(wasm.Type.I64); break;
		case I64TruncSF32: buildConvCall(wasm.Type.F32, wasm.Type.I64, fns.fnI64TruncSF32); valueStack.checkTop(wasm.Type.I64); break;
		case I64TruncUF32: buildConvCall(wasm.Type.F32, wasm.Type.I64, fns.fnI64TruncUF32); valueStack.checkTop(wasm.Type.I64); break;
		case I64TruncSF64: buildConvCall(wasm.Type.F64, wasm.Type.I64, fns.fnI64TruncSF64); valueStack.checkTop(wasm.Type.I64); break;
		case I64TruncUF64: buildConvCall(wasm.Type.F64, wasm.Type.I64, fns.fnI64TruncUF64); valueStack.checkTop(wasm.Type.I64); break;
		case F32ConvertSI32: buildCast(wasm.Type.I32, wasm.Type.F32, typeF32, LLVMOpcode.SIToFP); valueStack.checkTop(wasm.Type.F32); break;
		case F32ConvertUI32: buildCast(wasm.Type.I32, wasm.Type.F32, typeF32, LLVMOpcode.UIToFP); valueStack.checkTop(wasm.Type.F32); break;
		case F32ConvertSI64: buildCast(wasm.Type.I64, wasm.Type.F32, typeF32, LLVMOpcode.SIToFP); valueStack.checkTop(wasm.Type.F32); break;
		case F32ConvertUI64: buildCast(wasm.Type.I64, wasm.Type.F32, typeF32, LLVMOpcode.UIToFP); valueStack.checkTop(wasm.Type.F32); break;
		case F32DemoteF64: buildConvCall(wasm.Type.F64, wasm.Type.F32, fns.fnF32DemoteF64); valueStack.checkTop(wasm.Type.F32); break;
		case F64ConvertSI32: buildCast(wasm.Type.I32, wasm.Type.F64, typeF64, LLVMOpcode.SIToFP); valueStack.checkTop(wasm.Type.F64); break;
		case F64ConvertUI32: buildCast(wasm.Type.I32, wasm.Type.F64, typeF64, LLVMOpcode.UIToFP); valueStack.checkTop(wasm.Type.F64); break;
		case F64ConvertSI64: buildCast(wasm.Type.I64, wasm.Type.F64, typeF64, LLVMOpcode.SIToFP); valueStack.checkTop(wasm.Type.F64); break;
		case F64ConvertUI64: buildCast(wasm.Type.I64, wasm.Type.F64, typeF64, LLVMOpcode.UIToFP); valueStack.checkTop(wasm.Type.F64); break;
		case F64PromoteF32: buildCast(wasm.Type.F32, wasm.Type.F64, typeF64, LLVMOpcode.FPExt); valueStack.checkTop(wasm.Type.F64); break;
		case I32ReinterpretF32: buildBitCast(wasm.Type.F32, wasm.Type.I32, typeI32); valueStack.checkTop(wasm.Type.I32); break;
		case I64ReinterpretF64: buildBitCast(wasm.Type.F64, wasm.Type.I64, typeI64); valueStack.checkTop(wasm.Type.I64); break;
		case F32ReinterpretI32: buildBitCast(wasm.Type.I32, wasm.Type.F32, typeF32); valueStack.checkTop(wasm.Type.F32); break;
		case F64ReinterpretI64: buildBitCast(wasm.Type.I64, wasm.Type.F64, typeF64); valueStack.checkTop(wasm.Type.F64); break;
		default:
			unhandledOp(op, "generic");
		}
	}

	override fn onOpMemory(op: wasm.Opcode, flags: u32, offset: u32)
	{
		//io.writefln("%s", wasm.opToString(op));

		ensureBlock(op);

		switch (op) with (wasm.Opcode) {
		case I32Load:    buildLoad(wasm.Type.I32,  fns.fnI32Load,    offset); break;
		case I64Load:    buildLoad(wasm.Type.I64,  fns.fnI64Load,    offset); break;
		case F32Load:    buildLoad(wasm.Type.F32,  fns.fnF32Load,    offset); break;
		case F64Load:    buildLoad(wasm.Type.F64,  fns.fnF64Load,    offset); break;
		case I32Load8S:  buildLoad(wasm.Type.I32,  fns.fnI32Load8S,  offset); break;
		case I32Load8U:  buildLoad(wasm.Type.I32,  fns.fnI32Load8U,  offset); break;
		case I32Load16S: buildLoad(wasm.Type.I32,  fns.fnI32Load16S, offset); break;
		case I32Load16U: buildLoad(wasm.Type.I32,  fns.fnI32Load16U, offset); break;
		case I64Load8S:  buildLoad(wasm.Type.I64,  fns.fnI64Load8S,  offset); break;
		case I64Load8U:  buildLoad(wasm.Type.I64,  fns.fnI64Load8U,  offset); break;
		case I64Load16S: buildLoad(wasm.Type.I64,  fns.fnI64Load16S, offset); break;
		case I64Load16U: buildLoad(wasm.Type.I64,  fns.fnI64Load16U, offset); break;
		case I64Load32S: buildLoad(wasm.Type.I64,  fns.fnI64Load32S, offset); break;
		case I64Load32U: buildLoad(wasm.Type.I64,  fns.fnI64Load32U, offset); break;
		case I32Store:   buildStore(wasm.Type.I32, fns.fnI32Store,   offset); break;
		case I64Store:   buildStore(wasm.Type.I64, fns.fnI64Store,   offset); break;
		case F32Store:   buildStore(wasm.Type.F32, fns.fnF32Store,   offset); break;
		case F64Store:   buildStore(wasm.Type.F64, fns.fnF64Store,   offset); break;
		case I32Store8:  buildStore(wasm.Type.I32, fns.fnI32Store8,  offset); break;
		case I32Store16: buildStore(wasm.Type.I32, fns.fnI32Store16, offset); break;
		case I64Store8:  buildStore(wasm.Type.I64, fns.fnI64Store8,  offset); break;
		case I64Store16: buildStore(wasm.Type.I64, fns.fnI64Store16, offset); break;
		case I64Store32: buildStore(wasm.Type.I64, fns.fnI64Store32, offset); break;
		default: unhandledOp(op, "memory");
		}
	}

	override fn onOpVar(op: wasm.Opcode, index: u32)
	{
		//io.writefln("%s", wasm.opToString(op));

		ensureBlock(op);
		ensureValidLocalIndex(index);

		ptr := currentLocals[index];
		type := currentLocalTypes[index];

		switch (op) with (wasm.Opcode) {
		case GetLocal:
			v := LLVMBuildLoad(builder, ptr, "");
			valueStack.push(type, v);
			break;
		case SetLocal:
			v := valueStack.pop(type);
			LLVMBuildStore(builder, v, ptr);
			break;
		case TeeLocal:
			// Don't pop the value.
			v := valueStack.checkTop(type);
			LLVMBuildStore(builder, v, ptr);
			break;
		case GetGlobal:
			if (isLinkable && index == 0) {
				v := LLVMBuildLoad(builder, globalTeslaStack, "");
				valueStack.push(wasm.Type.I32, v);
				break;
			}

			ensureValidGlobalIndex(index, "get_global");
			g := globals[index];
			if (!g.isPointer) {
				str := format("global '%s' is not a valid readable global", index);
				onError(str);
				break;
			}

			v := LLVMBuildLoad(builder, g.llvmValue, "");
			valueStack.push(g.type, v);
			break;
		case SetGlobal:
			if (isLinkable && index == 0) {
				v := valueStack.pop(wasm.Type.I32);
				LLVMBuildStore(builder, v, globalTeslaStack);
				break;
			}

			ensureValidGlobalIndex(index, "get_global");
			g := globals[index];
			if (!g.isPointer) {
				str := format("global '%s' is not a valid readable global", index);
				onError(str);
				break;
			}

			v := valueStack.pop(g.type);
			LLVMBuildStore(builder, v, g.llvmValue);
			break;
		default:
			unhandledOp(op, "var");
		}
	}

	fn buildBlock(cstr: const(char)*) LLVMBasicBlockRef
	{
		return LLVMAppendBasicBlockInContext(ctx, currentFunc.llvmFunc, cstr);
	}

	fn buildRet()
	{
		ft := currentFunc.ft;
		if (ft.hasRet) {
			LLVMBuildRet(builder, valueStack.pop(ft.retType));
		} else {
			LLVMBuildRetVoid(builder);
		}
	}

	fn buildICmp(t: wasm.Type, p: LLVMIntPredicate)
	{
		r := valueStack.pop(t);
		l := valueStack.pop(t);
		v := LLVMBuildICmp(builder, p, l, r, "");
		v = LLVMBuildZExtOrBitCast(builder, v, typeI32, "");
		valueStack.push(wasm.Type.I32, v);
	}

	fn buildFCmp(t: wasm.Type, p: LLVMRealPredicate)
	{
		r := valueStack.pop(t);
		l := valueStack.pop(t);
		v := LLVMBuildFCmp(builder, p, l, r, "");
		v = LLVMBuildZExtOrBitCast(builder, v, typeI32, "");
		valueStack.push(wasm.Type.I32, v);
	}

	fn buildBinOp(t: wasm.Type, op: LLVMOpcode)
	{
		r := valueStack.pop(t);
		l := valueStack.pop(t);
		v := LLVMBuildBinOp(builder, op, l, r, "");
		valueStack.push(t, v);
	}

	fn buildBinCall(t: wasm.Type, f: LLVMValueRef)
	{
		args: LLVMValueRef[2];
		args[1] = valueStack.pop(t);
		args[0] = valueStack.pop(t);
		v := LLVMBuildCall(builder, f, args);
		valueStack.push(t, v);
	}

	fn buildUnaryCall(t: wasm.Type, f: LLVMValueRef)
	{
		args: LLVMValueRef[1];
		args[0] = valueStack.pop(t);
		v := LLVMBuildCall(builder, f, args);
		valueStack.push(t, v);
	}

	fn buildCast(from: wasm.Type, to: wasm.Type, llvmType: LLVMTypeRef, lop: LLVMOpcode)
	{
		v := valueStack.pop(from);
		v = LLVMBuildCast(builder, lop, v, llvmType, "");
		valueStack.push(to, v);
	}

	fn buildBitCast(from: wasm.Type, to: wasm.Type, llvmType: LLVMTypeRef)
	{
		f := valueStack.pop(from);
		v := LLVMBuildZExtOrBitCast(builder, f, llvmType, "");
		valueStack.push(to, v);
	}

	fn buildConvCall(from: wasm.Type, to: wasm.Type, func: LLVMValueRef)
	{
		args: LLVMValueRef[1];
		args[0] = valueStack.pop(from);
		v := LLVMBuildCall(builder, func, args);
		valueStack.push(to, v);
	}

	fn buildLoad(t: wasm.Type, func: LLVMValueRef, offset: u32)
	{
		ptr := valueStack.pop(wasm.Type.I32);
		if (offset != 0) {
			ptr = LLVMBuildBinOp(builder, LLVMOpcode.Add,
				LLVMConstInt(typeI32, offset, false), ptr, "");
		}

		args: LLVMValueRef[1];
		args[0] = ptr;
		v := LLVMBuildCall(builder, func, args);
		valueStack.push(t, v);
	}

	fn buildStore(t: wasm.Type, func: LLVMValueRef, offset: u32)
	{
		v := valueStack.pop(t);
		ptr := valueStack.pop(wasm.Type.I32);
		if (offset != 0) {
			ptr = LLVMBuildBinOp(builder, LLVMOpcode.Add,
				LLVMConstInt(typeI32, offset, false), ptr, "");
		}

		args: LLVMValueRef[2];
		args[0] = ptr;
		args[1] = v;
		LLVMBuildCall(builder, func, args);
	}


	/*
	 *
	 * Various error checking functions.
	 *
	 */

	fn unhandledOp(op: wasm.Opcode, kind: string, loc: string = __LOCATION__)
	{
		str := format("unhandled %s opcode '%s'", kind, wasm.opToString(op));
		onError(str, loc);
	}

	fn ensureNotImportFuncIndex(index: u32, kind: string, loc: string = __LOCATION__)
	{	
		if (index >= numFuncImports) {
			return;
		}

		str := format("can not reference import function in %s", kind);
		onError(str, loc);
	}

	fn ensureValidFuncIndex(index: u32, kind: string, loc: string = __LOCATION__)
	{
		if (index < funcs.length) {
			return;
		}

		str := format("invalid function index for %s", kind);
		onError(str, loc);
	}

	fn ensureValidFuncTypeIndex(index: u32, kind: string, loc: string = __LOCATION__)
	{
		if (index < funcTypes.length) {
			return;
		}

		str := format("invalid function type index for %s", kind);
		onError(str, loc);
	}

	fn ensureValidGlobalIndex(index: u32, kind: string, loc: string = __LOCATION__)
	{
		if (index < globals.length) {
			return;
		}

		str := format("invalid global index for %s", kind);
		onError(str, loc);
	}

	fn ensureSectionOrder(id: wasm.Section, loc: string = __LOCATION__)
	{
		if (id > lastSection) {
			return;
		}
		str := format("section '%s' can not come before section '%s'",
			wasm.sectionToString(id), wasm.sectionToString(lastSection));
		onError(str, loc);
	}

	fn ensureOneEntry(count: u32, section: string, loc: string = __LOCATION__)
	{
		if (count == 1) {
			return;
		}

		str := format("%s section may only have one entry", section);
		onError(str, loc);
	}

	fn ensureTypeSection(section: string, loc: string = __LOCATION__)
	{	
		if (hasProccessedType) {
			return;
		}

		str := format("%s section requires types section", section);
		onError(str, loc);
	}

	fn ensureValidLocalIndex(index: u32, loc:string = __LOCATION__)
	{
		if (index < currentLocals.length) {
			return;
		}

		onError("local index out of bounds", loc);
	}

	fn ensureBlock(op: wasm.Opcode, loc:string = __LOCATION__)
	{
		if (currentBlock !is null) {
			return;
		}

		str := format("opcode is unreachable '%s'", wasm.opToString(op));
		onError(str, loc);
	}

	fn ensureTerminated(op: wasm.Opcode, loc:string = __LOCATION__)
	{
		if (currentBlock is null) {
			return;
		}

		str := format("'%s' block does not have a terminating opcode", wasm.opToString(op));
		onError(str, loc);
	}


	/*
	 *
	 * Nops.
	 *
	 */

	override fn onHeader(ref header: wasm.Header) {}
	override fn onCustomSection(name: string, data: const(u8)[]) {}
	override fn onStart(index: u32) {}
	override fn onCodeSection(count: u32) {}
	override fn onCode(data: const(u8)[]) {}
}


struct BlockEntry
{
	block: LLVMBasicBlockRef;
	isLoop: bool;
}

struct ValueStack = mixin TypedStack!LLVMValueRef;
struct BlockStack = mixin TypedStack!BlockEntry;

struct TypedStack!(T)
{
public:
	poly: Polyfill;


private:
	enum Max = 128;

	mTs: T[Max];
	mTypes: wasm.Type[Max];
	mNum: u32;


public:
	fn push(t: wasm.Type, v: T)
	{
		checkPush();
		mTypes[mNum] = t;
		mTs[mNum] = v;
		mNum++;
	}

	fn pop(t: wasm.Type, loc: string = __LOCATION__) T
	{
		checkTypeAndPop(t, loc);
		v := mTs[mNum];
		mTs[mNum] = T.default;
		return v;
	}

	fn pop() T
	{
		checkAndPop();
		ret := mTs[mNum];
		mTs[mNum] = T.default;
		return ret;
	}

	fn topType(loc: string = __LOCATION__) wasm.Type
	{
		if (mNum <= 0) {
			poly.onError("stack under run", loc);
		}
		return mTypes[mNum-1];
	}

	fn getRelative(index: u32, out t: wasm.Type, out v: T)
	{
		index++;
		if (mNum < index) {
			poly.onError("stack under run");
		}
		t = mTypes[mNum-index];
		v = mTs[mNum-index];
	}

	fn checkTop(t: wasm.Type, loc: string = __LOCATION__) T
	{
		if (mNum < 1) {
			poly.onError("stack under run", loc);
		}
		if (mTypes[mNum-1] != t) {
			str := format("stack type missmatch expected: '%s', got: '%s'",
				wasm.typeToString(t), wasm.typeToString(mTypes[mNum-1]));
			poly.onError(str, loc);
		}
		return mTs[mNum-1];
	}

	fn checkPush(loc: string = __LOCATION__)
	{
		if (mNum >= Max) {
			poly.onError("stack to large", loc);
		}
	}

	fn checkAndPop(loc: string = __LOCATION__)
	{
		if (mNum == 0) {
			poly.onError("stack under run", loc);
		}	
		mNum--;
	}

	fn checkTypeAndPop(t: wasm.Type, loc: string = __LOCATION__)
	{
		checkAndPop();
		if (mTypes[mNum] != t) {
			str := format("stack type missmatch expected: '%s', got: '%s'",
				wasm.typeToString(t), wasm.typeToString(mTypes[mNum]));
			poly.onError(str, loc);
		}
	}
}
