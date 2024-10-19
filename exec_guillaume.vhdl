library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exec is
	port (
	-- Decode interface synchro
			dec2exe_empty	: in Std_logic;
			exe_pop			: out Std_logic;

	-- Decode interface operands
			dec_op1			: in Std_Logic_Vector(31 downto 0); -- first alu input
			dec_op2			: in Std_Logic_Vector(31 downto 0); -- shifter input
			dec_exe_dest	: in Std_Logic_Vector(3 downto 0); -- Rd destination
			dec_exe_wb		: in Std_Logic; -- Rd destination write back
			dec_flag_wb		: in Std_Logic; -- CSPR modifiy

	-- Decode to mem interface 
			dec_mem_data	: in Std_Logic_Vector(31 downto 0); -- data to MEM W
			dec_mem_dest	: in Std_Logic_Vector(3 downto 0); -- Destination MEM R
			dec_pre_index 	: in Std_logic;

			dec_mem_lw		: in Std_Logic;
			dec_mem_lb		: in Std_Logic;
			dec_mem_sw		: in Std_Logic;
			dec_mem_sb		: in Std_Logic;

	-- Shifter command
			dec_shift_lsl	: in Std_Logic;
			dec_shift_lsr	: in Std_Logic;
			dec_shift_asr	: in Std_Logic;
			dec_shift_ror	: in Std_Logic;
			dec_shift_rrx	: in Std_Logic;
			dec_shift_val	: in Std_Logic_Vector(4 downto 0);
			dec_cy			: in Std_Logic;

	-- Alu operand selection
			dec_comp_op1	: in Std_Logic;
			dec_comp_op2	: in Std_Logic;
			dec_alu_cy 		: in Std_Logic;

	-- Alu command
			dec_alu_cmd		: in Std_Logic_Vector(1 downto 0);

	-- Exe bypass to decod
			exe_res			: out Std_Logic_Vector(31 downto 0);

			exe_c			: out Std_Logic;
			exe_v			: out Std_Logic;
			exe_n			: out Std_Logic;
			exe_z			: out Std_Logic;

			exe_dest		: out Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: out Std_Logic; -- Rd destination write back
			exe_flag_wb		: out Std_Logic; -- CSPR modifiy

	-- Mem interface
			exe_mem_adr		: out Std_Logic_Vector(31 downto 0); -- Alu res register
			exe_mem_data	: out Std_Logic_Vector(31 downto 0);
			exe_mem_dest	: out Std_Logic_Vector(3 downto 0);

			exe_mem_lw		: out Std_Logic;
			exe_mem_lb		: out Std_Logic;
			exe_mem_sw		: out Std_Logic;
			exe_mem_sb		: out Std_Logic;

			exe2mem_empty	: out Std_logic;
			mem_pop			: in Std_logic;

	-- global interface
			ck				: in Std_logic;
			reset_n			: in Std_logic;
			vdd				: in bit;
			vss				: in bit);
end exec;

----------------------------------------------------------------------

architecture Behavior OF exec is

component shifter
	port(
		shift_lsl	: in Std_Logic;
		shift_lsr	: in Std_Logic;
		shift_asr	: in Std_Logic;
		shift_ror	: in Std_Logic;
		shift_rrx	: in Std_Logic;
		shift_val	: in Std_Logic_Vector(4 downto 0);

		din			: in Std_Logic_Vector(31 downto 0);
		cin			: in Std_Logic;

		dout		: out Std_Logic_Vector(31 downto 0);
		cout		: out Std_Logic;

		vdd			: in bit;
		vss			: in bit);
end component;

component alu
	port (
		op1			: in Std_Logic_Vector(31 downto 0);
		op2			: in Std_Logic_Vector(31 downto 0);
		cin			: in Std_Logic;
		
		cmd			: in Std_Logic_Vector(1 downto 0);
		
		res			: out Std_Logic_Vector(31 downto 0);
		cout		: out Std_Logic;
		z			: out Std_Logic;
		n			: out Std_Logic;
		v			: out Std_Logic;
		
		vdd			: in bit;
		vss			: in bit);
end component;

component fifo_72b
	port(
		din			: in std_logic_vector(71 downto 0);
		dout		: out std_logic_vector(71 downto 0);

		-- commands
		push		: in std_logic;
		pop			: in std_logic;

		-- flags
		full		: out std_logic;
		empty		: out std_logic;

		reset_n		: in std_logic;
		ck			: in std_logic;
		vdd			: in bit;
		vss			: in bit);
end component;


signal shift_c 		: std_logic;
signal alu_c 		: std_logic;

signal op2			: std_logic_vector(31 downto 0);
signal op2_shift	: std_logic_vector(31 downto 0);
signal op1			: std_logic_vector(31 downto 0);


signal alu_res		: std_logic_vector(31 downto 0);
signal res_reg		: std_logic_vector(31 downto 0);
signal mem_adr		: std_logic_vector(31 downto 0);

signal exe_push 	: std_logic;
signal exe2mem_full	: std_logic;
signal mem_acces	: std_logic;

begin

--  Component instantiation.
	shifter_inst : Shifter
	port map (
		shift_lsl	=> dec_shift_lsl,
		shift_lsr	=> dec_shift_lsr,
		shift_asr	=> dec_shift_asr,
		shift_ror	=> dec_shift_ror,
		shift_rrx	=> dec_shift_rrx,
		shift_val	=> dec_shift_val,

		din			=> dec_op2,
		cin			=> dec_cy,

		dout		=> op2_shift,
		cout		=> shift_c,

		vdd			=> vdd,
		vss			=> vss
	);

	alu_inst : alu
	port map (
		op1		 => op1,
		op2		 => op2,
		cin		 => dec_alu_cy,

		cmd		 => dec_alu_cmd,

		res		 => alu_res,
		cout	 => alu_c,
		z		 => exe_z,
		n		 => exe_n,
		v		 => exe_v,

		vdd		 => vdd,
		vss		 => vss
	);

	exec2mem : fifo_72b
	port map (
		din(71)	 => dec_mem_lw,
		din(70)	 => dec_mem_lb,
		din(69)	 => dec_mem_sw,
		din(68)	 => dec_mem_sb,

		din(67 downto 64) => dec_mem_dest,
		din(63 downto 32) => dec_mem_data,
		din(31 downto 0) => mem_adr,

		dout(71)	 => exe_mem_lw,
		dout(70)	 => exe_mem_lb,
		dout(69)	 => exe_mem_sw,
		dout(68)	 => exe_mem_sb,

		dout(67 downto 64) => exe_mem_dest,
		dout(63 downto 32) => exe_mem_data,
		dout(31 downto 0)  => exe_mem_adr,

		push	 => exe_push,
		pop		 => mem_pop,

		empty		 => exe2mem_empty,
		full		 => exe2mem_full,

		reset_n	 => reset_n,
		ck		 => ck,
		vdd		 => vdd,
		vss		 => vss
	);

  
  --- calc op2
  op2 <= op2_shift when dec_comp_op2 = '0'
         else not op2_shift;
  -- if dec_comp_op2 = '0' then
  --   op2 <= op2_shift;
  -- else -- not ( shift_op2 )
  --   op2 <= not op2_shift;
  -- end if;

  --- calc op1
  op1 <= dec_op1 when dec_comp_op1 = '0'
         else not dec_op1;
  -- if dec_comp_op1 = '0' then 
  --   op1 <= dec_op1;
  -- else -- not op1
  --   op1 <= not dec_op2;
  -- end if;

  --- sortie alu
  exe_res <= alu_res;
  mem_adr <= alu_res when dec_pre_index = '1'
             else dec_op1;


  
  
  exe_push <= '1' when (not exe2mem_full and (dec_exe_lw or dec_exe_lb or dec_exe_sw or dec_exe_sb)) = '1' else '0';
  
  if dec_exe_wb = '0' then -- vers DEC
    exe_res <= alu_res;
    exe_pop <= '1';
  else -- vers MEM
    -- alu_res => buffer ???
    if exe2mem_full = '0' then
      exe_push <= '1'; 
      if dec_pre_index = '1' then
        mem_adr <= alu_res;
      else 
        mem_adr <= dec_op1;
      end if;
      exe_pop <= '1';
    end if;
    
  end if;

  --- sortie flags alu
  exe_flag_wb <= dec_flag_wb;
  if dec_alu_cmd = "00" then -- update carry flag for Add
    exe_c <= alu_c;
  else
    exe_c <= shift_c;
  end if;

      
	--- dec data -> mem data ???
	-- dec_mem_data => buffer

-- res_reg mem_adr exe_push mem_acces

-- synchro
	-- mem_adr <= X"00000000";
	-- mem_acces <= '0';
	-- exe_push <= '1';

	-- exe_pop	<= '0';

-- cout
	-- exe_c <= '0';

-- ALU opearandes

	-- op1 <=	X"00000000";

	-- op2 <=	X"00000000";

-- Loop dec

	-- exe_dest <= '1:
	-- exe_wb <= '1;
	-- exe_flag_wb <= '0';

	-- exe_res <= X"00000000";
end Behavior;
