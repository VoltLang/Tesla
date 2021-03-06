module test;

import ops;
import testfuncs;


extern(C):

@mangledName("_t_eq") fn eq(f32, f32) i32;
@mangledName("_t_ne") fn ne(f32, f32) i32;
@mangledName("_t_lt") fn lt(f32, f32) i32;
@mangledName("_t_le") fn le(f32, f32) i32;
@mangledName("_t_gt") fn gt(f32, f32) i32;
@mangledName("_t_ge") fn ge(f32, f32) i32;

extern(Volt) fn main() i32
{
	test("eq", eq, 0.5f, 0.5f, 1);
	test("ne", ne, 0.5f, 0.5f, 0);
	test("lt", lt, 0.5f, 0.5f, 0);
	test("le", le, 0.5f, 0.5f, 1);
	test("gt", gt, 0.5f, 0.5f, 0);
	test("ge", ge, 0.5f, 0.5f, 1);

	return getResult();
}
