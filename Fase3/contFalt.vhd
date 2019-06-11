library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;



entity contFalt is
	generic(N : positive := 5);    -- Sets the upper limit '5'
	port(enable : in std_logic;
		  clk		: in  std_logic;
		  addFaltas, subFaltas, resetFaltas  	: in  std_logic; 
		  --reset  : in  std_logic;
		  faltas : out std_logic_vector(2 downto 0)); -- 5 faltas possiveis
end contFalt;




architecture Behavioral of contFalt is
	signal s_faltas : unsigned(2 downto 0) := to_unsigned(0,3); 
begin
	process(clk)

	begin
		if(rising_edge(clk)) then
			if(resetFaltas = '1') then
				s_faltas <= to_unsigned(0,3);
			elsif ( enable = '1') then 
				if (addFaltas = '1') then
					if (s_faltas = N) then
						s_faltas <= to_unsigned(0, 3);
					else
						s_faltas <= s_faltas + 1;
					end if;
				elsif (subFaltas = '1') then
					if (s_faltas = "000") then
						s_faltas <= to_unsigned(N, 3);
					else
						s_faltas <= s_faltas - 1;
					end if;
				end if;
			end if;
		end if;
	end process;

	faltas <= std_logic_vector(s_faltas);

	

end Behavioral;