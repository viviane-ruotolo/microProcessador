library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter_tb is
    end;

architecture a_program_counter_tb of program_counter_tb is
    component program_counter
        port(
            clock: in std_logic;
            write_enable: in std_logic;
            reset: in std_logic;
            data_in: in unsigned(6 downto 0);
            data_out: out unsigned(6 downto 0)
        );
    end component;
    constant time_period : time := 100 ns; -- Periodo do clock
    signal finished : std_logic := '0';
    signal clk, reset: std_logic;
    signal data_i, data_o: unsigned(6 downto 0);
        
begin 
        uut: program_counter port map (clock => clk, write_enable => '1', reset => reset, data_in => data_i, data_out => data_o);

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
            data_i <= "0001111";
            

            wait for time_period * 2;
            
            data_i <= "0000001";
            
            wait for time_period * 2;
            
            data_i <= "0010000";

            wait;
        end process;
end architecture;
