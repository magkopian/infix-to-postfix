## Description:
This is an infix to postfix converter implemented with C, Flex and Bison. For every infix expression the program calculates the postfix equivalent and the mathematical result.

The user can either input the infix expressions directly to the program or load them from a file. There are supported all the basic operands '+', '-', '*', '/', '^', '%', '(', ')'. But, there is not supported the unary minus and also there are supported only integer numbres.

## How to Build:

All you need to do to compile the code is just use the `Makefile` by running,

```BASH
make
```

For this to work, the `gcc` compiler, `make`, `flex` and `bison` programs have to be installed. On Debian and Ubuntu based system all the build dependecies can be installed as followes,

```BASH
sudo apt update
sudo apt install gcc make flex bison
```

## How to use:
To input the infix expressions directly to the program, you just run it like this:

```BASH
./in2post
```

To give the input via a file, you have to specify the file path as an argument like this:

```BASH
./in2post path/to/file
```

Every expression must be on its own line. All empty space is ignored, you can you as many new lines, tabs and spaces you want.
