library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_8x1 is 
    port(
        sel_op: in unsigned(2 downto 0);
        op0: in unsigned(15 downto 0);
        op1: in unsigned(15 downto 0);
        op2: in unsigned(15 downto 0);
        op3: in unsigned(15 downto 0);
        op4: in unsigned(15 downto 0); 
        op5: in unsigned(15 downto 0);
        op6: in unsigned(15 downto 0);
        op7: in unsigned(15 downto 0);
        saida: out unsigned(15 downto 0)
        );
end entity;

architecture a_mux_8x1 of mux_8x1 is
    begin
    saida <=op0 when sel_op = "000" else
            op1 when sel_op = "001" else
            op2 when sel_op = "010" else
            op3 when sel_op = "011" else
            op4 when sel_op = "100" else
            op5 when sel_op = "101" else
            op6 when sel_op = "110" else
            op7 when sel_op = "111" else
            "0000000000000000";

end architecture;
