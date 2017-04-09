// Copyright © 2012-2017, Jakob Bornecrantz.  All rights reserved.
// See copyright notice and license below.
/**
 * This file imports the regular C api of LLVM but also extends it
 * with simple wrappers that works on native arrays instead of C
 * pointer plus length arrays as well as string wrappers.
 */
module lib.llvm.core;

import watt.conv : toString, toStringz;

public import lib.llvm.c.Core;


// Need to do this for all overloaded functions.
alias LLVMSetTarget = lib.llvm.c.Core.LLVMSetTarget;
alias LLVMSetDataLayout = lib.llvm.c.Core.LLVMSetDataLayout;
alias LLVMModuleCreateWithNameInContext = lib.llvm.c.Core.LLVMModuleCreateWithNameInContext;


fn LLVMSetTarget(mod: LLVMModuleRef, str: string)
{
	stack: char[1024];
	ptr := nullTerminate(stack, str);
	lib.llvm.c.Core.LLVMSetTarget(mod, ptr);
}

fn LLVMSetDataLayout(mod: LLVMModuleRef, str: string)
{
	stack: char[1024];
	ptr := nullTerminate(stack, str);
	lib.llvm.c.Core.LLVMSetDataLayout(mod, ptr);
}

fn LLVMModuleCreateWithNameInContext(name: string, c: LLVMContextRef) LLVMModuleRef
{
	stack: char[1024];
	ptr := nullTerminate(stack, name);
	return lib.llvm.c.Core.LLVMModuleCreateWithNameInContext(ptr, c);
}

fn LLVMFunctionType(ret: LLVMTypeRef, args: LLVMTypeRef[], vararg: bool) LLVMTypeRef
{
	return lib.llvm.c.Core.LLVMFunctionType(
		ret, args.ptr, cast(uint)args.length, vararg);
}

fn LLVMAddFunction(mod: LLVMModuleRef, name: string, type: LLVMTypeRef) LLVMValueRef
{
	stack: char[1024];
	ptr := nullTerminate(stack, name);
	return lib.llvm.c.Core.LLVMAddFunction(mod, ptr, type);
}

fn LLVMAddIncoming(phi: LLVMValueRef, iv: LLVMValueRef[], ib: LLVMBasicBlockRef[])
{
	assert(iv.length == ib.length);
	lib.llvm.c.Core.LLVMAddIncoming(phi, iv.ptr, ib.ptr, cast(uint)iv.length);
}


/*
 *
 * Builders.
 *
 */

fn LLVMBuildAlloca(b: LLVMBuilderRef, type: LLVMTypeRef, name: string) LLVMValueRef
{
	stack: char[1024];
	ptr := nullTerminate(stack, name);
	return lib.llvm.c.Core.LLVMBuildAlloca(b, type, ptr);
}

fn LLVMBuildCall(b: LLVMBuilderRef, func: LLVMValueRef,
                 args: LLVMValueRef[]) LLVMValueRef
{
	return lib.llvm.c.Core.LLVMBuildCall(
		b, func, args.ptr, cast(uint)args.length, "");
}

/*
fn LLVMBuildInvoke(b: LLVMBuilderRef, func: LLVMValueRef, args: LLVMValueRef[],
                   then: LLVMBasicBlockRef, pad: LLVMBasicBlockRef) LLVMValueRef
{
	return lib.llvm.c.Core.LLVMBuildInvoke(
		b, func, args.ptr, cast(uint)args.length, then, pad, "");
}

fn LLVMBuildAlloca(b: LLVMBuilderRef, type: LLVMTypeRef,
                   name: string) LLVMValueRef
{
	stack: char[1024];
	auto ptr = nullTerminate(stack, name);
	return lib.llvm.c.Core.LLVMBuildAlloca(b, type, ptr);
}
*/

/*
 *
 * Dumpers.
 *
 */

fn LLVMPrintTypeToString(ty: LLVMTypeRef) string
{
	cstr := lib.llvm.c.Core.LLVMPrintTypeToString(ty);
	return handleAndDisposeMessage(&cstr);
}

fn LLVMPrintValueToString(v: LLVMValueRef) string
{
	cstr := lib.llvm.c.Core.LLVMPrintValueToString(v);
	return handleAndDisposeMessage(&cstr);
}

fn LLVMPrintModuleToString(mod: LLVMModuleRef) string
{
	cstr := lib.llvm.c.Core.LLVMPrintModuleToString(mod);
	return handleAndDisposeMessage(&cstr);
}

/**
 * Small helper function that writes a string and null terminates
 * it to a given char array, usefull for using stack space to null
 * terminate strings.
 */
fn nullTerminate(stack: char[], str: string) const(char)*
{
	if (str.length + 1 > stack.length) {
		return toStringz(str);
	}
	stack[0 .. str.length] = str[];
	stack[str.length] = 0;
	return stack.ptr;
}

/**
 * Small helper function that takes care of output messages.
 */
fn handleAndDisposeMessage(msg: const(char)**) string
{
	if (msg is null || *msg is null) {
		return null;
	}

	auto ret = toString(*msg);
	LLVMDisposeMessage(*msg);
	*msg = null;
	return ret;
}

enum string llvmLicense = `
==============================================================================
LLVM Release License
==============================================================================
University of Illinois/NCSA
Open Source License

Copyright (c) 2003-2010 University of Illinois at Urbana-Champaign.
All rights reserved.

Developed by:

    LLVM Team

    University of Illinois at Urbana-Champaign

    http://llvm.org

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal with
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimers.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimers in the
      documentation and/or other materials provided with the distribution.

    * Neither the names of the LLVM Team, University of Illinois at
      Urbana-Champaign, nor the names of its contributors may be used to
      endorse or promote products derived from this Software without specific
      prior written permission.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE
SOFTWARE.
`;

import tesla.license;

static this()
{
	licenseArray ~= llvmLicense;
}
