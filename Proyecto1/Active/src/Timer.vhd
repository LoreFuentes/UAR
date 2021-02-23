Library IEEE;
use IEEE.std_logic_1164.all;

Entity Timer is 
	generic(ticks : integer := 10);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	EOT : out std_logic
	);
end Timer;

Architecture Behavioral of Timer is 
signal Cp, Cn : integer;
begin				  
	Combinational : process(Cp)
	begin
		if Cp = (ticks - 1) then
			EOT <= '1';
			Cn <= 0;
		else 
			EOT <= '0';
			Cn <= Cp + 1;
		end if;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then 
			Cp <= 0;
		elsif CLK'event and CLK = '1' then 
			Cp <= Cn;
		end if;
	end process Sequential;
end Behavioral;
 