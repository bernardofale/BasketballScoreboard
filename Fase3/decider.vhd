library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity decider is
	port(click : in std_logic;
		  dIn : in std_logic_vector(3 downto 0);
		  clk_enable : in std_logic;
		  add: out std_logic;
		  sub: out std_logic;
		  go0: out std_logic);
end decider;

architecture behav of decider is 

	signal s_add : std_logic := '0';
	signal s_sub : std_logic := '0';
	signal s_go0 : std_logic := '0';
	signal s_add1 : std_logic := '0';
	signal s_sub1 : std_logic := '0';
	signal s_go1 : std_logic := '0';
	signal s_add2 : std_logic := '0';
	signal s_sub2 : std_logic := '0';
	signal s_go2 : std_logic := '0';

begin	
	process(dIn, click)
	begin	
		if(click = '1') then	
			if(dIn <= "0001") then
				s_add <= '1';
				s_sub <= '0';
				s_go0 <= '0';
			elsif(dIn > "0001" and dIn <= "0011") then
				s_add <= '0';
				s_sub <= '1';
				s_go0 <= '0';
			elsif ( dIn > "0011" ) then
				s_add <= '0';
				s_sub <= '0';
				s_go0 <= '1';
			else
				s_add <= '0';
				s_sub <= '0';
				s_go0 <= '0';
			end if;
		else
			s_add <= '0';
			s_sub <= '0';
			s_go0 <= '0';
		end if;
		if ( falling_edge(click)) then	
			s_add1 <= s_add;
			s_sub1 <= s_sub;
			s_go1 <= s_go0;
		end if;
		if (clk_enable = '1') then
			s_add1 <= '0';
			s_sub1 <= '0';
			s_go1 <= '0';
		end if;
	end process;
	add <= std_logic(s_add1);
	sub <= std_logic(s_sub1);
	go0 <= std_logic(s_go1);
end behav;
				
				

	