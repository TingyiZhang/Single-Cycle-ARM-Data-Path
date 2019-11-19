`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2019 04:25:53 PM
// Design Name: 
// Module Name: PC_Counter
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


module BranchSelect(PC,Branch, UncondBranch, Address, zero, PC_new);
    input [63:0]PC;
    input Branch;
    input [63:0] Address;
    input zero                                                                                                                                         ;
    input UncondBranch;
    output reg [63:0] PC_new;
    
            always@(*)
            if(zero & Branch | UncondBranch)
                begin
                    PC_new <= PC + Address;
                end
            else
                begin
                    PC_new <= PC + 1;           
                end

endmodule
