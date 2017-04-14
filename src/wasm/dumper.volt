// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module wasm.dumper;

import core.c.stdlib : exit;
import io = watt.io;
import watt.text.format : format;

import wasm.defines;
import wasm.structs;
import wasm.reader;


class Dumper : Reader
{
	override fn onHeader(ref header: Header)
	{
		io.writefln("(module");
	}

	override fn onSection(id: Section, data: const(u8)[]) SkipOrParse
	{
		switch (id) with (Section) {
		case Element, Data: return SkipOrParse.Skip;
		default: return SkipOrParse.Parse;
		}
	}

	override fn onTypeEntry(num: u32, from: Type, args: Type[], ret: Type)
	{
		f := typeToString(from);
		a: string[];
		r := typeToString(ret);
		foreach (t; args) {
			a ~= typeToString(t);
		}

		io.writefln(`  (type (%s (param %s) (result %s)))`, f, a, r);
	}

	override fn onImportGlobal(num: u32, mod: string, field: string, t: Type, mut: bool)
	{
		io.writefln(`  (import "%s" "%s" (global %s %s))`,
			mod, field, mut ? "mut" : "imm",
			typeToString(t));
	}

	override fn onImportFunc(num: u32, mod: string, field: string, index: u32)
	{
		io.writefln(`  (import "%s" "%s" (func (type %s))`,
			mod, field, index);	
	}

	override fn onFunctionEntry(num: u32, index: u32)
	{
		io.writefln(`  (func (type %s))`, index);
	}

	override fn onTableEntry(num: u32, elem_type: Type, l: Limits)
	{
		if (l.flags) {
			io.writefln(`  (table %s %s %s)`, typeToString(elem_type), l.initial, l.maximum);
		} else {
			io.writefln(`  (table %s %s)`, typeToString(elem_type), l.initial);
		}
	}

	override fn onMemoryEntry(num: u32, l: Limits)
	{
		if (l.flags) {
			io.writefln(`  (memory %s %s)`, l.initial, l.maximum);
		} else {
			io.writefln(`  (memory %s)`, l.initial);
		}
	}

	override fn onExportEntry(num: u32, name: string, kind: wasm.ExternalKind, index: u32)
	{
		io.writefln(`  (export "%s" (%s %s))`, name, externalKindToString(kind), index);
	}

	override fn onStart(index: u32)
	{
		io.writefln(`  (start %s)`, index);
	}

	override fn onFunctionBody(num: u32, types: Type[], counts: u32[])
	{
		if (types.length != counts.length) {
			onReadError("missmatching local vars length");
		}

		foreach (i; 0 .. counts.length) {
			str := typeToString(types[i]);
			foreach (k; 0 .. counts[i]) {
				io.writefln(`    (local %s)`, str);
			}
		}
	}

	override fn onFunctionBodyEnd(num: u32)
	{
		io.writefln(`  )`);
	}

	override fn onOp(op: Opcode)
	{
		io.writefln("    %s", opToString(op));
	}

	override fn onControl(op: Opcode, t: Type)
	{
		io.writefln("    %s %s", opToString(op), typeToString(t));
	}

	override fn onBranch(op: Opcode, relative_depth: u32)
	{
		io.writefln("    %s %s", opToString(op), relative_depth);
	}

	override fn onCall(index: u32)
	{
		io.writefln("    call %s", index);
	}

	override fn onCallIndirect(typeIndex: u32)
	{
		io.writefln("    call %s", typeIndex);
	}

	override fn onOpMemory(op: Opcode, flags: u32, offset: u32)
	{
		io.writef("    %s flags=%s", opToString(op), flags);
		if (offset != 0) {
			io.writefln(" offset=%s", offset);
		} else {
			io.writefln("");
		}
	}

	override fn onOpVar(op: Opcode, index: u32)
	{
		io.writefln("    %s %s", opToString(op), index);
	}

	override fn onOpI32Const(v: i32)
	{
		io.writefln("    i32.const %s", v);
	}

	override fn onOpI64Const(v: i64)
	{
		io.writefln("    i64.const %s", v);
	}

	override fn onOpF32Const(v: f32)
	{
		io.writefln("    f32.const %s", v);
	}

	override fn onOpF64Const(v: f64)
	{
		io.writefln("    f64.const %s", v);
	}

	override fn onReadError(err: string)
	{
		io.output.flush();
		io.error.writefln("Error: '%s'", err);
		io.error.flush();
		exit(-1);
	}

	override fn onEOF()
	{
		io.writefln(")");
	}

	override fn onCustomSection(name: string, data: const(u8)[]) {}
	override fn onTypeSection(count: u32) {}
	override fn onImportSection(count: u32) {}
	override fn onFunctionSection(count: u32) {}
	override fn onTableSection(count: u32) {}
	override fn onMemorySection(count: u32) {}
	override fn onExportSection(count: u32) {}
	override fn onCodeSection(count: u32) {}
	override fn onCode(data: const(u8)[]) {}
}
