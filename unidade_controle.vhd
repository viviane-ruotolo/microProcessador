library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        data_out: out unsigned(15 downto 0)
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

    signal atual_pc, data_out_pc: unsigned(6 downto 0);
    signal estado_s, wr_en_incrementa: std_logic;
    signal dado_rom_s, instrucao: unsigned(15 downto 0);
    signal opcode: unsigned(3 downto 0);
    signal end_instrucao, proximo_pc, incrementado_pc: unsigned(6 downto 0);
    signal write_en_pc, jump_en, nop_en: std_logic;

begin 

    pc: program_counter port map (clock => clock, write_enable => write_en_pc, reset => reset, data_in => proximo_pc, data_out => atual_pc);

    rom_uc: rom port map (clock => clock, endereco => atual_pc, dado => dado_rom_s);
    
    -- leitura da ROM no estado 0 (fetch) e a atualização do PC no estado 1(decode/execute)
    m_estados: maq_estados port map (clock => clock, reset => reset, estado_out => estado_s);

    inc_pc: incrementa_pc port map(atual_pc => atual_pc, write_enable => wr_en_incrementa, proximo_pc => incrementado_pc);
    
    wr_en_incrementa <= estado_s and (not jump_en);
    
    -- Trocar pelo registrador de instruçao
    instrucao <= dado_rom_s when estado_s = '0' else
                 instrucao when estado_s = '1' else   
                "0000000000000000";

    write_en_pc <= '1' when estado_s = '1' else
                    '0' when estado_s = '0' else 
                    '0';

    -- jumps (1111), nop (0011) 
    opcode <= instrucao(15 downto 12);
    end_instrucao <= instrucao(6 downto 0);
    
    jump_en <=  '1' when opcode="1111" else
    '0';

    -- Não sabemos o que fazer com o nop
    nop_en <=  '1' when opcode="0011" else
    '0';

    proximo_pc <= end_instrucao when jump_en = '1' else 
                  incrementado_pc;
    
    data_out <= instrucao;
 

end architecture;
