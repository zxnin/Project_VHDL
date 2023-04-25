LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


LIBRARY work;
USE work.alu_func.ALL;
USE work.alu_proc.ALL;





entity mux is
    port (a, b: in word8; 
          s: in word1;
          q: out word8);

end entity mux;

architecture arch_mux of mux is
  
begin
	
    process (s) is--logic of the mux
    begin 
        IF (s = '1') THEN
		q <= b ;
	ELSE 
		q <= a;
	END IF;
    end process;

 
end architecture arch_mux;
