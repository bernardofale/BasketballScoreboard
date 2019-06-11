library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity contPont is
	generic(N : positive := 99);    -- Sets the upper limit '99'

	port(clk      : in  std_logic;
		  pont		: in  std_logic; 
		  reset    : in  std_logic;
		  count    : out std_logic_vector(7 downto 0)); -- Counts in  binary
end contPont;

architecture Behavioral of contPont is
	signal s_count : unsigned(7 downto 0) := to_unsigned(0,8); 
begin
	process(clk)

	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				s_count <= to_unsigned(0,8);
			elsif(pont = '1' and s_count <= N-1) then 
				s_count <= s_count + 1;							
			elsif (pont = '1' and s_count = N) then	
				s_count <= to_unsigned(0,8);
			end if;
		end if;
	end process;

	count <= std_logic_vector(s_count);
end Behavioral;