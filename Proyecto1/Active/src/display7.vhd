Library IEEE;
use IEEE.std_logic_1164.all;

Entity display7 is
	port(
	XIN : in std_logic_vector(3 downto 0);
	SEG : out std_logic_vector(7 downto 0)
	);
end display7;

Architecture datapath of display7 is
begin
	With XIN Select SEG <=
	"10011111" when "0001", --1
	"00100101" when "0010",	--2
	"00001101" when "0011",	--3
	"10011001" when "0100",	--4
	"01001001" when "0101",	--5
	"01000001" when "0110",	--6
	"00011101" when "0111",	--7
	"00000001" when "1000",	--8
	"00001001" when "1001",	--9
	"00010001" when "1010",	--A
	"11000001" when "1011",	--B
	"01100011" when "1100",	--C
	"10000101" when "1101",	--D
	"01100001" when "1110",	--E
	"01110001" when "1111",	--F
	"00000011" when others;	--0
end datapath;