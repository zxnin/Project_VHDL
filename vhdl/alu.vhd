LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;
use ieee.std_logic_textio.all;

LIBRARY work;
USE work.alu_func.ALL;
USE work.alu_proc.ALL;

entity alu is
    port (
            -- INPUTS
            W           : IN    word8;   -- work register
            f           : IN    word8;   -- file register/literal
            op          : IN    operation; -- operation (decoded from instruction)
            bit_select  : IN    word3;   -- bit select for BSF and BCF operations
            st_in       : IN    word3;   -- status in
            alu_en      : IN    word1;
            -- OUTPUTS
            result      : OUT   word8;   -- result of the operation
            st_out      : OUT   word3    -- status out
        );
end entity alu;


architecture alu_arch of alu is
begin

  ALU: process(W,f,op,bit_select,st_in) is ---sensitivity 
  begin
    if alu_en='1' then
      case op is
        when ADDWF|ADDLW  => ADDLW(W, f, st_in, st_out, result);
        when ANDWF|ANDLW  => ANDLW(W, f, st_in, st_out, result);
        when CLRF |CLRW   => CLRF(W, f, st_in, st_out, result);
        when COMF         => COMF(W, f, st_in, st_out, result);
        when DECF         => DECF(W, f, st_in, st_out, result);
        when INCF         => INCF(W, f, st_in, st_out, result); 
        when IORLW|IORWF  => IORLW(W, f, st_in, st_out, result); 
        when MOVF         => MOVF(W, f, st_in, st_out, result);   
        when MOVWF        => MOVWF(W, f, st_in, st_out, result);
        when MOVLW         =>MOVLW(W, f, st_in, st_out, result); 



        when SUBWF|SUBLW  => SUBWF(W, f, st_in, st_out, result);   
        when RLF          => RLF(W, f, st_in, st_out, result); 
        when RRF          => RRF(W, f, st_in, st_out, result);
        when SWAPF        => SWAPF(W, f, st_in, st_out, result);
        when XORLW|XORWF  => XORWF(W, f, st_in, st_out, result);
        when BCF          => BCF(W, f, st_in, bit_select, st_out, result); 
        when BSF          => BSF(W, f, st_in, bit_select, st_out, result); 
        when NOP          => NOP(W, f, st_in, st_out, result); 
      end case;
    end if;
  end process ALU;
end architecture alu_arch;








