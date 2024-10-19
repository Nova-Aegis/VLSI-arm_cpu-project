library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--library work;
--use work.bidon.all;


--  A testbench has no ports.
entity adder32_tb is
end adder32_tb;

architecture Structurel of adder32_tb is
	--  Declaration un composant
	component Add32b
	port (
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		S : out std_logic_vector(31 downto 0)
	);
	end component;

	signal A, B, S : std_logic_vector(31 downto 0);
	signal Cin : std_logic := '0';
	signal Cout : std_logic;

	begin
	Add32b_0: Add32b
	port map (
		A => A,
		B => B,
		Cin => Cin,
		S => S,
		Cout => Cout
	);

process

begin
	-- Test Case 1
    A <= x"00000001";
    B <= x"00000001";
    wait for 10 ns;
    assert (S = x"00000002") report "Test Case 1 Failed" severity error;
    assert (Cout = '0') report "Test Case 1 Cout Failed" severity error;

    -- Test Case 2
    A <= x"FFFFFFFF";
    B <= x"00000001";
    wait for 10 ns;
    assert (S = x"00000000") report "Test Case 2 Failed" severity error;
    assert (Cout = '1') report "Test Case 2 Cout Failed" severity error;

    -- Test Case 3
    A <= x"12345678";
    B <= x"87654321";
    wait for 10 ns;
    assert (S = x"99999999") report "Test Case 3 Failed" severity error;
    assert (Cout = '0') report "Test Case 3 Cout Failed" severity error;

    -- Test Case 4
    A <= x"00000000";
    B <= x"00000000";
    wait for 10 ns;
    assert (S = x"00000000") report "Test Case 4 Failed" severity error;
    assert (Cout = '0') report "Test Case 4 Cout Failed" severity error;

    -- Test Case 5
    A <= x"7FFFFFFF";
    B <= x"7FFFFFFF";
    wait for 10 ns;
    assert (S = x"FFFFFFFE") report "Test Case 5 Failed" severity error;
    assert (Cout = '0') report "Test Case 5 Cout Failed" severity error;

    -- Test Case 6
    A <= x"80000000";
    B <= x"80000000";
    wait for 10 ns;
    assert (S = x"00000000") report "Test Case 6 Failed" severity error;
    assert (Cout = '1') report "Test Case 6 Cout Failed" severity error;

assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end Structurel;
