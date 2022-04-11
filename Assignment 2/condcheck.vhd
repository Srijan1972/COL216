library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity condcheck is
    port(
        cond      :in std_logic_vector(3 downto 0);
        flags_reg :in std_logic_vector(3 downto 0); -- NZCV
        E         :out std_logic);
end condcheck;

architecture behavior of condcheck is
begin
    process(cond,flags_reg) is
    begin
        case cond is
            when "0000" => if flags_reg(2)='1' then E <= '1'; else E <= '0'; end if;
            when "0001" => if flags_reg(2)='0' then E <= '1'; else E <= '0'; end if;
            when "0010" => if flags_reg(1)='1' then E <= '1'; else E <= '0'; end if;
            when "0011" => if flags_reg(1)='0' then E <= '1'; else E <= '0'; end if;
            when "0100" => if flags_reg(3)='1' then E <= '1'; else E <= '0'; end if;
            when "0101" => if flags_reg(3)='0' then E <= '1'; else E <= '0'; end if;
            when "0110" => if flags_reg(0)='1' then E <= '1'; else E <= '0'; end if;
            when "0111" => if flags_reg(0)='0' then E <= '1'; else E <= '0'; end if;
            when "1000" => if flags_reg(1)='1' and flags_reg(2)='0' then E <= '1'; else E <= '0'; end if;
            when "1001" => if flags_reg(1)='0' or flags_reg(2)='1' then E <= '1'; else E <= '0'; end if;
            when "1010" => if flags_reg(3)=flags_reg(0) then E <= '1'; else E <= '0'; end if;
            when "1011" => if flags_reg(3)/=flags_reg(0) then E <= '1'; else E <= '0'; end if;
            when "1100" => if flags_reg(3)=flags_reg(0) and flags_reg(2)='0' then E <= '1'; else E <= '0'; end if;
            when "1101" => if flags_reg(3)/=flags_reg(0) or flags_reg(2)='1' then E <= '1'; else E <= '0'; end if;
            when others => E <= '1';
        end case;
    end process;
end behavior;