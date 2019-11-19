`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2019 03:24:42 PM
// Design Name: 
// Module Name: Control
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


module Control(Instruction, Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, UncondBranch, ALUop);
    input [31:0] Instruction;
    output Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, UncondBranch;
    output [2:0] ALUop;
    
    parameter BRANCH = 11'b00010100000;
    parameter AND = 11'b10001010000;
    parameter ADD = 11'b10001011000;
    parameter ORR = 11'b10101010000;
    parameter CBNZ = 11'b10110100000;
    parameter SUB = 11'b11001011000;
    parameter MOVK = 11'b11110010100;
    parameter STUR = 11'b11111000000;
    parameter LDUR = 11'b11111000010;
    reg [10:0] signal;
    
    always@(*)
    begin
        case(Instruction[31:21])
            BRANCH: signal = 11'b00000001011;
            AND: signal = 11'b00010000000; 
            ADD: signal = 11'b00010000101;
            ORR: signal = 11'b00010000001;
            CBNZ: signal = 11'b10000010100;
            SUB: signal = 11'b00010000110;
            MOVK: signal = 11'b01010000111;
            STUR: signal = 11'b11000100101;
            LDUR: signal = 11'b01111000101;
            default: signal = 0;
            endcase
    end
    
    assign Reg2Loc = signal[10];
    assign ALUSrc = signal[9];
    assign MemtoReg = signal[8];
    assign RegWrite = signal[7];
    assign MemRead = signal[6];
    assign MemWrite = signal[5];
    assign Branch = signal[4];
    assign UncondBranch = signal[3];
    assign ALUop = signal[2:0];
    
endmodule
