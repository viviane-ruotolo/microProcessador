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
            write_in_regs: in unsigned(2 downto 0);
            selec_op_ula: in unsigned(1 downto 0);
            write_regs_data: in unsigned(15 downto 0);
            result_tl: out unsigned(15 downto 0)
        );
    end component;

    constant time_period : time := 100 ns; -- Periodo do clock
    signal finished : std_logic := '0';
    signal clk, reset: std_logic;
    signal sel_regs_cte, write_en_br, write_en_acu: std_logic; -- seleciona no mux o dado para a ULA (cte ou registrador)
    signal read_regs, write_in_regs: unsigned(2 downto 0);
    signal selec_op_ula: unsigned(1 downto 0);
    signal write_regs_data, cte, result_tl: unsigned(15 downto 0);
        
begin 
        uut: top_level port map (cte => cte, clock => clk, reset => reset, sel_regs_cte => sel_regs_cte, write_en_br => write_en_br, write_en_acu => write_en_acu, read_regs => read_regs, write_in_regs => write_in_regs, selec_op_ula => selec_op_ula, write_regs_data => write_regs_data, result_tl => result_tl);

        sim_time_proc: process
        begin
            wait for 2 us; -- tempo total da simulação (10 períodos)
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
            -- tempo inicial
            write_en_br <= '0';
            write_en_acu <= '0';
            reset <= '0';
            sel_regs_cte <= '0';
            reset <= '1';
            wait for time_period * 2;

            -- escreve em algum registrador e na constante
           reset <= '0';
            wait for time_period * 2;
            write_en_br <= '1';
            write_en_acu <= '0';
            cte <= "0000000000001111"; -- F
            write_in_regs <= "010"; -- 
            --selec_op_ula <= "00"; -- soma
            -- escreve no reg 2 -> o valor 3
            write_regs_data <= "0000000000000011";
            
            -- lê o registrador
            wait for time_period;
            write_en_br <= '0';
            read_regs <= "010";

            -- testa se registrador ou cte vai pra ula e permite escrita no acumulador
            wait for time_period;
            sel_regs_cte <= '1'; -- Registrador
            write_en_acu <= '1';
            selec_op_ula <= "00"; -- soma

            -- Recebe resultado da ula e faz outra operação
            wait for time_period;
            write_en_br <= '0';
            write_en_acu <= '0';
            selec_op_ula <= "01"; -- sub

            -- testa se registrador ou cte vai pra ula e permite escrita no acumulador
            wait for time_period;
            sel_regs_cte <= '0'; -- Constante
            write_en_acu <= '1';

            -- Recebe resultado da ula e finaliza teste
            wait for time_period;
            write_en_br <= '0';
            write_en_acu <= '0';
            wait for time_period;

            wait;
        end process;
end architecture;
