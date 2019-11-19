`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2019 01:17:19 PM
// Design Name: 
// Module Name: sign_extend
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


module sign_extend(Instruction, Address);
    input [31:0]Instruction;
    output reg [63:0]Address;
    
    parameter BRANCH = 11'b00010100000;
    parameter AND = 11'b10001010000;
    parameter ADD = 11'b10001011000;
    parameter ORR = 11'b10101010000;
    parameter CBNZ = 11'b10110100000;
    parameter SUB = 11'b11001011000;
    parameter MOVK = 11'b11110010100;
    parameter STUR = 11'b11111000000;
    parameter LDUR = 11'b11111000010;
        
    always@(*)
    begin
        case(Instruction[31:21])
            LDUR: Address <= (Instruction[20])? {53'h1fffffffffffff, Instruction[20:10]} : {53'b0, Instruction[20:10]};
            STUR: Address <= (Instruction[20])? {53'h1fffffffffffff, Instruction[20:10]} : {53'b0, Instruction[20:10]};
            BRANCH: Address <= (Instruction[20]) ? {43'h7ffffffffff, Instruction[20:0]} : {43'b0, Instruction[20:0]};
            MOVK: Address <= (Instruction[20]) ? {48'hffffffffffff, Instruction[20:5]} : {48'b0, Instruction[20:5]};
            CBNZ: Address <= (Instruction[20]) ? {48'hffffffffffff, Instruction[20:5]} : {48'b0, Instruction[20:5]};
            default: Address <= 0;
        endcase
    end

endmodule
