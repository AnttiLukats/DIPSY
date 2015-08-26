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
		when 000000 => D <= "1100000000000110";	-- 0x0000
		when 000001 => D <= "1110000001001010";	-- 0x0002
		when 000002 => D <= "1001010101011010";	-- 0x0004
		when 000003 => D <= "1111011111110001";	-- 0x0006
		when 000004 => D <= "1001010101001010";	-- 0x0008
		when 000005 => D <= "1111011111100001";	-- 0x000A
		when 000006 => D <= "1001010100001000";	-- 0x000C
		when 000007 => D <= "1001101000101000";	-- 0x000E
		when 000008 => D <= "1101111111111000";	-- 0x0010
		when 000009 => D <= "1001100000101000";	-- 0x0012
		when 000010 => D <= "1101111111110110";	-- 0x0014
		when 000011 => D <= "1001101000110000";	-- 0x0016
		when 000012 => D <= "1101111111110100";	-- 0x0018
		when 000013 => D <= "1001100000110000";	-- 0x001A
		when 000014 => D <= "1101111111110010";	-- 0x001C
		when 000015 => D <= "1001101000111000";	-- 0x001E
		when 000016 => D <= "1101111111110000";	-- 0x0020
		when 000017 => D <= "1001100000111000";	-- 0x0022
		when 000018 => D <= "1101111111101110";	-- 0x0024
		when 000019 => D <= "1100111111110011";	-- 0x0026
		when others => D <= "----------------";
		end case;
	end process;
end;
