library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
   port
   (    clock, reset: in std_logic;
        estado_out: out unsigned(2 downto 0)
   );
end entity;

architecture a_maq_estados of maq_estados is
   signal estado_s: unsigned(2 downto 0);

begin
   process(clock, reset)
   begin
      if reset='1' then
         estado_s <= "000";
      elsif rising_edge(clock) then
         if estado_s="100" then        -- se esta em 4
            estado_s <= "000";         -- o prox vai voltar ao zero
         else
            estado_s <= estado_s+1;   -- senao avanca
         end if;
      end if;
   end process;

   estado_out <= estado_s;
end architecture;

-- Estado 0: Fetch
-- Estado 1: Decode
-- Estado 2: PC
-- Estado 3: Execute / Read reg for ram op
-- Estado 4: Write ram / Write regs 