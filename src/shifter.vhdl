library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter is
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

	-- global interface
	vdd : in bit;
	vss : in bit
);
end Shifter;

architecture behavioral of Shifter is

	signal vec : std_logic_vector(31 downto 0);

	begin
	process(din, cin, shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, shift_val) begin

		if shift_lsl = '1' then -- lsl
			dout <= std_logic_vector(shift_left(unsigned(din), to_integer(unsigned(shift_val))));
			if shift_val = "00000" then
				cout <= '0';
			else
				cout <= din(32-to_integer(unsigned(shift_val)));
			end if; 
		elsif shift_lsr = '1' then -- lsr
			dout <= std_logic_vector(shift_right(unsigned(din), to_integer(unsigned(shift_val))));
			if shift_val = "00000" then
				cout <= '0';
			else
				cout <= din(to_integer(unsigned(shift_val))-1);
			end if;
		elsif shift_asr = '1' then -- asr
			dout <= std_logic_vector(shift_right(signed(din), to_integer(unsigned(shift_val))));
			if shift_val = "00000" then
				cout <= '0';
			else
				cout <= din(to_integer(unsigned(shift_val))-1);
			end if; 
		elsif shift_ror = '1' then -- ror
			dout <= std_logic_vector(rotate_right(unsigned(din), to_integer(unsigned(shift_val))));
			if shift_val = "00000" then
				cout <= '0';
			else
				cout <= din(to_integer(unsigned(shift_val))-1);
			end if;
		else -- rrx
			dout <= ("" &  cin) & din(31 downto 1);
			cout <= din(0);
		end if;
	end process;

end behavioral;
