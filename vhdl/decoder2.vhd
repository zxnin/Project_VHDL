LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;
use ieee.std_logic_textio.all;

LIBRARY work;
USE work.alu_func.ALL;
USE work.alu_proc.ALL;


entity dec is


  port(
            -- INPUTS--
            instr       : IN    word14;  -- instruction word
            alu_res     : IN    word8;    
            clk         : IN    word1;   -- clock signal
            reset       : IN    word1;   -- reset signal

            -- OUTPUTS--
            addr_in     : OUT   word8;  -- read address in ram
            
            --addr_bus    : OUT   word8;
            to_ram      : OUT   word8;
            to_W        : OUT   word8;
            to_lit      : OUT   word8;   -- literal (instr 7-0)
            bit_select  : OUT   word3;   -- bit select (instr 9-7)


            we          : OUT   word1;   -- write enable
            re          : OUT   word1;   -- read enable
            wreg_en     : OUT   word1;   -- write-to-work-register enable
            alu_en      : OUT   word1;   -- alu enable
     

            pc_out      : OUT   word13;   -- program counter
            in_select   : OUT   word1;    -- input select (selects second ALU operand)

            alu_op      : OUT   operation; -- operation (decoded from instruction)
            cur_state   : OUT   state      -- reports the current state, used for simulations
        );
  
end entity dec;



architecture dec_arch of dec is 

  signal next_state : state := iFetch;

  
begin
  
  dec: process(clk, reset) is 
    variable pc_temp : word13;
    variable d: word1 := '0'; --chooses the destination of ALU output (0->W, 1->RAM)
  begin
   

    if reset= '1' then
      we <= '0';
      re <= '0';
      wreg_en <= '0';
      alu_en <= '0';
      to_lit <= (others => '0');--add
      pc_out <= (others => '0');
--here
      pc_temp := (others => '0');
      --to_ram <= "00000000";
      alu_op <= NOP;
      next_state <= iFetch;



    elsif rising_edge(clk) then
     case next_state is
       when iFetch =>
        cur_state <= iFetch; -- this is solely for simulation
        we <= '0'; re <= '0'; alu_en <= '0'; wreg_en <= '0'; in_select <= '0'; -- disable everything
        addr_in <= '0' & instr(6 DOWNTO 0); -- address is always found on the same location
    

          -- Decoding of the instruction
          -- The next state and ALU output destination are also decoded here
          if    STD_MATCH("000111-", instr(13 downto 7)) THEN alu_op <= ADDWF; d := instr(7); next_state <= Mread;    --Byte-oriented file register operations
          elsif STD_MATCH("000101-", instr(13 downto 7)) THEN alu_op <= ANDWF; d := instr(7); next_state <= Mread;   
          elsif STD_MATCH("0000011", instr(13 downto 7)) THEN alu_op <= CLRF;  d := instr(7); next_state <= Execute; 
          elsif STD_MATCH("0000010", instr(13 downto 7)) THEN alu_op <= CLRW;  d := instr(7); next_state <= Execute;  
          elsif STD_MATCH("001001-", instr(13 downto 7)) THEN alu_op <= COMF;  d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("000011-", instr(13 downto 7)) THEN alu_op <= DECF;  d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("001010-", instr(13 downto 7)) THEN alu_op <= INCF;  d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("000100-", instr(13 downto 7)) THEN alu_op <= IORWF; d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("001000-", instr(13 downto 7)) THEN alu_op <= MOVF;  d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("0000001", instr(13 downto 7)) THEN alu_op <= MOVWF; d := instr(7); next_state <= Mread; 

          elsif STD_MATCH("0000000", instr(13 downto 7)) THEN alu_op <= NOP;   d := '1';      next_state <= Execute; 
          elsif STD_MATCH("001101-", instr(13 downto 7)) THEN alu_op <= RLF;   d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("001100-", instr(13 downto 7)) THEN alu_op <= RRF;   d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("000010-", instr(13 downto 7)) THEN alu_op <= SUBWF; d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("001110-", instr(13 downto 7)) THEN alu_op <= SWAPF; d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("000110-", instr(13 downto 7)) THEN alu_op <= XORWF; d := instr(7); next_state <= Mread;    
          elsif STD_MATCH("0100", instr(13 downto 10)) THEN alu_op <= BCF;   d := '1';        next_state <= Mread; --BIT-ORIENTED FILE REGISTER OPERATIONS   
          elsif STD_MATCH("0101", instr(13 downto 10)) THEN alu_op <= BSF;   d := '1';        next_state <= Mread;    
          elsif STD_MATCH("11111--", instr(13 downto 7)) THEN alu_op <= ADDLW; d := '0';      next_state <= Execute; --LITERAL AND CONTROL OPERATIONS
          elsif STD_MATCH("111001-", instr(13 downto 7)) THEN alu_op <= ANDLW; d := '0';      next_state <= Execute; 
          elsif STD_MATCH("111000-", instr(13 downto 7)) THEN alu_op <= IORLW; d := '0';      next_state <= Execute; 
          elsif STD_MATCH("1100---", instr(13 downto 7)) THEN alu_op <= MOVLW; d := '0';      next_state <= Execute; 
          elsif STD_MATCH("11110--", instr(13 downto 7)) THEN alu_op <= SUBLW; d := '0';      next_state <= Execute; 
          elsif STD_MATCH("111010-", instr(13 downto 7)) THEN alu_op <= XORLW; d := '0';      next_state <= Execute;
          else  alu_op <= NOP;   d := '1';      next_state <= Execute; 
          end if;


     when Mread =>
       cur_state <= Mread;
       in_select <= '1'; --set alu input to read 
       re <= '1';
       we <= '0';
       next_state <= Execute;
   
     
    when Execute =>
       cur_state <= Execute;
       
      if d ='0' then
        in_select <= '1';
       else
        in_select <= '0';
       end if; 

       re <= '0';    ------????
       alu_en <= '1';
       bit_select <= instr(9 downto 7);
       to_lit <= instr(7 downto 0);
       next_state <= Mwrite;  

      report "######################" & integer'image(to_integer(unsigned(instr(7 downto 0))));
      --report "######################" & to_hstring(instr(7 downto 0));

    when Mwrite =>
      cur_state <= Mwrite;
      alu_en <= '0';
      we <= '1';

      next_state <= iFetch;
      if d = '0' then
        wreg_en <='1';
        to_W <= alu_res;
        re <= '1';
        we <= '0';
    
      else
        we <= '1';
        re <= '0';
        wreg_en <='0';
        to_ram <= alu_res;
        

      end if;
      --we <= '1';
    
--here
      --pc_out <= pc_temp + 1;
     pc_temp :=STD_LOGIC_VECTOR(UNSIGNED(pc_temp) + 1);
     --pc_out <= pc_temp;
     end case;
     pc_out <= pc_temp;
     cur_state <= next_state;
    end if;   

  end process dec;

end architecture dec_arch;
 












