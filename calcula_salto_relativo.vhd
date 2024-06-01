library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calcula_salto_relativo is 
    port(
        atual_pc: in unsigned(6 downto 0);
        delta: in unsigned(6 downto 0);
        write_enable: in std_logic;
        proximo_pc: out unsigned(6 downto 0)
    );
end entity;

architecture a_calcula_salto_relativo of calcula_salto_relativo is

begin

    proximo_pc <= atual_pc + delta when write_enable = '1' else
                  atual_pc;

end architecture; 
