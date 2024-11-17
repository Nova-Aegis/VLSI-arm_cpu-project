library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
	port(
	-- Write Port 1 prioritaire (origine EXE) Rd
		wdata1		: in Std_Logic_Vector(31 downto 0);
		wadr1		: in Std_Logic_Vector(3 downto 0);
		wen1		: in Std_Logic; -- write enable

	-- Write Port 2 non prioritaire (origine MEM) Rd
		wdata2		: in Std_Logic_Vector(31 downto 0);
		wadr2		: in Std_Logic_Vector(3 downto 0);
		wen2		: in Std_Logic;

	-- Write CSPR Port (origine EXE)
		wcry		: in Std_Logic;
		wzero		: in Std_Logic;
		wneg		: in Std_Logic;
		wovr		: in Std_Logic;
		cspr_wb		: in Std_Logic;
		
	-- Read Port 1 32 bits Rn
		reg_rd1		: out Std_Logic_Vector(31 downto 0);
		radr1		: in Std_Logic_Vector(3 downto 0);
		reg_v1		: out Std_Logic;

	-- Read Port 2 32 bits Rs
		reg_rd2		: out Std_Logic_Vector(31 downto 0);
		radr2		: in Std_Logic_Vector(3 downto 0);
		reg_v2		: out Std_Logic;

	-- Read Port 3 32 bits Rm
		reg_rd3		: out Std_Logic_Vector(31 downto 0);
		radr3		: in Std_Logic_Vector(3 downto 0);
		reg_v3		: out Std_Logic;

	-- read CSPR Port
		reg_cry		: out Std_Logic;
		reg_zero	: out Std_Logic;
		reg_neg		: out Std_Logic;
		reg_cznv	: out Std_Logic; -- CNZ valide
		reg_ovr		: out Std_Logic; -- V
		reg_vv		: out Std_Logic; -- V valide
		
	-- Invalidate Port 
		inval_adr1	: in Std_Logic_Vector(3 downto 0);
		inval1		: in Std_Logic;

		inval_adr2	: in Std_Logic_Vector(3 downto 0);
		inval2		: in Std_Logic;

		inval_czn	: in Std_Logic;
		inval_ovr	: in Std_Logic;

	-- PC
		reg_pc		: out Std_Logic_Vector(31 downto 0);
		reg_pcv		: out Std_Logic;
		inc_pc		: in Std_Logic;
	
	-- global interface
		ck			: in Std_Logic;
		reset_n		: in Std_Logic;
		vdd			: in bit;
		vss			: in bit);
end Reg;

architecture Behavior OF Reg is

	component Add32b
		port(
			A : in Std_Logic_Vector(31 downto 0);
			B : in Std_Logic_Vector(31 downto 0);
			cin		: in Std_Logic;
			cout	: out Std_Logic;
			S : out Std_Logic_Vector(31 downto 0)
		);
	end component;

	type reg_array is array(15 downto 0) of std_logic_vector(31 downto 0);
	signal regs : reg_array;
	signal regs_valide : std_logic_vector(15 downto 0);
	
	-- 0 C (flags_valide[0])
	-- 1 N
	-- 2 Z
	-- 3 V (flags_valide[1])
	signal flags : std_logic_vector(3 downto 0);
	signal flags_valide : std_logic_vector(1 downto 0);

	signal pc_upd : std_logic_vector(31 downto 0);

	
begin

	process( ck, reset_n )
	begin
		if reset_n = '0' then
			for i in 0 to 15 loop
				regs(i) <= x"00000000";
				regs_valide(i) <= '1';
			end loop;
			flags <= "0000";
			flags_valide <= "11";
		elsif rising_edge(ck) then
			--- Invalidation des ports
			regs_valide(to_integer(unsigned(inval_adr1))) <= not inval1;
			regs_valide(to_integer(unsigned(inval_adr2))) <= not inval2;
			flags_valide(0) <= not inval_czn;
			flags_valide(1) <= not inval_ovr;

			--- PC
			if regs_valide(15) = '0' then
				if wen1 = '1' and wadr1 = "1111" then
					regs(15) <= wdata1;
				elsif wen2 = '1' and wadr2 = "1111" then
					regs(15) <= wdata2;
				end if;
			elsif inc_pc = '1' then
				regs(15) <= pc_upd;
			end if;
			
			--- écriture registre destination
			if wen1 = '1' and regs_valide(to_integer(unsigned(wadr1))) = '0' then
				regs_valide(to_integer(unsigned(wadr1))) <= '1';
				regs(to_integer(unsigned(wadr1))) <= wdata1;
			end if;	
			if wen2 = '1' and wadr1 /= wadr2 and regs_valide(to_integer(unsigned(wadr1))) = '0' then
				regs_valide(to_integer(unsigned(wadr1))) <= '1';
				regs(to_integer(unsigned(wadr1))) <= wdata1;
			end if;	

			--- écriture des flags			
			if flags_valide(0) = '0' and cspr_wb = '1' then
				flags(0) <= wcry;
				flags(1) <= wzero;
				flags(2) <= wneg;
				flags_valide(0) <= '1';
			end if;
			if flags_valide(1) = '1' and cspr_wb = '1' then
				flags(3) <= wovr;
				flags_valide(1) <= '1';
			end if;
						
			
		end if;
	end process;

	
	--- Lecture registre Source
	reg_rd1 <= regs(to_integer(unsigned(radr1)));
	reg_v1 <= regs_valide(to_integer(unsigned(radr1)));
	reg_rd2 <= regs(to_integer(unsigned(radr2)));
	reg_v2 <= regs_valide(to_integer(unsigned(radr2)));
	reg_rd3 <= regs(to_integer(unsigned(radr3)));
	reg_v3 <= regs_valide(to_integer(unsigned(radr3)));

	--- Lecture flags
	reg_cry <= flags(0);
	reg_zero <= flags(1);
	reg_neg <= flags(2);
	reg_cznv <= flags_valide(0);
	reg_ovr <= flags(3);
	reg_vv <= flags_valide(1);

	



	--- PC updater
	pc_adder : Add32b
		port map(
			A => regs(15),
			B => x"00000004",
			cin => '0',
			cout => open,
			S => pc_upd
		);
	


end Behavior;
