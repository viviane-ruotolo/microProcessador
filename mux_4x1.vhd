library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1 is 
    port(
        sel_op: in unsigned(1 downto 0);
        op0: in unsigned(15 downto 0);
        op1: in unsigned(15 downto 0);
        op2: in unsigned(15 downto 0);
        op3: in unsigned(15 downto 0); 
        saida: out unsigned(15 downto 0)
        );
end entity;

architecture a_mux_4x1 of mux_4x1 is
    begin
    saida <=op0 when sel_op = "00" else
            op1 when sel_op = "01" else
            op2 when sel_op = "10" else
            op3 when sel_op = "11" else
            "0000000000000000";

end architecture;
