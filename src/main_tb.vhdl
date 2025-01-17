library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.ram.all;


--  A testbench has no ports.
entity main_tb is
end main_tb;

architecture behav of main_tb is
	
	component icache
	port(
	-- Icache interface
			if_adr			: in Std_Logic_vector(31 downto 0) ;
			if_adr_valid	: in Std_Logic;

			ic_inst			: out Std_Logic_vector(31 downto 0) ;
			ic_stall			: out Std_Logic);
	end component;

	component dcache
	port(
	-- Dcache outterface
			mem_adr			: in Std_Logic_Vector(31 downto 0);
			mem_stw			: in Std_Logic;
			mem_stb			: in Std_Logic;
			mem_load			: in Std_Logic;

			mem_data			: in Std_Logic_Vector(31 downto 0);
			dc_data			: out Std_Logic_Vector(31 downto 0);
			dc_stall			: out Std_Logic;

			ck					: in Std_logic);
	end component;

	component arm_core
	port(
	-- Icache interface
			if_adr			: out Std_Logic_Vector(31 downto 0) ;
			if_adr_valid	: out Std_Logic;

			ic_inst			: in Std_Logic_Vector(31 downto 0) ;
			ic_stall			: in Std_Logic;

	-- Dcache interface
			mem_adr			: out Std_Logic_Vector(31 downto 0);
			mem_stw			: out Std_Logic;
			mem_stb			: out Std_Logic;
			mem_load			: out Std_Logic;

			mem_data			: out Std_Logic_Vector(31 downto 0);
			dc_data			: in Std_Logic_Vector(31 downto 0);
			dc_stall			: in Std_Logic;


	-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in bit;
			vss				: in bit);
	end component;

	signal	if_adr			: Std_Logic_Vector(31 downto 0) ;
	signal	if_adr_valid	: Std_Logic;

	signal	ic_inst			: Std_Logic_Vector(31 downto 0) ;
	signal	ic_stall			: Std_Logic;
   
	signal	mem_adr			: Std_Logic_Vector(31 downto 0);
	signal	mem_stw			: Std_Logic;
	signal	mem_stb			: Std_Logic;
	signal	mem_load			: Std_Logic;

	signal	mem_data			: Std_Logic_Vector(31 downto 0);
	signal	dc_data			: Std_Logic_Vector(31 downto 0);
	signal	dc_stall			: Std_Logic;

	signal	ck					: Std_Logic;
	signal	reset_n			: Std_Logic;
	signal	vdd				: bit := '1';
	signal	vss				: bit := '0';

	signal	GoodAdr			: Std_Logic_Vector(31 downto 0) ;
	signal	BadAdr			: Std_Logic_Vector(31 downto 0) ;

	signal valid : std_logic := '1';


	--- ============================================================
	--- ============================================================
	--- Change the constant to your TTY out address
	constant TTY_out : std_logic_vector(31 downto 0) := x"0000007C";
	--- ============================================================
	--- ============================================================

	function to_hstring (value     : STD_LOGIC_VECTOR) return STRING is
    constant ne     : INTEGER := (value'length+3)/4;
    variable pad    : STD_LOGIC_VECTOR(0 to (ne*4 - value'length) - 1);
    variable ivalue : STD_LOGIC_VECTOR(0 to ne*4 - 1);
    variable result : STRING(1 to ne);
    variable quad   : STD_LOGIC_VECTOR(0 to 3);
  begin
    if value'length < 1 then
      return "";
    else
      if value (value'left) = 'Z' then
        pad := (others => 'Z');
      else
        pad := (others => '0');
      end if;
      ivalue := pad & value;
      for i in 0 to ne-1 loop
        quad := To_X01Z(ivalue(4*i to 4*i+3));
        case quad is
          when x"0"   => result(i+1) := '0';
          when x"1"   => result(i+1) := '1';
          when x"2"   => result(i+1) := '2';
          when x"3"   => result(i+1) := '3';
          when x"4"   => result(i+1) := '4';
          when x"5"   => result(i+1) := '5';
          when x"6"   => result(i+1) := '6';
          when x"7"   => result(i+1) := '7';
          when x"8"   => result(i+1) := '8';
          when x"9"   => result(i+1) := '9';
          when x"A"   => result(i+1) := 'A';
          when x"B"   => result(i+1) := 'B';
          when x"C"   => result(i+1) := 'C';
          when x"D"   => result(i+1) := 'D';
          when x"E"   => result(i+1) := 'E';
          when x"F"   => result(i+1) := 'F';
          when "ZZZZ" => result(i+1) := 'Z';
          when others => result(i+1) := 'X';
        end case;
      end loop;
      return result;
    end if;
  end function to_hstring;



	
	begin
	--  Component instantiation.

	icache_i : icache
	port map (	if_adr			=> if_adr,
					if_adr_valid	=> if_adr_valid,
					ic_inst			=> ic_inst,
					ic_stall			=> ic_stall);

	dcache_i : dcache
	port map (	mem_adr	=> mem_adr,
					mem_stw	=> mem_stw,
					mem_stb	=> mem_stb,
					mem_load	=> mem_load,

					mem_data	=> mem_data,
					dc_data	=> dc_data,
					dc_stall	=> dc_stall,

					ck			=> ck);

	arm_core_i : arm_core
	port map (

			if_adr			=> if_adr,
			if_adr_valid	=> if_adr_valid,

			ic_inst			=> ic_inst,
			ic_stall			=> ic_stall,

			mem_adr			=> mem_adr,
			mem_stw			=> mem_stw,
			mem_stb			=> mem_stb,
			mem_load			=> mem_load,

			mem_data			=> mem_data,
			dc_data			=> dc_data,
			dc_stall			=> dc_stall,

			ck					=> ck,
			reset_n			=> reset_n,
			vdd				=> vdd,
			vss				=> vss);

   -- Test ADR GOOD or BAD

--process(if_adr, if_adr_valid)
--begin
--	if if_adr_valid = '1' then
--		 assert if_adr /= GoodAdr report "GOOD!!!" severity failure;
--		 assert if_adr /= BadAdr report "BAD!!!" severity failure;
--	end if;
--end process;
	
	--  This process does the real job.
process

begin

	GoodAdr <= std_logic_vector(TO_SIGNED(mem_goodadr + 4, 32));
	BadAdr <= std_logic_vector(TO_SIGNED(mem_badadr + 4, 32));

	reset_n <= '0';
	ck <= '0';
	wait for 1 ns;
	ck <= '1';
	wait for 1 ns;
	reset_n <= '1';

	while not (if_adr_valid = '1' and (if_adr = GoodAdr or if_adr = BadAdr)) and valid = '1' loop
		ck <= '0';
		wait for 1 ns;
		ck <= '1';
		wait for 1 ns;
	end loop;

	assert if_adr = GoodAdr report "GOOD!!!" severity note;
	assert if_adr = BadAdr report "BAD!!!" severity note;
	assert false report "end of test" severity note;

wait;
end process;

process
begin
	wait until mem_adr = TTY_out;
	if mem_stb = '1' then
		report "TTY out : 0x" & to_hstring(mem_data(7 downto 0));
	elsif mem_stw = '1' then
		report "TTY out : 0x" & to_hstring(mem_data);
	end if;
end process;
	
end behav;
