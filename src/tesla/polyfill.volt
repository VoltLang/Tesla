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

	valueStack: ValueStack;
	blockStack: BlockStack;
	currentFunc: Func;
	currentBlock: LLVMBasicBlockRef;
	currentLocals: LLVMValueRef[];
	currentLocalTypes: wasm.Type[];


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
		return onError("can't import global");
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
	 * Misc.
	 *
	 */

	override fn onReadError(err: string)
	{
		onError(format("read error \"%s\"", err));
	}

	fn onError(err: string)
	{
		io.output.writefln("%s", printToString());
		io.output.flush();
		str := format("Error: %s", err);
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
		//io.writefln("%s", wasm.opToString(wasm.Opcode.I32Const));

		ensureBlock(wasm.Opcode.I32Const);

		llvmType := toLLVMFromValueType(wasm.Type.I32);
		llvmValue := LLVMConstInt(llvmType, cast(u64)v, false);
		valueStack.push(wasm.Type.I32, llvmValue);
	}

	override fn onOpI64Const(v: i64) { onError("I64Const"); }
	override fn onOpF32Const(v: f32) { onError("F32Const"); }
	override fn onOpF64Const(v: f64) { onError("F64Const"); }

	override fn onControl(op: wasm.Opcode, t: wasm.Type)
	{
		//io.writefln("%s", wasm.opToString(op));

		if (t != wasm.Type.Void) {
			return onError("can not handle control with return type");
		}

		switch (op) with (wasm.Opcode) {
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
			foreach (i, a; ft.argTypes) {
				args[--c] = valueStack.pop(a);
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
		case I32LtS: buildCmp(wasm.Type.I32, LLVMIntPredicate.SLT); break;
		case I32GeU: buildCmp(wasm.Type.I32, LLVMIntPredicate.UGE); break;
		case I32Add: buildBinOp(wasm.Type.I32, LLVMOpcode.Add); break;
		case I32Sub: buildBinOp(wasm.Type.I32, LLVMOpcode.Sub); break;
		case I32Mul: buildBinOp(wasm.Type.I32, LLVMOpcode.Mul); break;
		case I32And: buildBinOp(wasm.Type.I32, LLVMOpcode.And); break;
		case I32Or: buildBinOp(wasm.Type.I32, LLVMOpcode.Or); break;
		case I32Xor: buildBinOp(wasm.Type.I32, LLVMOpcode.Xor); break;
		default:
			unhandledOp(op, "generic");
		}
	}

	override fn onOpMemory(op: wasm.Opcode, flags: u32, offset: u32)
	{
		//io.writefln("%s", wasm.opToString(op));

		ensureBlock(op);

		switch (op) with (wasm.Opcode) {
		case I32Load8U:  buildLoad(wasm.Type.I32,  typeI8, false, offset); break;
		case I32Load8S:  buildLoad(wasm.Type.I32,  typeI8,  true, offset); break;
		case I32Load16U: buildLoad(wasm.Type.I32, typeI16, false, offset); break;
		case I32Load16S: buildLoad(wasm.Type.I32, typeI16,  true, offset); break;
		case I32Load:    buildLoad(wasm.Type.I32, typeI32, false, offset); break;
		case I64Load8U:  buildLoad(wasm.Type.I64,  typeI8, false, offset); break;
		case I64Load8S:  buildLoad(wasm.Type.I64,  typeI8,  true, offset); break;
		case I64Load16U: buildLoad(wasm.Type.I64, typeI16, false, offset); break;
		case I64Load16S: buildLoad(wasm.Type.I64, typeI16,  true, offset); break;
		case I64Load32U: buildLoad(wasm.Type.I64, typeI32, false, offset); break;
		case I64Load32S: buildLoad(wasm.Type.I64, typeI32,  true, offset); break;
		case I64Load:    buildLoad(wasm.Type.I64, typeI64, false, offset); break;
		case I32Store: buildStore(wasm.Type.I32, typeI32, offset); break;
		case I64Store: buildStore(wasm.Type.I64, typeI64, offset); break;
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
		valueStack.push(t, v);
	}

	fn buildBinOp(t: wasm.Type, op: LLVMOpcode)
	{
		r := valueStack.pop(t);
		l := valueStack.pop(t);
		v := LLVMBuildBinOp(builder, op, l, r, "");
		valueStack.push(t, v);
	}

	fn buildLoad(t: wasm.Type, srcBaseType: LLVMTypeRef, signed: bool, offset: u32)
	{
		toType := toLLVMFromValueType(t);
		ptrType := LLVMPointerType(srcBaseType, 0);

		ptr := valueStack.pop(wasm.Type.I32);
		if (offset != 0) {
			ptr = LLVMBuildBinOp(builder, LLVMOpcode.Add,
				LLVMConstInt(typeI32, offset, false), ptr, "");
		}
		ptr = LLVMBuildBitCast(builder, ptr, ptrType, "");

		v := LLVMBuildLoad(builder, ptr, "");

		if (signed) {
			v = LLVMBuildSExtOrBitCast(builder, v, toType, "");
		} else {
			v = LLVMBuildZExtOrBitCast(builder, v, toType, "");
		}

		valueStack.push(t, v);
	}

	fn buildStore(t: wasm.Type, baseType: LLVMTypeRef, offset: u32)
	{
		ptrType := LLVMPointerType(baseType, 0);

		v := valueStack.pop(t);
		ptr := valueStack.pop(wasm.Type.I32);
		if (offset != 0) {
			ptr = LLVMBuildBinOp(builder, LLVMOpcode.Add,
				LLVMConstInt(typeI32, offset, false), ptr, "");
		}
		v = LLVMBuildBitCast(builder, v, baseType, "");
		ptr = LLVMBuildBitCast(builder, ptr, ptrType, "");

		LLVMBuildStore(builder, v, ptr);
	}


	/*
	 *
	 * Various error checking functions.
	 *
	 */

	fn unhandledOp(op: wasm.Opcode, kind: string)
	{
		str := format("unhandled %s opcode '%s'", kind, wasm.opToString(op));
		onError(str);
	}

	fn ensureNotImportFuncIndex(index: u32, kind: string)
	{	
		if (index >= numFuncImports) {
			return;
		}

		str := format("can not reference import function in %s", kind);
		onError(str);
	}

	fn ensureValidFuncIndex(index: u32, kind: string)
	{
		if (index < funcs.length) {
			return;
		}

		str := format("invalid function index for %s", kind);
		onError(str);
	}

	fn ensureValidFuncTypeIndex(index: u32, kind: string)
	{
		if (index < funcTypes.length) {
			return;
		}

		str := format("invalid function type index for %s", kind);
		onError(str);
	}

	fn ensureSectionOrder(id: wasm.Section)
	{
		if (id > lastSection) {
			return;
		}
		str := format("section '%s' can not come before section '%s'",
			wasm.sectionToString(id), wasm.sectionToString(lastSection));
		onError(str);
	}

	fn ensureOneEntry(count: u32, section: string)
	{
		if (count == 1) {
			return;
		}

		str := format("%s section may only have one entry", section);
		onError(str);
	}

	fn ensureTypeSection(section: string)
	{	
		if (hasProccessedType) {
			return;
		}

		str := format("%s section requires types section", section);
		onError(str);
	}

	fn ensureValidLocalIndex(index: u32)
	{
		if (index < currentLocals.length) {
			return;
		}

		onError("local index out of bounds");
	}

	fn ensureBlock(op: wasm.Opcode)
	{
		if (currentBlock !is null) {
			return;
		}

		str := format("opcode is unreachable '%s'", wasm.opToString(op));
		onError(str);
	}

	fn ensureTerminated(op: wasm.Opcode)
	{
		if (currentBlock is null) {
			return;
		}

		str := format("'%s' block does not have a terminating opcode", wasm.opToString(op));
		onError(str);
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

	fn pop(t: wasm.Type) T
	{
		checkTypeAndPop(t);
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

	fn getRelative(index: u32, out t: wasm.Type, out v: T)
	{
		index++;
		if (mNum < index) {
			poly.onError("stack under run");
		}
		t = mTypes[mNum-index];
		v = mTs[mNum-index];
	}

	fn checkTop(t: wasm.Type) T
	{
		if (mNum < 1) {
			poly.onError("stack under run");
		}
		if (mTypes[mNum-1] != t) {
			poly.onError("stack type missmatch");
		}
		return mTs[mNum-1];
	}

	fn checkPush()
	{
		if (mNum >= Max) {
			poly.onError("stack to large");
		}
	}

	fn checkAndPop()
	{
		if (mNum == 0) {
			poly.onError("stack under run");
		}	
		mNum--;
	}

	fn checkTypeAndPop(t: wasm.Type)
	{
		checkAndPop();
		if (mTypes[mNum] != t) {
			poly.onError("stack type missmatch");
		}
	}
}
