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


architecture behavioral of Alu is

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

	process (cmd, op1, op2)
	begin
		case cmd is
			when "01" =>
				res_tmp <= op1 and op2;
				v <= '0';
			when "10" =>
				res_tmp <= op1 or op2;
				v <= '0';
			when "11" =>
				res_tmp <= op1 xor op2;
				v <= '0';
			when others =>
				res_tmp <= res_add;
				v <= res_add_cout xor res_add(31);
		end case;

		cout <= res_add_cout;
		
		if res_tmp = x"00000000" then 
			z <= '1';		
		else
			z <= '0';
		end if;

		n <= res_tmp(31);
		res <= res_tmp;

	end process;	
end behavioral;
