`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2019 02:35:39 PM
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory(Address, WriteData, ReadData, ReadEnable, WriteEnable, rst, clk);
    input [63:0]Address;
    input [63:0]WriteData;
    output reg [63:0]ReadData;
    input ReadEnable;
    input WriteEnable;
    input clk,rst;
    reg [63:0] Data_Mem[63:0];
    integer i;
    initial
        begin
            for(i = 0; i < 64; i=i+1) Data_Mem[i] <= i;    
        end
    // Read
    always @(Address, Data_Mem[Address], ReadEnable)
        begin
            ReadData = Data_Mem[Address];
        end

    // Write
    always @(posedge clk)
        begin
            if (rst)
                for (i=0; i<64; i=i+1) Data_Mem[i] <= 'b0; // rst all registers
            else
            begin
                if (WriteEnable)
                    Data_Mem[Address] <= WriteData; //If writeback is enabled and not 0 register.
            end
        end



endmodule
