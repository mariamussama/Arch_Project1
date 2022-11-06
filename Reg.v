`include"DFlipFlop.v"
module Reg#(parameter N=32)(
    input [N-1:0]D,
    input clk, 
    input load, 
    input rst, 
    output [N-1:0]Q
    );
  wire [N-1:0]DD;
genvar i ;
generate
for( i = 0; i<N; i=i+1) begin
mux2by1 m1 (load, Q[i], D[i],DD[i]);
DFlipFlop m2 (clk, rst, DD[i], Q[i]);
end
endgenerate 

endmodule