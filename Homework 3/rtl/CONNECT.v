module CONNECT 
(
input 	
		x_left,
		x_up,
		y_left,
		y_up,
		z_left,
		z_up,
output	
		x_right,
		y_right,
		z_right
);
				
assign x_right = x_left | 	 (x_up & y_left);
assign y_right = y_left & 			   y_up ;
assign z_right = z_left | 	 (z_up & y_left);

endmodule