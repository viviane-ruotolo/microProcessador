library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port( 
        clock: in std_logic;
        endereco: in unsigned(6 downto 0);
        dado: out unsigned(15 downto 0) 
   );
end entity;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0  => "0000000000000010",
        1  => "1000000000100000",
        2  => "0000011001000000",
        3  => "0000000011000000",
        4  => "0000100000000000",
        5  => "0000000000000010",
        6  => "1111000000000011",
        7  => "0000000000001010",
        8  => "0000101000000010",
        9  => "0011000000000000",
        10 => "0000000100001000",
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
    );
    
begin

    process(clock)
    begin
        if(rising_edge(clock)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;