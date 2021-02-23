Library IEEE;
use IEEE.std_logic_1164.all; 

Entity Toggle is
	port(
	CLK : in std_logic;
	RST : in std_logic;
	TOG : in std_logic;
	TGS : out std_logic
	); 
end Toggle;

Architecture Behavioral of Toggle is
signal Qp, Qn : std_logic;
begin 
	
	Combinational : process(TOG, Qp)
	begin			  
		Qn <= Qp XOR TOG;
		TGS <= Qp;
	end process Combinational;
	
	Secuential : process (CLK, RST)	
	begin
		
		if RST = '0' then
			Qp <= '0'; 
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Secuential;

end Behavioral;