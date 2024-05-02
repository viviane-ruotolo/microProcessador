library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_tb is
end entity;

architecture a_banco_regs_tb of banco_regs_tb is

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
    
    constant time_period : time := 100 ns; -- Periodo do clock
    signal finished : std_logic := '0';
    signal clk, reset, write_en : std_logic;
    signal write_d, read_regs_out: unsigned(15 downto 0);
    signal read_r, write_r: unsigned(2 downto 0);
    
begin 
        uut: banco_regs port map (read_regs_1 => read_r, write_data => write_d, write_regs => write_r, write_enable => write_en, clock => clk, reset => reset, read_regs_out => read_regs_out);

        sim_time_proc: process
        begin
            wait for 6 us; -- tempo total da simulação (60 períodos)
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
            wait for time_period * 2;
            write_en <= '0';
            
            -- escreve em todos os registradores    
            wait for time_period * 2;
            write_en <= '1';
            write_d <= "0000000000000001";
            write_r <= "001";
            wait for time_period * 2;
            write_d <= "0000000000000010";
            write_r <= "010";
            wait for time_period * 2;
            write_d <= "0000000000000011";
            write_r <= "011";
            wait for time_period * 2;
            write_d <= "0000000000000100";
            write_r <= "100";
            wait for time_period * 2;
            write_d <= "0000000000000101";
            write_r <= "101";
            wait for time_period * 2;
            write_d <= "0000000000000110";
            write_r <= "110";
            wait for time_period * 2;
            write_d <= "0000000000000111";
            write_r <= "111";
            wait for time_period * 2;
    
            -- testar se não vai escrever com enable - '0'
            write_en <= '0';
            write_r <= "001";
            write_d <= "0000000000001111";
            wait for time_period;
    
            -- testar leitura de todos os registradores
            read_r <= "001";
            wait for time_period * 2;
            read_r <= "010";
            wait for time_period * 2;
            read_r <= "011";
            wait for time_period * 2;
            read_r <= "100";
            wait for time_period * 2;
            read_r <= "101";
            wait for time_period * 2;
            read_r <= "110";
            wait for time_period * 2;
            read_r <= "111";
            wait for time_period * 2;
            
            -- resetar todos os registradores
            reset <= '1';
            wait for time_period * 2;
            reset<=  '0';
            wait for time_period * 3;
            
            -- Ler tudo para conferir se foram resetados
            read_r <= "001";
            wait for time_period * 2;
            read_r <= "010";
            wait for time_period * 2;
            read_r <= "011";
            wait for time_period * 2;
            read_r <= "100";
            wait for time_period * 2;
            read_r <= "101";
            wait for time_period * 2;
            read_r <= "110";
            wait for time_period * 2;
            read_r <= "111";
            wait for time_period * 2;
        end process;
end architecture;

