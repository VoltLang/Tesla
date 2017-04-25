module test;

import ops;
import io = watt.io;

global statusFlag: i32;

fn test(name: string, f: fn!C(i32, i32) i32, l: i32, r: i32, expect: i32)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s) ret: 0x%08x (%s)", expect, expect, ret, ret);
		io.error.flush();
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(i32) i32, v: i32, expect: i32)
{
	//io.output.writefln("%s(%s) = %s", name, v, expect);
	//io.output.flush();
	ret := f(v);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s) = %s", name, v, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s) ret: 0x%08x (%s)", expect, expect, ret, ret);
		io.error.flush();
	}
}

int main()
{
	test("add", add, 1, 1, 2);
	test("add", add, 1, 0, 1);
	test("add", add, -1, -1, -2);
	test("add", add, -1, 1, 0);
	test("add", add, 0x7fffffff, 1, 0x80000000);
	test("add", add, 0x80000000, -1, 0x7fffffff);
	test("add", add, 0x80000000, 0x80000000, 0);
	test("add", add, 0x3fffffff, 1, 0x40000000);

	test("sub", sub, 1, 1, 0);
	test("sub", sub, 1, 0, 1);
	test("sub", sub, -1, -1, 0);
	test("sub", sub, 0x7fffffff, -1, 0x80000000);
	test("sub", sub, 0x80000000, 1, 0x7fffffff);
	test("sub", sub, 0x80000000, 0x80000000, 0);
	test("sub", sub, 0x3fffffff, -1, 0x40000000);

	test("mul", mul, 1, 1, 1);
	test("mul", mul, 1, 0, 0);
	test("mul", mul, -1, -1, 1);
	test("mul", mul, 0x10000000, 4096, 0);
	test("mul", mul, 0x80000000, 0, 0);
	test("mul", mul, 0x80000000, -1, 0x80000000);
	test("mul", mul, 0x7fffffff, -1, 0x80000001);
	test("mul", mul, 0x01234567, 0x76543210, 0x358e7470);

	test("div_s", div_s, 1, 1, 1);
	test("div_s", div_s, 0, 1, 0);
	test("div_s", div_s, -1, -1, 1);
	test("div_s", div_s, 0x80000000, 2, 0xc0000000);
	test("div_s", div_s, 0x80000001, 1000, 0xffdf3b65);
	test("div_s", div_s, 5, 2, 2);
	test("div_s", div_s, -5, 2, -2);
	test("div_s", div_s, 5, -2, -2);
	test("div_s", div_s, -5, -2, 2);
	test("div_s", div_s, 7, 3, 2);
	test("div_s", div_s, -7, 3, -2);
	test("div_s", div_s, 7, -3, -2);
	test("div_s", div_s, -7, -3, 2);
	test("div_s", div_s, 11, 5, 2);
	test("div_s", div_s, 17, 7, 2);

	test("div_u", div_u, 1, 1, 1);
	test("div_u", div_u, 0, 1, 0);
	test("div_u", div_u, -1, -1, 1);
	test("div_u", div_u, 0x80000000, -1, 0);
	test("div_u", div_u, 0x80000000, 2, 0x40000000);
	test("div_u", div_u, 0x8ff00ff0, 0x10001, 0x8fef);
	test("div_u", div_u, 0x80000001, 1000, 0x20c49b);
	test("div_u", div_u, 5, 2, 2);
	test("div_u", div_u, -5, 2, 0x7ffffffd);
	test("div_u", div_u, 5, -2, 0);
	test("div_u", div_u, -5, -2, 0);
	test("div_u", div_u, 7, 3, 2);
	test("div_u", div_u, 11, 5, 2);
	test("div_u", div_u, 17, 7, 2);

	test("rem_s", rem_s, 0x7fffffff, -1, 0);
	test("rem_s", rem_s, 1, 1, 0);
	test("rem_s", rem_s, 0, 1, 0);
	test("rem_s", rem_s, -1, -1, 0);
	test("rem_s", rem_s, 0x80000000, -1, 0);
	test("rem_s", rem_s, 0x80000000, 2, 0);
	test("rem_s", rem_s, 0x80000001, 1000, -647);
	test("rem_s", rem_s, 5, 2, 1);
	test("rem_s", rem_s, -5, 2, -1);
	test("rem_s", rem_s, 5, -2, 1);
	test("rem_s", rem_s, -5, -2, -1);
	test("rem_s", rem_s, 7, 3, 1);
	test("rem_s", rem_s, -7, 3, -1);
	test("rem_s", rem_s, 7, -3, 1);
	test("rem_s", rem_s, -7, -3, -1);
	test("rem_s", rem_s, 11, 5, 1);
	test("rem_s", rem_s, 17, 7, 3);
	test("rem_u", rem_u, 1, 1, 0);
	test("rem_u", rem_u, 0, 1, 0);
	test("rem_u", rem_u, -1, -1, 0);
	test("rem_u", rem_u, 0x80000000, -1, 0x80000000);
	test("rem_u", rem_u, 0x80000000, 2, 0);
	test("rem_u", rem_u, 0x8ff00ff0, 0x10001, 0x8001);
	test("rem_u", rem_u, 0x80000001, 1000, 649);
	test("rem_u", rem_u, 5, 2, 1);
	test("rem_u", rem_u, -5, 2, 1);
	test("rem_u", rem_u, 5, -2, 5);
	test("rem_u", rem_u, -5, -2, -5);
	test("rem_u", rem_u, 7, 3, 1);
	test("rem_u", rem_u, 11, 5, 1);
	test("rem_u", rem_u, 17, 7, 3);

	test("and", and, 1, 0, 0);
	test("and", and, 0, 1, 0);
	test("and", and, 1, 1, 1);
	test("and", and, 0, 0, 0);
	test("and", and, 0x7fffffff, 0x80000000, 0);
	test("and", and, 0x7fffffff, -1, 0x7fffffff);
	test("and", and, 0xf0f0ffff, 0xfffff0f0, 0xf0f0f0f0);
	test("and", and, 0xffffffff, 0xffffffff, 0xffffffff);

	test("or", or, 1, 0, 1);
	test("or", or, 0, 1, 1);
	test("or", or, 1, 1, 1);
	test("or", or, 0, 0, 0);
	test("or", or, 0x7fffffff, 0x80000000, -1);
	test("or", or, 0x80000000, 0, 0x80000000);
	test("or", or, 0xf0f0ffff, 0xfffff0f0, 0xffffffff);
	test("or", or, 0xffffffff, 0xffffffff, 0xffffffff);

	test("xor", xor, 1, 0, 1);
	test("xor", xor, 0, 1, 1);
	test("xor", xor, 1, 1, 0);
	test("xor", xor, 0, 0, 0);
	test("xor", xor, 0x7fffffff, 0x80000000, -1);
	test("xor", xor, 0x80000000, 0, 0x80000000);
	test("xor", xor, -1, 0x80000000, 0x7fffffff);
	test("xor", xor, -1, 0x7fffffff, 0x80000000);
	test("xor", xor, 0xf0f0ffff, 0xfffff0f0, 0x0f0f0f0f);
	test("xor", xor, 0xffffffff, 0xffffffff, 0);

	test("shl", shl, 1, 1, 2);
	test("shl", shl, 1, 0, 1);
	test("shl", shl, 0x7fffffff, 1, 0xfffffffe);
	test("shl", shl, 0xffffffff, 1, 0xfffffffe);
	test("shl", shl, 0x80000000, 1, 0);
	test("shl", shl, 0x40000000, 1, 0x80000000);
	test("shl", shl, 1, 31, 0x80000000);
	test("shl", shl, 1, 32, 1);
	test("shl", shl, 1, 33, 2);
	test("shl", shl, 1, -1, 0x80000000);
	test("shl", shl, 1, 0x7fffffff, 0x80000000);

	test("shr_s", shr_s, 1, 1, 0);
	test("shr_s", shr_s, 1, 0, 1);
	test("shr_s", shr_s, -1, 1, -1);
	test("shr_s", shr_s, 0x7fffffff, 1, 0x3fffffff);
	test("shr_s", shr_s, 0x80000000, 1, 0xc0000000);
	test("shr_s", shr_s, 0x40000000, 1, 0x20000000);
	test("shr_s", shr_s, 1, 32, 1);
	test("shr_s", shr_s, 1, 33, 0);
	test("shr_s", shr_s, 1, -1, 0);
	test("shr_s", shr_s, 1, 0x7fffffff, 0);
	test("shr_s", shr_s, 1, 0x80000000, 1);
	test("shr_s", shr_s, 0x80000000, 31, -1);
	test("shr_s", shr_s, -1, 32, -1);
	test("shr_s", shr_s, -1, 33, -1);
	test("shr_s", shr_s, -1, -1, -1);
	test("shr_s", shr_s, -1, 0x7fffffff, -1);
	test("shr_s", shr_s, -1, 0x80000000, -1);

	test("shr_u", shr_u, 1, 1, 0);
	test("shr_u", shr_u, 1, 0, 1);
	test("shr_u", shr_u, -1, 1, 0x7fffffff);
	test("shr_u", shr_u, 0x7fffffff, 1, 0x3fffffff);
	test("shr_u", shr_u, 0x80000000, 1, 0x40000000);
	test("shr_u", shr_u, 0x40000000, 1, 0x20000000);
	test("shr_u", shr_u, 1, 32, 1);
	test("shr_u", shr_u, 1, 33, 0);
	test("shr_u", shr_u, 1, -1, 0);
	test("shr_u", shr_u, 1, 0x7fffffff, 0);
	test("shr_u", shr_u, 1, 0x80000000, 1);
	test("shr_u", shr_u, 0x80000000, 31, 1);
	test("shr_u", shr_u, -1, 32, -1);
	test("shr_u", shr_u, -1, 33, 0x7fffffff);
	test("shr_u", shr_u, -1, -1, 1);
	test("shr_u", shr_u, -1, 0x7fffffff, 1);
	test("shr_u", shr_u, -1, 0x80000000, -1);

	test("rotl", rotl, 0xfe00dc00, 4, 0xe00dc00f);
	test("rotl", rotl, 0xabcd9876, 1, 0x579b30ed);
	test("rotl", rotl, 0x00008000, 37, 0x00100000);
	test("rotl", rotl, 0x769abcdf, 0x8000000d, 0x579beed3);
	test("rotl", rotl, 1, 31, 0x80000000);
	test("rotl", rotl, 0x80000000, 1, 1);

	test("rotr", rotr, 0xb0c1d2e3, 0x0005, 0x1d860e97);
	test("rotr", rotr, 0xb0c1d2e3, 0xff05, 0x1d860e97);
	test("rotr", rotr, 0xff00cc00, 1, 0x7f806600);
	test("rotr", rotr, 0x00080000, 4, 0x00008000);
	test("rotr", rotr, 0x769abcdf, 0xffffffed, 0xe6fbb4d5);
	test("rotr", rotr, 1, 1, 0x80000000);
	test("rotr", rotr, 0x80000000, 31, 1);

	test("clz", clz, 0xffffffff, 0);
	test("clz", clz, 0, 32);
	test("clz", clz, 0x00008000, 16);
	test("clz", clz, 0xff, 24);
	test("clz", clz, 0x80000000, 0);
	test("clz", clz, 1, 31);
	test("clz", clz, 2, 30);
	test("clz", clz, 0x7fffffff, 1);

	test("ctz", ctz, -1, 0);
	test("ctz", ctz, 0, 32);
	test("ctz", ctz, 0x00008000, 15);
	test("ctz", ctz, 0x00010000, 16);
	test("ctz", ctz, 0x80000000, 31);
	test("ctz", ctz, 0x7fffffff, 0);

	test("popcnt", popcnt, -1, 32);
	test("popcnt", popcnt, 0, 0);
	test("popcnt", popcnt, 0x00008000, 1);
	test("popcnt", popcnt, 0x80008000, 2);
	test("popcnt", popcnt, 0x7fffffff, 31);
	test("popcnt", popcnt, 0xAAAAAAAA, 16);
	test("popcnt", popcnt, 0x55555555, 16);
	test("popcnt", popcnt, 0xDEADBEEF, 24);

	test("eqz", eqz, 0, 1);
	test("eqz", eqz, 1, 0);
	test("eqz", eqz, 0x80000000, 0);
	test("eqz", eqz, 0x7fffffff, 0);

	test("eq", eq, 0, 0, 1);
	test("eq", eq, 1, 1, 1);
	test("eq", eq, -1, 1, 0);
	test("eq", eq, 0x80000000, 0x80000000, 1);
	test("eq", eq, 0x7fffffff, 0x7fffffff, 1);
	test("eq", eq, -1, -1, 1);
	test("eq", eq, 1, 0, 0);
	test("eq", eq, 0, 1, 0);
	test("eq", eq, 0x80000000, 0, 0);
	test("eq", eq, 0, 0x80000000, 0);
	test("eq", eq, 0x80000000, -1, 0);
	test("eq", eq, -1, 0x80000000, 0);
	test("eq", eq, 0x80000000, 0x7fffffff, 0);
	test("eq", eq, 0x7fffffff, 0x80000000, 0);

	test("ne", ne, 0, 0, 0);
	test("ne", ne, 1, 1, 0);
	test("ne", ne, -1, 1, 1);
	test("ne", ne, 0x80000000, 0x80000000, 0);
	test("ne", ne, 0x7fffffff, 0x7fffffff, 0);
	test("ne", ne, -1, -1, 0);
	test("ne", ne, 1, 0, 1);
	test("ne", ne, 0, 1, 1);
	test("ne", ne, 0x80000000, 0, 1);
	test("ne", ne, 0, 0x80000000, 1);
	test("ne", ne, 0x80000000, -1, 1);
	test("ne", ne, -1, 0x80000000, 1);
	test("ne", ne, 0x80000000, 0x7fffffff, 1);
	test("ne", ne, 0x7fffffff, 0x80000000, 1);

	test("lt_s", lt_s, 0, 0, 0);
	test("lt_s", lt_s, 1, 1, 0);
	test("lt_s", lt_s, -1, 1, 1);
	test("lt_s", lt_s, 0x80000000, 0x80000000, 0);
	test("lt_s", lt_s, 0x7fffffff, 0x7fffffff, 0);
	test("lt_s", lt_s, -1, -1, 0);
	test("lt_s", lt_s, 1, 0, 0);
	test("lt_s", lt_s, 0, 1, 1);
	test("lt_s", lt_s, 0x80000000, 0, 1);
	test("lt_s", lt_s, 0, 0x80000000, 0);
	test("lt_s", lt_s, 0x80000000, -1, 1);
	test("lt_s", lt_s, -1, 0x80000000, 0);
	test("lt_s", lt_s, 0x80000000, 0x7fffffff, 1);
	test("lt_s", lt_s, 0x7fffffff, 0x80000000, 0);

	test("lt_u", lt_u, 0, 0, 0);
	test("lt_u", lt_u, 1, 1, 0);
	test("lt_u", lt_u, -1, 1, 0);
	test("lt_u", lt_u, 0x80000000, 0x80000000, 0);
	test("lt_u", lt_u, 0x7fffffff, 0x7fffffff, 0);
	test("lt_u", lt_u, -1, -1, 0);
	test("lt_u", lt_u, 1, 0, 0);
	test("lt_u", lt_u, 0, 1, 1);
	test("lt_u", lt_u, 0x80000000, 0, 0);
	test("lt_u", lt_u, 0, 0x80000000, 1);
	test("lt_u", lt_u, 0x80000000, -1, 1);
	test("lt_u", lt_u, -1, 0x80000000, 0);
	test("lt_u", lt_u, 0x80000000, 0x7fffffff, 0);
	test("lt_u", lt_u, 0x7fffffff, 0x80000000, 1);

	test("le_s", le_s, 0, 0, 1);
	test("le_s", le_s, 1, 1, 1);
	test("le_s", le_s, -1, 1, 1);
	test("le_s", le_s, 0x80000000, 0x80000000, 1);
	test("le_s", le_s, 0x7fffffff, 0x7fffffff, 1);
	test("le_s", le_s, -1, -1, 1);
	test("le_s", le_s, 1, 0, 0);
	test("le_s", le_s, 0, 1, 1);
	test("le_s", le_s, 0x80000000, 0, 1);
	test("le_s", le_s, 0, 0x80000000, 0);
	test("le_s", le_s, 0x80000000, -1, 1);
	test("le_s", le_s, -1, 0x80000000, 0);
	test("le_s", le_s, 0x80000000, 0x7fffffff, 1);
	test("le_s", le_s, 0x7fffffff, 0x80000000, 0);

	test("le_u", le_u, 0, 0, 1);
	test("le_u", le_u, 1, 1, 1);
	test("le_u", le_u, -1, 1, 0);
	test("le_u", le_u, 0x80000000, 0x80000000, 1);
	test("le_u", le_u, 0x7fffffff, 0x7fffffff, 1);
	test("le_u", le_u, -1, -1, 1);
	test("le_u", le_u, 1, 0, 0);
	test("le_u", le_u, 0, 1, 1);
	test("le_u", le_u, 0x80000000, 0, 0);
	test("le_u", le_u, 0, 0x80000000, 1);
	test("le_u", le_u, 0x80000000, -1, 1);
	test("le_u", le_u, -1, 0x80000000, 0);
	test("le_u", le_u, 0x80000000, 0x7fffffff, 0);
	test("le_u", le_u, 0x7fffffff, 0x80000000, 1);

	test("gt_s", gt_s, 0, 0, 0);
	test("gt_s", gt_s, 1, 1, 0);
	test("gt_s", gt_s, -1, 1, 0);
	test("gt_s", gt_s, 0x80000000, 0x80000000, 0);
	test("gt_s", gt_s, 0x7fffffff, 0x7fffffff, 0);
	test("gt_s", gt_s, -1, -1, 0);
	test("gt_s", gt_s, 1, 0, 1);
	test("gt_s", gt_s, 0, 1, 0);
	test("gt_s", gt_s, 0x80000000, 0, 0);
	test("gt_s", gt_s, 0, 0x80000000, 1);
	test("gt_s", gt_s, 0x80000000, -1, 0);
	test("gt_s", gt_s, -1, 0x80000000, 1);
	test("gt_s", gt_s, 0x80000000, 0x7fffffff, 0);
	test("gt_s", gt_s, 0x7fffffff, 0x80000000, 1);

	test("gt_u", gt_u, 0, 0, 0);
	test("gt_u", gt_u, 1, 1, 0);
	test("gt_u", gt_u, -1, 1, 1);
	test("gt_u", gt_u, 0x80000000, 0x80000000, 0);
	test("gt_u", gt_u, 0x7fffffff, 0x7fffffff, 0);
	test("gt_u", gt_u, -1, -1, 0);
	test("gt_u", gt_u, 1, 0, 1);
	test("gt_u", gt_u, 0, 1, 0);
	test("gt_u", gt_u, 0x80000000, 0, 1);
	test("gt_u", gt_u, 0, 0x80000000, 0);
	test("gt_u", gt_u, 0x80000000, -1, 0);
	test("gt_u", gt_u, -1, 0x80000000, 1);
	test("gt_u", gt_u, 0x80000000, 0x7fffffff, 1);
	test("gt_u", gt_u, 0x7fffffff, 0x80000000, 0);

	test("ge_s", ge_s, 0, 0, 1);
	test("ge_s", ge_s, 1, 1, 1);
	test("ge_s", ge_s, -1, 1, 0);
	test("ge_s", ge_s, 0x80000000, 0x80000000, 1);
	test("ge_s", ge_s, 0x7fffffff, 0x7fffffff, 1);
	test("ge_s", ge_s, -1, -1, 1);
	test("ge_s", ge_s, 1, 0, 1);
	test("ge_s", ge_s, 0, 1, 0);
	test("ge_s", ge_s, 0x80000000, 0, 0);
	test("ge_s", ge_s, 0, 0x80000000, 1);
	test("ge_s", ge_s, 0x80000000, -1, 0);
	test("ge_s", ge_s, -1, 0x80000000, 1);
	test("ge_s", ge_s, 0x80000000, 0x7fffffff, 0);
	test("ge_s", ge_s, 0x7fffffff, 0x80000000, 1);

	test("ge_u", ge_u, 0, 0, 1);
	test("ge_u", ge_u, 1, 1, 1);
	test("ge_u", ge_u, -1, 1, 1);
	test("ge_u", ge_u, 0x80000000, 0x80000000, 1);
	test("ge_u", ge_u, 0x7fffffff, 0x7fffffff, 1);
	test("ge_u", ge_u, -1, -1, 1);
	test("ge_u", ge_u, 1, 0, 1);
	test("ge_u", ge_u, 0, 1, 0);
	test("ge_u", ge_u, 0x80000000, 0, 1);
	test("ge_u", ge_u, 0, 0x80000000, 0);
	test("ge_u", ge_u, 0x80000000, -1, 0);
	test("ge_u", ge_u, -1, 0x80000000, 1);
	test("ge_u", ge_u, 0x80000000, 0x7fffffff, 1);
	test("ge_u", ge_u, 0x7fffffff, 0x80000000, 0);

	io.output.flush();
	return statusFlag;
}

extern(C):
fn add(i32, i32) i32;
fn sub(i32, i32) i32;
fn mul(i32, i32) i32;
fn div_u(i32, i32) i32;
fn div_s(i32, i32) i32;
fn rem_u(i32, i32) i32;
fn rem_s(i32, i32) i32;
fn and(i32, i32) i32;
fn or(i32, i32) i32;
fn xor(i32, i32) i32;
fn shl(i32, i32) i32;
fn shr_u(i32, i32) i32;
fn shr_s(i32, i32) i32;
fn rotl(i32, i32) i32;
fn rotr(i32, i32) i32;

fn clz(i32) i32;
fn ctz(i32) i32;
fn popcnt(i32) i32;
fn eqz(i32) i32;

fn eq(i32, i32) i32;
fn ne(i32, i32) i32;
fn lt_s(i32, i32) i32;
fn lt_u(i32, i32) i32;
fn le_s(i32, i32) i32;
fn le_u(i32, i32) i32;
fn gt_s(i32, i32) i32;
fn gt_u(i32, i32) i32;
fn ge_s(i32, i32) i32;
fn ge_u(i32, i32) i32;
