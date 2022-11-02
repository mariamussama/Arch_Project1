`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 12:40:17 PM
// Design Name: 
// Module Name: TB_Mil1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_Mil1();
reg clk, rst;
always #20 clk=~clk;
full_cycle uut(clk, rst);
initial begin
clk =0;rst=1;
#100;
rst=0;
#500;
end
endmodule
