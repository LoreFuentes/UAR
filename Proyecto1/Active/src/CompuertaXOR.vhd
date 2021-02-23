Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CompuertaXOR is	
	port(
		RST    : in std_logic;
		CLK    : in std_logic; 
		DIN  : in std_logic_vector(7 downto 0); --VECTOR DOUT DEL UAR  
		SAL : out std_logic --valor de la compuerta 
	);
end CompuertaXOR;			

architecture behavioral of CompuertaXOR is
--signal dos: std_logic_vector(3 downto 0):="0010";
signal Cp, Cn, XR: std_logic;
begin  
	combinational : process(DIN, Cp, XR)
	begin  
		XR <= ((DIN(0) XOR DIN(1)) XOR (DIN(2) XOR DIN(3))) XOR ((DIN(4) XOR DIN(5)) XOR (DIN(6) XOR DIN(7)));	
		if XR = '0' then 
			Cn <= '1';
		else 
			Cn <= '0';	 
		end if;
		
		SAL <=Cp;
	end process combinational;
	
	sequential : process(RST, CLK)
	begin  
		if RST ='0' then 
			Cp <= '0';
		elsif CLK'event and CLK ='1' then 
			Cp <= Cn;
		end if;
	end process sequential;
	
end behavioral; 