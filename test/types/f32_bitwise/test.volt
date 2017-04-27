module test;

import ops;
import testfuncs;


extern(C):

@mangledName("_t_abs") fn abs(f32) f32;
@mangledName("_t_neg") fn neg(f32) f32;
@mangledName("_t_copysign") fn copysign(f32, f32) f32;

extern(Volt) fn main() i32
{
	test("abs", abs, -0.5f,  0.5f);
	test("neg", neg,  0.5f, -0.5f);
	test("copysign", copysign, 0.5f, -0.5f, -0.5f);

	return getResult();
}
