module InstMem (
    input [5:0] addr, 
    output [31:0] data_out
    );
 reg [31:0] mem [0:63];
 assign data_out = mem[addr];

 initial begin
mem[0]=32'h00002283;// lw x5, 0(x0)
mem[1]=32'h00402b03;// lw x22, 4(x0)
mem[2]=32'h00802b83;// lw x23, 8(x0)
mem[3]=32'h41628333;// sub x6, x5, x22
mem[4]=32'h0042e093;// ori x1, x5, 4
mem[5]=32'h002b1513;// Loop: slli x10, x22, 2
mem[6]=32'h01950533;// add x10, x10, x25
mem[7]=32'h00032483;//lw x9, 0(x6)
mem[8]=32'h000063b7;// lui x7, 6
mem[9]=32'h00004417;// auipc x8, 4
mem[10]=32'h030003e7;// jalr x7, 48(x0)
mem[11]=32'h04001a63;// bne x0, x0, Exit
mem[12]=32'h001b0b13;// addi x22, x22, 1
mem[13]=32'h035a8663;// beq x21, x21, label
mem[14]=32'h00c0036f;// jal x6, branch
mem[15]=32'h022c8263;// beq x25, x2, label
mem[16]=32'h02219063;// bne x3, x2, label
mem[17]=32'h001b4e63;// branch: blt x22, x1, label
mem[18]=32'h0021dc63;// bge x3, x2, label
mem[19]=32'h0021ea63;// bltu x3, x2, label
mem[20]=32'h0021f863;// bgeu x3, x2, label
mem[21]=32'h00528503;// lb x10, 5(x5)
mem[22]=32'h00529503;// lh x10, 5(x5)
mem[23]=32'h0052a503;// lw x10, 5(x5)
mem[24]=32'h0043c503;// label: lbu x10, 4(x7)
mem[25]=32'h0092d503;// lhu x10, 9(x5)
mem[26]=32'h00110523;// sb x1, 10(x2)
mem[27]=32'h00a10183;// lb x3, 10(x2)
mem[28]=32'h00711523;// sh x7, 10(x2)
mem[29]=32'h00410093;// addi x1, x2, 4
mem[30]=32'h00412093;// slti x1, x2, 4
mem[31]=32'h00413093;// sltiu x1, x2, 4
mem[32]=32'h00458503;// Exit: lb x10, 4(x11)
mem[33]=32'h003100b3;// add x1, x2, x3
mem[34]=32'h403100b3;//sub x1, x2, x3
mem[35]=32'h003110b3;// sll x1, x2, x3
mem[36]=32'h003120b3;// slt x1, x2, x3
mem[37]=32'h00712523;// sw x7, 10(x2)
mem[38]=32'h00414093;// xori x1, x2, 4
mem[38]=32'h00416093;// ori x1, x2, 4
mem[39]=32'h00417093;// andi x1, x2, 4
mem[40]=32'h002c9293;// slli x5, x25, 2
mem[41]=32'h002cd293;// srli x5, x25, 2
mem[42]=32'h4022dc93;// srai x25, x5, 2
mem[43]=32'h003130b3;// sltu x1, x2, x3
mem[44]=32'h003140b3;// xor x1, x2, x3
mem[45]=32'h003150b3;// srl x1, x2, x3
mem[46]=32'h403150b3;// sra x1, x2, x3
mem[47]=32'h003160b3;// or x1, x2, x3
mem[48]=32'h003170b3;// and x1, x2, x3
mem[49]=32'h00100073;//  ebreak
mem[50]=32'h00000033;// add x0, x0, x0
mem[51]=32'h40938333 ;//sub x6, x7, x9
mem[52]=32'h0110000f;//  fence 1, 1
mem[53]=32'h00000073;// ecall

 end 
endmodule