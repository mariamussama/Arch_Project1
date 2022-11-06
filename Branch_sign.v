`include "defines.v"
module Branch_sign(
    input [2:0]funct3, 
    input zf, 
    input sf, 
    input vf, 
    input cf, 
    output reg BR
    );
always @ * begin
  case (funct3)
    `BR_BEQ : BR = zf;
    `BR_BNE : BR = ~zf;
    `BR_BLT : BR = (sf != vf) ;
    `BR_BGE : BR = (sf == vf);
    `BR_BLTU : BR = ~cf;
    `BR_BGEU : BR = cf;
    default: BR = 1'b0;
  endcase
end
endmodule 