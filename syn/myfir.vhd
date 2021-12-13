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

	 DIN0:      IN signed(NB - 1 downto 0); --multiple inputs
	 DIN1:      IN signed(NB - 1 downto 0);
	 DIN2:      IN signed(NB - 1 downto 0);

	 B0: 	    IN signed(NB - 1 downto 0);  --coefficients
	 B1: 	    IN signed(NB - 1 downto 0);
	 B2: 	    IN signed(NB - 1 downto 0);                                                                                                                                           
	 B3: 	    IN signed(NB - 1 downto 0);
	 B4: 	    IN signed(NB - 1 downto 0);
	 B5: 	    IN signed(NB - 1 downto 0);
	 B6: 	    IN signed(NB - 1 downto 0);
	 B7: 	    IN signed(NB - 1 downto 0);
	 B8: 	    IN signed(NB - 1 downto 0);

  	 DOUT0:     OUT signed(NB - 1 downto 0); --multiple outputs
	 DOUT1:     OUT signed(NB - 1 downto 0);
	 DOUT2:     OUT signed(NB - 1 downto 0);

	 VOUT: 		OUT std_logic );
end myfir;

architecture rtl of myfir is

component reg is
	port(
		clock,reset : in std_logic;
		i : in signed(2*NB-1 downto 0);
		o : out signed(2*NB-1 downto 0)
	);
end component;

type data    is array (0 to NT-1) of signed(NB -1   downto 0);--type for data in
--type datax   is array (0 to 2)    of signed(NB-1    downto 0);--type for input x
type operand is array (0 to NT-1) of signed(2*NB -1   downto 0);--type for sum and products
type c       is array (0 to NT-1) of signed(NB -1   downto 0);--type for coefficients
type dataout    is array (0 to 2) of signed(NB -1   downto 0);--type for data out

--type SignalM is array (NT-1 downto 0,NT-1 downto 0) of signed(2*NB -1 downto 0);--matrix for out


signal prod0,prod1,prod2:			operand :=(others=>(others=>'0'));
signal sum0,sum1,sum2:				operand :=(others=>(others=>'0'));
signal Q:				data    :=(others=>(others=>'0'));
--signal inputData: 				datax   :=(others=>(others=>'0'));
signal array_coeff: 				c       :=(others=>(others=>'0'));
signal sig_vout         	 : std_logic;
signal sig_dout:				dataout    :=(others=>(others=>'0'));

signal mult0,mult1,mult2:				operand :=(others=>(others=>'0'));
--signal multPipe0:				SignalM :=(others=>(others=>(others=>'0')));
--signal multPipe1:				SignalM :=(others=>(others=>(others=>'0')));
--signal multPipe2:				SignalM :=(others=>(others=>(others=>'0')));

begin

		array_coeff(0) <= B0;
		array_coeff(1) <= B1;
		array_coeff(2) <= B2;
		array_coeff(3) <= B3;
		array_coeff(4) <= B4;
		array_coeff(5) <= B5;
		array_coeff(6) <= B6;
		array_coeff(7) <= B7;
		array_coeff(8) <= B8;


			prod0(0)<=array_coeff(0)*DIN0; 	 e_reg00:reg port map(CLK,RST,prod0(0),mult0(0));--0 is for the first matrix 00 is 0 row and 0 column
			prod1(0)<=array_coeff(0)*DIN1;	 e_reg10:reg port map(CLK,RST,prod1(0),mult1(0));
			prod2(0)<=array_coeff(0)*DIN2; 	 e_reg20:reg port map(CLK,RST,prod2(0),mult2(0));
			prod1(1)<=array_coeff(1)*DIN0; 	 e_reg11:reg port map(CLK,RST,prod1(1),mult1(1));
			prod2(1)<=array_coeff(1)*DIN1; 	 e_reg21:reg port map(CLK,RST,prod2(1),mult2(1));
			prod2(2)<=array_coeff(2)*DIN0; 	 e_reg22:reg port map(CLK,RST,prod2(2),mult2(2));

		products: for j in 1 to NT - 1 generate
			prod0(j)<=Q(j-1)*array_coeff(j); 		 reg0j:reg port map(CLK,RST,prod0(j),mult0(j));
				
			secondrow:if(j+1 < NT-1) generate
				prod1(j+1)<=Q(j-1)*array_coeff(j+1); reg1j:reg port map(CLK,RST,prod1(j+1),mult1(j+1));
			end generate;
			thirdrow:if(j+2 < NT-1) generate
				prod2(j+2)<=Q(j-1)*array_coeff(j+2); reg2j:reg port map(CLK,RST,prod2(j+2),mult2(j+2));
			end generate;
		end generate;

			sum0(0)<=mult0(0);
			sum1(0)<=mult1(0);
			sum2(0)<=mult2(0);


		sums:	  for j in 1 to NT - 1 generate
			sum0(j)<=mult0(j) + sum0(j-1);
			sum1(j)<=mult1(j) + sum1(j-1);
			sum2(j)<=mult2(j) + sum2(j-1);
		end generate;


in_reg: process(CLK,RST)
begin
	   if RST ='0' then
				Q<=(others=>(others=>'0'));
	   elsif CLK'event and CLK='1' then
			if VIN = '1' then
				Q(0)<=DIN2;
				Q(1)<=DIN1;
				Q(2)<=DIN0;
				Q(3)<=Q(0);
				Q(4)<=Q(1);
				Q(5)<=Q(2);
				Q(6)<=Q(3);
				Q(7)<=Q(4);
				Q(8)<=Q(5);

			end if;
	  		 --temp: for j in 0 to NT - 2 loop
			--		Q(j+1)<= Q(j);
			 --end loop;
	   end if;
end process;

out_reg: process(CLK,RST)
begin
	   if RST ='0' then
			VOUT <= '0';
			DOUT0 <=(others=>'0');
			DOUT1 <=(others=>'0');
			DOUT2 <=(others=>'0');
	   elsif CLK'event and CLK='1' then
			if VIN = '1' then
				sig_vout <= '1';
				VOUT <= sig_vout;
				sig_dout(0) <= resize(sum0(NT-1)(2*NB -2  downto NB-1),NB);
				sig_dout(1) <= resize(sum1(NT-1)(2*NB -2  downto NB-1),NB);
				sig_dout(2) <= resize(sum2(NT-1)(2*NB -2  downto NB-1),NB);
				DOUT0 <= sig_dout(0);
				DOUT1 <= sig_dout(1);
				DOUT2 <= sig_dout(2);
			end if;
		end if;
end process;

end rtl;

configuration CFG_myfir of myfir is
  for rtl
  end for;
end CFG_myfir;

configuration CFG_myfir of myfir is
  for rtl			
      for all : reg
       use configuration WORK.CFG_reg;
      end for;		 	
   end for;
end CFG_myfir;
