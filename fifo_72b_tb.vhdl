library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_72b_tb is
end fifo_72b_tb;

architecture sim of fifo_72b_tb is

	component fifo_72b
		port (
			din		: in std_logic_vector(71 downto 0);
			dout	: out std_logic_vector(71 downto 0);

			-- commands
			push	: in std_logic;
			pop		: in std_logic;

			-- flags
			full	: out std_logic;
			empty	: out std_logic;

			reset_n	: in std_logic;
			ck		: in std_logic;
			vdd		: in bit;
			vss		: in bit
    );
	end component;
	signal input : std_logic_vector(71 downto 0) := x"111122223333444456";
	signal output : std_logic_vector(71 downto 0);
	signal push : std_logic := '0';
	signal pop : std_logic := '1';
	signal reset_n : std_logic := '1';
	signal ck : std_logic := '0';
	signal full, empty : std_logic;

begin

	fifo_0 : fifo_72b
		port map (
			din => input,
			dout => output,
			push => push,
			pop => pop,
			full => full,
			empty => empty,
			reset_n => reset_n,
			ck => ck,
			vdd => '1',
			vss => '0'
			);
	
	process
	begin
		report "Starting test bench";
		ck <= '1';
		wait for 10 ns;
		ck <= '0';
		pop <= '0';
		wait for 10 ns;
		assert empty = '1' report "start fifo not empty" severity error;
		assert full = '0' report "start fifo full" severity error;
		wait for 10 ns;
		push <= '1';
		ck <= '1';
		wait for 10 ns;
		push <= '0';
		
		-- Test Case 1 first push
		assert empty = '0' report "Test 1 fifo empty" severity error;
		assert full = '1' report "Test 1 fifo not full" severity error;
		ck <= '0';
		-- Test Case 2 first pop
		pop <= '1';
		wait for 10 ns;
		ck <= '1';
		wait for 10 ns;
		assert empty = '1' report "Test 2 fifo not empty" severity error;
		assert full = '0' report "Test 2 fifo full" severity error;
		assert output = x"111122223333444456" report "Test 2 dout error" severity error;

		wait;
	end process;
end architecture;
