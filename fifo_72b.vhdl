library ieee;
use ieee.std_logic_1164.all;

entity fifo_72b is
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
end fifo_72b;

architecture dataflow of fifo_72b is

  signal fifo_d	: std_logic_vector(71 downto 0);
  signal fifo_v	: std_logic;

begin

		
	-- process(ck)

	-- 	function to_hstring (value     : STD_LOGIC_VECTOR) return STRING is
	-- 		constant ne     : INTEGER := (value'length+3)/4;
	-- 		variable pad    : STD_LOGIC_VECTOR(0 to (ne*4 - value'length) - 1);
	-- 		variable ivalue : STD_LOGIC_VECTOR(0 to ne*4 - 1);
	-- 		variable result : STRING(1 to ne);
	-- 		variable quad   : STD_LOGIC_VECTOR(0 to 3);
	-- 	begin
	-- 		if value'length < 1 then
	-- 			return "";
	-- 		else
	-- 			if value (value'left) = 'Z' then
	-- 				pad := (others => 'Z');
	-- 			else
	-- 				pad := (others => '0');
	-- 			end if;
	-- 			ivalue := pad & value;
	-- 			for i in 0 to ne-1 loop
	-- 				quad := To_X01Z(ivalue(4*i to 4*i+3));
	-- 				case quad is
	-- 					when x"0"   => result(i+1) := '0';
	-- 					when x"1"   => result(i+1) := '1';
	-- 					when x"2"   => result(i+1) := '2';
	-- 					when x"3"   => result(i+1) := '3';
	-- 					when x"4"   => result(i+1) := '4';
	-- 					when x"5"   => result(i+1) := '5';
	-- 					when x"6"   => result(i+1) := '6';
	-- 					when x"7"   => result(i+1) := '7';
	-- 					when x"8"   => result(i+1) := '8';
	-- 					when x"9"   => result(i+1) := '9';
	-- 					when x"A"   => result(i+1) := 'A';
	-- 					when x"B"   => result(i+1) := 'B';
	-- 					when x"C"   => result(i+1) := 'C';
	-- 					when x"D"   => result(i+1) := 'D';
	-- 					when x"E"   => result(i+1) := 'E';
	-- 					when x"F"   => result(i+1) := 'F';
	-- 					when "ZZZZ" => result(i+1) := 'Z';
	-- 					when others => result(i+1) := 'X';
	-- 				end case;
	-- 			end loop;
	-- 			return result;
	-- 		end if;
	-- 	end function to_hstring;

		
  begin
		if rising_edge(ck) then
			--report "fifo_v : " & to_hstring("000" & fifo_v);
			-- Valid bit
			if reset_n = '0' then
				fifo_v <= '0';
			else
				if fifo_v = '0' then
					if push = '1' then
						--report "fifo72b :     | push detected";
						fifo_v <= '1';
					else
						fifo_v <= '0';
					end if;
				else
					if pop = '1' then 
						if push = '1' then
							--report "fifo72b : pop | push detected";
							fifo_v <= '1';
						else
							--report "fifo72b : pop |      detected";
							fifo_v <= '0';
						end if;
					else
						fifo_v <= '1';
					end if;
				end if;
			end if;

			-- data
			if fifo_v = '0' then
				if push = '1' then
					--report "din " & to_hstring(din(31 downto 0));
					fifo_d <= din;
				end if;
			elsif push='1' and pop='1' then
        --report "din " & to_hstring(din(31 downto 0)) & " | dout " & to_hstring(fifo_d(31 downto 0));
				fifo_d <= din;
			end if;
		end if;
	end process;

	full <= '1' when fifo_v = '1' and pop = '0' else '0';
	empty <= not fifo_v;
	dout <= fifo_d;

end dataflow;
