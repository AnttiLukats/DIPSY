----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:48:08 04/08/2008 
-- Design Name: 
-- Module Name:    PORESET - Behavioral 
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

entity PORESET is Port ( 
	    SYSRST  : in  STD_LOGIC;
        RST     : out  STD_LOGIC;
        CLK     : in  STD_LOGIC);
end PORESET;

architecture Behavioral of PORESET is

signal CNT : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal RST_i : STD_LOGIC;

begin
	--RST <= '1' when CNT(7 downto 5)="101" else '0';
	RST_i <= '1' when CNT(3 downto 1)="101" else '0';
    RST <= RST_i;
	
	process (CLK,SYSRST)
	begin
		if (CLK'event and CLK='1') then
            if (SYSRST='0') then
                CNT<="0000";    
            elsif (RST_i='0') then
				CNT<=CNT+"0001";
			end if;
		end if;
	end process;

end Behavioral;

