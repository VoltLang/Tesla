module test;

import ops;
import testfuncs;


extern(C):
fn add(i64, i64) i64;
fn sub(i64, i64) i64;
fn mul(i64, i64) i64;
fn div_u(i64, i64) i64;
fn div_s(i64, i64) i64;
fn rem_u(i64, i64) i64;
fn rem_s(i64, i64) i64;
fn and(i64, i64) i64;
fn or(i64, i64) i64;
fn xor(i64, i64) i64;
fn shl(i64, i64) i64;
fn shr_u(i64, i64) i64;
fn shr_s(i64, i64) i64;
fn rotl(i64, i64) i64;
fn rotr(i64, i64) i64;

fn clz(i64) i64;
fn ctz(i64) i64;
fn popcnt(i64) i64;
fn eqz(i64) i32;

fn eq(i64, i64) i32;
fn ne(i64, i64) i32;
fn lt_s(i64, i64) i32;
fn lt_u(i64, i64) i32;
fn le_s(i64, i64) i32;
fn le_u(i64, i64) i32;
fn gt_s(i64, i64) i32;
fn gt_u(i64, i64) i32;
fn ge_s(i64, i64) i32;
fn ge_u(i64, i64) i32;

extern(Volt) fn main() i32
{
	test("add", add, 1, 1, 2);
	test("add", add, 1, 0, 1);
	test("add", add, -1, -1, -2);
	test("add", add, -1, 1, 0);
	test("add", add, 0x7fffffffffffffff_i64, 1, 0x8000000000000000_i64);
	test("add", add, 0x8000000000000000_i64, -1, 0x7fffffffffffffff_i64);
	test("add", add, 0x8000000000000000_i64, 0x8000000000000000_i64, 0);
	test("add", add, 0x3fffffff_i64, 1, 0x40000000_i64);

	test("sub", sub, 1, 1, 0);
	test("sub", sub, 1, 0, 1);
	test("sub", sub, -1, -1, 0);
	test("sub", sub, 0x7fffffffffffffff_i64, -1, 0x8000000000000000_i64);
	test("sub", sub, 0x8000000000000000_i64, 1, 0x7fffffffffffffff_i64);
	test("sub", sub, 0x8000000000000000_i64, 0x8000000000000000_i64, 0);
	test("sub", sub, 0x3fffffff_i64, -1, 0x40000000_i64);

	test("mul", mul, 1, 1, 1);
	test("mul", mul, 1, 0, 0);
	test("mul", mul, -1, -1, 1);
	test("mul", mul, 0x1000000000000000_i64, 4096, 0);
	test("mul", mul, 0x8000000000000000_i64, 0, 0);
	test("mul", mul, 0x8000000000000000_i64, -1, 0x8000000000000000_i64);
	test("mul", mul, 0x7fffffffffffffff_i64, -1, 0x8000000000000001_i64);
	test("mul", mul, 0x0123456789abcdef_i64, 0xfedcba9876543210_i64, 0x2236d88fe5618cf0_i64);

	//test("div_s", div_s, 1, 0, "integer divide by zero");
	//test("div_s", div_s, 0, 0, "integer divide by zero");
	//test("div_s", div_s, 0x8000000000000000_i64, -1, "integer overflow");
	test("div_s", div_s, 1, 1, 1);
	test("div_s", div_s, 0, 1, 0);
	test("div_s", div_s, -1, -1, 1);
	test("div_s", div_s, 0x8000000000000000_i64, 2, 0xc000000000000000_i64);
	test("div_s", div_s, 0x8000000000000001_i64, 1000, 0xffdf3b645a1cac09_i64);
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

	//test("div_u", div_u, 1, 0, "integer divide by zero");
	//test("div_u", div_u, 0, 0, "integer divide by zero");
	test("div_u", div_u, 1, 1, 1);
	test("div_u", div_u, 0, 1, 0);
	test("div_u", div_u, -1, -1, 1);
	test("div_u", div_u, 0x8000000000000000_i64, -1, 0);
	test("div_u", div_u, 0x8000000000000000_i64, 2, 0x4000000000000000_i64);
	test("div_u", div_u, 0x8ff00ff00ff00ff0_i64, 0x100000001_i64, 0x8ff00fef_i64);
	test("div_u", div_u, 0x8000000000000001_i64, 1000, 0x20c49ba5e353f7_i64);
	test("div_u", div_u, 5, 2, 2);
	test("div_u", div_u, -5, 2, 0x7ffffffffffffffd_i64);
	test("div_u", div_u, 5, -2, 0);
	test("div_u", div_u, -5, -2, 0);
	test("div_u", div_u, 7, 3, 2);
	test("div_u", div_u, 11, 5, 2);
	test("div_u", div_u, 17, 7, 2);

	//test("rem_s", rem_s, 1, 0, "integer divide by zero");
	//test("rem_s", rem_s, 0, 0, "integer divide by zero");
	test("rem_s", rem_s, 0x7fffffffffffffff_i64, -1, 0);
	test("rem_s", rem_s, 1, 1, 0);
	test("rem_s", rem_s, 0, 1, 0);
	test("rem_s", rem_s, -1, -1, 0);
	test("rem_s", rem_s, 0x8000000000000000_i64, -1, 0);
	test("rem_s", rem_s, 0x8000000000000000_i64, 2, 0);
	test("rem_s", rem_s, 0x8000000000000001_i64, 1000, -807);
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

	//test("rem_u", rem_u, 1, 0, "integer divide by zero");
	//test("rem_u", rem_u, 0, 0, "integer divide by zero");
	test("rem_u", rem_u, 1, 1, 0);
	test("rem_u", rem_u, 0, 1, 0);
	test("rem_u", rem_u, -1, -1, 0);
	test("rem_u", rem_u, 0x8000000000000000_i64, -1, 0x8000000000000000_i64);
	test("rem_u", rem_u, 0x8000000000000000_i64, 2, 0);
	test("rem_u", rem_u, 0x8ff00ff00ff00ff0_i64, 0x100000001_i64, 0x80000001_i64);
	test("rem_u", rem_u, 0x8000000000000001_i64, 1000, 809);
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
	test("and", and, 0x7fffffffffffffff_i64, 0x8000000000000000_i64, 0);
	test("and", and, 0x7fffffffffffffff_i64, -1, 0x7fffffffffffffff_i64);
	test("and", and, 0xf0f0ffff_i64, 0xfffff0f0_i64, 0xf0f0f0f0_i64);
	test("and", and, 0xffffffffffffffff_i64, 0xffffffffffffffff_i64, 0xffffffffffffffff_i64);

	test("or", or, 1, 0, 1);
	test("or", or, 0, 1, 1);
	test("or", or, 1, 1, 1);
	test("or", or, 0, 0, 0);
	test("or", or, 0x7fffffffffffffff_i64, 0x8000000000000000_i64, -1);
	test("or", or, 0x8000000000000000_i64, 0, 0x8000000000000000_i64);
	test("or", or, 0xf0f0ffff_i64, 0xfffff0f0_i64, 0xffffffff_i64);
	test("or", or, 0xffffffffffffffff_i64, 0xffffffffffffffff_i64, 0xffffffffffffffff_i64);

	test("xor", xor, 1, 0, 1);
	test("xor", xor, 0, 1, 1);
	test("xor", xor, 1, 1, 0);
	test("xor", xor, 0, 0, 0);
	test("xor", xor, 0x7fffffffffffffff_i64, 0x8000000000000000_i64, -1);
	test("xor", xor, 0x8000000000000000_i64, 0, 0x8000000000000000_i64);
	test("xor", xor, -1, 0x8000000000000000_i64, 0x7fffffffffffffff_i64);
	test("xor", xor, -1, 0x7fffffffffffffff_i64, 0x8000000000000000_i64);
	test("xor", xor, 0xf0f0ffff_i64, 0xfffff0f0_i64, 0x0f0f0f0f_i64);
	test("xor", xor, 0xffffffffffffffff_i64, 0xffffffffffffffff_i64, 0);

	test("shl", shl, 1, 1, 2);
	test("shl", shl, 1, 0, 1);
	test("shl", shl, 0x7fffffffffffffff_i64, 1, 0xfffffffffffffffe_i64);
	test("shl", shl, 0xffffffffffffffff_i64, 1, 0xfffffffffffffffe_i64);
	test("shl", shl, 0x8000000000000000_i64, 1, 0);
	test("shl", shl, 0x4000000000000000_i64, 1, 0x8000000000000000_i64);
	test("shl", shl, 1, 63, 0x8000000000000000_i64);
	test("shl", shl, 1, 64, 1);
	test("shl", shl, 1, 65, 2);
	test("shl", shl, 1, -1, 0x8000000000000000_i64);
	test("shl", shl, 1, 0x7fffffffffffffff_i64, 0x8000000000000000_i64);

	test("shr_s", shr_s, 1, 1, 0);
	test("shr_s", shr_s, 1, 0, 1);
	test("shr_s", shr_s, -1, 1, -1);
	test("shr_s", shr_s, 0x7fffffffffffffff_i64, 1, 0x3fffffffffffffff_i64);
	test("shr_s", shr_s, 0x8000000000000000_i64, 1, 0xc000000000000000_i64);
	test("shr_s", shr_s, 0x4000000000000000_i64, 1, 0x2000000000000000_i64);
	test("shr_s", shr_s, 1, 64, 1);
	test("shr_s", shr_s, 1, 65, 0);
	test("shr_s", shr_s, 1, -1, 0);
	test("shr_s", shr_s, 1, 0x7fffffffffffffff_i64, 0);
	test("shr_s", shr_s, 1, 0x8000000000000000_i64, 1);
	test("shr_s", shr_s, 0x8000000000000000_i64, 63, -1);
	test("shr_s", shr_s, -1, 64, -1);
	test("shr_s", shr_s, -1, 65, -1);
	test("shr_s", shr_s, -1, -1, -1);
	test("shr_s", shr_s, -1, 0x7fffffffffffffff_i64, -1);
	test("shr_s", shr_s, -1, 0x8000000000000000_i64, -1);

	test("shr_u", shr_u, 1, 1, 0);
	test("shr_u", shr_u, 1, 0, 1);
	test("shr_u", shr_u, -1, 1, 0x7fffffffffffffff_i64);
	test("shr_u", shr_u, 0x7fffffffffffffff_i64, 1, 0x3fffffffffffffff_i64);
	test("shr_u", shr_u, 0x8000000000000000_i64, 1, 0x4000000000000000_i64);
	test("shr_u", shr_u, 0x4000000000000000_i64, 1, 0x2000000000000000_i64);
	test("shr_u", shr_u, 1, 64, 1);
	test("shr_u", shr_u, 1, 65, 0);
	test("shr_u", shr_u, 1, -1, 0);
	test("shr_u", shr_u, 1, 0x7fffffffffffffff_i64, 0);
	test("shr_u", shr_u, 1, 0x8000000000000000_i64, 1);
	test("shr_u", shr_u, 0x8000000000000000_i64, 63, 1);
	test("shr_u", shr_u, -1, 64, -1);
	test("shr_u", shr_u, -1, 65, 0x7fffffffffffffff_i64);
	test("shr_u", shr_u, -1, -1, 1);
	test("shr_u", shr_u, -1, 0x7fffffffffffffff_i64, 1);
	test("shr_u", shr_u, -1, 0x8000000000000000_i64, -1);

	test("rotl", rotl, 1, 1, 2);
	test("rotl", rotl, 1, 0, 1);
	test("rotl", rotl, -1, 1, -1);
	test("rotl", rotl, 0xabd1234ef567809c_i64, 63, 0x55e891a77ab3c04e_i64);
	test("rotl", rotl, 0xabd1234ef567809c_i64, 0x800000000000003f_i64, 0x55e891a77ab3c04e_i64);
	test("rotl", rotl, 1, 63, 0x8000000000000000_i64);
	test("rotl", rotl, 0x8000000000000000_i64, 1, 1);

	test("rotr", rotr, 1, 1, 0x8000000000000000_i64);
	test("rotr", rotr, 1, 0, 1);
	test("rotr", rotr, -1, 1, -1);
	test("rotr", rotr, 0xabcd1234ef567809_i64, 53, 0x6891a77ab3c04d5e_i64);
	test("rotr", rotr, 0xabcd1234ef567809_i64, 0x35_i64, 0x6891a77ab3c04d5e_i64);
	test("rotr", rotr, 0xabcd1234ef567809_i64, 0xf5_i64, 0x6891a77ab3c04d5e_i64);
	test("rotr", rotr, 1, 1, 0x8000000000000000_i64);
	test("rotr", rotr, 0x8000000000000000_i64, 63, 1);

	// TODO more tests

	return getResult();
}
