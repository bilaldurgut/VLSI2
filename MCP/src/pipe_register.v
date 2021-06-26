`timescale 1ns / 1ps


module pipe_register
#(
parameter WIDTH=32
)
(
input 		   				clk,rst,
input [WIDTH-1 : 0] 		D,
output reg [WIDTH-1 : 0] 	Q
);

integer i;

always@(posedge clk)
begin

	if(rst)
	begin
		for(i=0 ; i<WIDTH ; i=i+1)
		begin
			Q[i] <= 0;
		end
	end
	else
	begin
		for(i=0 ; i<WIDTH ; i=i+1)
		begin
			Q[i] <= D[i];
		end		
	end

end

endmodule
