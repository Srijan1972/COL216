library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processor is
    port(
        clock:in std_logic;
        rst:in std_logic;
        ext_data:in std_logic_vector(7 downto 0);
        status:in std_logic);
end processor;

architecture behavior of processor is
component alu is
    port(
        cin    :in std_logic;
        cout   :out std_logic;
        op1    :in std_logic_vector(31 downto 0);
        op2    :in std_logic_vector(31 downto 0);
        opcode :in std_logic_vector(3 downto 0);
        res    :out std_logic_vector(31 downto 0));
end component;

component condcheck is
    port(
        cond      :in std_logic_vector(3 downto 0);
        flags_reg :in std_logic_vector(3 downto 0); --NZCV
        E         :out std_logic);
end component;

component decoder is
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
end component;

component flags is
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
end component;

component memory is
    port(
        addr     :in std_logic_vector(7 downto 0);
        w_en     :in std_logic_vector(3 downto 0);
        clock    :in std_logic;
        data_in  :in std_logic_vector(31 downto 0);
        data_out :out std_logic_vector(31 downto 0);
        mode     :in std_logic);
end component;

component multiplier is
    port(
        mulop1:in std_logic_vector(31 downto 0);
        mulop2:in std_logic_vector(31 downto 0);
        mulacc:in std_logic_vector(63 downto 0);
        mulres:out std_logic_vector(63 downto 0);
        U:in std_logic;
        A:in std_logic);
end component;

component registers is
    port(
        r_add1     :in std_logic_vector(3 downto 0);
        r_add2     :in std_logic_vector(3 downto 0);
        w_add      :in std_logic_vector(3 downto 0);
        data_in    :in std_logic_vector(31 downto 0);
        w_en       :in std_logic;
        clock      :in std_logic;
        data_out1  :out std_logic_vector(31 downto 0);
        data_out2  :out std_logic_vector(31 downto 0));
end component;

component shifter is
    port(
        operand:in std_logic_vector(31 downto 0);
        shift_length:in std_logic_vector(4 downto 0);
        shift_type:in std_logic_vector(1 downto 0);
        csout:out std_logic;
        operand2:out std_logic_vector(31 downto 0));
end component;
        
    type state_type is (decode,loadops,dp1,dp2,dt1,str1,ldr1,ldr2,b,pc_write,shifting,write_back,mul1,mul2,mul3,mul4,swi,ret,rte);
    signal state:state_type:=decode;
    signal next_state:state_type:=decode;
    signal reset:std_logic:='0';
    signal cin:std_logic:='0';
    signal cout:std_logic:='0';
    signal I:std_logic:='0';
    signal S:std_logic:='0';
    signal E:std_logic:='0';
    signal regs_w_en:std_logic:='0';
    signal Fset:std_logic:='0';
    signal csout:std_logic:='0';
    signal Fmul:std_logic:='0';
    signal mode:std_logic:='0'; -- 0 for user, 1 for supervisor
    signal F:std_logic_vector(1 downto 0):=(others => '0');
    signal L:std_logic_vector(1 downto 0):=(others => '0');
    signal shift_type:std_logic_vector(1 downto 0):=(others => '0');
    signal opcodedp:std_logic_vector(3 downto 0):=(others => '0');
    signal cond:std_logic_vector(3 downto 0):=(others => '0');
    signal opcode:std_logic_vector(3 downto 0):=(others => '0');
    signal Rn:std_logic_vector(3 downto 0):=(others => '0');
    signal Rd:std_logic_vector(3 downto 0):=(others => '0');
    signal rot:std_logic_vector(3 downto 0):=(others => '0');
    signal Rm:std_logic_vector(3 downto 0):=(others => '0');
    signal flags_reg:std_logic_vector(3 downto 0):=(others => '0');
    signal mem_w_en:std_logic_vector(3 downto 0):=(others => '0');
    signal regs_r1:std_logic_vector(3 downto 0):=(others => '0');
    signal regs_r2:std_logic_vector(3 downto 0):=(others => '0');
    signal regs_w:std_logic_vector(3 downto 0):=(others => '0');
    signal shift_length:std_logic_vector(4 downto 0):=(others => '0');
    signal opcodedt:std_logic_vector(5 downto 0):=(others => '0');
    signal imm:std_logic_vector(7 downto 0):=(others => '0');
    signal shift:std_logic_vector(7 downto 0):=(others => '0');
    signal addr:std_logic_vector(7 downto 0):=X"80";
    signal offset:std_logic_vector(11 downto 0):=(others => '0');
    signal address:std_logic_vector(23 downto 0):=(others => '0');
    signal pc:std_logic_vector(31 downto 0):=X"00000200";
    signal IR:std_logic_vector(31 downto 0):=(others => '0');
    signal pc_temp:std_logic_vector(31 downto 0):=(others => '0');
    signal op1:std_logic_vector(31 downto 0):=(others => '0');
    signal op2_temp:std_logic_vector(31 downto 0):=(others => '0');
    signal op2:std_logic_vector(31 downto 0):=(others => '0');
    signal res:std_logic_vector(31 downto 0):=(others => '0');
    signal mem_in:std_logic_vector(31 downto 0):=(others => '0');
    signal mem_out:std_logic_vector(31 downto 0):=(others => '0');
    signal regs_in:std_logic_vector(31 downto 0):=(others => '0');
    signal regs_out1:std_logic_vector(31 downto 0):=(others => '0');
    signal regs_out2:std_logic_vector(31 downto 0):=(others => '0');
    signal mulop1:std_logic_vector(31 downto 0):=(others => '0');
    signal mulop2:std_logic_vector(31 downto 0):=(others => '0');
    signal mulacc:std_logic_vector(63 downto 0):=(others => '0');
    signal mulres:std_logic_vector(63 downto 0):=(others => '0');
begin
    ALU_comp:alu port map(cin,cout,op1,op2,opcodedp,res);
    CondCheck_comp:condcheck port map(cond,flags_reg,E);
    Decoder_comp:decoder port map(IR,cond,F,I,opcode,S,Rn,Rd,rot,imm,shift,Rm,opcodedt,offset,L,address);
    Flags_comp:flags port map(flags_reg,Fset,S,op1(31),op2(31),opcodedp,res,cout,csout,Fmul,IR(23),IR(22),mulres);
    Memory_comp:memory port map(addr,mem_w_en,clock,mem_in,mem_out,mode);
    Registers_comp:registers port map(regs_r1,regs_r2,regs_w,regs_in,regs_w_en,clock,regs_out1,regs_out2);
    Shifter_comp:shifter port map(op2_temp,shift_length,shift_type,csout,op2);
    Mult_comp:multiplier port map(mulop1,mulop2,mulacc,mulres,IR(22),IR(21));
    state <= next_state;
    run:process(clock)
    begin
        if rising_edge(clock) and rst='1' then
            pc_temp <= X"00000000";
            next_state <= pc_write;
            mode <= '1';
        elsif rising_edge(clock) then
            case state is
                when decode =>
                    IR <= mem_out;
                    op1 <= "00" & pc(31 downto 2);
                    cin <= '1';
                    opcodedp <= "0101";
                    regs_w_en <= '0';
                    mem_w_en <= "0000";
                    op2_temp <= x"00000000";
                    shift_length <= "00000";
                    shift_type <= "00";
                    Fset <= '0';
                    Fmul <= '0';
                    next_state <= loadops;
                when loadops =>
                    pc_temp <= res(29 downto 0) & "00";
                    if E='1' then
                        if F="01" and IR(25)='1' and IR(4 downto 0)="10000" then next_state <= ret; regs_r1 <= "1110";
                        elsif F="01" and IR(25)='1' and IR(4 downto 0)="10001" then next_state <= rte; regs_r1 <= "1110";
                        elsif F="00" and IR(25 downto 23)="000" and IR(7 downto 4)="1001" then next_state <= mul1; Fmul <= '1'; regs_r1 <= Rm; regs_r2 <= rot;
                        elsif F="01" or (F="00" and IR(25)='0' and IR(7)='1' and IR(4)='1') then next_state <= dt1; regs_r1 <= Rn; regs_r2 <= Rd; regs_w <= Rd;
                        elsif F="00" then next_state <= dp1; Fset <= '1'; regs_r1 <= Rn; regs_r2 <= Rm; regs_w <= Rd;
                        elsif F="10" then next_state <= b; op1 <= res; if address(23)='1' then op2_temp <= X"FF" & address; else op2_temp <= X"00" & address; end if; shift_length <= "00000"; shift_type <= "00"; cin <= '1'; opcodedp <= "0101";
                        else next_state <= swi; regs_in <= res(29 downto 0) & "00"; regs_w <= "1110"; regs_w_en <= '1'; mode <= '1';
                        end if;
                    else next_state <= pc_write;
                    end if;
                when dp1 =>
                    op1 <= regs_out1;
                    if I='1' then op2_temp <= x"000000" & imm;
                    else op2_temp <= regs_out2;
                    end if;
                    opcodedp <= opcode;
                    regs_r2 <= rot;
                    next_state <= shifting;
                when dp2 =>
                    if opcode="1000" or opcode="1001" or opcode="1010" or opcode="1011" then regs_w_en <= '0';
                    else regs_w_en <= '1';
                    end if;
                    Fset <= '0';
                    regs_in <= res;
                    next_state <= pc_write;
                when dt1 =>
                    op1 <= regs_out1;
                    if F="01" then
                        if opcodedt(5)='1' then op2_temp <= x"00000" & offset;
                        else regs_r2 <= IR(3 downto 0);
                        end if;
                        if opcodedt(3)='1' then opcodedp <= "0100";
                        else opcodedp <= "0010";
                        end if;
                    else
                        if IR(22)='1' then op2_temp <= x"000000" & IR(11 downto 8) & IR(3 downto 0);
                        else regs_r2 <= IR(3 downto 0);
                        end if;
                    end if;
                    next_state <= shifting;
                when str1 =>
                    if F="01" then
                        if opcodedt(4)='1' then addr <= res(9 downto 2);
                        else addr <= op1(9 downto 2);
                        end if;
                        if opcodedt(2)='0' then
                            mem_in <= regs_out2;
                            mem_w_en <= "1111";
                        else
                            mem_in <= regs_out2(7 downto 0) & regs_out2(7 downto 0) & regs_out2(7 downto 0) & regs_out2(7 downto 0);
                            if opcodedt(4)='1' then
                            case res(1 downto 0) is
                                when "00" => mem_w_en <= "0001";
                                when "01" => mem_w_en <= "0010";
                                when "10" => mem_w_en <= "0100";
                                when others => mem_w_en <= "1000";
                            end case;
                            else
                            case op1(1 downto 0) is
                                when "00" => mem_w_en <= "0001";
                                when "01" => mem_w_en <= "0010";
                                when "10" => mem_w_en <= "0100";
                                when others => mem_w_en <= "1000";
                            end case;
                            end if;
                        end if;
                    else    
                        mem_in <= regs_out2(15 downto 0) & regs_out2(15 downto 0);
                        if IR(24)='1' then
                            if res(1)='0' then mem_w_en <= "0011";
                            else mem_w_en <= "1100";
                            end if;
                        else
                            if op1(1)='0' then mem_w_en <= "0011";
                            else mem_w_en <= "1100";
                            end if;
                        end if;
                    end if;
                    next_state <= write_back;
                when ldr1 =>
                    if IR(24)='1' then addr <= res(9 downto 2);
                    else addr <= op1(9 downto 2);
                    end if;
                    next_state <= ldr2;
                when ldr2 =>
                    if F="01" then
                        if opcodedt(2)='0' then regs_in <= mem_out;
                        else
                            case addr(1 downto 0) is
                                when "00" => regs_in <= X"000000" & mem_out(7 downto 0);
                                when "01" => regs_in <= X"000000" & mem_out(15 downto 8);
                                when "10" => regs_in <= X"000000" & mem_out(23 downto 16);
                                when others => regs_in <= X"000000" & mem_out(31 downto 24);
                            end case;
                        end if;
                    else
                        case IR(6 downto 5) is
                            when "01" =>
                                regs_in <= X"0000" & mem_out(15 downto 0);
                            when "10" => if mem_out(7)='1' then regs_in <= X"FFFFFF" & mem_out(7 downto 0); else regs_in <= X"000000" & mem_out(7 downto 0); end if;
                            when others => if mem_out(15)='1' then regs_in <= X"FFFF" & mem_out(15 downto 0); else regs_in <= X"0000" & mem_out(15 downto 0); end if;
                        end case;
                    end if;
                    regs_w_en <= '1';
                    next_state <= write_back;
                when b =>
                    pc_temp <= res(29 downto 0) & "00";
                    regs_in <= pc_temp;
                    regs_w <= "1110";
                    regs_w_en <= L(0);
                    next_state <= pc_write;
                when shifting =>
                    if F="00" and ((IR(7)='0' or IR(4)='0') or IR(25)='1') then
                        if I='1' then shift_length <= rot & '0'; shift_type <= "11";
                        elsif shift(0)='1' then shift_length <= regs_out2(4 downto 0); shift_type <= shift(2 downto 1);
                        else shift_length <= shift(7 downto 3); shift_type <= shift(2 downto 1);
                        end if;
                        next_state <= dp2;
                    elsif F="01" then
                        if opcodedt(5)='0' then shift_length <= "00000"; shift_type <= "00";
                        else shift_length <= offset(11 downto 7); shift_type <= shift(6 downto 5); op2_temp <= regs_out2;
                        end if;
                        if opcodedt(0)='1' then next_state <= ldr1;
                        else next_state <= str1;
                        end if;
                    elsif F="00" then
                        shift_length <= "00000"; shift_type <= "00";
                        if IR(22)='0' then op2_temp <= regs_out2; regs_r2 <= IR(15 downto 12); end if;
                        if IR(20)='1' then next_state <= ldr1; else next_state <= str1; end if;
                    end if;
                when write_back =>
                        regs_in <= res;
                        if IR(20)='1' then regs_w <= Rn;
                        else regs_w <= Rd;
                        end if;
                        regs_w_en <= IR(21);
                        next_state <= pc_write;
                when mul1 =>
                    mulop1 <= regs_out1;
                    mulop2 <= regs_out2;
                    regs_r1 <= Rn;
                    regs_r2 <= Rd;
                    next_state <= mul2;
                    Fmul <= S;
                when mul2 =>
                    mulacc <= regs_out1 & regs_out2;
                    next_state <= mul3;
                when mul3 =>
                    regs_w <= Rn;
                    regs_w_en <= '1';
                    if IR(23)='0' then regs_in <= mulres(31 downto 0); next_state <= pc_write;
                    else regs_in <= mulres(63 downto 32); next_state <= mul4;
                    end if;
                    Fmul <= '0';
                when mul4 =>
                    regs_w <= Rd;
                    regs_in <= mulres(31 downto 0); next_state <= pc_write;
                when swi =>
                    pc_temp <= X"00000008";
                    mem_in <= X"00000" & "000" & status & ext_data;
                    addr <= X"01";
                    mem_w_en <= status & status & status & status;
                    mode <= '1';
                    if status='1' then next_state <= pc_write;
                    else next_state <= swi;
                    end if;
                when ret =>
                    pc_temp <= regs_out1;
                    next_state <= pc_write;
                when rte =>
                    pc_temp <= regs_out1;
                    mode <= '0';
                    next_state <= pc_write;
                when pc_write =>
                    pc <= pc_temp;
                    addr <= pc_temp(9 downto 2);
                    next_state <= decode;
            end case;
        end if;
    end process run;
end behavior;