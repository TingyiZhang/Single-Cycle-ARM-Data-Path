`timescale 1ns / 1ns
module Instruction_Memory(Address, ReadData1);
parameter BITSIZE = 32;
parameter REGSIZE = 64;
input [REGSIZE-1:0] Address;
output reg [BITSIZE-1:0] ReadData1;

reg [BITSIZE-1:0] memory_file [0:REGSIZE-1];	// Entire list of memory

localparam [10:0] AND_Op   = 11'h450,
                  ADD_Op   = 11'h458,
                  ORR_Op   = 11'h550,
                  SUB_Op   = 11'h658,
                  STUR_Op  = 11'h7c0,
                  LDUR_Op  = 11'h7c2,
                  MOVK_Op  = 11'h794,
                  CBNZ_Op   = 11'h5a0,
                  BRA_Op   = 11'h0a0;

reg [4:0]  Rt_Sel, R1_Sel, R2_Sel;
localparam [5:0]  shamt = 6'b0;
reg [10:0] DT_Address;
reg [20:0] BRAN_Address;
reg [15:0] COND_Address, MOV_Immediate;

// Asyncronous read of memory. Was not specified.
always @(Address, memory_file[Address])
begin
	ReadData1 = memory_file[Address];
end

integer i;
// method of filling the memory instead of through a test bench
initial
	begin
		// https://en.wikipedia.org/wiki/Taxicab_number
	    // PC = 0 -> movk x27, 9^3 = 729
	    i = 0;
	    MOV_Immediate = 16'h02d9;
	    Rt_Sel = 5'h1b;
	    memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

	    // PC = 1 -> movk x30, 10^3 = 1000
	    i = i+1;
	    MOV_Immediate = 16'h03e8;
	    Rt_Sel = 5'h1e;
	    memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

	    // PC = 2 -> add x6, x27, x30 # x6 = 1729
	    i = i+1;
	    R1_Sel = 5'h1b;
        R2_Sel = 5'h1e;
        Rt_Sel = 5'h06;
        memory_file[i] = {ADD_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 3 -> movk x29, 1^3 = 1
	    i = i+1;
	    MOV_Immediate = 16'h0001;
	    Rt_Sel = 5'h1d;
	    memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

	    // PC = 4 -> movk x28, 12^3 = 1728
	    i = i+1;
	    MOV_Immediate = 16'h06c0;
	    Rt_Sel = 5'h1c;
	    memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

		// PC = 5 -> add x6, x29, x28 # x6 = 1729
	    i = i+1;
	    R1_Sel = 5'h1c;
        R2_Sel = 5'h1d;
        Rt_Sel = 5'h06;
        memory_file[i] = {ADD_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 6 -> sub x7, x30, x27 # x7 = 271
		i = i+1;
        R1_Sel = 5'h1e;
        R2_Sel = 5'h1b;
        Rt_Sel = 5'h07;
        memory_file[i] = {SUB_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 7 -> sub x7, x28, x29 # x7 = 1727
		i = i+1;
        R1_Sel = 5'h1c;
        R2_Sel = 5'h1d;
        Rt_Sel = 5'h07;
        memory_file[i] = {SUB_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 8 -> orr x8, x30, x27 # x8 = 1017
	    i = i+1;
	    R1_Sel = 5'h1e;
	    R2_Sel = 5'h1b;
	    Rt_Sel = 5'h08;
	    memory_file[i] = {ORR_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 9 -> orr x8, x28, x29 # x8 = 1729
	    i = i+1;
	    R1_Sel = 5'h1c;
	    R2_Sel = 5'h1d;
	    Rt_Sel = 5'h08;
	    memory_file[i] = {ORR_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 10 -> and x9, x30, x27 # x9 = 712
	    i = i+1;
	    R1_Sel = 5'h1e;
	    R2_Sel = 5'h1b;
	    Rt_Sel = 5'h09;
	    memory_file[i] = {AND_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 11 -> and x9, x28, x29 # x9 = 0
	    i = i+1;
	    R1_Sel = 5'h1c;
	    R2_Sel = 5'h1d;
	    Rt_Sel = 5'h09;
	    memory_file[i] = {AND_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// PC = 12 -> movk x24, 64
		i = i+1;
		MOV_Immediate = 16'h0040;
		Rt_Sel = 5'h18;
		memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

		// PC = 13 -> stur x6, [x9, 6] # DMem[6] = x6 -> PC = 5
		i = i+1;
		DT_Address = 11'h006;
		R1_Sel = 5'h09;
		Rt_Sel = 5'h06;
		memory_file[i] = {STUR_Op, DT_Address, R1_Sel, Rt_Sel};

		// PC = 14 -> stur x7, [x24, -55] #DMem[9] = x7 -> PC = 7
		i = i+1;
		DT_Address = 11'h7C9;
		R1_Sel = 5'h18;
		Rt_Sel = 5'h07;
		memory_file[i] = {STUR_Op, DT_Address, R1_Sel, Rt_Sel};

		// PC = 15 -> ldur x26, [x9, 6] # x26 = DMem[6]
		i = i+1;//x26
		DT_Address = 11'h006;
		R1_Sel = 5'h09;
		Rt_Sel = 5'h1a;
		memory_file[i] = {LDUR_Op, DT_Address, R1_Sel, Rt_Sel};

		// PC = 16 -> ldur x25, [x24, -55] # x25 = DMem[9]
		i = i+1;
		DT_Address = 11'h7C9;
		R1_Sel = 5'h18;
		Rt_Sel = 5'h19;
		memory_file[i] = {LDUR_Op, DT_Address, R1_Sel, Rt_Sel};
		
		// correct flow: 17, 18, 20, 21, 25, 24, 22, 27
		// MOVK - let's assume that this puts zero into x12
		// if the actual CPU has higher bits non-zero (thus x12 != 0),
		// please ask questions approriately (it's not wrong)
		// PC = 17 -> movk x12, #0
		i = i+1;
	    Rt_Sel = 5'd12;
		MOV_Immediate = 16'h0;
	    memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

	    // BRANCH - jump forward to 20
		// PC = 18 -> branch 2
		// CBNZ
		i = i+1;
	    BRAN_Address = 21'h2;
	    memory_file[i] = {BRA_Op, BRAN_Address};

		// TRASH - should never execute
		// PC = 19 -> add x11, x6, x7
		i = i+1;
		R1_Sel = 5'd6;
        R2_Sel = 5'd7;
        Rt_Sel = 5'd11;
		memory_file[i] = {ADD_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// CBNZ - don't jump now that x12 == 0
		// PC = 20 -> cbnz x12, 2
		i = i+1;
	    Rt_Sel = 5'd12;
		COND_Address = 16'h2;
	    memory_file[i] = {CBNZ_Op, COND_Address, Rt_Sel};

		// CBNZ - jump to 25 because x6 != 0
		// PC = 21 -> cbnz x6, 4
		i = i+1;
	    Rt_Sel = 5'd6;
		COND_Address = 16'h4;
	    memory_file[i] = {CBNZ_Op, COND_Address, Rt_Sel};

		// normal flow from 24; jump to 27
		// if the CBNZ on i=20/21 does not work (but branch works), try workaround (goto 27)
		// PC = 22 -> branch 5
		i = i+1;
		BRAN_Address = 21'h5;
	    memory_file[i] = {BRA_Op, BRAN_Address};

		// TRASH - fallback from 22
		// BRANCH - fallback jump to 27
		// PC = 23 -> branch 4
		i = i+1;
	    BRAN_Address = 21'h4;
	    memory_file[i] = {BRA_Op, BRAN_Address};

		// BRANCH - jump backward to 22
		// PC = 24 -> branch -2
		i = i+1;
	    BRAN_Address = 21'b111111111111111111110;
	    memory_file[i] = {BRA_Op, BRAN_Address};

		// Completed BRANCH (+/-) and CBNZ (+) from i=21/22
		// CBNZ - jump to 24 (backward) because x6 != 0
		// PC = 25 -> cbnz x6, -1
		i = i+1;
	    Rt_Sel = 5'd6;
		COND_Address = 16'b1111111111111111;
	    memory_file[i] = {CBNZ_Op, COND_Address, Rt_Sel};

		// TRASH - should never execute
		// PC = 26 -> and x11, x6, x7
		i = i+1;
		R1_Sel = 5'd6;
        R2_Sel = 5'd7;
        Rt_Sel = 5'd11;
		memory_file[i] = {AND_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// Start MOVK test keep behavior
		// notice sign extension
		// PC = 27 -> movk x13, 0xffff
		i = i+1;
	    Rt_Sel = 5'd13;
		MOV_Immediate = 16'hffff;
	    memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

		// PC = 28 -> add x14, x13, x13 (= 0x1fffe)
		i = i+1;
		R1_Sel = 5'd13;
        R2_Sel = 5'd13;
        Rt_Sel = 5'd14;
		memory_file[i] = {ADD_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// 0x1fffe --MOVK(0x0ff0)-> 0x10ff0
		// PC = 29 -> movk x14, 0xff0
		i = i+1;
	    Rt_Sel = 5'd14;
		MOV_Immediate = 16'hff0;
	    memory_file[i] = {MOVK_Op, MOV_Immediate, Rt_Sel};

		// final read from reg x14
		// PC = 30 -> orr x15, x14, x14
		i = i+1;
		R1_Sel = 5'd14;
        R2_Sel = 5'd14;
        Rt_Sel = 5'd15;
		memory_file[i] = {ORR_Op, R2_Sel, shamt, R1_Sel, Rt_Sel};

		// BRANCH - infinite stop
		// PC = 31 -> branch 0
		i = i+1;
	    BRAN_Address = 21'h0;
	    memory_file[i] = {BRA_Op, BRAN_Address};
	end
endmodule
