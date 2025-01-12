library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--  A testbench has no ports.
entity shifter_tb is
end shifter_tb;

architecture Structurel of shifter_tb is
	--  Declaration un composant
	component Shifter
	port (
		shift_lsl : in std_logic;
		shift_lsr : in std_logic;
		shift_asr : in std_logic;
		shift_ror : in std_logic;
		shift_rrx : in std_logic;
		shift_val : in std_logic_vector(4 downto 0);
		din : in std_logic_vector(31 downto 0);
		cin : in std_logic;
		
		dout : out std_logic_vector(31 downto 0);
		cout : out std_logic;

		vdd : in bit;
		vss : in bit
	);
	end component;

	signal shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, cin, cout : std_logic;
	signal shift_val : std_logic_vector(4 downto 0);
	signal din, dout : std_logic_vector(31 downto 0);

	begin
	Shifter_0: Shifter
	port map (
		shift_lsl => shift_lsl,
		shift_lsr => shift_lsr,
		shift_asr => shift_asr,
		shift_ror => shift_ror,
		shift_rrx => shift_rrx,
		shift_val => shift_val,
		din => din,
		cin => cin,
		dout => dout,
		cout => cout,
		vdd => '1',
		vss => '0'
	);

process

begin
	assert false report "start of test" severity note;

	-- Test lsl
	shift_lsl <= '1';
	shift_lsr <= '0';
	shift_asr <= '0';
	shift_ror <= '0';
	shift_rrx <= '0';
	din <= x"51111111";
	shift_val <= "00010";
	wait for 10 ns;
	assert (dout = x"44444444")  report "Test lsl Failed" severity error;
	assert (cout = '1')  report "Test lsl cout Failed" severity error;

	-- Test lsr
	shift_lsl <= '0';
	shift_lsr <= '1';
	shift_asr <= '0';
	shift_ror <= '0';
	shift_rrx <= '0';
	din <= x"11111112";
	shift_val <= "00010";
	wait for 10 ns;
	assert (dout = x"04444444")  report "Test lsr Failed" severity error;
	assert (cout = '1')  report "Test lsr cout Failed" severity error;

	-- Test asr
	shift_lsl <= '0';
	shift_lsr <= '0';
	shift_asr <= '1';
	shift_ror <= '0';
	shift_rrx <= '0';
	din <= x"8888888A";
	shift_val <= "00010";
	wait for 10 ns;
	assert (dout = x"E2222222")  report "Test asr Failed" severity error;
	assert (cout = '1')  report "Test asr cout Failed" severity error;

	-- Test ror
	shift_lsl <= '0';
	shift_lsr <= '0';
	shift_asr <= '0';
	shift_ror <= '1';
	shift_rrx <= '0';
	din <= x"11111112";
	shift_val <= "00010";
	wait for 10 ns;
	assert (dout = x"84444444")  report "Test ror Failed" severity error;
	assert (cout = '1')  report "Test ror cout Failed" severity error;

	-- Test rrx
	shift_lsl <= '0';
	shift_lsr <= '0';
	shift_asr <= '0';
	shift_ror <= '0';
	shift_rrx <= '1';
	din <= x"FFFFFFFF";
	cin <= '0';
	shift_val <= "00000";
	wait for 10 ns;
	assert (dout = x"7FFFFFFF")  report "Test rrx Failed" severity error;
	assert (cout = '1')  report "Test rrx cout Failed" severity error;

assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end Structurel;
