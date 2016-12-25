# Tesla Language

## Ideas

General ideas for the scripting language.

---

Special syntax for scripting.

```
#!/bin/tesla

var hello = "Hello";
var world = "World";
var str = new world[2 .. $];


// '$' switches to bash mode for that line.
// '$' inside of bash mode replaces the following ident
// with a string representation of that varaible
$ echo Hello $world

// output: Hello World


// The contents of ${ } is parsed as a expression
// and then turned into a string.
$ echo Hello ${"wo" ~ str}

// output: Hello world


// '\' can be used to escaped the new line as with bash commands.
// Notice that it parsers the command line just as bash does,
// which means that whitespace is removed between the two arguments
// "Hello" and "World".
$ echo Hello \
	World

// output: Hello World
```


---

Uniform keyword ident syntax.

```

import io = watt.io;
var str = "Foo";
fn func() { return 0; }
alias print = io.print;
class Bar {}


```

---

Optional types in the syntax and language

```
var v = "Foo";
var str : string;

str = 3; // Auto converts to a string.
v = 4; // v now has a integer type.
