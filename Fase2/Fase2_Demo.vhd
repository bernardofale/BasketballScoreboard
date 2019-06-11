library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fase2_Demo is
	port( CLOCK_50 : in 	std_logic;
			KEY		: in  std_logic_vector(3 downto 0);			SW			: in  std_logic_vector(17 downto 0);
			LEDG		: out std_logic_vector(3 downto 0);
			LEDR		: out std_logic_vector(17 downto 0);
			HEX0		: out std_logic_vector(6 downto 0);
			HEX1		: out std_logic_vector(6 downto 0);
			HEX2		: out std_logic_vector(6 downto 0);
			HEX3		: out std_logic_vector(6 downto 0);
			HEX4		: out std_logic_vector(6 downto 0);
			HEX5		: out std_logic_vector(6 downto 0);
			HEX6		: out std_logic_vector(6 downto 0);
			HEX7		: out std_logic_vector(6 downto 0));
end Fase2_Demo;

architecture Shell of Fase2_Demo is
	signal s_count: std_logic_vector(15 downto 0);
	signal s_clock, s_pulse: std_logic;
	signal s_countP:std_logic_vector(2 downto 0);
	signal s_novoP: std_logic;
	signal s_decOut: std_logic_vector(4 downto 0);
	signal s_pontos_bin7seg_equipa1_bit0, s_pontos_bin7seg_equipa1_bit1, s_pontos_bin7seg_equipa2_bit0, s_pontos_bin7seg_equipa2_bit1: std_logic_vector(3 downto 0);
	signal s_bin2bcd_equipa1, s_bin2bcd_equipa2: std_logic_vector(7 downto 0);
	signal s_contPont_equipa1, s_contPont_equipa2: std_logic;
	signal s_bin2digit4_equipa1, s_bin2digit4_equipa2: std_logic_vector(2 downto 0);
	signal s_contFalt_equipa1, s_contFalt_equipa2: std_logic;
begin
									
	debouncerContadorPeriodos:		entity work.DebounceUnit(Behavioral)
											generic map(inPolarity => '1')
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
									dataIn => "0001000000000000",
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
	
	
	
	-- FASE 2 --
	
	-- CONTADOR PONTOS --
	debouncerPontosEquipa1: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(0),
												-- output
												pulsedOut => s_contPont_equipa1);
	
	debouncerPontosEquipa2: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(1),
												-- output
												pulsedOut => s_contPont_equipa2);
	
	contadorPontosEquipa1:  entity work.contPont(Behavioral)
									port map(clk => CLOCK_50,
												pont => s_contPont_equipa1,
												reset => '0',													-- TODO: mudar reset para um switch (mudar dataIn do contador main para libertar espaço)
												-- output														
												count => s_bin2bcd_equipa1);								
												
	contadorPontosEquipa2:  entity work.contPont(Behavioral)
									port map(clk => CLOCK_50,
												pont => s_contPont_equipa2,
												reset => '0',													-- TODO: mudar reset para um switch (mudar dataIn do contador main para libertar espaço)
												-- output
												count => s_bin2bcd_equipa2);
	-- saidas contador									
	bin2bcdEquipa1: 			entity work.bin2bcd(Behavioral)
									port map(inp8bit => s_bin2bcd_equipa1,
												-- outputs
												bcd0 => s_pontos_bin7seg_equipa1_bit0,
												bcd1 => s_pontos_bin7seg_equipa1_bit1);
	
	bin2bcdEquipa2: 			entity work.bin2bcd(Behavioral)
									port map(inp8bit => s_bin2bcd_equipa2,
												-- outputs
												bcd0 => s_pontos_bin7seg_equipa2_bit0,
												bcd1 => s_pontos_bin7seg_equipa2_bit1);
												
	bin7segEquipa1_bit0: 	entity work.bin7SegDecoder(Behavioral)
									port map(binInput => s_pontos_bin7seg_equipa1_bit0,
												enable => '1',
												decOut_n => HEX4(6 downto 0));
	
	bin7segEquipa1_bit1: 	entity work.bin7SegDecoder(Behavioral)
									port map(binInput => s_pontos_bin7seg_equipa1_bit1,
												enable => '1',
												decOut_n => HEX5(6 downto 0));
												
	bin7segEquipa2_bit0: 	entity work.bin7SegDecoder(Behavioral)
									port map(binInput => s_pontos_bin7seg_equipa2_bit0,
												enable => '1',
												decOut_n => HEX6(6 downto 0));
	bin7segEquipa2_bit1: 	entity work.bin7SegDecoder(Behavioral)
									port map(binInput => s_pontos_bin7seg_equipa2_bit1,
												enable => '1',
												decOut_n => HEX7(6 downto 0));
	
	
	
	-- FIM CONTADOR PONTOS -- TUDO A FUNCIONAR ^^ --
	
	-- CONTADOR DE FALTAS --
	debouncerFaltasEquipa1: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(2),
												-- output
												pulsedOut => s_contFalt_equipa1);
												
	debouncerFaltasEquipa2: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(3),
												-- output
												pulsedOut => s_contFalt_equipa2);
												
	contadorFaltasEquipa1:  entity work.contFalt(Behavioral)
									port map(clk => CLOCK_50,
												ap => s_contFalt_equipa1,
												reset => '0',													-- TODO: mudar reset para um switch (mudar dataIn do contador main para libertar espaço)
												-- Output
												faltas => s_bin2digit4_equipa1);
	
	contadorFaltasEquipa2:  entity work.contFalt(Behavioral)
									port map(clk => CLOCK_50,
												ap => s_contFalt_equipa2,
												reset => '0',													-- TODO: mudar reset para um switch (mudar dataIn do contador main para libertar espaço)
												-- Output
												faltas => s_bin2digit4_equipa2);
												
	bin2digit4Equipa1: 		entity work.bin2digit4(Behavioral)
									port map(binInput => s_bin2digit4_equipa1,
												enable => '1',
												-- Output
												decOut_n => LEDR(4 downto 0));
	
	bin2digit4Equipa2: 		entity work.bin2digit4esq(Behavioral)
									port map(binInput => s_bin2digit4_equipa2,
												enable => '1',
												-- Output
												decOut_n => LEDR(17 downto 13));
	LEDR(12 downto 5) <= "00000000";
	-- FIM CONTADOR DE FALTAS -- 
									
									
end Shell;