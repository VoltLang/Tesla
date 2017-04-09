// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module main;

import watt.io.file;
import io = watt.io;
import wasm = wasm;

import tesla.polyfill;
import tesla.driver;

fn main(args: string[]) i32
{
	drv := new DefaultDriver(args);
	ret := drv.run();
	drv.close();
	return ret;
}
