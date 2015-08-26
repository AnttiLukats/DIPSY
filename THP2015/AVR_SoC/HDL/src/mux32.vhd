----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:51 04/13/2009 
-- Design Name: 
-- Module Name:    mux32 - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux32 is
    Port ( DI : in  STD_LOGIC_VECTOR (31 downto 0);
           SEL : in  STD_LOGIC_VECTOR (4 downto 0);
           DO : out  STD_LOGIC);
end mux32;

architecture Behavioral of mux32 is

signal M16 : STD_LOGIC_VECTOR (15 downto 0);
signal M8 : STD_LOGIC_VECTOR (8 downto 0);
signal M4 : STD_LOGIC_VECTOR (4 downto 0);
signal M2 : STD_LOGIC_VECTOR (2 downto 0);

begin
  -- 16 LUT or 31 versatiles!
  DO <= DI( to_integer(unsigned(SEL)) );

--P16 : for I in 0 to 15 generate
--	begin
--		M16(I) <= DI(I*2) when SEL(0)='0' else DI(I*2+1);
--	end generate P16;	
--	
--P8 : for I in 0 to 7 generate
--	begin
--		M8(I) <= M16(I*2) when SEL(1)='0' else DI(I*2+1);
--	end generate P8;	
--	
--P4 : for I in 0 to 3 generate
--	begin
--		M4(I) <= M8(I*2) when SEL(2)='0' else DI(I*2+1);
--	end generate P4;	
--	
--P2 : for I in 0 to 1 generate
--	begin
--		M2(I) <= M4(I*2) when SEL(3)='0' else DI(I*2+1);
--	end generate P2;	
--	
--	DO <= M2(0) when SEL(4)='0' else M2(1);
	
end Behavioral;

