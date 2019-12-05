# Single-Cycle-ARM-Data-Path
A design of simplifide ARM-like CPU.

It supports the following instructions:

Instruction|Opcode
----|----
BRANCH|11'h0A0
AND|11'h450
ADD|11'h458
ORR|11'h550
CBNZ|11'h5A0
SUB|11'h658
MOVK|11'h794
STUR|11'h7C0
LDUR|11'h7C2

## Components
### ALU
- Inputs: Registers or DRAddress(depends on ALU mux)
- Outputs: Results and a zero flag(it sets to 1 when the result is not zero in this design).
- Opcode:

Opcode|Operation
----|----
0 | AND
1 | OR
2 | NOT
3 | MOVA
4 | MOVB
5 | ADD
6 | SUBSTRACT
7 | MOVK

### ALU mux
- Decide the second input of ALU is a register or DTAddress

### Data Memory
- It's size is 512B

### Data mux
- Choose from the data read from data memory and the ALU result based on the MemtoReg signal.

### Sign extend
- extend specific bits to 64 bits, used by IM-Type and D-Type instruction.

### Regloc mux
- If the instruction is MOVK, Readselect1 will be the 0~4 digits of Instruction.
- If the Reg2Loc Signal is 1, Readselect2 will be the 0~4 digits of Instruction.

### Branch Selection
- No Branch or UncondBranch signal, PC = PC + 1
- Or, PC = PC + Address

### Control Unit Signals
An unified unit of control unit and ALU control unit.
- Reg2Loc: decide the location of the Readselect2
- ALUSrc: control ALU mux
- MemtoReg: control Data mux
- Regwrite: write enable for register file
- MemRead: read enable for data memory
- MemWrite: write enable for data memory
- Branch: Conditional branch signal
- UncondBranch: Unconditional branch signal
- ALUop: Opcodes of ALU

### Register file
- It contains 32 registers in total, the 31th register is zero register.

### Instruction memory
- In my instruction memory, the programm is load the first 6 numbers of Fibonacci array into data memory.

## Final design diagram
<img src = "https://github.com/TingyiZhang/Single-Cycle-ARM-Data-Path/blob/master/FinalDesign.png">

## Testing
The instructions in the instruction memory is loading the first 6 fibonacci numbers into data menmory.

Wavefrom:

