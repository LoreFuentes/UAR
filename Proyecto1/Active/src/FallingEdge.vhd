Library IEEE;
use IEEE.std_logic_1164.all;

Entity FallingEdge is 
	
	port(
	RST   : in   std_logic;
	CLK   : in   std_logic;   
	XIN   : in   std_logic;
	XOUT  : out  std_logic
	);
end FallingEdge; 

Architecture Behavioral of FallingEdge is 	
signal Qp, Qn : std_logic_vector(2 downto 0):="000";

begin 
	combinational : process (Qp, XIN)
	begin 
		Qn(0) <= XIN;
		Qn(1) <= Qp(0);
		Qn(2) <= Qp(1);
		XOUT <= NOT(Qp(0)) AND NOT (Qp(1)) AND Qp(2);
	end process combinational;
	
	sequential : process(RST, CLK)
	begin 
		if RST = '0' then 
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then 
			Qp <= Qn;
		end if;	
	end process sequential;	
	
	
end Behavioral;