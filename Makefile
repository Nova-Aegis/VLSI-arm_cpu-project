all: alu shifter

exe : alu shifter exec_guillaume.o fifo_72b.vhdl


alu: alu.o alu_tb.o adder32.o
	ghdl -e -v alu_tb

shifter: shifter.o shifter_tb.o
	ghdl -e -v shifter_tb

%.o: %.vhdl
	ghdl -a -v $<

run_alu: alu
	ghdl -r alu_tb --vcd=alu.vcd

run_shifter: shifter
	ghdl -r shifter_tb --vcd=shifter.vcd

clean:
	@rm *.o *.vcd  *~ alu_tb adder32_tb fa_tb shifter_tb
