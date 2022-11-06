module Control_unit(
    input [6:0]opcode,
    input EC_EB, 
    output reg Branch, 
    output reg MemRead,
    output reg MemtoReg, 
    output reg [1:0] ALUOp, 
    output reg [1:0] Rd_sel, 
    output reg MemWrite, 
    output reg ALUSrc, 
    output reg RegWrite, 
    output reg pc_sel,
    output reg JAL,
    output reg EC_FE,
    output reg EB
    );
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
            EC_FE=1'b0;
            EB=1'b1;
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
            EC_FE=1'b0;
            EB=1'b1;
            end
5'b01000: begin Branch = 0; 
            MemRead = 0; 
            MemtoReg = 1'b0 ;
            ALUOp = 2'b00;
            MemWrite = 1; 
            ALUSrc = 1;
            RegWrite = 0;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            EC_FE=1'b0;
            EB=1'b1;
            end
5'b11000: begin Branch = 1; //branch
            MemRead = 0; 
            MemtoReg = 1'b0;
            ALUOp = 2'b01;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            EC_FE=1'b0;
            EB=1'b1;
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
            EC_FE=1'b0;
            EB=1'b1;
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
            EC_FE=1'b0;
            EB=1'b1;
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
            EC_FE=1'b0;
            EB=1'b1;
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
            EC_FE=1'b0;
            EB=1'b1;
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
            EC_FE=1'b0;
            EB=1'b1;
            end
5'b11100: begin if (~EC_EB) begin
            Branch = 0; //ECALL
            MemRead = 0; 
            MemtoReg = 1'b0;
            ALUOp = 2'b01;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            EC_FE=1'b1;
            EB=1'b1;
            end
            else begin
            Branch = 0; //EBREAK
            MemRead = 0; 
            MemtoReg = 1'b0;
            ALUOp = 2'b01;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            EC_FE=1'b0;
            EB=1'b0;
            end
            end
5'b00011: begin Branch = 0; //FENCE
            MemRead = 0; 
            MemtoReg = 1'b0;
            ALUOp = 2'b01;
            MemWrite = 0; 
            ALUSrc = 0;
            RegWrite = 0;
            Rd_sel=2'b10;
            pc_sel = 1'b0;
            JAL=1'b0;
            EC_FE=1'b1;
            EB=1'b1;
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
            EC_FE=1'b0;
            EB=1'b1;
            end
endcase
end

endmodule