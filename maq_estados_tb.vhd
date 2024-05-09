library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados_tb is
    end;

architecture a_maq_estados_tb of maq_estados_tb is
    component maq_estados
        port(
            clock: in std_logic;
            reset: in std_logic;
            estado_out: out std_logic
        );
    end component;

    constant time_period: time := 100 ns;
    signal finished : std_logic := '0';
    signal clk, reset: std_logic;
    signal estado_s: std_logic;


begin
        utt: maq_estados port map(clock => clk, reset => reset, estado_out => estado_s);

        reset_global: process
        begin
            reset <= '0';
            wait for time_period * 8;
            reset <= '1';
            wait for time_period * 2;
            reset <= '0';
            wait;
        end process;

    sim_time_proc: process
    begin
        wait for 1 us;
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



end architecture;