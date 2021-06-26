`timescale 1ns / 1ps

module FU(
    input [31:0] A,
    input [31:0] B,
    input  [3:0] FS,
    output V,C,N,Z,
    output [31:0] F
    );
wire [31:0] w0,w1 ;
        
    ALU alu(.A(A), .B(B), .Gout(w0), .G_select(FS[2:0]), .CarryF(C), 
            .OverflowF(V), .NegativeF(N), .ZeroF(Z));
    Shifter  shifter(.in(B), .out(w1), .sel(FS[2:0]), .k(A[5:0]));
    MUX2 #(.WIDTH(32)) mux(.C0(w0),.C1(w1),.O(F), .S(FS[3]));
endmodule
