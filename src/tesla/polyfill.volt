// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module tesla.polyfill;

import core.exception;
import watt.text.format : format;
import io = watt.io;

import lib.llvm;
import wasm = wasm;


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

	fnTeslaI32DivU: LLVMValueRef;
	fnTeslaI32DivS: LLVMValueRef;
	fnTeslaI32RemU: LLVMValueRef;
	fnTeslaI32RemS: LLVMValueRef;
	fnTeslaI32Clz: LLVMValueRef;
	fnTeslaI32Ctz: LLVMValueRef;
	fnTeslaI32Rotl: LLVMValueRef;
	fnTeslaI32Rotr: LLVMValueRef;

	fnTeslaI64DivU: LLVMValueRef;
	fnTeslaI64DivS: LLVMValueRef;
	fnTeslaI64RemU: LLVMValueRef;
	fnTeslaI64RemS: LLVMValueRef;
	fnTeslaI64Clz: LLVMValueRef;
	fnTeslaI64Ctz: LLVMValueRef;
	fnTeslaI64Rotl: LLVMValueRef;
	fnTeslaI64Rotr: LLVMValueRef;

	fnTeslaI32Load: LLVMValueRef;
	fnTeslaI64Load: LLVMValueRef;
	fnTeslaF32Load: LLVMValueRef;
	fnTeslaF64Load: LLVMValueRef;
	fnTeslaI32Load8S: LLVMValueRef;
	fnTeslaI32Load8U: LLVMValueRef;
	fnTeslaI32Load16S: LLVMValueRef;
	fnTeslaI32Load16U: LLVMValueRef;
	fnTeslaI64Load8S: LLVMValueRef;
	fnTeslaI64Load8U: LLVMValueRef;
	fnTeslaI64Load16S: LLVMValueRef;
	fnTeslaI64Load16U: LLVMValueRef;
	fnTeslaI64Load32S: LLVMValueRef;
	fnTeslaI64Load32U: LLVMValueRef;
	fnTeslaI32Store: LLVMValueRef;
	fnTeslaI64Store: LLVMValueRef;
	fnTeslaF32Store: LLVMValueRef;
	fnTeslaF64Store: LLVMValueRef;
	fnTeslaI32Store8: LLVMValueRef;
	fnTeslaI32Store16: LLVMValueRef;
	fnTeslaI64Store8: LLVMValueRef;
	fnTeslaI64Store16: LLVMValueRef;
	fnTeslaI64Store32: LLVMValueRef;

	fnLLVM_ctpop_i32: LLVMValueRef;
	fnLLVM_ctpop_i64: LLVMValueRef;

	// Hack for now.
	@property fn isLinkable() bool { return true; }

public:
	this()
	{
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
		this.fnTeslaI32Clz = null;
		this.fnTeslaI32Ctz = null;
		this.fnTeslaI32Rotl = null;
		this.fnTeslaI32Rotr = null;
		this.fnLLVM_ctpop_i32 = null;
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
		binI32Args: LLVMTypeRef[2];
		binI32Args[0] = typeI32;
		binI32Args[1] = typeI32;
		binI32 := LLVMFunctionType(typeI32, binI32Args, false);

		unaryI32Args: LLVMTypeRef[1];
		unaryI32Args[0] = typeI32;
		unaryI32 := LLVMFunctionType(typeI32, unaryI32Args, false);

		binI64Args: LLVMTypeRef[2];
		binI64Args[0] = typeI64;
		binI64Args[1] = typeI64;
		binI64 := LLVMFunctionType(typeI64, binI64Args, false);

		unaryI64Args: LLVMTypeRef[1];
		unaryI64Args[0] = typeI64;
		unaryI64 := LLVMFunctionType(typeI64, unaryI64Args, false);

		loadArgs: LLVMTypeRef[1];
		loadArgs[0] = typeI32;
		loadI32 := LLVMFunctionType(typeI32, loadArgs, false);
		loadI64 := LLVMFunctionType(typeI64, loadArgs, false);
		loadF32 := LLVMFunctionType(typeF32, loadArgs, false);
		loadF64 := LLVMFunctionType(typeF64, loadArgs, false);

		storeI32Args: LLVMTypeRef[2];
		storeI32Args[0] = typeI32;
		storeI32Args[1] = typeI32;
		storeI32 := LLVMFunctionType(typeVoid, storeI32Args, false);

		storeI64Args: LLVMTypeRef[2];
		storeI64Args[0] = typeI32;
		storeI64Args[1] = typeI64;
		storeI64 := LLVMFunctionType(typeVoid, storeI64Args, false);

		storeF32Args: LLVMTypeRef[2];
		storeF32Args[0] = typeI32;
		storeF32Args[1] = typeF32;
		storeF32 := LLVMFunctionType(typeVoid, storeF32Args, false);

		storeF64Args: LLVMTypeRef[2];
		storeF64Args[0] = typeI32;
		storeF64Args[1] = typeF64;
		storeF64 := LLVMFunctionType(typeVoid, storeF64Args, false);

		fnTeslaI32DivU = LLVMAddFunction(this.mod, "__tesla_op_i32_div_u", binI32);
		fnTeslaI32DivS = LLVMAddFunction(this.mod, "__tesla_op_i32_div_s", binI32);
		fnTeslaI32RemU = LLVMAddFunction(this.mod, "__tesla_op_i32_rem_u", binI32);
		fnTeslaI32RemS = LLVMAddFunction(this.mod, "__tesla_op_i32_rem_s", binI32);
		fnTeslaI32Clz = LLVMAddFunction(this.mod, "__tesla_op_i32_clz", unaryI32);
		fnTeslaI32Ctz = LLVMAddFunction(this.mod, "__tesla_op_i32_ctz", unaryI32);
		fnTeslaI32Rotl = LLVMAddFunction(this.mod, "__tesla_op_i32_rotl", binI32);
		fnTeslaI32Rotr = LLVMAddFunction(this.mod, "__tesla_op_i32_rotr", binI32);

		fnTeslaI64DivU = LLVMAddFunction(this.mod, "__tesla_op_i64_div_u", binI64);
		fnTeslaI64DivS = LLVMAddFunction(this.mod, "__tesla_op_i64_div_s", binI64);
		fnTeslaI64RemU = LLVMAddFunction(this.mod, "__tesla_op_i64_rem_u", binI64);
		fnTeslaI64RemS = LLVMAddFunction(this.mod, "__tesla_op_i64_rem_s", binI64);
		fnTeslaI64Clz = LLVMAddFunction(this.mod, "__tesla_op_i64_clz", unaryI64);
		fnTeslaI64Ctz = LLVMAddFunction(this.mod, "__tesla_op_i64_ctz", unaryI64);
		fnTeslaI64Rotl = LLVMAddFunction(this.mod, "__tesla_op_i64_rotl", binI64);
		fnTeslaI64Rotr = LLVMAddFunction(this.mod, "__tesla_op_i64_rotr", binI64);

		fnTeslaI32Load = LLVMAddFunction(this.mod, "__tesla_op_i32_load", loadI32);
		fnTeslaI64Load = LLVMAddFunction(this.mod, "__tesla_op_i64_load", loadI64);
		fnTeslaF32Load = LLVMAddFunction(this.mod, "__tesla_op_f32_load", loadF32);
		fnTeslaF64Load = LLVMAddFunction(this.mod, "__tesla_op_f64_load", loadF64);
		fnTeslaI32Load8S = LLVMAddFunction(this.mod, "__tesla_op_i32_load8_s", loadI32);
		fnTeslaI32Load8U = LLVMAddFunction(this.mod, "__tesla_op_i32_load8_u", loadI32);
		fnTeslaI32Load16S = LLVMAddFunction(this.mod, "__tesla_op_i32_load16_s", loadI32);
		fnTeslaI32Load16U = LLVMAddFunction(this.mod, "__tesla_op_i32_load16_u", loadI32);
		fnTeslaI64Load8S = LLVMAddFunction(this.mod, "__tesla_op_i64_load8_s", loadI64);
		fnTeslaI64Load8U = LLVMAddFunction(this.mod, "__tesla_op_i64_load8_u", loadI64);
		fnTeslaI64Load16S = LLVMAddFunction(this.mod, "__tesla_op_i64_load16_s", loadI64);
		fnTeslaI64Load16U = LLVMAddFunction(this.mod, "__tesla_op_i64_load16_u", loadI64);
		fnTeslaI64Load32S = LLVMAddFunction(this.mod, "__tesla_op_i64_load32_s", loadI64);
		fnTeslaI64Load32U = LLVMAddFunction(this.mod, "__tesla_op_i64_load32_u", loadI64);
		fnTeslaI32Store = LLVMAddFunction(this.mod, "__tesla_op_i32_store", storeI32);
		fnTeslaI64Store = LLVMAddFunction(this.mod, "__tesla_op_i64_store", storeI64);
		fnTeslaF32Store = LLVMAddFunction(this.mod, "__tesla_op_f32_store", storeF32);
		fnTeslaF64Store = LLVMAddFunction(this.mod, "__tesla_op_f64_store", storeF64);
		fnTeslaI32Store8 = LLVMAddFunction(this.mod, "__tesla_op_i32_store8", storeI32);
		fnTeslaI32Store16 = LLVMAddFunction(this.mod, "__tesla_op_i32_store16", storeI32);
		fnTeslaI64Store8 = LLVMAddFunction(this.mod, "__tesla_op_i64_store8", storeI64);
		fnTeslaI64Store16 = LLVMAddFunction(this.mod, "__tesla_op_i64_store16", storeI64);
		fnTeslaI64Store32 = LLVMAddFunction(this.mod, "__tesla_op_i64_store32", storeI64);

		fnLLVM_ctpop_i32 = LLVMAddFunction(this.mod, "llvm.ctpop.i32", unaryI32);
		fnLLVM_ctpop_i64 = LLVMAddFunction(this.mod, "llvm.ctpop.i64", unaryI64);

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
		name := format("__n%s", num); // May be overridden by export.
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
			funcs[index].name = name;
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
		buildRet();
		currentBlock = null;
		currentLocals = null;
		currentLocalTypes = null;
	}

	override fn onOpI32Const(v: i32)
	{
		ensureBlock(wasm.Opcode.I32Const);

		llvmValue := LLVMConstInt(typeI32, cast(u64)v, false);
		valueStack.push(wasm.Type.I32, llvmValue);
	}

	override fn onOpI64Const(v: i64)
	{
		ensureBlock(wasm.Opcode.I64Const);

		llvmValue := LLVMConstInt(typeI64, cast(u64)v, false);
		valueStack.push(wasm.Type.I64, llvmValue);
	}

	override fn onOpF32Const(v: f32) { onError("F32Const"); }
	override fn onOpF64Const(v: f64) { onError("F64Const"); }

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
		// 32-bit integer.
		case I32Add: buildBinOp(wasm.Type.I32, LLVMOpcode.Add); break;
		case I32Sub: buildBinOp(wasm.Type.I32, LLVMOpcode.Sub); break;
		case I32Mul: buildBinOp(wasm.Type.I32, LLVMOpcode.Mul); break;
		case I32DivU: buildBinCall(wasm.Type.I32, fnTeslaI32DivU); break;
		case I32DivS: buildBinCall(wasm.Type.I32, fnTeslaI32DivS); break;
		case I32RemU: buildBinCall(wasm.Type.I32, fnTeslaI32RemU); break;
		case I32RemS: buildBinCall(wasm.Type.I32, fnTeslaI32RemS); break;
		case I32And: buildBinOp(wasm.Type.I32, LLVMOpcode.And); break;
		case I32Or: buildBinOp(wasm.Type.I32, LLVMOpcode.Or); break;
		case I32Xor: buildBinOp(wasm.Type.I32, LLVMOpcode.Xor); break;
		case I32Shl: buildBinOp(wasm.Type.I32, LLVMOpcode.Shl); break;
		case I32ShrU: buildBinOp(wasm.Type.I32, LLVMOpcode.LShr); break;
		case I32ShrS: buildBinOp(wasm.Type.I32, LLVMOpcode.AShr); break;
		case I32Rotl: buildBinCall(wasm.Type.I32, fnTeslaI32Rotl); break;
		case I32Rotr: buildBinCall(wasm.Type.I32, fnTeslaI32Rotr); break;
		case I32Clz: buildUnaryCall(wasm.Type.I32, fnTeslaI32Clz); break;
		case I32Ctz: buildUnaryCall(wasm.Type.I32, fnTeslaI32Ctz); break;
		case I32Popcnt: buildUnaryCall(wasm.Type.I32, fnLLVM_ctpop_i32); break;
		case I32Eq: buildCmp(wasm.Type.I32, LLVMIntPredicate.EQ); break;
		case I32Ne: buildCmp(wasm.Type.I32, LLVMIntPredicate.NE); break;
		case I32LeU: buildCmp(wasm.Type.I32, LLVMIntPredicate.ULE); break;
		case I32LeS: buildCmp(wasm.Type.I32, LLVMIntPredicate.SLE); break;
		case I32LtU: buildCmp(wasm.Type.I32, LLVMIntPredicate.ULT); break;
		case I32LtS: buildCmp(wasm.Type.I32, LLVMIntPredicate.SLT); break;
		case I32GeU: buildCmp(wasm.Type.I32, LLVMIntPredicate.UGE); break;
		case I32GeS: buildCmp(wasm.Type.I32, LLVMIntPredicate.SGE); break;
		case I32GtU: buildCmp(wasm.Type.I32, LLVMIntPredicate.UGT); break;
		case I32GtS: buildCmp(wasm.Type.I32, LLVMIntPredicate.SGT); break;
		case I32Eqz:
			valueStack.push(wasm.Type.I32, LLVMConstInt(typeI32, 0, false));
			buildCmp(wasm.Type.I32, LLVMIntPredicate.EQ);
			break;
		// 64-bit integer.
		case I64Add: buildBinOp(wasm.Type.I64, LLVMOpcode.Add); break;
		case I64Sub: buildBinOp(wasm.Type.I64, LLVMOpcode.Sub); break;
		case I64Mul: buildBinOp(wasm.Type.I64, LLVMOpcode.Mul); break;
		case I64DivU: buildBinCall(wasm.Type.I64, fnTeslaI64DivU); break;
		case I64DivS: buildBinCall(wasm.Type.I64, fnTeslaI64DivS); break;
		case I64RemU: buildBinCall(wasm.Type.I64, fnTeslaI64RemU); break;
		case I64RemS: buildBinCall(wasm.Type.I64, fnTeslaI64RemS); break;
		case I64And: buildBinOp(wasm.Type.I64, LLVMOpcode.And); break;
		case I64Or: buildBinOp(wasm.Type.I64, LLVMOpcode.Or); break;
		case I64Xor: buildBinOp(wasm.Type.I64, LLVMOpcode.Xor); break;
		case I64Shl: buildBinOp(wasm.Type.I64, LLVMOpcode.Shl); break;
		case I64ShrU: buildBinOp(wasm.Type.I64, LLVMOpcode.LShr); break;
		case I64ShrS: buildBinOp(wasm.Type.I64, LLVMOpcode.AShr); break;
		case I64Rotl: buildBinCall(wasm.Type.I64, fnTeslaI64Rotl); break;
		case I64Rotr: buildBinCall(wasm.Type.I64, fnTeslaI64Rotr); break;
		case I64Clz: buildUnaryCall(wasm.Type.I64, fnTeslaI64Clz); break;
		case I64Ctz: buildUnaryCall(wasm.Type.I64, fnTeslaI64Ctz); break;
		case I64Popcnt: buildUnaryCall(wasm.Type.I64, fnLLVM_ctpop_i64); break;
		case I64Eq: buildCmp(wasm.Type.I64, LLVMIntPredicate.EQ); break;
		case I64Ne: buildCmp(wasm.Type.I64, LLVMIntPredicate.NE); break;
		case I64LeU: buildCmp(wasm.Type.I64, LLVMIntPredicate.ULE); break;
		case I64LeS: buildCmp(wasm.Type.I64, LLVMIntPredicate.SLE); break;
		case I64LtU: buildCmp(wasm.Type.I64, LLVMIntPredicate.ULT); break;
		case I64LtS: buildCmp(wasm.Type.I64, LLVMIntPredicate.SLT); break;
		case I64GeU: buildCmp(wasm.Type.I64, LLVMIntPredicate.UGE); break;
		case I64GeS: buildCmp(wasm.Type.I64, LLVMIntPredicate.SGE); break;
		case I64GtU: buildCmp(wasm.Type.I64, LLVMIntPredicate.UGT); break;
		case I64GtS: buildCmp(wasm.Type.I64, LLVMIntPredicate.SGT); break;
		case I64Eqz:
			valueStack.push(wasm.Type.I64, LLVMConstInt(typeI64, 0, false));
			buildCmp(wasm.Type.I64, LLVMIntPredicate.EQ);
			break;
		case I32WrapI64: buildBitCast(wasm.Type.I64, wasm.Type.I32, typeI32); break;
//		case I32TruncSF32: traps
//		case I32TruncUF32: traps
//		case I32TruncSF64: traps
//		case I32TruncUF64: traps
		case I64ExtendSI32: buildCast(wasm.Type.I32, wasm.Type.I64, typeI64, LLVMOpcode.SExt); break;
		case I64ExtendUI32: buildCast(wasm.Type.I32, wasm.Type.I64, typeI64, LLVMOpcode.ZExt); break;
//		case I64TruncSF32: traps
//		case I64TruncUF32: traps
//		case I64TruncSF64: traps
//		case I64TruncUF64: traps
		case F32ConvertSI32: buildCast(wasm.Type.I32, wasm.Type.F32, typeF32, LLVMOpcode.SIToFP); break;
		case F32ConvertUI32: buildCast(wasm.Type.I32, wasm.Type.F32, typeF32, LLVMOpcode.UIToFP); break;
		case F32ConvertSI64: buildCast(wasm.Type.I64, wasm.Type.F32, typeF32, LLVMOpcode.SIToFP); break;
		case F32ConvertUI64: buildCast(wasm.Type.I64, wasm.Type.F32, typeF32, LLVMOpcode.UIToFP); break;
//		case F32DemoteF64: traps
		case F64ConvertSI32: buildCast(wasm.Type.I32, wasm.Type.F64, typeF64, LLVMOpcode.SIToFP); break;
		case F64ConvertUI32: buildCast(wasm.Type.I32, wasm.Type.F64, typeF64, LLVMOpcode.UIToFP); break;
		case F64ConvertSI64: buildCast(wasm.Type.I64, wasm.Type.F64, typeF64, LLVMOpcode.SIToFP); break;
		case F64ConvertUI64: buildCast(wasm.Type.I64, wasm.Type.F64, typeF64, LLVMOpcode.UIToFP); break;
		case F64PromoteF32: buildCast(wasm.Type.F32, wasm.Type.F64, typeF64, LLVMOpcode.FPExt); break;
		case I32ReinterpretF32: buildBitCast(wasm.Type.F32, wasm.Type.I32, typeI32); break;
		case I64ReinterpretF64: buildBitCast(wasm.Type.F64, wasm.Type.I64, typeI64); break;
		case F32ReinterpretI32: buildBitCast(wasm.Type.I32, wasm.Type.F32, typeF32); break;
		case F64ReinterpretI64: buildBitCast(wasm.Type.I64, wasm.Type.F64, typeF64); break;
		case Select:
			c := valueStack.pop(wasm.Type.I32);
			t := valueStack.topType();
			l := valueStack.pop(t);
			r := valueStack.pop(t);
			v := LLVMBuildSelect(builder, c, l, r, "");
			valueStack.push(t, v);
			break;
		default:
			unhandledOp(op, "generic");
		}
	}

	override fn onOpMemory(op: wasm.Opcode, flags: u32, offset: u32)
	{
		//io.writefln("%s", wasm.opToString(op));

		ensureBlock(op);

		switch (op) with (wasm.Opcode) {
		case I32Load:    buildLoad(wasm.Type.I32,  fnTeslaI32Load,    offset); break;
		case I64Load:    buildLoad(wasm.Type.I64,  fnTeslaI64Load,    offset); break;
		case F32Load:    buildLoad(wasm.Type.F32,  fnTeslaF32Load,    offset); break;
		case F64Load:    buildLoad(wasm.Type.F64,  fnTeslaF64Load,    offset); break;
		case I32Load8S:  buildLoad(wasm.Type.I32,  fnTeslaI32Load8S,  offset); break;
		case I32Load8U:  buildLoad(wasm.Type.I32,  fnTeslaI32Load8U,  offset); break;
		case I32Load16S: buildLoad(wasm.Type.I32,  fnTeslaI32Load16S, offset); break;
		case I32Load16U: buildLoad(wasm.Type.I32,  fnTeslaI32Load16U, offset); break;
		case I64Load8S:  buildLoad(wasm.Type.I64,  fnTeslaI64Load8S,  offset); break;
		case I64Load8U:  buildLoad(wasm.Type.I64,  fnTeslaI64Load8U,  offset); break;
		case I64Load16S: buildLoad(wasm.Type.I64,  fnTeslaI64Load16S, offset); break;
		case I64Load16U: buildLoad(wasm.Type.I64,  fnTeslaI64Load16U, offset); break;
		case I64Load32S: buildLoad(wasm.Type.I64,  fnTeslaI64Load32S, offset); break;
		case I64Load32U: buildLoad(wasm.Type.I64,  fnTeslaI64Load32U, offset); break;
		case I32Store:   buildStore(wasm.Type.I32, fnTeslaI32Store,   offset); break;
		case I64Store:   buildStore(wasm.Type.I64, fnTeslaI64Store,   offset); break;
		case F32Store:   buildStore(wasm.Type.F32, fnTeslaF32Store,   offset); break;
		case F64Store:   buildStore(wasm.Type.F64, fnTeslaF64Store,   offset); break;
		case I32Store8:  buildStore(wasm.Type.I32, fnTeslaI32Store8,  offset); break;
		case I32Store16: buildStore(wasm.Type.I32, fnTeslaI32Store16, offset); break;
		case I64Store8:  buildStore(wasm.Type.I64, fnTeslaI64Store8,  offset); break;
		case I64Store16: buildStore(wasm.Type.I64, fnTeslaI64Store16, offset); break;
		case I64Store32: buildStore(wasm.Type.I64, fnTeslaI64Store32, offset); break;
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
			if (!g.isPointer) {
				str := format("global '%s' is not a valid readable global", index);
				onError(str);
				break;
			}

			g := globals[index];
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
			if (!g.isPointer) {
				str := format("global '%s' is not a valid readable global", index);
				onError(str);
				break;
			}

			g := globals[index];
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

	fn buildCmp(t: wasm.Type, p: LLVMIntPredicate)
	{
		r := valueStack.pop(t);
		l := valueStack.pop(t);
		v := LLVMBuildICmp(builder, p, l, r, "");
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
		mTs[mNum] = T.init;
		return v;
	}

	fn pop() T
	{
		checkAndPop();
		ret := mTs[mNum];
		mTs[mNum] = T.init;
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
			poly.onError("stack type missmatch", loc);
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
			poly.onError("stack type missmatch", loc);
		}
	}
}
