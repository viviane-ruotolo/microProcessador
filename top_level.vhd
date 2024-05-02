library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        cte: in unsigned(15 downto 0);
        clock: in std_logic;
        reset: in std_logic;
        sel_regs_cte: in std_logic; -- seleciona no mux o dado para a ULA (cte ou registrador)
        write_en_br: in std_logic;
        write_en_acu: in std_logic;
        read_regs: in unsigned(2 downto 0);
        write_regs: in unsigned (2 downto 0);
        selec_op_ula: in unsigned(1 downto 0);
        write_regs: in unsigned(15 downto 0);
        result_tl: out unsigned(15 downto 0)
    );
end entity;

architecture a_top_level of top_level is
    component banco_regs is
        port(
            read_regs_1: in unsigned(2 downto 0);
            write_data: in unsigned(15 downto 0);
            write_regs: in unsigned(2 downto 0);
            write_enable: in std_logic;
            clock: in std_logic;
            reset: in std_logic;
            read_regs_out: out unsigned(15 downto 0)
        );
    end component;
    
    component ula_16bits
        port(
            entrada0: in unsigned(15 downto 0);
            entrada1: in unsigned(15 downto 0);
            selec_op: in unsigned(1 downto 0);
            resultado: out unsigned(15 downto 0)
        );
    end component;
    
    component registrador is
        port(
            clock: in std_logic;
            reset: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

component mux_2x1
    port(
        sel_op: in std_logic;
        op0: in unsigned(15 downto 0);
        op1: in unsigned(15 downto 0);
        saida: out unsigned(15 downto 0)            
    );
end component;
    
    signal read_regs_out, data_ula1, data_ula2 : unsigned(15 downto 0);
    signal write_acu: unsigned(15 downto 0) := "0000000000000000";
begin

    banco_r: banco_regs port map (read_regs_1 => read_regs, write_data => write_data, write_regs => write_regs, write_enable => write_en_br, clock => clock, reset => reset, read_regs_out => read_regs_out);
 
    mux_regs_cte: mux_2x1 port map (sel_op => sel_regs_cte, op0 => cte, op1 => read_regs_out, saida => data_ula1);

    acumulador: registrador port map (clock => clock, reset => reset, write_enable => write_en_acu, data_in => write_acu, data_out => data_ula2);

    ula: ula_16bits port map (entrada0 => data_ula1, entrada1 => data_ula2, selec_op => selec_op_ula, resultado => write_acu);

    result_tl <= write_acu;


end architecture;