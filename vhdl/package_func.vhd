library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

--------------------package functions---------------------------
package alu_func is 


  
  subtype word14 is std_logic_vector(13 downto 0);
  subtype word13 is std_logic_vector(12 downto 0);
  subtype word9 is std_logic_vector(8 downto 0);
  subtype word8 is std_logic_vector(7 downto 0);
  subtype word5 is std_logic_vector(4 downto 0);
  subtype word4 is std_logic_vector(3 downto 0);
  subtype word3 is std_logic_vector(2 downto 0);
  subtype word1 is std_logic;


  type operation is (ADDWF, ANDWF, CLRF, CLRW, COMF, DECF, INCF, IORWF, MOVF, MOVWF, RLF, RRF, SUBWF, SWAPF, XORWF, BCF, BSF, ADDLW, ANDLW, IORLW, MOVLW, SUBLW, XORLW, NOP);
  
  type state is (iFetch, Execute, Mread, Mwrite);



  function bit2_Z(input: in word9) return word1;
  function bit1_DC(input: in word1) return word1;
  function bit0_C(input: in word1) return word1;

end package;

--------------------package body------------------------
package body alu_func is 


  -- Function to determine if the 8-bit word is zero
  function bit2_Z (input: in word9) return word1 is
  begin
    if input = "000000000" then return '1';
    else return '0';
    end if;
  end function bit2_Z;



  --Function to determine if there are the carry-out from 4th lower bit of the result
  function bit1_DC(input: in word1) return word1 is
  begin
    return input;
  end function bit1_DC;



  --Function to determine the carry.out from the significant bit of result
  --Not necessary in this case, it has the same logic as function bit1_DC
  function bit0_C(input: in word1) return word1 is
  begin
    return input;
  end function bit0_C;

end alu_func;
