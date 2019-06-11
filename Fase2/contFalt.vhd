library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;



entity contFalt is
	generic(N : positive := 5);    -- Sets the upper limit '5'
	port(clk		: in  std_logic;
		  ap  	: in  std_logic; 
		  reset  : in  std_logic;
		  faltas : out std_logic_vector(2 downto 0)); -- 5 faltas possiveis
end contFalt;




architecture Behavioral of contFalt is
	signal s_faltas : unsigned(2 downto 0) := to_unsigned(0,3); 
begin
	process(clk)

	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				s_faltas <= to_unsigned(0,3);
			elsif(ap = '1' and s_faltas < N) then 
				s_faltas <= s_faltas + 1;							
			elsif (ap = '1' and s_faltas = N) then
				s_faltas <= to_unsigned(0,3);
			end if;
		end if;
	end process;

	faltas <= std_logic_vector(s_faltas);

	

end Behavioral;