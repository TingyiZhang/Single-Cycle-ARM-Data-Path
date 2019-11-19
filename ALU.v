`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2019 03:23:01 PM
// Design Name: 
// Module Name: ALU
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
module ALU(opcode, data1, data2, result, zero);
    parameter BITSIZE = 64;
    input [BITSIZE - 1:0] data1, data2;
    output reg [BITSIZE - 1:0] result;
    output zero;
    input [2:0] opcode;
    
    reg [63:0]temp;
    
    parameter AND = 3'b000;                                            
    parameter OR = 3'b001;
    parameter NOT = 3'b010;
    parameter MOVA = 3'b011;
    parameter MOVB = 3'b100;
    parameter ADD = 3'b101;
    parameter SUB = 3'b110;
    parameter MOVK = 3'b111;
    
    always@(*)
        begin
            case(opcode)
                AND: result <= data1 & data2;
                OR: result <= data1 | data2;
                NOT: result <= ~data1;
                MOVA: result <= data1;
                MOVB: result <= data2;
                ADD: result <= data1 + data2;
                SUB: result <= data1 - data2;
                MOVK: result <= {data1[63:16], data2[15:0]};
            endcase
        end
        assign zero = (result == 0) ? 0 : 1;
endmodule
