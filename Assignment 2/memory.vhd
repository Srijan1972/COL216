library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
    port(
        addr     :in std_logic_vector(7 downto 0);
        w_en     :in std_logic_vector(3 downto 0);
        clock    :in std_logic;
        data_in  :in std_logic_vector(31 downto 0);
        data_out :out std_logic_vector(31 downto 0);
        mode     :in std_logic);
end memory;

architecture behavior of memory is
    type mem_array is array (0 to 255) of std_logic_vector(31 downto 0);
    signal mem: mem_array:=(0 => X"EA000006",2 => X"EA00000C",8 => X"E3A0EC02",9 => X"E6000011",16 => X"E3A00004",17 => X"E5900000",18 => X"E6000011",128 => X"E3A00002",129 => X"E3A01004",130 => X"E1500001",131 => X"0A000002",132 => X"C0400001",133 => X"B0411000",134 => X"EAFFFFFA",135 => X"E3E02000",others => X"00000000");
begin
    data_out <= mem(to_integer(unsigned(addr))) when (((not mode) and addr(7)) or mode)='1' else X"00000000";
    writing: process(clock)
    begin
        if rising_edge(clock) then
            if w_en(3)='1' and (((not mode) and addr(7)) or mode)='1' then mem(to_integer(unsigned(addr)))(31 downto 24) <= data_in(31 downto 24); end if;
            if w_en(2)='1' and (((not mode) and addr(7)) or mode)='1' then mem(to_integer(unsigned(addr)))(23 downto 16) <= data_in(23 downto 16); end if;
            if w_en(1)='1' and (((not mode) and addr(7)) or mode)='1' then mem(to_integer(unsigned(addr)))(15 downto 8) <= data_in(15 downto 8); end if;
            if w_en(0)='1' and (((not mode) and addr(7)) or mode)='1' then mem(to_integer(unsigned(addr)))(7 downto 0) <= data_in(7 downto 0); end if;
        end if;
    end process writing;
end behavior;
