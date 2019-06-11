library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;



entity bin2bcd is

	port(inp8bit : in  std_logic_vector(7 downto 0);

		  bcd1 : out std_logic_vector(3 downto 0);

		  bcd0 : out std_logic_vector(3 downto 0));

end bin2bcd;



architecture Behavioral of bin2bcd is

	

	signal s_bcd1 : std_logic_vector(7 downto 0); 

	signal s_bcd0 : std_logic_vector(7 downto 0); 

	

begin



	s_bcd1 <= std_logic_vector(unsigned(inp8bit(7 downto 0))/10);

	s_bcd0 <= std_logic_vector(unsigned(inp8bit(7 downto 0))rem 10);

	bcd1 <= s_bcd1(3 downto 0);

	bcd0 <= s_bcd0(3 downto 0);

end Behavioral;