module NDFlipFlop(input clk, input rst, input D, output reg Q);
 always @ (negedge  clk or negedge  rst)
 if (rst) begin
 Q <= 1'b0;
 end else begin
 Q <= D;
 end
endmodule