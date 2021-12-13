library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use WORK.constants.all;

library std;
use std.textio.all;

entity data_maker is  
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT0    : out std_logic_vector(NB - 1 downto 0);
    DOUT1    : out std_logic_vector(NB - 1 downto 0);
    DOUT2    : out std_logic_vector(NB - 1 downto 0);
	  B0: 	    out std_logic_vector(NB - 1 downto 0);  --coefficients
	  B1: 	    out std_logic_vector(NB - 1 downto 0);
	  B2: 	    out std_logic_vector(NB - 1 downto 0);
	  B3: 	    out std_logic_vector(NB - 1 downto 0);
	  B4: 	    out std_logic_vector(NB - 1 downto 0);
	  B5: 	    out std_logic_vector(NB - 1 downto 0);
	  B6: 	    out std_logic_vector(NB - 1 downto 0);
	  B7: 	    out std_logic_vector(NB - 1 downto 0);
	  B8: 	    out std_logic_vector(NB - 1 downto 0);
    END_SIM : out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);  

begin  -- beh

  B0 <= conv_std_logic_vector(-51,14);
  B1 <= conv_std_logic_vector(-112,14);
  B2 <= conv_std_logic_vector(419,14);
  B3 <= conv_std_logic_vector(2179,14);  
  B4 <= conv_std_logic_vector(3323,14);
  B5 <= conv_std_logic_vector(2176,14);
  B6 <= conv_std_logic_vector(419,14);
  B7 <= conv_std_logic_vector(-112,14); 
  B8 <= conv_std_logic_vector(-51,14);
  
  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "samples.txt";
    variable line_in : line;
    variable x : integer;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT0 <= (others => '0') after tco;   
      DOUT1 <= (others => '0') after tco;  
      DOUT2 <= (others => '0') after tco;     
      VOUT <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if not endfile(fp_in) then

        readline(fp_in, line_in);
        read(line_in, x);
        DOUT0 <= conv_std_logic_vector(x, 14) after tco;

        readline(fp_in, line_in);
        read(line_in, x);
        DOUT1 <= conv_std_logic_vector(x, 14) after tco;

        readline(fp_in, line_in);
        read(line_in, x);
        DOUT2 <= conv_std_logic_vector(x, 14) after tco;

        VOUT <= '1' after tco;
        sEndSim <= '0' after tco;
      else
        VOUT <= '0' after tco;        
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process;

  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;

  END_SIM <= END_SIM_i(10);  

end beh;
