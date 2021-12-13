library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----simple register-----------
entity reg is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(13 downto 0);
		o : out std_logic_vector(13 downto 0)
	);
end reg;

architecture behavioral of reg is
	signal temp : std_logic_vector(13 downto 0);

begin
	process (clock,reset)
	begin
		if(reset = '0')then
				temp <= (others=>'0');
		elsif(clock = '1' and clock'event and load = '1')then
				temp <= i;
		end if;
	end process;

	o <= temp;
	
end behavioral;


configuration CFG_reg of reg is
  for behavioral
  end for;
end CFG_reg;
