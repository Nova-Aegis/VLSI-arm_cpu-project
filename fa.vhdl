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

signal X1, X2, X3 : std_logic;
  
begin
	process (A, B, Cin)
	variable X1, X2, X3 : std_logic;
	begin
    	x1 := A xor B;
    	Sout <= X1 xor Cin;
    	X2 := X1 nand Cin;
    	X3 := A nand B;
    	Cout <= X2 nand X3;
  	end process;

end dataflow;
