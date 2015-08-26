-- This file was generated with hex2rom written by Daniel Wallner

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom1200 is
	port(
		Clk	: in std_logic;
		A	: in std_logic_vector(8 downto 0);
		D	: out std_logic_vector(15 downto 0)
	);
end rom1200;

architecture rtl of rom1200 is
	signal A_r : std_logic_vector(8 downto 0);
begin
	process (Clk)
	begin
		if Clk'event and Clk = '1' then
			A_r <= A;
		end if;
	end process;
	process (A_r)
	begin
		case to_integer(unsigned(A_r)) is
		when 000000 => D <= "1001101100000000";	-- 0x0000
		when 000001 => D <= "1100000000000010";	-- 0x0002
		when 000002 => D <= "1001101011111000";	-- 0x0004
		when 000003 => D <= "1100000000000001";	-- 0x0006
		when 000004 => D <= "1001100011111000";	-- 0x0008
		when 000005 => D <= "1001101000001000";	-- 0x000A
		when 000006 => D <= "0000000000000000";	-- 0x000C
		when 000007 => D <= "0000000000000000";	-- 0x000E
		when 000008 => D <= "1001100000001000";	-- 0x0010
		when 000009 => D <= "1100111111110110";	-- 0x0012
		when others => D <= "0000000000000000";
		end case;
	end process;
end;
