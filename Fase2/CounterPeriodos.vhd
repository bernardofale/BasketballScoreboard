library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CounterPeriodos is
	port (enable, period: in std_logic;
			countIn: in std_logic_vector(15 downto 0);
			novoPeriodo: out std_logic := '0';
			countPeriodos: out std_logic_vector(2 downto 0) := "000");
end CounterPeriodos;


architecture Behavioral of CounterPeriodos is
	signal s_count: unsigned(2 downto 0) := "000";
begin
	process(countIn, period)--0000 0001 0011 0111 1111
	begin
		if (enable = '1') and (countIn = std_logic_vector(to_unsigned(0, 16))) then
			if (rising_edge(period)) then
				if (s_count = "100") then
					s_count <= "000";
				else
					s_count <= s_count + 1;
				end if;
				
				novoPeriodo <= '1';
			
			end if;
		else
			novoPeriodo <= '0';
		end if;
	end process;
	
	countPeriodos <= std_logic_vector(s_count);
end Behavioral;