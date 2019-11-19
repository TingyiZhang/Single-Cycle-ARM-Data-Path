`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2019 01:04:48 PM
// Design Name: 
// Module Name: ALU_mux
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


module ALU_mux(ReadData1, ReadData2, ALUSrc, DTAddress,data1, data2);

    input [63:0]ReadData1, ReadData2, DTAddress;
    input ALUSrc;
    output [63:0]data1, data2;
    
    assign data1 = ReadData1;
    assign data2 = (ALUSrc == 1) ? DTAddress : ReadData2;

endmodule
