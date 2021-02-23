Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity ConversorBinario is
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
end ConversorBinario;

Architecture Structural of ConversorBinario is
Component LatchSR is port(
	RST : in std_logic;
	CLK : in std_logic;
	SET : in std_logic;
	CLR : in std_logic;
	SOUT : out std_logic);
end Component;
Component Counter is	
	generic(bits : integer :=10);
	port(
		RST : in std_logic; -- se�al de entrada de rest
		CLK : in std_logic; -- se�al de entrada del reloj (50Mhrz)
		ENA : in std_logic;  
		COUNT : out std_logic_vector(bits-1 downto 0) 
	);
end Component;
Component contadordecimal is port(
	RST : in std_logic;
	CLK : in std_logic;
	ENI : in std_logic;
	ONE : out std_logic_vector(3 downto 0);
	TEN : out std_logic_vector(3 downto 0);
	HUN : out std_logic_vector(3 downto 0);
	THO : out std_logic_vector(3 downto 0));
end Component;
Component display7 is port(
	XIN : in std_logic_vector(3 downto 0);
	SEG : out std_logic_vector(7 downto 0));
end Component;
signal ENA, EOC, RSS, GTE, INC : std_logic;
signal CNT : std_logic_vector(nBits - 1 downto 0);
signal o,t,h,th : std_logic_vector(3 downto 0);
begin
	RSS <= RST AND NOT(STR); 
	INC <= GTE AND ENA;
	EOC <= NOT(GTE); 
	GTE <= '1' when unsigned(DIN) > unsigned(CNT) else '0';
	
	U01 : LatchSR port map(RST, CLK, STR, EOC, ENA);
	U02 : Counter generic map(nBits) port map(ENA, CLK, '1', CNT);
	U03 : contadordecimal port map(RSS, CLK, INC, o, t, h, th);	
	
	U04 : display7 port map (o,ONE); 
	U05 : display7 port map (t,TEN); 
	U06 : display7 port map (h,HUN); 
	U07 : display7 port map (th,THO);
end Structural;