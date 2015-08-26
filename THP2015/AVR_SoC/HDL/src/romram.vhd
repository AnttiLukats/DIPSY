----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:46:58 04/15/2009 
-- Design Name: 
-- Module Name:    romram - Behavioral 
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

entity romram is Port ( 
				clk 			: in  STD_LOGIC;
				A 				: in  STD_LOGIC_VECTOR (9 downto 0);
				D 				: out  STD_LOGIC_VECTOR (15 downto 0);
				COUT 			: in  STD_LOGIC_VECTOR (8 downto 0);
				WA 			: in  STD_LOGIC_VECTOR (10 downto 0);
				WDO 			: out  STD_LOGIC_VECTOR (7 downto 0);
				WDI 			: in  STD_LOGIC_VECTOR (7 downto 0);
				WE 			: in  STD_LOGIC;
				init_clk 	: in STD_LOGIC;
				init_req 	: in  STD_LOGIC;
				init_done 	: in  STD_LOGIC
				);
end romram;

architecture Behavioral of romram is

	COMPONENT SBRAM
	PORT(
		RCLK : IN std_logic;
		RADDR : IN std_logic_vector(7 downto 0);
		WCLK : IN std_logic;
		WE0   : IN std_logic;
		WE1   : IN std_logic;
		WADDR : IN std_logic_vector(7 downto 0);
		WDATA : IN std_logic_vector(15 downto 0);          
		RDATA : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	COMPONENT SBROM
	PORT(
		RCLK : IN std_logic;
		RADDR : IN std_logic_vector(7 downto 0);
		WCLK : IN std_logic;
		WE0   : IN std_logic;
		WE1   : IN std_logic;
		WADDR : IN std_logic_vector(7 downto 0);
		WDATA : IN std_logic_vector(15 downto 0);          
		RDATA : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;


--signal bios_data : std_logic_vector(7 downto 0);
--signal flash_data : std_logic_vector(7 downto 0);
--signal init_data : std_logic_vector(7 downto 0);
--signal romaddr : std_logic_vector(6 downto 0);
--
--signal dib : std_logic_vector(7 downto 0);
--
----signal init_done_i : std_logic;
--signal addrb : std_logic_vector(9 downto 0);
--signal web : std_logic;

signal D0 : std_logic_vector(15 downto 0);
signal D1 : std_logic_vector(15 downto 0);
signal D2 : std_logic_vector(15 downto 0);
signal D3 : std_logic_vector(15 downto 0);

signal D01 : std_logic_vector(15 downto 0);
signal D23 : std_logic_vector(15 downto 0);


signal WEs : std_logic_vector(7 downto 0);
signal WDATA : std_logic_vector(15 downto 0);

begin

	D   <= D01 when A(9)='0' else D23;
	D01 <= D0 when A(8)='0' else D1;
	D23 <= D2 when A(8)='0' else D3;

	
	
	WEs(0) <= '0';
	WEs(1) <= '0';
	WEs(2) <= WE and not WA(10) and     WA(9) and not WA(0);
	WEs(3) <= WE and not WA(10) and     WA(9) and     WA(0);
	WEs(4) <= WE and     WA(10) and not WA(9) and not WA(0);
	WEs(5) <= WE and     WA(10) and not WA(9) and     WA(0);
	WEs(6) <= WE and     WA(10) and     WA(9) and not WA(0);
	WEs(7) <= WE and     WA(10) and     WA(9) and     WA(0);
	
	
	--
	WDATA(15 downto 8) <= WDI;
	WDATA(7 downto 0)  <= WDI;
	

-- insert SB RAM's here

	RAM0: SBRAM PORT MAP (RDATA => D0, WE0 => WEs(0), WE1 => WEs(1), RCLK => clk, RADDR => A(7 downto 0), WCLK => clk, WADDR => WA(8 downto 1), WDATA => WDATA);
	RAM1: SBRAM PORT MAP (RDATA => D1, WE0 => WEs(2), WE1 => WEs(3), RCLK => clk, RADDR => A(7 downto 0), WCLK => clk, WADDR => WA(8 downto 1), WDATA => WDATA);
	RAM2: SBRAM PORT MAP (RDATA => D2, WE0 => WEs(4), WE1 => WEs(5), RCLK => clk, RADDR => A(7 downto 0), WCLK => clk, WADDR => WA(8 downto 1), WDATA => WDATA);
	RAM3: SBRAM PORT MAP (RDATA => D3, WE0 => WEs(6), WE1 => WEs(7), RCLK => clk, RADDR => A(7 downto 0), WCLK => clk, WADDR => WA(8 downto 1), WDATA => WDATA);




end Behavioral;

