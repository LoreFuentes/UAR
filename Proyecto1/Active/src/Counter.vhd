-- Librerias --
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Counter is	
	generic(bits : integer :=10);
	port(
		RST : in std_logic; -- se�al de entrada de rest
		CLK : in std_logic; -- se�al de entrada del reloj (50Mhrz)
		ENA : in std_logic;  
		COUNT : out std_logic_vector(bits-1 downto 0) 
	);
end Counter;	 

architecture behavioral of Counter is 


signal Qn,Qp : std_logic_vector (bits-1 downto 0) ;
begin

COUNT<=Qp;	
	process(ENA,Qp)
	begin
		if ENA = '1' then
			Qn <= std_logic_vector(unsigned(Qp)+1);
		else
			Qn <= Qp;
		end if;	   
	end process ; 
	
	process	 (RST,CLK)
	begin
		if RST = '0' then 
			Qp <= (others => '0');
		elsif  rising_edge(CLK) then
			Qp <= Qn;
		end if;
	end process;
end;