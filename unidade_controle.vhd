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
            reset: in std_logic;
            write_enable: in std_logic;
            end_in: in unsigned(6 downto 0);
            end_out: out unsigned(6 downto 0)
        );
    end component;

    signal proximo_pc, atual_pc: unsigned(6 downto 0)  := "0000000";

begin 
    
    pc: program_counter port map (clock => clock, reset => reset, write_enable => '1', end_in => proximo_pc, end_out => atual_pc);

    proximo_pc <= atual_pc + "0000001";

    rom_uc: rom port map (clock => clock, endereco => atual_pc, dado => data_out);

end architecture;
