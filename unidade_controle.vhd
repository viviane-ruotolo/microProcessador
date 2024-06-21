library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        overflow: in std_logic;
        zero: in std_logic;
        negative: in std_logic;
        destino, source: out unsigned(3 downto 0);
        op_ula: out unsigned(1 downto 0);
        cte: out unsigned(11 downto 0);
        write_en_acu: out std_logic;
        write_en_bregs: out std_logic;
        write_en_flags: out std_logic;
        wr_en_reg_end_ram: out std_logic;
        wr_en_ram: out std_logic;
        finished: out std_logic;
        sel_data_ram_para_regs: out std_logic;
        sel_regs_ou_cte_para_ula: out std_logic; -- seleciona no mux o dado para a ULA (cte ou registrador)
        sel_data_cte_ou_regs_acu_ula: out unsigned(1 downto 0) -- seleciona se vai escrever um dado da constante ou de registrador/acumulador
    );
end entity;

architecture a_unidade_controle of unidade_controle is 

    component rom is
        port( 
            clock: in std_logic;
            endereco: in unsigned(6 downto 0);
            dado: out unsigned(19 downto 0) 
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
            estado_out: out unsigned(2 downto 0)
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

    component calcula_salto_relativo is 
    port(
        atual_pc: in unsigned(6 downto 0);
        delta: in unsigned(6 downto 0);
        write_enable: in std_logic;
        proximo_pc: out unsigned(6 downto 0)
    );
    end component;

    component registrador_instrucao is
        port(
            clock: in std_logic;
            reset: in std_logic;
            write_enable: in std_logic;
            instrucao: in unsigned(19 downto 0);
            estado: in unsigned(2 downto 0);
            opcode: in unsigned(3 downto 0);
            data_in_reg_op: out unsigned(15 downto 0);
            data_in_reg_funct: out unsigned(15 downto 0);
            end_instrucao: out unsigned(6 downto 0);
            cte: out unsigned(11 downto 0);
            delta_salto: out unsigned(6 downto 0);
            destino: out unsigned(3 downto 0);
            source: out unsigned(3 downto 0)
        );
    end component;

    signal atual_pc, data_out_pc: unsigned(6 downto 0);
    signal wr_en_incrementa, cond_satisfeita: std_logic;
    signal estado_s: unsigned(2 downto 0);
    signal dado_rom_s: unsigned(19 downto 0);
    signal opcode, data_in_reg_op, data_in_reg_funct, cond_function_s: unsigned(15 downto 0);
    signal end_instrucao, delta_salto: unsigned(6 downto 0);
    signal proximo_pc, incrementado_pc, salto_rel_pc: unsigned(6 downto 0);
    signal write_en_pc, write_en_reg_inst, write_en_reg_op, jump_en_ab, jump_en_rel, nop_en, wr_en_calc_salto: std_logic;
    signal destino_s, source_s, reg_s: unsigned(3 downto 0);

begin 

    pc: program_counter port map (clock => clock, write_enable => write_en_pc, reset => reset, data_in => proximo_pc, data_out => atual_pc);

    rom_uc: rom port map (clock => clock, endereco => atual_pc, dado => dado_rom_s);
    
    m_estados: maq_estados port map (clock => clock, reset => reset, estado_out => estado_s);

    inc_pc: incrementa_pc port map(atual_pc => atual_pc, write_enable => wr_en_incrementa, proximo_pc => incrementado_pc);
    
    calcula_salto: calcula_salto_relativo port map(atual_pc => atual_pc, delta => delta_salto, write_enable => wr_en_calc_salto, proximo_pc => salto_rel_pc);
    
    reg_instrucao: registrador_instrucao port map(clock => clock, reset => reset, write_enable => write_en_reg_inst, instrucao => dado_rom_s, estado => estado_s, 
                                                  opcode => opcode(3 downto 0), data_in_reg_op => data_in_reg_op, data_in_reg_funct => data_in_reg_funct, end_instrucao => end_instrucao, 
                                                  cte => cte, delta_salto => delta_salto, destino => destino_s, source => source_s);

    reg_opcode: registrador port map (clock => clock, reset => reset, write_enable => write_en_reg_op, data_in => data_in_reg_op, data_out => opcode);

    reg_cond_funct: registrador port map(clock => clock, reset => reset, write_enable => write_en_reg_op, data_in => data_in_reg_funct, data_out => cond_function_s);
    
    wr_en_incrementa <= '1' when estado_s = "010" and jump_en_ab = '0' and jump_en_rel = '0' else
                        '0';
    
    wr_en_calc_salto <= '1' when estado_s = "010" and jump_en_ab = '0' and jump_en_rel = '1' else
                        '0';

    write_en_reg_inst <= '1' when estado_s = "000" else
                    '0';

    write_en_pc <= '1' when estado_s = "010" else
                    '0';

    write_en_reg_op <= '1' when estado_s = "001" else
                    '0';

    wr_en_reg_end_ram <= '1' when estado_s = "011" and (opcode(3 downto 0) = "1000" or opcode(6 downto 0) = "1001") else 
                         '0';
    
    wr_en_ram <= '1' when estado_s = "100" and opcode(3 downto 0) = "1000" else 
                 '0';
    
    -- VER SE ALTERA AS FLAGS CERTAS COM OPERAÇÕES NA ULA
    -- TALVEZ DEVIA TER UMA CONDIÇÃO PARA O ESTADO 11 ----------------------------------------------------------
    -- Altera as flags se tiver no estado 10 e for operaçao da ula: CMP, ADD, SUB, SUBI 
    write_en_flags <= '1' when estado_s = "010" and (opcode(3 downto 0) = "0111" or opcode(3 downto 0) =  "0010" or opcode(3 downto 0) = "0100" or opcode(3 downto 0) = "00011")  else
                      '0';

    write_en_acu <= '1' when estado_s = "011" and destino_s = "1000" and (opcode(3 downto 0) = "0010" or opcode(3 downto 0) = "0100" or opcode(3 downto 0) ="0110" or opcode(3 downto 0) ="1010" or opcode(3 downto 0) ="1011") else 
                    '1' when estado_s = "011" and source_s = "1000" and (opcode(3 downto 0) ="0011" or opcode(3 downto 0) ="0101") else 
                    '1' when estado_s = "100" and destino_s = "1000" and opcode(3 downto 0) = "1001" else
                    '0';
  
      
    write_en_bregs <= '1' when estado_s = "011" and destino_s /= "1000" and (opcode(3 downto 0) = "0010" or opcode(3 downto 0) = "0100" or opcode(3 downto 0) ="0110" or opcode(3 downto 0) ="1011") else 
                      '1' when estado_s = "011" and source_s /= "1000" and (opcode(3 downto 0) ="0011" or opcode(3 downto 0) ="0101") else 
                      '1' when estado_s = "100" and destino_s /= "1000" and opcode(3 downto 0) = "1001" else
                      '0'; 

    jump_en_ab <=  '1' when estado_s = "010" and opcode(3 downto 0) ="0001" and cond_function_s(2 downto 0) = "000" else
                        '0';
     
    -- Só se a condição for satisfeita
    jump_en_rel <= '1' when estado_s = "010" and opcode(3 downto 0) = "0001" and cond_function_s(2 downto 0) /= "000" and cond_satisfeita = '1' else
                        '0';  
     
    nop_en <=  '1' when opcode(3 downto 0) ="0000" else
                     '0';
    
    finished <= '1' when opcode(3 downto 0) = "1111" and estado_s = "011" else 
                '0';
    
    -- Condição: tem que ser testada no estado 01, para fazer o salto no estado 10
    cond_satisfeita <= '1' when cond_function_s(2 downto 0) = "001" and zero = '1' else -- BEQ
                       '1' when cond_function_s(2 downto 0) = "010" and (negative xor overflow) = '0' else -- BGE
                       '1' when cond_function_s(2 downto 0) = "011" and zero = '0' and (negative xor overflow) = '0' else -- BGT
                       '1' when cond_function_s(2 downto 0) = "100" and (negative xor overflow) = '1' else -- BLT
                       '1' when cond_function_s(2 downto 0) = "101" and zero = '0' else -- BNE
                       '0'; 

    op_ula <= "00" when opcode(3 downto 0) ="0010" else -- add
              "01" when opcode(3 downto 0) ="0011" or opcode(3 downto 0) = "0111" or opcode(3 downto 0) = "0100" else -- Quando for SUBI ou CMP
              "10" when opcode(3 downto 0) ="1010" else --and
              "11" when opcode(3 downto 0) ="1011" else -- not
              "00";

    proximo_pc <= end_instrucao when jump_en_ab = '1' else 
                  salto_rel_pc when jump_en_rel = '1' else  
                  incrementado_pc;

    sel_data_ram_para_regs  <= '1' when estado_s = "100" and opcode(6 downto 0) = "1001" else 
                               '0';

    -- seleciona no mux o dado para a ULA (cte (0) ou registrador(1))
    sel_regs_ou_cte_para_ula <= '0' when estado_s = "011" and opcode(3 downto 0) ="0011" else
                                '1';
    
    -- seleciona se vai escrever um dado da constante, registrador, acumulador ou ula
    -- 00 (cte) - 01 (regs) - 10 (ula) - 11 (acu)
    sel_data_cte_ou_regs_acu_ula <= "00" when estado_s = "011" and opcode(3 downto 0) ="0101" else
                                "01" when estado_s = "011" and opcode(3 downto 0) ="0110" and source_s /= "1000" else 
                                "10" when estado_s = "011" and (opcode(3 downto 0) ="0010" or opcode(3 downto 0) ="0100" or opcode(3 downto 0) ="0011" or opcode(3 downto 0) ="1010" or opcode(3 downto 0) ="1011") else 
                                "11" when estado_s = "011" and opcode(3 downto 0) ="0110" and source_s = "1000" else
                                "00";            
    
    destino <= destino_s;
    source <= source_s;
end architecture;
