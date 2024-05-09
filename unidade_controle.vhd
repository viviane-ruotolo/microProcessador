library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        data_out: in unsigned(15 downto 0)
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
            end_in: in unsigned(6 downto 0);
            end_out: out unsigned(6 downto 0)
        );
    end component;
    
    component maq_estados is
        port(
            clock: in std_logic;
            reset: in std_logic;
            estado_out: out std_logic
        );
    end component;

    signal proximo_pc, atual_pc: unsigned(6 downto 0)  := "0000000";
    signal estado_s: std_logic;
    signal dado_rom_s, instrucao: unsigned(15 downto 0);
    signal opcode: unsigned(3 downto 0);
    signal end_instrucao: unsigned(6 downto 0);

begin 

    -- Já poderia alterar o enable nesse lab pra fazer as alterações finais da uc?
    pc: program_counter port map (clock => clock, write_enable => '1', end_in => proximo_pc, end_out => atual_pc);

    rom_uc: rom port map (clock => clock, endereco => atual_pc, dado => dado_rom_s);

    -- leitura da ROM no estado 0 (fetch) e a atualização do PC no estado 1
(decode/execute)
    m_estados: maq_estados port map (clock => clock, reset => reset, estado_out => estado);

    instrucao <= dado_rom_s when estado = '0' else
                "0000000000000000";

    proximo_pc <= atual_pc + "0000001" when estado = '1' else
                  atual_pc when estado = '0' else 
                  "0000000";

    -- Arrumar dados da memória para fazer jumps e loops
    opcode <= instrucao(15 downto 12);
    end_instrucao <= instrucao(6 downto 0);
    
end architecture;
