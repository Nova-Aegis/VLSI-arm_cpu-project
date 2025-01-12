library ieee;
use ieee.std_logic_1164.all;

--library work;
--use work.bidon.all;


--  A testbench has no ports.
entity FA_tb is
end FA_tb;

architecture Structurel of FA_tb is
	--  Declaration un composant
	component FAdder
	port (
		A, B, Cin : in std_logic;
		Sout, Cout : out std_logic);
	end component;

	signal A, B, Cin, Sout, Cout : std_logic;

	begin
	FAdder_0: FAdder
	port map (
		A => A,
		B => B,
		Cin => Cin,
		Sout => Sout,
		Cout => Cout
	);

process

function nat_to_std (v: in natural) return std_logic is
variable res : std_logic;
begin
	if v = 1 then
		res := '1';
	else
		res := '0';
	end if;
	return res;
end function nat_to_std;

variable vSout : std_logic;
variable vCout : std_logic;

begin
La : for va in 0 to 1 loop
	Lb : for vb in 0 to 1 loop
		Lc : for vc in 0 to 1 loop
			A <= nat_to_std(va);
			B <= nat_to_std(vb);
			Cin <= nat_to_std(vc);
			vSout := ( nat_to_std(va) xor nat_to_std(vb) ) xor nat_to_std(vc);
			vCout := ( nat_to_std(va) nand nat_to_std(vb) ) nand
				( nat_to_std(vc) nand ( nat_to_std(va) xor nat_to_std(vb) ) );
			wait for 1 ns;
			assert vSout = Sout report "Erreur sur Sout" severity error;
			assert vCout = Cout report "Erreur sur Cout" severity error;
		end loop Lc;
	end loop Lb;
end loop La;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end Structurel;
