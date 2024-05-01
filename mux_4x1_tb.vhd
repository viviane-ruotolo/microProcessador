library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1_tb is
end;

architecture a_mux_4x1_tb of mux_4x1_tb is
    component mux_4x1
        port(
            sel_op: in unsigned(1 downto 0);
            op0: in unsigned(15 downto 0);
            op1: in unsigned(15 downto 0);
            op2: in unsigned(15 downto 0);
            op3: in unsigned(15 downto 0); 
            saida: out unsigned(15 downto 0)            
        );
    end component;

    signal sel_op : unsigned(1 downto 0);
    signal op0, op1, op2, op3, saida : unsigned (15 downto 0);

    begin 
        op0 <= "0000000000000000";
        op1 <= "0000000000000001";
        op2 <= "0000000000000010";
        op3 <= "0000000000000011";

        uut: mux_4x1 port map(sel_op => sel_op, op0 => op0, op1 => op1, op2 => op2, op3 => op3, saida => saida);

        process
        begin 
            sel_op <= "00";
            wait for 50 ns;
            sel_op <= "01";
            wait for 50 ns;
            sel_op <= "10";
            wait for 50 ns;
            sel_op <= "11";
            wait for 50 ns;
            wait;
        end process;
    end architecture;

