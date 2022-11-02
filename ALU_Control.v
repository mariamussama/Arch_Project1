`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 12:50:11 PM
// Design Name: 
// Module Name: ALU_Control
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
module Control_unit(input [6:0]opcode, output reg Branch, MemRead, MemtoReg, output reg [1:0] ALUOp, output reg MemWrite, ALUSrc, RegWrite);
always @(*) begin
case(opcode[6:2]) 
5'b01100: begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b10;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 1;
            end
5'b00000: begin Branch = 0; 
            MemRead = 1; 
            MemtoReg = 1;
            ALUOp = 2'b00;
            MemWrite = 0; 
            ALUSrc = 1;
            RegWrite = 1;
            end
5'b01000: begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 1'bx ;
            ALUOp = 2'b00;
            MemWrite = 1; 
            ALUSrc = 1;
            RegWrite = 0;
            end
5'b11000: begin Branch = 1; 
            MemRead = 0; 
            MemtoReg = 1'bx;
            ALUOp = 2'b01;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            end
default:begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b00;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            end
endcase
end

endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ALU_CU(input [1:0] ALUOp, input [3:0] Inst, output [3:0] ALU_Sel);
/*assign ALU_Sel = (ALUOp == 2'b00)? 4'b0010://add
                 (ALUOp == 2'b01)? 4'b0110://sub
                 (ALUOp == 2'b10 && Inst[14:12] == 3'b000 && Inst[30])? 4'b0110://sub
                 (ALUOp == 2'b10 && Inst[14:12] == 3'b000)? 4'b0010://add
                 (ALUOp == 2'b10 && Inst[14:12] == 3'b111 && Inst[30]==1'b0)? 4'b0000://and
                 (ALUOp == 2'b10 && Inst[14:12] == 3'b110 && Inst[30]==1'b0)? 4'b0001://or
                 4'b1111;*/
always @ * begin
  case (ALUOp)
    2'b00 : ALU_Sel = 4'b0000;//load and store
    2'b01 : ALU_Sel = 4'b0001;//branch
    2'b10 : begin 
        if (Inst[2:0] == 3'b000 && Inst[30])
        ALU_Sel = 4'b0001;//sub
        else if (Inst[2:0] == 3'b000)
        ALU_Sel = 4'b0000;//add
        else if (Inst[2:0] == 3'b111 && ~Inst[30])
        ALU_Sel = 4'b0101;//and
        else if (Inst[2:0] == 3'b110 && ~Inst[30])
        ALU_Sel = 4'b0100;//or
        else if (Inst[2:0] == 3'b100 && ~Inst[30])
        ALU_Sel = 4'b0111;//xor 
        else if (Inst[2:0] == 3'b001 && ~Inst[30])
        ALU_Sel = 4'b1000;//sll
        else if (Inst[2:0] == 3'b101 && ~Inst[30])
        ALU_Sel = 4'b1001;//srl
        else if (Inst[2:0] == 3'b101)
        ALU_Sel = 4'b1010;//sra
        else if (Inst[2:0] == 3'b010 && ~Inst[30])
        ALU_Sel = 4'b1101;//slt
        else if (Inst[2:0] == 3'b011 && ~Inst[30])
        ALU_Sel = 4'b1111;//sltu   
    end///////currently working 
    	default:	ALU_Sel = 4'b0000;
  endcase
end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*module ALU #(parameter N=32)(input [3:0]sel,input [N-1:0]A, input[N-1:0]B, output reg [N-1:0] ALUout, output zeroflag );
wire [N-1:0]Sum;
wire Cout;
wire [N-1:0]Bin;
wire [N-1:0]AND_out;
wire [N-1:0] OR_out;
assign Bin = sel[2]? ~B: B;
add_sub#(N) u1 (sel[2], A, Bin, Sum, Cout);
assign AND_out = A & B;
assign OR_out = A|B;
always @ * begin
  case (sel)
            // arithmetic
    4'b00_00 : ALUout = Sum;
    4'b00_01 : ALUout = Sum;
    4'b00_11 : ALUout = B;
            // logic
    4'b01_00:  ALUout = A | B;
    4'b01_01:  ALUout = A & B;
    4'b01_11:  ALUout = A ^ B;
            // shift
    4'b10_00:  ALUout=sh;
    4'b10_01:  ALUout=sh;
    4'b10_10:  ALUout=sh;
            // slt & sltu
    4'b11_01:  ALUout = {31'b0,(sf != vf)};
    4'b11_11:  ALUout = {31'b0,(~cf)};

	default:	ALUout = Sum;
  endcase
end
assign zeroflag = ALUout? 0: 1;
endmodule*/
module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [3:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;
            4'b00_11 : r = b;
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r=sh;
            4'b10_01:  r=sh;
            4'b10_10:  r=sh;
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; 
            4'b11_11:  r = {31'b0,(~cf)};            	
        endcase
    end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ALU_Control(

    );
endmodule
