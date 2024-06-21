library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_instrucao is
    port(
        clock: in std_logic;
        reset: in std_logic;
        write_enable: in std_logic;
        instrucao: in unsigned(19 downto 0);
        estado: in unsigned(2 downto 0);
        opcode: in unsigned(3 downto 0);
        data_in_reg_op: out unsigned(15 downto 0);
        data_in_reg_funct: out unsigned(15 downto 0);
        end_instrucao: out unsigned(6 downto 0);
        cte: out unsigned(11 downto 0);
        delta_salto: out unsigned(6 downto 0);
        destino: out unsigned(3 downto 0);
        source: out unsigned(3 downto 0)
    );
end entity;

architecture a_registrador_instrucao of registrador_instrucao is
    signal instrucao_s: unsigned(19 downto 0);
    signal source_s, pointer_s: unsigned(3 downto 0);
    
begin
    process(clock, reset, write_enable)
    begin
        if reset = '1' then 
            instrucao_s <= "00000000000000000000";
        elsif write_enable = '1' then   
            if rising_edge(clock) then
                instrucao_s <= instrucao;
            end if;
        end if;
    end process;
                                
    data_in_reg_op <= "000000000000" & instrucao_s(19 downto 16);
    data_in_reg_funct <= "0000000000000" & instrucao_s(5 downto 3);
    end_instrucao <= instrucao_s(15 downto 9);
    destino <= instrucao_s(15 downto 12);
    cte <= instrucao_s(11 downto 0); 
    delta_salto <= instrucao_s(15 downto 9);

    source_s <= instrucao_s(15 downto 12) when opcode = "0011" or opcode = "0101" or opcode = "1000" else
              instrucao_s(11 downto 8);
    pointer_s <= instrucao_s(11 downto 8);
    
    -- chuto que era pro CMP, mas não precisou
    --acu_s <= destino_s;
    --reg_s <= source_s;
    source <= pointer_s when estado = "011" and (opcode = "1000" or opcode = "1001") else              
              source_s;

end architecture;