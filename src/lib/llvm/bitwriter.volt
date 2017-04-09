// Copyright © 2012-2016, Jakob Bornecrantz.  All rights reserved.
// See copyright notice and license in src/lib/llvm/core.volt.
module lib.llvm.bitwriter;

import lib.llvm.core;
public import lib.llvm.c.BitWriter;


fn LLVMWriteBitcodeToFile(mod: LLVMModuleRef, filename: string) bool
{
	stack: char[1024];
	ptr := nullTerminate(stack, filename);
	return lib.llvm.c.BitWriter.LLVMWriteBitcodeToFile(mod, ptr) != 0;
}
