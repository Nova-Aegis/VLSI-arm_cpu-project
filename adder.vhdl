library ieee;
use ieee.std_logic_1164.all;

entity Add4b is
port (
	A : in std_logic_vector(3 downto 0);
	B : in std_logic_vector(3 downto 0);
	Cin : in std_logic;
	Cout : out std_logic;
	S : out std_logic_vector(3 downto 0)
);

end Add4b;

architecture Structurel of Add4b is

	component FAdder
	port (
		A, B, Cin : in std_logic;
		Sout, Cout : out std_logic);
	end component;

	signal C1, C2, C3 : std_logic;

	begin
		FA_0 : FAdder
		port map(
			A => A(0),
			B => B(0),
			Cin => Cin,
			Sout => S(0),
			Cout => C1
		);
		FA_1 : FAdder
		port map(
			A => A(1),
			B => B(1),
			Cin => C1,
			Sout => S(1),
			Cout => C2
		);
		FA_2 : FAdder
		port map(
			A => A(2),
			B => B(2),
			Cin => C2,
			Sout => S(2),
			Cout => C3
		);
		FA_3 : FAdder
		port map(
			A => A(3),
			B => B(3),
			Cin => C3,
			Sout => S(3),
			Cout => Cout
		);
end Structurel;
