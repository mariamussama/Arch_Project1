`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 12:32:12 PM
// Design Name: 
// Module Name: Milestone1
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

module full_cycle( input clk, input rst,output wire [31:0]Inst, output wire [15:0]concat,output[31:0]pc_OUT,sum_pc,sum_shift,pc,Read_data1,Read_data2,Write_data,gen_out,shift_Out,mux_to_ALU,ALUout,mem_data_out );
wire and_pc,zeroflag,Cout;
wire cout_add_pc;
wire Branch, MemRead, MemtoReg;
wire [1:0] ALUOp;
wire MemWrite, ALUSrc, RegWrite;
wire [4:0]ReadReg1,ReadReg2, WriteReg;
assign ReadReg1 = Inst [19:15];
assign ReadReg2  = Inst [24:20];
assign WriteReg  = Inst [11:7];
wire [3:0] ALU_Sel;
//////////////////IF/ID//////////////////////
Reg #(32) reg_pc(pc, clk, 1'b1,rst, pc_OUT);
add_sub #(32) addr(1'b0, pc_OUT, 32'd4, sum_pc, cout_add_pc );
n_mux2by1 #(32) m2by1_pc(and_pc,sum_pc, sum_shift, pc);
InstMem insmem(pc_OUT[7:2],Inst);//check the address
//////////////////ID/EX//////////////////////
Control_unit CU(Inst[6:0],Branch, MemRead, MemtoReg,ALUOp,MemWrite, ALUSrc, RegWrite);
Reg_file #(32) RF(Write_data, ReadReg1,ReadReg2,WriteReg,clk, rst, RegWrite, Read_data1,Read_data2 );
imm_generator imm_gen(Inst, gen_out); //imm gen
//////////////////EX/Mem//////////////////////
Shifter #(32)shift_(gen_out, shift_Out); //shift
n_mux2by1 #(32)mux_fromRF(ALUSrc,Read_data2,gen_out, mux_to_ALU);
ALU_CU ALUControl(ALUOp, {Inst[30],Inst[14,12]}, ALU_Sel);
ALU #(32) ALU(ALU_Sel,Read_data1,mux_to_ALU, ALUout, zeroflag );
//and andmux (and_pc, Branch, zeroflag);
assign and_pc = Branch & zeroflag;
add_sub #(32) ADD_to_mux_PC(1'b0, pc_OUT, shift_Out , sum_shift, Cout);//check cin=0, use of cout
///////////////////Mem/WB//////////////////////
DataMem datamem(clk, MemRead, MemWrite, ALUout[7:2], Read_data2, mem_data_out);
/////////////////WB/IF/////////////////////
n_mux2by1 #(32)mem_mux(MemtoReg, ALUout, mem_data_out, Write_data);
////////////////////////////////////////////////////////
assign concat={{2'b00},ALU_Sel,Branch,MemRead,MemtoReg,ALUOp,MemWrite, ALUSrc, RegWrite,zeroflag,and_pc};
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Milestone1(

    );
endmodule
