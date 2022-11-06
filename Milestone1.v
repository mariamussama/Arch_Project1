`include "defines.v"
`include "rv32_ImmGen.v"
`include "n_mux2by1.v"
`include "n_mux4by1.v"
`include "add_sub.v"
`include "InstMem.v"
`include "DataMem.v"
`include "Reg_file.v"
`include "Control_unit.v"
`include "ALU_CU.v"
`include "shift.v"
`include "Branch_sign.v"
`include "prv32_ALU.v"
//////////////////////////////////////////////////////////////////////////////////

module Milestone1 ( 
    input clk, 
    input rst,
    output wire [31:0]Inst
    );
wire and_pc, zeroflag, Cout;
wire cout_add_pc;
wire Branch, MemRead, MemtoReg;
wire [1:0] ALUOp, Rd_sel;
wire MemWrite, ALUSrc, RegWrite;
wire [4:0]ReadReg1,ReadReg2, WriteReg;
wire [3:0] ALU_Sel;
wire cf, vf, sf, BR, pc_sel,JAL,EC_FE,EB;
wire [31:0]Write_data, muxPC_out;
wire [31:0]pc_OUT, sum_pc, sum_shift, pc, Read_data1, Read_data2, Write_data_Rd, gen_out, mux_to_ALU, ALUout, mem_data_out;
wire rst_pc=1'b1;
/////////////////////////////////////////////////
assign ReadReg1 = Inst [19:15];
assign ReadReg2  = Inst [24:20];
assign WriteReg  = Inst [11:7];
//////////////////IF/ID//////////////////////
Reg #(32) reg_pc(.D(pc), .clk(clk), .load(EB), .rst(rst), .Q(pc_OUT));
n_mux2by1 #(32)mux_ECFE_pc(.sel(EC_FE),.A(pc_OUT),.B(32'b11111111111111111111111111111100),.Out(muxPC_out));
add_sub #(32) addr(.Cin(1'b0), .A(muxPC_out), .B(32'd4), .Sum(sum_pc), .Cout(cout_add_pc));
n_mux4by1 #(32)mux_pc(.sel({pc_sel,and_pc}), .A(sum_pc), .B(sum_shift), .C(ALUout), .D(ALUout), .Out(pc));
InstMem insmem(.addr(pc_OUT[7:2]), .data_out(Inst));
//////////////////ID/EX//////////////////////
Control_unit CU( .opcode(Inst[6:0]), .EC_EB(Inst[20]), .Branch(Branch), .MemRead(MemRead), 
.MemtoReg(MemtoReg), .ALUOp(ALUOp), .Rd_sel(Rd_sel), .MemWrite(MemWrite), .ALUSrc(ALUSrc), 
.RegWrite(RegWrite), .pc_sel(pc_sel), .JAL(JAL), .EC_FE(EC_FE), .EB(EB));
n_mux4by1 #(32) mux_rd(.sel(Rd_sel), .A(sum_shift), .B(sum_pc), .C(Write_data_Rd), .D(32'd0), .Out(Write_data));
Reg_file #(32) RF(.D(Write_data), .ReadReg1(ReadReg1), .ReadReg2(ReadReg2), 
.WriteReg(WriteReg), .clk(clk), .rst(rst), .RegWrite(RegWrite), .Read_data1(Read_data1),.Read_data2(Read_data2) );
rv32_ImmGen imm_gen(.IR(Inst), .Imm(gen_out));
//////////////////EX/Mem//////////////////////
n_mux2by1 #(32)mux_fromRF( .sel(ALUSrc), .A(Read_data2), .B(gen_out), .Out(mux_to_ALU));
ALU_CU ALUControl(.ALUOp(ALUOp), .Inst({Inst[30],Inst[14:12]}), .ALU_Sel(ALU_Sel));
prv32_ALU alu( .a(Read_data1), .b(mux_to_ALU), .shamt(Inst[24:20]), .r(ALUout) , 
.cf(cf), .zf(zeroflag), .vf(vf), .sf(sf), .alufn(ALU_Sel) );
Branch_sign br(.funct3(Inst[14:12]), .zf(zeroflag), .sf(sf), .vf(vf), .cf(cf), .BR(BR));
assign and_pc = Branch & (BR|JAL);
add_sub #(32) ADD_to_mux_PC(.Cin(1'b0), .A(pc_OUT), .B(gen_out) , .Sum(sum_shift), .Cout(Cout));
///////////////////Mem/WB//////////////////////
DataMem datamem( .clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), 
.addr(ALUout[7:0]), .data_in(Read_data2), .func3(Inst[14:12]), .data_out(mem_data_out));
/////////////////WB/IF/////////////////////
n_mux2by1 #(32)mem_mux(.sel(MemtoReg), .A(ALUout), .B(mem_data_out), .Out(Write_data_Rd));

endmodule
