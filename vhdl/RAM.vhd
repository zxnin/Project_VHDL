LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;
use ieee.std_logic_textio.all;

LIBRARY work;
USE work.alu_func.ALL;
USE work.alu_proc.ALL;


entity RAM is

  generic (rows: integer);

  port(
  -- Inputs--
  data_bus     : in word8;  -- data input --
  add_in       : in word8;  -- read address in ram
  status_in    : in word3;
  clk          : in word1; -- clock signal
  reset        : in word1; -- reset (initializes all memory to 0)
  we           : in word1; -- write enable
  re           : in word1; -- read enable
  pc_in        : in word13; --from decoder

  --Outputs--
  read_bus     : out word8; -- data output
  status_out   : out word3;
  pin_A        : OUT word5;
  pin_B        : OUT word8 );
  
end entity RAM;



architecture RAM_arch of RAM is 
  constant status_addr : integer range 0 to 128 := 3; --status register address 03h
  constant PCL_addr    : INTEGER RANGE 0 TO 79 := 2;  -- PC register address, low 8 bits

  constant porta_addr : integer range 0 to 128  := 5; --porta register address 
  constant portb_addr : integer range 0 to 128  := 6; --portb register address 
  constant PCLATH_addr : INTEGER RANGE 0 TO 79 := 10; -- PC register address, high 5 bits 
  type mem_array is array (0 to (2**rows-1)) of word8;--memory bank, 128 on total
  signal memory : mem_array;
  signal temp_st: word3;





begin
  
  MEM: process(clk, reset) is 
  
  variable temp_w: integer;
  --variable temp_r: integer;

  begin 
    if reset = '1' then
      memory <= (others => (others => '0')); --reset initializes all memory to zero
      status_out <= "000";--status initial value 000
      read_bus  <= (others => '0'); --initial value for read bus
      temp_st <= "000";
      --read and write during rising edge of the clock signal 
    elsif (rising_edge(clk)) then

    --ASSERT (d\LAST_EVENT>=d_setup) 
    --REPORT ]setup time error



      if re = '1' then
        --temp_r := to_integer(unsigned(add_out));
        read_bus <= memory(to_integer(unsigned(add_in)));
        temp_st <= memory(3)(2 downto 0);
        status_out <= temp_st;
      end if;
      
        

      if we = '1' then
        temp_w := to_integer(unsigned(add_in));
       
        

        -- Do not write status if STATUS register is being written to
        if not(temp_w = status_addr) then
          temp_st <= status_in;
          memory(3)(2 downto 0) <= temp_st; 
        end if;

        memory(PCLATH_addr)(4 DOWNTO 0) <= pc_in(12 DOWNTO 8); -- Upper PC bits
        memory(PCL_addr) <= pc_in(7 DOWNTO 0);                 -- Lower PC bits
        memory(to_integer(unsigned(add_in)))<= data_bus;
      end if;

    end if;

  end process MEM;
    
    pin_A     <= memory(PORTA_addr)(4 DOWNTO 0);
    pin_B     <= memory(PORTB_addr)(7 DOWNTO 0);

end architecture RAM_arch;
 












