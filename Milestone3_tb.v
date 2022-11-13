`include "Milestone3.v" 
//////////////////////////////////////////////////////////////////////////////////
module Milestone3_tb();
reg clk, rst;
wire [31:0]Inst;
Milestone3 uut( clk, rst, Inst);
always #10 clk=~clk;
initial begin
$dumpfile("Milestone3.vcd");
$dumpvars(0, Milestone3_tb);
clk =0;rst=1;
#25;
rst=0;
#1000;
$finish;
end
endmodule
