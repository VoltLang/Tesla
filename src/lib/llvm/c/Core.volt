// See copyright notice and license in src/lib/llvm/core.volt.
module lib.llvm.c.Core;

alias LLVMBool = int;

struct LLVMContext {}
alias  LLVMContextRef = LLVMContext*;
struct LLVMModule {}
alias  LLVMModuleRef = LLVMModule*;
struct LLVMType {}
alias  LLVMTypeRef = LLVMType*;
struct LLVMValue {}
alias  LLVMValueRef = LLVMValue*;
struct LLVMAttributeImpl {}
alias  LLVMAttributeRef = LLVMAttributeImpl*;
struct LLVMBasicBlock {}
alias  LLVMBasicBlockRef = LLVMBasicBlock*;
struct LLVMBuilder {}
alias  LLVMBuilderRef = LLVMBuilder*;


enum LLVMOpcode {
	/* Terminator Instructions */
	Ret            = 1,
	Br             = 2,
	Switch         = 3,
	IndirectBr     = 4,
	Invoke         = 5,
	/* removed 6 due to API changes */
	Unreachable    = 7,

	/* Standard Binary Operators */
	Add            = 8,
	FAdd           = 9,
	Sub            = 10,
	FSub           = 11,
	Mul            = 12,
	FMul           = 13,
	UDiv           = 14,
	SDiv           = 15,
	FDiv           = 16,
	URem           = 17,
	SRem           = 18,
	FRem           = 19,

	/* Logical Operators */
	Shl            = 20,
	LShr           = 21,
	AShr           = 22,
	And            = 23,
	Or             = 24,
	Xor            = 25,

	/* Memory Operators */
	Alloca         = 26,
	Load           = 27,
	Store          = 28,
	GetElementPtr  = 29,

	/* Cast Operators */
	Trunc          = 30,
	ZExt           = 31,
	SExt           = 32,
	FPToUI         = 33,
	FPToSI         = 34,
	UIToFP         = 35,
	SIToFP         = 36,
	FPTrunc        = 37,
	FPExt          = 38,
	PtrToInt       = 39,
	IntToPtr       = 40,
	BitCast        = 41,
	AddrSpaceCast  = 60,

	/* Other Operators */
	ICmp           = 42,
	FCmp           = 43,
	PHI            = 44,
	Call           = 45,
	Select         = 46,
	UserOp1        = 47,
	UserOp2        = 48,
	VAArg          = 49,
	ExtractElement = 50,
	InsertElement  = 51,
	ShuffleVector  = 52,
	ExtractValue   = 53,
	InsertValue    = 54,

	/* Atomic operators */
	Fence          = 55,
	AtomicCmpXchg  = 56,
	AtomicRMW      = 57,

	/* Exception Handling Operators */
	Resume         = 58,
	LandingPad     = 59,
	CleanupRet     = 61,
	CatchRet       = 62,
	CatchPad       = 63,
	CleanupPad     = 64,
	CatchSwitch    = 65
}

enum LLVMIntPredicate
{
	EQ = 32, /**< equal */
	NE,      /**< not equal */
	UGT,     /**< unsigned greater than */
	UGE,     /**< unsigned greater or equal */
	ULT,     /**< unsigned less than */
	ULE,     /**< unsigned less or equal */
	SGT,     /**< signed greater than */
	SGE,     /**< signed greater or equal */
	SLT,     /**< signed less than */
	SLE      /**< signed less or equal */
}

enum LLVMRealPredicate
{
	PredicateFalse, /**< Always false (always folded) */
	OEQ,            /**< True if ordered and equal */
	OGT,            /**< True if ordered and greater than */
	OGE,            /**< True if ordered and greater than or equal */
	OLT,            /**< True if ordered and less than */
	OLE,            /**< True if ordered and less than or equal */
	ONE,            /**< True if ordered and operands are unequal */
	ORD,            /**< True if ordered (no nans) */
	UNO,            /**< True if unordered: isnan(X) | isnan(Y) */
	UEQ,            /**< True if unordered or equal */
	UGT,            /**< True if unordered or greater than */
	UGE,            /**< True if unordered, greater than, or equal */
	ULT,            /**< True if unordered or less than */
	ULE,            /**< True if unordered, less than, or equal */
	UNE,            /**< True if unordered or not equal */
	PredicateTrue   /**< Always true (always folded) */
}

extern(C):

fn LLVMContextCreate() LLVMContextRef;
fn LLVMModuleCreateWithNameInContext(const(char)*, LLVMContextRef) LLVMModuleRef;
fn LLVMContextDispose(LLVMContextRef);
fn LLVMModuleCreateWithName(const(char)*) LLVMModuleRef;
fn LLVMDisposeModule(LLVMModuleRef);
fn LLVMSetDataLayout(LLVMModuleRef, const(char)*);
fn LLVMSetTarget(LLVMModuleRef, const(char)*);
fn LLVMDumpModule(LLVMModuleRef);
fn LLVMCreateMessage(const(char)*) const(char)*;
fn LLVMDisposeMessage(const(char)*);
fn LLVMAddFunction(LLVMModuleRef, const(char)*, LLVMTypeRef) LLVMValueRef;
fn LLVMGetParam(LLVMValueRef, u32) LLVMValueRef;

// Dumpers
fn LLVMDumpType(LLVMTypeRef);
fn LLVMDumpValue(LLVMValueRef);
fn LLVMDumpModule(LLVMModuleRef);
fn LLVMPrintTypeToString(LLVMTypeRef) const(char)*;
fn LLVMPrintValueToString(LLVMValueRef) const(char)*;
fn LLVMPrintModuleToString(LLVMModuleRef) const(char)*;

// Types
fn LLVMVoidTypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMInt1TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMInt8TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMInt16TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMInt32TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMInt64TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMInt128TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMIntTypeInContext(LLVMContextRef, u32) LLVMTypeRef;
fn LLVMGetIntTypeWidth(LLVMTypeRef) u32;
fn LLVMHalfTypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMFloatTypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMDoubleTypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMX86FP80TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMFP128TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMPPCFP128TypeInContext(LLVMContextRef) LLVMTypeRef;
fn LLVMFunctionType(LLVMTypeRef, LLVMTypeRef*, u32, LLVMBool) LLVMTypeRef;

// Const
fn LLVMConstInt(LLVMTypeRef, u64, LLVMBool) LLVMValueRef;

// Builder
fn LLVMCreateBuilderInContext(LLVMContextRef) LLVMBuilderRef;
fn LLVMPositionBuilder(LLVMBuilderRef, LLVMBasicBlockRef, LLVMValueRef);
fn LLVMPositionBuilderBefore(LLVMBuilderRef, LLVMValueRef);
fn LLVMPositionBuilderAtEnd(LLVMBuilderRef, LLVMBasicBlockRef);
fn LLVMGetInsertBlock(LLVMBuilderRef) LLVMBasicBlockRef;
fn LLVMClearInsertionPosition(LLVMBuilderRef);
fn LLVMInsertIntoBuilder(LLVMBuilderRef, LLVMValueRef);
fn LLVMInsertIntoBuilderWithName(LLVMBuilderRef, LLVMValueRef, const(char)*);
fn LLVMDisposeBuilder(LLVMBuilderRef);

// Basic block
fn LLVMAppendBasicBlockInContext(LLVMContextRef, LLVMValueRef, const(char)*) LLVMBasicBlockRef;
fn LLVMAddIncoming(LLVMValueRef, LLVMValueRef*, LLVMBasicBlockRef*, u32);
fn LLVMMoveBasicBlockAfter(LLVMBasicBlockRef, LLVMBasicBlockRef);
fn LLVMMoveBasicBlockBefore(LLVMBasicBlockRef, LLVMBasicBlockRef);
fn LLVMCountBasicBlocks(LLVMValueRef) u32;
fn LLVMGetBasicBlocks(LLVMValueRef, LLVMBasicBlockRef*);
fn LLVMGetFirstBasicBlock(LLVMValueRef) LLVMBasicBlockRef;
fn LLVMGetLastBasicBlock(LLVMValueRef) LLVMBasicBlockRef;

// Build
fn LLVMBuildCall(LLVMBuilderRef, LLVMValueRef, LLVMValueRef*, uint, const(char)*) LLVMValueRef;
fn LLVMBuildRetVoid(LLVMBuilderRef) LLVMValueRef;
fn LLVMBuildRet(LLVMBuilderRef, LLVMValueRef) LLVMValueRef;
fn LLVMBuildAlloca(LLVMBuilderRef, LLVMTypeRef, const(char)*) LLVMValueRef;
fn LLVMBuildLoad(LLVMBuilderRef, LLVMValueRef, const(char)*) LLVMValueRef;
fn LLVMBuildStore(LLVMBuilderRef, LLVMValueRef, LLVMValueRef) LLVMValueRef;
fn LLVMBuildTruncOrBitCast(LLVMBuilderRef, LLVMValueRef,
                           LLVMTypeRef, const(char)*) LLVMValueRef;
fn LLVMBuildBinOp(LLVMBuilderRef, LLVMOpcode,
                  LLVMValueRef, LLVMValueRef, const(char)*) LLVMValueRef;
fn LLVMBuildICmp(LLVMBuilderRef, LLVMIntPredicate,
                 LLVMValueRef, LLVMValueRef, const(char)*) LLVMValueRef;
fn LLVMBuildFCmp(LLVMBuilderRef, LLVMRealPredicate,
                 LLVMValueRef, LLVMValueRef, const(char)*) LLVMValueRef;
fn LLVMBuildUnreachable(LLVMBuilderRef) LLVMValueRef;
fn LLVMBuildBr(LLVMBuilderRef, LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBuildCondBr(LLVMBuilderRef, LLVMValueRef,
                   LLVMBasicBlockRef, LLVMBasicBlockRef) LLVMValueRef;
fn LLVMBuildPhi(LLVMBuilderRef, LLVMTypeRef, const(char)*) LLVMValueRef;
fn LLVMBuildSelect(LLVMBuilderRef, LLVMValueRef,
                   LLVMValueRef, LLVMValueRef, const(char)*) LLVMValueRef;
