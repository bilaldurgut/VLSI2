module CON_COMP_1_bit
(
input 	
		a,
		b,
		x_left,
		y_left,
		z_left,

output 	
		x_right,
		y_right,
		z_right
);

wire 	x_up,
		y_up,
		z_up;
		
COMP_1_bit COMP_1_bit_inst
						(
						.a		(a),
						.b		(b),
						.x		(x_up),
						.y		(y_up),
						.z		(z_up)
						);

CONNECT CONNECT_inst
						(
						.x_up		(x_up),
						.y_up		(y_up),
						.z_up		(z_up),
						.x_left		(x_left),
						.y_left		(y_left),
						.z_left		(z_left),
						.x_right	(x_right),
						.y_right	(y_right),
						.z_right	(z_right)
						);

endmodule