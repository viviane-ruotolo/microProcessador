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
        0  => B"101_0011_000000000",
        1  => B"101_0100_000000000",
        2  => B"101_0010_000000001",
        3  => B"110_1000_0011_00000",
        4  => B"010_1000_0100_00000",
        5  => B"110_0100_1000_00000",
        6  => B"110_1000_0011_00000",
        7  => B"010_1000_0010_00000",
        8  => B"110_0011_1000_00000",
        9  => B"101_1000_000011110",
        10 => B"111_1000_0011_00000",
        11 => B"001_1111000_011_000",
        12 => B"110_0101_0100_00000",
        13 => B"000_0000000_000000",
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