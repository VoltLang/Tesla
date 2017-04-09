// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module main;

import watt.io.file;
import io = watt.io;
import wasm = wasm;

import tesla.polyfill;


fn main(args: string[]) i32
{
	if (args.length == 1) {
		io.writefln("usage: %s <file>", args[0]);
		return 1;
	}

	data := cast(const(u8)[])read(args[1]);
	if (false) {
		t := new wasm.Dumper();
		wasm.readFile(t, data);
	} else {
		p := new Polyfill();
		wasm.readFile(p, data);
		io.writefln("%s", p.printToString());
		p.close();
	}

	return 0;
}
