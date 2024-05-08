library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
    port(
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        estado_in: in std_logic;
        estado_out: out std_logic
    );
end entity;

architecture a_maq_estados of maq_estados is
    signal estado: std_logic;
    
begin
    process(clock, reset, write_enable)
    begin
        if reset = '1' then 
            estado <= '0';
        elsif write_enable = '1' then   
            if rising_edge(clock) then
                estado <= not estado;
            end if;
        end if;
    end process;
                                
    estado_out <= estado;
end architecture;