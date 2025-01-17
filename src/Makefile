# Compilation variables
CC = ghdl
CFLAGS = -a -v
TBFLAGS = -e -v
RUNFLAGS = -r

C_MOD_DIR = ../C_model

# vhdl files
VHDLS_EXEC = fa.vhdl adder.vhdl alu.vhdl fifo_72b.vhdl exec.vhdl
VHDLS_DECODE = reg.vhdl fifo_127b.vhdl fifo_32b.vhdl decod.vhdl
VHDLS_IFETCH = fifo_32b.vhdl ifetch.vhdl
VHDLS_MEM = mem.vhdl
VHDLS_CHIP = $(VHDLS_EXEC) $(VHDLS_DECODE) $(VHDLS_IFTECH) $(VHDLS_MEM) arm_core.vhdl arm_chip.vhdl

# object files
OADDER32 = adder.o fa.o
OALU = alu.o $(OADDER32)
OSHIFTER = shifter.o
OFIFO = fifo_72b.o
OEXEC = $(OALU) $(OSHIFTER) $(OFIFO) exec.o
OREG = reg.o
ODECODE = $(OREG) $(OFIFO) decod.o fifo_32b.o fifo_127b.o
OARM = $(ODECODE) $(OEXEC) ifetch.o mem.o
OARM_RUN = $(OARM) ram.o icache.o dcache.o arm_core.o $(C_MOD_DIR)/lib/arm_ghdl.o


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

main_tb :  ram.o icache.o dcache.o arm_core.o ${C_MOD_DIR}/lib/arm_ghdl.o main_tb.o
	$(CC) $(TBFLAGS) -Wl,${C_MOD_DIR}/lib/mem.o -Wl,${C_MOD_DIR}/lib/arm_ghdl.o -Wl,${C_MOD_DIR}/ReadElf/lib/ElfObj.o main_tb

# Object file maker
%.o : %.vhdl
	$(CC) $(CFLAGS) $<

# Test Banch runner
run_adder : adder_tb
	$(CC) $(RUNFLAGS) adder_tb --vcd=adder32.vcd

run_alu : alu_tb
	$(CC) $(RUNFLAGS) alu_tb --vcd=alu.vcd

run_shifter : shifter_tb
	$(CC) $(RUNFLAGS) shifter_tb --vcd=shifter.vcd

run_fifo : fifo_tb
	$(CC) $(RUNFLAGS) fifo_72b_tb --vcd=fifo_72b.vcd

run_exec : exec_tb
	$(CC) $(RUNFLAGS) exec_tb --vcd=exec.vcd

run_arm : arm_tb
	$(CC) $(RUNFLAGS) arm_tb --vcd=arm.vcd


% : %.vhdl
	vasy -I vhdl -V -o -a -C 8 $< $@_model
	boom -V -A -O $@_model $@_o && mv $@_o $@_model
	boog $@_model $@

synthesis : $(VHDLS_CHIP:.vhdl=)

# The Janitor
clean:
	-rm -f *.o *.vcd
	-rm -f *~
	-rm -f alu_tb adder32_tb shifter_tb exec_tb fifo_72b_tb arm_tb main_tb
	-rm -f work-obj93.cf

#######
ram.o : ram.vhdl
icache.o : icache.vhdl ram.o
dcache.o : dcache.vhdl ram.o
main_tb.o : main_tb.vhdl icache.o dcache.o ram.o 
arm_core.o : arm_core.vhdl ifetch.o decod.o exec.o mem.o
ifetch.o : ifetch.vhdl fifo_32b.o
decod.o : decod.vhdl fifo_32b.o fifo_127b.o reg.o
reg.o : reg.vhdl adder.o
exec.o : exec.vhdl fifo_72b.o alu.o shifter.o
fifo_72b.o : fifo_72b.vhdl
fifo_32b.o : fifo_32b.vhdl
fifo_127b.o : fifo_127b.vhdl
alu.o : alu.vhdl adder.o
shifter.o : shifter.vhdl
mem.o : mem.vhdl
adder.o : adder.vhdl fa16.o
fa16.o : fa16.vhdl fa4.o
fa4.o : fa4.vhdl fa.o
fa.o : fa.vhdl
