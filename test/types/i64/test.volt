module test;

import ops;
import io = watt.io;


global statusFlag: i32;

fn test(name: string, f: fn!C(i64, i64) i64, l: i64, r: i64, expect: i64)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("%s(0x%016x, 0x%016x) = 0x%016x", name, l, r, expect);
		io.error.writefln("FAIL expect: 0x%016x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%016x (%s)", ret, ret);
		io.error.flush();
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(i64, i64) i32, l: i64, r: i64, expect: i32)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("%s(0x%016x, 0x%016x) = 0x%08x", name, l, r, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%08x (%s)", ret, ret);
		io.error.flush();
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(i64) i64, v: i64, expect: i64)
{
	//io.output.writefln("%s(%s) = %s", name, v, expect);
	//io.output.flush();
	ret := f(v);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s) = %s", name, v, expect);
		io.error.writefln("%s(0x%016x) = 0x%016x", name, v, expect);
		io.error.writefln("FAIL expect: 0x%016x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%016x (%s)", ret, ret);
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(i64) i32, v: i64, expect: i32)
{
	//io.output.writefln("%s(%s) = %s", name, v, expect);
	//io.output.flush();
	ret := f(v);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s) = %s", name, v, expect);
		io.error.writefln("%s(0x%016x) = 0x%08x", name, v, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%08x (%s)", ret, ret);
		io.error.flush();
	}
}

int main()
{
	test("add", add, 1, 1, 2);
	test("add", add, 1, 0, 1);
	test("add", add, -1, -1, -2);
	test("add", add, -1, 1, 0);
	test("add", add, 0x7fffffffffffffff, 1, 0x8000000000000000);
	test("add", add, 0x8000000000000000, -1, 0x7fffffffffffffff);
	test("add", add, 0x8000000000000000, 0x8000000000000000, 0);
	test("add", add, 0x3fffffff, 1, 0x40000000);

	test("sub", sub, 1, 1, 0);
	test("sub", sub, 1, 0, 1);
	test("sub", sub, -1, -1, 0);
	test("sub", sub, 0x7fffffffffffffff, -1, 0x8000000000000000);
	test("sub", sub, 0x8000000000000000, 1, 0x7fffffffffffffff);
	test("sub", sub, 0x8000000000000000, 0x8000000000000000, 0);
	test("sub", sub, 0x3fffffff, -1, 0x40000000);

	test("mul", mul, 1, 1, 1);
	test("mul", mul, 1, 0, 0);
	test("mul", mul, -1, -1, 1);
	test("mul", mul, 0x1000000000000000, 4096, 0);
	test("mul", mul, 0x8000000000000000, 0, 0);
	test("mul", mul, 0x8000000000000000, -1, 0x8000000000000000);
	test("mul", mul, 0x7fffffffffffffff, -1, 0x8000000000000001);
	test("mul", mul, 0x0123456789abcdef, 0xfedcba9876543210, 0x2236d88fe5618cf0);

	//test("div_s", div_s, 1, 0, "integer divide by zero");
	//test("div_s", div_s, 0, 0, "integer divide by zero");
	//test("div_s", div_s, 0x8000000000000000, -1, "integer overflow");
	test("div_s", div_s, 1, 1, 1);
	test("div_s", div_s, 0, 1, 0);
	test("div_s", div_s, -1, -1, 1);
	test("div_s", div_s, 0x8000000000000000, 2, 0xc000000000000000);
	test("div_s", div_s, 0x8000000000000001, 1000, 0xffdf3b645a1cac09);
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
	test("div_u", div_u, 0x8000000000000000L, -1, 0);
	test("div_u", div_u, 0x8000000000000000L, 2, 0x4000000000000000L);
	test("div_u", div_u, 0x8ff00ff00ff00ff0L, 0x100000001L, 0x8ff00fefL);
	test("div_u", div_u, 0x8000000000000001L, 1000, 0x20c49ba5e353f7L);
	test("div_u", div_u, 5, 2, 2);
	test("div_u", div_u, -5, 2, 0x7ffffffffffffffd);
	test("div_u", div_u, 5, -2, 0);
	test("div_u", div_u, -5, -2, 0);
	test("div_u", div_u, 7, 3, 2);
	test("div_u", div_u, 11, 5, 2);
	test("div_u", div_u, 17, 7, 2);

	//test("rem_s", rem_s, 1, 0, "integer divide by zero");
	//test("rem_s", rem_s, 0, 0, "integer divide by zero");
	test("rem_s", rem_s, 0x7fffffffffffffff, -1, 0);
	test("rem_s", rem_s, 1, 1, 0);
	test("rem_s", rem_s, 0, 1, 0);
	test("rem_s", rem_s, -1, -1, 0);
	test("rem_s", rem_s, 0x8000000000000000, -1, 0);
	test("rem_s", rem_s, 0x8000000000000000, 2, 0);
	test("rem_s", rem_s, 0x8000000000000001, 1000, -807);
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
	test("rem_u", rem_u, 0x8000000000000000L, -1, 0x8000000000000000L);
	test("rem_u", rem_u, 0x8000000000000000L, 2, 0);
	test("rem_u", rem_u, 0x8ff00ff00ff00ff0L, 0x100000001L, 0x80000001L);
	test("rem_u", rem_u, 0x8000000000000001L, 1000, 809);
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
	test("and", and, 0x7fffffffffffffffL, 0x8000000000000000L, 0);
	test("and", and, 0x7fffffffffffffffL, -1, 0x7fffffffffffffffL);
	test("and", and, 0xf0f0ffffL, 0xfffff0f0L, 0xf0f0f0f0L);
	test("and", and, 0xffffffffffffffffL, 0xffffffffffffffffL, 0xffffffffffffffffL);

	test("or", or, 1, 0, 1);
	test("or", or, 0, 1, 1);
	test("or", or, 1, 1, 1);
	test("or", or, 0, 0, 0);
	test("or", or, 0x7fffffffffffffffL, 0x8000000000000000L, -1);
	test("or", or, 0x8000000000000000L, 0, 0x8000000000000000L);
	test("or", or, 0xf0f0ffffL, 0xfffff0f0L, 0xffffffffL);
	test("or", or, 0xffffffffffffffffL, 0xffffffffffffffffL, 0xffffffffffffffffL);

	test("xor", xor, 1, 0, 1);
	test("xor", xor, 0, 1, 1);
	test("xor", xor, 1, 1, 0);
	test("xor", xor, 0, 0, 0);
	test("xor", xor, 0x7fffffffffffffffL, 0x8000000000000000L, -1);
	test("xor", xor, 0x8000000000000000L, 0, 0x8000000000000000L);
	test("xor", xor, -1, 0x8000000000000000L, 0x7fffffffffffffffL);
	test("xor", xor, -1, 0x7fffffffffffffffL, 0x8000000000000000L);
	test("xor", xor, 0xf0f0ffffL, 0xfffff0f0L, 0x0f0f0f0fL);
	test("xor", xor, 0xffffffffffffffffL, 0xffffffffffffffffL, 0);

	test("shl", shl, 1, 1, 2);
	test("shl", shl, 1, 0, 1);
	test("shl", shl, 0x7fffffffffffffffL, 1, 0xfffffffffffffffeL);
	test("shl", shl, 0xffffffffffffffffL, 1, 0xfffffffffffffffeL);
	test("shl", shl, 0x8000000000000000L, 1, 0);
	test("shl", shl, 0x4000000000000000L, 1, 0x8000000000000000L);
	test("shl", shl, 1, 63, 0x8000000000000000L);
	test("shl", shl, 1, 64, 1);
	test("shl", shl, 1, 65, 2);
	test("shl", shl, 1, -1, 0x8000000000000000L);
	test("shl", shl, 1, 0x7fffffffffffffffL, 0x8000000000000000L);

	test("shr_s", shr_s, 1, 1, 0);
	test("shr_s", shr_s, 1, 0, 1);
	test("shr_s", shr_s, -1, 1, -1);
	test("shr_s", shr_s, 0x7fffffffffffffffL, 1, 0x3fffffffffffffffL);
	test("shr_s", shr_s, 0x8000000000000000L, 1, 0xc000000000000000L);
	test("shr_s", shr_s, 0x4000000000000000L, 1, 0x2000000000000000L);
	test("shr_s", shr_s, 1, 64, 1);
	test("shr_s", shr_s, 1, 65, 0);
	test("shr_s", shr_s, 1, -1, 0);
	test("shr_s", shr_s, 1, 0x7fffffffffffffffL, 0);
	test("shr_s", shr_s, 1, 0x8000000000000000L, 1);
	test("shr_s", shr_s, 0x8000000000000000L, 63, -1);
	test("shr_s", shr_s, -1, 64, -1);
	test("shr_s", shr_s, -1, 65, -1);
	test("shr_s", shr_s, -1, -1, -1);
	test("shr_s", shr_s, -1, 0x7fffffffffffffffL, -1);
	test("shr_s", shr_s, -1, 0x8000000000000000L, -1);

	test("shr_u", shr_u, 1, 1, 0);
	test("shr_u", shr_u, 1, 0, 1);
	test("shr_u", shr_u, -1, 1, 0x7fffffffffffffffL);
	test("shr_u", shr_u, 0x7fffffffffffffffL, 1, 0x3fffffffffffffffL);
	test("shr_u", shr_u, 0x8000000000000000L, 1, 0x4000000000000000L);
	test("shr_u", shr_u, 0x4000000000000000L, 1, 0x2000000000000000L);
	test("shr_u", shr_u, 1, 64, 1);
	test("shr_u", shr_u, 1, 65, 0);
	test("shr_u", shr_u, 1, -1, 0);
	test("shr_u", shr_u, 1, 0x7fffffffffffffffL, 0);
	test("shr_u", shr_u, 1, 0x8000000000000000L, 1);
	test("shr_u", shr_u, 0x8000000000000000L, 63, 1);
	test("shr_u", shr_u, -1, 64, -1);
	test("shr_u", shr_u, -1, 65, 0x7fffffffffffffffL);
	test("shr_u", shr_u, -1, -1, 1);
	test("shr_u", shr_u, -1, 0x7fffffffffffffffL, 1);
	test("shr_u", shr_u, -1, 0x8000000000000000L, -1);

	test("rotl", rotl, 1, 1, 2);
	test("rotl", rotl, 1, 0, 1);
	test("rotl", rotl, -1, 1, -1);
	test("rotl", rotl, 0xabd1234ef567809cL, 63, 0x55e891a77ab3c04eL);
	test("rotl", rotl, 0xabd1234ef567809cL, 0x800000000000003fL, 0x55e891a77ab3c04eL);
	test("rotl", rotl, 1, 63, 0x8000000000000000L);
	test("rotl", rotl, 0x8000000000000000L, 1, 1);

	test("rotr", rotr, 1, 1, 0x8000000000000000L);
	test("rotr", rotr, 1, 0, 1);
	test("rotr", rotr, -1, 1, -1);
	test("rotr", rotr, 0xabcd1234ef567809L, 53, 0x6891a77ab3c04d5eL);
	test("rotr", rotr, 0xabcd1234ef567809L, 0x35L, 0x6891a77ab3c04d5eL);
	test("rotr", rotr, 0xabcd1234ef567809L, 0xf5L, 0x6891a77ab3c04d5eL);
	test("rotr", rotr, 1, 1, 0x8000000000000000L);
	test("rotr", rotr, 0x8000000000000000L, 63, 1);

	// TODO more tests

	io.output.flush();
	return statusFlag;
}

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
