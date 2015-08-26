--
--  
-- changed PLL, sysclock not passing it
-- changed bitio to use TDI-TDO-TCK


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


use work.AX_Pack.all;
use work.config.all;

entity STAMPSB is
	generic(
		SyncReset : boolean := true
		--TriState : boolean := false
	);

	port(
		RGB0		: out std_logic;
		RGB1		: out std_logic;
		RGB2		: out std_logic

--		nRST		: in std_logic;
--		Clk		: in std_logic;

		--GP		: inout std_logic_vector(4 downto 0)
	);
end STAMPSB;

architecture rtl of STAMPSB is


COMPONENT  SB_RGBA_DRV  
Generic 
(
  		CURRENT_MODE :string := "0b0";
 		RGB0_CURRENT :string := "0b000001";
 		RGB1_CURRENT :string := "0b000001";
 		RGB2_CURRENT :string := "0b000001"
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


component SB_LFOSC  is 
	port	(
		CLKLF : out std_logic;
		CLKLFEN  :in std_logic;
		CLKLFPU : in std_logic
		);
end component;



	constant	ROMAddressWidth		: integer := 9;
	constant	RAMAddressWidth		: integer := 0;
	constant	BigISet			: boolean := false;

	component ROM1200
		port(
			Clk	: in std_logic;
			A	: in std_logic_vector(ROMAddressWidth - 1 downto 0);
			D	: out std_logic_vector(15 downto 0)
		);
	end component;

	COMPONENT X_CLK_INT
	PORT(
		I : IN std_logic;          
		O : OUT std_logic
		);
	END COMPONENT;


	COMPONENT PORESET
	PORT(
		SYSRST : IN std_logic;
		CLK : IN std_logic;          
		RST : OUT std_logic
		);
	END COMPONENT;

	COMPONENT nco_8bit
	PORT(
		RST : IN std_logic;
		CLKIN : IN std_logic;
		--	COUT : out STD_LOGIC_VECTOR (7 downto 0);		
		N : IN std_logic_vector(7 downto 0);          
		CLKOUT : OUT std_logic
		);
	END COMPONENT;

	COMPONENT romram
	PORT(
		clk : IN std_logic;
		A : IN std_logic_vector(9 downto 0);
		WA : IN std_logic_vector(10 downto 0);
		WDO : OUT std_logic_vector(7 downto 0);
		WDI : IN std_logic_vector(7 downto 0);
		WE : IN std_logic;
		COUT : IN std_logic_vector(8 downto 0);
		init_clk : IN std_logic;
		init_req : IN std_logic;          
		D : OUT std_logic_vector(15 downto 0);
		init_done :IN std_logic
		);
	END COMPONENT;
	
	COMPONENT mux32
	PORT(
		DI : IN std_logic_vector(31 downto 0);
		SEL : IN std_logic_vector(4 downto 0);          
		DO : OUT std_logic
		);
	END COMPONENT;	
	
	COMPONENT DEC32
	PORT(
		ADDR : IN std_logic_vector(4 downto 0);
		EN1 : IN std_logic;
		EN2_N : IN std_logic;          
		SEL : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	
	signal	Reset_s_n	: std_logic;
	signal	Reset_s_n_i	: std_logic;
	signal	ROM_Addr	: std_logic_vector(ROMAddressWidth - 1 downto 0);
	signal	ROM_Data	: std_logic_vector(15 downto 0);
	signal	SREG		: std_logic_vector(7 downto 0);
	signal	IO_Rd		: std_logic;
	signal	IO_Wr		: std_logic;
	signal	IO_Wr_HR		: std_logic;	
	signal	IO_Addr		: std_logic_vector(5 downto 0);
	signal	IO_WData	: std_logic_vector(7 downto 0);
	signal	IO_RData	: std_logic_vector(7 downto 0);
--	signal	TCCR_Sel	: std_logic;
--	signal	TCNT_Sel	: std_logic;
--	signal	PORTB_Sel	: std_logic;
--	signal	DDRB_Sel	: std_logic;
--	signal	PINB_Sel	: std_logic;
--	signal	PORTD_Sel	: std_logic;
--	signal	DDRD_Sel	: std_logic;
--	signal	PIND_Sel	: std_logic;
--	signal	Sleep_En	: std_logic;
--	signal	ISC0		: std_logic_vector(1 downto 0);
--	signal	Int0_ET		: std_logic;
--	signal	Int0_En		: std_logic;
--	signal	Int0_r		: std_logic_vector(1 downto 0);
--	signal	TC_Trig		: std_logic;
	signal	TOIE0		: std_logic;
	signal	TOV0		: std_logic;
	signal	Int_Trig	: std_logic_vector(15 downto 1);
	signal	Int_Acc		: std_logic_vector(15 downto 1);
--	signal	TCCR		: std_logic_vector(2 downto 0);
--	signal	TCNT		: std_logic_vector(7 downto 0);
	
	signal	Z	: std_logic_vector(15 downto 0);	
	signal	ram_datain		:  std_logic_vector(7 downto 0);
	signal	ram_write		:  std_logic;	
--	signal	DirB		: std_logic_vector(7 downto 0);
--	signal	Port_InB	: std_logic_vector(7 downto 0);
--	signal	Port_OutB	: std_logic_vector(7 downto 0);
--	signal	DirD		: std_logic_vector(7 downto 0);
--	signal	Port_InD	: std_logic_vector(7 downto 0);
--	signal	Port_OutD	: std_logic_vector(7 downto 0);


	signal	GP_O	: std_logic_vector(31 downto 0) := X"00000000";
	signal	GP_OX	: std_logic_vector(31 downto 0);
	signal	GP_OA	: std_logic_vector(31 downto 0);
	signal	GP_T	: std_logic_vector(31 downto 0) := X"00000000";
	signal	GP_TX	: std_logic_vector(31 downto 0);
	
	signal	SEL32	: std_logic_vector(31 downto 0);
	signal	DI32	: std_logic_vector(31 downto 0);
	signal   ASIO_RDBIT : std_logic;
	
	
	signal pre_reset_n : std_logic;
--	signal init_req : std_logic;
	signal init_done : std_logic;
	
	signal clk: std_logic;

	signal clknco: std_logic;
	signal NCO	: std_logic_vector(7 downto 0);
	signal NCO_real	: std_logic_vector(7 downto 0);

   signal DIRIN: std_logic;
   signal FLAG: std_logic;

	signal CR1	: std_logic_vector(7 downto 0);
	signal CR2	: std_logic_vector(7 downto 0);
	signal CR3	: std_logic_vector(7 downto 0);
	signal CR4	: std_logic_vector(7 downto 0);

   signal OSCIO1EN: std_logic; -- one pin oscillator enable
   signal OSCIO2EN: std_logic;	

   signal OSC1EN: std_logic; -- two pin oscillator enable	
   signal OSC1SEL: std_logic;	
   signal OSC2EN: std_logic;	
   signal CR_INV: std_logic;	-- inversion

	
   signal SDOUT: std_logic;	
 
   signal tick	: std_logic_vector(1 downto 0);
	signal COUT	: std_logic_vector(8 downto 0);
	
	signal UTDI: std_logic;	
	signal UTDO: std_logic;	
	signal UDRCK: std_logic;	
   signal GLA : std_logic;	
   signal GLB : std_logic;	
   signal GLC : std_logic;	

	signal IO_Upd: std_logic;	
	signal IO_T : std_logic;	
	signal IO_O : std_logic;	

	signal HALTED : std_logic;	

	signal SCK_S : std_logic := '0';	


	signal Reset_n  : std_logic := '1';	

begin

--	Inst_nco_8bit: nco_8bit PORT MAP( RST => '0', CLKIN => Clkin, CLKOUT => clknco, N => NCO_real);
--	NCO_real <= NCO; -- when init_done='1' else "00000000";
	--NCO_real <= "10000000";

--	Inst_X_CLK_INT: X_CLK_INT PORT MAP(
--		I => clknco,
--		--I => clkin,
--		O => clk
--	);


--	Inst_X_CLK_INT_RES: X_CLK_INT PORT MAP(
--		I => Reset_s_n_i,
--		O => Reset_s_n
--	);


LF: SB_LFOSC 	port map (		CLKLF => Clk,		CLKLFEN  => '1',		CLKLFPU => '1'	);



	--Inst_PORESET: PORESET PORT MAP(
	--	SYSRST => Reset_n,
	--	RST => pre_reset_n,
	--	CLK => Clk
	--);

--	pre_reset_n <= '1';

	Reset_s_n <= '1'; -- nRST;



   IO_Wr_HR <= '1' when IO_Wr = '1' and IO_Addr(5)='1' else '0';
	
	-- Registers/Interrupts
	process (Reset_s_n, Clk)
	begin
		if Reset_s_n = '0' then
			--Sleep_En <= '0';
			--ISC0 <= "00";
			--Int0_ET <= '0';
			--Int0_En <= '0';
			--Int0_r <= "11";
			TOIE0 <= '0';
			TOV0 <= '0';
			NCO <= "00001000"; -- fastest
			CR1 <= "00000000";
			CR2 <= "00000000";
			CR3 <= "00000000";
			CR4 <= X"00";
		elsif Clk'event and Clk = '1' then
		   tick(0) <= COUT(5);
			tick(1) <= tick(0);
			
--			Int0_r(0) <= INT0;
--			Int0_r(1) <= Int0_r(0);
--			if IO_Wr = '1' and IO_Addr = "110101" then	-- $35 MCUCR
--				Sleep_En <= IO_WData(5);
--				ISC0 <= IO_WData(1 downto 0);
--			end if;
--			if IO_Wr = '1' and IO_Addr = "111011" then	-- $3B GIMSK
--				Int0_En <= IO_WData(6);
--			end if;
			if IO_Wr = '1' and IO_Addr = "111001" then	-- $39 TIMSK
				TOIE0 <= IO_WData(0);
			end if;
--			if IO_Wr = '1' and IO_Addr = "111000" then	-- $38 TIFR
--				if IO_WData(1) = '1' then
--					TOV0 <= '0';
--				end if;
--			end if;

			if IO_Wr_HR = '1' and IO_Addr(4 downto 0) = "00000" then	-- 10 0000 0x20
					NCO <= IO_WData;
			end if;	
			-- Control Register
			if IO_Wr_HR = '1' and IO_Addr(4 downto 0) = "01000" then	-- 10 1000 0x28
					CR1 <= IO_WData;
			end if;	
			
			if IO_Wr_HR = '1' and IO_Addr(4 downto 0) = "01001" then	-- 10 1000 0x29
					CR2 <= IO_WData;
			end if;	

			if IO_Wr_HR = '1' and IO_Addr(4 downto 0) = "01010" then	-- 10 1000 0x2a
					CR3 <= IO_WData;
			end if;	

			if IO_Wr_HR = '1' and IO_Addr(4 downto 0) = "01011" then	-- 10 1000 0x2b
					CR4 <= IO_WData;
			end if;	

			if Int_Acc(1) = '1' then
				TOV0 <= '0';
			end if;

--			if TC_Trig = '1' then
--				TOV0 <= '1';
--			end if;

			if tick(0)='1' and tick(1)='0' then
				TOV0 <= '1';
			end if;			
			
--			if Int_Acc(1) = '1' then
--				Int0_ET <= '0';
--			end if;
--			if (ISC0 = "10" and Int0_r = "10") or (ISC0 = "11" and Int0_r = "01") then
--				Int0_ET <= '1';
--			end if;
		end if;
	end process;

	--Int_Trig(1) <= '0'; -- when Int0_En = '0' else not Int0_r(1) when ISC0 = "00" else Int0_ET;
	Int_Trig(1) <= '1' when TOIE0 = '1' and TOV0 = '1' else '0';
	Int_Trig(15 downto 2) <= (others => '0');

	rom : ROM1200 port map (
			Clk => Clk,
			A => ROM_Addr(8 downto 0),
			D => ROM_Data);

--	rom: romram PORT MAP(
--		clk => Clk,
--		A => ROM_Addr,
--		D => ROM_Data,
--		COUT => COUT,
--		WA => Z(10 downto 0), -- Z
--		WDO => ram_datain,
--		WDI => IO_WData,
--		WE => ram_write,
--		init_clk => Clk,
--		init_req => '0',
--		init_done => init_done
--	);



	ax : AX8
		generic map(
			ROMAddressWidth => ROMAddressWidth,
			RAMAddressWidth => RAMAddressWidth,
			BigIset => BigIset)
		port map (
			Clk => Clk,
			Reset_n => Reset_s_n,
			--HALTED => HALTED,
			ROM_Addr => ROM_Addr,
			ROM_Data => ROM_Data,
			Sleep_En => '0',
			FLAG => FLAG,
			Int_Trig => Int_Trig,
			Int_Acc => Int_Acc,
			SREG => SREG,
			ZZ => Z,
			ram_datain => ram_datain,
			ram_write => ram_write,
			IO_Rd => IO_Rd,
			IO_Wr => IO_Wr,
			IO_Addr => IO_Addr,
			IO_RData => IO_RData,
			IO_WData => IO_WData);


--		with IO_Addr select
--			IO_RData <= SREG when "111111",
--				"0000000" & ASIO_RDBIT when others;
		IO_RData <= 
			("0000000" & ASIO_RDBIT) when	IO_Addr(5)='0' else
			SREG;
				
				

           GP_TX(4 downto 0)   <= GP_T(4 downto 0);
           GP_OX(4 downto 0)   <= GP_O(4 downto 0);

				
	--
	
	Inst_mux32: mux32 PORT MAP(
		DI => DI32,
		SEL => IO_Addr(4 downto 0),
		DO => ASIO_RDBIT
	);

   
	FLAG <= DIRIN;

	Inst_mux32d: mux32 PORT MAP(
		DI => DI32,
		SEL => CR4(4 downto 0),
		DO => DIRIN
	);

	Inst_DEC32: DEC32 PORT MAP(
		ADDR  => IO_Addr(4 downto 0),
		SEL   => SEL32,
		EN1   => '1', --IO_Wr,
		EN2_N => IO_Addr(5)
	);

	-- generate IOs!
	IO_Upd <= IO_Rd or IO_Wr;
	IO_T <= '1' when IO_Wr='1' else '0';
	IO_O <= IO_WData(0) when IO_Wr='1' else '0';
	
FFs : for I in 0 to 7 generate
	begin
			process (Clk)
			begin
				--if Reset_n = '0' then
				--	GP_T(I) <= '
				--els
				if Clk'event and Clk = '1' then
					if SEL32(I)='1' then
						if IO_Upd='1' then
							GP_O(I) <= IO_O;
							GP_T(I) <= IO_T;
						end if;
					end if;
				end if;
			end process;
			--
	end generate FFs;



   CR_INV    <= CR2(2);
	


--	DI32(4 downto 0) <= GP(4 downto 0);

--IOs : for I in CFG_FIRST_IO to CFG_LAST_IO generate
--	begin
--		GP(I) <= GP_OX(I) when GP_TX(I)='1' else 'Z';
--	end generate IOs;




--	LED  <= GP_O(31);

RGBA:  SB_RGBA_DRV  
	generic map (
  		CURRENT_MODE  => "0b0",
 		RGB0_CURRENT  => "0b000001",
 		RGB1_CURRENT  => "0b000001",
 		RGB2_CURRENT  => "0b000001"

	)
	port map (
		CURREN => '1',
		RGB0PWM => GP_O(5),
		RGB1PWM => GP_O(6),
		RGB2PWM => GP_O(7),
		RGBLEDEN => '1',
		RGB0 => RGB0,
		RGB1 => RGB1,
		RGB2 => RGB2
	);	 



end;
