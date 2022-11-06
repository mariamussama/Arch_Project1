`include "Milestone1.v" 
//////////////////////////////////////////////////////////////////////////////////
module Milestone1_tb();
reg clk, rst;
wire [31:0]Inst;
Milestone1 uut( clk, rst, Inst);
always #10 clk=~clk;
initial begin
$dumpfile("Milestone1.vcd");
$dumpvars(0, Milestone1_tb);
clk =0;rst=1;
#25;
rst=0;
#1000;
$finish;
end
endmodule
