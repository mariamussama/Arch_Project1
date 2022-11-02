`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 12:33:36 PM
// Design Name: 
// Module Name: Imm_Shift
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
module Shifter #(parameter N=6)(input [N-1:0]IN, output [N-1:0]Out);
    assign Out={IN[N-2:0],1'b0};
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////

module imm_generator(input[31:0]Inst, output [31:0]gen_out);
wire [6:0]opcode;
wire [11:0]immediate;
assign opcode = Inst[6:0];
assign immediate = (opcode[6] == 1'b1)? {Inst[31],Inst[7],Inst[30:25],Inst[11:8]}:
                   (opcode[5] == 1'b0)? {Inst[31:20]}: {Inst[31: 25], Inst[11:7]};
assign gen_out = {{20{immediate[11]}},immediate};
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Imm_Shift(

    );
endmodule
