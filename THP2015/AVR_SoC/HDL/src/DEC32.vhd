----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:35:10 04/13/2009 
-- Design Name: 
-- Module Name:    DEC32 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DEC32 is
    Port ( ADDR : in  STD_LOGIC_VECTOR (4 downto 0);
           SEL : out  STD_LOGIC_VECTOR (31 downto 0);
           EN1 : in  STD_LOGIC;
           EN2_N : in  STD_LOGIC);
end DEC32;

architecture Behavioral of DEC32 is

begin
	SEL(0) <= '1' when EN1='1' and EN2_N='0' and ADDR="00000" else '0';
	SEL(1) <= '1' when EN1='1' and EN2_N='0' and ADDR="00001" else '0';
	SEL(2) <= '1' when EN1='1' and EN2_N='0' and ADDR="00010" else '0';
	SEL(3) <= '1' when EN1='1' and EN2_N='0' and ADDR="00011" else '0';
	SEL(4) <= '1' when EN1='1' and EN2_N='0' and ADDR="00100" else '0';
	SEL(5) <= '1' when EN1='1' and EN2_N='0' and ADDR="00101" else '0';
	SEL(6) <= '1' when EN1='1' and EN2_N='0' and ADDR="00110" else '0';
	SEL(7) <= '1' when EN1='1' and EN2_N='0' and ADDR="00111" else '0';
	
	SEL(8) <= '1' when EN1='1' and EN2_N='0' and ADDR="01000" else '0';
	SEL(9) <= '1' when EN1='1' and EN2_N='0' and ADDR="01001" else '0';
	SEL(10) <= '1' when EN1='1' and EN2_N='0' and ADDR="01010" else '0';
	SEL(11) <= '1' when EN1='1' and EN2_N='0' and ADDR="01011" else '0';
	SEL(12) <= '1' when EN1='1' and EN2_N='0' and ADDR="01100" else '0';
	SEL(13) <= '1' when EN1='1' and EN2_N='0' and ADDR="01101" else '0';
	SEL(14) <= '1' when EN1='1' and EN2_N='0' and ADDR="01110" else '0';
	SEL(15) <= '1' when EN1='1' and EN2_N='0' and ADDR="01111" else '0';	
	
	SEL(16) <= '1' when EN1='1' and EN2_N='0' and ADDR="10000" else '0';
	SEL(17) <= '1' when EN1='1' and EN2_N='0' and ADDR="10001" else '0';
	SEL(18) <= '1' when EN1='1' and EN2_N='0' and ADDR="10010" else '0';
	SEL(19) <= '1' when EN1='1' and EN2_N='0' and ADDR="10011" else '0';
	SEL(20) <= '1' when EN1='1' and EN2_N='0' and ADDR="10100" else '0';
	SEL(21) <= '1' when EN1='1' and EN2_N='0' and ADDR="10101" else '0';
	SEL(22) <= '1' when EN1='1' and EN2_N='0' and ADDR="10110" else '0';
	SEL(23) <= '1' when EN1='1' and EN2_N='0' and ADDR="10111" else '0';
	
	SEL(24) <= '1' when EN1='1' and EN2_N='0' and ADDR="11000" else '0';
	SEL(25) <= '1' when EN1='1' and EN2_N='0' and ADDR="11001" else '0';
	SEL(26) <= '1' when EN1='1' and EN2_N='0' and ADDR="11010" else '0';
	SEL(27) <= '1' when EN1='1' and EN2_N='0' and ADDR="11011" else '0';
	SEL(28) <= '1' when EN1='1' and EN2_N='0' and ADDR="11100" else '0';
	SEL(29) <= '1' when EN1='1' and EN2_N='0' and ADDR="11101" else '0';
	SEL(30) <= '1' when EN1='1' and EN2_N='0' and ADDR="11110" else '0';
	SEL(31) <= '1' when EN1='1' and EN2_N='0' and ADDR="11111" else '0';		
	
	

end Behavioral;

