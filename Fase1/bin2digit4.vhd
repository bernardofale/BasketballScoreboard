library IEEE;

use IEEE.STD_LOGIC_1164.all;



entity bin2digit4 is

	port(binInput : in std_logic_vector(2 downto 0);

		  enable : in std_logic;

		  decOut_n : out std_logic_vector(4 downto 0));

end bin2digit4;



architecture Behavioral of bin2digit4 is



begin



	decOut_n <= "00000" when (enable = '0') else 

					"00001" when (binInput = "001") else --1

					"00011" when (binInput = "010") else --2

					"00111" when (binInput = "011") else --3

					"01111" when (binInput = "100") else --4
					
					"11111" when (binInput = "101") else --5
					
					"00000";
					

end Behavioral;