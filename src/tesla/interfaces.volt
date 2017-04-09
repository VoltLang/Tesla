// Copyright © 2016-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/tesla/license.volt (BOOST ver. 1.0).
/**
 * Main tesla interfaces.
 */
module tesla.interfaces;

static import watt.text.sink;


abstract class Driver
{
public:
	/// Helper alias
	alias Fmt = watt.text.sink.SinkArg;


public:
	/**
	 * Prints a info string.
	 */
	abstract fn info(fmt: Fmt, ...);

	/**
	 * Error encoutered, print error then abort operation.
	 *
	 * May terminate program with exit, or throw an exception to resume.
	 */
	abstract fn abort(fmt: Fmt, ...);
}
