library IEEE; 
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all; 

entity clk_enable is
	generic ( k: integer  := 50000000);
	port 		(clkIn :in std_logic;
				clkOut : out std_logic); 
end clk_enable;			
				
architecture behav of clk_enable is
	signal s_cnt : integer := 0;
	
	begin
	process(clkin)
	begin
	if(rising_edge(clkin)) then
		if ( s_cnt = k ) then
			s_cnt <= 0;
			clkOut <= '1';
			else 
				clkOut <= '0';
				s_cnt <= s_cnt + 1;
		end if;
	end if;
	end process;
	
end behav;