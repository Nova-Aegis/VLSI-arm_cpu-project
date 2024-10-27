library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--library work;

entity exec_tb is
end exec_tb;

architecture sim of exec_tb is

  component EXEC
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
  end component;

  constant period : time := 10 ms;
	signal valide : std_logic := '1';
  
	signal dec2exe_empty : std_logic := '0';
	signal mem_pop : std_logic := '0';
	signal ck : std_logic := '0';
	signal reset_n : std_logic := '0';

	signal exe_pop, dec_wb, sw, exe_wb, flag_wb, exe2mem_empty : std_logic;
	signal alu_cmd : std_logic_vector(1 downto 0);
	signal flag, exe_reg, mem_acces, mem_reg : std_logic_vector(3 downto 0);
	signal op1, op2, exe_res, mem_adr, mem_data : std_logic_vector(31 downto 0);

	-- NOTE : commencer avec reset_n = '0' et mem_pop ='1' pour initialiser la
	-- fifo. Après un rising_edge(ck) mettre reset_n = '1' et mem_pop = '0'
	
begin
	exec_0 : EXEC
    port map (
      dec2exe_empty => dec2exe_empty,
      exe_pop => exe_pop,

      dec_op1 => op1,
      dec_op2 => op2,
      dec_exe_dest => "0100",
      dec_exe_wb => dec_wb,
      dec_flag_wb => '0',

      dec_mem_data => x"22222222",
      dec_mem_dest => "1000",
      dec_pre_index => '1',

      dec_mem_lw => '0',
      dec_mem_lb => '0',
      dec_mem_sw => sw,
      dec_mem_sb => '0',

      dec_shift_lsl => '0',
      dec_shift_lsr => '0',
      dec_shift_asr => '1',
      dec_shift_ror => '0',
      dec_shift_rrx => '0',
      dec_shift_val => "00000",
      dec_cy => '0',

      dec_comp_op1 => '0',
      dec_comp_op2 => '0',
      dec_alu_cy => '0',

      dec_alu_cmd => alu_cmd,

      exe_res => exe_res,

      exe_c => flag(0),
      exe_v => flag(1),
      exe_n => flag(2),
      exe_z => flag(3),

      exe_dest => exe_reg,
      exe_wb => exe_wb,
      exe_flag_wb => flag_wb,

      exe_mem_adr	=> mem_adr,
      exe_mem_data => mem_data,
      exe_mem_dest => mem_reg,

      exe_mem_lw => mem_acces(0),
      exe_mem_lb => mem_acces(1),
      exe_mem_sw => mem_acces(2),
      exe_mem_sb => mem_acces(3),
      
      exe2mem_empty => exe2mem_empty,
      mem_pop => mem_pop,
      
      ck => ck,
      reset_n => reset_n,
      vdd => '1',
      vss => '0'
      );
	ck <= not ck after period/2 when valide = '1' else '0';
	
	process(ck)
	begin
		if (rising_edge(ck)) then
			report "";
			report "ck rising edge";
			report "";
		end if;
	end process;
	

	process
	begin
		
    -- clock
    assert false report "start of test" severity note;

    dec2exe_empty <= '0';
    sw <= '0';
    wait until rising_edge(ck);
		assert (exe2mem_empty = '1') report "Start fifo not empty" severity error;
    reset_n <= '1';

    -- Test Case 1 add
    assert (exe_pop = '1') report "Test pop starts at 1 Failed" severity error;
    op1 <= x"FFFFFFFF";
    op2 <= x"00000001";
    dec_wb <= '1';
    alu_cmd <= "00";
    wait until rising_edge(ck);
		assert (exe2mem_empty = '1') report "Start fifo not empty" severity error;
    assert (exe_res = x"00000000") report "Test Case 1 res Failed" severity error;
    assert (flag = "1011") report "Test Case 1 flag Failed" severity error;
    assert (exe_pop = '1') report "Test Case 1 pop Failed" severity error;
    assert (exe_reg = "0100") report "Test Case 1 reg Failed" severity error;
    assert (exe_wb = '1') report "Test Case 1 wb Failed" severity error;
    assert (flag_wb = '0') report "Test Case 1 fwb Failed" severity error;
    assert false report "Test Case 1 complete" severity note;
    
    -- Test Case 2 mem
    assert (exe_pop = '1') report "Test pop starts at 2 Failed" severity error;
    sw <= '1';
    op1 <= x"00000001";
    op2 <= x"00000001";
    dec_wb <= '1';
    alu_cmd <= "00";

    wait until rising_edge(ck);
    assert (exe_res = x"00000002") report "Test Case 2 res Failed" severity error;
    assert (flag = "0000") report "Test Case 2 flag Failed" severity error;
    assert (exe_reg = "0100") report "Test Case 2 reg Failed" severity error;
    assert (exe_wb = '1') report "Test Case 2 wb Failed" severity error;
    assert (flag_wb = '0') report "Test Case 2 fwb Failed" severity error;
    assert (exe2mem_empty = '0') report "Test case 2 fifo not empty Failed" severity error;
		assert false report "Test Case 2 complete" severity note;
    
    -- Test Case 3 mem buffer full
    assert (exe_pop = '1') report "Test pop starts at 3 Failed" severity error;
    sw <= '1';
    op1 <= x"00000010";
    op2 <= x"00000010";
    dec_wb <= '1';
    alu_cmd <= "00";
		mem_pop <= '1';

    wait until rising_edge(ck);
		
    assert (exe_pop = '0') report "Test case 3 pop Failed" severity error;
    mem_pop <= '0';
    sw <= '0';
    assert (exe_res = x"00000020") report "Test Case 3 res Failed" severity error;
    assert (flag = "0000") report "Test Case 3 flag Failed" severity error;
    assert (exe_reg = "0100") report "Test Case 3 reg Failed" severity error;
    assert (exe_wb = '1') report "Test Case 3 wb Failed" severity error;
    assert (flag_wb = '0') report "Test Case 3 fwb Failed" severity error;
		--report to_hstring(mem_adr);
    assert (mem_adr = x"00000002") report "Test Case 3 mem_adr Failed" severity error; 
    assert (mem_data = x"22222222") report "Test Case 3 mem_data Failed" severity error;
    assert (mem_reg = "1000") report "Test Case 3 mem_reg Failed" severity error;
    assert (mem_acces = "0100") report "Test Case 3 mem_acces Failed" severity error;
    assert (exe2mem_empty = '1') report "Test case 3 fifo empty Failed" severity error;
    assert false report "Test Case 3 complte" severity note;

    -- Test Case 4 emptying buffer
    wait until rising_edge(ck);
    assert (exe_pop = '1') report "Test case 4 pop Failed" severity error;
    assert (exe2mem_empty = '1') report "Test case 4 fifo empty Failed" severity error;
    assert (mem_adr = x"00000002") report "Test Case 4 mem_adr Failed" severity error; 
    assert (mem_data = x"22222222") report "Test Case 4 mem_data Failed" severity error;
    assert (mem_reg = "1000") report "Test Case 4 mem_reg Failed" severity error;
    assert (mem_acces = "0100") report "Test Case 4 mem_acces Failed" severity error;
    assert false report "Test Case 4 complte" severity note;

    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.

		valide <= '0';
    wait;
  end process;
end architecture;
