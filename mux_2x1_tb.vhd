library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1_tb is
end;

architecture a_mux_2x1_tb of mux_2x1_tb is
    component mux_2x1
        port(
            sel_op: in std_logic;
            op0: in unsigned(15 downto 0);
            op1: in unsigned(15 downto 0);
            saida: out unsigned(15 downto 0)            
        );
    end component;

    signal sel_op : std_logic;
    signal op0, op1, saida : unsigned (15 downto 0);

    begin 
        op0 <= "0000000000000001";
        op1 <= "0000000000000010";

        uut: mux_2x1 port map(sel_op => sel_op, op0 => op0, op1 => op1, saida => saida);

        process
        begin 
            sel_op <= '0';
            wait for 50 ns;
            sel_op <= '1';
            wait for 50 ns;
            wait;
        end process;
    end architecture;

