-------------------------------Test Bench---------------------------
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.alu_proc.all;
use work.alu_func.all;



ENTITY top IS
    PORT (
            -- INPUTS
            reset        : IN word1;    -- reset signal
            clk_tb       : IN word1;    -- clock signal
            instr        : IN word14;   -- instruction word
            -- OUTPUTS
            pc_o         : OUT word13;  -- program counter
            pin_A        : OUT word5;
            pin_B        : OUT word8;

            cur_state    : OUT state;
            st           : OUT word3; 
            res          : OUT word8

         );

END ENTITY top;



architecture arch of top is
    --buffer for storing the text
    file file_vectors : text;
    file file_results : text;
    

    signal a_test, b_test : word8 := "00000000";-- 8-bit signal 
    signal op_func        : operation;
    signal bs, st_in  : word3 := "000"; 

    constant clock_T                      : time      := 5 ns;
    constant rows                         : integer   := 8;
    signal re_tb, we_tb                  : std_logic :='0';
    signal add_in, read_bus               : word8 := "00000000";

    --signal cur_state    : state;
    signal instruction  : word14;
    signal pc_out       : word13;
    signal lit, in_W, in_ram : word8 := "00000000";
    signal wreg_en,  alu_en , in_sel   : word1 :='0';
    signal st_signal    : word3;
    signal res_signal    : word8;

    signal x: word8 := "00001100";

begin

    dut1 : entity work.alu(alu_arch)
       
        port map(
                  W=>a_test, 
                  f=>b_test, 
                  op=>op_func, 
                  bit_select=>bs, 
                  result=>res_signal, 
                  st_in=>st_in, 
                  alu_en => alu_en,
                  st_out=>st_signal     );



    dut2 : entity work.RAM(RAM_arch)
       
        generic map(rows     => rows)
        port map(
                  data_bus   => in_ram, 
                  add_in     => add_in, 
                  
                  status_in  => st_signal, 
                  clk        => clk_tb, 
                  reset      => reset, 
                  we         => we_tb,     
                  re         => re_tb,  
                  status_out => st_in,
                  read_bus   => read_bus, 
                  pc_in      => pc_out,
                  pin_A      => pin_A,
                  pin_B      => pin_B  
                );

                  



    dut3 : entity work.dec(dec_arch)
       
        port map( 
                 instr   => instruction,
                 alu_res => res_signal,   
                 clk     => clk_tb,   
                 reset   => reset,
                 addr_in  =>  add_in,
                 
 
                 to_ram => in_ram,  
                 to_W   => in_W,    
                 to_lit => lit,     
                 bit_select => bs,

  
                 we  => we_tb,  
                 re  => re_tb,       
                 wreg_en  => wreg_en,  
                 alu_en => alu_en,      
     

                 pc_out => pc_out,     
                 in_select => in_sel,  
                 --d          
                 alu_op => op_func,     
                 cur_state => cur_state     );

      dut4 : entity work.mux(arch_mux)
       
        port map( 
                 a   => read_bus,
                 b   => lit,   
                 s   => in_sel,   
                 q   => a_test               );
     
    
      
     -- Work register
    W_reg : PROCESS (clk_tb, reset, wreg_en, a_test)
      BEGIN
        -- Initialize the work register on reset
        IF reset = '1' THEN
            b_test <= "00000000";
        -- Work register is written into ONLY when these conditions fulfill
        -- Otherwise it retains its data
        ELSIF RISING_EDGE(clk_tb) AND (wreg_en= '1') THEN
            b_test <= in_W;
            --report "######################AAAAAAAAAAAAAA:" & integer'image(to_integer(unsigned(x)));
            --report "######################BBBBBBBBBBBBBB" & integer'image(to_integer(unsigned(b_test)));
            --report "######################WWWWWWWWWWWWWW" & integer'image(to_integer(unsigned(in_W)));
            --report "######################SSSSSSSSSSSSSS" & std_logic'image(in_sel);

        END IF;
    END PROCESS W_reg;


    instr_reg : PROCESS(clk_tb, reset, instr)
      BEGIN
        -- Initialize the instruction as NOP on reset
        IF reset = '1' THEN
            instruction <= (OTHERS => '0');
        -- Instruction is distributed forwards on rising edge
        ELSIF RISING_EDGE(clk_tb) THEN
            instruction <= instr;
        END IF;
    END PROCESS instr_reg;






    -- DUT_reg : PROCESS(clk_tb)
    --   BEGIN
    --     -- Initialize the instruction as NOP on reset
    --     IF RISING_EDGE(clk_tb) THEN
    --         b_test <= in_W;
    --     END IF;
    -- END PROCESS DUT_reg;










    DUT_st: PROCESS(clk_tb, reset, instr)
    BEGIN
    
    IF RISING_EDGE(clk_tb) THEN
        st <= st_signal;
        res <= res_signal;
        pc_o <= pc_out;
    END IF;
    
END PROCESS DUT_st;
    
    

end architecture arch;
