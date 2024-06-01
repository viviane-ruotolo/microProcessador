library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_std_logic is
    port(
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic
    );
end entity;

architecture a_registrador_std_logic of registrador_std_logic is
    signal registro: std_logic;
    
begin
    process(clock, reset, write_enable)
    begin
        if reset = '1' then 
            registro <= '0';
        elsif write_enable = '1' then   
            if rising_edge(clock) then
                registro <= data_in;
            end if;
        end if;
    end process;
                                
    data_out <= registro;
end architecture;