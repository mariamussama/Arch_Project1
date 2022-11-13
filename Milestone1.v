`include "defines.v"
`include "rv32_ImmGen.v"
`include "n_mux2by1.v"
`include "n_mux4by1.v"
`include "add_sub.v"
`include "InstMem.v"
`include "DataMem.v"
`include "Reg_file.v"
`include "Reg.v"
`include "Control_unit.v"
`include "ALU_CU.v"
`include "shift.v"
`include "Branch_sign.v"
`include "prv32_ALU.v"
`include "Mem.v"
//////////////////////////////////////////////////////////////////////////////////

module Milestone1 ( 
    input clk, 
    input rst,
    output reg [31:0]Inst
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
wire [31:0]pc_OUT, sum_pc, sum_shift, pc, Read_data1, Read_data2, Write_data_Rd, gen_out, mux_to_ALU, ALUout, mem_out;//, mem_data_out;//, mem_out;
reg [31:0] mem_data_out;
wire rst_pc=1'b1;
wire [13:0] CU_signals;
wire [7:0] mux_mem_addr;

wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_sumPC;

wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_sumPC;
wire [13:0] ID_EX_Ctrl;
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;

wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_sumPC;// EX_MEM_sumShift; replaced by EX_MEM_BranchAddOut
wire [13:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire [3:0] EX_MEM_Func;
wire EX_MEM_Zero, EX_MEM_BR;

wire [31:0] MEM_WB_BranchAddOut,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_sumPC; //MEM_WB_sumShift;
wire [13:0] MEM_WB_Ctrl;

wire [4:0] MEM_WB_Rd;
/////////////////////////////////////////////////
assign ReadReg1 = IF_ID_Inst [19:15];
assign ReadReg2  = IF_ID_Inst [24:20];
assign WriteReg  = IF_ID_Inst [11:7];
//////////////////IF/ID//////////////////////
Reg #(32) reg_pc(.D(pc), .clk(clk), .load(EB), .rst(rst), .Q(pc_OUT));
n_mux2by1 #(32)mux_ECFE_pc(.sel(EC_FE),.A(pc_OUT),.B(32'b11111111111111111111111111111100),.Out(muxPC_out));
add_sub #(32) addr(.Cin(1'b0), .A(muxPC_out), .B(32'd4), .Sum(sum_pc), .Cout(cout_add_pc));
n_mux4by1 #(32)mux_pc(.sel({EX_MEM_Ctrl[11],and_pc}), .A(sum_pc), .B(EX_MEM_BranchAddOut), .C(EX_MEM_ALU_out), .D(EX_MEM_ALU_out), .Out(pc));
n_mux2by1 #(8)mux_Inst_data(.sel(clk),.A(EX_MEM_ALU_out[7:0]),.B(pc_OUT[7:0]),.Out(mux_mem_addr)); //address to the memory
//InstMem insmem(.addr(pc_OUT[7:0]), .data_out(Inst));
Mem mem(.clk(clk), .MemRead(EX_MEM_Ctrl[6]), .MemWrite(EX_MEM_Ctrl[2]), .addr(mux_mem_addr), .data_in(EX_MEM_RegR2), .func3(EX_MEM_Func[2:0]), .data_out(mem_out));
Reg #(96) IF_ID ({pc_OUT,Inst,sum_pc},clk,1'b1,rst, {IF_ID_PC,IF_ID_Inst,IF_ID_sumPC} );
always @(mem_out) begin
if (clk)
Inst <= mem_out;
else
mem_data_out <= mem_out;
end 
//////////////////ID/EX//////////////////////
Control_unit CU( .opcode(IF_ID_Inst[6:0]), .EC_EB(IF_ID_Inst[20]), .Branch(Branch), .MemRead(MemRead), 
.MemtoReg(MemtoReg), .ALUOp(ALUOp), .Rd_sel(Rd_sel), .MemWrite(MemWrite), .ALUSrc(ALUSrc), 
.RegWrite(RegWrite), .pc_sel(pc_sel), .JAL(JAL), .EC_FE(EC_FE), .EB(EB));
assign CU_signals = {Rd_sel, pc_sel, JAL, EC_FE, EB, Branch, MemRead, MemtoReg,ALUOp,MemWrite, ALUSrc, RegWrite};
n_mux4by1 #(32) mux_rd(.sel(MEM_WB_Ctrl[13:12]), .A(MEM_WB_BranchAddOut), .B(MEM_WB_sumPC), .C(Write_data_Rd), .D(32'd0), .Out(Write_data));//working
Reg_file #(32) RF(.D(Write_data), .ReadReg1(ReadReg1), .ReadReg2(ReadReg2), 
.WriteReg(MEM_WB_Rd), .clk(clk), .rst(rst), .RegWrite(MEM_WB_Ctrl[0]), .Read_data1(Read_data1),.Read_data2(Read_data2) );
rv32_ImmGen imm_gen(.IR(IF_ID_Inst), .Imm(gen_out));
Reg #(193) ID_EX ({CU_signals,IF_ID_PC,Read_data1,Read_data2,gen_out,{IF_ID_Inst[30],IF_ID_Inst[14:12]},
ReadReg1,ReadReg2, WriteReg, IF_ID_sumPC},clk,1'b1,rst,{ID_EX_Ctrl,ID_EX_PC,
ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_sumPC} );
//////////////////EX/Mem//////////////////////
n_mux2by1 #(32)mux_fromRF( .sel(ID_EX_Ctrl[1]), .A(ID_EX_RegR2), .B(ID_EX_Imm), .Out(mux_to_ALU));
ALU_CU ALUControl(.ALUOp(ID_EX_Ctrl[4:3]), .Inst(ID_EX_Func), .ALU_Sel(ALU_Sel));
prv32_ALU alu( .a(ID_EX_RegR1), .b(mux_to_ALU), .shamt(ID_EX_Rs2), .r(ALUout) , 
.cf(cf), .zf(zeroflag), .vf(vf), .sf(sf), .alufn(ALU_Sel) );
Branch_sign br(.funct3(ID_EX_Func[2:0]), .zf(zeroflag), .sf(sf), .vf(vf), .cf(cf), .BR(BR));
add_sub #(32) ADD_to_mux_PC(.Cin(1'b0), .A(ID_EX_PC), .B(ID_EX_Imm) , .Sum(sum_shift), .Cout(Cout));
Reg #(153) EX_MEM ({ID_EX_Ctrl,sum_shift,zeroflag,ALUout,ID_EX_RegR2,ID_EX_Rd,ID_EX_sumPC, BR, ID_EX_Func},clk,1'b1,rst,
 {EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_Zero,EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd,EX_MEM_sumPC, EX_MEM_BR, EX_MEM_Func} );//
///////////////////Mem/WB//////////////////////
assign and_pc = EX_MEM_Ctrl[7] & (EX_MEM_BR|EX_MEM_Ctrl[10]);
/*DataMem datamem( .clk(clk), .MemRead(EX_MEM_Ctrl[6]), .MemWrite(EX_MEM_Ctrl[2]), 
.addr(EX_MEM_ALU_out[7:0]), .data_in(EX_MEM_RegR2), .func3(EX_MEM_Func[2:0]), .data_out(mem_data_out));*/
Reg #(147) MEM_WB ({EX_MEM_Ctrl,mem_data_out,EX_MEM_ALU_out,EX_MEM_Rd, EX_MEM_sumPC, EX_MEM_BranchAddOut},clk,1'b1,rst,
 {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
MEM_WB_Rd, MEM_WB_sumPC,MEM_WB_BranchAddOut} ); //
/////////////////WB/IF/////////////////////
n_mux2by1 #(32)mem_mux(.sel(MEM_WB_Ctrl[5]), .A(MEM_WB_ALU_out), .B(MEM_WB_Mem_out), .Out(Write_data_Rd));

endmodule
