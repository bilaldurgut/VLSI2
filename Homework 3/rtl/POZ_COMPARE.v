module POZ_COMPARE
(
input
		a_0,
		a_1,
		a_2,
		a_3,
		b_0,
		b_1,
		b_2,
		b_3,
output 
		x,
		y,
		z
);

wire 	x_1,
		x_2,
		x_3,
		y_1,
		y_2,
		y_3,
		z_1,
		z_2,
		z_3;
		
CON_COMP_1_bit CON_COMP_1_bit_inst1 (
									.a			(a_0),
									.b			(b_0),
									.x_right	(x),
									.y_right	(y),
									.z_right	(z),
									.x_left		(x_1),
									.y_left		(y_1),
									.z_left		(z_1)
									);

CON_COMP_1_bit CON_COMP_1_bit_inst2 (
									.a			(a_1),
									.b			(b_1),
									.x_right	(x_1),
									.y_right	(y_1),
									.z_right	(z_1),
									.x_left		(x_2),
									.y_left		(y_2),
									.z_left		(z_2)
									);

CON_COMP_1_bit CON_COMP_1_bit_inst3 (
									.a			(a_2),
									.b			(b_2),
									.x_right	(x_2),
									.y_right	(y_2),
									.z_right	(z_2),
									.x_left		(x_3),
									.y_left		(y_3),
									.z_left		(z_3)
									);

COMP_1_bit COMP_1_bit_inst			(
									.a			(a_3),
									.b			(b_3),
									.x			(x_3),
									.y			(y_3),
									.z			(z_3)
									);
									
endmodule