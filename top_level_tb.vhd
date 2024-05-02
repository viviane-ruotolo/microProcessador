library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end;

architecture a_top_level_tb of top_level_tb is

    component top_level is
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
    end component;

    constant time_period : time := 100ns; -- Periodo do clock
    signal finished : std_logic := '0';
    signal clk, reset, write_en : std_logic;
    signal data_in, data_out: unsigned(15 downto 0);
    signal cte: in unsigned(15 downto 0);
    signal sel_regs_cte, write_en_br, write_en_acu: in std_logic; -- seleciona no mux o dado para a ULA (cte ou registrador)
    signal read_regs, write_regs: in unsigned(2 downto 0);
    write_regs: in unsigned (2 downto 0);
    selec_op_ula: in unsigned(1 downto 0);
    write_regs: in unsigned(15 downto 0);
    result_tl: out unsigned(15 downto 0)
        
begin 
        uut: top_level port map (clock => clk, reset => reset, write_enable => write_en, data_in => data_in, data_out => data_out);
        
        reset_global: process
        begin 
            wait for time_period * 8;
            reset <= '1';
            wait for time_period * 2;
            reset <= '0';
            wait;
        end process;

        sim_time_proc: process
        begin
            wait for 1 us; -- tempo total da simulação (10 períodos)
            finished <= '1';
            wait;
        end process sim_time_proc;

        clk_proc: process
        begin
            while finished /= '1' loop
                clk <= '0';
                wait for time_period/2;
                clk <= '1';
                wait for time_period/2;
            end loop;
            wait;
        end process clk_proc;
        
        process 
        begin 
        data_in <= "0000000000001111";
        
        wait for time_period * 2;
        write_en <= '0';
        wait for time_period * 2;
        write_en <= '1';
        wait for time_period * 2;
        data_in <= "0000000000010000";
        wait for time_period * 2;
        
        -- tempo inicial
        wait for time_period * 2;
        write_en <= '0';

        -- escreve em algum registrador e no acumulador
        
        -- lê o registrador
        -- testa se registrador ou cte vai pra ula
        -- lê o acumulador e vai pra ula
        -- realiza operação x na ula 
        -- lê o acumulador com o resultado
        end process;
end architecture;

{