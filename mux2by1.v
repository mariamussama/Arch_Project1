module mux2by1(
    input sel, 
    input A, 
    input B, 
    output res
    );
assign res = sel? B : A;
endmodule