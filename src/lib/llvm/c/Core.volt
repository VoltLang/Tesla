// SPDX-FileCopyrightText: 2007-2026, LLVM Developers.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

module lib.llvm.c.Core;

public import lib.llvm.c.Types;


enum LLVMAttributeIndex : uint {
	Return = 0U,
	Function = cast(uint)-1,
}


alias LLVMDiagnosticHandler = extern(C) fn(LLVMDiagnosticInfoRef, void*);
alias LLVMYieldCallback = extern(C) fn(LLVMContextRef, void*);


extern(C):

//#--- Auto generated below ---#
enum LLVMAtomicOrdering {
	NotAtomic = 0,
	Unordered = 1,
	Monotonic = 2,
	Acquire = 4,
	Release = 5,
	AcquireRelease = 6,
	SequentiallyConsistent = 7,
}
enum LLVMDLLStorageClass {
	Default = 0,
	DLLImport = 1,
	DLLExport = 2,
}
enum LLVMDiagnosticSeverity {
	Error = 0,
	Warning = 1,
	Remark = 2,
	Note = 3,
}
enum LLVMInlineAsmDialect {
	ATT = 0,
	Intel = 1,
}
enum LLVMIntPredicate {
	EQ = 32,
	NE = 33,
	UGT = 34,
	UGE = 35,
	ULT = 36,
	ULE = 37,
	SGT = 38,
	SGE = 39,
	SLT = 40,
	SLE = 41,
}
enum LLVMLinkage {
	External = 0,
	AvailableExternally = 1,
	LinkOnceAny = 2,
	LinkOnceODR = 3,
	LinkOnceODRAutoHide = 4,
	WeakAny = 5,
	WeakODR = 6,
	Appending = 7,
	Internal = 8,
	Private = 9,
	DLLImport = 10,
	DLLExport = 11,
	ExternalWeak = 12,
	Ghost = 13,
	Common = 14,
	LinkerPrivate = 15,
	LinkerPrivateWeak = 16,
}
enum LLVMModuleFlagBehavior {
	Error = 0,
	Warning = 1,
	Require = 2,
	Override = 3,
	Append = 4,
	AppendUnique = 5,
}
enum LLVMOpcode {
	Ret = 1,
	Br = 2,
	Switch = 3,
	IndirectBr = 4,
	Invoke = 5,
	Unreachable = 7,
	CallBr = 67,
	FNeg = 66,
	Add = 8,
	FAdd = 9,
	Sub = 10,
	FSub = 11,
	Mul = 12,
	FMul = 13,
	UDiv = 14,
	SDiv = 15,
	FDiv = 16,
	URem = 17,
	SRem = 18,
	FRem = 19,
	Shl = 20,
	LShr = 21,
	AShr = 22,
	And = 23,
	Or = 24,
	Xor = 25,
	Alloca = 26,
	Load = 27,
	Store = 28,
	GetElementPtr = 29,
	Trunc = 30,
	ZExt = 31,
	SExt = 32,
	FPToUI = 33,
	FPToSI = 34,
	UIToFP = 35,
	SIToFP = 36,
	FPTrunc = 37,
	FPExt = 38,
	PtrToInt = 39,
	IntToPtr = 40,
	BitCast = 41,
	AddrSpaceCast = 60,
	ICmp = 42,
	FCmp = 43,
	PHI = 44,
	Call = 45,
	Select = 46,
	UserOp1 = 47,
	UserOp2 = 48,
	VAArg = 49,
	ExtractElement = 50,
	InsertElement = 51,
	ShuffleVector = 52,
	ExtractValue = 53,
	InsertValue = 54,
	Freeze = 68,
	Fence = 55,
	AtomicCmpXchg = 56,
	AtomicRMW = 57,
	Resume = 58,
	LandingPad = 59,
	CleanupRet = 61,
	CatchRet = 62,
	CatchPad = 63,
	CleanupPad = 64,
	CatchSwitch = 65,
}
enum LLVMRealPredicate {
	PredicateFalse = 0,
	OEQ = 1,
	OGT = 2,
	OGE = 3,
	OLT = 4,
	OLE = 5,
	ONE = 6,
	ORD = 7,
	UNO = 8,
	UEQ = 9,
	UGT = 10,
	UGE = 11,
	ULT = 12,
	ULE = 13,
	UNE = 14,
	PredicateTrue = 15,
}
enum LLVMThreadLocalMode {
	Not = 0,
	GeneralDynamicTLSModel = 1,
	LocalDynamicTLSModel = 2,
	InitialExecTLSModel = 3,
	LocalExecTLSModel = 4,
}
enum LLVMUnnamedAddr {
	NoUnnamed = 0,
	LocalUnnamed = 1,
	GlobalUnnamed = 2,
}
enum LLVMVisibility {
	Default = 0,
	Hidden = 1,
	Protected = 2,
}
version(LLVMVersion20AndAbove) {
	enum LLVMTypeKind {
		Void = 0,
		Half = 1,
		Float = 2,
		Double = 3,
		X86_FP80 = 4,
		FP128 = 5,
		PPC_FP128 = 6,
		Label = 7,
		Integer = 8,
		Function = 9,
		Struct = 10,
		Array = 11,
		Pointer = 12,
		Vector = 13,
		Metadata = 14,
		Token = 16,
		ScalableVector = 17,
		BFloat = 18,
		X86_AMX = 19,
		TargetExt = 20,
	}
} else version(LLVMVersion16AndAbove) {
	enum LLVMTypeKind {
		Void = 0,
		Half = 1,
		Float = 2,
		Double = 3,
		X86_FP80 = 4,
		FP128 = 5,
		PPC_FP128 = 6,
		Label = 7,
		Integer = 8,
		Function = 9,
		Struct = 10,
		Array = 11,
		Pointer = 12,
		Vector = 13,
		Metadata = 14,
		X86_MMX = 15,
		Token = 16,
		ScalableVector = 17,
		BFloat = 18,
		X86_AMX = 19,
		TargetExt = 20,
	}
} else version(LLVMVersion12AndAbove) {
	enum LLVMTypeKind {
		Void = 0,
		Half = 1,
		Float = 2,
		Double = 3,
		X86_FP80 = 4,
		FP128 = 5,
		PPC_FP128 = 6,
		Label = 7,
		Integer = 8,
		Function = 9,
		Struct = 10,
		Array = 11,
		Pointer = 12,
		Vector = 13,
		Metadata = 14,
		X86_MMX = 15,
		Token = 16,
		ScalableVector = 17,
		BFloat = 18,
		X86_AMX = 19,
	}
} else version(LLVMVersion11AndAbove) {
	enum LLVMTypeKind {
		Void = 0,
		Half = 1,
		Float = 2,
		Double = 3,
		X86_FP80 = 4,
		FP128 = 5,
		PPC_FP128 = 6,
		Label = 7,
		Integer = 8,
		Function = 9,
		Struct = 10,
		Array = 11,
		Pointer = 12,
		Vector = 13,
		Metadata = 14,
		X86_MMX = 15,
		Token = 16,
		ScalableVector = 17,
		BFloat = 18,
	}
} else {
	enum LLVMTypeKind {
		Void = 0,
		Half = 1,
		Float = 2,
		Double = 3,
		X86_FP80 = 4,
		FP128 = 5,
		PPC_FP128 = 6,
		Label = 7,
		Integer = 8,
		Function = 9,
		Struct = 10,
		Array = 11,
		Pointer = 12,
		Vector = 13,
		Metadata = 14,
		X86_MMX = 15,
		Token = 16,
	}
}
version(LLVMVersion19AndAbove) {
	enum LLVMValueKind {
		Argument = 0,
		BasicBlock = 1,
		MemoryUse = 2,
		MemoryDef = 3,
		MemoryPhi = 4,
		Function = 5,
		GlobalAlias = 6,
		GlobalIFunc = 7,
		GlobalVariable = 8,
		BlockAddress = 9,
		ConstantExpr = 10,
		ConstantArray = 11,
		ConstantStruct = 12,
		ConstantVector = 13,
		UndefValue = 14,
		ConstantAggregateZero = 15,
		ConstantDataArray = 16,
		ConstantDataVector = 17,
		ConstantInt = 18,
		ConstantFP = 19,
		ConstantPointerNull = 20,
		ConstantTokenNone = 21,
		MetadataAsValue = 22,
		InlineAsm = 23,
		Instruction = 24,
		PoisonValue = 25,
		ConstantTargetNone = 26,
		ConstantPtrAuth = 27,
	}
} else version(LLVMVersion16AndAbove) {
	enum LLVMValueKind {
		Argument = 0,
		BasicBlock = 1,
		MemoryUse = 2,
		MemoryDef = 3,
		MemoryPhi = 4,
		Function = 5,
		GlobalAlias = 6,
		GlobalIFunc = 7,
		GlobalVariable = 8,
		BlockAddress = 9,
		ConstantExpr = 10,
		ConstantArray = 11,
		ConstantStruct = 12,
		ConstantVector = 13,
		UndefValue = 14,
		ConstantAggregateZero = 15,
		ConstantDataArray = 16,
		ConstantDataVector = 17,
		ConstantInt = 18,
		ConstantFP = 19,
		ConstantPointerNull = 20,
		ConstantTokenNone = 21,
		MetadataAsValue = 22,
		InlineAsm = 23,
		Instruction = 24,
		PoisonValue = 25,
		ConstantTargetNone = 26,
	}
} else version(LLVMVersion12AndAbove) {
	enum LLVMValueKind {
		Argument = 0,
		BasicBlock = 1,
		MemoryUse = 2,
		MemoryDef = 3,
		MemoryPhi = 4,
		Function = 5,
		GlobalAlias = 6,
		GlobalIFunc = 7,
		GlobalVariable = 8,
		BlockAddress = 9,
		ConstantExpr = 10,
		ConstantArray = 11,
		ConstantStruct = 12,
		ConstantVector = 13,
		UndefValue = 14,
		ConstantAggregateZero = 15,
		ConstantDataArray = 16,
		ConstantDataVector = 17,
		ConstantInt = 18,
		ConstantFP = 19,
		ConstantPointerNull = 20,
		ConstantTokenNone = 21,
		MetadataAsValue = 22,
		InlineAsm = 23,
		Instruction = 24,
		PoisonValue = 25,
	}
} else {
	enum LLVMValueKind {
		Argument = 0,
		BasicBlock = 1,
		MemoryUse = 2,
		MemoryDef = 3,
		MemoryPhi = 4,
		Function = 5,
		GlobalAlias = 6,
		GlobalIFunc = 7,
		GlobalVariable = 8,
		BlockAddress = 9,
		ConstantExpr = 10,
		ConstantArray = 11,
		ConstantStruct = 12,
		ConstantVector = 13,
		UndefValue = 14,
		ConstantAggregateZero = 15,
		ConstantDataArray = 16,
		ConstantDataVector = 17,
		ConstantInt = 18,
		ConstantFP = 19,
		ConstantPointerNull = 20,
		ConstantTokenNone = 21,
		MetadataAsValue = 22,
		InlineAsm = 23,
		Instruction = 24,
	}
}
version(LLVMVersion21AndAbove) {
	enum LLVMAtomicRMWBinOp {
		Xchg = 0,
		Add = 1,
		Sub = 2,
		And = 3,
		Nand = 4,
		Or = 5,
		Xor = 6,
		Max = 7,
		Min = 8,
		UMax = 9,
		UMin = 10,
		FAdd = 11,
		FSub = 12,
		FMax = 13,
		FMin = 14,
		UIncWrap = 15,
		UDecWrap = 16,
		USubCond = 17,
		USubSat = 18,
		FMaximum = 19,
		FMinimum = 20,
	}
} else version(LLVMVersion20AndAbove) {
	enum LLVMAtomicRMWBinOp {
		Xchg = 0,
		Add = 1,
		Sub = 2,
		And = 3,
		Nand = 4,
		Or = 5,
		Xor = 6,
		Max = 7,
		Min = 8,
		UMax = 9,
		UMin = 10,
		FAdd = 11,
		FSub = 12,
		FMax = 13,
		FMin = 14,
		UIncWrap = 15,
		UDecWrap = 16,
		USubCond = 17,
		USubSat = 18,
	}
} else version(LLVMVersion19AndAbove) {
	enum LLVMAtomicRMWBinOp {
		Xchg = 0,
		Add = 1,
		Sub = 2,
		And = 3,
		Nand = 4,
		Or = 5,
		Xor = 6,
		Max = 7,
		Min = 8,
		UMax = 9,
		UMin = 10,
		FAdd = 11,
		FSub = 12,
		FMax = 13,
		FMin = 14,
		UIncWrap = 15,
		UDecWrap = 16,
	}
} else version(LLVMVersion15AndAbove) {
	enum LLVMAtomicRMWBinOp {
		Xchg = 0,
		Add = 1,
		Sub = 2,
		And = 3,
		Nand = 4,
		Or = 5,
		Xor = 6,
		Max = 7,
		Min = 8,
		UMax = 9,
		UMin = 10,
		FAdd = 11,
		FSub = 12,
		FMax = 13,
		FMin = 14,
	}
} else {
	enum LLVMAtomicRMWBinOp {
		Xchg = 0,
		Add = 1,
		Sub = 2,
		And = 3,
		Nand = 4,
		Or = 5,
		Xor = 6,
		Max = 7,
		Min = 8,
		UMax = 9,
		UMin = 10,
		FAdd = 11,
		FSub = 12,
	}
}
version(LLVMVersion18AndAbove) {
	enum LLVMCallConv {
		C = 0,
		Fast = 8,
		Cold = 9,
		GHC = 10,
		HiPE = 11,
		AnyReg = 13,
		PreserveMost = 14,
		PreserveAll = 15,
		Swift = 16,
		CXXFASTTLS = 17,
		X86Stdcall = 64,
		X86Fastcall = 65,
		ARMAPCS = 66,
		ARMAAPCS = 67,
		ARMAAPCSVFP = 68,
		MSP430INTR = 69,
		X86ThisCall = 70,
		PTXKernel = 71,
		PTXDevice = 72,
		SPIRFUNC = 75,
		SPIRKERNEL = 76,
		IntelOCLBI = 77,
		X8664SysV = 78,
		Win64 = 79,
		X86VectorCall = 80,
		HHVM = 81,
		HHVMC = 82,
		X86INTR = 83,
		AVRINTR = 84,
		AVRSIGNAL = 85,
		AVRBUILTIN = 86,
		AMDGPUVS = 87,
		AMDGPUGS = 88,
		AMDGPUPS = 89,
		AMDGPUCS = 90,
		AMDGPUKERNEL = 91,
		X86RegCall = 92,
		AMDGPUHS = 93,
		MSP430BUILTIN = 94,
		AMDGPULS = 95,
		AMDGPUES = 96,
	}
} else {
	enum LLVMCallConv {
		C = 0,
		Fast = 8,
		Cold = 9,
		GHC = 10,
		HiPE = 11,
		WebKitJS = 12,
		AnyReg = 13,
		PreserveMost = 14,
		PreserveAll = 15,
		Swift = 16,
		CXXFASTTLS = 17,
		X86Stdcall = 64,
		X86Fastcall = 65,
		ARMAPCS = 66,
		ARMAAPCS = 67,
		ARMAAPCSVFP = 68,
		MSP430INTR = 69,
		X86ThisCall = 70,
		PTXKernel = 71,
		PTXDevice = 72,
		SPIRFUNC = 75,
		SPIRKERNEL = 76,
		IntelOCLBI = 77,
		X8664SysV = 78,
		Win64 = 79,
		X86VectorCall = 80,
		HHVM = 81,
		HHVMC = 82,
		X86INTR = 83,
		AVRINTR = 84,
		AVRSIGNAL = 85,
		AVRBUILTIN = 86,
		AMDGPUVS = 87,
		AMDGPUGS = 88,
		AMDGPUPS = 89,
		AMDGPUCS = 90,
		AMDGPUKERNEL = 91,
		X86RegCall = 92,
		AMDGPUHS = 93,
		MSP430BUILTIN = 94,
		AMDGPULS = 95,
		AMDGPUES = 96,
	}
}
version(!LLVMVersion21AndAbove) {
	enum LLVMLandingPadClauseTy {
		Catch = 0,
		Filter = 1,
	}
}
version(LLVMVersion18AndAbove) {
	enum LLVMTailCallKind {
		None = 0,
		Tail = 1,
		MustTail = 2,
		NoTail = 3,
	}
}
fn LLVMAddAttributeAtIndex(F: LLVMValueRef, Idx: LLVMAttributeIndex, A: LLVMAttributeRef);
fn LLVMAddCallSiteAttribute(C: LLVMValueRef, Idx: LLVMAttributeIndex, A: LLVMAttributeRef);
fn LLVMAddCase(Switch: LLVMValueRef, OnVal: LLVMValueRef, Dest: LLVMBasicBlockRef);
fn LLVMAddClause(LandingPad: LLVMValueRef, ClauseVal: LLVMValueRef);
fn LLVMAddDestination(IndirectBr: LLVMValueRef, Dest: LLVMBasicBlockRef);
fn LLVMAddFunction(M: LLVMModuleRef, Name: const(char)*, FunctionTy: LLVMTypeRef) LLVMValueRef;
fn LLVMAddGlobal(M: LLVMModuleRef, Ty: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMAddGlobalIFunc(M: LLVMModuleRef, Name: const(char)*, NameLen: size_t, Ty: LLVMTypeRef, AddrSpace: u32, Resolver: LLVMValueRef) LLVMValueRef;
fn LLVMAddGlobalInAddressSpace(M: LLVMModuleRef, Ty: LLVMTypeRef, Name: const(char)*, AddressSpace: u32) LLVMValueRef;
fn LLVMAddHandler(CatchSwitch: LLVMValueRef, Dest: LLVMBasicBlockRef);
fn LLVMAddIncoming(PhiNode: LLVMValueRef, IncomingValues: LLVMValueRef*, IncomingBlocks: LLVMBasicBlockRef*, Count: u32);
fn LLVMAddModuleFlag(M: LLVMModuleRef, Behavior: LLVMModuleFlagBehavior, Key: const(char)*, KeyLen: size_t, Val: LLVMMetadataRef);
fn LLVMAddNamedMetadataOperand(M: LLVMModuleRef, Name: const(char)*, Val: LLVMValueRef);
fn LLVMAddTargetDependentFunctionAttr(Fn: LLVMValueRef, A: const(char)*, V: const(char)*);
fn LLVMAliasGetAliasee(Alias: LLVMValueRef) LLVMValueRef;
fn LLVMAliasSetAliasee(Alias: LLVMValueRef, Aliasee: LLVMValueRef);
fn LLVMAlignOf(Ty: LLVMTypeRef) LLVMValueRef;
fn LLVMAppendBasicBlock(Fn: LLVMValueRef, Name: const(char)*) LLVMBasicBlockRef;
fn LLVMAppendBasicBlockInContext(C: LLVMContextRef, Fn: LLVMValueRef, Name: const(char)*) LLVMBasicBlockRef;
fn LLVMAppendExistingBasicBlock(Fn: LLVMValueRef, BB: LLVMBasicBlockRef);
fn LLVMAppendModuleInlineAsm(M: LLVMModuleRef, Asm: const(char)*, Len: size_t);
fn LLVMArrayType(ElementType: LLVMTypeRef, ElementCount: u32) LLVMTypeRef;
fn LLVMBasicBlockAsValue(BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBlockAddress(F: LLVMValueRef, BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBuildAShr(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildAdd(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildAddrSpaceCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildAggregateRet(LLVMBuilderRef, RetVals: LLVMValueRef*, N: u32) LLVMValueRef;
fn LLVMBuildAlloca(LLVMBuilderRef, Ty: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildAnd(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildArrayAlloca(LLVMBuilderRef, Ty: LLVMTypeRef, Val: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildArrayMalloc(LLVMBuilderRef, Ty: LLVMTypeRef, Val: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildAtomicCmpXchg(B: LLVMBuilderRef, Ptr: LLVMValueRef, Cmp: LLVMValueRef, New: LLVMValueRef, SuccessOrdering: LLVMAtomicOrdering, FailureOrdering: LLVMAtomicOrdering, SingleThread: LLVMBool) LLVMValueRef;
fn LLVMBuildAtomicRMW(B: LLVMBuilderRef, op: LLVMAtomicRMWBinOp, PTR: LLVMValueRef, Val: LLVMValueRef, ordering: LLVMAtomicOrdering, singleThread: LLVMBool) LLVMValueRef;
fn LLVMBuildBinOp(B: LLVMBuilderRef, Op: LLVMOpcode, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildBitCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildBr(LLVMBuilderRef, Dest: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBuildCall2(LLVMBuilderRef, LLVMTypeRef, Fn: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildCast(B: LLVMBuilderRef, Op: LLVMOpcode, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildCatchPad(B: LLVMBuilderRef, ParentPad: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildCatchRet(B: LLVMBuilderRef, CatchPad: LLVMValueRef, BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBuildCatchSwitch(B: LLVMBuilderRef, ParentPad: LLVMValueRef, UnwindBB: LLVMBasicBlockRef, NumHandlers: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildCleanupPad(B: LLVMBuilderRef, ParentPad: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildCleanupRet(B: LLVMBuilderRef, CatchPad: LLVMValueRef, BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBuildCondBr(LLVMBuilderRef, If: LLVMValueRef, Then: LLVMBasicBlockRef, Else: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBuildExactSDiv(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildExactUDiv(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildExtractElement(LLVMBuilderRef, VecVal: LLVMValueRef, Index: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildExtractValue(LLVMBuilderRef, AggVal: LLVMValueRef, Index: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFAdd(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFCmp(LLVMBuilderRef, Op: LLVMRealPredicate, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFDiv(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFMul(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFNeg(LLVMBuilderRef, V: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFPCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFPExt(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFPToSI(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFPToUI(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFPTrunc(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFRem(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFSub(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFence(B: LLVMBuilderRef, ordering: LLVMAtomicOrdering, singleThread: LLVMBool, Name: const(char)*) LLVMValueRef;
fn LLVMBuildFree(LLVMBuilderRef, PointerVal: LLVMValueRef) LLVMValueRef;
fn LLVMBuildFreeze(LLVMBuilderRef, Val: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildGEP2(B: LLVMBuilderRef, Ty: LLVMTypeRef, Pointer: LLVMValueRef, Indices: LLVMValueRef*, NumIndices: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildGlobalString(B: LLVMBuilderRef, Str: const(char)*, Name: const(char)*) LLVMValueRef;
fn LLVMBuildGlobalStringPtr(B: LLVMBuilderRef, Str: const(char)*, Name: const(char)*) LLVMValueRef;
fn LLVMBuildICmp(LLVMBuilderRef, Op: LLVMIntPredicate, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildInBoundsGEP2(B: LLVMBuilderRef, Ty: LLVMTypeRef, Pointer: LLVMValueRef, Indices: LLVMValueRef*, NumIndices: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildIndirectBr(B: LLVMBuilderRef, Addr: LLVMValueRef, NumDests: u32) LLVMValueRef;
fn LLVMBuildInsertElement(LLVMBuilderRef, VecVal: LLVMValueRef, EltVal: LLVMValueRef, Index: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildInsertValue(LLVMBuilderRef, AggVal: LLVMValueRef, EltVal: LLVMValueRef, Index: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildIntCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildIntCast2(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, IsSigned: LLVMBool, Name: const(char)*) LLVMValueRef;
fn LLVMBuildIntToPtr(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildInvoke2(LLVMBuilderRef, Ty: LLVMTypeRef, Fn: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Then: LLVMBasicBlockRef, Catch: LLVMBasicBlockRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildIsNotNull(LLVMBuilderRef, Val: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildIsNull(LLVMBuilderRef, Val: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildLShr(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildLandingPad(B: LLVMBuilderRef, Ty: LLVMTypeRef, PersFn: LLVMValueRef, NumClauses: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildLoad2(LLVMBuilderRef, Ty: LLVMTypeRef, PointerVal: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildMalloc(LLVMBuilderRef, Ty: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildMemCpy(B: LLVMBuilderRef, Dst: LLVMValueRef, DstAlign: u32, Src: LLVMValueRef, SrcAlign: u32, Size: LLVMValueRef) LLVMValueRef;
fn LLVMBuildMemMove(B: LLVMBuilderRef, Dst: LLVMValueRef, DstAlign: u32, Src: LLVMValueRef, SrcAlign: u32, Size: LLVMValueRef) LLVMValueRef;
fn LLVMBuildMemSet(B: LLVMBuilderRef, Ptr: LLVMValueRef, Val: LLVMValueRef, Len: LLVMValueRef, Align: u32) LLVMValueRef;
fn LLVMBuildMul(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNSWAdd(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNSWMul(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNSWNeg(B: LLVMBuilderRef, V: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNSWSub(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNUWAdd(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNUWMul(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNUWNeg(B: LLVMBuilderRef, V: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNUWSub(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNeg(LLVMBuilderRef, V: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildNot(LLVMBuilderRef, V: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildOr(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildPhi(LLVMBuilderRef, Ty: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildPointerCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildPtrToInt(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildResume(B: LLVMBuilderRef, Exn: LLVMValueRef) LLVMValueRef;
fn LLVMBuildRet(LLVMBuilderRef, V: LLVMValueRef) LLVMValueRef;
fn LLVMBuildRetVoid(LLVMBuilderRef) LLVMValueRef;
fn LLVMBuildSDiv(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildSExt(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildSExtOrBitCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildSIToFP(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildSRem(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildSelect(LLVMBuilderRef, If: LLVMValueRef, Then: LLVMValueRef, Else: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildShl(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildShuffleVector(LLVMBuilderRef, V1: LLVMValueRef, V2: LLVMValueRef, Mask: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildStore(LLVMBuilderRef, Val: LLVMValueRef, Ptr: LLVMValueRef) LLVMValueRef;
fn LLVMBuildStructGEP2(B: LLVMBuilderRef, Ty: LLVMTypeRef, Pointer: LLVMValueRef, Idx: u32, Name: const(char)*) LLVMValueRef;
fn LLVMBuildSub(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildSwitch(LLVMBuilderRef, V: LLVMValueRef, Else: LLVMBasicBlockRef, NumCases: u32) LLVMValueRef;
fn LLVMBuildTrunc(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildTruncOrBitCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildUDiv(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildUIToFP(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildURem(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildUnreachable(LLVMBuilderRef) LLVMValueRef;
fn LLVMBuildVAArg(LLVMBuilderRef, List: LLVMValueRef, Ty: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildXor(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildZExt(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuildZExtOrBitCast(LLVMBuilderRef, Val: LLVMValueRef, DestTy: LLVMTypeRef, Name: const(char)*) LLVMValueRef;
fn LLVMBuilderGetDefaultFPMathTag(Builder: LLVMBuilderRef) LLVMMetadataRef;
fn LLVMBuilderSetDefaultFPMathTag(Builder: LLVMBuilderRef, FPMathTag: LLVMMetadataRef);
fn LLVMClearInsertionPosition(Builder: LLVMBuilderRef);
fn LLVMCloneModule(M: LLVMModuleRef) LLVMModuleRef;
fn LLVMConstAdd(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstAddrSpaceCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
fn LLVMConstAllOnes(Ty: LLVMTypeRef) LLVMValueRef;
fn LLVMConstArray(ElementTy: LLVMTypeRef, ConstantVals: LLVMValueRef*, Length: u32) LLVMValueRef;
fn LLVMConstBitCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
fn LLVMConstExtractElement(VectorConstant: LLVMValueRef, IndexConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstGEP2(Ty: LLVMTypeRef, ConstantVal: LLVMValueRef, ConstantIndices: LLVMValueRef*, NumIndices: u32) LLVMValueRef;
fn LLVMConstInBoundsGEP2(Ty: LLVMTypeRef, ConstantVal: LLVMValueRef, ConstantIndices: LLVMValueRef*, NumIndices: u32) LLVMValueRef;
fn LLVMConstInlineAsm(Ty: LLVMTypeRef, AsmString: const(char)*, Constraints: const(char)*, HasSideEffects: LLVMBool, IsAlignStack: LLVMBool) LLVMValueRef;
fn LLVMConstInsertElement(VectorConstant: LLVMValueRef, ElementValueConstant: LLVMValueRef, IndexConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstInt(IntTy: LLVMTypeRef, N: u64, SignExtend: LLVMBool) LLVMValueRef;
fn LLVMConstIntGetSExtValue(ConstantVal: LLVMValueRef) i64;
fn LLVMConstIntGetZExtValue(ConstantVal: LLVMValueRef) u64;
fn LLVMConstIntOfArbitraryPrecision(IntTy: LLVMTypeRef, NumWords: u32, Words: const(u64)*) LLVMValueRef;
fn LLVMConstIntOfString(IntTy: LLVMTypeRef, Text: const(char)*, Radix: u8) LLVMValueRef;
fn LLVMConstIntOfStringAndSize(IntTy: LLVMTypeRef, Text: const(char)*, SLen: u32, Radix: u8) LLVMValueRef;
fn LLVMConstIntToPtr(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
fn LLVMConstNSWAdd(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstNSWNeg(ConstantVal: LLVMValueRef) LLVMValueRef;
fn LLVMConstNSWSub(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstNUWAdd(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstNUWNeg(ConstantVal: LLVMValueRef) LLVMValueRef;
fn LLVMConstNUWSub(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstNamedStruct(StructTy: LLVMTypeRef, ConstantVals: LLVMValueRef*, Count: u32) LLVMValueRef;
fn LLVMConstNeg(ConstantVal: LLVMValueRef) LLVMValueRef;
fn LLVMConstNot(ConstantVal: LLVMValueRef) LLVMValueRef;
fn LLVMConstNull(Ty: LLVMTypeRef) LLVMValueRef;
fn LLVMConstPointerCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
fn LLVMConstPointerNull(Ty: LLVMTypeRef) LLVMValueRef;
fn LLVMConstPtrToInt(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
fn LLVMConstReal(RealTy: LLVMTypeRef, N: f64) LLVMValueRef;
fn LLVMConstRealGetDouble(ConstantVal: LLVMValueRef, losesInfo: LLVMBool*) f64;
fn LLVMConstRealOfString(RealTy: LLVMTypeRef, Text: const(char)*) LLVMValueRef;
fn LLVMConstRealOfStringAndSize(RealTy: LLVMTypeRef, Text: const(char)*, SLen: u32) LLVMValueRef;
fn LLVMConstShuffleVector(VectorAConstant: LLVMValueRef, VectorBConstant: LLVMValueRef, MaskConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstString(Str: const(char)*, Length: u32, DontNullTerminate: LLVMBool) LLVMValueRef;
fn LLVMConstStringInContext(C: LLVMContextRef, Str: const(char)*, Length: u32, DontNullTerminate: LLVMBool) LLVMValueRef;
fn LLVMConstStruct(ConstantVals: LLVMValueRef*, Count: u32, Packed: LLVMBool) LLVMValueRef;
fn LLVMConstStructInContext(C: LLVMContextRef, ConstantVals: LLVMValueRef*, Count: u32, Packed: LLVMBool) LLVMValueRef;
fn LLVMConstSub(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
fn LLVMConstTrunc(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
fn LLVMConstTruncOrBitCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
fn LLVMConstVector(ScalarConstantVals: LLVMValueRef*, Size: u32) LLVMValueRef;
fn LLVMConstXor(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
fn LLVMContextCreate() LLVMContextRef;
fn LLVMContextDispose(C: LLVMContextRef);
fn LLVMContextGetDiagnosticContext(C: LLVMContextRef) void*;
fn LLVMContextGetDiagnosticHandler(C: LLVMContextRef) LLVMDiagnosticHandler;
fn LLVMContextSetDiagnosticHandler(C: LLVMContextRef, Handler: LLVMDiagnosticHandler, DiagnosticContext: void*);
fn LLVMContextSetDiscardValueNames(C: LLVMContextRef, Discard: LLVMBool);
fn LLVMContextSetYieldCallback(C: LLVMContextRef, Callback: LLVMYieldCallback, OpaqueHandle: void*);
fn LLVMContextShouldDiscardValueNames(C: LLVMContextRef) LLVMBool;
fn LLVMCopyModuleFlagsMetadata(M: LLVMModuleRef, Len: size_t*) LLVMModuleFlagEntry*;
fn LLVMCountBasicBlocks(Fn: LLVMValueRef) u32;
fn LLVMCountIncoming(PhiNode: LLVMValueRef) u32;
fn LLVMCountParamTypes(FunctionTy: LLVMTypeRef) u32;
fn LLVMCountParams(Fn: LLVMValueRef) u32;
fn LLVMCountStructElementTypes(StructTy: LLVMTypeRef) u32;
fn LLVMCreateBasicBlockInContext(C: LLVMContextRef, Name: const(char)*) LLVMBasicBlockRef;
fn LLVMCreateBuilder() LLVMBuilderRef;
fn LLVMCreateBuilderInContext(C: LLVMContextRef) LLVMBuilderRef;
fn LLVMCreateEnumAttribute(C: LLVMContextRef, KindID: u32, Val: u64) LLVMAttributeRef;
fn LLVMCreateFunctionPassManager(MP: LLVMModuleProviderRef) LLVMPassManagerRef;
fn LLVMCreateFunctionPassManagerForModule(M: LLVMModuleRef) LLVMPassManagerRef;
fn LLVMCreateMemoryBufferWithContentsOfFile(Path: const(char)*, OutMemBuf: LLVMMemoryBufferRef*, OutMessage: char**) LLVMBool;
fn LLVMCreateMemoryBufferWithMemoryRange(InputData: const(char)*, InputDataLength: size_t, BufferName: const(char)*, RequiresNullTerminator: LLVMBool) LLVMMemoryBufferRef;
fn LLVMCreateMemoryBufferWithMemoryRangeCopy(InputData: const(char)*, InputDataLength: size_t, BufferName: const(char)*) LLVMMemoryBufferRef;
fn LLVMCreateMemoryBufferWithSTDIN(OutMemBuf: LLVMMemoryBufferRef*, OutMessage: char**) LLVMBool;
fn LLVMCreateMessage(Message: const(char)*) char*;
fn LLVMCreateModuleProviderForExistingModule(M: LLVMModuleRef) LLVMModuleProviderRef;
fn LLVMCreatePassManager() LLVMPassManagerRef;
fn LLVMCreateStringAttribute(C: LLVMContextRef, K: const(char)*, KLength: u32, V: const(char)*, VLength: u32) LLVMAttributeRef;
fn LLVMDeleteBasicBlock(BB: LLVMBasicBlockRef);
fn LLVMDeleteFunction(Fn: LLVMValueRef);
fn LLVMDeleteGlobal(GlobalVar: LLVMValueRef);
fn LLVMDisposeBuilder(Builder: LLVMBuilderRef);
fn LLVMDisposeMemoryBuffer(MemBuf: LLVMMemoryBufferRef);
fn LLVMDisposeMessage(Message: char*);
fn LLVMDisposeModule(M: LLVMModuleRef);
fn LLVMDisposeModuleFlagsMetadata(Entries: LLVMModuleFlagEntry*);
fn LLVMDisposeModuleProvider(M: LLVMModuleProviderRef);
fn LLVMDisposePassManager(PM: LLVMPassManagerRef);
fn LLVMDisposeValueMetadataEntries(Entries: LLVMValueMetadataEntry*);
fn LLVMDoubleType() LLVMTypeRef;
fn LLVMDoubleTypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMDumpModule(M: LLVMModuleRef);
fn LLVMDumpType(Val: LLVMTypeRef);
fn LLVMDumpValue(Val: LLVMValueRef);
fn LLVMEraseGlobalIFunc(IFunc: LLVMValueRef);
fn LLVMFP128Type() LLVMTypeRef;
fn LLVMFP128TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMFinalizeFunctionPassManager(FPM: LLVMPassManagerRef) LLVMBool;
fn LLVMFloatType() LLVMTypeRef;
fn LLVMFloatTypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMFunctionType(ReturnType: LLVMTypeRef, ParamTypes: LLVMTypeRef*, ParamCount: u32, IsVarArg: LLVMBool) LLVMTypeRef;
fn LLVMGetAlignment(V: LLVMValueRef) u32;
fn LLVMGetAllocatedType(Alloca: LLVMValueRef) LLVMTypeRef;
fn LLVMGetArgOperand(Funclet: LLVMValueRef, i: u32) LLVMValueRef;
fn LLVMGetArrayLength(ArrayTy: LLVMTypeRef) u32;
fn LLVMGetAsString(c: LLVMValueRef, Length: size_t*) const(char)*;
fn LLVMGetAtomicRMWBinOp(AtomicRMWInst: LLVMValueRef) LLVMAtomicRMWBinOp;
fn LLVMGetAttributeCountAtIndex(F: LLVMValueRef, Idx: LLVMAttributeIndex) u32;
fn LLVMGetAttributesAtIndex(F: LLVMValueRef, Idx: LLVMAttributeIndex, Attrs: LLVMAttributeRef*);
fn LLVMGetBasicBlockName(BB: LLVMBasicBlockRef) const(char)*;
fn LLVMGetBasicBlockParent(BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMGetBasicBlockTerminator(BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMGetBasicBlocks(Fn: LLVMValueRef, BasicBlocks: LLVMBasicBlockRef*);
fn LLVMGetBufferSize(MemBuf: LLVMMemoryBufferRef) size_t;
fn LLVMGetBufferStart(MemBuf: LLVMMemoryBufferRef) const(char)*;
fn LLVMGetCallSiteAttributeCount(C: LLVMValueRef, Idx: LLVMAttributeIndex) u32;
fn LLVMGetCallSiteAttributes(C: LLVMValueRef, Idx: LLVMAttributeIndex, Attrs: LLVMAttributeRef*);
fn LLVMGetCallSiteEnumAttribute(C: LLVMValueRef, Idx: LLVMAttributeIndex, KindID: u32) LLVMAttributeRef;
fn LLVMGetCallSiteStringAttribute(C: LLVMValueRef, Idx: LLVMAttributeIndex, K: const(char)*, KLen: u32) LLVMAttributeRef;
fn LLVMGetCalledFunctionType(C: LLVMValueRef) LLVMTypeRef;
fn LLVMGetCalledValue(Instr: LLVMValueRef) LLVMValueRef;
fn LLVMGetClause(LandingPad: LLVMValueRef, Idx: u32) LLVMValueRef;
fn LLVMGetCmpXchgFailureOrdering(CmpXchgInst: LLVMValueRef) LLVMAtomicOrdering;
fn LLVMGetCmpXchgSuccessOrdering(CmpXchgInst: LLVMValueRef) LLVMAtomicOrdering;
fn LLVMGetCondition(Branch: LLVMValueRef) LLVMValueRef;
fn LLVMGetConstOpcode(ConstantVal: LLVMValueRef) LLVMOpcode;
fn LLVMGetCurrentDebugLocation(Builder: LLVMBuilderRef) LLVMValueRef;
fn LLVMGetCurrentDebugLocation2(Builder: LLVMBuilderRef) LLVMMetadataRef;
fn LLVMGetDLLStorageClass(Global: LLVMValueRef) LLVMDLLStorageClass;
fn LLVMGetDataLayout(M: LLVMModuleRef) const(char)*;
fn LLVMGetDataLayoutStr(M: LLVMModuleRef) const(char)*;
fn LLVMGetDebugLocColumn(Val: LLVMValueRef) u32;
fn LLVMGetDebugLocDirectory(Val: LLVMValueRef, Length: u32*) const(char)*;
fn LLVMGetDebugLocFilename(Val: LLVMValueRef, Length: u32*) const(char)*;
fn LLVMGetDebugLocLine(Val: LLVMValueRef) u32;
fn LLVMGetDiagInfoDescription(DI: LLVMDiagnosticInfoRef) char*;
fn LLVMGetDiagInfoSeverity(DI: LLVMDiagnosticInfoRef) LLVMDiagnosticSeverity;
fn LLVMGetElementAsConstant(C: LLVMValueRef, idx: u32) LLVMValueRef;
fn LLVMGetElementType(Ty: LLVMTypeRef) LLVMTypeRef;
fn LLVMGetEntryBasicBlock(Fn: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetEnumAttributeAtIndex(F: LLVMValueRef, Idx: LLVMAttributeIndex, KindID: u32) LLVMAttributeRef;
fn LLVMGetEnumAttributeKind(A: LLVMAttributeRef) u32;
fn LLVMGetEnumAttributeKindForName(Name: const(char)*, SLen: size_t) u32;
fn LLVMGetEnumAttributeValue(A: LLVMAttributeRef) u64;
fn LLVMGetFCmpPredicate(Inst: LLVMValueRef) LLVMRealPredicate;
fn LLVMGetFirstBasicBlock(Fn: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetFirstFunction(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetFirstGlobal(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetFirstGlobalAlias(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetFirstGlobalIFunc(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetFirstInstruction(BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMGetFirstNamedMetadata(M: LLVMModuleRef) LLVMNamedMDNodeRef;
fn LLVMGetFirstParam(Fn: LLVMValueRef) LLVMValueRef;
fn LLVMGetFirstUse(Val: LLVMValueRef) LLVMUseRef;
fn LLVMGetFunctionCallConv(Fn: LLVMValueRef) u32;
fn LLVMGetGC(Fn: LLVMValueRef) const(char)*;
fn LLVMGetGlobalContext() LLVMContextRef;
fn LLVMGetGlobalIFuncResolver(IFunc: LLVMValueRef) LLVMValueRef;
fn LLVMGetGlobalParent(Global: LLVMValueRef) LLVMModuleRef;
fn LLVMGetHandlers(CatchSwitch: LLVMValueRef, Handlers: LLVMBasicBlockRef*);
fn LLVMGetICmpPredicate(Inst: LLVMValueRef) LLVMIntPredicate;
fn LLVMGetIncomingBlock(PhiNode: LLVMValueRef, Index: u32) LLVMBasicBlockRef;
fn LLVMGetIncomingValue(PhiNode: LLVMValueRef, Index: u32) LLVMValueRef;
fn LLVMGetIndices(Inst: LLVMValueRef) const(u32)*;
fn LLVMGetInitializer(GlobalVar: LLVMValueRef) LLVMValueRef;
fn LLVMGetInsertBlock(Builder: LLVMBuilderRef) LLVMBasicBlockRef;
fn LLVMGetInstructionCallConv(Instr: LLVMValueRef) u32;
fn LLVMGetInstructionOpcode(Inst: LLVMValueRef) LLVMOpcode;
fn LLVMGetInstructionParent(Inst: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetIntTypeWidth(IntegerTy: LLVMTypeRef) u32;
fn LLVMGetIntrinsicDeclaration(Mod: LLVMModuleRef, ID: u32, ParamTypes: LLVMTypeRef*, ParamCount: size_t) LLVMValueRef;
fn LLVMGetIntrinsicID(Fn: LLVMValueRef) u32;
fn LLVMGetLastBasicBlock(Fn: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetLastEnumAttributeKind() u32;
fn LLVMGetLastFunction(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetLastGlobal(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetLastGlobalAlias(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetLastGlobalIFunc(M: LLVMModuleRef) LLVMValueRef;
fn LLVMGetLastInstruction(BB: LLVMBasicBlockRef) LLVMValueRef;
fn LLVMGetLastNamedMetadata(M: LLVMModuleRef) LLVMNamedMDNodeRef;
fn LLVMGetLastParam(Fn: LLVMValueRef) LLVMValueRef;
fn LLVMGetLinkage(Global: LLVMValueRef) LLVMLinkage;
fn LLVMGetMDKindID(Name: const(char)*, SLen: u32) u32;
fn LLVMGetMDKindIDInContext(C: LLVMContextRef, Name: const(char)*, SLen: u32) u32;
fn LLVMGetMDNodeNumOperands(V: LLVMValueRef) u32;
fn LLVMGetMDNodeOperands(V: LLVMValueRef, Dest: LLVMValueRef*);
fn LLVMGetMDString(V: LLVMValueRef, Length: u32*) const(char)*;
fn LLVMGetMetadata(Val: LLVMValueRef, KindID: u32) LLVMValueRef;
fn LLVMGetModuleContext(M: LLVMModuleRef) LLVMContextRef;
fn LLVMGetModuleFlag(M: LLVMModuleRef, Key: const(char)*, KeyLen: size_t) LLVMMetadataRef;
fn LLVMGetModuleIdentifier(M: LLVMModuleRef, Len: size_t*) const(char)*;
fn LLVMGetModuleInlineAsm(M: LLVMModuleRef, Len: size_t*) const(char)*;
fn LLVMGetNamedFunction(M: LLVMModuleRef, Name: const(char)*) LLVMValueRef;
fn LLVMGetNamedGlobal(M: LLVMModuleRef, Name: const(char)*) LLVMValueRef;
fn LLVMGetNamedGlobalAlias(M: LLVMModuleRef, Name: const(char)*, NameLen: size_t) LLVMValueRef;
fn LLVMGetNamedGlobalIFunc(M: LLVMModuleRef, Name: const(char)*, NameLen: size_t) LLVMValueRef;
fn LLVMGetNamedMetadata(M: LLVMModuleRef, Name: const(char)*, NameLen: size_t) LLVMNamedMDNodeRef;
fn LLVMGetNamedMetadataName(NamedMD: LLVMNamedMDNodeRef, NameLen: size_t*) const(char)*;
fn LLVMGetNamedMetadataNumOperands(M: LLVMModuleRef, Name: const(char)*) u32;
fn LLVMGetNamedMetadataOperands(M: LLVMModuleRef, Name: const(char)*, Dest: LLVMValueRef*);
fn LLVMGetNextBasicBlock(BB: LLVMBasicBlockRef) LLVMBasicBlockRef;
fn LLVMGetNextFunction(Fn: LLVMValueRef) LLVMValueRef;
fn LLVMGetNextGlobal(GlobalVar: LLVMValueRef) LLVMValueRef;
fn LLVMGetNextGlobalAlias(GA: LLVMValueRef) LLVMValueRef;
fn LLVMGetNextGlobalIFunc(IFunc: LLVMValueRef) LLVMValueRef;
fn LLVMGetNextInstruction(Inst: LLVMValueRef) LLVMValueRef;
fn LLVMGetNextNamedMetadata(NamedMDNode: LLVMNamedMDNodeRef) LLVMNamedMDNodeRef;
fn LLVMGetNextParam(Arg: LLVMValueRef) LLVMValueRef;
fn LLVMGetNextUse(U: LLVMUseRef) LLVMUseRef;
fn LLVMGetNormalDest(InvokeInst: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetNumArgOperands(Instr: LLVMValueRef) u32;
fn LLVMGetNumClauses(LandingPad: LLVMValueRef) u32;
fn LLVMGetNumContainedTypes(Tp: LLVMTypeRef) u32;
fn LLVMGetNumHandlers(CatchSwitch: LLVMValueRef) u32;
fn LLVMGetNumIndices(Inst: LLVMValueRef) u32;
fn LLVMGetNumOperands(Val: LLVMValueRef) i32;
fn LLVMGetNumSuccessors(Term: LLVMValueRef) u32;
fn LLVMGetOperand(Val: LLVMValueRef, Index: u32) LLVMValueRef;
fn LLVMGetOperandUse(Val: LLVMValueRef, Index: u32) LLVMUseRef;
fn LLVMGetOrInsertNamedMetadata(M: LLVMModuleRef, Name: const(char)*, NameLen: size_t) LLVMNamedMDNodeRef;
fn LLVMGetOrdering(MemoryAccessInst: LLVMValueRef) LLVMAtomicOrdering;
fn LLVMGetParam(Fn: LLVMValueRef, Index: u32) LLVMValueRef;
fn LLVMGetParamParent(Inst: LLVMValueRef) LLVMValueRef;
fn LLVMGetParamTypes(FunctionTy: LLVMTypeRef, Dest: LLVMTypeRef*);
fn LLVMGetParams(Fn: LLVMValueRef, Params: LLVMValueRef*);
fn LLVMGetParentCatchSwitch(CatchPad: LLVMValueRef) LLVMValueRef;
fn LLVMGetPersonalityFn(Fn: LLVMValueRef) LLVMValueRef;
fn LLVMGetPointerAddressSpace(PointerTy: LLVMTypeRef) u32;
fn LLVMGetPreviousBasicBlock(BB: LLVMBasicBlockRef) LLVMBasicBlockRef;
fn LLVMGetPreviousFunction(Fn: LLVMValueRef) LLVMValueRef;
fn LLVMGetPreviousGlobal(GlobalVar: LLVMValueRef) LLVMValueRef;
fn LLVMGetPreviousGlobalAlias(GA: LLVMValueRef) LLVMValueRef;
fn LLVMGetPreviousGlobalIFunc(IFunc: LLVMValueRef) LLVMValueRef;
fn LLVMGetPreviousInstruction(Inst: LLVMValueRef) LLVMValueRef;
fn LLVMGetPreviousNamedMetadata(NamedMDNode: LLVMNamedMDNodeRef) LLVMNamedMDNodeRef;
fn LLVMGetPreviousParam(Arg: LLVMValueRef) LLVMValueRef;
fn LLVMGetReturnType(FunctionTy: LLVMTypeRef) LLVMTypeRef;
fn LLVMGetSection(Global: LLVMValueRef) const(char)*;
fn LLVMGetSourceFileName(M: LLVMModuleRef, Len: size_t*) const(char)*;
fn LLVMGetStringAttributeAtIndex(F: LLVMValueRef, Idx: LLVMAttributeIndex, K: const(char)*, KLen: u32) LLVMAttributeRef;
fn LLVMGetStringAttributeKind(A: LLVMAttributeRef, Length: u32*) const(char)*;
fn LLVMGetStringAttributeValue(A: LLVMAttributeRef, Length: u32*) const(char)*;
fn LLVMGetStructElementTypes(StructTy: LLVMTypeRef, Dest: LLVMTypeRef*);
fn LLVMGetStructName(Ty: LLVMTypeRef) const(char)*;
fn LLVMGetSubtypes(Tp: LLVMTypeRef, Arr: LLVMTypeRef*);
fn LLVMGetSuccessor(Term: LLVMValueRef, i: u32) LLVMBasicBlockRef;
fn LLVMGetSwitchDefaultDest(SwitchInstr: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetTarget(M: LLVMModuleRef) const(char)*;
fn LLVMGetThreadLocalMode(GlobalVar: LLVMValueRef) LLVMThreadLocalMode;
fn LLVMGetTypeByName(M: LLVMModuleRef, Name: const(char)*) LLVMTypeRef;
fn LLVMGetTypeContext(Ty: LLVMTypeRef) LLVMContextRef;
fn LLVMGetTypeKind(Ty: LLVMTypeRef) LLVMTypeKind;
fn LLVMGetUndef(Ty: LLVMTypeRef) LLVMValueRef;
fn LLVMGetUnnamedAddress(Global: LLVMValueRef) LLVMUnnamedAddr;
fn LLVMGetUnwindDest(InvokeInst: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetUsedValue(U: LLVMUseRef) LLVMValueRef;
fn LLVMGetUser(U: LLVMUseRef) LLVMValueRef;
fn LLVMGetValueKind(Val: LLVMValueRef) LLVMValueKind;
fn LLVMGetValueName(Val: LLVMValueRef) const(char)*;
fn LLVMGetValueName2(Val: LLVMValueRef, Length: size_t*) const(char)*;
fn LLVMGetVectorSize(VectorTy: LLVMTypeRef) u32;
fn LLVMGetVisibility(Global: LLVMValueRef) LLVMVisibility;
fn LLVMGetVolatile(MemoryAccessInst: LLVMValueRef) LLVMBool;
fn LLVMGetWeak(CmpXchgInst: LLVMValueRef) LLVMBool;
fn LLVMGlobalClearMetadata(Global: LLVMValueRef);
fn LLVMGlobalCopyAllMetadata(Value: LLVMValueRef, NumEntries: size_t*) LLVMValueMetadataEntry*;
fn LLVMGlobalEraseMetadata(Global: LLVMValueRef, Kind: u32);
fn LLVMGlobalGetValueType(Global: LLVMValueRef) LLVMTypeRef;
fn LLVMGlobalSetMetadata(Global: LLVMValueRef, Kind: u32, MD: LLVMMetadataRef);
fn LLVMHalfType() LLVMTypeRef;
fn LLVMHalfTypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMHasMetadata(Val: LLVMValueRef) i32;
fn LLVMHasPersonalityFn(Fn: LLVMValueRef) LLVMBool;
fn LLVMHasUnnamedAddr(Global: LLVMValueRef) LLVMBool;
fn LLVMInitializeFunctionPassManager(FPM: LLVMPassManagerRef) LLVMBool;
fn LLVMInsertBasicBlock(InsertBeforeBB: LLVMBasicBlockRef, Name: const(char)*) LLVMBasicBlockRef;
fn LLVMInsertBasicBlockInContext(C: LLVMContextRef, BB: LLVMBasicBlockRef, Name: const(char)*) LLVMBasicBlockRef;
fn LLVMInsertExistingBasicBlockAfterInsertBlock(Builder: LLVMBuilderRef, BB: LLVMBasicBlockRef);
fn LLVMInsertIntoBuilder(Builder: LLVMBuilderRef, Instr: LLVMValueRef);
fn LLVMInsertIntoBuilderWithName(Builder: LLVMBuilderRef, Instr: LLVMValueRef, Name: const(char)*);
fn LLVMInstructionClone(Inst: LLVMValueRef) LLVMValueRef;
fn LLVMInstructionEraseFromParent(Inst: LLVMValueRef);
fn LLVMInstructionGetAllMetadataOtherThanDebugLoc(Instr: LLVMValueRef, NumEntries: size_t*) LLVMValueMetadataEntry*;
fn LLVMInstructionRemoveFromParent(Inst: LLVMValueRef);
fn LLVMInt128Type() LLVMTypeRef;
fn LLVMInt128TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMInt16Type() LLVMTypeRef;
fn LLVMInt16TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMInt1Type() LLVMTypeRef;
fn LLVMInt1TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMInt32Type() LLVMTypeRef;
fn LLVMInt32TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMInt64Type() LLVMTypeRef;
fn LLVMInt64TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMInt8Type() LLVMTypeRef;
fn LLVMInt8TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMIntType(NumBits: u32) LLVMTypeRef;
fn LLVMIntTypeInContext(C: LLVMContextRef, NumBits: u32) LLVMTypeRef;
fn LLVMIntrinsicCopyOverloadedName(ID: u32, ParamTypes: LLVMTypeRef*, ParamCount: size_t, NameLength: size_t*) char*;
fn LLVMIntrinsicGetName(ID: u32, NameLength: size_t*) const(char)*;
fn LLVMIntrinsicGetType(Ctx: LLVMContextRef, ID: u32, ParamTypes: LLVMTypeRef*, ParamCount: size_t) LLVMTypeRef;
fn LLVMIntrinsicIsOverloaded(ID: u32) LLVMBool;
fn LLVMIsAAddrSpaceCastInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAAllocaInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAArgument(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAAtomicCmpXchgInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAAtomicRMWInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsABasicBlock(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsABinaryOperator(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsABitCastInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsABlockAddress(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsABranchInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACallBrInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACallInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACastInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACatchPadInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACatchReturnInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACatchSwitchInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACleanupPadInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACleanupReturnInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsACmpInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstant(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantAggregateZero(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantArray(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantDataArray(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantDataSequential(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantDataVector(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantExpr(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantFP(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantInt(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantPointerNull(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantStruct(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantTokenNone(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAConstantVector(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsADbgDeclareInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsADbgInfoIntrinsic(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsADbgLabelInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsADbgVariableIntrinsic(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAExtractElementInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAExtractValueInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFCmpInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFPExtInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFPToSIInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFPToUIInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFPTruncInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFenceInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFreezeInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFuncletPadInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAFunction(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAGetElementPtrInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAGlobalAlias(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAGlobalIFunc(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAGlobalObject(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAGlobalValue(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAGlobalVariable(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAICmpInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAIndirectBrInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAInlineAsm(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAInsertElementInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAInsertValueInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAInstruction(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAIntToPtrInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAIntrinsicInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAInvokeInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsALandingPadInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsALoadInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAMDNode(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAMDString(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAMemCpyInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAMemIntrinsic(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAMemMoveInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAMemSetInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAPHINode(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAPtrToIntInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAResumeInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAReturnInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsASExtInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsASIToFPInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsASelectInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAShuffleVectorInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAStoreInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsASwitchInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsATerminatorInst(Inst: LLVMValueRef) LLVMValueRef;
fn LLVMIsATruncInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAUIToFPInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAUnaryInstruction(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAUnaryOperator(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAUndefValue(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAUnreachableInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAUser(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAVAArgInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAZExtInst(Val: LLVMValueRef) LLVMValueRef;
fn LLVMIsAtomicSingleThread(AtomicInst: LLVMValueRef) LLVMBool;
fn LLVMIsCleanup(LandingPad: LLVMValueRef) LLVMBool;
fn LLVMIsConditional(Branch: LLVMValueRef) LLVMBool;
fn LLVMIsConstant(Val: LLVMValueRef) LLVMBool;
fn LLVMIsConstantString(c: LLVMValueRef) LLVMBool;
fn LLVMIsDeclaration(Global: LLVMValueRef) LLVMBool;
fn LLVMIsEnumAttribute(A: LLVMAttributeRef) LLVMBool;
fn LLVMIsExternallyInitialized(GlobalVar: LLVMValueRef) LLVMBool;
fn LLVMIsFunctionVarArg(FunctionTy: LLVMTypeRef) LLVMBool;
fn LLVMIsGlobalConstant(GlobalVar: LLVMValueRef) LLVMBool;
fn LLVMIsInBounds(GEP: LLVMValueRef) LLVMBool;
fn LLVMIsLiteralStruct(StructTy: LLVMTypeRef) LLVMBool;
fn LLVMIsMultithreaded() LLVMBool;
fn LLVMIsNull(Val: LLVMValueRef) LLVMBool;
fn LLVMIsOpaqueStruct(StructTy: LLVMTypeRef) LLVMBool;
fn LLVMIsPackedStruct(StructTy: LLVMTypeRef) LLVMBool;
fn LLVMIsStringAttribute(A: LLVMAttributeRef) LLVMBool;
fn LLVMIsTailCall(CallInst: LLVMValueRef) LLVMBool;
fn LLVMIsThreadLocal(GlobalVar: LLVMValueRef) LLVMBool;
fn LLVMIsUndef(Val: LLVMValueRef) LLVMBool;
fn LLVMLabelType() LLVMTypeRef;
fn LLVMLabelTypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMLookupIntrinsicID(Name: const(char)*, NameLen: size_t) u32;
fn LLVMMDNode(Vals: LLVMValueRef*, Count: u32) LLVMValueRef;
fn LLVMMDNodeInContext(C: LLVMContextRef, Vals: LLVMValueRef*, Count: u32) LLVMValueRef;
fn LLVMMDNodeInContext2(C: LLVMContextRef, MDs: LLVMMetadataRef*, Count: size_t) LLVMMetadataRef;
fn LLVMMDString(Str: const(char)*, SLen: u32) LLVMValueRef;
fn LLVMMDStringInContext(C: LLVMContextRef, Str: const(char)*, SLen: u32) LLVMValueRef;
fn LLVMMDStringInContext2(C: LLVMContextRef, Str: const(char)*, SLen: size_t) LLVMMetadataRef;
fn LLVMMetadataAsValue(C: LLVMContextRef, MD: LLVMMetadataRef) LLVMValueRef;
fn LLVMMetadataTypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMModuleCreateWithName(ModuleID: const(char)*) LLVMModuleRef;
fn LLVMModuleCreateWithNameInContext(ModuleID: const(char)*, C: LLVMContextRef) LLVMModuleRef;
fn LLVMModuleFlagEntriesGetFlagBehavior(Entries: LLVMModuleFlagEntry*, Index: u32) LLVMModuleFlagBehavior;
fn LLVMModuleFlagEntriesGetKey(Entries: LLVMModuleFlagEntry*, Index: u32, Len: size_t*) const(char)*;
fn LLVMModuleFlagEntriesGetMetadata(Entries: LLVMModuleFlagEntry*, Index: u32) LLVMMetadataRef;
fn LLVMMoveBasicBlockAfter(BB: LLVMBasicBlockRef, MovePos: LLVMBasicBlockRef);
fn LLVMMoveBasicBlockBefore(BB: LLVMBasicBlockRef, MovePos: LLVMBasicBlockRef);
fn LLVMPPCFP128Type() LLVMTypeRef;
fn LLVMPPCFP128TypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMPointerType(ElementType: LLVMTypeRef, AddressSpace: u32) LLVMTypeRef;
fn LLVMPositionBuilder(Builder: LLVMBuilderRef, Block: LLVMBasicBlockRef, Instr: LLVMValueRef);
fn LLVMPositionBuilderAtEnd(Builder: LLVMBuilderRef, Block: LLVMBasicBlockRef);
fn LLVMPositionBuilderBefore(Builder: LLVMBuilderRef, Instr: LLVMValueRef);
fn LLVMPrintModuleToFile(M: LLVMModuleRef, Filename: const(char)*, ErrorMessage: char**) LLVMBool;
fn LLVMPrintModuleToString(M: LLVMModuleRef) char*;
fn LLVMPrintTypeToString(Val: LLVMTypeRef) char*;
fn LLVMPrintValueToString(Val: LLVMValueRef) char*;
fn LLVMRemoveBasicBlockFromParent(BB: LLVMBasicBlockRef);
fn LLVMRemoveCallSiteEnumAttribute(C: LLVMValueRef, Idx: LLVMAttributeIndex, KindID: u32);
fn LLVMRemoveCallSiteStringAttribute(C: LLVMValueRef, Idx: LLVMAttributeIndex, K: const(char)*, KLen: u32);
fn LLVMRemoveEnumAttributeAtIndex(F: LLVMValueRef, Idx: LLVMAttributeIndex, KindID: u32);
fn LLVMRemoveGlobalIFunc(IFunc: LLVMValueRef);
fn LLVMRemoveStringAttributeAtIndex(F: LLVMValueRef, Idx: LLVMAttributeIndex, K: const(char)*, KLen: u32);
fn LLVMReplaceAllUsesWith(OldVal: LLVMValueRef, NewVal: LLVMValueRef);
fn LLVMRunFunctionPassManager(FPM: LLVMPassManagerRef, F: LLVMValueRef) LLVMBool;
fn LLVMRunPassManager(PM: LLVMPassManagerRef, M: LLVMModuleRef) LLVMBool;
fn LLVMSetAlignment(V: LLVMValueRef, Bytes: u32);
fn LLVMSetArgOperand(Funclet: LLVMValueRef, i: u32, value: LLVMValueRef);
fn LLVMSetAtomicRMWBinOp(AtomicRMWInst: LLVMValueRef, BinOp: LLVMAtomicRMWBinOp);
fn LLVMSetAtomicSingleThread(AtomicInst: LLVMValueRef, SingleThread: LLVMBool);
fn LLVMSetCleanup(LandingPad: LLVMValueRef, Val: LLVMBool);
fn LLVMSetCmpXchgFailureOrdering(CmpXchgInst: LLVMValueRef, Ordering: LLVMAtomicOrdering);
fn LLVMSetCmpXchgSuccessOrdering(CmpXchgInst: LLVMValueRef, Ordering: LLVMAtomicOrdering);
fn LLVMSetCondition(Branch: LLVMValueRef, Cond: LLVMValueRef);
fn LLVMSetCurrentDebugLocation(Builder: LLVMBuilderRef, L: LLVMValueRef);
fn LLVMSetCurrentDebugLocation2(Builder: LLVMBuilderRef, Loc: LLVMMetadataRef);
fn LLVMSetDLLStorageClass(Global: LLVMValueRef, Class: LLVMDLLStorageClass);
fn LLVMSetDataLayout(M: LLVMModuleRef, DataLayoutStr: const(char)*);
fn LLVMSetExternallyInitialized(GlobalVar: LLVMValueRef, IsExtInit: LLVMBool);
fn LLVMSetFunctionCallConv(Fn: LLVMValueRef, CC: u32);
fn LLVMSetGC(Fn: LLVMValueRef, Name: const(char)*);
fn LLVMSetGlobalConstant(GlobalVar: LLVMValueRef, IsConstant: LLVMBool);
fn LLVMSetGlobalIFuncResolver(IFunc: LLVMValueRef, Resolver: LLVMValueRef);
fn LLVMSetInitializer(GlobalVar: LLVMValueRef, ConstantVal: LLVMValueRef);
fn LLVMSetInstDebugLocation(Builder: LLVMBuilderRef, Inst: LLVMValueRef);
fn LLVMSetInstructionCallConv(Instr: LLVMValueRef, CC: u32);
fn LLVMSetIsInBounds(GEP: LLVMValueRef, InBounds: LLVMBool);
fn LLVMSetLinkage(Global: LLVMValueRef, Linkage: LLVMLinkage);
fn LLVMSetMetadata(Val: LLVMValueRef, KindID: u32, Node: LLVMValueRef);
fn LLVMSetModuleIdentifier(M: LLVMModuleRef, Ident: const(char)*, Len: size_t);
fn LLVMSetModuleInlineAsm(M: LLVMModuleRef, Asm: const(char)*);
fn LLVMSetModuleInlineAsm2(M: LLVMModuleRef, Asm: const(char)*, Len: size_t);
fn LLVMSetNormalDest(InvokeInst: LLVMValueRef, B: LLVMBasicBlockRef);
fn LLVMSetOperand(User: LLVMValueRef, Index: u32, Val: LLVMValueRef);
fn LLVMSetOrdering(MemoryAccessInst: LLVMValueRef, Ordering: LLVMAtomicOrdering);
fn LLVMSetParamAlignment(Arg: LLVMValueRef, Align: u32);
fn LLVMSetParentCatchSwitch(CatchPad: LLVMValueRef, CatchSwitch: LLVMValueRef);
fn LLVMSetPersonalityFn(Fn: LLVMValueRef, PersonalityFn: LLVMValueRef);
fn LLVMSetSection(Global: LLVMValueRef, Section: const(char)*);
fn LLVMSetSourceFileName(M: LLVMModuleRef, Name: const(char)*, Len: size_t);
fn LLVMSetSuccessor(Term: LLVMValueRef, i: u32, block: LLVMBasicBlockRef);
fn LLVMSetTailCall(CallInst: LLVMValueRef, IsTailCall: LLVMBool);
fn LLVMSetTarget(M: LLVMModuleRef, Triple: const(char)*);
fn LLVMSetThreadLocal(GlobalVar: LLVMValueRef, IsThreadLocal: LLVMBool);
fn LLVMSetThreadLocalMode(GlobalVar: LLVMValueRef, Mode: LLVMThreadLocalMode);
fn LLVMSetUnnamedAddr(Global: LLVMValueRef, HasUnnamedAddr: LLVMBool);
fn LLVMSetUnnamedAddress(Global: LLVMValueRef, UnnamedAddr: LLVMUnnamedAddr);
fn LLVMSetUnwindDest(InvokeInst: LLVMValueRef, B: LLVMBasicBlockRef);
fn LLVMSetValueName(Val: LLVMValueRef, Name: const(char)*);
fn LLVMSetValueName2(Val: LLVMValueRef, Name: const(char)*, NameLen: size_t);
fn LLVMSetVisibility(Global: LLVMValueRef, Viz: LLVMVisibility);
fn LLVMSetVolatile(MemoryAccessInst: LLVMValueRef, IsVolatile: LLVMBool);
fn LLVMSetWeak(CmpXchgInst: LLVMValueRef, IsWeak: LLVMBool);
fn LLVMShutdown();
fn LLVMSizeOf(Ty: LLVMTypeRef) LLVMValueRef;
fn LLVMStartMultithreaded() LLVMBool;
fn LLVMStopMultithreaded();
fn LLVMStructCreateNamed(C: LLVMContextRef, Name: const(char)*) LLVMTypeRef;
fn LLVMStructGetTypeAtIndex(StructTy: LLVMTypeRef, i: u32) LLVMTypeRef;
fn LLVMStructSetBody(StructTy: LLVMTypeRef, ElementTypes: LLVMTypeRef*, ElementCount: u32, Packed: LLVMBool);
fn LLVMStructType(ElementTypes: LLVMTypeRef*, ElementCount: u32, Packed: LLVMBool) LLVMTypeRef;
fn LLVMStructTypeInContext(C: LLVMContextRef, ElementTypes: LLVMTypeRef*, ElementCount: u32, Packed: LLVMBool) LLVMTypeRef;
fn LLVMTokenTypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMTypeIsSized(Ty: LLVMTypeRef) LLVMBool;
fn LLVMTypeOf(Val: LLVMValueRef) LLVMTypeRef;
fn LLVMValueAsBasicBlock(Val: LLVMValueRef) LLVMBasicBlockRef;
fn LLVMValueAsMetadata(Val: LLVMValueRef) LLVMMetadataRef;
fn LLVMValueIsBasicBlock(Val: LLVMValueRef) LLVMBool;
fn LLVMValueMetadataEntriesGetKind(Entries: LLVMValueMetadataEntry*, Index: u32) u32;
fn LLVMValueMetadataEntriesGetMetadata(Entries: LLVMValueMetadataEntry*, Index: u32) LLVMMetadataRef;
fn LLVMVectorType(ElementType: LLVMTypeRef, ElementCount: u32) LLVMTypeRef;
fn LLVMVoidType() LLVMTypeRef;
fn LLVMVoidTypeInContext(C: LLVMContextRef) LLVMTypeRef;
fn LLVMX86FP80Type() LLVMTypeRef;
fn LLVMX86FP80TypeInContext(C: LLVMContextRef) LLVMTypeRef;
version(LLVMVersion18AndAbove) {
	fn LLVMGetInlineAsm(Ty: LLVMTypeRef, AsmString: const(char)*, AsmStringSize: size_t, Constraints: const(char)*, ConstraintsSize: size_t, HasSideEffects: LLVMBool, IsAlignStack: LLVMBool, Dialect: LLVMInlineAsmDialect, CanThrow: LLVMBool) LLVMValueRef;
} else version(LLVMVersion13AndAbove) {
	fn LLVMGetInlineAsm(Ty: LLVMTypeRef, AsmString: char*, AsmStringSize: size_t, Constraints: char*, ConstraintsSize: size_t, HasSideEffects: LLVMBool, IsAlignStack: LLVMBool, Dialect: LLVMInlineAsmDialect, CanThrow: LLVMBool) LLVMValueRef;
} else {
	fn LLVMGetInlineAsm(Ty: LLVMTypeRef, AsmString: char*, AsmStringSize: size_t, Constraints: char*, ConstraintsSize: size_t, HasSideEffects: LLVMBool, IsAlignStack: LLVMBool, Dialect: LLVMInlineAsmDialect) LLVMValueRef;
}
version(LLVMVersion14AndAbove) {
	fn LLVMSetInstrParamAlignment(Instr: LLVMValueRef, Idx: LLVMAttributeIndex, Align: u32);
} else {
	fn LLVMSetInstrParamAlignment(Instr: LLVMValueRef, index: u32, Align: u32);
}
version(!LLVMVersion15AndAbove) {
	fn LLVMConstExactSDiv(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstExactUDiv(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstExtractValue(AggConstant: LLVMValueRef, IdxList: u32*, NumIdx: u32) LLVMValueRef;
	fn LLVMConstFAdd(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstFDiv(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstFMul(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstFRem(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstFSub(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstInsertValue(AggConstant: LLVMValueRef, ElementValueConstant: LLVMValueRef, IdxList: u32*, NumIdx: u32) LLVMValueRef;
	fn LLVMConstSDiv(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstSRem(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstUDiv(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstURem(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
}
version(!LLVMVersion16AndAbove) {
	fn LLVMAddAlias(M: LLVMModuleRef, Ty: LLVMTypeRef, Aliasee: LLVMValueRef, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildCall(LLVMBuilderRef, Fn: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildGEP(B: LLVMBuilderRef, Pointer: LLVMValueRef, Indices: LLVMValueRef*, NumIndices: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildInBoundsGEP(B: LLVMBuilderRef, Pointer: LLVMValueRef, Indices: LLVMValueRef*, NumIndices: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildInvoke(LLVMBuilderRef, Fn: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Then: LLVMBasicBlockRef, Catch: LLVMBasicBlockRef, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildLoad(LLVMBuilderRef, PointerVal: LLVMValueRef, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildPtrDiff(LLVMBuilderRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildStructGEP(B: LLVMBuilderRef, Pointer: LLVMValueRef, Idx: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMConstFNeg(ConstantVal: LLVMValueRef) LLVMValueRef;
	fn LLVMConstGEP(ConstantVal: LLVMValueRef, ConstantIndices: LLVMValueRef*, NumIndices: u32) LLVMValueRef;
	fn LLVMConstInBoundsGEP(ConstantVal: LLVMValueRef, ConstantIndices: LLVMValueRef*, NumIndices: u32) LLVMValueRef;
}
version(!LLVMVersion17AndAbove) {
	fn LLVMConstSelect(ConstantCondition: LLVMValueRef, ConstantIfTrue: LLVMValueRef, ConstantIfFalse: LLVMValueRef) LLVMValueRef;
	fn LLVMGetGlobalPassRegistry() LLVMPassRegistryRef;
}
version(!LLVMVersion18AndAbove) {
	fn LLVMConstAShr(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstAnd(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstFPCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstFPExt(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstFPToSI(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstFPToUI(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstFPTrunc(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstIntCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef, isSigned: LLVMBool) LLVMValueRef;
	fn LLVMConstLShr(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstOr(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstSExt(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstSExtOrBitCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstSIToFP(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstUIToFP(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstZExt(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
	fn LLVMConstZExtOrBitCast(ConstantVal: LLVMValueRef, ToType: LLVMTypeRef) LLVMValueRef;
}
version(!LLVMVersion19AndAbove) {
	fn LLVMConstFCmp(Predicate: LLVMRealPredicate, LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstICmp(Predicate: LLVMIntPredicate, LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstShl(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
}
version(!LLVMVersion20AndAbove) {
	fn LLVMX86MMXType() LLVMTypeRef;
	fn LLVMX86MMXTypeInContext(C: LLVMContextRef) LLVMTypeRef;
}
version(!LLVMVersion21AndAbove) {
	fn LLVMConstMul(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstNSWMul(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
	fn LLVMConstNUWMul(LHSConstant: LLVMValueRef, RHSConstant: LLVMValueRef) LLVMValueRef;
}
version(LLVMVersion11AndAbove) {
	fn LLVMBFloatType() LLVMTypeRef;
	fn LLVMBFloatTypeInContext(C: LLVMContextRef) LLVMTypeRef;
	fn LLVMGetMaskValue(ShuffleVectorInst: LLVMValueRef, Elt: u32) i32;
	fn LLVMGetNumMaskElements(ShuffleVectorInst: LLVMValueRef) u32;
	fn LLVMGetUndefMaskElem() i32;
}
version(LLVMVersion12AndAbove) {
	fn LLVMCreateTypeAttribute(C: LLVMContextRef, KindID: u32, type_ref: LLVMTypeRef) LLVMAttributeRef;
	fn LLVMGetPoison(Ty: LLVMTypeRef) LLVMValueRef;
	fn LLVMGetTypeAttributeValue(A: LLVMAttributeRef) LLVMTypeRef;
	fn LLVMGetTypeByName2(C: LLVMContextRef, Name: const(char)*) LLVMTypeRef;
	fn LLVMIsAPoisonValue(Val: LLVMValueRef) LLVMValueRef;
	fn LLVMIsPoison(Val: LLVMValueRef) LLVMBool;
	fn LLVMIsTypeAttribute(A: LLVMAttributeRef) LLVMBool;
	fn LLVMScalableVectorType(ElementType: LLVMTypeRef, ElementCount: u32) LLVMTypeRef;
	fn LLVMX86AMXType() LLVMTypeRef;
	fn LLVMX86AMXTypeInContext(C: LLVMContextRef) LLVMTypeRef;
}
version(LLVMVersion13AndAbove) {
	fn LLVMIntrinsicCopyOverloadedName2(Mod: LLVMModuleRef, ID: u32, ParamTypes: LLVMTypeRef*, ParamCount: size_t, NameLength: size_t*) char*;
}
version(LLVMVersion14AndAbove) {
	fn LLVMAddAlias2(M: LLVMModuleRef, ValueTy: LLVMTypeRef, AddrSpace: u32, Aliasee: LLVMValueRef, Name: const(char)*) LLVMValueRef;
	fn LLVMAddMetadataToInst(Builder: LLVMBuilderRef, Inst: LLVMValueRef);
	fn LLVMBuildPtrDiff2(LLVMBuilderRef, ElemTy: LLVMTypeRef, LHS: LLVMValueRef, RHS: LLVMValueRef, Name: const(char)*) LLVMValueRef;
	fn LLVMGetGEPSourceElementType(GEP: LLVMValueRef) LLVMTypeRef;
}
version(LLVMVersion15AndAbove) {
	fn LLVMDeleteInstruction(Inst: LLVMValueRef);
	fn LLVMGetAggregateElement(C: LLVMValueRef, Idx: u32) LLVMValueRef;
	fn LLVMGetCastOpcode(Src: LLVMValueRef, SrcIsSigned: LLVMBool, DestTy: LLVMTypeRef, DestIsSigned: LLVMBool) LLVMOpcode;
	fn LLVMPointerTypeInContext(C: LLVMContextRef, AddressSpace: u32) LLVMTypeRef;
	fn LLVMPointerTypeIsOpaque(Ty: LLVMTypeRef) LLVMBool;
}
version(LLVMVersion17AndAbove) {
	// Removed
} else version(LLVMVersion15AndAbove) {
	fn LLVMContextSetOpaquePointers(C: LLVMContextRef, OpaquePointers: LLVMBool);
}
version(LLVMVersion16AndAbove) {
	fn LLVMGetVersion(Major: u32*, Minor: u32*, Patch: u32*);
	fn LLVMTargetExtTypeInContext(C: LLVMContextRef, Name: const(char)*, TypeParams: LLVMTypeRef*, TypeParamCount: u32, IntParams: u32*, IntParamCount: u32) LLVMTypeRef;
}
version(LLVMVersion17AndAbove) {
	fn LLVMArrayType2(ElementType: LLVMTypeRef, ElementCount: u64) LLVMTypeRef;
	fn LLVMConstArray2(ElementTy: LLVMTypeRef, ConstantVals: LLVMValueRef*, Length: u64) LLVMValueRef;
	fn LLVMGetArrayLength2(ArrayTy: LLVMTypeRef) u64;
	fn LLVMGetExact(DivOrShrInst: LLVMValueRef) LLVMBool;
	fn LLVMGetNSW(ArithInst: LLVMValueRef) LLVMBool;
	fn LLVMGetNUW(ArithInst: LLVMValueRef) LLVMBool;
	fn LLVMIsAValueAsMetadata(Val: LLVMValueRef) LLVMValueRef;
	fn LLVMReplaceMDNodeOperandWith(V: LLVMValueRef, Index: u32, Replacement: LLVMMetadataRef);
	fn LLVMSetExact(DivOrShrInst: LLVMValueRef, IsExact: LLVMBool);
	fn LLVMSetNSW(ArithInst: LLVMValueRef, HasNSW: LLVMBool);
	fn LLVMSetNUW(ArithInst: LLVMValueRef, HasNUW: LLVMBool);
}
version(LLVMVersion18AndAbove) {
	fn LLVMBuildCallWithOperandBundles(LLVMBuilderRef, LLVMTypeRef, Fn: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Bundles: LLVMOperandBundleRef*, NumBundles: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildInvokeWithOperandBundles(LLVMBuilderRef, Ty: LLVMTypeRef, Fn: LLVMValueRef, Args: LLVMValueRef*, NumArgs: u32, Then: LLVMBasicBlockRef, Catch: LLVMBasicBlockRef, Bundles: LLVMOperandBundleRef*, NumBundles: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMCanValueUseFastMathFlags(Inst: LLVMValueRef) LLVMBool;
	fn LLVMCreateOperandBundle(Tag: const(char)*, TagLen: size_t, Args: LLVMValueRef*, NumArgs: u32) LLVMOperandBundleRef;
	fn LLVMDisposeOperandBundle(Bundle: LLVMOperandBundleRef);
	fn LLVMGetFastMathFlags(FPMathInst: LLVMValueRef) LLVMFastMathFlags;
	fn LLVMGetInlineAsmAsmString(InlineAsmVal: LLVMValueRef, Len: size_t*) const(char)*;
	fn LLVMGetInlineAsmCanUnwind(InlineAsmVal: LLVMValueRef) LLVMBool;
	fn LLVMGetInlineAsmConstraintString(InlineAsmVal: LLVMValueRef, Len: size_t*) const(char)*;
	fn LLVMGetInlineAsmDialect(InlineAsmVal: LLVMValueRef) LLVMInlineAsmDialect;
	fn LLVMGetInlineAsmFunctionType(InlineAsmVal: LLVMValueRef) LLVMTypeRef;
	fn LLVMGetInlineAsmHasSideEffects(InlineAsmVal: LLVMValueRef) LLVMBool;
	fn LLVMGetInlineAsmNeedsAlignedStack(InlineAsmVal: LLVMValueRef) LLVMBool;
	fn LLVMGetIsDisjoint(Inst: LLVMValueRef) LLVMBool;
	fn LLVMGetNNeg(NonNegInst: LLVMValueRef) LLVMBool;
	fn LLVMGetNumOperandBundleArgs(Bundle: LLVMOperandBundleRef) u32;
	fn LLVMGetNumOperandBundles(C: LLVMValueRef) u32;
	fn LLVMGetOperandBundleArgAtIndex(Bundle: LLVMOperandBundleRef, Index: u32) LLVMValueRef;
	fn LLVMGetOperandBundleAtIndex(C: LLVMValueRef, Index: u32) LLVMOperandBundleRef;
	fn LLVMGetOperandBundleTag(Bundle: LLVMOperandBundleRef, Len: size_t*) const(char)*;
	fn LLVMGetTailCallKind(CallInst: LLVMValueRef) LLVMTailCallKind;
	fn LLVMSetFastMathFlags(FPMathInst: LLVMValueRef, FMF: LLVMFastMathFlags);
	fn LLVMSetIsDisjoint(Inst: LLVMValueRef, IsDisjoint: LLVMBool);
	fn LLVMSetNNeg(NonNegInst: LLVMValueRef, IsNonNeg: LLVMBool);
	fn LLVMSetTailCallKind(CallInst: LLVMValueRef, kind: LLVMTailCallKind);
}
version(LLVMVersion19AndAbove) {
	fn LLVMBuildCallBr(B: LLVMBuilderRef, Ty: LLVMTypeRef, Fn: LLVMValueRef, DefaultDest: LLVMBasicBlockRef, IndirectDests: LLVMBasicBlockRef*, NumIndirectDests: u32, Args: LLVMValueRef*, NumArgs: u32, Bundles: LLVMOperandBundleRef*, NumBundles: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMBuildGEPWithNoWrapFlags(B: LLVMBuilderRef, Ty: LLVMTypeRef, Pointer: LLVMValueRef, Indices: LLVMValueRef*, NumIndices: u32, Name: const(char)*, NoWrapFlags: LLVMGEPNoWrapFlags) LLVMValueRef;
	fn LLVMConstGEPWithNoWrapFlags(Ty: LLVMTypeRef, ConstantVal: LLVMValueRef, ConstantIndices: LLVMValueRef*, NumIndices: u32, NoWrapFlags: LLVMGEPNoWrapFlags) LLVMValueRef;
	fn LLVMConstStringInContext2(C: LLVMContextRef, Str: const(char)*, Length: size_t, DontNullTerminate: LLVMBool) LLVMValueRef;
	fn LLVMConstantPtrAuth(Ptr: LLVMValueRef, Key: LLVMValueRef, Disc: LLVMValueRef, AddrDisc: LLVMValueRef) LLVMValueRef;
	fn LLVMCreateConstantRangeAttribute(C: LLVMContextRef, KindID: u32, NumBits: u32, LowerWords: const(u64)*, UpperWords: const(u64)*) LLVMAttributeRef;
	fn LLVMGEPGetNoWrapFlags(GEP: LLVMValueRef) LLVMGEPNoWrapFlags;
	fn LLVMGEPSetNoWrapFlags(GEP: LLVMValueRef, NoWrapFlags: LLVMGEPNoWrapFlags);
	fn LLVMGetBlockAddressBasicBlock(BlockAddr: LLVMValueRef) LLVMBasicBlockRef;
	fn LLVMGetBlockAddressFunction(BlockAddr: LLVMValueRef) LLVMValueRef;
	fn LLVMGetCallBrDefaultDest(CallBr: LLVMValueRef) LLVMBasicBlockRef;
	fn LLVMGetCallBrIndirectDest(CallBr: LLVMValueRef, Idx: u32) LLVMBasicBlockRef;
	fn LLVMGetCallBrNumIndirectDests(CallBr: LLVMValueRef) u32;
	fn LLVMGetConstantPtrAuthAddrDiscriminator(PtrAuth: LLVMValueRef) LLVMValueRef;
	fn LLVMGetConstantPtrAuthDiscriminator(PtrAuth: LLVMValueRef) LLVMValueRef;
	fn LLVMGetConstantPtrAuthKey(PtrAuth: LLVMValueRef) LLVMValueRef;
	fn LLVMGetConstantPtrAuthPointer(PtrAuth: LLVMValueRef) LLVMValueRef;
	fn LLVMGetPrefixData(Fn: LLVMValueRef) LLVMValueRef;
	fn LLVMGetPrologueData(Fn: LLVMValueRef) LLVMValueRef;
	fn LLVMGetTargetExtTypeIntParam(TargetExtTy: LLVMTypeRef, Idx: u32) u32;
	fn LLVMGetTargetExtTypeName(TargetExtTy: LLVMTypeRef) const(char)*;
	fn LLVMGetTargetExtTypeNumIntParams(TargetExtTy: LLVMTypeRef) u32;
	fn LLVMGetTargetExtTypeNumTypeParams(TargetExtTy: LLVMTypeRef) u32;
	fn LLVMGetTargetExtTypeTypeParam(TargetExtTy: LLVMTypeRef, Idx: u32) LLVMTypeRef;
	fn LLVMHasPrefixData(Fn: LLVMValueRef) LLVMBool;
	fn LLVMHasPrologueData(Fn: LLVMValueRef) LLVMBool;
	fn LLVMIsAConstantPtrAuth(Val: LLVMValueRef) LLVMValueRef;
	fn LLVMIsNewDbgInfoFormat(M: LLVMModuleRef) LLVMBool;
	fn LLVMPositionBuilderBeforeDbgRecords(Builder: LLVMBuilderRef, Block: LLVMBasicBlockRef, Inst: LLVMValueRef);
	fn LLVMPositionBuilderBeforeInstrAndDbgRecords(Builder: LLVMBuilderRef, Instr: LLVMValueRef);
	fn LLVMPrintDbgRecordToString(Record: LLVMDbgRecordRef) char*;
	fn LLVMSetIsNewDbgInfoFormat(M: LLVMModuleRef, UseNewFormat: LLVMBool);
	fn LLVMSetPrefixData(Fn: LLVMValueRef, prefixData: LLVMValueRef);
	fn LLVMSetPrologueData(Fn: LLVMValueRef, prologueData: LLVMValueRef);
}
version(LLVMVersion20AndAbove) {
	fn LLVMBuildAtomicCmpXchgSyncScope(B: LLVMBuilderRef, Ptr: LLVMValueRef, Cmp: LLVMValueRef, New: LLVMValueRef, SuccessOrdering: LLVMAtomicOrdering, FailureOrdering: LLVMAtomicOrdering, SSID: u32) LLVMValueRef;
	fn LLVMBuildAtomicRMWSyncScope(B: LLVMBuilderRef, op: LLVMAtomicRMWBinOp, PTR: LLVMValueRef, Val: LLVMValueRef, ordering: LLVMAtomicOrdering, SSID: u32) LLVMValueRef;
	fn LLVMBuildFenceSyncScope(B: LLVMBuilderRef, ordering: LLVMAtomicOrdering, SSID: u32, Name: const(char)*) LLVMValueRef;
	fn LLVMGetAtomicSyncScopeID(AtomicInst: LLVMValueRef) u32;
	fn LLVMGetBuilderContext(Builder: LLVMBuilderRef) LLVMContextRef;
	fn LLVMGetFirstDbgRecord(Inst: LLVMValueRef) LLVMDbgRecordRef;
	fn LLVMGetLastDbgRecord(Inst: LLVMValueRef) LLVMDbgRecordRef;
	fn LLVMGetNamedFunctionWithLength(M: LLVMModuleRef, Name: const(char)*, Length: size_t) LLVMValueRef;
	fn LLVMGetNamedGlobalWithLength(M: LLVMModuleRef, Name: const(char)*, Length: size_t) LLVMValueRef;
	fn LLVMGetNextDbgRecord(DbgRecord: LLVMDbgRecordRef) LLVMDbgRecordRef;
	fn LLVMGetPreviousDbgRecord(DbgRecord: LLVMDbgRecordRef) LLVMDbgRecordRef;
	fn LLVMGetSyncScopeID(C: LLVMContextRef, Name: const(char)*, SLen: size_t) u32;
	fn LLVMGetValueContext(Val: LLVMValueRef) LLVMContextRef;
	fn LLVMIsAtomic(Inst: LLVMValueRef) LLVMBool;
	fn LLVMSetAtomicSyncScopeID(AtomicInst: LLVMValueRef, SSID: u32);
}
version(LLVMVersion21AndAbove) {
	fn LLVMConstDataArray(ElementTy: LLVMTypeRef, Data: const(char)*, SizeInBytes: size_t) LLVMValueRef;
	fn LLVMGetICmpSameSign(Inst: LLVMValueRef) LLVMBool;
	fn LLVMGetRawDataValues(c: LLVMValueRef, SizeInBytes: size_t*) const(char)*;
	fn LLVMSetICmpSameSign(Inst: LLVMValueRef, SameSign: LLVMBool);
}
