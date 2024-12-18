library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity arm_tb is
end arm_tb;


architecture sim OF arm_tb is

	Component IFetch
		port(
			-- Icache interface
			if_adr			: out Std_Logic_Vector(31 downto 0) ;
			if_adr_valid	: out Std_Logic;

			ic_inst			: in Std_Logic_Vector(31 downto 0) ;
			ic_stall			: in Std_Logic;

			-- Decode interface
			dec2if_empty	: in Std_Logic;
			if_pop			: out Std_Logic;
			dec_pc			: in Std_Logic_Vector(31 downto 0) ;

			if_ir				: out Std_Logic_Vector(31 downto 0) ;
			if2dec_empty	: out Std_Logic;
			dec_pop			: in Std_Logic;

			-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in bit;
			vss				: in bit);
	end Component;

	Component Decod
		port(
			-- Exec  operands
			dec_op1			: out Std_Logic_Vector(31 downto 0); -- first alu input
			dec_op2			: out Std_Logic_Vector(31 downto 0); -- shifter input
			dec_exe_dest	: out Std_Logic_Vector(3 downto 0); -- Rd destination
			dec_exe_wb		: out Std_Logic; -- Rd destination write back
			dec_flag_wb		: out Std_Logic; -- CSPR modifiy

			-- Decod to mem via exec
			dec_mem_data	: out Std_Logic_Vector(31 downto 0); -- data to MEM
			dec_mem_dest	: out Std_Logic_Vector(3 downto 0);
			dec_pre_index 	: out Std_logic;

			dec_mem_lw		: out Std_Logic;
			dec_mem_lb		: out Std_Logic;
			dec_mem_sw		: out Std_Logic;
			dec_mem_sb		: out Std_Logic;

			-- Shifter command
			dec_shift_lsl	: out Std_Logic;
			dec_shift_lsr	: out Std_Logic;
			dec_shift_asr	: out Std_Logic;
			dec_shift_ror	: out Std_Logic;
			dec_shift_rrx	: out Std_Logic;
			dec_shift_val	: out Std_Logic_Vector(4 downto 0);
			dec_cy			: out Std_Logic;

			-- Alu operand selection
			dec_comp_op1	: out Std_Logic;
			dec_comp_op2	: out Std_Logic;
			dec_alu_cy 		: out Std_Logic;

			-- Exec Synchro
			dec2exe_empty	: out Std_Logic;
			exe_pop			: in Std_logic;

			-- Alu command
			dec_alu_cmd		: out Std_Logic_Vector(1 downto 0);

			-- Exe Write Back to reg
			exe_res			: in Std_Logic_Vector(31 downto 0);

			exe_c				: in Std_Logic;
			exe_v				: in Std_Logic;
			exe_n				: in Std_Logic;
			exe_z				: in Std_Logic;

			exe_dest			: in Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: in Std_Logic; -- Rd destination write back
			exe_flag_wb		: in Std_Logic; -- CSPR modifiy

			-- Ifetch interface
			dec_pc			: out Std_Logic_Vector(31 downto 0) ;
			if_ir				: in Std_Logic_Vector(31 downto 0) ;

			-- Ifetch synchro
			dec2if_empty	: out Std_Logic;
			if_pop			: in Std_Logic;

			if2dec_empty	: in Std_Logic;
			dec_pop			: out Std_Logic;

			-- Mem Write back to reg
			mem_res			: in Std_Logic_Vector(31 downto 0);
			mem_dest			: in Std_Logic_Vector(3 downto 0);
			mem_wb			: in Std_Logic;
			
			-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in bit;
			vss				: in bit);
	end Component;

	Component EXec
		port(
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

			exe_c				: out Std_Logic;
			exe_v				: out Std_Logic;
			exe_n				: out Std_Logic;
			exe_z				: out Std_Logic;

			exe_dest			: out Std_Logic_Vector(3 downto 0); -- Rd destination
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
			ck					: in Std_logic;
			reset_n			: in Std_logic;
			vdd				: in bit;
			vss				: in bit);
	end Component;

	Component Mem
		port(
			-- Exe interface
			exe2mem_empty	: in Std_logic;
			mem_pop			: out Std_logic;
			exe_mem_adr		: in Std_Logic_Vector(31 downto 0);
			exe_mem_data	: in Std_Logic_Vector(31 downto 0);
			exe_mem_dest	: in Std_Logic_Vector(3 downto 0);

			exe_mem_lw		: in Std_Logic;
			exe_mem_lb		: in Std_Logic;
			exe_mem_sw		: in Std_Logic;
			exe_mem_sb		: in Std_Logic;

			-- Mem WB
			mem_res			: out Std_Logic_Vector(31 downto 0);
			mem_dest			: out Std_Logic_Vector(3 downto 0);
			mem_wb			: out Std_Logic;
			
			-- Dcache interface
			mem_adr			: out Std_Logic_Vector(31 downto 0);
			mem_stw			: out Std_Logic;
			mem_stb			: out Std_Logic;
			mem_load			: out Std_Logic;

			mem_data			: out Std_Logic_Vector(31 downto 0);
			dc_data			: in Std_Logic_Vector(31 downto 0);
			dc_stall			: in Std_Logic;

			-- global interface
			vdd				: in bit;
			vss				: in bit);
	end Component;

--signal if2dec_full	: std_logic;

	Signal if_pop			: Std_Logic;
	Signal if_ir			: Std_Logic_Vector(31 downto 0) ;
	Signal if2dec_empty	: Std_Logic;

	Signal dec_op1			: Std_Logic_Vector(31 downto 0);
	Signal dec_op2			: Std_Logic_Vector(31 downto 0);
	Signal dec_exe_dest	: Std_Logic_Vector(3 downto 0);
	Signal dec_exe_wb		: Std_Logic;
	Signal dec_flag_wb		: Std_Logic;
	Signal dec_mem_data	: Std_Logic_Vector(31 downto 0);
	Signal dec_mem_dest	: Std_Logic_Vector(3 downto 0);
	Signal dec_pre_index : Std_logic;
	Signal dec_mem_lw		: Std_Logic;
	Signal dec_mem_lb		: Std_Logic;
	Signal dec_mem_sw		: Std_Logic;
	Signal dec_mem_sb		: Std_Logic;
	Signal dec_shift_lsl	: Std_Logic;
	Signal dec_shift_lsr	: Std_Logic;
	Signal dec_shift_asr	: Std_Logic;
	Signal dec_shift_ror	: Std_Logic;
	Signal dec_shift_rrx	: Std_Logic;
	Signal dec_shift_val	: Std_Logic_Vector(4 downto 0);
	Signal dec_cy			: Std_Logic;
	Signal dec_comp_op1	: Std_Logic;
	Signal dec_comp_op2	: Std_Logic;
	Signal dec_alu_cy 	: Std_Logic;
	Signal dec2exe_empty	: Std_Logic;
	Signal dec_alu_cmd	: Std_Logic_Vector(1 downto 0);
	Signal dec_pc			: Std_Logic_Vector(31 downto 0) ;
	Signal dec2if_empty	: Std_Logic;
	Signal dec_pop			: Std_Logic;

	Signal exe_pop			: Std_logic;
	Signal exe_res			: Std_Logic_Vector(31 downto 0);
	Signal exe_c			: Std_Logic;
	Signal exe_v			: Std_Logic;
	Signal exe_n			: Std_Logic;
	Signal exe_z			: Std_Logic;
	Signal exe_dest		: Std_Logic_Vector(3 downto 0);
	Signal exe_wb			: Std_Logic;
	Signal exe_flag_wb	: Std_Logic;
	Signal exe_mem_adr	: Std_Logic_Vector(31 downto 0);
	Signal exe_mem_data	: Std_Logic_Vector(31 downto 0);
	Signal exe_mem_dest	: Std_Logic_Vector(3 downto 0);
	Signal exe_mem_lw		: Std_Logic;
	Signal exe_mem_lb		: Std_Logic;
	Signal exe_mem_sw		: Std_Logic;
	Signal exe_mem_sb		: Std_Logic;
	Signal exe2mem_empty	: Std_logic;

	Signal mem_pop			: Std_Logic;
	Signal mem_res			: Std_Logic_Vector(31 downto 0);
	Signal mem_dest		: Std_Logic_Vector(3 downto 0);
	Signal mem_wb			: Std_Logic;


	
	signal if_adr			: Std_Logic_Vector(31 downto 0);
	signal if_adr_valid	: Std_Logic;

	signal ic_inst				: Std_Logic_Vector(31 downto 0) := x"00000000";
	signal ic_stall			: Std_Logic := '1';

	-- Dcache interface
	signal mem_adr			: Std_Logic_Vector(31 downto 0);
	signal mem_stw			: Std_Logic;
	signal mem_stb			: Std_Logic;
	signal mem_load			: Std_Logic;

	signal mem_data			: Std_Logic_Vector(31 downto 0);
	signal dc_data			: Std_Logic_Vector(31 downto 0) := x"00000000";
	signal dc_stall			: Std_Logic := '0';
	

	signal vdd : bit := '1';
	signal vss : bit := '0';
	signal ck : std_logic := '0';
	signal reset_n : std_logic := '0';
	
	constant period : time := 50 ms;
	signal valid : std_logic := '1';


	
begin

	ifetch_i : ifetch
	port map (
	-- Icache interface
					if_adr			=> if_adr,
					if_adr_valid	=> if_adr_valid,
      
					ic_inst			=> ic_inst,
					ic_stall			=> ic_stall,

					dec2if_empty	=> dec2if_empty,
					if_pop			=> if_pop,
					dec_pc			=> dec_pc,
      
					if_ir				=> if_ir,
					if2dec_empty	=> if2dec_empty,
					dec_pop			=> dec_pop,

					reset_n			=> reset_n,
					ck		 			=> ck,
					vdd	 			=> vdd,
					vss	 			=> vss);

	decod_i : decod
	port map (
	-- Exec  operands
					dec_op1			=> dec_op1,
					dec_op2			=> dec_op2,
					dec_exe_dest	=> dec_exe_dest,
					dec_exe_wb		=> dec_exe_wb,
					dec_flag_wb		=> dec_flag_wb,

	-- Decod to mem via exec
					dec_mem_data	=> dec_mem_data,
					dec_mem_dest	=> dec_mem_dest,
					dec_pre_index 	=> dec_pre_index ,

					dec_mem_lw		=> dec_mem_lw,
					dec_mem_lb		=> dec_mem_lb,
					dec_mem_sw		=> dec_mem_sw,
					dec_mem_sb		=> dec_mem_sb,

	-- Shifter command
					dec_shift_lsl	=> dec_shift_lsl,
					dec_shift_lsr	=> dec_shift_lsr,
					dec_shift_asr	=> dec_shift_asr,
					dec_shift_ror	=> dec_shift_ror,
					dec_shift_rrx	=> dec_shift_rrx,
					dec_shift_val	=> dec_shift_val,
					dec_cy			=> dec_cy,

	-- Alu operand selection
					dec_comp_op1	=> dec_comp_op1,
					dec_comp_op2	=> dec_comp_op2,
					dec_alu_cy 		=> dec_alu_cy ,

	-- Exec Synchro
					dec2exe_empty	=> dec2exe_empty,
					exe_pop			=> exe_pop,

	-- Alu command
					dec_alu_cmd		=> dec_alu_cmd,

	-- Exe Write Back to reg
					exe_res			=> exe_res,

					exe_c				=> exe_c,
					exe_v				=> exe_v,
					exe_n				=> exe_n,
					exe_z				=> exe_z,

					exe_dest			=> exe_dest,
					exe_wb			=> exe_wb,
					exe_flag_wb		=> exe_flag_wb,

	-- Ifetch interface
					dec_pc			=> dec_pc,
					if_ir				=> if_ir,

	-- Ifetch synchro
					dec2if_empty	=> dec2if_empty,
					if_pop			=> if_pop,

					if2dec_empty	=> if2dec_empty,
					dec_pop			=> dec_pop,

	-- Mem Write back to reg
					mem_res			=> mem_res,
					mem_dest			=> mem_dest,
					mem_wb			=> mem_wb,

	-- global interface
					reset_n			=> reset_n,
					ck		 			=> ck,
					vdd	 			=> vdd,
					vss	 			=> vss);

	exec_i : exec
	port map (
	-- Decode interface synchro
					dec2exe_empty	=> dec2exe_empty,
					exe_pop			=> exe_pop,

	-- Decode interface operands
					dec_op1			=> dec_op1,
					dec_op2			=> dec_op2,
					dec_exe_dest	=> dec_exe_dest,
					dec_exe_wb		=> dec_exe_wb,
					dec_flag_wb		=> dec_flag_wb,

	-- Decode to mem interface 
					dec_mem_data	=> dec_mem_data,
					dec_mem_dest	=> dec_mem_dest,
					dec_pre_index 	=> dec_pre_index ,

					dec_mem_lw		=> dec_mem_lw,
					dec_mem_lb		=> dec_mem_lb,
					dec_mem_sw		=> dec_mem_sw,
					dec_mem_sb		=> dec_mem_sb,

	-- Shifter command
					dec_shift_lsl	=> dec_shift_lsl,
					dec_shift_lsr	=> dec_shift_lsr,
					dec_shift_asr	=> dec_shift_asr,
					dec_shift_ror	=> dec_shift_ror,
					dec_shift_rrx	=> dec_shift_rrx,
					dec_shift_val	=> dec_shift_val,
					dec_cy			=> dec_cy,

	-- Alu operand selection
					dec_comp_op1	=> dec_comp_op1,
					dec_comp_op2	=> dec_comp_op2,
					dec_alu_cy 		=> dec_alu_cy ,

	-- Alu command
					dec_alu_cmd		=> dec_alu_cmd,

	-- Exe bypass to decod
					exe_res			=> exe_res,

					exe_c				=> exe_c,
					exe_v				=> exe_v,
					exe_n				=> exe_n,
					exe_z				=> exe_z,

					exe_dest			=> exe_dest,
					exe_wb			=> exe_wb,
					exe_flag_wb		=> exe_flag_wb,

	-- Mem interface
					exe_mem_adr		=> exe_mem_adr,
					exe_mem_data	=> exe_mem_data,
					exe_mem_dest	=> exe_mem_dest,

					exe_mem_lw		=> exe_mem_lw,
					exe_mem_lb		=> exe_mem_lb,
					exe_mem_sw		=> exe_mem_sw,
					exe_mem_sb		=> exe_mem_sb,

					exe2mem_empty	=> exe2mem_empty,
					mem_pop			=> mem_pop,

	-- global interface
					reset_n			=> reset_n,
					ck		 			=> ck,
					vdd	 			=> vdd,
					vss	 			=> vss);

	mem_i : mem
	port map (
	-- Exe interface
					exe2mem_empty	=> exe2mem_empty,
					mem_pop			=> mem_pop,
					exe_mem_adr		=> exe_mem_adr,
					exe_mem_data	=> exe_mem_data,
					exe_mem_dest	=> exe_mem_dest,

					exe_mem_lw		=> exe_mem_lw,
					exe_mem_lb		=> exe_mem_lb,
					exe_mem_sw		=> exe_mem_sw,
					exe_mem_sb		=> exe_mem_sb,

	-- Mem WB
					mem_res			=> mem_res,
					mem_dest			=> mem_dest,
					mem_wb			=> mem_wb,
			
	-- Dcache interface
					mem_adr			=> mem_adr,
					mem_stw			=> mem_stw,
					mem_stb			=> mem_stb,
					mem_load			=> mem_load,

					mem_data			=> mem_data,
					dc_data			=> dc_data,
					dc_stall			=> dc_stall,

	-- global interface
					vdd	 			=> vdd,
					vss	 			=> vss);

	ck <= not ck after period/2 when valid = '1' else '0';
	
process
	
begin

	wait until rising_edge(ck);
	wait for 10 ns;

	assert dec2if_empty = '1' report "start dec2if not mepty";
	assert if2dec_empty = '1' report "start if2dec not empty";

	wait until rising_edge(ck);
	reset_n <= '1';

	if_pop <= '1';
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	wait for 10 ns;
	
	assert if_adr = x"00000" & x"0000" report "first instr adr not 0x00";
	assert if_adr_valid = '1' report "first instr not valid";

	-- wait 1 cycle to push instruction
	wait until rising_edge(ck);
	ic_stall <= '0';
	ic_inst <= "1110" & "001" & "0100" & "0" & "0000" & "0000" & "0000" & "00001000";
	--- ADD r0, r0, 8
	assert if_adr = x"0000" & x"0001" report "second instr adr not 0x01";
	assert if_adr_valid = '1' report "second instr not valid";
	assert dec_pop = '1' report "decode not poping";
		
	wait until rising_edge(ck);
	ic_inst <= "1110" & "000" & "1101" & "0" & "0000" & "0001" & "00000000" & "0000"; 
	--- MOV r1, r0
	assert if_adr = x"0000" & x"0002" report "third instr adr not 0x02";
	assert if_adr_valid = '1' report "third instr not valid";
	assert dec_pop = '1' report "decode not poping";

	wait until rising_edge(ck);
	ic_inst <= "1110" & "001" & "0100"  & "0" & "0000" & "0010" & "0000" & "11110000"; 
	assert dec_pop = '0' report "decode poping when should not";
	
	wait until rising_edge(ck);
	ic_stall <= '1';
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	wait until rising_edge(ck);
	valid <= '0';
	wait;

end process;
end;
