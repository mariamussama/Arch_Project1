`include "mux4by1.v"
module n_mux4by1 #(parameter N=32)(
    input [1:0]sel,
    input [N-1:0]A, 
    input [N-1:0]B,
    input [N-1:0]C, 
    input [N-1:0]D, 
    output [N-1:0]Out
    );
genvar i ;
generate
for( i = 0; i<N; i=i+1) begin
mux4by1 m1 (sel, A[i], B[i], C[i], D[i], Out[i]);
end
endgenerate 
endmodule