library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is Port ( 
        CLKOUT    : out  STD_LOGIC;
        CLK     : in  STD_LOGIC);
end divider;

architecture Behavioral of divider is

signal CNT : STD_LOGIC_VECTOR(15 downto 0) := X"0000";

begin
	CLKOUT <= CNT(13);

	process (CLK)
	begin
	if (CLK'event and CLK='1') then
			CNT<=CNT+X"0001";
	end if;
	end process;

end Behavioral;

