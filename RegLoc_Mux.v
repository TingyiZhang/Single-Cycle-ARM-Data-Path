`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2019 12:00:14 PM
// Design Name: 
// Module Name: RegLoc_Mux
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


module RegLoc_Mux(Instruction, Reg2Loc, ReadSelect1, ReadSelect2, WriteSelect);
    input [31:0]Instruction;
    input Reg2Loc;
    output [4:0]ReadSelect1, ReadSelect2, WriteSelect;
    
    parameter MOVK = 11'b11110010100;
    
    assign ReadSelect1 = (Instruction[31:21] == MOVK) ? Instruction[4:0] : Instruction[9:5];
    assign WriteSelect = Instruction[4:0];
    assign ReadSelect2 = (Reg2Loc == 1)? Instruction[4:0] : Instruction[20:16];
 
endmodule
