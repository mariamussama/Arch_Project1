module DataMem (
    input clk, 
    input MemRead, 
    input MemWrite, 
    input [7:0] addr, 
    input [31:0] data_in, 
    input [2:0]func3, 
    output reg [31:0] data_out
    );
 reg [7:0] mem [0:255];

 always @(posedge clk) begin
 if(MemWrite)begin
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