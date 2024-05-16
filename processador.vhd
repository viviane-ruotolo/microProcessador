library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        instrucao: out unsigned(15 downto 0);
        registrador: out unsigned(15 downto 0);
        acumulador: out unsigned(15 downto 0);
        ula_out: out unsigned(15 downto 0);
        estado: out unsigned(2 downto 0);
        pc: out unsigned(6 downto 0);
    );
end entity;

architecture a_processador of processador is

    component unidade_controle is 
    port(
        clock: in std_logic;
        reset: in std_logic;
        destino, source: out unsigned(3 downto 0);
        cte: out unsigned(8 downto 0)
    );
    end component;
    signal teste: std_logic;

begin

end architecture; 