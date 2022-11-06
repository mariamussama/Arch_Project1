`include "Reg.v"
module Reg_file#(parameter N=32) (
    input[N-1:0]D, 
    input [4:0]ReadReg1, 
    input [4:0]ReadReg2, 
    input [4:0]WriteReg, 
    input clk,
    input rst, 
    input RegWrite, 
    output [N-1:0] Read_data1, 
    output [N-1:0]Read_data2 
    );
wire [N-1:0]Q[31:0];
reg [31:0]load;
always @(*)begin
load = 32'b0;
if(WriteReg)begin
load[WriteReg]=RegWrite;
end
end

genvar i;
generate
for( i = 0; i<32; i=i+1) begin
Reg #(N) r( D,clk,load[i], rst, Q[i]);
end
endgenerate

assign Read_data1= Q[ReadReg1];
assign Read_data2= Q[ReadReg2];
endmodule