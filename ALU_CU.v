module ALU_CU(
    input [1:0] ALUOp, 
    input [3:0] Inst, 
    output reg [3:0] ALU_Sel
    );
    
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