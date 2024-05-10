library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidade_controle_tb is 
end;

architecture a_unidade_controle_tb of unidade_controle_tb is
    component unidade_controle is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        data_out: out unsigned(15 downto 0)
    );
    end component;

    constant time_period : time := 100 ns; -- Periodo do clock
    signal clock_s, reset_s, finished, inicio: std_logic;
    signal data_out_s: unsigned(15 downto 0);
begin 

    uut: unidade_controle port map(clock => clock_s, reset => reset_s, data_out => data_out_s);

    sim_time_proc: process
    begin
        wait for 1 us; -- tempo total da simulação (10 períodos)
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clock_s <= '0';
            wait for time_period/2;
            clock_s <= '1';
            wait for time_period/2;
        end loop;
        wait;
    end process clk_proc;
    
    process
    begin
        inicio <= '1';
        wait for time_period;
        inicio <= '0';
        wait for 9 * time_period;
        wait;
    end process;

end architecture;