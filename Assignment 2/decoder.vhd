library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
    port(
        Instr:in std_logic_vector(31 downto 0);
        cond:out std_logic_vector(3 downto 0);
        F:out std_logic_vector(1 downto 0);
        I:out std_logic;
        opcodedp:out std_logic_vector(3 downto 0);
        S:out std_logic;
        Rn:out std_logic_vector(3 downto 0);
        Rd:out std_logic_vector(3 downto 0);
        rot:out std_logic_vector(3 downto 0);
        imm:out std_logic_vector(7 downto 0);
        shift:out std_logic_vector(7 downto 0);
        Rm:out std_logic_vector(3 downto 0);
        opcodedt:out std_logic_vector(5 downto 0);
        offset:out std_logic_vector(11 downto 0);
        L:out std_logic_vector(1 downto 0);
        address:out std_logic_vector(23 downto 0));
end entity;

architecture behavior of decoder is
begin
    process(Instr) is
    begin
        cond <= Instr(31 downto 28);
        F <= Instr(27 downto 26);
        I <= Instr(25);
        opcodedp <= Instr(24 downto 21);
        S <= Instr(20);
        Rn <= Instr(19 downto 16);
        Rm <= Instr(3 downto 0);
        Rd <= Instr(15 downto 12);
        rot <= Instr(11 downto 8);
        imm <= Instr(7 downto 0);
        shift <= Instr(11 downto 4);
        opcodedt <= Instr(25 downto 20);
        offset <= Instr(11 downto 0);
        L <= Instr(25 downto 24);
        address <= Instr(23 downto 0);
    end process;
end behavior;