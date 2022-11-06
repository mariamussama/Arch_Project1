
//////////////////////////////////////////////////////////////////////////////////
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
 mem[0]=32'h00002283;//000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
 mem[1]=32'h00402b03;
 mem[2]=32'h00802b83;//000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
 mem[3]=32'h41628333;//000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
 mem[4]=32'h0042e093;//0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2
 mem[5]=32'h002b1513;//0_000000_00011_00100_000_0100_0_1100011; //beq x4, x3, 4
 mem[6]=32'h01950533;//0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2
 mem[7]=32'h00032483;//0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2
 mem[8]=32'h000063b7;//0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)
 mem[9]=32'h00004417;//000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)
 mem[10]=32'h4022dc93;//0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1
 mem[11]=32'h04001863;//0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
 mem[12]=32'h001b0b13;//0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2
 mem[13]=32'hff5c80e3;//0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
 mem[14]=32'h00c0036f;
 mem[15]=32'h022c8263;
 mem[16]=32'h02219063;
 mem[17]=32'h0021ce63;
 mem[18]=32'h0021dc63;
 mem[19]=32'h0021ea63;
 mem[20]=32'h0021f863;
 mem[21]=32'h00528503;
 mem[22]=32'h00529503;
 mem[23]=32'h0052a503;
 mem[24]=32'h0043c503;
 mem[25]=32'h0092d503;
 mem[26]=32'h00110523;
 mem[27]=32'h00a10183;
 mem[28]=32'h00410093;///addi
 mem[29]=32'h00412093;/////////slti
 mem[30]=32'h00413093;
 mem[31]=32'h003170b3;//and x1 x2 x3      //32'h0110000f;/////////fence
 mem[32]=32'h00458503;
 mem[33]=32'h003100b3;
 mem[34]=32'h403100b3;
 mem[35]=32'h003110b3;
 mem[36]=32'h003120b3;
 mem[37]=32'h00712523;
 mem[38]=32'h00414093;
 mem[39]=32'h00416093;
 mem[40]=32'h00f14103;// lbu x2,15(x2) //32'h00000073;///////////ecall
 mem[41]=32'h00417093;
 mem[42]=32'h002c9293;
 mem[43]=32'h002cd293;
 mem[44]=32'h4022dc93;
 mem[45]=32'h003130b3;
 mem[46]=32'h003140b3;
 mem[47]=32'h00f05303;//lhu x6, 15(x0)  //32'h00100073;//////////ebreak
 mem[48]=32'h003150b3;
 mem[49]=32'h403150b3;
 mem[50]=32'h003160b3;
 mem[51]=32'h01100383;//lb x7,17(x0)

 end 
 
 
endmodule
////////////////////////////////////////////////////////////////////////////////////////
module DataMem (input clk, input MemRead, input MemWrite, input [7:0] addr, input [31:0] data_in, input [2:0]func3, output reg [31:0] data_out);
 reg [7:0] mem [0:255];
 //wire [5:0]addr;
 //integer i;
 //assign addr= {address[3:0],2'b00};
 always @(posedge clk) begin
 if(MemWrite)begin///working
 if (func3==3'b000) mem[addr]<=data_in[7:0];
 if (func3==3'b001) {mem[addr+1], mem[addr]}<=data_in[15:0];
 if (func3==3'b010) {mem[addr+3], mem[addr+2],mem[addr+1],mem[addr] }<=data_in;
 end

 end
 always@ (*) begin
  if (MemRead)begin
  if (func3==3'b000) data_out<={{24{mem[addr][7]}},mem[addr]};//lb
  if (func3==3'b001) data_out<={{16{mem[addr+1][7]}},mem[addr+1], mem[addr]};//lh
  if (func3==3'b010) data_out<={mem[addr+3], mem[addr+2],mem[addr+1],mem[addr] };//lw
  if (func3==3'b100) data_out<={{24{1'b0}},mem[addr]};//lbu
  if (func3==3'b101) data_out<={{16{1'b0}},mem[addr+1], mem[addr]};//lhu
  end
 end
 /*initial begin
 for(i = 0; i<64; i=i+1) begin
   mem[i] = i; 
 end
 end*/
 initial begin
 mem[0]=8'd17;
 mem[1]=8'd0; 
 mem[2]=8'd0; 
 mem[3]=8'd0; 
 mem[4]=8'd9; 
 mem[5]=8'd0; 
 mem[6]=8'd0;
 mem[7]=8'd0; 
 mem[8]=8'd25; 
 mem[9]=8'd0;
 mem[10]=8'd0;
 mem[11]=8'd0;
 mem[12]=8'd25;
 mem[13]=8'd0;  
 mem[14]=8'd0;  
 mem[15]=8'b00000001;  
 mem[16]=8'b01100000; //24577 for 15-16
 mem[17]=8'b10101010;//170, -86
 end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Reg_RF_Mem(

    );
endmodule
