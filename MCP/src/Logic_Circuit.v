`timescale 1ns / 1ps

module Logic_Circuit(

input [31:0] A,B,
input [1:0] select,
output reg [31:0] result
);
wire [31:0] w1,w2,w3;

AND and1(A,B,w1);
OR  or1(A,B,w2);
//NOT not1(A,w3);
XOR xor1(A,B,w3);

always@(A,B,select,w1,w2,w3)
    begin
        if(select[1])
		begin
			result <= w1;
		end
		
		else 
		begin
			if(select[0])
			begin
				result <=w2;
			end
			else 
			begin
				result <=w3;
			end
		end
    end
endmodule
