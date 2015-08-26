----------------------------------------------------------------------------------
-- DIPSY very very first TEST ever made.
-- No constraint file needed!!
-- it uses HARD IP with fixed pin mapping
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity top is Port ( 
           RGB0  : out  STD_LOGIC
	   );
end top;

architecture Behavioral of top is

component SB_LFOSC  is 
	port	(
		CLKLF : out std_logic;
		CLKLFEN  :in std_logic;
		CLKLFPU : in std_logic
		);
end component;

COMPONENT  SB_RGBA_DRV  
Generic 
(
  	 CURRENT_MODE :string := "0b0";
 	 RGB0_CURRENT :string := "0b000001";
 	 RGB1_CURRENT :string := "0b000000";
 	 RGB2_CURRENT :string := "0b000000"
);
port (
         CURREN : in std_logic;
	 RGB0PWM : in std_logic;
	 RGB1PWM : in std_logic;
	 RGB2PWM : in std_logic;
	 RGBLEDEN : in std_logic;
         RGB0 : out std_logic;
	 RGB1 : out std_logic;
	 RGB2 : out std_logic
	);	 
END COMPONENT;

component divider is Port ( 
        CLKOUT    : out  STD_LOGIC;
        CLK     : in  STD_LOGIC);
end component;


signal clk: std_logic;
signal LED: std_logic;

signal cnt: std_logic_vector(31 downto 0);

begin

LF: SB_LFOSC 
	port map (
		CLKLF => clk,
		CLKLFEN  => '1',
		CLKLFPU => '1'
	);


RGBA:  SB_RGBA_DRV  
	port map (
		CURREN => '1',
		RGB0PWM => LED,
		RGB1PWM => '0',
		RGB2PWM => '0',
		RGBLEDEN => '1',
		RGB0 => RGB0,
		RGB1 => open,
		RGB2 => open
	);	 

--	LED <= cnt(17);
--process(clk)
--begin
--	if (rising_edge(clk)) then
--		cnt <= cnt + X"00000001";
--	end if;
--end process;

	Inst_DIV: divider PORT MAP(
		CLK   => clk,
		CLKOUT => LED
	);



end Behavioral;

