`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2019 02:12:38 PM
// Design Name: 
// Module Name: Data_Mux
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


module Data_Mux(ReadData, ALU_Result, MemtoReg, WriteData);

    input [63:0]ReadData, ALU_Result;
    input MemtoReg;
    output [63:0]WriteData;
    
    assign WriteData = (MemtoReg == 1) ? ReadData : ALU_Result;
 
endmodule
