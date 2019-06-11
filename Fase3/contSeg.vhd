--library IEEE;
--use IEEE.STD_LOGIC_1164.all;
--use IEEE.NUMERIC_STD.all;
--
--entity contSeg is 
--	port(click : in std_logic;
--		  clk : in std_logic;
--		  clk_enable : in std_logic;
--		  dOut : out std_logic_vector(3 downto 0));
--		  
--end contSeg;
--
--architecture Behavioral of contSeg is
--	signal s_dOut : unsigned(3 downto 0);
--	
--begin
--	process(clk)
--	begin
--		if (rising_edge(clk)) then	
--				if (clk_enable = '1' and click = '1') then
--					s_dOut <= s_dOut + 1;
--				elsif ( click = '0' ) then	
--					s_dOut <= to_unsigned(0,4);
--				else	
--					s_dout <= s_dOut;
--				end if;
--			end if;
--		end process;
--		dOut <= std_logic_vector(s_dOut);
--end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity contSeg is 
	port(click : in std_logic;
		  clk : in std_logic;
		  clk_enable : in std_logic;
		  dOut : out std_logic_vector(3 downto 0));
		  
end contSeg;

architecture Behavioral of contSeg is
	signal s_dOut : unsigned(3 downto 0);
	
begin
	process(clk)
	begin
		if (rising_edge(clk)) then	
				if (clk_enable = '1' and click = '1') then
					s_dOut <= s_dOut + 1;
				elsif ( click = '0' ) then	
					s_dOut <= "0000";
				else	
					s_dout <= s_dOut;
				end if;
			end if;
		end process;
		dOut <= std_logic_vector(s_dOut);
end Behavioral;