`include "defines.v"

//////////////////////////////////////////////////////////////////////////////////

module rv32_ImmGen (
    input  wire [31:0]  IR,
    output reg  [31:0]  Imm
);

always @(*) begin
	case (`OPCODE)
		`OPCODE_Arith_I   : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		`OPCODE_Store     :     Imm = { {21{IR[31]}}, IR[30:25], IR[11:8], IR[7] };
		`OPCODE_LUI       :     Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		`OPCODE_AUIPC     :     Imm = { IR[31], IR[30:20], IR[19:12], 12'b0 };
		`OPCODE_JAL       : 	Imm = { {12{IR[31]}}, IR[19:12], IR[20], IR[30:25], IR[24:21], 1'b0 };
		`OPCODE_JALR      : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] };
		`OPCODE_Branch    : 	Imm = { {20{IR[31]}}, IR[7], IR[30:25], IR[11:8], 1'b0};
		default           : 	Imm = { {21{IR[31]}}, IR[30:25], IR[24:21], IR[20] }; // IMM_I
	endcase 
end

endmodule
/*module Shifter #(parameter N=6)(input [N-1:0]IN, output [N-1:0]Out);
    assign Out={IN[N-2:0],1'b0};
endmodule*/
///////////////////////////////////////////////////////////////////////////////////////////////////
/*
module imm_generator(input[31:0]Inst, output [31:0]gen_out);
wire [6:0]opcode;
wire [11:0]immediate;
assign opcode = Inst[6:0];
assign immediate = (opcode[6] == 1'b1)? {Inst[31],Inst[7],Inst[30:25],Inst[11:8]}:
                   (opcode[5] == 1'b0)? {Inst[31:20]}: {Inst[31: 25], Inst[11:7]};
assign gen_out = {{20{immediate[11]}},immediate};
endmodule*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Imm_Shift(

    );
endmodule
