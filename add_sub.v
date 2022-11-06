module add_sub #(parameter N=32)(
    input Cin, 
    input [N-1:0]A, 
    input[N-1:0]B,
    output [N-1:0]Sum, 
    output Cout
    );
assign {Cout,Sum} = A + B + Cin;
endmodule