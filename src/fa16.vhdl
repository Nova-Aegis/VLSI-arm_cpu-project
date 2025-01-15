library ieee;
use ieee.std_logic_1164.all;

entity FAdder16 is
	port(
		A, B : in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		Sout : out std_logic_vector(15 downto 0);
		Cout : out std_logic;
		vdd : in bit;
		vss : in bit
		);
end FAdder16;

architecture dataflow of FAdder16 is
	component FAdder4
		port (
			A, B : in std_logic_vector(3 downto 0);
			Cin : in std_logic;
			Sout : out std_logic_vector(3 downto 0);
			Cout : out std_logic;
			vdd : in bit;
			vss : in bit
			);
	end component;
	signal C : std_logic_vector(2 downto 0);
begin
	fa4_0 : Fadder4
		port map(
			A => A(3 downto 0),
			B => B(3 downto 0),
			Cin => Cin,
			Sout => Sout(3 downto 0),
			Cout => C(0),
			vdd => vdd,
			vss => vss
			);
	fa4_1 : Fadder4
		port map(
			A => A(7 downto 4),
			B => B(7 downto 4),
			Cin => C(0),
			Sout => Sout(7 downto 4),
			Cout => C(1),
			vdd => vdd,
			vss => vss
			);
	fa4_2 : Fadder4
		port map(
			A => A(11 downto 8), B => B(11 downto 8),
			Cin => C(1),
			Sout => Sout(11 downto 8),
			Cout => C(2),
			vdd => vdd,
			vss => vss
			);
	fa4_3 : Fadder4
		port map(
			A => A(15 downto 12), B => B(15 downto 12),
			Cin => C(2),
			Sout => Sout(15 downto 12),
			Cout => Cout,
			vdd => vdd,
			vss => vss
			);
end dataflow;
