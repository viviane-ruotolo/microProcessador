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
        0  => "0011000000000010",
        1  => "1111000000000100",
        2  => "0011011001000000",
        3  => "1111000000000110",
        4  => "0011100000000001",
        5  => "1111000000000010",
        6  => "1111000000001000",
        7  => "0011000000001010",
        8  => "0011101000000010",
        9  => "0011000000000000",
        10 => "0011000100001000",
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