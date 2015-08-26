----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:27:10 06/28/2009 
-- Design Name: 
-- Module Name:    SBRAM - Behavioral 
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

entity SBROM is Port ( 
	RCLK 	: in  STD_LOGIC;
	RADDR 	: in  STD_LOGIC_VECTOR (7 downto 0);
	RDATA 	: out  STD_LOGIC_VECTOR (15 downto 0);
	WCLK	: in  STD_LOGIC;
	WE0 	: in  STD_LOGIC;
	WE1 	: in  STD_LOGIC;
	WADDR 	: in  STD_LOGIC_VECTOR (7 downto 0);
	WDATA 	: in  STD_LOGIC_VECTOR (15 downto 0)
	);
end SBROM;

architecture Behavioral of SBROM is

	component ROM1200
		port(
			Clk	: in std_logic;
			A	: in std_logic_vector(7 downto 0);
			D	: out std_logic_vector(15 downto 0)
		);
	end component;
		
begin

	rom : ROM1200 port map (
			Clk => RCLK,
			A => RADDR,
			D => RDATA);



end Behavioral;

