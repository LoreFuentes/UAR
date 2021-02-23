Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CountDown is	
	generic(n : integer :=10);
	port(
		RST : in std_logic;
		CLK : in std_logic; 
		DEC : in std_logic; -- pin que genera un decremento  
		RDY : out std_logic -- Salida de fin de cuenta
	);
end CountDown; 

architecture behavioral of CountDown is 
--signals 
signal Cp, Cn : integer; 
begin 
	--Combinational	
	Combinational : process(Cp, DEC)
	begin 
		if DEC = '1' then 
			Cn <= Cp - 1;
		else 
			Cn <= Cp;
		end if;
		if Cp = -1 then 
			RDY <= '1';
		else 
			RDY <= '0';
		end if ;			
	end process Combinational;
	--Sequential
	sequential : process(RST,CLK)
	begin 
		if RST = '0' then 
			Cp <= n;
		elsif CLK' event and CLK = '1' then 
			Cp <= Cn;
		end if;
	end process sequential; 
end behavioral;
