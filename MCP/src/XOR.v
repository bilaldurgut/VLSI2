`timescale 1ns / 1ps
module XOR
    #(parameter WIDTH = 32)
    (
	input [WIDTH-1:0] I1,
	input [WIDTH-1:0] I2,
	output [WIDTH-1:0] O
	);


assign O = I1^I2;

endmodule