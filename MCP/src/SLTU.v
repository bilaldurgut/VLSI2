module SLTU(
    input [31:0] A,
    input [31:0] B,
    //input [2:0] Control_Signals,
    output [31:0] R

    );
    wire Cout;
    wire [32:0] R_out;
    wire [32:0] A_33, B_33;

    assign A_33 = {1'b0, A};
    assign B_33 = {1'b0, B};

    sub #(.WIDTH(33)) u2(.A(A_33),.B(~B_33),.Cout(Cout),.sum(R_out));

    assign R = R_out[32] ? 1 : 0 ;

endmodule