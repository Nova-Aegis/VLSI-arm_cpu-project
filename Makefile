# Compilation variables
CC = ghdl
CFLAGS = -a -v
TBFLAGS = -e -v
RUNFLAGS = -r

# vhdl files
VHDLS_EXEC = fa.vhdl adder32.vhdl alu.vhdl fifo_72b.vhdl exec.vhdl
VHDLS_DECODE = reg.vhdl fifo_127b.vhdl fifo_32b.vhdl decod.vhdl
VHDLS_IFETCH = fifo_32b.vhdl ifetch.vhdl
VHDLS_MEM = mem.vhdl
VHDLS_CHIP = $(VHDLS_EXEC) $(VHDLS_DECODE) $(VHDLS_IFTECH) $(VHDLS_MEM) arm_core.vhdl arm_chip.vhdl

# object files
OADDER32 = adder32.o fa.o
OALU = alu.o $(OADDER32)
OSHIFTER = shifter.o
OFIFO = fifo_72b.o
OEXEC = $(OALU) $(OSHIFTER) $(OFIFO) exec.o
OREG = reg.o
ODECODE = $(OREG) $(OFIFO) decod.o fifo_32b.o fifo_127b.o
OARM = $(ODECODE) $(OEXEC) ifetch.o mem.o


.PHONY : all exec_tb adder32_tb alu_tb shifter_tb fifo_tb arm_tb run_fifo run_adder32 run_alu run_shifter run_exec run_arm clean

# MOAB (Mother Of All Binaries)
all: alu_tb shifter_tb exec_tb adder32_tb fifo_tb arm_tb

# Test Bench maker
exec_tb : $(OEXEC) exec_tb.o
	$(CC) $(TBFLAGS) exec_tb

adder32_tb : $(OADDER32) adder32_tb.o
	$(CC) $(TBFLAGS) adder32_tb

alu_tb : $(OALU) alu_tb.o
	$(CC) $(TBFLAGS) alu_tb

shifter_tb : $(OSHIFTER) shifter_tb.o
	$(CC) $(TBFLAGS) shifter_tb

fifo_tb : $(OFIFO) fifo_72b_tb.o
	$(CC) $(TBFLAGS) fifo_72b_tb

decode_tb : $(ODECODE)

arm_tb : $(OARM) arm_tb.o
	$(CC) $(TBFLAGS) arm_tb

# Object file maker
%.o : %.vhdl
	$(CC) $(CFLAGS) $<

# Test Banch runner
run_adder32 : adder32
	$(CC) $(RUNFLAGS) adder32_tb --vcd=adder32.vcd

run_alu : alu
	$(CC) $(RUNFLAGS) alu_tb --vcd=alu.vcd

run_shifter : shifter
	$(CC) $(RUNFLAGS) shifter_tb --vcd=shifter.vcd

run_fifo : fifo
	$(CC) $(RUNFLAGS) fifo_72b_tb --vcd=fifo_72b.vcd

run_exec : exec
	$(CC) $(RUNFLAGS) exec_tb --vcd=exec.vcd

run_arm : arm
	$(CC) $(RUNFLAGS) arm_tb --vcd=arm.vcd

% : %.vhdl
	vasy -I vhdl -V -o -a -C 8 $< $@
	boom -V -A -O $@ $@_o
	boog $@_o $@

synthesis : $(VHDLS_CHIP:.vhdl=)

# The Janitor
clean:
	-rm *.o *.vcd
	-rm *~
	-rm alu_tb adder32_tb shifter_tb exec_tb fifo_72b_tb arm_tb
