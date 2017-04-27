module testfuncs;

import io = watt.io;


/**
 * This variable is set if any test fails.
 */
global statusFlag: i32;

/**
 * Call this to tidy any state, flush output and return the test status.
 */
fn getResult() i32
{
	io.output.flush();
	return statusFlag;
}


/*
 *
 * I32 test functions.
 *
 */

fn test(name: string, f: fn!C(i32, i32) i32, l: i32, r: i32, expect: i32)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("%s(0x%08x, 0x%08x) = 0x%08x", name, l, r, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%08x (%s)", ret, ret);
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
		io.error.writefln("%s(0x%08x) = 0x%08x", name, v, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%08x (%s)", ret, ret);
		io.error.flush();
	}
}


/*
 *
 * I64 test functions.
 *
 */

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


/*
 *
 * F32 test functions.
 *
 */

fn test(name: string, f: fn!C(f32, f32) f32, l: f32, r: f32, expect: f32)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("FAIL expect: %s", expect);
		io.error.writefln("        ret: %s", ret);
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(f32) f32, v: f32, expect: f32)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(v);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s) = %s", name, v, expect);
		io.error.writefln("FAIL expect: %s", expect);
		io.error.writefln("        ret: %s", ret);
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(f32, f32) i32, l: f32, r: f32, expect: i32)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("%s(%s, %s) = 0x%08x", name, l, r, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%08x (%s)", ret, ret);
		io.error.flush();
	}
}


/*
 *
 * F32 test functions.
 *
 */

fn test(name: string, f: fn!C(f64, f64) f64, l: f64, r: f64, expect: f64)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("FAIL expect: %s", expect);
		io.error.writefln("        ret: %s", ret);
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(f64) f64, v: f64, expect: f64)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(v);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s) = %s", name, v, expect);
		io.error.writefln("FAIL expect: %s", expect);
		io.error.writefln("        ret: %s", ret);
		io.error.flush();
	}
}

fn test(name: string, f: fn!C(f64, f64) i32, l: f64, r: f64, expect: i32)
{
	//io.output.writefln("%s(%s, %s) = %s", name, l, r, expect);
	//io.output.flush();
	ret := f(l, r);

	if (expect != ret) {
		statusFlag |= 1;
		io.error.writefln("%s(%s, %s) = %s", name, l, r, expect);
		io.error.writefln("%s(%s, %s) = 0x%08x", name, l, r, expect);
		io.error.writefln("FAIL expect: 0x%08x (%s)", expect, expect);
		io.error.writefln("        ret: 0x%08x (%s)", ret, ret);
		io.error.flush();
	}
}
