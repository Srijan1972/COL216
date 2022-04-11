library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity flags is
    port(
        flags_reg :out std_logic_vector(3 downto 0); -- NZCV
        Fset      :in std_logic;
        S         :in std_logic;
        op1_msb   :in std_logic;
        op2_msb   :in std_logic;
        opcode    :in std_logic_vector(3 downto 0);
        res       :in std_logic_vector(31 downto 0);
        alu_carry :in std_logic;
        shift_carry:in std_logic;
        Fmul:in std_logic;
        SL:in std_logic;
        U:in std_logic;
        mulres:in std_logic_vector(63 downto 0));
end flags;

architecture behavior of flags is
	signal N:std_logic:='0';
	signal Z:std_logic:='0';
	signal C:std_logic:='0';
	signal V:std_logic:='0';
begin
	flags_reg <= N & Z & C & V;
    process(S,op1_msb,op2_msb,opcode,res,alu_carry,Fset,shift_carry,Fmul,SL,u,mulres) is
    begin
        if S='1' and Fset='1' then
            N <= res(31);
            if res=x"00000000" then Z <= '1'; else Z <= '0'; end if;
            case opcode is
                when "0100"|"0101"|"1011" =>
                    C <= alu_carry;
                    V <= (op1_msb and op2_msb and not(res(31))) or (not(op1_msb) and not(op2_msb) and res(31));
                when "0010"|"0110"|"1010" =>
                    C <= alu_carry;
                    V <= (op1_msb and not(op2_msb) and not(res(31))) or (not(op1_msb) and op2_msb and res(31));
                when "0011"|"0111" =>
                    C <= alu_carry;
                    V <= (not(op1_msb) and op2_msb and not(res(31))) or (op1_msb and not(op2_msb) and res(31));
                when "0000"|"0001"|"1000"|"1001"|"1100"|"1101"|"1110"|"1111" =>
                    C <= shift_carry;
                when others => null;
            end case;
        elsif S='0' and Fset='1' then
            case opcode is
                when "1011" =>
                    N <= res(31);
                    if res=x"00000000" then Z <= '1'; else Z <= '0'; end if;
                    C <= alu_carry;
                    V <= (op1_msb and op2_msb and not(res(31))) or (not(op1_msb) and not(op2_msb) and res(31));
                when "1010" =>
                    N <= res(31);
                    if res=x"00000000" then Z <= '1'; else Z <= '0'; end if;
                    C <= alu_carry;
                    V <= (op1_msb and not(op2_msb) and not(res(31))) or (not(op1_msb) and op2_msb and res(31));
                when "1000"|"1001" =>
                    N <= res(31);
                    if res=x"00000000" then Z <= '1'; else Z <= '0'; end if;
                when others => null;
            end case;
        elsif S='1' and Fmul='1' then
            if SL='0' then
                N <= mulres(31);
                if mulres(31 downto 0)=x"00000000" then Z <= '1'; else Z <= '0'; end if;
            elsif U='0' then
                N <= mulres(63);
                if mulres=x"0000000000000000" then Z <= '1'; else Z <= '0'; end if;
            elsif U='1' then
                if mulres=x"0000000000000000" then Z <= '1'; else Z <= '0'; end if;
            end if;
        end if;
    end process;
end architecture;