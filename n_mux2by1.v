`include "mux2by1.v"
module n_mux2by1 #(parameter N=8)(
    input sel,
    input [N-1:0]A, 
    input [N-1:0]B, 
    output [N-1:0]Out
    );
genvar i ;
generate
for( i = 0; i<N; i=i+1) begin
mux2by1 m1 (sel, A[i], B[i],Out[i]);
end
endgenerate 
endmodule