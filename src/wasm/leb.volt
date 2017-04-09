// Copyright © 2012-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module util.leb;

import wasm.structs;


fn readULEB128(data: const(u8)[], out v: u32) i32
{
	result: u32;
	shift: u32;
	i: i32;
	b: u8;

	do {
		if (i >= cast(i32)data.length) {
			return -1;
		}

		b = data[i];
		result |= cast(u32)(b & 0x7f) << shift;
		shift += 7;
		i += 1;
	} while (b & 0x80);

	data = data[i .. $];

	v = result;

	return i;
}

fn readSLEB128(data: const(u8)[], out v: i32) i32
{
	result: i32;
	shift: i32;
	i: i32;
	b: u8;

	do {
		if (i >= cast(i32)data.length) {
			return -1;
		}

		b = data[i];
		result |= cast(i32)(b & 0x7f) << shift;
		shift += 7;
		i += 1;
	} while (b & 0x80);

	if ((b & 0x40) != 0 && (shift < cast(i32)typeid(i32).size * 8)) {
		result |= (cast(i32)-1 << shift);
	}

	v = result;

	return i;
}

fn readF(ref data: const(u8)[], out v: u8) bool
{
	if (data.length < 1) {
		return true;
	}
	v = data[0];
	data = data[1 .. $];
	return false;
}

fn readV(ref data: const(u8)[], out l: Limits) bool
{
	return data.readV(out l.flags) ||
	       data.readV(out l.initial) ||
               (l.flags && data.readV(out l.maximum));
}

fn readV(ref data: const(u8)[], out v: u8) bool
{
	r: u32;
	ret := data.readULEB128(out r);
	if (ret < 0) {
		return true;
	}
	v = cast(u8)r;
	data = data[ret .. $];
	return false;
}

fn readV(ref data: const(u8)[], out v: i8) bool
{
	r: i32;
	ret := data.readSLEB128(out r);
	if (ret < 0) {
		return true;
	}
	v = cast(i8)r;
	data = data[ret .. $];
	return false;
}

fn readV(ref data: const(u8)[], out v: u32) bool
{
	ret := data.readULEB128(out v);
	if (ret < 0) {
		return true;
	}
	data = data[ret .. $];
	return false;
}

fn readV(ref data: const(u8)[], out v: i32) bool
{
	ret := data.readSLEB128(out v);
	if (ret < 0) {
		return true;
	}
	data = data[ret .. $];
	return false;
}

fn readV(ref data: const(u8)[], out v: const(char)[]) bool
{
	len: u32;
	ret := data.readULEB128(out len);
	if (ret < 0) {
		return true;
	}

	end := cast(u32)ret + len;
	if (end > data.length) {
		return true;
	}

	v = cast(const(char)[])data[ret .. end];
	data = data[end .. $];
	return false;

}
