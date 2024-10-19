library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Add32b is
port (
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	Cin : in std_logic;
	Cout : out std_logic;
	S : out std_logic_vector(31 downto 0)
);

end Add32b;

architecture Structurel of Add32b is

	signal res : std_logic_vector(32 downto 0);

	begin
		res <= std_logic_vector( unsigned("0" & A) + unsigned("0" & B) + unsigned'("" & cin)); 
		Cout <= res(32);
		S <= res(31 downto 0);
end Structurel;
