module ops;

extern(C):


/*
 *
 * i32 ops.
 *
 */

fn __tesla_op_i32_div_u(l: u32, r: u32) u32
{
	return l / r;
}

fn __tesla_op_i32_div_s(l: i32, r: i32) i32
{
	return l / r;
}

fn __tesla_op_i32_rem_u(l: u32, r: u32) u32
{
	return l % r;
}

fn __tesla_op_i32_rem_s(l: i32, r: i32) i32
{
	if (l == i32.min && cast(u32)r == u32.max) {
		return 0;
	} else {
		return l % r;
	}
}

fn __tesla_op_i32_rotl(l: i32, r: i32) i32
{
	amount := cast(u32)r & 31u;
	lu := cast(u32)l;
	if (amount != 0) {
		return cast(i32)((lu << amount) | (lu >> (32u - amount)));
	} else {
		return l;
	}
}

fn __tesla_op_i32_rotr(l: i32, r: i32) i32
{
	amount := cast(u32)r & 31u;
	lu := cast(u32)l;
	if (amount != 0) {
		return cast(i32)((lu >> amount) | (lu << (32u - amount)));
	} else {
		return l;
	}
}

fn __tesla_op_i32_clz(v: i32) i32
{
	return v != 0 ? __llvm_ctlz(v, false) : 32;
}

fn __tesla_op_i32_ctz(v: i32) i32
{
	return v != 0 ? __llvm_cttz(v, false) : 32;
}


/*
 *
 * i64 ops.
 *
 */

fn __tesla_op_i64_div_u(l: u64, r: u64) u64
{
	return l / r;
}

fn __tesla_op_i64_div_s(l: i64, r: i64) i64
{
	return l / r;
}

fn __tesla_op_i64_rem_u(l: u64, r: u64) u64
{
	return l % r;
}

fn __tesla_op_i64_rem_s(l: i64, r: i64) i64
{
	if (l == i64.min && cast(u64)r == u64.max) {
		return 0;
	} else {
		return l % r;
	}
}

fn __tesla_op_i64_rotl(l: i64, r: i64) i64
{
	amount := cast(u64)r & 63u;
	lu := cast(u64)l;
	if (amount != 0) {
		return cast(i64)((lu << amount) | (lu >> (64u - amount)));
	} else {
		return l;
	}
}

fn __tesla_op_i64_rotr(l: i64, r: i64) i64
{
	amount := cast(u64)r & 63u;
	lu := cast(u64)l;
	if (amount != 0) {
		return cast(i64)((lu >> amount) | (lu << (64u - amount)));
	} else {
		return l;
	}
}

fn __tesla_op_i64_clz(v: i64) i64
{
	return v != 0 ? __llvm_ctlz(v, false) : 64L;
}

fn __tesla_op_i64_ctz(v: i64) i64
{
	return v != 0 ? __llvm_cttz(v, false) : 64L;
}


/*
 *
 * f32 ops.
 *
 */

fn __tesla_op_f32_div(l: f32, r: f32) f32
{
	return l / r;
}


/*
 *
 * f32 ops.
 *
 */

fn __tesla_op_f64_div(l: f64, r: f64) f64
{
	return l / r;
}


/*
 *
 * Shared llvm functions
 *
 */

@mangledName("llvm.ctlz.i32") fn __llvm_ctlz(i32, bool) i32;
@mangledName("llvm.cttz.i32") fn __llvm_cttz(i32, bool) i32;
@mangledName("llvm.ctlz.i64") fn __llvm_ctlz(i64, bool) i64;
@mangledName("llvm.cttz.i64") fn __llvm_cttz(i64, bool) i64;
