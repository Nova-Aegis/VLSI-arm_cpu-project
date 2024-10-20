# Compilation variables
CC = ghdl
CFLAGS = -a -v
TBFLAGS = -e -v
RUNFLAGS = -r

# object files
OADDER32 = adder32.o
OALU = alu.o $(OADDER32)
OSHIFTER = shifter.o
OEXEC = $(OALU) $(OSHIFTER) exec.o fifo_72b.o

# MOAB (Mother Of All Binaries)
all: alu shifter exec adder32

# Test Bench maker
exec : $(OEXEC) exec_tb.o
	$(CC) $(TBFLAGS) exec_tb

adder32 : $(OADDER32) adder32_tb.o
	$(CC) $(TBFLAGS) adder32_tb

alu: $(OALU) alu_tb.o
	$(CC) $(TBFLAGS) alu_tb

shifter: $(OSHIFTER) shifter_tb.o
	$(CC) $(TBFLAGS) shifter_tb

# Object file maker
%.o: %.vhdl
	$(CC) $(CFLAGS) $<

# Test Banch runner
run_adder32: adder32
	$(CC) $(RUNFLAGS) adder32_tb --vcd=adder32.vcd

run_alu: alu
	$(CC) $(RUNFLAGS) alu_tb --vcd=alu.vcd

run_shifter: shifter
	$(CC) $(RUNFLAGS) shifter_tb --vcd=shifter.vcd

run_exec: exec
	$(CC) $(RUNFLAGS) exec_tb --vcd=exec.vcd


# The Janitor
clean:
	-rm *.o *.vcd
	-rm *~
	-rm alu_tb adder32_tb shifter_tb exec_tb
