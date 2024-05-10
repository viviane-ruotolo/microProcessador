library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incrementa_pc is 
    port(
        atual_pc: in unsigned(6 downto 0);
        write_enable: in std_logic;
        proximo_pc: out unsigned(6 downto 0)
    );
end entity;

architecture a_incrementa_pc of incrementa_pc is

begin

    proximo_pc <= atual_pc + "0000001" when write_enable = '1' else
                  atual_pc;

end a_incrementa_pc ; 
