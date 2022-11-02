
module mux2by1(input sel, input A, input B, output res);
assign res = sel? B : A;
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module n_mux2by1 #(parameter N=8)(input sel,input [N-1:0]A, input [N-1:0]B, output [N-1:0]Out);
genvar i ;
generate
for( i = 0; i<N; i=i+1) begin
mux2by1 m1 (sel, A[i], B[i],Out[i]);
end
endgenerate 
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module mux4by1 (input [1:0]sel, input A, input B,input C, input D, output reg res);
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module n_mux4by1 #(parameter N=32)(input [1:0]sel,input [N-1:0]A, input [N-1:0]B,input [N-1:0]C, input [N-1:0]D, output [N-1:0]Out);
genvar i ;
generate
for( i = 0; i<N; i=i+1) begin
mux4by1 m1 (sel, A[i], B[i], C[i], D[i], Out[i]);
end
endgenerate 
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module add_sub #(parameter N=32)(input Cin, input [N-1:0]A, input[N-1:0]B,output [N-1:0]Sum, output Cout);
assign {Cout,Sum} = A + B + Cin;
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Mux_Addr(

    );
endmodule
