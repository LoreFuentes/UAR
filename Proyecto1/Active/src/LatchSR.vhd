--Componente Latch--

-- Librerias --
Library ieee;
use ieee.std_logic_1164.all;


entity LatchSR is
	port(
		RST : in std_logic; -- señal de entrada de rest
		CLK : in std_logic; -- señal de entrada del reloj (50Mhrz)
		SET : in std_logic; 
		CLR : in std_logic; 
		SOUT : out std_logic 
	);
end LatchSR;	 

architecture behavioral of LatchSR is 


signal Qn,Qp : std_logic ;
begin

SOUT<=Qp;	
	process(CLR,SET,Qp)
	begin
		if CLR = '1' then
			Qn <= '0';
		elsif SET = '1' then
			Qn <= '1' ;
		else
			Qn <= Qp;
		end if;	   
	end process ; 
	
	process	 (RST,CLK)
	begin
		if RST = '0' then 
			Qp <= '0';
		elsif  rising_edge(CLK) then
			Qp <= Qn;
		end if;
	end process;
end;

