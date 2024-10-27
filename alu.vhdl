library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Alu is
port ( op1 : in std_logic_vector(31 downto 0);
	op2 : in std_logic_vector(31 downto 0);
	cin : in std_logic;
	cmd : in std_logic_vector(1 downto 0);
	res : out std_logic_vector(31 downto 0);
	cout : out std_logic;
	z : out std_logic;
	n : out std_logic;
	v : out std_logic;
	vdd : in bit;
	vss : in bit
);
end Alu;


architecture dataflow of Alu is

	component Add32b
	port (
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		S : out std_logic_vector(31 downto 0)
	);
	end component;
	
	signal res_add : std_logic_vector(31 downto 0);
	signal res_add_cout : std_logic;
	signal res_tmp : std_logic_vector(31 downto 0);

	begin
		-- ADD
		add : Add32b
		port map (
			A => op1,
			B => op2,
			Cin => cin,
			Cout => res_add_cout,
			S => res_add
		);

    with cmd select res_tmp <=
      (op1 and op2) when "01",
      (op1 or op2) when "10",
      (op1 xor op2) when "11",
      res_add when others;
    v <= (res_add_cout xor res_add(31)) and (not cmd(1) and not cmd(0));
    -- res_tmp <= (op1 and op2) when cmd = "01" else
    --            (op1 or op2) when cmd = "10" else
    --            (op1 xor op2) when cmd = "11" else
    --            res_add;
    -- v <= res_add_cout xor res_add(31) when cmd = "00" else '0';
    cout <= res_add_cout;
    
    z <= '1' when res_tmp = x"00000000" else '0';
    n <= res_tmp(31);
		res <= res_tmp;
end dataflow;
