library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1 is 
    port(
        sel_op: in std_logic;
        op0: in unsigned(15 downto 0);
        op1: in unsigned(15 downto 0); 
        saida: out unsigned(15 downto 0)
        );
end entity;

architecture a_mux_2x1 of mux_2x1 is
    begin
    saida <=op0 when sel_op = '0' else
            op1 when sel_op = '1' else
            "0000000000000000";

end architecture;
