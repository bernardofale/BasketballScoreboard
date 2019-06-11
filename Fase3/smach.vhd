library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity smach is
	port(reset		: in  std_logic;
		  clk			: in  std_logic;
		  count, countFinished, novoPeriodo		: in  std_logic;
		  falt		: out std_logic;
		  pont		: out std_logic;
		  periodo	: out std_logic;
		  temporizador	: out std_logic;
		  resetOut, loadOut: out std_logic);
end smach;

architecture Behavioral of smach is
	type TState is (defTime, started, stopped);
	signal s_currentState, s_nextState : TState;
	signal s_reset: std_logic;
begin
	sync_proc : process(clk)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				s_reset <= '1';
				s_currentState <= defTime;
			else
				s_reset <= '0';
				s_currentState <= s_nextState;
			end if;
		end if;
	end process;

	comb_proc : process(s_currentState, count)
	begin
		case (s_currentState) is
		when defTime =>
			loadOut <= '1';
			falt <= '0';
			pont <= '0';
			periodo <= '1';
			temporizador <= '0';
			
						
			if (count = '1') and (novoPeriodo = '1') then
				s_nextState <= started;
			else
				s_nextState <= deftime;
			end if;

		when started =>
			loadOut <= '0';
			falt <= '0';
			pont <= '1';
			periodo <= '0';
			temporizador <= '1';
			
			
			
			if (count = '0') and (countFinished = '0') then
				s_nextState <= stopped;
			elsif (countFinished = '1') then 
				s_nextState <= defTime;
			else
				s_nextState <= started;
			end if;

		when stopped =>
			loadOut <= '0';
			falt <= '1';
			pont <= '0';
			periodo <= '0';
			temporizador <= '0';
			
			
			if (count = '1') then
				s_nextState <= started;
			else	
				s_nextState <= stopped;
			end if;
			
		end case;

	end process;
	resetOut <= s_reset;
end Behavioral;