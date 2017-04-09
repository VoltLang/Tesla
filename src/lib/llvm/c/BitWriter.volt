// See copyright notice and license in src/lib/llvm/core.volt.
module lib.llvm.c.BitWriter;

import lib.llvm.c.Core;


extern(C):

fn LLVMWriteBitcodeToFile(LLVMModuleRef, const(char)*) int;
fn LLVMWriteBitcodeToFD(LLVMModuleRef, int, int, int) int;
