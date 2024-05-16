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
        0  => B"101_0011_000000101",
        1  => B"101_0100_000001000",
        2  => B"110_1000_0011_00000",
        3  => B"010_1000_0100_00000",
        4  => B"110_0101_1000_00000",
        5  => B"011_1000_000000001",
        6  => B"110_0101_1000_00000",
        7  => B"001_0010100_000000",
        8  => B"101_0101_000000000",
        9  => "0011000000000000",
        10 => "0011000100001000",
        20 => B"110_1000_0101_00000",
        21 => B"110_0011_1000_00000",
        22 => B"001_0000010_000000",
        23 => B"101_0011_000000000",
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