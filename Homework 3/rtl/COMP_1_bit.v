module COMP_1_bit
(
input 		
			a,
			b,
output	
			x,
			y,
			z
);


assign x = (a & ~b) 	? 1'b1 : 1'b0;
assign y = ~(a ^ b)	    ? 1'b1 : 1'b0;
assign z = (~a & b) 	? 1'b1 : 1'b0;

endmodule