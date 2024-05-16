library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is 
end;

architecture a_processador_tb of processador_tb is
    component processador is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        regs_out: out unsigned(15 downto 0);
        acu_out: out unsigned(15 downto 0);
        ula_out: out unsigned(15 downto 0)
    );
    end component;

    constant time_period : time := 100 ns; -- Periodo do clock
    signal clock_s, reset_s, finished: std_logic;
    signal regs_out, acu_out, ula_out: unsigned(15 downto 0);
begin 

    uut: processador port map(clock => clock_s, reset => reset_s, regs_out => regs_out, acu_out => acu_out, ula_out => ula_out);

    sim_time_proc: process
    begin
        wait for 4 us; -- tempo total da simulação (10 períodos)
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
        reset_s <= '1';
        wait for 2 * time_period;
        reset_s <= '0';
        wait for 8 * time_period;
        wait;
    end process;

end architecture;