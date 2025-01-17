# Processor capable of executing the ARM v2.3 instruction set

This project implements a processor capable of executing the ARM v2.3 instruction set in VHDL. It was developped as part of the conception of digital integrated circuits (VLSI) at Sorbonne University, Master SESI & SAR M1, 2024-2025.

## About the implementation

This implementation uses a 4 stage asynchronous system : IFETCH, DECODE, EXECUTE, MEMORY.
IFETCH (given to us) is in charge of fetching the next instruction with the given address.
DECODE holds the register bank and is the brain of the processor. It decodes the instruction, delays it when necessary and choses what EXE and MEM will be working on.
EXECUTE is the brawn of the processor, it does the logical and arithemtic operations, shifts an operand and passes data and addresses to MEM.
MEMORY (given to us) is similar to IFETCH, it waits for an address and maybe data and fetches or send data to the memory unit.

## About the instruction set

The ARM v2.3 instruction set has a multitude of instructions possible.
The data processing operations includes all simple register to register operation such as arithmetic operation, bitwise logical operation and testing instructions.
The simple memory access operations stores or load data from or to registers. It can also modify base address register with pre or post indexation.
The branch operation are in charge of jumping from one instruction to another way before or way after. It also has the possibility to store the current program counter before jumping. All jump instructions or modifications to the program counter has one delayed slot executed before jumping.
The multiplication operations (not implemented) are as their name suggest a multiplication between 2 words.
The multiple memory access operations (not implemented) allows to store or load multiple data from/to registers.
The swap operation (not implemented) switches the data of 2 registers.

# Usage

## Package prerequisite

- GHDL
- arm compiler
- make

## Compiling

There are two option for compilation :

Compile and test :

```sh
make test
```

Compile global platform :

```sh
make compile
```

## Compiling ARM programs

The current implementation is capable of executing programs. To do so, you must first compile a program into an arm binary file.
3 labels must be present :
- _start : what instruction will be first executed
- _good : when to stop, no errors
- _bad : when to stop, error

For c programs the following flags must be specified at compilation.

```sh
$(ARM-C-COMPILER) -march=armv2a -mno-thumb-interwork
$(ARM-LINKER) -Bstatic -fix-v4bx
```

For assembly programs the following flags must be specified at compilation.

```sh
$(ARM-ASM-COMPILER) -march=armv2a
$(ARM-LINKER) -Bstatic -fix-v4bx
```

See `test-pogram/Makefile` for example.

## Running programs

To run compiled programs, use the following command :

```sh
./execute <path/to/program/elf> [--vcd=<vcd-file>.vcd]
```

## Examining trace

The executions will leave a trace when `[--vcd=<vcd-file>.vcd]` is used.
GTKWave is able to read the vcd file, allowing you to view a trace of the execution of your program.

## More output

An output can be setup to print the hexadecimal value of a data written by memory. To do so, you must setup a word that will be used as the output, and place the address of said word in `src/main_tb.vhdl` where instead of the address for the TTY_out constant.

No other modification is necessary, the output will be printed automatically when executing your program.

# Authors

- [Thaïs Milleret](https://www.linkedin.com/in/thais-milleret/)
- [Guilaume Regnault](https://www.linkedin.com/in/guillaume-regnault-754b8a332)

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.
