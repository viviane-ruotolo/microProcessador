library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_tb is
end entity;

architecture a_registrador_tb of registrador_tb is

    component registrador is
        port(
            clock: in std_logic;
            reset: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    constant time_period : time := 100 ns; -- Periodo do clock
    signal finished : std_logic := '0';
    signal clk, reset, write_en : std_logic;
    signal data_in, data_out: unsigned(15 downto 0);
        
begin 
        uut: registrador port map (clock => clk, reset => reset, write_enable => write_en, data_in => data_in, data_out => data_out);
        
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
        -- reseta aqui 
        
        -- write_en = '0' --> data_out = 0
        -- write_en = '1' --> data_out = F
        -- data_out = 0x10
        -- escreve no rising_edge do clock
        -- reset = '1' --> data_out = 0
        end process;
end architecture;
