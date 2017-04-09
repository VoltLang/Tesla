// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
module tesla.driver;

import core.c.stdlib : exit;
import core.varargs : va_list, va_start, va_end;
import io = watt.io;
import watt.io.file : read;

import wasm = wasm;

import tesla.interfaces;
import tesla.polyfill;


class DefaultDriver : Driver
{
private:
	mArgs: string[];
	mInputFile: string;
	mOutputFile: string;
	mOutputStdio: bool;

	mPoly: Polyfill;


public:
	this(args: string[])
	{
		mArgs = args;
		mOutputStdio = true;
	}

	fn close()
	{
		if (mPoly !is null) {
			mPoly.close();
			mPoly = null;
		}
	}

	fn run() i32
	{
		if (mArgs.length == 0) {
			mArgs = ["tesla"];
		}

		if (mArgs.length == 1) {
			printConfigUsage();
			return 1;
		}

		processArgs(this, mArgs[1 .. $]);

		if (mInputFile is null) {
			printConfigUsage();
			return 1;
		}

		data := cast(const(u8)[])read(mInputFile); 
		mPoly := new Polyfill();
		wasm.readFile(mPoly, data); 

		if (mOutputStdio) {
			io.writefln("%s", mPoly.printToString());
		} else {
			mPoly.writeToFile(mOutputFile);
		}

		return 0;
	}

	fn printConfigUsage()
	{
		info("usage: %s <file>", mArgs[0]); 
		info("");
		info("\t-o outputname    Set output to outputname.");
	}

	override fn info(fmt: Fmt, ...)
	{
		vl: va_list;
		va_start(vl);
		io.output.vwritefln(fmt, ref _typeids, ref vl);
		io.output.flush();
		va_end(vl);
	}

	override fn abort(fmt: Fmt, ...)
	{
		io.output.flush();

		vl: va_list;
		va_start(vl);
		io.error.write("error: ");
		io.error.vwritefln(fmt, ref _typeids, ref vl);
		io.error.flush();
		va_end(vl);
		exit(1);
	}
}

enum State
{
	None,
	Output,
}

fn processArgs(drv: DefaultDriver, args: string[])
{
	state: State;
	foreach (arg; args) {
		state = processArg(drv, state, arg); 
	}
	if (state != State.None) {
		drv.abort("expected extra argument");
	}
}

fn processArg(drv: DefaultDriver, state: State, arg: string) State
{
	switch (state) with (State) {
	case None:
		switch (arg) {
		case "-o": return State.Output;
		default:
		}

		if (arg[0] == '-') {
			drv.abort("unknown argument %s", arg);
		}

		if (drv.mInputFile !is null) {
			drv.abort("only one input file is supported");
		}

		drv.mInputFile = arg;
		return State.None;
	case Output:
		if (arg == "-") {
			drv.mOutputFile = null;
			drv.mOutputStdio = true;
		} else {
			drv.mOutputFile = arg;
			drv.mOutputStdio = false;
		}
		return State.None;
	default:
		drv.abort("internal state error");
		return State.None;
	}
}
