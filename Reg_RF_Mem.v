module DFlipFlop(input clk, input rst, input D, output reg Q);
 always @ (posedge clk or posedge rst)
 if (rst) begin
 Q <= 1'b0;
 end else begin
 Q <= D;
 end
endmodule 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Reg#(parameter N=32)(input [N-1:0]D,input clk, input load, input rst, output [N-1:0]Q);
// wire [N-1:0]Q;
  wire [N-1:0]DD;
genvar i ;
generate
for( i = 0; i<N; i=i+1) begin
mux2by1 m1 (load, Q[i], D[i],DD[i]);
DFlipFlop m2 (clk, rst, DD[i], Q[i]);
end
endgenerate 

endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Reg_file#(parameter N=32) (input[N-1:0]D, input [4:0]ReadReg1, input [4:0]ReadReg2, input [4:0]WriteReg, input clk,input rst, input RegWrite, output [N-1:0] Read_data1, output [N-1:0]Read_data2 );
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
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module InstMem (input [5:0] addr, output [31:0] data_out);
 reg [31:0] mem [0:63];
 assign data_out = mem[addr];
integer i;

/*initial begin
for(i = 0; i<64; i=i+1) begin
   mem[i] = i; 
 end
 end*/
 
 initial begin
 mem[0]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
 mem[1]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
 mem[2]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
 mem[3]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
 mem[4]=32'b0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
 mem[5]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
 mem[6]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
 mem[7]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
 mem[8]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
 mem[9]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
 mem[10]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
 mem[11]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
 mem[12]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
 end 
 
 
endmodule
////////////////////////////////////////////////////////////////////////////////////////
module DataMem (input clk, input MemRead, input MemWrite, input [5:0] addr, input [31:0] data_in, input [2:0]func3, output reg [31:0] data_out);
 reg [7:0] mem [0:63];
 integer i;
 always @(posedge clk) begin
 if(MemWrite)///working
 if (func3==3'b000) mem[addr]<=data_in;
 if (func3==3'b001) {mem[addr], mem[addr+1]}<=data_in;
 if (func3==3'b010) {mem[addr], mem[addr+1],mem[addr+2],mem[addr+3] }<=data_in;

 end
 always@(*) begin
  if (MemRead)///working
 //data_out<= mem[addr];
  if (func3==3'b000) data_out<=mem[addr];
  if (func3==3'b001) data_out<={mem[addr], mem[addr+1]};
  if (func3==3'b010) data_out<={mem[addr], mem[addr+1],mem[addr+2],mem[addr+3] };
 end
 /*initial begin
for(i = 0; i<64; i=i+1) begin
   mem[i] = i; 
 end
 end*/
 initial begin
 mem[0]=7'd17;
 mem[1]=7'd9; 
 mem[2]=7'd25; 

 end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Reg_RF_Mem(

    );
endmodule
