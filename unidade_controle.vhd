library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        destino, source: out unsigned(3 downto 0);
        op_ula: out unsigned(1 downto 0);
        cte: out unsigned(8 downto 0)
        write_en_acu: out std_logic;
        write_en_bregs: out std_logic;
        sel_regs_ou_cte_para_ula: out std_logic; -- seleciona no mux o dado para a ULA (cte ou registrador)
        sel_data_cte_ou_regs_acu_ula: out unsigned(1 downto 0); -- seleciona se vai escrever um dado da constante ou de registrador/acumulador
    );
end entity;

architecture a_unidade_controle of unidade_controle is 

    component rom is
        port( 
            clock: in std_logic;
            endereco: in unsigned(6 downto 0);
            dado: out unsigned(15 downto 0) 
        );
    end component;

    component program_counter is
        port(
            clock: in std_logic;
            write_enable: in std_logic;
            reset: in std_logic;
            data_in: in unsigned(6 downto 0);
            data_out: out unsigned(6 downto 0)
        );
    end component;
    
    component maq_estados is
        port(
            clock: in std_logic;
            reset: in std_logic;
            estado_out: out std_logic
        );
    end component;

    component incrementa_pc is 
    port(
        atual_pc: in unsigned(6 downto 0);
        write_enable: in std_logic;
        proximo_pc: out unsigned(6 downto 0)
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

    signal atual_pc, data_out_pc: unsigned(6 downto 0);
    signal wr_en_incrementa: std_logic;
    signal estado_s: unsigned(1 downto 0);
    signal dado_rom_s, instrucao: unsigned(15 downto 0);
    signal opcode: unsigned(15 downto 0);
    signal end_instrucao: unsigned(6 downto 0);
    signal proximo_pc, incrementado_pc: unsigned(6 downto 0);
    signal write_en_pc, write_en_reg_inst, jump_en, nop_en: std_logic;

begin 

    pc: program_counter port map (clock => clock, write_enable => write_en_pc, reset => reset, data_in => proximo_pc, data_out => atual_pc);

    rom_uc: rom port map (clock => clock, endereco => atual_pc, dado => dado_rom_s);
    
    -- leitura da ROM no estado 0 (fetch) e a atualização do PC no estado 1(decode/execute)
    m_estados: maq_estados port map (clock => clock, reset => reset, estado_out => estado_s);

    inc_pc: incrementa_pc port map(atual_pc => atual_pc, write_enable => wr_en_incrementa, proximo_pc => incrementado_pc);
    
    wr_en_incrementa <= estado_s and (not jump_en);
    
    reg_instrucao: registrador port map(clock <= clock, reset <= reset, write_enable <= write_en_reg_inst, data_in <= dado_rom_s, data_out <= instrucao);

    reg_opcode: registrador port map (clock <= clock, reset <= reset, write_enable <= write_en_reg_op, data_in <= "0000000000000" & instrucao(15 downto 13), data_out <= opcode);

    write_en_reg_inst <= '1' when estado_s = "00" else
                    '0';

    write_en_pc <= '1' when estado_s = "11" else
                    '0';

    write_en_reg_op <= '1' when estado_s = "01" else
                    '0';

    end_instrucao <= instrucao(12 downto 6);
    destino <= instrucao(12 downto 9);
    source <= instrucao(12 downto 9) when opcode(2 downto 0) = "011" or opcode(2 downto 0) = "101" else
              instrucao(8 downto 5);
    cte <= instrucao(8 downto 0); 
    
    jump_en <=  '1' when opcode(2 downto 0) ="001" else
    '0';

    -- Não sabemos o que fazer com o nop
    nop_en <=  '1' when opcode(2 downto 0) ="0011" else
    '0';

    op_ula <= "00" when opcode(2 downto 0) ="010" else 
              "01" when opcode(2 downto 0) ="011" else
              "00";

    proximo_pc <= end_instrucao when jump_en = '1' else 
                  incrementado_pc;
    
    write_en_acu <= '1' when estado_s = "10" and destino = "1000" and (opcode(2 downto 0) = "010" or opcode(2 downto 0) = "100" or opcode(2 downto 0) ="110") else 
                    '1' when estado_s = "10" and source = "1000" and (opcode(2 downto 0) ="011" or opcode(2 downto 0) ="101") else 
                    '0';

    write_en_bregs <= '1' when estado_s = "10" and destino /= "1000" and (opcode(2 downto 0) = "010" or opcode(2 downto 0) = "100" or opcode(2 downto 0) ="110") else 
                      '1' when estado_s = "10" and source /= "1000" and (opcode(2 downto 0) ="011" or opcode(2 downto 0) ="101") else 
                      '0'; 
    -- 0 cte - 1 regs
    -- seleciona no mux o dado para a ULA (cte ou registrador)
    sel_regs_ou_cte_para_ula <= '0' when estado_s = "10" and opcode(2 downto 0) ="011" else
                                '1';
    
    -- seleciona se vai escrever um dado da constante ou de registrador/acumulador
    -- 00 (cte) - 01 (regs) - 10 (ula) - 11 (acu)
    sel_data_cte_ou_regs_acu <= "00" when estado_s = "10" and opcode(2 downto 0) ="101" else
                                "01" when estado_s = "10" and opcode(2 downto 0) ="110" and source /= "1000" else 
                                "10" when estado_s = "10" and (opcode(2 downto 0) ="010" or opcode(2 downto 0) ="100" or opcode(2 downto 0) ="011") else 
                                "11" when estado_s = "10" and opcode(2 downto 0) ="110" and source = "1000" else
                                "00"; 
           

end architecture;
