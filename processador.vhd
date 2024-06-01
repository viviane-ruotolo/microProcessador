library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        regs_out: out unsigned(15 downto 0);
        acu_out: out unsigned(15 downto 0);
        ula_out: out unsigned(15 downto 0) -- pegar estado e pc tbm e instrucao
    );
end entity;

architecture a_processador of processador is

    component unidade_controle is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        overflow: in std_logic;
        zero: in std_logic;
        negative: in std_logic;
        destino, source: out unsigned(3 downto 0);
        op_ula: out unsigned(1 downto 0);
        cte: out unsigned(8 downto 0);
        write_en_acu: out std_logic;
        write_en_bregs: out std_logic;
        write_en_flags: out std_logic;
        sel_regs_ou_cte_para_ula: out std_logic; -- seleciona no mux o dado para a ULA (cte ou registrador)
        sel_data_cte_ou_regs_acu_ula: out unsigned(1 downto 0) -- seleciona se vai escrever um dado da constante ou de registrador/acumulador
    );
    end component;

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
            resultado: out unsigned(15 downto 0);
            carry: out std_logic;
            overflow: out std_logic;
            zero: out std_logic;
            negative: out std_logic
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

    component registrador_std_logic is
        port(
            clock: in std_logic;
            reset: in std_logic;
            write_enable: in std_logic;
            data_in: in std_logic;
            data_out: out std_logic
        );
    end component;
    
    signal read_regs_out, write_regs_data, resultado_ula, data_ula1, data_ula2 : unsigned(15 downto 0);
    signal write_acu, cte_16bits: unsigned(15 downto 0) := "0000000000000000"; 
    signal destino, source: unsigned(3 downto 0);
    signal op_ula: unsigned(1 downto 0);
    signal cte: unsigned(8 downto 0);
    signal write_en_acu, carry_in, overflow_in, carry_out, overflow_out, zero_in, zero_out: std_logic;
    signal write_en_bregs, negative_out, negative_in, write_en_flags_s: std_logic;
    signal sel_regs_ou_cte_para_ula: std_logic; -- seleciona no mux o dado para a ULA (cte ou registrador)
    signal sel_data_cte_ou_regs_acu_ula: unsigned(1 downto 0); -- seleciona se vai escrever um dado da constante ou de registrador/acumulador

begin
    
    un_controle: unidade_controle port map (clock => clock, reset => reset, overflow => overflow_out, zero => zero_out, negative => negative_out, destino => destino, source => source, op_ula => op_ula, cte => cte, write_en_acu => write_en_acu, write_en_bregs => write_en_bregs, write_en_flags => write_en_flags_s, sel_regs_ou_cte_para_ula => sel_regs_ou_cte_para_ula, sel_data_cte_ou_regs_acu_ula => sel_data_cte_ou_regs_acu_ula);

    banco_r: banco_regs port map (read_regs_1 => source(2 downto 0), write_data => write_regs_data, write_regs => destino(2 downto 0), write_enable => write_en_bregs, clock => clock, reset => reset, read_regs_out => read_regs_out);
 
    mux_regs_cte: mux_2x1 port map (sel_op => sel_regs_ou_cte_para_ula, op0 => cte_16bits, op1 => read_regs_out, saida => data_ula1);

    acumulador: registrador port map (clock => clock, reset => reset, write_enable => write_en_acu, data_in => write_acu, data_out => data_ula2);

    ula: ula_16bits port map (entrada0 => data_ula1, entrada1 => data_ula2, selec_op => op_ula, resultado => resultado_ula, carry => carry_in, overflow => overflow_in, zero => zero_in, negative => negative_in);
    
    carry_flag: registrador_std_logic port map (clock => clock, reset => reset, write_enable => write_en_flags_s, data_in => carry_in, data_out => carry_out);

    overflow_flag: registrador_std_logic port map (clock => clock, reset => reset, write_enable => write_en_flags_s, data_in => overflow_in, data_out => overflow_out);
    
    negative_flag: registrador_std_logic port map(clock => clock, reset => reset, write_enable => write_en_flags_s, data_in => negative_in, data_out  => negative_out);
    
    zero_flag: registrador_std_logic port map(clock => clock, reset => reset, write_enable => write_en_flags_s, data_in => zero_in, data_out => zero_out);
    
    cte_16bits <= "0000000" & cte;
    
    -- seleciona se vai escrever um dado da constante ou de registrador/acumulador
    -- 00 (cte) - 01 (regs) - 10 (ula) - 11 (acu)
    write_acu <= cte_16bits when sel_data_cte_ou_regs_acu_ula = "00" else
                 read_regs_out when sel_data_cte_ou_regs_acu_ula = "01" else
                 resultado_ula when sel_data_cte_ou_regs_acu_ula = "10" else
                 write_acu when sel_data_cte_ou_regs_acu_ula = "11" else
                 "0000000000000000";
    
    write_regs_data <= cte_16bits when sel_data_cte_ou_regs_acu_ula = "00" else
                       read_regs_out when sel_data_cte_ou_regs_acu_ula = "01" else
                       data_ula2 when sel_data_cte_ou_regs_acu_ula = "11" else
                       write_regs_data when sel_data_cte_ou_regs_acu_ula = "10" else
                       "0000000000000000"; 
    
    regs_out <= read_regs_out;
    acu_out <= data_ula2;
    ula_out <= resultado_ula;

end architecture; 