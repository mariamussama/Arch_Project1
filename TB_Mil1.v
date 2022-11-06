`include "Milestone1.v" 
//////////////////////////////////////////////////////////////////////////////////
module TB_Mil1();
reg clk, rst;
wire [15:0]concat;
wire [31:0]Inst;//,pc_OUT,sum_pc,sum_shift,pc,Read_data1,Read_data2,Write_data_Rd,gen_out,mux_to_ALU,ALUout,mem_data_out;
full_cycle uut( clk, rst, Inst, concat);
//pc_OUT,sum_pc,sum_shift,pc,Read_data1,Read_data2,Write_data_Rd,gen_out,mux_to_ALU,ALUout,mem_data_out);
always #10 clk=~clk;
initial begin
$dumpfile("Milestone1.vcd");
$dumpvars(0, TB_Mil1);
clk =0;rst=1;
#25;
rst=0;
#1000;
$finish;
end
endmodule
