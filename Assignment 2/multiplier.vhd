library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier is
    port(
        mulop1:in std_logic_vector(31 downto 0);
        mulop2:in std_logic_vector(31 downto 0);
        mulacc:in std_logic_vector(63 downto 0);
        mulres:out std_logic_vector(63 downto 0);
        U:in std_logic;
        A:in std_logic);
end entity;

architecture behavior of multiplier is
begin
    process(U,A,mulop1,mulop2,mulacc)
    begin
        if A='0' and U='0' then mulres <= std_logic_vector(signed(mulop1) * signed(mulop2));
        elsif A='0' and U='1' then mulres <= std_logic_vector(unsigned(mulop1) * unsigned(mulop2));
        elsif A='1' and U='0' then mulres <= std_logic_vector((signed(mulop1) * signed(mulop2)) + signed(mulacc));
        else mulres <= std_logic_vector((unsigned(mulop1) * unsigned(mulop2)) + unsigned(mulacc));
        end if;
    end process;
end behavior;