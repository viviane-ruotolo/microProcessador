library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_8x1_tb is
end;

architecture a_mux_8x1_tb of mux_8x1_tb is
    component mux_8x1
        port(
            sel_op: in unsigned(2 downto 0);
            op0: in unsigned(15 downto 0);
            op1: in unsigned(15 downto 0);
            op2: in unsigned(15 downto 0);
            op3: in unsigned(15 downto 0); 
            op4: in unsigned(15 downto 0); 
            op5: in unsigned(15 downto 0);
            op6: in unsigned(15 downto 0);
            op7: in unsigned(15 downto 0);
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
        op4 <= "0000000000000100";
        op5 <= "0000000000000101";
        op6 <= "0000000000000110";
        op7 <= "0000000000000111";
        
        uut: mux_8x1 port map(sel_op => sel_op, op0 => op0, op1 => op1, op2 => op2, op3 => op3, op4 => op4, op5 => op5, op6 => op6, op7 => op7, saida => saida);

        process
        begin 
            sel_op <= "000";
            wait for 50 ns;
            sel_op <= "001";
            wait for 50 ns;
            sel_op <= "010";
            wait for 50 ns;
            sel_op <= "011";
            wait for 50 ns;
            sel_op <= "100";
            wait for 50 ns;
            sel_op <= "101";
            wait for 50 ns;
            sel_op <= "110";
            wait for 50 ns;
            sel_op <= "111";
            wait for 50 ns;
            wait;
        end process;
    end architecture;

