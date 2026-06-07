// SPDX-FileCopyrightText: 2007-2026, LLVM Developers.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

module lib.llvm.c.BitWriter;

public import lib.llvm.c.Types;


extern(C):

//#--- Auto generated below ---#
fn LLVMWriteBitcodeToFD(M: LLVMModuleRef, FD: i32, ShouldClose: i32, Unbuffered: i32) i32;
fn LLVMWriteBitcodeToFile(M: LLVMModuleRef, Path: const(char)*) i32;
fn LLVMWriteBitcodeToFileHandle(M: LLVMModuleRef, Handle: i32) i32;
fn LLVMWriteBitcodeToMemoryBuffer(M: LLVMModuleRef) LLVMMemoryBufferRef;
