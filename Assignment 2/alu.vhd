library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        cin    :in std_logic;
        cout   :out std_logic;
        op1    :in std_logic_vector(31 downto 0);
        op2    :in std_logic_vector(31 downto 0);
        opcode :in std_logic_vector(3 downto 0);
        res    :out std_logic_vector(31 downto 0));
end alu;

architecture behavior of alu is
    signal temp_reg:std_logic_vector(32 downto 0);
begin
    cout <= temp_reg(32);
    res <= temp_reg(31 downto 0);
    data_proc:process(cin,op1,op2,opcode)
    begin
        case opcode is
            when "0000" => -- and
                temp_reg(31 downto 0) <= op1 and op2;
                temp_reg(32) <= cin;
            when "0001" => -- eor
                temp_reg(31 downto 0) <= op1 xor op2;
                temp_reg(32) <= cin;
            when "0010" => -- sub
                temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & not(op2)) + 1);
            when "0011" => -- rsb
                temp_reg <= std_logic_vector(signed('0' & op2) + signed('0' & not(op1)) + 1);
            when "0100" => -- add
                temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & op2));
            when "0101" => -- adc
                if cin='1' then temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & op2) + 1);
                else temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & op2));
                end if;
            when "0110" => --sbc
                if cin='0' then temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & not(op2)));
                else temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & not(op2)) + 1);
                end if;
            when "0111" => --rsc
                if cin='0' then temp_reg <= std_logic_vector(signed('0' & op2) + signed('0' & not(op1)));
                else temp_reg <= std_logic_vector(signed('0' & op2) + signed('0' & not(op1)) + 1);
                end if;
            when "1000" => -- tst
                temp_reg(31 downto 0) <= op1 and op2;
                temp_reg(32) <= cin;
            when "1001" => -- teq
                temp_reg(31 downto 0) <= op1 xor op2;
                temp_reg(32) <= cin;
            when "1010" => -- cmp
                temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & not(op2)) + 1);
            when "1011" => -- cmn
                temp_reg <= std_logic_vector(signed('0' & op1) + signed('0' & op2));
            when "1100" => -- orr
                temp_reg(31 downto 0) <= op1 or op2;
                temp_reg(32) <= cin;
            when "1101" => -- mov
                temp_reg(31 downto 0) <= op2;
                temp_reg(32) <= cin;
            when "1110" => -- bic
                temp_reg(31 downto 0) <= op1 and (not op2);
                temp_reg(32) <= cin;
            when "1111" => -- mvn
                temp_reg(31 downto 0) <= not op2;
                temp_reg(32) <= cin;
            when others => -- fail case
                temp_reg <= (others => 'X');
        end case;
    end process data_proc;
end behavior;