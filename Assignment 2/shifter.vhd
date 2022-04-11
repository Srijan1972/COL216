library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter is
    port(
        operand:in std_logic_vector(31 downto 0);
        shift_length:in std_logic_vector(4 downto 0);
        shift_type:in std_logic_vector(1 downto 0);
        csout:out std_logic;
        operand2:out std_logic_vector(31 downto 0));
end entity;

architecture behavior of shifter is
begin
    process(operand,shift_length,shift_type) is
    begin
        case shift_type is
            when "00" => 
                operand2 <= to_stdlogicvector(to_bitvector(operand) sll to_integer(unsigned(shift_length)));
                if shift_length = "00000" then csout <= '0';
                else csout <= operand(to_integer(unsigned(not(shift_length))));
                end if;
            when "01" =>
                operand2 <= to_stdlogicvector(to_bitvector(operand) srl to_integer(unsigned(shift_length)));
                csout <= operand(to_integer(unsigned(shift_length)));
            when "10" =>
                operand2 <= to_stdlogicvector(to_bitvector(operand) sra to_integer(unsigned(shift_length)));
                csout <= operand(to_integer(unsigned(shift_length)));
            when "11" =>
                operand2 <= to_stdlogicvector(to_bitvector(operand) ror to_integer(unsigned(shift_length)));
                csout <= operand(to_integer(unsigned(shift_length)));
            when others => operand2 <= (others => 'X');
        end case;
    end process;
end behavior;