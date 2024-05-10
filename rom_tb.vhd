library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
    end;

architecture a_rom_tb of rom_tb is
    component rom
        port( 
            clock: in std_logic;
            endereco: in unsigned(6 downto 0);
            dado: out unsigned(15 downto 0) 
        );
    end component;

    constant time_period: time := 100 ns;
    signal finished: std_logic := '0';
    signal clk: std_logic;
    signal endereco_i: unsigned(6 downto 0);
    signal dado_o: unsigned(15 downto 0);

begin
    utt: rom port map(clock => clk, endereco => endereco_i, dado => dado_o);

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

    process
    begin
        endereco_i <= "0000000";
        wait for time_period * 2;
        endereco_i <= "0000010";
        wait for time_period * 2;
        endereco_i <= "0001010";
        wait for time_period * 2;
        endereco_i <= "0000011";
        wait for time_period * 2;
        endereco_i <= "0000100";
        wait;
    end process;
end architecture;