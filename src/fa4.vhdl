library ieee;
use ieee.std_logic_1164.all;


entity FAdder4 is
	port(
		A, B : in std_logic_vector(3 downto 0);
		Cin : in std_logic;
		Sout : out std_logic_vector(3 downto 0);
		Cout : out std_logic;
		vdd : in bit;
		vss : in bit
		);
end FAdder4;

architecture dataflow of FAdder4 is
	component FAdder
		port (
			A, B, Cin : in std_logic;
			Sout, Cout : out std_logic;
			vdd : in bit;
			vss : in bit
			);
	end component;
	signal C : std_logic_vector(2 downto 0);

begin
	
	fa_0 : Fadder
		port map(
			A => A(0),
			B => B(0),
			Cin => Cin,
			Sout => Sout(0),
			Cout => C(0),
			vdd => vdd,
			vss => vss
			);
	
	fa_1 : Fadder
		port map(
			A => A(1),
			B => B(1),
			Cin => C(0),
			Sout => Sout(1),
			Cout => C(1),
			vdd => vdd,
			vss => vss
			);
	
	fa_2 : Fadder
		port map(
			A => A(2),
			B => B(2),
			Cin => C(1),
			Sout => Sout(2),
			Cout => C(2),
			vdd => vdd,
			vss => vss
			);
	
	fa_3 : Fadder
		port map(
			A => A(3),
			B => B(3),
			Cin => C(2),
			Sout => Sout(3),
			Cout => Cout,
			vdd => vdd,
			vss => vss
			);
	
end dataflow;
