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
        0  => B"0101_0001_00000011",
        1  => B"0101_0010_00001000",
        2  => B"0101_0011_00000011",
        3  => B"0101_0100_00010100",
        4  => B"1000_0001_0011_0000",
        5  => B"1000_0010_0100_0000",
        6  => B"0110_1000_0001_0000",
        7  => B"0010_1000_0010_0000",
        8  => B"0110_0101_1000_0000",
        9  => B"0101_0110_00011110",
        10 => B"1000_0101_0110_0000",
        11 => B"0010_1000_0110_0000",
        12 => B"1001_0111_0110_0000",
        13 => B"1001_0010_0011_0000",
        14 => B"1001_0001_0100_0000",
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