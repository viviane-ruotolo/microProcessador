library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_16bits_tb is
end;

architecture a_ula_16bits_tb of ula_16bits_tb is
    component ula_16bits
        port(
            entrada0: in unsigned(15 downto 0);
            entrada1: in unsigned(15 downto 0);
            selec_op: in unsigned(1 downto 0);
            resultado: out unsigned(15 downto 0)
        );
    end component;

    signal entrada0, entrada1, resultado : unsigned (15 downto 0);
    signal selec_op: unsigned (1 downto 0);
    
    begin 

        entrada0 <= "0000000000000111";
        entrada1 <= "0000000000000001";

        uut: ula_16bits port map(entrada0 => entrada0, entrada1 => entrada1, selec_op => selec_op, resultado => resultado);

        process
        begin
            selec_op <= "00";
            wait for 50 ns;
            selec_op <= "01";
            wait for 50 ns;
            selec_op <= "10";
            wait for 50 ns;
            selec_op <= "11";
            wait for 50 ns;
            wait;
        end process;
    end architecture;

