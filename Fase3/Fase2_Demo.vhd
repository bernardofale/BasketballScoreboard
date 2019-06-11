library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fase2_Demo is
	port( CLOCK_50 : in 	std_logic;
			KEY		: in  std_logic_vector(3 downto 0);
			SW			: in  std_logic_vector(17 downto 0);
			LEDG		: out std_logic_vector(4 downto 0);
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
	signal s_falt, s_pont, s_period, s_temporizador : std_logic;
	signal s_resOut : std_logic;
	signal s_enable, s_enable1 : std_logic;
	signal d_dOut, d_dOut1: std_logic_vector(3 downto 0);
	signal s_add, s_sub, s_go0 : std_logic;
	signal s_add1, s_sub1, s_go1 : std_logic;
	signal s_add_debounced, s_sub_debounced, s_go0_debounced : std_logic;
	signal s_add1_debounced, s_sub1_debounced, s_go1_debounced : std_logic;
	
	signal s_enable_faltas, s_enable1_faltas : std_logic;
	signal d_dOut_faltas, d_dOut1_faltas: std_logic_vector(3 downto 0);
	signal s_add_faltas, s_sub_faltas, s_go0_faltas : std_logic;
	signal s_add1_faltas, s_sub1_faltas, s_go1_faltas : std_logic;
	signal s_add_faltas_debounced, s_sub_faltas_debounced, s_go0_faltas_debounced : std_logic;
	signal s_add1_faltas_debounced, s_sub1_faltas_debounced, s_go1_faltas_debounced : std_logic;
	
	signal s_loadOut, s_countFinished : std_logic;
begin
									
	debouncerContadorPeriodos:		entity work.DebounceUnit(Behavioral)
											generic map(inPolarity => '1')
											port map(refClk => CLOCK_50,
														dirtyIn => SW(17),
														pulsedOut => s_pulse);
									
	ContadorPeriodos: entity work.CounterPeriodos(Behavioral)
							port map(--reset => '0',
										enable => s_period and SW(1) and not Sw(0),
										period => s_pulse,
										countIn => s_count,
										countPeriodos => s_countP,
										--countFinished => s_countFinished,
										novoPeriodo => s_novoP);
	
	
	ContadorTempo: 	entity work.CounterDown(behav)
						port map(clk => s_clock,
									load => s_loadOut,
									reset => s_novoP or s_resOut,
									enable => s_temporizador,
									dataIn => SW(9 downto 2),
									countFinished => s_countFinished,
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
									 decOut_n => LEDG(4 downto 0));
									 
	--LEDG(4 downto 0) <= s_decOut;
	
	
	
	-- FASE 2 --
	
	-- CONTADOR PONTOS --
	debouncerPontosEquipa1: entity work.DebounceUnitTest(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(0),
												-- output
												pulsedOut => s_contPont_equipa1);
	
	debouncerPontosEquipa2: entity work.DebounceUnitTest(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(1),
												-- output
												pulsedOut => s_contPont_equipa2);
	
	clockGenerator: 			entity work.clk_enable(behav)
									port map(clkIn => CLOCK_50,
												clkOut => s_enable );
	
	clockGenerator2 :			entity work.clk_enable(behav)
									generic map( k => 49999999)
									port map(clkIn => CLOCK_50,
												clkOut => s_enable1);
	
	contadorSegundosEquipa1:entity work.contSeg(Behavioral) 
									port map(click => s_contPont_equipa1,
												clk => CLOCK_50,
												clk_enable => s_enable,
												dOut => d_dOut);
	contadorSegundosEquipa2:entity work.contSeg(Behavioral) 
									port map(click => s_contPont_equipa2,
												clk => CLOCK_50,
												clk_enable => s_enable,
												dOut => d_dOut1);
									
	deciderEquipa1: 			entity work.decider(behav)
									port map(click => s_contPont_equipa1,
												clk_enable => s_enable1,
												dIn => d_dOut,
												add => s_add,
												sub => s_sub,
												go0 => s_go0);
	
	deciderEquipa2: 			entity work.decider(behav)
									port map(click => s_contPont_equipa2,
												clk_enable => s_enable1,
												dIn => d_dOut1,
												add => s_add1,
												sub => s_sub1,
												go0 => s_go1);
												
	---------
	debouncerAdd1: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_add,
												-- output
												pulsedOut => s_add_debounced);
	
	debouncerAdd2: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_add1,
												-- output
												pulsedOut => s_add1_debounced);
												
												
	debouncerSub1: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_sub,
												-- output
												pulsedOut => s_sub_debounced);
	
	debouncerSub2: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_sub1,
												-- output
												pulsedOut => s_sub1_debounced);
												
	
	debouncerZero1: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_go0,
												-- output
												pulsedOut => s_go0_debounced);
	
	debouncerZero2: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_go1,
												-- output
												pulsedOut => s_go1_debounced);
	---------
	
	contadorPontosEquipa1:  entity work.contPont(Behavioral)
									port map(enable => s_pont,
												clk => CLOCK_50,
												add => s_add_debounced,
												sub => s_sub_debounced,
												--go0 => s_go0_debounced,
												reset => s_resOut or s_go0_debounced,													
												-- output														
												count => s_bin2bcd_equipa1);								
												
	contadorPontosEquipa2:  entity work.contPont(Behavioral)
									port map(enable => s_pont,
												clk => CLOCK_50,
												add => s_add1_debounced,
												sub => s_sub1_debounced,
												-- go0 => s_go1_debounced,
												reset => s_resOut or s_go1_debounced,													
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
	debouncerFaltasEquipa1: entity work.DebounceUnitTest(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(2),
												-- output
												pulsedOut => s_contFalt_equipa1);
												
	debouncerFaltasEquipa2: entity work.DebounceUnitTest(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => KEY(3),
												-- output
												pulsedOut => s_contFalt_equipa2);
												
	clockGenerator_Faltas: 			entity work.clk_enable(behav)
											port map(clkIn => CLOCK_50,
														clkOut => s_enable_faltas );
			
	clockGenerator2_Faltas:			entity work.clk_enable(behav)
											generic map( k => 49999999)
											port map(clkIn => CLOCK_50,
														clkOut => s_enable1_faltas);											
	
	contadorSegundosEquipa1_Faltas:	entity work.contSeg(Behavioral) 
												port map(click => s_contFalt_equipa1,
															clk => CLOCK_50,
															clk_enable => s_enable_faltas,
															dOut => d_dOut_faltas);
															
	contadorSegundosEquipa2_Faltas:	entity work.contSeg(Behavioral) 
												port map(click => s_contFalt_equipa2,
															clk => CLOCK_50,
															clk_enable => s_enable_faltas,
															dOut => d_dOut1_faltas);
															
	deciderEquipa1_Faltas: 			entity work.decider(behav)
											port map(click => s_contFalt_equipa1,
														clk_enable => s_enable1_faltas,
														dIn => d_dOut_faltas,
														add => s_add_faltas,
														sub => s_sub_faltas,
														go0 => s_go0_faltas);
	
	deciderEquipa2_Faltas: 			entity work.decider(behav)
											port map(click => s_contFalt_equipa2,
														clk_enable => s_enable1_faltas,
														dIn => d_dOut1_faltas,
														add => s_add1_faltas,
														sub => s_sub1_faltas,
														go0 => s_go1_faltas);
														
	---------
	debouncerAdd1_Faltas: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_add_faltas,
												-- output
												pulsedOut => s_add_faltas_debounced);
	
	debouncerAdd2_Faltas: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_add1_faltas,
												-- output
												pulsedOut => s_add1_faltas_debounced);
												
												
	debouncerSub1_Faltas: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_sub_faltas,
												-- output
												pulsedOut => s_sub_faltas_debounced);
	
	debouncerSub2_Faltas: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_sub1_faltas,
												-- output
												pulsedOut => s_sub1_faltas_debounced);
												
	
	debouncerZero1_Faltas: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_go0_faltas,
												-- output
												pulsedOut => s_go0_faltas_debounced);
	
	debouncerZero2_Faltas: entity work.DebounceUnit(Behavioral)
									port map(refClk  => CLOCK_50,
												dirtyIn => s_go1_faltas,
												-- output
												pulsedOut => s_go1_faltas_debounced);
	---------
												
	contadorFaltasEquipa1:  entity work.contFalt(Behavioral)
									port map(enable => s_falt,
												clk => CLOCK_50,
												addFaltas => s_add_faltas_debounced,
												subFaltas => s_sub_faltas_debounced,
												resetFaltas => s_resOut or s_go0_faltas_debounced,													
												-- Output
												faltas => s_bin2digit4_equipa1);
	
	contadorFaltasEquipa2:  entity work.contFalt(Behavioral)
									port map(enable => s_falt,
												clk => CLOCK_50,
												addFaltas => s_add1_faltas_debounced,
												subFaltas => s_sub1_faltas_debounced,
												resetFaltas => s_resOut or s_go1_faltas_debounced,													
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
	
	LEDR(6 downto 5) <= "00";
	LEDR(12 downto 10) <= "000";	-- overlap unused LEDS
	-- FIM CONTADOR DE FALTAS -- 
									
									
	-- FASE 3--
	
	ControlUnit: 				entity work.smach(Behavioral)
									port map(clk => CLOCk_50,
												reset => SW(0),
												count => SW(1),
												novoPeriodo => s_pulse,
												falt => s_falt,
												pont => s_pont,
												countFinished => s_countFinished,
												periodo => s_period,
												temporizador => s_temporizador,
												resetOut => s_resOut,
												loadOut => s_loadOut);
end Shell;