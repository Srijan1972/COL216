library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registers is
    port(
        r_add1     :in std_logic_vector(3 downto 0);
        r_add2     :in std_logic_vector(3 downto 0);
        w_add      :in std_logic_vector(3 downto 0);
        data_in    :in std_logic_vector(31 downto 0);
        w_en       :in std_logic;
        clock      :in std_logic;
        data_out1  :out std_logic_vector(31 downto 0);
        data_out2  :out std_logic_vector(31 downto 0));
end registers;

architecture behavior of registers is
    type reg_array is array (0 to 15) of std_logic_vector(31 downto 0);
    signal regs: reg_array:=(others => (others => '0'));
begin
    data_out1 <= regs(to_integer(unsigned(r_add1)));
    data_out2 <= regs(to_integer(unsigned(r_add2)));
    write_proc: process(clock,w_en)
    begin
        if(rising_edge(clock) and w_en='1') then
            regs(to_integer(unsigned(w_add))) <= data_in;
        end if;
    end process write_proc;
end behavior;