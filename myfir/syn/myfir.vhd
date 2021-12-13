library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

entity myfir is
port (
  	 CLK: 		IN std_logic;
  	 RST: 	 	IN std_logic;
	 VIN: 	   	IN std_logic;

	 DIN:  		IN signed(NB - 1 downto 0);

	 B0: 	    IN signed(NB - 1 downto 0);  --coefficients
	 B1: 	    IN signed(NB - 1 downto 0);
	 B2: 	    IN signed(NB - 1 downto 0);
	 B3: 	    IN signed(NB - 1 downto 0);
	 B4: 	    IN signed(NB - 1 downto 0);
	 B5: 	    IN signed(NB - 1 downto 0);
	 B6: 	    IN signed(NB - 1 downto 0);
	 B7: 	    IN signed(NB - 1 downto 0);
	 B8: 	    IN signed(NB - 1 downto 0);

  	 DOUT: 		OUT signed(NB - 1 downto 0);

	 VOUT: 		OUT std_logic );
end myfir;

architecture rtl of myfir is

type data    is array (0 to NT-1) of signed(NB -1   downto 0);--type for data in
type operand is array (0 to NT-1) of signed(2*NB -1   downto 0);--type for sum and products
type c       is array (0 to NT-1) of signed(NB -1   downto 0);--type for coefficients

signal prod:			operand :=(others=>(others=>'0'));
signal sum:				operand :=(others=>(others=>'0'));
signal Q:				data :=(others=>(others=>'0'));

signal array_coeff: 	c 	 :=(others=>(others=>'0'));

signal sig_vout         	 : std_logic;


begin
  array_coeff(0) <= B0;
  array_coeff(1) <=	B1;
  array_coeff(2) <=	B2;
  array_coeff(3) <= B3;
  array_coeff(4) <= B4;
  array_coeff(5) <=	B5;
  array_coeff(6) <= B6;
  array_coeff(7) <= B7;
  array_coeff(8) <= B8;


		prod(0)<=array_coeff(0)*DIN;	
		products: for j in 1 to NT - 1 generate
			prod(j)<=Q(j-1)*array_coeff(j-1);
		end generate;
		sums:	  for j in 1 to NT - 1 generate
			sum(j)<=prod(j) + sum(j-1);
		end generate;



in_reg: process(CLK,RST)
begin
	   if RST ='0' then
				Q(0)<=(others=>'0');
	   elsif CLK'event and CLK='1' then
			if VIN = '1' then
				Q(0)<=DIN;
			end if;
	  		 temp: for j in 0 to NT - 2 loop
					Q(j+1)<= Q(j);
			 end loop;
	   end if;
end process;

out_reg: process(CLK,RST)
begin
	   if RST ='0' then
			VOUT <= '0';
			DOUT <=(others=>'0');
	   elsif CLK'event and CLK='1' then
			if VIN = '1' then
				sig_vout <= '1';
				VOUT <= sig_vout;
				DOUT <= resize(sum(NT-1)(2*NB -2  downto NB-1),NB);
			end if;
		end if;
end process;

end rtl;

configuration CFG_myfir of myfir is
  for rtl
  end for;
end CFG_myfir;


