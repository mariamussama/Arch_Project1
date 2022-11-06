`include "defines.v"
`include "ALU_Control.v"
`include "Imm_Shift.v"
`include "Mux_Addr.v"
`include "Reg_RF_Mem.v"

//////////////////////////////////////////////////////////////////////////////////

module full_cycle( input clk, input rst,output wire [31:0]Inst, output wire [15:0]concat);//,output[31:0]pc_OUT,sum_pc,sum_shift,pc,Read_data1,Read_data2,Write_data_Rd,gen_out,mux_to_ALU,ALUout,mem_data_out );
wire and_pc, zeroflag, Cout;
wire cout_add_pc;
wire Branch, MemRead, MemtoReg;
wire [1:0] ALUOp, Rd_sel;
wire MemWrite, ALUSrc, RegWrite;
wire [4:0]ReadReg1,ReadReg2, WriteReg;
assign ReadReg1 = Inst [19:15];
assign ReadReg2  = Inst [24:20];
assign WriteReg  = Inst [11:7];
wire [3:0] ALU_Sel;
wire cf, vf, sf, BR, pc_sel,JAL,EC_FE,EB;
wire [31:0]Write_data, muxPC_out;
wire [31:0]pc_OUT,sum_pc,sum_shift,pc,Read_data1,Read_data2,Write_data_Rd,gen_out,mux_to_ALU,ALUout,mem_data_out;
wire rst_pc=1'b1;
//////////////////IF/ID//////////////////////
Reg #(32) reg_pc(pc, clk, EB, rst, pc_OUT);
n_mux2by1 #(32)mux_eb_pc(EC_FE,pc_OUT,32'b11111111111111111111111111111100, muxPC_out);
add_sub #(32) addr(1'b0, muxPC_out, 32'd4, sum_pc, cout_add_pc );
//n_mux2by1 #(32) m2by1_pc(and_pc,sum_pc, sum_shift, pc);
n_mux4by1 #(32)mux_pc({pc_sel,and_pc}, sum_pc, sum_shift, ALUout, ALUout, pc); //need to support pc_sel
InstMem insmem(pc_OUT[7:2],Inst);//check the address
//////////////////ID/EX//////////////////////
Control_unit CU(Inst[6:0],Inst[20],Branch, MemRead, MemtoReg,ALUOp, Rd_sel, MemWrite, ALUSrc, RegWrite, pc_sel,JAL,EC_FE,EB);
n_mux4by1 #(32) mux_rd(Rd_sel, sum_shift, sum_pc, Write_data, 32'd0, Write_data_Rd);
Reg_file #(32) RF(Write_data_Rd, ReadReg1,ReadReg2,WriteReg,clk, rst, RegWrite, Read_data1,Read_data2 );
rv32_ImmGen imm_gen(Inst, gen_out); //imm gen
//////////////////EX/Mem//////////////////////
//Shifter #(32)shift_(gen_out, shift_Out); //shift
n_mux2by1 #(32)mux_fromRF(ALUSrc,Read_data2,gen_out, mux_to_ALU);
ALU_CU ALUControl(ALUOp, {Inst[30],Inst[14:12]}, ALU_Sel);
//ALU #(32) ALU(ALU_Sel,Read_data1,mux_to_ALU, ALUout, zeroflag );
prv32_ALU alu( Read_data1, mux_to_ALU, Inst[24:20], ALUout,cf, zeroflag, vf, sf, ALU_Sel );
//and andmux (and_pc, Branch, zeroflag);
Branch_sign br(Inst[14:12], zeroflag, sf, vf, cf, BR);
assign and_pc = Branch & (BR|JAL);
add_sub #(32) ADD_to_mux_PC(1'b0, pc_OUT, gen_out , sum_shift, Cout);//check cin=0, use of cout

///////////////////Mem/WB//////////////////////
DataMem datamem(clk, MemRead, MemWrite, ALUout[7:0], Read_data2, Inst[14:12], mem_data_out );
/////////////////WB/IF/////////////////////
n_mux2by1 #(32)mem_mux(MemtoReg, ALUout, mem_data_out, Write_data);
////////////////////////////////////////////////////////
assign concat={{2'b00},ALU_Sel,Branch,MemRead,MemtoReg,ALUOp,MemWrite, ALUSrc, RegWrite,zeroflag,and_pc};
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Milestone1(

    );
endmodule