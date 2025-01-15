library ieee;
use ieee.std_logic_1164.all;

entity FAdder is
	port (
		A, B, Cin : in std_logic;
		Sout, Cout : out std_logic;
		vdd : in bit;
		vss : in bit
		);
end FAdder;

architecture dataflow of FAdder is
begin
	Sout <= (A xor B) xor Cin;
	Cout <= ((A xor B) nand Cin) nand (A nand B);
end dataflow;
