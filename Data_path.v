`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2019 01:07:30 PM
// Design Name: 
// Module Name: Data_path
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Data_path(clk, rst, pc, signal, pc_new, alu, amux, regf, regloc, datam, data, instruction, signex, Zero);
    // test outputs of every component
    output [63:0] pc;
    output [10:0] signal;
    output [63:0] pc_new;
    output [63:0] alu;
    output [127:0] amux;
    output [127:0] regf;
    output [14:0] regloc;
    output [63:0] datam;
    output [63:0] data;
    output [31:0] instruction;
    output [63:0] signex;
    output [63:0] Zero;
    input clk;
    input rst;
    // PC register
    reg [63:0] PC;
    initial PC <= 0;
    // the output of Instrction Memory(instruction)
    wire[31:0] Instruction;
    //outputs of control unit
    wire Reg2Loc;
    wire ALUSrc;
    wire MemtoReg;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire UncondBranch;
    wire [2:0]ALUop;
    // outputs of RegLoc Mux 
    wire [4:0]ReadSelect1, ReadSelect2, WriteSelect;
    // outputs of Regfile
    wire [63:0] ReadData1, ReadData2;
    // the output of sign_extend
    wire [63:0]DTAddress;
    // outputs of ALU mux
    wire [63:0]data1, data2;
    // outputs of ALU
    wire zero;
    wire [63:0]result;
    // the output of Data Memory
    wire [63:0]ReadData;
    // the output of Data mux
    wire [63:0]WriteData;
    // the output of Branch Select
    wire [63:0]PC_new;
    
    Instruction_Memory Imem(.Address(PC),.ReadData1(Instruction));
    
    Control CUnit(.Instruction(Instruction),.Reg2Loc(Reg2Loc),.ALUSrc(ALUSrc),.MemtoReg(MemtoReg),.RegWrite(RegWrite),.MemRead(MemRead),.MemWrite(MemWrite),.Branch(Branch),.UncondBranch(UncondBranch),.ALUop(ALUop));
    
    RegLoc_Mux Regmux(.Instruction(Instruction),.Reg2Loc(Reg2Loc),.ReadSelect1(ReadSelect1),.ReadSelect2(ReadSelect2),.WriteSelect(WriteSelect));
    
    Register_File Regfile(.ReadSelect1(ReadSelect1),.ReadSelect2(ReadSelect2),.WriteSelect(WriteSelect),.clk(clk),.rst(rst),.WriteEnable(RegWrite),.ReadData1(ReadData1),.ReadData2(ReadData2),.WriteData(WriteData));
    
    sign_extend signextend(.Instruction(Instruction),.Address(DTAddress));
    
    ALU_mux alumux(.ReadData1(ReadData1),.ReadData2(ReadData2),.DTAddress(DTAddress),.ALUSrc(ALUSrc),.data1(data1),.data2(data2));
    
    ALU Alu(.opcode(ALUop),.data1(data1),.data2(data2),.zero(zero),.result(result));
    
    Data_Memory DataMem(.Address(result),.WriteData(ReadData2),.WriteEnable(MemWrite),.ReadEnable(MemRead),.clk(clk),.rst(rst),.ReadData(ReadData));
    
    Data_Mux datamux(.ReadData(ReadData),.ALU_Result(result),.MemtoReg(MemtoReg),.WriteData(WriteData));
    
    BranchSelect branch(.PC(PC),.Branch(Branch),.UncondBranch(UncondBranch),.Address(DTAddress),.zero(zero),.PC_new(PC_new));
    
    always@(posedge clk)
        begin
            PC = PC_new;
        end
     
    assign pc = PC;
    assign signal = {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, UncondBranch, ALUop};
    assign pc_new = PC_new;
    assign alu = {result};
    assign amux = {data1, data2};
    assign regf = {ReadData1, ReadData2};
    assign regloc = {ReadSelect1, ReadSelect2, WriteSelect};
    assign datam = WriteData;
    assign data = ReadData;
    assign instruction = Instruction;
    assign signex = DTAddress;
    assign Zero = zero;

endmodule
