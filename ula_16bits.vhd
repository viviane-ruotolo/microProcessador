library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_16bits is
    port(
        entrada0: in unsigned(15 downto 0);
        entrada1: in unsigned(15 downto 0);
        selec_op: in unsigned(1 downto 0);
        resultado: out unsigned(15 downto 0)
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

    signal soma, sub, op_and, op_or: unsigned(15 downto 0); -- Resultado de cada operaçao
    begin
    
    soma <= entrada0 + entrada1;
    sub <= entrada0 - entrada1;
    op_and <= entrada0 and entrada1;
    op_or <= entrada0 or entrada1;

    stage1: mux_4x1 port map(sel_op => selec_op, op0 => soma, op1 => sub, op2 => op_and, op3 => op_or, saida => resultado);
end architecture;

    
    