library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is
    port(
        read_regs_1: in unsigned(3 downto 0);
        write_data: in unsigned(15 downto 0);
        write_regs: in unsigned(3 downto 0);
        write_enable: in std_logic;
        clock: in std_logic;
        reset: in std_logic;
        read_regs_out: out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_regs of banco_regs is
    component registrador is
        port(
            clock: in std_logic;
            reset: in std_logic;
            write_enable: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;


    component mux_8x1 is 
    port(
        sel_op: in unsigned(2 downto 0);
        op0: in unsigned(15 downto 0);
        op1: in unsigned(15 downto 0);
        op2: in unsigned(15 downto 0);
        op3: in unsigned(15 downto 0);
        op4: in unsigned(15 downto 0); 
        op5: in unsigned(15 downto 0);
        op6: in unsigned(15 downto 0);
        op7: in unsigned(15 downto 0);
        saida: out unsigned(15 downto 0)
        );
    end component;
    
    signal result0 : unsigned(15 downto 0) := "0000000000000000";
    signal result1, result2, result3,  result4, result5, result6, result7, resultF: unsigned(15 downto 0);
    signal enable0, enable1, enable2, enable3, enable4, enable5, enable6, enable7, enableF: std_logic := '0'; 

begin
    regs0: registrador port map(clock => clock, reset => reset, write_enable => enable0, data_in => write_data, data_out => result0);
    regs1: registrador port map(clock => clock, reset => reset, write_enable => enable1, data_in => write_data, data_out => result1);
    regs2: registrador port map(clock => clock, reset => reset, write_enable => enable2, data_in => write_data, data_out => result2);
    regs3: registrador port map(clock => clock, reset => reset, write_enable => enable3, data_in => write_data, data_out => result3);
    regs4: registrador port map(clock => clock, reset => reset, write_enable => enable4, data_in => write_data, data_out => result4);
    regs5: registrador port map(clock => clock, reset => reset, write_enable => enable5, data_in => write_data, data_out => result5);
    regs6: registrador port map(clock => clock, reset => reset, write_enable => enable6, data_in => write_data, data_out => result6);
    regs7: registrador port map(clock => clock, reset => reset, write_enable => enable7, data_in => write_data, data_out => result7);
    regs9: registrador port map(clock => clock, reset => reset, write_enable => enableF, data_in => write_data, data_out => resultF);

    enable1 <= '1' when write_enable = '1' and write_regs = "0001" else
                '0';

    enable2 <= '1' when write_enable = '1' and write_regs = "0010" else
                '0';
                
    enable3 <= '1' when write_enable = '1' and write_regs = "0011" else
                  '0';

    enable4 <= '1' when write_enable = '1' and write_regs = "0100" else
                  '0';
      
    enable5 <= '1' when write_enable = '1' and write_regs = "0101" else
                  '0';
                      
    enable6 <= '1' when write_enable = '1' and write_regs = "0110" else
                  '0';
    
    enable7 <= '1' when write_enable = '1' and write_regs = "0111" else
                  '0';

    enableF <= '1' when write_enable = '1' and write_regs = "1111" else
                  '0';                  
    
    --mux_result: mux_8x1 port map(sel_op => read_regs_1, op0 => result0, op1 => result1, op2 => result2, op3 => result3,
    --                             op4 => result4, op5 => result5, op6 => result6, op7 => result7, saida => read_regs_out);

    read_regs_out <=result0 when read_regs_1 = "0000" else
                    result1 when read_regs_1 = "0001" else
                    result2 when read_regs_1 = "0010" else
                    result3 when read_regs_1 = "0011" else
                    result4 when read_regs_1 = "0100" else
                    result5 when read_regs_1 = "0101" else
                    result6 when read_regs_1 = "0110" else
                    result7 when read_regs_1 = "0111" else
                    resultF when read_regs_1 = "1111" else
                    "0000000000000000";
end architecture;