library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.ALL;

library work;
use work.alu_func.all;
--------------------package procedure---------------------------

package alu_proc is 

 procedure ADDLW (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8); --ADDWF

 procedure ANDLW (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);--ANDWF

 procedure CLRF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);--CLRW

 procedure COMF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);


------
 procedure DECF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8); 

 procedure INCF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);

 procedure IORLW (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);--IORWF

 procedure MOVF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);

-----

 procedure MOVWF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8); 

 procedure MOVLW  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8); 


 procedure RLF    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);

 procedure RRF    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);

 procedure SUBWF (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);--SUBLW

-----

 procedure SWAPF (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8); 

 procedure XORWF (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8); --XORLW

 procedure BCF    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal bit_select : in word3;
                  signal st_out: out word3;
                  signal result: out word8);

 procedure BSF    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal bit_select : in word3;
                  signal st_out: out word3;
                  signal result: out word8);

 procedure NOP    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8);
end package;




package body alu_proc is


--1--
 procedure ADDLW (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is 

 -- Variables to calculate mid-results
 variable temp5 : word5;
 variable temp9 : word9;
  
   begin
   temp5 := std_logic_vector(unsigned('0' & W(3 downto 0)) + unsigned('0' & f(3 downto 0)));
   temp9 := std_logic_vector(unsigned('0' & W) + unsigned('0' & f));
   st_out(2) <= bit2_Z(temp9);
   st_out(1) <= bit1_DC( temp5(temp5'left) );
   st_out(0) <= bit1_DC( temp9(temp9'left) );
   result <= temp9(7 downto 0);  
 end procedure ADDLW;





--2--
 procedure ANDLW (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

 variable temp8 : word8;
 variable temp9 : word9;
 begin
   --temp8 := W and f;
   temp9 := ('0' & W) and ( '0' & f);
   temp8 := temp9(7 downto 0);
   st_out(2) <= bit2_Z('0' & temp8);
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= temp8;

   
 end procedure ANDLW;


--3--
 procedure CLRF (signal w, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is
 
 begin
   st_out(2) <= '1';
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= "00000000"; 
 end procedure CLRF;


--4--
 procedure COMF (signal w, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

 variable temp8 : word8;
 begin 
   temp8     := not(f);
   st_out(2) <= bit2_Z('0' & temp8);
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= temp8; 
 end procedure COMF;


--5--

 procedure DECF (signal w, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

 variable temp8 : word8;
 begin 
   temp8     := not(f);
   st_out(2) <= bit2_Z('0' & temp8);--type of function input is word9
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= temp8; 
 end procedure DECF;


--6--
procedure INCF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

 variable temp8 : word8;
 begin
   temp8     := std_logic_vector(unsigned(f) + 1);
   st_out(2) <= bit2_Z('0' & temp8);
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= temp8; 
 end procedure INCF;


--7--
 procedure IORLW (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

 variable temp8 : word8;
 begin 
   temp8     := (W) or (f);
   st_out(2) <= bit2_Z('0' & temp8);
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= temp8; 
 end procedure IORLW;


--8--
 procedure MOVF  (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

 variable temp8 : word8;
 begin 
   temp8     := f;
   st_out(2) <= bit2_Z('0' & temp8);
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= temp8; 
 end procedure MOVF;


--9_1--
 procedure MOVWF (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is
 
 begin             
   st_out(0) <= st_in(0);
   st_out(1) <= st_in(1);
   st_out(2) <= st_in(2);
   result <= f; 
 end procedure MOVWF;



--9_2--
 procedure MOVLW (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is
 
 begin             
   st_out(0) <= st_in(0);
   st_out(1) <= st_in(1);
   st_out(2) <= st_in(2);
   result <= W; 

   report "WWWWWWWWWWW" & integer'image(to_integer(unsigned(W)));
 end procedure MOVLW;







--10--
 procedure RLF   (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is
 begin
  st_out(0) <= f(7);
  st_out(1) <= st_in(1);
  st_out(2) <= st_in(2);
  result    <= f(6 downto 0) & st_in(0);
 end procedure RLF;

--11--
 procedure RRF    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is 

  begin
  st_out(0) <= f(0);
  st_out(1) <= st_in(1);
  st_out(2) <= st_in(2);
  result    <= st_in(0) & f(7 downto 1);
 end procedure RRF;


--12--
 procedure SUBWF (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is
 variable temp5 : word5;
 variable temp9 : word9;
  
   begin
   temp5 := std_logic_vector(unsigned('1' & f(3 downto 0)) - unsigned('0' & W(3 downto 0)));
   temp9 := std_logic_vector(unsigned('1' & W) - unsigned('0' & f));
   --temp9 := std_logic_vector(unsigned('1' & f) - unsigned('0' & W));
   st_out(2) <= bit2_Z(temp9);
   st_out(1) <= bit1_DC( temp5(temp5'left) );
   st_out(0) <= bit1_DC( temp9(temp9'left) );
   result <= temp9(7 downto 0);  
 end procedure SUBWF;

--13--
 procedure SWAPF (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

  begin
  st_out(0) <= st_in(0);
  st_out(1) <= st_in(1);
  st_out(2) <= st_in(2);
  result    <= f(3 downto 0) & f(7 downto 4);
 end procedure SWAPF;



--14--
 procedure XORWF (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

 variable temp8 : word8; 
 begin 
   temp8     := W xor f;
   st_out(2) <= bit2_Z('0' & temp8);
   st_out(1) <= st_in(1);
   st_out(0) <= st_in(0);
   result <= temp8;
 end procedure XORWF;

 
--15--
 procedure BCF    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal bit_select : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

  variable val   : word8;
  variable temp8 : word8;
  begin
  val := "00000001";
  temp8 := f and not(std_logic_vector(SHIFT_LEFT(unsigned(val), 
                              to_integer(unsigned(bit_select)))));
  st_out(0) <= st_in(0);
  st_out(1) <= st_in(1);
  st_out(2) <= st_in(2);
  result    <= temp8;
 end procedure BCF;

--16--
 procedure BSF    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal bit_select : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is
  variable val   : word8;
  variable temp8 : word8;
  begin
  val :="00000001";
  temp8 := f or std_logic_vector(SHIFT_LEFT(unsigned(val), 
                              to_integer(unsigned(bit_select))));
  st_out(0) <= st_in(0);
  st_out(1) <= st_in(1);
  st_out(2) <= st_in(2);
  result    <= temp8;
 end procedure BSF;


--17--
 procedure NOP    (signal W, f  : in word8;
                  signal st_in : in word3;
                  signal st_out: out word3;
                  signal result: out word8) is

  begin
  st_out(0) <= st_in(0);
  st_out(1) <= st_in(1);
  st_out(2) <= st_in(2);
  result    <= f;
 end procedure NOP;


end alu_proc;



