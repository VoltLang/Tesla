// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module tesla.polyfill.funcs;

import lib.llvm;


struct InbuiltFuncs
{
public:
	fnI32DivU: LLVMValueRef;
	fnI32DivS: LLVMValueRef;
	fnI32RemU: LLVMValueRef;
	fnI32RemS: LLVMValueRef;
	fnI32Clz: LLVMValueRef;
	fnI32Ctz: LLVMValueRef;
	fnI32Rotl: LLVMValueRef;
	fnI32Rotr: LLVMValueRef;

	fnI64DivU: LLVMValueRef;
	fnI64DivS: LLVMValueRef;
	fnI64RemU: LLVMValueRef;
	fnI64RemS: LLVMValueRef;
	fnI64Clz: LLVMValueRef;
	fnI64Ctz: LLVMValueRef;
	fnI64Rotl: LLVMValueRef;
	fnI64Rotr: LLVMValueRef;

	fnF32Div: LLVMValueRef;
	fnF64Div: LLVMValueRef;

	fnI32Load: LLVMValueRef;
	fnI64Load: LLVMValueRef;
	fnF32Load: LLVMValueRef;
	fnF64Load: LLVMValueRef;
	fnI32Load8S: LLVMValueRef;
	fnI32Load8U: LLVMValueRef;
	fnI32Load16S: LLVMValueRef;
	fnI32Load16U: LLVMValueRef;
	fnI64Load8S: LLVMValueRef;
	fnI64Load8U: LLVMValueRef;
	fnI64Load16S: LLVMValueRef;
	fnI64Load16U: LLVMValueRef;
	fnI64Load32S: LLVMValueRef;
	fnI64Load32U: LLVMValueRef;
	fnI32Store: LLVMValueRef;
	fnI64Store: LLVMValueRef;
	fnF32Store: LLVMValueRef;
	fnF64Store: LLVMValueRef;
	fnI32Store8: LLVMValueRef;
	fnI32Store16: LLVMValueRef;
	fnI64Store8: LLVMValueRef;
	fnI64Store16: LLVMValueRef;
	fnI64Store32: LLVMValueRef;

	fnI32TruncSF32: LLVMValueRef;
	fnI32TruncUF32: LLVMValueRef;
	fnI32TruncSF64: LLVMValueRef;
	fnI32TruncUF64: LLVMValueRef;
	fnI64TruncSF32: LLVMValueRef;
	fnI64TruncUF32: LLVMValueRef;
	fnI64TruncSF64: LLVMValueRef;
	fnI64TruncUF64: LLVMValueRef;
	fnF32DemoteF64: LLVMValueRef;

	fn_ctpop_i32: LLVMValueRef;
	fn_ctpop_i64: LLVMValueRef;
	fn_fabs_f32: LLVMValueRef;
	fn_ceil_f32: LLVMValueRef;
	fn_floor_f32: LLVMValueRef;
	fn_trunc_f32: LLVMValueRef;
	fn_nearbyint_f32: LLVMValueRef;
	fn_sqrt_f32: LLVMValueRef;
	fn_minnum_f32: LLVMValueRef;
	fn_maxnum_f32: LLVMValueRef;
	fn_copysign_f32: LLVMValueRef;
	fn_fabs_f64: LLVMValueRef;
	fn_ceil_f64: LLVMValueRef;
	fn_floor_f64: LLVMValueRef;
	fn_trunc_f64: LLVMValueRef;
	fn_nearbyint_f64: LLVMValueRef;
	fn_sqrt_f64: LLVMValueRef;
	fn_minnum_f64: LLVMValueRef;
	fn_maxnum_f64: LLVMValueRef;
	fn_copysign_f64: LLVMValueRef;


public:
	fn setup(mod: LLVMModuleRef,
	         typeVoid: LLVMTypeRef,
	         typeI32: LLVMTypeRef,
	         typeI64: LLVMTypeRef,
	         typeF32: LLVMTypeRef,
	         typeF64: LLVMTypeRef)
	{
		argsI32: LLVMTypeRef[1];
		argsI32[0] = typeI32;

		argsI64: LLVMTypeRef[1];
		argsI64[0] = typeI64;

		argsF32: LLVMTypeRef[1];
		argsF32[0] = typeF32;

		argsF64: LLVMTypeRef[1];
		argsF64[0] = typeF64;

		argsI32I32: LLVMTypeRef[2];
		argsI32I32[0] = typeI32;
		argsI32I32[1] = typeI32;

		argsI64I64: LLVMTypeRef[2];
		argsI64I64[0] = typeI64;
		argsI64I64[1] = typeI64;

		argsF32F32: LLVMTypeRef[2];
		argsF32F32[0] = typeF32;
		argsF32F32[1] = typeF32;

		argsF64F64: LLVMTypeRef[2];
		argsF64F64[0] = typeF64;
		argsF64F64[1] = typeF64;

		argsI32I64: LLVMTypeRef[2];
		argsI32I64[0] = typeI32;
		argsI32I64[1] = typeI64;

		argsI32F32: LLVMTypeRef[2];
		argsI32F32[0] = typeI32;
		argsI32F32[1] = typeF32;

		argsI32F64: LLVMTypeRef[2];
		argsI32F64[0] = typeI32;
		argsI32F64[1] = typeF64;

		unaryI32 := LLVMFunctionType(typeI32, argsI32, false);
		unaryI64 := LLVMFunctionType(typeI64, argsI64, false);
		unaryF32 := LLVMFunctionType(typeF32, argsF32, false);
		unaryF64 := LLVMFunctionType(typeF64, argsF64, false);
		binI32 := LLVMFunctionType(typeI32, argsI32I32, false);
		binI64 := LLVMFunctionType(typeI64, argsI64I64, false);
		binF32 := LLVMFunctionType(typeF32, argsF32F32, false);
		binF64 := LLVMFunctionType(typeF64, argsF64F64, false);
		loadI32 := LLVMFunctionType(typeI32, argsI32, false);
		loadI64 := LLVMFunctionType(typeI64, argsI32, false);
		loadF32 := LLVMFunctionType(typeF32, argsI32, false);
		loadF64 := LLVMFunctionType(typeF64, argsI32, false);
		storeI32 := LLVMFunctionType(typeVoid, argsI32I32, false);
		storeI64 := LLVMFunctionType(typeVoid, argsI32I64, false);
		storeF32 := LLVMFunctionType(typeVoid, argsI32F32, false);
		storeF64 := LLVMFunctionType(typeVoid, argsI32F64, false);

		fnI32DivU = LLVMAddFunction(mod, "__tesla_op_i32_div_u", binI32);
		fnI32DivS = LLVMAddFunction(mod, "__tesla_op_i32_div_s", binI32);
		fnI32RemU = LLVMAddFunction(mod, "__tesla_op_i32_rem_u", binI32);
		fnI32RemS = LLVMAddFunction(mod, "__tesla_op_i32_rem_s", binI32);
		fnI32Clz = LLVMAddFunction(mod, "__tesla_op_i32_clz", unaryI32);
		fnI32Ctz = LLVMAddFunction(mod, "__tesla_op_i32_ctz", unaryI32);
		fnI32Rotl = LLVMAddFunction(mod, "__tesla_op_i32_rotl", binI32);
		fnI32Rotr = LLVMAddFunction(mod, "__tesla_op_i32_rotr", binI32);

		fnI64DivU = LLVMAddFunction(mod, "__tesla_op_i64_div_u", binI64);
		fnI64DivS = LLVMAddFunction(mod, "__tesla_op_i64_div_s", binI64);
		fnI64RemU = LLVMAddFunction(mod, "__tesla_op_i64_rem_u", binI64);
		fnI64RemS = LLVMAddFunction(mod, "__tesla_op_i64_rem_s", binI64);
		fnI64Clz = LLVMAddFunction(mod, "__tesla_op_i64_clz", unaryI64);
		fnI64Ctz = LLVMAddFunction(mod, "__tesla_op_i64_ctz", unaryI64);
		fnI64Rotl = LLVMAddFunction(mod, "__tesla_op_i64_rotl", binI64);
		fnI64Rotr = LLVMAddFunction(mod, "__tesla_op_i64_rotr", binI64);

		fnF32Div = LLVMAddFunction(mod, "__tesla_op_f32_div", binF32);
		fnF64Div = LLVMAddFunction(mod, "__tesla_op_f64_div", binF64);

		fnI32Load = LLVMAddFunction(mod, "__tesla_op_i32_load", loadI32);
		fnI64Load = LLVMAddFunction(mod, "__tesla_op_i64_load", loadI64);
		fnF32Load = LLVMAddFunction(mod, "__tesla_op_f32_load", loadF32);
		fnF64Load = LLVMAddFunction(mod, "__tesla_op_f64_load", loadF64);
		fnI32Load8S = LLVMAddFunction(mod, "__tesla_op_i32_load8_s", loadI32);
		fnI32Load8U = LLVMAddFunction(mod, "__tesla_op_i32_load8_u", loadI32);
		fnI32Load16S = LLVMAddFunction(mod, "__tesla_op_i32_load16_s", loadI32);
		fnI32Load16U = LLVMAddFunction(mod, "__tesla_op_i32_load16_u", loadI32);
		fnI64Load8S = LLVMAddFunction(mod, "__tesla_op_i64_load8_s", loadI64);
		fnI64Load8U = LLVMAddFunction(mod, "__tesla_op_i64_load8_u", loadI64);
		fnI64Load16S = LLVMAddFunction(mod, "__tesla_op_i64_load16_s", loadI64);
		fnI64Load16U = LLVMAddFunction(mod, "__tesla_op_i64_load16_u", loadI64);
		fnI64Load32S = LLVMAddFunction(mod, "__tesla_op_i64_load32_s", loadI64);
		fnI64Load32U = LLVMAddFunction(mod, "__tesla_op_i64_load32_u", loadI64);
		fnI32Store = LLVMAddFunction(mod, "__tesla_op_i32_store", storeI32);
		fnI64Store = LLVMAddFunction(mod, "__tesla_op_i64_store", storeI64);
		fnF32Store = LLVMAddFunction(mod, "__tesla_op_f32_store", storeF32);
		fnF64Store = LLVMAddFunction(mod, "__tesla_op_f64_store", storeF64);
		fnI32Store8 = LLVMAddFunction(mod, "__tesla_op_i32_store8", storeI32);
		fnI32Store16 = LLVMAddFunction(mod, "__tesla_op_i32_store16", storeI32);
		fnI64Store8 = LLVMAddFunction(mod, "__tesla_op_i64_store8", storeI64);
		fnI64Store16 = LLVMAddFunction(mod, "__tesla_op_i64_store16", storeI64);
		fnI64Store32 = LLVMAddFunction(mod, "__tesla_op_i64_store32", storeI64);

		fnI32TruncSF32 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_s_f32",
			LLVMFunctionType(typeI32, argsF32, false));
		fnI32TruncUF32 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_u_f32",
			LLVMFunctionType(typeI32, argsF32, false));
		fnI32TruncSF64 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_s_f64",
			LLVMFunctionType(typeI32, argsF64, false));
		fnI32TruncUF64 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_u_f64",
			LLVMFunctionType(typeI32, argsF64, false));
		fnI64TruncSF32 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_s_f32",
			LLVMFunctionType(typeI64, argsF32, false));
		fnI64TruncUF32 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_u_f32",
			LLVMFunctionType(typeI64, argsF32, false));
		fnI64TruncSF64 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_s_f64",
			LLVMFunctionType(typeI64, argsF64, false));
		fnI64TruncUF64 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_u_f64",
			LLVMFunctionType(typeI64, argsF64, false));
		fnF32DemoteF64 = LLVMAddFunction(mod, "__tesla_op_f32_Demote_f64",
			LLVMFunctionType(typeF32, argsF64, false));

		fn_ctpop_i32 = LLVMAddFunction(mod, "llvm.ctpop.i32", unaryI32);
		fn_ctpop_i64 = LLVMAddFunction(mod, "llvm.ctpop.i64", unaryI64);

		fn_fabs_f32 = LLVMAddFunction(mod, "llvm.fabs.f32", unaryF32);
		fn_ceil_f32 = LLVMAddFunction(mod, "llvm.ceil.f32", unaryF32);
		fn_floor_f32 = LLVMAddFunction(mod, "llvm.floor.f32", unaryF32);
		fn_trunc_f32 = LLVMAddFunction(mod, "llvm.trunc.f32", unaryF32);
		fn_nearbyint_f32 = LLVMAddFunction(mod, "llvm.nearbyint.f32", unaryF32);
		fn_sqrt_f32 = LLVMAddFunction(mod, "llvm.sqrt.f32", unaryF32);
		fn_minnum_f32 = LLVMAddFunction(mod, "llvm.minnum.f32", binF32);
		fn_maxnum_f32 = LLVMAddFunction(mod, "llvm.maxnum.f32", binF32);
		fn_copysign_f32 = LLVMAddFunction(mod, "llvm.copysign.f32", binF32);
		fn_fabs_f64 = LLVMAddFunction(mod, "llvm.fabs.f64", unaryF64);
		fn_ceil_f64 = LLVMAddFunction(mod, "llvm.ceil.f64", unaryF64);
		fn_floor_f64 = LLVMAddFunction(mod, "llvm.floor.f64", unaryF64);
		fn_trunc_f64 = LLVMAddFunction(mod, "llvm.trunc.f64", unaryF64);
		fn_nearbyint_f64 = LLVMAddFunction(mod, "llvm.nearbyint.f64", unaryF64);
		fn_sqrt_f64 = LLVMAddFunction(mod, "llvm.sqrt.f64", unaryF64);
		fn_minnum_f64 = LLVMAddFunction(mod, "llvm.minnum.f64", binF64);
		fn_maxnum_f64 = LLVMAddFunction(mod, "llvm.maxnum.f64", binF64);
		fn_copysign_f64 = LLVMAddFunction(mod, "llvm.copysign.f64", binF64);
	}
}
