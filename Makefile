# Compilation variables
CC = ghdl
CFLAGS = -a -v
TBFLAGS = -e -v
RUNFLAGS = -r

# object files
OADDER32 = adder32.o
OALU = alu.o $(OADDER32)
OSHIFTER = shifter.o
OFIFO = fifo_72b.o
OEXEC = $(OALU) $(OSHIFTER) $(OFIFO) exec.o
OREG = reg.o
ODECODE = $(OREG) $(OFIFO) decod.o fifo_32b.o fifo_127b.o
OARM = $(ODECODE) $(OEXEC) ifetch.o mem.o


.PHONY : all exec adder32 alu shifter fifo arm run_fifo run_adder32 run_alu run_shifter run_exec run_arm clean

# MOAB (Mother Of All Binaries)
all: alu shifter exec adder32 fifo arm

# Test Bench maker
exec : $(OEXEC) exec_tb.o
	$(CC) $(TBFLAGS) exec_tb

adder32 : $(OADDER32) adder32_tb.o
	$(CC) $(TBFLAGS) adder32_tb

alu: $(OALU) alu_tb.o
	$(CC) $(TBFLAGS) alu_tb

shifter: $(OSHIFTER) shifter_tb.o
	$(CC) $(TBFLAGS) shifter_tb

fifo : $(OFIFO) fifo_72b_tb.o
	$(CC) $(TBFLAGS) fifo_72b_tb

decode : $(ODECODE)

arm : $(OARM) arm_tb.o
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


# The Janitor
clean:
	-rm *.o *.vcd
	-rm *~
	-rm alu_tb adder32_tb shifter_tb exec_tb fifo_72b_tb arm_tb
