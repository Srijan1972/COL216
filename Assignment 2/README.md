# Assignment 2

## Modules made

- **ALU-** Takes 2 words and performs an operation on them (16 operations available)
- Condition Checker- Checks flags according to the current instruction and returns a result which tells the processor to either execute the instruction or move on.
- **Decoder-** Takes an instruction and decodes it to allow execution.
- **Flag circuit-** Sets N,Z,C,V flags according to results and opcode, can also set flags from multiplier.
- **Memory-** Contains both instructions to be executed and space to store extra data. Reading is continuous while writing only happens at clock edges. Writing can be done at the byte level but currently only word level writing has been implemented. Memory has been partitioned into user and supervisor area where the whole memory can be accessed in supervisor mode but only the 2nd half of the memory can be accessed in user mode. The program is stored in the beginning of the user area.
- **Processor-** Takes all the other entities and runs them using a program counter and an FSM.
- **Register File-** An array (length 16) of words. Reading is continuous but writing only happens at clock edges.
-**Shifter-** An entity which takes in a word (32 bits) and shifts it in 4 possible ways. (Logical left,logical right,arithmetic right, right rotate)
- **Multiplier-** An entity which takes 2 32 bit operands and optionally an accumulator of 64 bits. Returns result according to the instruction. The result returned is always 64 bits but while writing data it has been checked whether 32 or 64 bits have to be written.

## Features

- 7 assembly files have also been given as test cases, whose waveform output is also given.
- The processor contains an FSM with 19 states in order to drive the logic forward.
- The 4 main types of ARM instructions can be processed, i. e. data processing, data transfer, branch and software interrupt.
- In the supervisor area, there are 2 interrupt service routines in which the 1st is the ISR for reset (Accessed through memory location 0x00) and the 2nd is the ISR for swi (in which 9 bits are read) .. (Accessed from memory location 0x08). These routines can only be used in supervisor mode.
- The netlists have been generated through Quartus and the simulation has been done using Questa.
- Note: The number set in the loop of the clock process in the `processor_tb.vhd` file must be exactly one less than the number of seconds the reset signal has to wait to avoid conflicts.
