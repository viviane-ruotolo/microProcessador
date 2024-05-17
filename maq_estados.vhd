library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
   port
   (    clock, reset: in std_logic;
        estado_out: out unsigned(1 downto 0)
   );
end entity;

architecture a_maq_estados of maq_estados is
   signal estado_s: unsigned(1 downto 0);

begin
   process(clock, reset)
   begin
      if reset='1' then
         estado_s <= "00";
      elsif rising_edge(clock) then
         if estado_s="11" then        -- se agora esta em 3
            estado_s <= "00";         -- o prox vai voltar ao zero
         else
            estado_s <= estado_s+1;   -- senao avanca
         end if;
      end if;
   end process;

   estado_out <= estado_s;
end architecture;
