`include "defines.v"
/*module mirror (input [31:0] in, output reg [31:0] out);
    integer i;
    always @ *
        for(i=0; i<32; i=i+1)
            out[i] = in[31-i];
endmodule
////////////////////////////////////////////////////////////////////////////////////////////
// Shift Right Unit
module shr(input [31:0] a, output [31:0] r, input [4:0] shamt, input ar);

    wire [31:0] r1, r2, r3, r4;

    wire fill = ar ? a[31] : 1'b0;
    assign r1 = shamt[0] ? {{1{fill}}, a[31:1]} : a;
    assign r2 = shamt[1] ? {{2{fill}}, r1[31:2]} : r1;
    assign r3 = shamt[2] ? {{4{fill}}, r2[31:4]} : r2;
    assign r4 = shamt[3] ? {{8{fill}}, r3[31:8]} : r3;
    assign r = shamt[4] ? {{16{fill}}, r4[31:16]} : r4;

endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////
// The Shifter
module shift(
	input wire [31:0] a,
	input wire [4:0] shamt,
	input wire [1:0] typ,	// type[0] sll or srl - type[1] sra
							// 00 : srl, 10 : sra, 01 : sll
	output wire [31:0] r
	);
    wire [31 : 0] ma, my, y, x, sy;

    mirror m1(.in(a), .out(ma));
    mirror m2(.in(y), .out(my));

    assign x = typ[0] ? ma : a;
    shr sh0(.a(x), .r(y), .shamt(shamt), .ar(typ[1]));

    assign r = typ[0] ? my : y;

endmodule*/
//////////////////////////////////////////////////////////////////////////////////////////////////////
// The Shifter
module shift(
	input wire [31:0] a,
	input wire [4:0] shamt,
	input wire [1:0] typ,	// type[0] sll or srl - type[1] sra
							// 00 : srl, 10 : sra, 01 : sll
	output reg [31:0] r 
   // wire [shamt: 0] ext = shamt{a[31]};
	);
   // parameter sh=shamt;
    //wire [shamt: 0] zero = 0;
   /* wire [31 : 0] ma, my, y, x, sy;

    mirror m1(.in(a), .out(ma));
    mirror m2(.in(y), .out(my));

    assign x = typ[0] ? ma : a;
    shr sh0(.a(x), .r(y), .shamt(shamt), .ar(typ[1]));

    assign r = typ[0] ? my : y;*/
always @ * begin
  case (typ)
    2'b00 : r = (a<<shamt);//sll
    2'b01 : r = (a>>shamt);//srl
    2'b10 : r = (a>>>shamt); //sra
   // 2'b11 : r = (a>>shamt);
        default : r = a;
    endcase
end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Control_unit(input [6:0]opcode, output reg Branch, MemRead, MemtoReg, output reg [1:0] ALUOp, Rd_sel, output reg MemWrite, ALUSrc, RegWrite, pc_sel,JAL);
always @(*) begin
case(opcode[6:2]) 
5'b01100: begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b10;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 1;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            end
5'b00000: begin Branch = 0; 
            MemRead = 1; 
            MemtoReg = 1;
            ALUOp = 2'b00;
            MemWrite = 0; 
            ALUSrc = 1;
            RegWrite = 1;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            end
5'b01000: begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 1'bx ;
            ALUOp = 2'b00;
            MemWrite = 1; 
            ALUSrc = 1;
            RegWrite = 0;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            end
5'b11000: begin Branch = 1; 
            MemRead = 0; 
            MemtoReg = 1'bx;
            ALUOp = 2'b01;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            end
5'b00100: begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b10;
            MemWrite = 0; 
            ALUSrc = 1;
            RegWrite = 1;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            end
5'b11011: begin Branch = 1; //JAL
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b10;
            MemWrite = 0; 
            ALUSrc = 1;
            RegWrite = 1;
            Rd_sel=2'b01;
            pc_sel = 1'b0;
            JAL=1'b1;
            end
5'b11001: begin Branch = 1; //JALR
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b10;
            MemWrite = 0; 
            ALUSrc = 1;
            RegWrite = 1;
            Rd_sel=2'b01;
            pc_sel=1'b1;
            JAL=1'b0;
            end
5'b00101: begin Branch = 0; //AUIPC
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b00;
            MemWrite = 0; 
            ALUSrc = 1;
            RegWrite = 1;
            Rd_sel=2'b00;
            pc_sel = 1'b0;
            JAL=1'b0;
            end
5'b01101: begin Branch = 0; //LUI
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b00;
            MemWrite = 0; 
            ALUSrc = 1;
            RegWrite = 1;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            end
default:begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 0;
            ALUOp = 2'b00;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            Rd_sel=2'b11;
            pc_sel=1'b0;
            JAL=1'b0;
            end
endcase
end

endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ALU_CU(input [1:0] ALUOp, input [3:0] Inst, output reg [3:0] ALU_Sel);
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
        if (Inst[2:0] == 3'b000 && Inst[3])
        ALU_Sel = 4'b0001;//sub
        else if (Inst[2:0] == 3'b000)
        ALU_Sel = 4'b0000;//add
        else if (Inst[2:0] == 3'b111)
        ALU_Sel = 4'b0101;//and
        else if (Inst[2:0] == 3'b110)
        ALU_Sel = 4'b0100;//or
        else if (Inst[2:0] == 3'b100)
        ALU_Sel = 4'b0111;//xor 
        else if (Inst[2:0] == 3'b001)
        ALU_Sel = 4'b1000;//sll
        else if (Inst[2:0] == 3'b101 && ~Inst[3])
        ALU_Sel = 4'b1001;//srl
        else if (Inst[2:0] == 3'b101)
        ALU_Sel = 4'b1010;//sra
        else if (Inst[2:0] == 3'b010)
        ALU_Sel = 4'b1101;//slt
        else if (Inst[2:0] == 3'b011)
        ALU_Sel = 4'b1111;//sltu   
    end
    	default:	ALU_Sel = 4'b0000;
  endcase
end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,//Inst[24:20]
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
    shift shifter0(.a(a), .shamt(shamt), .typ(alufn[1:0]),  .r(sh));
    
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
module Branch_sign(input [2:0]funct3, input zf, input sf, input vf, input cf, output reg BR);
always @ * begin
  case (funct3)
    `BR_BEQ : BR = zf;
    `BR_BNE : BR = ~zf;
    `BR_BLT : BR = (sf != vf) ;
    `BR_BGE : BR = (sf == vf);
    `BR_BLTU : BR = ~cf;
    `BR_BGEU : BR = cf;
    default: BR = 1'b0;
  endcase
end
endmodule 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ALU_Control(

    );
endmodule
