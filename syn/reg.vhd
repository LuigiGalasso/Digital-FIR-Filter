library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;
----simple register-----------
entity reg is
	port(
		clock,reset : in std_logic;
		i : in signed(2*NB-1 downto 0);
		o : out signed(2*NB-1 downto 0)
	);
end reg;

architecture behavioral of reg is
	signal temp : signed(2*NB-1 downto 0);

begin
	process (clock)
	begin
		if(clock = '1' and clock'event)then
			if(reset = '0')then
				temp <= (others=>'0');	
			elsif(reset = '1' )then
				temp <= i;
			end if;
		end if;
	end process;

	o <= temp;
	
end behavioral;


configuration CFG_reg of reg is
  for behavioral
  end for;
end CFG_reg;
