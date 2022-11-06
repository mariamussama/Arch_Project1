module shift(
	input wire [31:0] a,
	input wire [4:0] shamt,
	input wire [1:0] typ,	// type[0] sll or srl - type[1] sra
							// 00 : srl, 10 : sra, 01 : sll
	output reg [31:0] r 
	);

always @ * begin
  case (typ)
    2'b00 : r = (a<<shamt);//sll
    2'b01 : r = (a>>shamt);//srl
    2'b10 : r = (a>>>shamt); //sra
        default : r = a;
    endcase
end
endmodule