
module Four_Digit_Seven_Segment_Driver(
input clk,
 input [13:0] num,
 output reg [3:0] Anode,
 output reg [6:0] LED_out
 );
 
 reg [3:0] LED_BCD;
 reg [19:0] refresh_counter = 0; // 20-bit counter
 wire [1:0] LED_activating_counter;
 always @(posedge clk)
 begin
 refresh_counter <= refresh_counter + 1;
 end

 assign LED_activating_counter = refresh_counter[19:18];

 always @(*)
 begin
 case(LED_activating_counter)
 2'b00: begin
 Anode = 4'b0111;
 LED_BCD = num/1000;
 end
 2'b01: begin
 Anode = 4'b1011;
 LED_BCD = (num % 1000)/100;
 end
 2'b10: begin
 Anode = 4'b1101;
 LED_BCD = ((num % 1000)%100)/10;
 end
 2'b11: begin
 Anode = 4'b1110;
 LED_BCD = ((num % 1000)%100)%10;
 end
 endcase
 end
 always @(*)
 begin
 case(LED_BCD)
 4'b0000: LED_out = 7'b0000001; // "0"
 4'b0001: LED_out = 7'b1001111; // "1"
 4'b0010: LED_out = 7'b0010010; // "2"
 4'b0011: LED_out = 7'b0000110; // "3"
 4'b0100: LED_out = 7'b1001100; // "4"
 4'b0101: LED_out = 7'b0100100; // "5"
 4'b0110: LED_out = 7'b0100000; // "6"
 4'b0111: LED_out = 7'b0001111; // "7"
 4'b1000: LED_out = 7'b0000000; // "8"
 4'b1001: LED_out = 7'b0000100; // "9"
 default: LED_out = 7'b0000001; // "0"
 endcase
 end 

endmodule

module Display (input [1:0]LedSel,input [3:0]ssdSel ,input clk,rclk,rst,output reg [15:0] LED, output[3:0] Anode,output[6:0] LED_out);//, output reg [15:0] LED);
   // wire [3:0] Anode;
   // wire [6:0] LED_out;
    reg [12:0]SSD;
    wire [31:0]Inst;
    wire [15:0]concat;
    wire [31:0]pc_OUT,sum_pc,sum_shift,pc,Read_data1,Read_data2,Write_data,gen_out,shift_Out,mux_to_ALU,ALUout,mem_data_out;
    full_cycle m (rclk, rst,Inst, concat,pc_OUT,sum_pc,sum_shift,pc,Read_data1,Read_data2,Write_data,gen_out,shift_Out,mux_to_ALU,ALUout,mem_data_out );
 always @( *) begin
 case(LedSel)
 2'b00: LED = Inst[15:0]; 
 2'b01: LED = Inst[31:16];
 2'b10: LED = concat; 
 default: LED = 16'd0; // "0"
 endcase
 end 
  always @( *) begin
 case(ssdSel)
 4'b0000: SSD = pc_OUT; 
 4'b0001: SSD = sum_pc;
 4'b0010: SSD = sum_shift;
 4'b0011: SSD = pc;
 4'b0100: SSD = Read_data1;
 4'b0101: SSD = Read_data2;
 4'b0110: SSD = Write_data;
 4'b0111: SSD = gen_out;
 4'b1000: SSD = shift_Out;
 4'b1001: SSD = mux_to_ALU;
 4'b1010: SSD = ALUout;
 4'b1011: SSD = mem_data_out;
 default: SSD = 13'd0; // "0"
 endcase
 end
    Four_Digit_Seven_Segment_Driver uut(clk,SSD ,Anode,LED_out);
 
endmodule


