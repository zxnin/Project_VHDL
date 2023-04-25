-------------------------------Test Bench---------------------------
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.alu_proc.all;
use work.alu_func.all;
--use work.read_intel_hex_pack.all;

entity testbench is
end entity testbench;



architecture arch of testbench is
    file file_vectors : text;
    file file_results : text;

    
    --signal program : program_array;
    constant clock_T        : time      := 5 ns;
    signal clk_tb, reset    : std_logic :='0';
    signal instr            : word14;
    signal pc_o             : word13;
    signal pc_t             : word13;
    signal pin_A            : word5;
    signal pin_B            : word8;
    signal cur_state        : state := iFetch;
    signal st               : word3;
    signal res              : word8 := (others => '0');
   


begin

        top: entity work.top(arch)
       
        port map(
                  reset => reset, 
                  clk_tb => clk_tb, 
                  instr => instr, 
                  pc_o => pc_o, 
                  pin_A => pin_A,
                  pin_B => pin_B, 
                  cur_state => cur_state, 
                  st => st,
                  res => res);
     

           
    
    run_sim: process is
      
        --CONSTANT ihex_data : STRING := "data.hex";
        --VARIABLE memory : program_array := (OTHERS => (OTHERS => '0'));
        --variable prog_mem_size: integer;
        variable v_ILINE    : line;
        variable v_OLINE    : line;
        variable op_val     : word14;
        variable val_com    : character; --for com between data in file
        


    begin 
        file_open(file_vectors, "input.csv", read_mode);
        
        
        --read_ihex_file(ihex_data, memory);
        WAIT FOR 1 ns;
        reset <= '1';
        clk_tb <= '0';
        WAIT FOR 1 ns;
        reset <= '0';
        pc_t <= std_logic_vector(to_signed(-1,13));
        wait for 1 ns;
        --prog_mem_size := program'length;
        --input:operation code, W, f, bit_select, status_in--
          while not endfile(file_vectors) loop
            clk_tb <='0';
                  
          --instr <= program(TO_INTEGER(UNSIGNED(pc)));
            if not (to_integer(unsigned(pc_t)) = to_integer(unsigned(pc_o))) then
              readline(file_vectors, v_ILINE);
              read(v_ILINE, op_val);
              --op_func <= str_to_op(op_val);
              instr <= std_logic_vector(unsigned(op_val));
              --instruction <= op_val;
              pc_t <= std_logic_vector(unsigned(pc_o));
             end if;


            wait for clock_T;
            clk_tb <='1';
            wait for clock_T;
         
          end loop;

        file_close(file_vectors);
        

        clk_tb <='0';
        wait for clock_T;
        clk_tb <='1';
        wait for clock_T;  
        clk_tb <='0';
        wait for clock_T;        
        clk_tb <='1';
        wait for clock_T; 
        clk_tb <='0';
 
        wait; -- this stops simulation
    end process;




    Writing: PROCESS (cur_state, clk_tb)
        variable v_ILINE    : line;
        variable v_OLINE    : line;
        variable op_val     : word14;
        variable val_com    : character := ','; --for com between data in file

        file file_results: text open write_mode is "output.csv";

    begin 
        
        if cur_state 'event and (cur_state = iFetch) then
              
              write(v_OLINE, to_integer(unsigned(res)));
              write(v_OLINE, val_com); 
              write(v_OLINE, st);
            
              writeline(file_results, v_OLINE);

        end if;

    
    end process;

end architecture arch;
