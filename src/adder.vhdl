library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;


entity Add32b is
port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	Cin : in std_logic;
	Cout : out std_logic;
	S : out std_logic_vector(31 downto 0);
	vdd : in bit;
	vss : in bit
);

end Add32b;

architecture Structurel of Add32b is

	-- signal res : std_logic_vector(32 downto 0);

	-- begin
	-- 	res <= std_logic_vector( unsigned("0" & A) + unsigned("0" & B) + unsigned'("" & cin)); 
	-- 	Cout <= res(32);
	-- 	S <= res(31 downto 0);

	
	component FAdder16
		port (
			A, B : in std_logic_vector(15 downto 0);
			Cin : in std_logic;
			Sout : out std_logic_vector(15 downto 0);
			Cout : out std_logic;
			vdd : in bit;
			vss : in bit
			);
	end component;

	signal C : std_logic;

begin

	FA_0 : Fadder16
		port map(
			A => A(15 downto 0), B => B(15 downto 0),
			Cin => Cin,
			Sout => S(15 downto 0),
			Cout => C,
			vdd => vdd, vss => vss
			);
	
	FA_1 : Fadder16
		port map(
			A => A(31 downto 16), B => B(31 downto 16),
			Cin => C,
			Sout => S(31 downto 16),
			Cout => Cout,
			vdd => vdd, vss => vss
			);
end Structurel;
