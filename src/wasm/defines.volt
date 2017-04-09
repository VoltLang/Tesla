// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module wasm.defines;


enum Ident    = 0x6d736100;
enum Version  = 0x00000001;

enum Section : u8
{
	Custom   =  0,
	Type     =  1,
	Import   =  2,
	Function =  3,
	Table    =  4,
	Memory   =  5,
	Global   =  6,
	Export   =  7,
	Start    =  8,
	Element  =  9,
	Code     = 10,
	Data     = 11,
}

enum ExternalKind : u8
{
	Function = 0,
	Table    = 1,
	Memory   = 2,
	Global   = 3,
}

enum Type : i8
{
	I32     = -0x01,
	I64     = -0x02,
	F32     = -0x03,
	F64     = -0x04,
	AnyFunc = -0x10,
	Func    = -0x20,
	Void    = -0x40,
}

enum Opcode : u8
{
	Unreachable       = 0x00,
	Nop               = 0x01,
	Block             = 0x02,
	Loop              = 0x03,
	If                = 0x04,
	Else              = 0x05,
	End               = 0x0b,
	Br                = 0x0c,
	BrIf              = 0x0d,
	BrTable           = 0x0e,
	Return            = 0x0f,
	Call              = 0x10,
	CallIndirect      = 0x11,
	Drop              = 0x1a,
	Select            = 0x1b,
	GetLocal          = 0x20,
	SetLocal          = 0x21,
	TeeLocal          = 0x22,
	GetGlobal         = 0x23,
	SetGlobal         = 0x24,
	I32Load           = 0x28,
	I64Load           = 0x29,
	F32Load           = 0x2a,
	F64Load           = 0x2b,
	I32Load8S         = 0x2c,
	I32Load8U         = 0x2d,
	I32Load16S        = 0x2e,
	I32Load16U        = 0x2f,
	I64Load8S         = 0x30,
	I64Load8U         = 0x31,
	I64Load16S        = 0x32,
	I64Load16U        = 0x33,
	I64Load32S        = 0x34,
	I64Load32U        = 0x35,
	I32Store          = 0x36,
	I64Store          = 0x37,
	F32Store          = 0x38,
	F64Store          = 0x39,
	I32Store8         = 0x3a,
	I32Store16        = 0x3b,
	I64Store8         = 0x3c,
	I64Store16        = 0x3d,
	I64Store32        = 0x3e,
	CurrentMemory     = 0x3f,
	GrowMemory        = 0x40,
	I32Const          = 0x41,
	I64Const          = 0x42,
	F32Const          = 0x43,
	F64Const          = 0x44,
	I32Eqz            = 0x45,
	I32Eq             = 0x46,
	I32Ne             = 0x47,
	I32LtS            = 0x48,
	I32LtU            = 0x49,
	I32GtS            = 0x4a,
	I32GtU            = 0x4b,
	I32LeS            = 0x4c,
	I32LeU            = 0x4d,
	I32GeS            = 0x4e,
	I32GeU            = 0x4f,
	I64Eqz            = 0x50,
	I64Eq             = 0x51,
	I64Ne             = 0x52,
	I64LtS            = 0x53,
	I64LtU            = 0x54,
	I64GtS            = 0x55,
	I64GtU            = 0x56,
	I64LeS            = 0x57,
	I64LeU            = 0x58,
	I64GeS            = 0x59,
	I64GeU            = 0x5a,
	F32Eq             = 0x5b,
	F32Ne             = 0x5c,
	F32Lt             = 0x5d,
	F32Gt             = 0x5e,
	F32Le             = 0x5f,
	F32Ge             = 0x60,
	F64Eq             = 0x61,
	F64Ne             = 0x62,
	F64Lt             = 0x63,
	F64Gt             = 0x64,
	F64Le             = 0x65,
	F64Ge             = 0x66,
	I32Clz            = 0x67,
	I32Ctz            = 0x68,
	I32Popcnt         = 0x69,
	I32Add            = 0x6a,
	I32Sub            = 0x6b,
	I32Mul            = 0x6c,
	I32DivS           = 0x6d,
	I32DivU           = 0x6e,
	I32RemS           = 0x6f,
	I32RemU           = 0x70,
	I32And            = 0x71,
	I32Or             = 0x72,
	I32Xor            = 0x73,
	I32Shl            = 0x74,
	I32ShrS           = 0x75,
	I32ShrU           = 0x76,
	I32Rotl           = 0x77,
	I32Rotr           = 0x78,
	I64Clz            = 0x79,
	I64Ctz            = 0x7a,
	I64Popcnt         = 0x7b,
	I64Add            = 0x7c,
	I64Sub            = 0x7d,
	I64Mul            = 0x7e,
	I64DivS           = 0x7f,
	I64DivU           = 0x80,
	I64RemS           = 0x81,
	I64RemU           = 0x82,
	I64And            = 0x83,
	I64Or             = 0x84,
	I64Xor            = 0x85,
	I64Shl            = 0x86,
	I64ShrS           = 0x87,
	I64ShrU           = 0x88,
	I64Rotl           = 0x89,
	I64Rotr           = 0x8a,
	F32Abs            = 0x8b,
	F32Neg            = 0x8c,
	F32Ceil           = 0x8d,
	F32Floor          = 0x8e,
	F32Trunc          = 0x8f,
	F32Nearest        = 0x90,
	F32Sqrt           = 0x91,
	F32Add            = 0x92,
	F32Sub            = 0x93,
	F32Mul            = 0x94,
	F32Div            = 0x95,
	F32Min            = 0x96,
	F32Max            = 0x97,
	F32Copysign       = 0x98,
	F64Abs            = 0x99,
	F64Neg            = 0x9a,
	F64Ceil           = 0x9b,
	F64Floor          = 0x9c,
	F64Trunc          = 0x9d,
	F64Nearest        = 0x9e,
	F64Sqrt           = 0x9f,
	F64Add            = 0xa0,
	F64Sub            = 0xa1,
	F64Mul            = 0xa2,
	F64Div            = 0xa3,
	F64Min            = 0xa4,
	F64Max            = 0xa5,
	F64Copysign       = 0xa6,
	I32WrapI64        = 0xa7,
	I32TruncSF32      = 0xa8,
	I32TruncUF32      = 0xa9,
	I32TruncSF64      = 0xaa,
	I32TruncUF64      = 0xab,
	I64ExtendSI32     = 0xac,
	I64ExtendUI32     = 0xad,
	I64TruncSF32      = 0xae,
	I64TruncUF32      = 0xaf,
	I64TruncSF64      = 0xb0,
	I64TruncUF64      = 0xb1,
	F32ConvertSI32    = 0xb2,
	F32ConvertUI32    = 0xb3,
	F32ConvertSI64    = 0xb4,
	F32ConvertUI64    = 0xb5,
	F32DemoteF64      = 0xb6,
	F64ConvertSI32    = 0xb7,
	F64ConvertUI32    = 0xb8,
	F64ConvertSI64    = 0xb9,
	F64ConvertUI64    = 0xba,
	F64PromoteF32     = 0xbb,
	I32ReinterpretF32 = 0xbc,
	I64ReinterpretF64 = 0xbd,
	F32ReinterpretI32 = 0xbe,
	F64ReinterpretI64 = 0xbf,
}

fn sectionToString(s: Section) string
{
	final switch (s) with (Section) {
	case Custom:   return "custom";
	case Type:     return "type";
	case Import:   return "import";
	case Function: return "function";
	case Table:    return "table";
	case Memory:   return "memory";
	case Global:   return "global";
	case Export:   return "export";
	case Start:    return "start";
	case Element:  return "element";
	case Code:     return "code";
	case Data:     return "data";
	}
}

fn externalKindToString(ek: ExternalKind) string
{
	final switch (ek) with (ExternalKind) {
	case Function: return "func";
	case Table:    return "table";
	case Memory:   return "memory";
	case Global:   return "global";
	}
}

fn typeToString(t: Type) string
{
	final switch (t) with (Type) {
	case I32:     return "i32";
	case I64:     return "i64";
	case F32:     return "f32";
	case F64:     return "f64";
	case AnyFunc: return "anyfunc";
	case Func:    return "func";
	case Void:    return "void";
	}
}

fn opToString(op: Opcode) string
{
	switch (op) with (Opcode) {
	case Unreachable:       return "unreachable";
	case Nop:               return "nop";
	case Block:             return "block";
	case Loop:              return "loop";
	case If:                return "if";
	case Else:              return "else";
	case End:               return "end";
	case Br:                return "br";
	case BrIf:              return "br_if";
	case BrTable:           return "br_table";
	case Return:            return "return";
	case Call:              return "call";
	case CallIndirect:      return "call_indirect";
	case Drop:              return "drop";
	case Select:            return "select";
	case GetLocal:          return "get_local";
	case SetLocal:          return "set_local";
	case TeeLocal:          return "tee_local";
	case GetGlobal:         return "get_global";
	case SetGlobal:         return "set_global";
	case I32Load:           return "i32.load";
	case I64Load:           return "i64.load";
	case F32Load:           return "f32.load";
	case F64Load:           return "f64.load";
	case I32Load8S:         return "i32.load8_s";
	case I32Load8U:         return "i32.load8_u";
	case I32Load16S:        return "i32.load16_s";
	case I32Load16U:        return "i32.load16_u";
	case I64Load8S:         return "i64.load8_s";
	case I64Load8U:         return "i64.load8_u";
	case I64Load16S:        return "i64.load16_s";
	case I64Load16U:        return "i64.load16_u";
	case I64Load32S:        return "i64.load32_s";
	case I64Load32U:        return "i64.load32_u";
	case I32Store:          return "i32.store";
	case I64Store:          return "i64.store";
	case F32Store:          return "f32.store";
	case F64Store:          return "f64.store";
	case I32Store8:         return "i32.store8";
	case I32Store16:        return "i32.store16";
	case I64Store8:         return "i64.store8";
	case I64Store16:        return "i64.store16";
	case I64Store32:        return "i64.store32";
	case CurrentMemory:     return "current_memory";
	case GrowMemory:        return "grow_memory";
	case I32Const:          return "i32.const";
	case I64Const:          return "i64.const";
	case F32Const:          return "f32.const";
	case F64Const:          return "f64.const";
	case I32Eqz:            return "i32.eqz";
	case I32Eq:             return "i32.eq";
	case I32Ne:             return "i32.ne";
	case I32LtS:            return "i32.lt_s";
	case I32LtU:            return "i32.lt_u";
	case I32GtS:            return "i32.gt_s";
	case I32GtU:            return "i32.gt_u";
	case I32LeS:            return "i32.le_s";
	case I32LeU:            return "i32.le_u";
	case I32GeS:            return "i32.ge_s";
	case I32GeU:            return "i32.ge_u";
	case I64Eqz:            return "i64.eqz";
	case I64Eq:             return "i64.eq";
	case I64Ne:             return "i64.ne";
	case I64LtS:            return "i64.lt_s";
	case I64LtU:            return "i64.lt_u";
	case I64GtS:            return "i64.gt_s";
	case I64GtU:            return "i64.gt_u";
	case I64LeS:            return "i64.le_s";
	case I64LeU:            return "i64.le_u";
	case I64GeS:            return "i64.ge_s";
	case I64GeU:            return "i64.ge_u";
	case F32Eq:             return "f32.eq";
	case F32Ne:             return "f32.ne";
	case F32Lt:             return "f32.lt";
	case F32Gt:             return "f32.gt";
	case F32Le:             return "f32.le";
	case F32Ge:             return "f32.ge";
	case F64Eq:             return "f64.eq";
	case F64Ne:             return "f64.ne";
	case F64Lt:             return "f64.lt";
	case F64Gt:             return "f64.gt";
	case F64Le:             return "f64.le";
	case F64Ge:             return "f64.ge";
	case I32Clz:            return "i32.clz";
	case I32Ctz:            return "i32.ctz";
	case I32Popcnt:         return "i32.popcnt";
	case I32Add:            return "i32.add";
	case I32Sub:            return "i32.sub";
	case I32Mul:            return "i32.mul";
	case I32DivS:           return "i32.div_s";
	case I32DivU:           return "i32.div_u";
	case I32RemS:           return "i32.rem_s";
	case I32RemU:           return "i32.rem_u";
	case I32And:            return "i32.and";
	case I32Or:             return "i32.or";
	case I32Xor:            return "i32.xor";
	case I32Shl:            return "i32.shl";
	case I32ShrS:           return "i32.shr_s";
	case I32ShrU:           return "i32.shr_u";
	case I32Rotl:           return "i32.rotl";
	case I32Rotr:           return "i32.rotr";
	case I64Clz:            return "i64.clz";
	case I64Ctz:            return "i64.ctz";
	case I64Popcnt:         return "i64.popcnt";
	case I64Add:            return "i64.add";
	case I64Sub:            return "i64.sub";
	case I64Mul:            return "i64.mul";
	case I64DivS:           return "i64.div_s";
	case I64DivU:           return "i64.div_u";
	case I64RemS:           return "i64.rem_s";
	case I64RemU:           return "i64.rem_u";
	case I64And:            return "i64.and";
	case I64Or:             return "i64.or";
	case I64Xor:            return "i64.xor";
	case I64Shl:            return "i64.shl";
	case I64ShrS:           return "i64.shr_s";
	case I64ShrU:           return "i64.shr_u";
	case I64Rotl:           return "i64.rotl";
	case I64Rotr:           return "i64.rotr";
	case F32Abs:            return "f32.abs";
	case F32Neg:            return "f32.neg";
	case F32Ceil:           return "f32.ceil";
	case F32Floor:          return "f32.floor";
	case F32Trunc:          return "f32.trunc";
	case F32Nearest:        return "f32.nearest";
	case F32Sqrt:           return "f32.sqrt";
	case F32Add:            return "f32.add";
	case F32Sub:            return "f32.sub";
	case F32Mul:            return "f32.mul";
	case F32Div:            return "f32.div";
	case F32Min:            return "f32.min";
	case F32Max:            return "f32.max";
	case F32Copysign:       return "f32.copysign";
	case F64Abs:            return "f64.abs";
	case F64Neg:            return "f64.neg";
	case F64Ceil:           return "f64.ceil";
	case F64Floor:          return "f64.floor";
	case F64Trunc:          return "f64.trunc";
	case F64Nearest:        return "f64.nearest";
	case F64Sqrt:           return "f64.sqrt";
	case F64Add:            return "f64.add";
	case F64Sub:            return "f64.sub";
	case F64Mul:            return "f64.mul";
	case F64Div:            return "f64.div";
	case F64Min:            return "f64.min";
	case F64Max:            return "f64.max";
	case F64Copysign:       return "f64.copysign";
	case I32WrapI64:        return "i32.wrap/i64";
	case I32TruncSF32:      return "i32.trunc_s/f32";
	case I32TruncUF32:      return "i32.trunc_u/f32";
	case I32TruncSF64:      return "i32.trunc_s/f64";
	case I32TruncUF64:      return "i32.trunc_u/f64";
	case I64ExtendSI32:     return "i64.extend_s/i32";
	case I64ExtendUI32:     return "i64.extend_u/i32";
	case I64TruncSF32:      return "i64.trunc_s/f32";
	case I64TruncUF32:      return "i64.trunc_u/f32";
	case I64TruncSF64:      return "i64.trunc_s/f64";
	case I64TruncUF64:      return "i64.trunc_u/f64";
	case F32ConvertSI32:    return "f32.convert_s/i32";
	case F32ConvertUI32:    return "f32.convert_u/i32";
	case F32ConvertSI64:    return "f32.convert_s/i64";
	case F32ConvertUI64:    return "f32.convert_u/i64";
	case F32DemoteF64:      return "f32.demote/f64";
	case F64ConvertSI32:    return "f64.convert_s/i32";
	case F64ConvertUI32:    return "f64.convert_u/i32";
	case F64ConvertSI64:    return "f64.convert_s/i64";
	case F64ConvertUI64:    return "f64.convert_u/i64";
	case F64PromoteF32:     return "f64.promote/f32";
	case I32ReinterpretF32: return "i32.reinterpret/f32";
	case I64ReinterpretF64: return "i64.reinterpret/f64";
	case F32ReinterpretI32: return "f32.reinterpret/i32";
	case F64ReinterpretI64: return "f64.reinterpret/i64";
	default:                return null;
	}
}
