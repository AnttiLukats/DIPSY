----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:48:28 10/12/2007 
-- Design Name: 
-- Module Name:    X_CLK_INT - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity X_CLK_INT is Port ( 
	I : in  STD_LOGIC;
        O : out  STD_LOGIC);
end X_CLK_INT;

architecture Behavioral of X_CLK_INT is

component SB_GB
	port ( USER_SIGNAL_TO_GLOBAL_BUFFER : in std_logic;
		   GLOBAL_BUFFER_OUTPUT : out std_logic);
end component;  

begin
	--O <= I;
    int1 : SB_GB  port map(USER_SIGNAL_TO_GLOBAL_BUFFER => I, GLOBAL_BUFFER_OUTPUT => O);

end Behavioral;

