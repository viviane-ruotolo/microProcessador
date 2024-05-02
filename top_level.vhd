library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        cte : in unsigned(15 downto 0);
        result: out unsigned(15 downto 0)

    );
end entity;

architecture a_top_level of top_level is
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
    
    component ula_16bits
        port(
            entrada0: in unsigned(15 downto 0);
            entrada1: in unsigned(15 downto 0);
            selec_op: in unsigned(1 downto 0);
            resultado: out unsigned(15 downto 0)
        );
    end component;
    
    component registrador is
        port(
            clock: in std_logic;
            reset: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

component mux_2x1
    port(
        sel_op: in std_logic;
        op0: in unsigned(15 downto 0);
        op1: in unsigned(15 downto 0);
        saida: out unsigned(15 downto 0)            
    );
end component;
    
begin

end architecture;