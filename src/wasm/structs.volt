// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module wasm.structs;


struct Header
{
public:
	ident: u32;
	ver: u32;
}

struct Limits
{
	initial: u32;
	maximum: u32;
	flags: u8;
}
