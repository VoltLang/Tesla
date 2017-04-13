// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module wasm.reader;

import watt.text.format : format;
import wasm.leb;
import wasm.defines;
import wasm.structs;


enum SkipOrParse : u8
{
	Skip  = 0,
	Parse = 1,
}

abstract class Reader
{
	abstract fn onHeader(ref header: Header);

	abstract fn onSection(id: Section, data: const(u8)[]) SkipOrParse;
	abstract fn onCustomSection(name: string, data: const(u8)[]);

	abstract fn onTypeSection(count: u32);
	abstract fn onTypeEntry(num: u32, from: Type, args: Type[], ret: Type);

	abstract fn onImportSection(count: u32);
	abstract fn onImportGlobal(num: u32, mod: string, field: string, t: Type, mut: bool);
	abstract fn onImportFunc(num: u32, mod: string, field: string, index: u32);

	abstract fn onFunctionSection(count: u32);
	abstract fn onFunctionEntry(num: u32, index: u32);

	abstract fn onTableSection(count: u32);
	abstract fn onTableEntry(num: u32, elem_type: Type, l: Limits);

	abstract fn onMemorySection(count: u32);
	abstract fn onMemoryEntry(num: u32, l: Limits);

	abstract fn onExportSection(count: u32);
	abstract fn onExportEntry(num: u32, name: string, kind: wasm.ExternalKind, index: u32);

	abstract fn onStart(index: u32);

	abstract fn onCodeSection(count: u32);
	abstract fn onFunctionBody(num: u32, types: Type[], counts: u32[]);
	abstract fn onFunctionBodyEnd(num: u32);
	abstract fn onCode(data: const(u8)[]);
	abstract fn onOp(op: Opcode);
	abstract fn onControl(op: Opcode, t: Type);
	abstract fn onBranch(op: Opcode, relative_depth: u32);
	abstract fn onCall(index: u32);
	abstract fn onCallIndirect(typeIndex: u32);
	abstract fn onOpMemory(op: Opcode, flags: u32, offset: u32);
	abstract fn onOpVar(op: Opcode, index: u32);
	abstract fn onOpI32Const(v: i32);

	abstract fn onReadError(err: string);
	abstract fn onEOF();
}

fn readFile(r: Reader, data: const(u8)[])
{
	ret: i32;
	index: u32;
	headerSize := cast(u32)typeid(Header).size;

	if (data.length < headerSize) {
		r.onReadError("invalid header");
		return;
	}

	r.onHeader(ref *cast(wasm.Header*)data.ptr);

	data = data[headerSize .. $];

	while (data.length > 0) {
		id: wasm.Section;
		payload_len: u32;

		if (data.readV(out id)) {
			return r.onReadError("failed to read section id");
		}

		if (data.readV(out payload_len)) {
			return r.onReadError("failed to read payload_len");
		}

		if (payload_len > data.length) {
			return r.onReadError("section size larger then file.");
		}

		s := data[0 .. payload_len];
		data = data[payload_len .. $];

		if (r.onSection(id, s) != SkipOrParse.Parse) {
			continue;
		}

		final switch (id) with (Section) {
		case Custom: readCustomSection(r, s); break;
		case Type: readTypeSection(r, s); break;
		case Import: readImportSection(r, s); break;
		case Function: readFunctionSection(r, s); break;
		case Table: readTableSection(r, s); break;
		case Memory: readMemorySection(r, s); break;
		case Global: readGlobalSection(r, s); break;
		case Export: readExportSection(r, s); break;
		case Start: readStartSection(r, s); break;
		case Element: readElementSection(r, s); break;
		case Code: readCodeSection(r, s); break;
		case Data: readDataSection(r, s); break;
		}
	}

	r.onEOF();
}

fn readCustomSection(r: Reader, data: const(u8)[])
{
	name: string;
	if (data.readV(out name)) {
		r.onReadError("failed to read custom section");
	}

	r.onCustomSection(name, data);
}

fn readTypeSection(r: Reader, data: const(u8)[])
{
	count: u32;
	num: u32;
	if (data.readV(out count)) {
		r.onReadError("failed to read type section");
	}
	r.onTypeSection(count);

	while (count-- > 0) {
		readTypeEntry(r, num++, ref data);
	}
}

fn readTypeEntry(r: Reader, num: u32, ref data: const(u8)[])
{
	i: u32;
	from: Type;
	param_count: u32;
	param_types: Type[32];
	return_count: u32;
	return_type: Type = Type.Void;

	if (data.readV(out from) ||
	    data.readV(out param_count) ||
	    param_count > 32) {
		return r.onReadError("failed to read type entry");
	}

	foreach (ref t; param_types[0 .. param_count]) {
		if (data.readV(out t)) {
			return r.onReadError("failed to read param_type");
		}
	}

	if (data.readV(out return_count) || return_count > 1) {
		return r.onReadError("failed to read return_count");
	}

	if (return_count == 1 && data.readV(out return_type)) {
		return r.onReadError("failed to read return_type");
	}

	r.onTypeEntry(num, from, new param_types[0 .. param_count], return_type);
}

fn readImportSection(r: Reader, data: const(u8)[])
{
	num: u32;
	count: u32;
	if (data.readV(out count)) {
		r.onReadError("failed to read import section");
	}
	r.onImportSection(count);

	while (count-- > 0) {
		readImportEntry(r, num++, ref data);
	}
}

fn readImportEntry(r: Reader, num: u32, ref data: const(u8)[])
{
	external_kind: u8;
	mod: const(char)[];
	field: const(char)[];

	if (data.readV(out mod) ||
	    data.readV(out field) ||
	    data.readF(out external_kind)) {
		return r.onReadError("failed to read import entry");
	}

	switch (external_kind) with (ExternalKind)  {
	case Global:
		type: i8;
		mut: u32;
		if (data.readV(out type) || data.readV(out mut)) {
			return r.onReadError("failed to read import entry");
		}
		r.onImportGlobal(num, mod, field, type, cast(bool)mut);
		break;
	case Function:
		index: u32;
		if (data.readV(out index)) {
			return r.onReadError("failed to read import entry");
		}
		r.onImportFunc(num, mod, field, index);
		break;
	default:
		r.onReadError("unhandled import entry");
	}
}

fn readFunctionSection(r: Reader, data: const(u8)[])
{
	num: u32;
	count: u32;
	if (data.readV(out count)) {
		r.onReadError("failed to read function section");
	}
	r.onFunctionSection(count);

	while (count-- > 0) {
		index: u32;
		if (data.readV(out index)) {
			r.onReadError("failed to read function entry");
		}
		r.onFunctionEntry(num++, index);
	}
}

fn readTableSection(r: Reader, data: const(u8)[])
{
	num: u32;
	count: u32;
	elem_type: Type;
	l: Limits;

	if (data.readV(out count) || count > 1) {
		return r.onReadError("failed to read table section");
	}
	r.onTableSection(count);

	while (count-- > 0) {
		if (data.readV(out elem_type) || data.readV(out l)) {
			return r.onReadError("failed to read table section");
		}
		r.onTableEntry(num++, elem_type, l);
	}
}

fn readMemorySection(r: Reader, data: const(u8)[])
{
	num: u32;
	count: u32;
	if (data.readV(out count) || count > 1) {
		return r.onReadError("failed to read memory section");
	}
	r.onMemorySection(count);

	while (count-- > 0) {
		l: Limits;
		if (data.readV(out l)) {
			return r.onReadError("failed to read memory entry");
		}
		r.onMemoryEntry(num++, l);
	}
}

fn readGlobalSection(r: Reader, data: const(u8)[])
{
	r.onReadError("global section");
}

fn readExportSection(r: Reader, data: const(u8)[])
{
	num: u32;
	count: u32;
	if (data.readV(out count)) {
		return r.onReadError("failed to read export section");
	}
	r.onExportSection(count);

	while (count-- > 0) {
		name: string;
		kind: wasm.ExternalKind;
		index: u32;
		if (data.readV(out name) ||
		    data.readV(out kind) ||
		    data.readV(out index)) {
			return r.onReadError("failed to read export entry");
		}
		r.onExportEntry(num++, name, kind, index);
	}
}

fn readStartSection(r: Reader, data: const(u8)[])
{
	index: u32;
	if (data.readV(out index)) {
		return r.onReadError("failed to read start section");
	}
	r.onStart(index);
}

fn readElementSection(r: Reader, data: const(u8)[])
{
	r.onReadError("element section");
}

fn readDataSection(r: Reader, data: const(u8)[])
{
	r.onReadError("data section");
}

fn readCodeSection(r: Reader, data: const(u8)[])
{
	num: u32;
	count: u32;
	if (data.readV(out count)) {
		return r.onReadError("failed to read code section");
	}
	r.onCodeSection(count);
	r.onCode(data);

	while (count-- > 0) {
		readFunctionBody(r, num++, ref data);
	}
}

fn readFunctionBody(r: Reader, num: u32, ref data: const(u8)[])
{
	body_size: u32;
	local_count: u32;
	local_types: Type[4];
	local_counts: u32[4];

	if (data.readV(out body_size) ||
	    body_size > data.length ||
	    data[body_size-1] != Opcode.End) {
		return r.onReadError("failed to read function body");
	}

	// Only read from the body.
	b := data[0 .. body_size];
	data = data[body_size .. $];

	if (b.readV(out local_count) ||
	    local_count > 4 /* 4 types */) {
		return r.onReadError("failed to read function locals");
	}

	foreach (i; 0 .. local_count) {
		if (b.readV(out local_counts[i]) ||
		    b.readV(out local_types[i])) {
			return r.onReadError("failed to read function locals");
		}
	}

	r.onFunctionBody(num, new local_types[0 .. local_count],
	                      new local_counts[0 .. local_count]);

	while (b.length > 1) {
		op: Opcode;
		if (b.readF(out op)) {
			return r.onReadError("failed to read opcode");
		}

		final switch (op.opKind()) with (OpcodeKind) {
		case Error:
			str := format("invalid opcode value '0x%02x'", op);
			return r.onReadError(str);
		case Unhandled:
			str := format("unhandled opcode '%s'", op.opToString());
			return r.onReadError(str);
		case Regular:
			r.onOp(op);
			break;
		case Control:
			r.onControl(op, Type.Void);
			break;
		case ControlType:
			t: Type;
			if (b.readV(out t)) {
				return r.onReadError("failed to read control type opcode");
			}
			r.onControl(op, t);
			break;
		case Branch:
			relative_depth: u32;
			if (b.readV(out relative_depth)) {
				return r.onReadError("failed to read branch opcode");
			}
			r.onBranch(op, relative_depth);
			break;
		case BranchTable:
			str := format("unhandled branch opcode '%s'", op.opToString());
			return r.onReadError(str);
		case Call:
			i: u32;
			if (b.readV(out i)) {
				return r.onReadError("failed to read call opcode");
			}
			r.onCall(i);
			break;
		case CallIndirect:
			typeIndex: u32;
			res: u32;
			if (b.readV(out typeIndex) || b.readV(out res) || res != 0) {
				return r.onReadError("failed to read call_indirect opcode");
			}
			r.onCallIndirect(typeIndex);
			break;
		case Memory:
			flags, offset: u32;
			if (b.readV(out flags) || b.readV(out offset)) {
				return r.onReadError("failed to read memory opcode");
			}
			r.onOpMemory(op, flags, offset);
			break;
		case VarAccess:
			i: u32;
			if (b.readV(out i)) {
				return r.onReadError("failed to read var opcode");
			}
			r.onOpVar(op, i);
			break;
		case I32Const:
			i: i32;
			if (b.readV(out i)) {
				return r.onReadError("failed to read i32.const opcode");
			}
			r.onOpI32Const(i);
			break;
		}
	}

	if (b.length != 1 || b[0] != Opcode.End) {
		return r.onReadError("function body not correctly terminated");
	}

	r.onFunctionBodyEnd(num);
}

enum OpcodeKind
{
	Error,        // Invalid value.
	Regular,      // Opcode with no extra imms.
	Control,      // Control without return type.
	ControlType,  // Control with return type.
	Branch,       // Branch with relative_depth argument.
	BranchTable,  // Branch with table argument.
	Call,         // Direct call with immediate. 
	CallIndirect, //
	Memory,       // Memory access opcodes.
	VarAccess,    // Get/set/tee local/global.
	I32Const,     // Constants
	Unhandled,    // Lazy programmer.
}

fn opKind(op: Opcode) OpcodeKind
{
	switch (op) with (Opcode) {
	case Unreachable, Nop:
		return OpcodeKind.Regular;
	case Block, Loop, If:
		return OpcodeKind.ControlType;
	case Else, End:
		return OpcodeKind.Control;
	case Br, BrIf:
		return OpcodeKind.Branch;
	case BrTable:
		return OpcodeKind.BranchTable;
	case Return:
		return OpcodeKind.Control;
	case Call:
		return OpcodeKind.Call;
	case CallIndirect:
		return OpcodeKind.CallIndirect;
	case Drop, Select:
		return OpcodeKind.Regular; // Parametric
	case GetLocal, SetLocal, TeeLocal, GetGlobal, SetGlobal:
		return OpcodeKind.VarAccess;
	case I32Load, I64Load, F32Load, F64Load, I32Load8S, I32Load8U,
	     I32Load16S, I32Load16U, I64Load8S, I64Load8U, I64Load16S,
	     I64Load16U, I64Load32S, I64Load32U, I32Store, I64Store, F32Store,
	     F64Store, I32Store8, I32Store16, I64Store8, I64Store16, I64Store32:
		return OpcodeKind.Memory;
	case CurrentMemory, GrowMemory:
		return OpcodeKind.Unhandled;
	case I32Const:
		return OpcodeKind.I32Const;
	case I64Const, F32Const, F64Const:
		return OpcodeKind.Unhandled;
	case I32Clz, I32Ctz, I32Popcnt, I32Add, I32Sub, I32Mul, I32DivS,
	     I32DivU, I32RemS, I32RemU, I32And, I32Or, I32Xor, I32Shl, I32ShrS,
	     I32ShrU, I32Rotl, I32Rotr, I64Clz, I64Ctz, I64Popcnt, I64Add,
	     I64Sub, I64Mul, I64DivS, I64DivU, I64RemS, I64RemU, I64And, I64Or,
	     I64Xor, I64Shl, I64ShrS, I64ShrU, I64Rotl, I64Rotr, F32Abs, F32Neg,
	     F32Ceil, F32Floor, F32Trunc, F32Nearest, F32Sqrt, F32Add, F32Sub,
	     F32Mul, F32Div, F32Min, F32Max, F32Copysign, F64Abs, F64Neg,
	     F64Ceil, F64Floor, F64Trunc, F64Nearest, F64Sqrt, F64Add, F64Sub,
	     F64Mul, F64Div, F64Min, F64Max, F64Copysign:
		return OpcodeKind.Regular; // Arith
	case I32Eqz, I32Eq, I32Ne, I32LtS, I32LtU, I32GtS, I32GtU, I32LeS, I32LeU,
	     I32GeS, I32GeU, I64Eqz, I64Eq, I64Ne, I64LtS, I64LtU, I64GtS, I64GtU,
	     I64LeS, I64LeU, I64GeS, I64GeU, F32Eq, F32Ne, F32Lt, F32Gt, F32Le,
	     F32Ge, F64Eq, F64Ne, F64Lt, F64Gt, F64Le, F64Ge:
		return OpcodeKind.Regular; // Compare
	case I32WrapI64, I32TruncSF32, I32TruncUF32, I32TruncSF64, I32TruncUF64,
	     I64ExtendSI32, I64ExtendUI32, I64TruncSF32, I64TruncUF32,
	     I64TruncSF64, I64TruncUF64, F32ConvertSI32, F32ConvertUI32,
	     F32ConvertSI64, F32ConvertUI64, F32DemoteF64, F64ConvertSI32,
	     F64ConvertUI32, F64ConvertSI64, F64ConvertUI64, F64PromoteF32:
		return OpcodeKind.Regular; // Conversions.
	case I32ReinterpretF32, I64ReinterpretF64,
	     F32ReinterpretI32, F64ReinterpretI64:
		return OpcodeKind.Regular; // Reinterprets.
	default: return OpcodeKind.Error;
	}
}
