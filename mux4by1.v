module mux4by1 (
    input [1:0]sel, 
    input A, 
    input B,
    input C, 
    input D, 
    output reg res
    );
always @ * begin
  case (sel)
    2'b00 : res = A;
    2'b01 : res = B;
    2'b10 : res = C;
    2'b11 : res = D;
    default: res = D;
  endcase
end
endmodule