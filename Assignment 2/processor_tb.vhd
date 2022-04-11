library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processor_tb is
end processor_tb;

architecture testbench of processor_tb is
component processor is
    port(
        clock:in std_logic;
        rst:in std_logic;
        ext_data:in std_logic_vector(7 downto 0);
        status:in std_logic);
end component;
    signal clock:std_logic:='0';
    signal rst:std_logic:='0';
    signal ext_data:std_logic_vector(7 downto 0):=x"AC";
    signal status:std_logic:='0';
begin
    processor_test:processor port map(clock,rst,ext_data,status);
    status <= '1' after 100 ns;
    c:process is
    begin
        for i in 0 to 49 loop
        wait for 0.5 ns;
        clock <= not clock;
        wait for 0.5 ns;
        clock <= not clock;
        end loop;
        wait;
    end process c;
    r:process is
    begin
        wait for 50 ns;
        rst <= '1';
        wait;
    end process r;
end architecture;