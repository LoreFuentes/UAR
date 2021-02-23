Library IEEE;
use IEEE.std_logic_1164.all;  
use ieee.numeric_std.all;

Entity AsynReceiver is 
	generic(baudRate : integer :=9600);
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	RXD : in std_logic;
--	ACK : in std_logic;
--	INT : out std_logic;
    --DOUTC: out std_logic_vector(3 downto 0);
	ONE : out std_logic_vector(7 downto 0);
	TEN : out std_logic_vector(7 downto 0);
	HUN : out std_logic_vector(7 downto 0);
	THO : out std_logic_vector(7 downto 0)
--	DOUT: out std_logic_vector(7 downto 0)
	);
end AsynReceiver; 

Architecture Behavioral of AsynReceiver is
-----------Componentes
	
Component FallingEdge is 
	
	port(
	RST   : in   std_logic;
	CLK   : in   std_logic;   
	XIN   : in   std_logic;
	XOUT  : out  std_logic
	);
end Component; 

Component LatchSR is
	port(
		RST : in std_logic; -- se�al de entrada de rest
		CLK : in std_logic; -- se�al de entrada del reloj (50Mhrz)
		SET : in std_logic; 
		CLR : in std_logic; 
		SOUT : out std_logic 
	);
end Component;

Component Timer is 
	generic(ticks : integer := 10);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	EOT : out std_logic
	);
end Component; 

Component Toggle is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	TOG : in std_logic;
	TGS : out std_logic
	); 
end Component;

Component Deserializer is
	generic(busWidth : integer := 10);
	port(
		RST : in std_logic;
		CLK : in std_logic; 
		BIN : in std_logic;
		SHF : in std_logic;
		DOUT : out std_logic_vector(busWidth-1 downto 0)
		);
end Component;

Component CountDown is	
	generic(n : integer :=10);
	port(
		RST : in std_logic;
		CLK : in std_logic; 
		DEC : in std_logic; -- pin que genera un decremento  
		RDY : out std_logic -- Salida de fin de cuenta
	);
end Component;	

component Counter is	
	generic(bits : integer :=10);
	port(
		RST : in std_logic; -- se�al de entrada de rest
		CLK : in std_logic; -- se�al de entrada del reloj (50Mhrz)
		ENA : in std_logic;  
		COUNT : out std_logic_vector(bits-1 downto 0) 
	);
end component; 

component CompuertaXOR is	
	port(
		RST    : in std_logic;
		CLK    : in std_logic; 
		DIN  : in std_logic_vector(7 downto 0); --VECTOR DOUT DEL UAR  
		SAL : out std_logic --valor de la compuerta 
	);
end component;	

component ConversorBinario is
	generic( nBits : integer := 8 );
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STR : in std_logic;
	DIN : in std_logic_vector(nBits - 1 downto 0);
	ONE : out std_logic_vector(7 downto 0);
	TEN : out std_logic_vector(7 downto 0);
	HUN : out std_logic_vector(7 downto 0);
	THO : out std_logic_vector(7 downto 0)
	);
end component;

--component Modulo is	
--	port(
--		RST    : in std_logic;
--		CLK    : in std_logic; 
--		COUNT  : in std_logic_vector(3 downto 0); --numero de 1's en RXD  
--		MODULE : out std_logic_vector(3 downto 0) --valor del modulo 
--	);
--end component;

signal FED, SYN,SYN1, TOG, EOC, ENA, NTOG, SHF, RSTC: std_logic;

signal CNTM : std_logic_vector(7 downto 0);---VALOR DEL MODULo
signal DOUTCC: std_logic_vector(15 downto 0);
--signal DOUTCF: std_logic_vector(15 downto 0);
signal CNTMOD : std_logic; 
begin 
	
----------modulo de division-------------- 


--	DOUT <=CNTM; 
--	DOUTC<= NOT(DOUTCC);
--	CNTMOD <= ((CNTM(0) XOR CNTM(1)) XOR (CNTM(2) XOR CNTM(3))) XOR ((CNTM(4) XOR CNTM(5)) XOR (CNTM(6) XOR CNTM(7)));
--------------------------------------
	NTOG <= NOT(TOG);
	SHF <= SYN AND NTOG;
	
--------Declaracion de se�ales para uar
	U01: FallingEdge port map(RST, CLK, RXD, FED);
	U02: LatchSR port map(RST, CLK, FED, EOC, ENA);
	U03: Timer generic map(50e6/(2*baudRate)) port map(ENA, CLK, SYN); 
	U04: Toggle port map(ENA, CLK, SYN, TOG);
	U05: Deserializer generic map(8) port map(RST, CLK, RXD, SHF, CNTM);
	U06: CountDown generic map(8) port map(ENA, CLK, SHF, EOC);
--	U07: LatchSR port map(RST, CLK,EOC, ACK, INT); 
------------------------------------------------------------------------
--------BLOQUE DE ERRORES EN PARIDAD-----------------------------------
	U08: LatchSR port map(RST, CLK,EOC, SYN1, RSTC); 
	U09: Timer generic map(2) port map(RSTC, CLK, SYN1);
	U10: CompuertaXOR port map(RSTC, CLK, CNTM, CNTMOD);
	U11: Counter generic map(16) port map(RST, CLK, CNTMOD, DOUTCC);--contador final de errores
	U12: ConversorBinario generic map(16) port map(RST, CLK, SYN, DOUTCC, ONE, TEN, HUN, THO);

	
end Behavioral;



