library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fase1_Demo is
	port( CLOCK_50 : in 	std_logic;			SW			: in std_logic_vector(17 downto 0);
			LEDG		: out std_logic_vector(3 downto 0);
			HEX0		: out std_logic_vector(6 downto 0);
			HEX1		: out std_logic_vector(6 downto 0);
			HEX2		: out std_logic_vector(6 downto 0);
			HEX3		: out std_logic_vector(6 downto 0));
end Fase1_Demo;

architecture Shell of Fase1_Demo is
	signal s_count: std_logic_vector(15 downto 0);
	signal s_clock: std_logic;
	signal s_pulse: std_logic;
	signal s_countP:std_logic_vector(2 downto 0);
	signal s_novoP: std_logic;
	signal s_decOut: std_logic_vector(4 downto 0);
begin
	
	debouncer:		entity work.DebounceUnit(Behavioral)
						generic map (inPolarity => '1')
						port map(refClk => CLOCK_50,
									dirtyIn => SW(17),
									pulsedOut => s_pulse);
									
	
	ContadorPeriodos: entity work.CounterPeriodos(Behavioral)
							port map(enable => SW(0),
										period => s_pulse,
										countIn => s_count,
										countPeriodos => s_countP,
										novoPeriodo => s_novoP);
	
	
	ContadorTemPo: 	entity work.CounterDown(behav)
						port map(clk => s_clock, 
									reset => s_novoP,
									enable => SW(0),
									dataIn => SW(16 downto 1),
									count => s_count);
	
	clkDivider:		entity work.ClkDividerN(Behavioral)
						generic map (divFactor => 500000)
						port map( clkIn => CLOCK_50,
									 clkOut => s_clock);
	
	DIG1:				entity work.Bin7SegDecoder(Behavioral)
						port map( enable => '1',
									 binInput => s_count(15 downto 12),
									 decOut_n => HEX3(6 downto 0));
	
	DIG2:				entity work.Bin7SegDecoder(Behavioral)
						port map( enable => '1',
									 binInput => s_count(11 downto 8),
									 decOut_n => HEX2(6 downto 0));
									 
	DIG3:				entity work.Bin7SegDecoder(Behavioral)
						port map( enable => '1',
									 binInput => s_count(7 downto 4),
									 decOut_n => HEX1(6 downto 0));
									 
	DIG4:				entity work.Bin7SegDecoder(Behavioral)
						port map( enable => '1',
									 binInput => s_count(3 downto 0),
									 decOut_n => HEX0(6 downto 0));
									 
	BIN3BITS2BCD:	entity work.bin2digit4(Behavioral)
						port map( binInput => s_countP,
									 enable => '1',
									 decOut_n => s_decOut);
									 
	LEDG(3 downto 0) <= s_decOut(3 downto 0);
										
end Shell;