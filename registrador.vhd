library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador is
    port(
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        data_in: in unsigned(15 downto 0);
        data_out: out unsigned(15 downto 0);
    );
end entity;

architecture a_registrador of registrador is
    signal registro: unsigned(15 downto 0);
    
begin
    process(clock, reset, write_enable)
    begin
        if reset = '1' then 
            registro <= "0000000000000000";
        elsif write_enable = '1' then   
            if rising_edge(clock) then
                registro <= data_in;
            end if;
        end if;
    end process;
                                
    data_out <= registro;
end architecture;