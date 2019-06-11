library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CounterDown is
	port( enable, reset, clk, load: in std_logic;
			dataIn: in std_logic_vector(7 downto 0);
			count: out std_logic_vector(15 downto 0);
			countFinished: out std_logic);
end CounterDown;

architecture behav of CounterDown is
	signal s_count, s_start: unsigned(23 downto 0);
	signal s_finished: std_logic := '1';
begin
	process(dataIn)
	begin
		if (load = '1') then
			-- s_count <= s_start;
			if (dataIn = std_logic_vector(to_unsigned(0, 8)) ) then
				s_start(23 downto 20) <= X"1";
				s_start(19 downto 16)  <= X"0";
				s_start(15 downto 12)   <= X"0";
				s_start(11 downto 8)   <= X"0";
				s_start(7 downto 0) <= X"00";
			else
				s_start(23 downto 16) <= unsigned(dataIn);
				s_start(15 downto 0) <= x"0000";
			end if;
		end if;
	end process;

	process(clk)
	begin
		if (rising_edge(clk))	 then
			if (reset = '1') or (s_finished = '1') or (load = '1' and enable = '0') then
				s_count <= s_start;

				s_finished <= '0';
			--elsif (enable = '0') then 
			--	s_count <= s_count;

			elsif (enable = '1' and s_finished = '0') then

				if (s_count(3 downto 0) = X"0") then
					s_count(3 downto 0) <= X"9";
					
					if (s_count(7 downto 4) = X"0") then
						s_count(7 downto 4) <= X"9";
						
						if (s_count(11 downto 8)  = X"0") then
							s_count(11 downto 8)  <= X"9";
							
							if (s_count(15 downto 12) = X"0") then
								s_count(15 downto 12) <= X"5";
								
								if (s_count(19 downto 16) = X"0") then
									s_count(19 downto 16) <= X"9";
									
									if (s_count(23 downto 20) = X"0") then
										--s_count <= s_start;
										s_finished <= '1';
									else
										s_count(23 downto 20) <= s_count(23 downto 20) - 1;
										s_finished <= '0';	
									end if;
								else
									s_count(19 downto 16) <= s_count(19 downto 16) - 1;
									s_finished <= '0';
								end if;
								
								--s_count <= s_start;
								--s_finished <= '1';
							else
								s_count(15 downto 12) <= s_count(15 downto 12) - 1;
								s_finished <= '0';	
							end if;
						else
							s_count(11 downto 8)  <= s_count(11 downto 8)  - 1;
							s_finished <= '0';
						end if;
					else
						s_count(7 downto 4) <= s_count(7 downto 4) - 1;
						s_finished <= '0';
					end if;
				else
					s_count(3 downto 0) <= s_count(3 downto 0) - 1;
					s_finished <= '0';
				end if;
			end if;
		end if;
	end process;
	
	count <= std_logic_vector(s_count(23 downto 8)) when (s_count >= X"010000" and load = '0') 
		 else std_logic_vector(s_count(15 downto 0)) when load = '0'
		 else std_logic_vector(s_start(23 downto 8)) when load = '1';
	
	countFinished <= s_finished;
end behav;