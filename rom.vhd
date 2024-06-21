library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port( 
        clock: in std_logic;
        endereco: in unsigned(6 downto 0);
        dado: out unsigned(19 downto 0) 
   );
end entity;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(19 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0  => B"0101_0001_000000000001", -- LD R1, 1
        1  => B"0101_0010_100000000000", -- LD R2, 2048 
        2  => B"0101_0011_000000000000", -- LD R3, 0 ---------------------- COMEÇAR EM ZERO
        
        -- ESCREVE_RAM
        3  => B"0110_1000_0011_00000000",  -- MOV A, R3
        4  => B"1000_0011_0011_00000000",  -- SW R3, (R3)
        5  => B"0010_1000_0001_00000000",  -- ADD A, R1
        6  => B"0110_0011_1000_00000000",  -- MOV R3, A
        8  => B"1010_1000_0010_00000000",  -- AND A, R2
        9  => B"0111_1000_0000_00000000",  -- CMP A, R0
        10 => B"0001_1111001_000_001_000", -- BEQ ESCREVE_RAM (addr -7)
        
        11 => B"0101_0011_000000000010", -- LD R3, 2 
        12 => B"0101_0010_000000101101", -- LD R2, 45
        
        -- LOOP_EXCLUI_MULTIPLOS
        13 => B"1001_0100_0011_00000000",  -- LW R4, (R3)
        14 => B"0110_1000_0100_00000000",  -- MOV A, R4
        15 => B"0111_1000_0000_00000000",  -- CMP A, R0
        16 => B"0001_0100010_000_101_000", -- BNE EH_PRIMO (addr +34)
        
        -- INCREMENTA_J
        17 => B"0110_1000_0011_00000000",  -- MOV A, R3
        18 => B"0010_1000_0001_00000000",  -- ADD A, R1
        19 => B"0110_0011_1000_00000000",  -- MOV R3, A
        22 => B"0111_1000_0010_00000000",  -- CMP A, R2
        23 => B"0001_1110110_000_100_000", -- BLT LOOP_EXCLUI_MULTIPLOS (-10)

        25 => B"0101_0011_000000000000", -- LD R3, 0
        26 => B"0110_1000_0011_00000000",  -- MOV A, R3
        27 => B"0101_0010_100000000000", -- LD R2, 2048
                
        -- MOSTRA_RESULTADO
        28 => B"0101_0101_011101010010",  -- LD R5, 11101010010
        29 => B"0110_1000_0011_00000000",  -- MOV A, R3
        30 => B"1001_0110_0011_00000000",  -- LW R6, (R3)
        31 => B"0010_1000_0001_00000000",  -- ADD A, R1
        32 => B"0110_0011_1000_00000000",  -- MOV R3, A
        33 => B"0110_0100_0110_00000000",  -- MOV R4, R6
        34 => B"0110_1000_0110_00000000",  -- MOV A, R6
        35 => B"0101_1111_000000011011",  -- LD RF, 27
        36 => B"0111_1000_0000_00000000", -- CMP A, R0
        37 => B"0001_0000110_000_001_000", -- BEQ INCREMENTA_DIVISOR (addr 6)
        38 => B"0001_0101001_000_101_000", -- BNE CALCULA_MODULO_RESULTADO (addr 41)
        
        -- CONTINUA_RESULTADO
        39 => B"0110_1000_0101_00000000",  -- MOV A, R5
        40 => B"0111_1000_0000_00000000",  -- CMP A, R0
        41 => B"0001_0000010_000_101_000", -- BNE INCREMENTA_DIVISOR (addr 41)
        42 => B"0110_0111_0100_00000000",  -- MOV R7, R4 -- Se o resto for zero, mostra o divisor
        
        -- INCREMENTA_DIVISOR
        43 => B"0110_1000_0011_00000000",  -- MOV A, R3
        44 => B"1010_1000_0010_00000000",  -- AND A, R2
        45 => B"0111_1000_0000_00000000",  -- CMP A, R0
        46 => B"0001_1101110_000_001_000", -- BEQ MOSTRA_RESULTADO (addr -18)
        
        47 => B"1111_0000000000000000",  -- END
        
        -- EXCLUI_MULTIPLO
        48 => B"1000_0000_0110_00000000",  -- SW R0, (R6) //Escreve zero no endereço (R6) da ram
        49 => B"0001_0111100_000_000_000", -- B INCREMENTA_NUMBER (ABS 60)
        
        -- EH_PRIMO
        50 => B"0110_1000_0100_00000000",  -- MOV A, R4
        51 => B"0010_1000_0001_00000000",  -- ADD A, R1
        52 => B"0110_0110_1000_00000000",  -- MOV R6, A
        53 => B"0101_0010_100000000000", -- LD R2, 2048
        
        -- PROCURA_MULTIPLOS
        54 => B"0110_0101_0110_00000000",  -- MOV R5, R6
        55 => B"0101_1111_000000110010", -- LD RF, 50
        56 => B"0001_1000101_000_000_000", -- B CALCULA_MODULO (ABS 69)
        
        -- CONTINUA_MULTIPLO
        57 => B"0110_1000_0101_00000000",  -- MOV A, R5 -- Se o resto for zero, exclui
        58 => B"0111_1000_0000_00000000",  -- CMP A, R0
        59 => B"0001_1110101_000_001_000", -- BEQ EXCLUI_MULTIPLO (addr 48)
        
        -- INCREMENTA_NUMBER
        60 => B"0110_1000_0110_00000000",  -- MOV A, R6
        61 => B"0010_1000_0001_00000000",  -- ADD A, R1
        62 => B"0110_0110_1000_00000000",  -- MOV R6, A
        64 => B"1010_1000_0010_00000000",  -- AND A, R2
        65 => B"0111_1000_0000_00000000",  -- CMP A, R0
        66 => B"0001_1110100_000_001_000", -- BEQ PROCURA_MULTIPLOS (addr 54)
        67 => B"0101_0010_000000101101", -- LD R2, 45
        68 => B"0001_0010001_000_000_000", -- B INCREMENTA_J (ABS 17)
        
        -- CALCULA_MODULO
        69 => B"0110_1000_0101_00000000",  -- MOV A, R5
        70 => B"0111_1000_0100_00000000",  -- CMP A, R4
        71 => B"0001_0000100_000_100_000", -- BLT ENCONTRA_DESTINO (addr +4)
        72 => B"0100_1000_0100_00000000",  -- SUB A, R4
        73 => B"0110_0101_1000_00000000",  -- MOV R5, A
        74 => B"0001_1000101_000_000_000", -- B CALCULA_MODULO (ABS 69)
        
        -- ENCONTRA_DESTINO
        75 => B"0101_1000_000000011011", -- LD A, 27
        76 => B"0111_1000_1111_00000000",  -- CMP A, RF
        77 => B"0001_1011010_000_001_000", -- BEQ CONTINUA_RESULTADO (addr -38)
        78 => B"0001_0111001_000_000_000", -- B CONTINUA_MULTIPLO (addr 57)

        -- CALCULA_MODULO_RESULTADO
        79 => B"0111_1000_0001_00000000", -- CMP A, R1
        80 => B"0001_1110101_000_101_000", -- BNE CALCULA_MODULO (addr -11)        
        81 => B"0001_0101011_000_000_000", -- B INCREMENTA_DIVISOR (abs 43)

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