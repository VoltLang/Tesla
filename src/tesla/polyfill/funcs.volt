// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module tesla.polyfill.funcs;

import lib.llvm;


struct InbuiltFuncs
{
public:
	typeUnaryI32: LLVMTypeRef;
	typeUnaryI64: LLVMTypeRef;
	typeUnaryF32: LLVMTypeRef;
	typeUnaryF64: LLVMTypeRef;
	typeBinI32: LLVMTypeRef;
	typeBinI64: LLVMTypeRef;
	typeBinF32: LLVMTypeRef;
	typeBinF64: LLVMTypeRef;
	typeLoadI32: LLVMTypeRef;
	typeLoadI64: LLVMTypeRef;
	typeLoadF32: LLVMTypeRef;
	typeLoadF64: LLVMTypeRef;
	typeStoreI32: LLVMTypeRef;
	typeStoreI64: LLVMTypeRef;
	typeStoreF32: LLVMTypeRef;
	typeStoreF64: LLVMTypeRef;
	typeI32TruncSF32: LLVMTypeRef;
	typeI32TruncUF32: LLVMTypeRef;
	typeI32TruncSF64: LLVMTypeRef;
	typeI32TruncUF64: LLVMTypeRef;
	typeI64TruncSF32: LLVMTypeRef;
	typeI64TruncUF32: LLVMTypeRef;
	typeI64TruncSF64: LLVMTypeRef;
	typeI64TruncUF64: LLVMTypeRef;
	typeF32DemoteF64: LLVMTypeRef;

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

		typeUnaryI32 = LLVMFunctionType(typeI32, argsI32, false);
		typeUnaryI64 = LLVMFunctionType(typeI64, argsI64, false);
		typeUnaryF32 = LLVMFunctionType(typeF32, argsF32, false);
		typeUnaryF64 = LLVMFunctionType(typeF64, argsF64, false);
		typeBinI32 = LLVMFunctionType(typeI32, argsI32I32, false);
		typeBinI64 = LLVMFunctionType(typeI64, argsI64I64, false);
		typeBinF32 = LLVMFunctionType(typeF32, argsF32F32, false);
		typeBinF64 = LLVMFunctionType(typeF64, argsF64F64, false);
		typeLoadI32 = LLVMFunctionType(typeI32, argsI32, false);
		typeLoadI64 = LLVMFunctionType(typeI64, argsI32, false);
		typeLoadF32 = LLVMFunctionType(typeF32, argsI32, false);
		typeLoadF64 = LLVMFunctionType(typeF64, argsI32, false);
		typeStoreI32 = LLVMFunctionType(typeVoid, argsI32I32, false);
		typeStoreI64 = LLVMFunctionType(typeVoid, argsI32I64, false);
		typeStoreF32 = LLVMFunctionType(typeVoid, argsI32F32, false);
		typeStoreF64 = LLVMFunctionType(typeVoid, argsI32F64, false);
		typeI32TruncSF32 = LLVMFunctionType(typeI32, argsF32, false);
		typeI32TruncUF32 = LLVMFunctionType(typeI32, argsF32, false);
		typeI32TruncSF64 = LLVMFunctionType(typeI32, argsF64, false);
		typeI32TruncUF64 = LLVMFunctionType(typeI32, argsF64, false);
		typeI64TruncSF32 = LLVMFunctionType(typeI64, argsF32, false);
		typeI64TruncUF32 = LLVMFunctionType(typeI64, argsF32, false);
		typeI64TruncSF64 = LLVMFunctionType(typeI64, argsF64, false);
		typeI64TruncUF64 = LLVMFunctionType(typeI64, argsF64, false);
		typeF32DemoteF64 = LLVMFunctionType(typeF32, argsF64, false);

		fnI32DivU = LLVMAddFunction(mod, "__tesla_op_i32_div_u", typeBinI32);
		fnI32DivS = LLVMAddFunction(mod, "__tesla_op_i32_div_s", typeBinI32);
		fnI32RemU = LLVMAddFunction(mod, "__tesla_op_i32_rem_u", typeBinI32);
		fnI32RemS = LLVMAddFunction(mod, "__tesla_op_i32_rem_s", typeBinI32);
		fnI32Clz = LLVMAddFunction(mod, "__tesla_op_i32_clz", typeUnaryI32);
		fnI32Ctz = LLVMAddFunction(mod, "__tesla_op_i32_ctz", typeUnaryI32);
		fnI32Rotl = LLVMAddFunction(mod, "__tesla_op_i32_rotl", typeBinI32);
		fnI32Rotr = LLVMAddFunction(mod, "__tesla_op_i32_rotr", typeBinI32);

		fnI64DivU = LLVMAddFunction(mod, "__tesla_op_i64_div_u", typeBinI64);
		fnI64DivS = LLVMAddFunction(mod, "__tesla_op_i64_div_s", typeBinI64);
		fnI64RemU = LLVMAddFunction(mod, "__tesla_op_i64_rem_u", typeBinI64);
		fnI64RemS = LLVMAddFunction(mod, "__tesla_op_i64_rem_s", typeBinI64);
		fnI64Clz = LLVMAddFunction(mod, "__tesla_op_i64_clz", typeUnaryI64);
		fnI64Ctz = LLVMAddFunction(mod, "__tesla_op_i64_ctz", typeUnaryI64);
		fnI64Rotl = LLVMAddFunction(mod, "__tesla_op_i64_rotl", typeBinI64);
		fnI64Rotr = LLVMAddFunction(mod, "__tesla_op_i64_rotr", typeBinI64);

		fnF32Div = LLVMAddFunction(mod, "__tesla_op_f32_div", typeBinF32);
		fnF64Div = LLVMAddFunction(mod, "__tesla_op_f64_div", typeBinF64);

		fnI32Load = LLVMAddFunction(mod, "__tesla_op_i32_load", typeLoadI32);
		fnI64Load = LLVMAddFunction(mod, "__tesla_op_i64_load", typeLoadI64);
		fnF32Load = LLVMAddFunction(mod, "__tesla_op_f32_load", typeLoadF32);
		fnF64Load = LLVMAddFunction(mod, "__tesla_op_f64_load", typeLoadF64);
		fnI32Load8S = LLVMAddFunction(mod, "__tesla_op_i32_load8_s", typeLoadI32);
		fnI32Load8U = LLVMAddFunction(mod, "__tesla_op_i32_load8_u", typeLoadI32);
		fnI32Load16S = LLVMAddFunction(mod, "__tesla_op_i32_load16_s", typeLoadI32);
		fnI32Load16U = LLVMAddFunction(mod, "__tesla_op_i32_load16_u", typeLoadI32);
		fnI64Load8S = LLVMAddFunction(mod, "__tesla_op_i64_load8_s", typeLoadI64);
		fnI64Load8U = LLVMAddFunction(mod, "__tesla_op_i64_load8_u", typeLoadI64);
		fnI64Load16S = LLVMAddFunction(mod, "__tesla_op_i64_load16_s", typeLoadI64);
		fnI64Load16U = LLVMAddFunction(mod, "__tesla_op_i64_load16_u", typeLoadI64);
		fnI64Load32S = LLVMAddFunction(mod, "__tesla_op_i64_load32_s", typeLoadI64);
		fnI64Load32U = LLVMAddFunction(mod, "__tesla_op_i64_load32_u", typeLoadI64);
		fnI32Store = LLVMAddFunction(mod, "__tesla_op_i32_store", typeStoreI32);
		fnI64Store = LLVMAddFunction(mod, "__tesla_op_i64_store", typeStoreI64);
		fnF32Store = LLVMAddFunction(mod, "__tesla_op_f32_store", typeStoreF32);
		fnF64Store = LLVMAddFunction(mod, "__tesla_op_f64_store", typeStoreF64);
		fnI32Store8 = LLVMAddFunction(mod, "__tesla_op_i32_store8", typeStoreI32);
		fnI32Store16 = LLVMAddFunction(mod, "__tesla_op_i32_store16", typeStoreI32);
		fnI64Store8 = LLVMAddFunction(mod, "__tesla_op_i64_store8", typeStoreI64);
		fnI64Store16 = LLVMAddFunction(mod, "__tesla_op_i64_store16", typeStoreI64);
		fnI64Store32 = LLVMAddFunction(mod, "__tesla_op_i64_store32", typeStoreI64);

		fnI32TruncSF32 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_s_f32", typeI32TruncSF32);
		fnI32TruncUF32 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_u_f32", typeI32TruncUF32);
		fnI32TruncSF64 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_s_f64", typeI32TruncSF64);
		fnI32TruncUF64 = LLVMAddFunction(mod, "__tesla_op_i32_trunc_u_f64", typeI32TruncUF64);
		fnI64TruncSF32 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_s_f32", typeI64TruncSF32);
		fnI64TruncUF32 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_u_f32", typeI64TruncUF32);
		fnI64TruncSF64 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_s_f64", typeI64TruncSF64);
		fnI64TruncUF64 = LLVMAddFunction(mod, "__tesla_op_i64_trunc_u_f64", typeI64TruncUF64);
		fnF32DemoteF64 = LLVMAddFunction(mod, "__tesla_op_f32_Demote_f64", typeF32DemoteF64);

		fn_ctpop_i32 = LLVMAddFunction(mod, "llvm.ctpop.i32", typeUnaryI32);
		fn_ctpop_i64 = LLVMAddFunction(mod, "llvm.ctpop.i64", typeUnaryI64);

		fn_fabs_f32 = LLVMAddFunction(mod, "llvm.fabs.f32", typeUnaryF32);
		fn_ceil_f32 = LLVMAddFunction(mod, "llvm.ceil.f32", typeUnaryF32);
		fn_floor_f32 = LLVMAddFunction(mod, "llvm.floor.f32", typeUnaryF32);
		fn_trunc_f32 = LLVMAddFunction(mod, "llvm.trunc.f32", typeUnaryF32);
		fn_nearbyint_f32 = LLVMAddFunction(mod, "llvm.nearbyint.f32", typeUnaryF32);
		fn_sqrt_f32 = LLVMAddFunction(mod, "llvm.sqrt.f32", typeUnaryF32);
		fn_minnum_f32 = LLVMAddFunction(mod, "llvm.minnum.f32", typeBinF32);
		fn_maxnum_f32 = LLVMAddFunction(mod, "llvm.maxnum.f32", typeBinF32);
		fn_copysign_f32 = LLVMAddFunction(mod, "llvm.copysign.f32", typeBinF32);
		fn_fabs_f64 = LLVMAddFunction(mod, "llvm.fabs.f64", typeUnaryF64);
		fn_ceil_f64 = LLVMAddFunction(mod, "llvm.ceil.f64", typeUnaryF64);
		fn_floor_f64 = LLVMAddFunction(mod, "llvm.floor.f64", typeUnaryF64);
		fn_trunc_f64 = LLVMAddFunction(mod, "llvm.trunc.f64", typeUnaryF64);
		fn_nearbyint_f64 = LLVMAddFunction(mod, "llvm.nearbyint.f64", typeUnaryF64);
		fn_sqrt_f64 = LLVMAddFunction(mod, "llvm.sqrt.f64", typeUnaryF64);
		fn_minnum_f64 = LLVMAddFunction(mod, "llvm.minnum.f64", typeBinF64);
		fn_maxnum_f64 = LLVMAddFunction(mod, "llvm.maxnum.f64", typeBinF64);
		fn_copysign_f64 = LLVMAddFunction(mod, "llvm.copysign.f64", typeBinF64);
	}
}
