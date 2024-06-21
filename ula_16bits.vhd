library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_16bits is
    port(
        entrada0: in unsigned(15 downto 0);
        entrada1: in unsigned(15 downto 0);
        selec_op: in unsigned(1 downto 0);
        resultado: out unsigned(15 downto 0);
        carry: out std_logic;
        overflow: out std_logic;
        zero: out std_logic;
        negative: out std_logic
    );
end entity;

architecture  a_ula_16bits of ula_16bits is

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

    signal carry_soma, carry_sub, overflow_soma, overflow_sub, neg_soma, neg_sub: std_logic;
    signal entrada0_17, entrada1_17, sub_17, soma_17: unsigned(16 downto 0);
    signal op_and, op_not, resultado_s: unsigned(15 downto 0); -- Resultado de cada operaçao
    begin
    
    -- Entrada 1: acumulador 
    -- Entrada 0: Registrador
    entrada0_17 <= '0' & entrada0;
    entrada1_17 <= '0' & entrada1;

    soma_17 <= entrada0_17 + entrada1_17;
    sub_17 <= entrada1_17 - entrada0_17; -- (A - R)
    op_and <= entrada0 and entrada1;
    op_not <= not entrada1;

    carry_soma <= soma_17(16);
    carry_sub <= sub_17(16);

    -- entrada0 + entrada1 (A + B)
    overflow_soma <= (entrada0_17(16) and entrada1_17(16) and not soma_17(16)) or
                     (not entrada0_17(16) and not entrada1_17(16) and soma_17(16));
    
    --Entrada1 - entrada0 (B - A)                 
    overflow_sub <= (entrada1_17(16) and not entrada0_17(16) and not sub_17(16)) or
                    (not entrada1_17(16) and entrada0_17(16) and sub_17(16));
    
    carry <= carry_soma when selec_op = "00" else 
             carry_sub when selec_op = "01" else
            '0';
    
    overflow <= overflow_soma when selec_op = "00" else
                overflow_sub when selec_op = "01" else
                '0';

    zero <= '1' when resultado_s = "0000000000000000" else
            '0';

    negative <= resultado_s(15);
    
    stage1: mux_4x1 port map(sel_op => selec_op, op0 => soma_17(15 downto 0), op1 => sub_17(15 downto 0), op2 => op_and, op3 => op_not, saida => resultado_s);

    resultado <= resultado_s;
end architecture;

    
    