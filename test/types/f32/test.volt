module test;

import ops;
import testfuncs;


extern(C):

@mangledName("_t_add") fn add(f32, f32) f32;
@mangledName("_t_sub") fn sub(f32, f32) f32;
@mangledName("_t_mul") fn mul(f32, f32) f32;
@mangledName("_t_div") fn div(f32, f32) f32;
@mangledName("_t_sqrt") fn sqrt(f32) f32;
@mangledName("_t_min") fn min(f32, f32) f32;
@mangledName("_t_max") fn max(f32, f32) f32;
@mangledName("_t_ceil") fn ceil(f32) f32;
@mangledName("_t_floor") fn floor(f32) f32;
@mangledName("_t_trunc") fn trunc(f32) f32;
@mangledName("_t_nearest") fn nearest(f32) f32;

extern(Volt) fn main() i32
{
	test("add", add, 0.5f, 0.5f, 0.5f + 0.5f);
	test("sub", sub, 0.5f, 0.5f, 0.5f - 0.5f);
	test("mul", mul, 0.5f, 0.5f, 0.5f * 0.5f);
	test("div", div, 0.5f, 0.5f, 0.5f / 0.5f);
	test("sqrt", sqrt, 4.0f, 2.0f);
	test("min", min, 0.5f, 0.5f, 0.5f);
	test("max", max, 0.5f, 0.5f, 0.5f);
	test("ceil", ceil, 0.5f, 1.0f);
	test("floor", floor, 0.5f, 0.0f);
	test("trunc", trunc, 0.5f, 0.0f);
	test("nearest", nearest, 0.5f, 0.0f);

	return getResult();
}
