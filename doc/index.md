---
layout: page
---

# Tesla

Right now a tool to turn wasm modules into native binary code. It uses LLVM
as its backend. And a homegrew binary reader to read wasm files. The program
mostly assumes that the wasm module is well formed.

## Status

Can parse and output most of the wasm module, some opcodes requires more
special built functions (to handle traps). Can also read modules that
are following the [dynamic linking][DynLink] standard.

## Further reading

 *  [C ABI][CABI]
 *  [Dynamic Linking][DynLink]



[DynLink]: https://github.com/WebAssembly/tool-conventions/blob/master/DynamicLinking.md
[CABI]: https://github.com/WebAssembly/tool-conventions/blob/master/BasicCABI.md
