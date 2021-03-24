module COMPARE
(
input
		a_0, b_0,
		a_1, b_1,
		a_2, b_2,
		a_3, b_3,
		a_4, b_4,
		a_5, b_5,
		a_6, b_6,
		a_7, b_7,
output
		x,
		y,
		z
		
);

wire 	x_left,
		y_left,
		z_left,
		
		signed_x_left,
		signed_z_left,
		
		x_right,
		y_right,
		z_right;
		
POZ_COMPARE POZ_COMPARE_inst_left	(
									.a_3 (a_7),
									.a_2 (a_6),
									.a_1 (a_5),
									.a_0 (a_4),
									.b_3 (b_7),
									.b_2 (b_6),
									.b_1 (b_5),
									.b_0 (b_4),
									.x	(x_left),
									.y 	(y_left),
									.z 	(z_left)
									);
									
POZ_COMPARE POZ_COMPARE_inst_right	(
									.a_3 (a_3),
									.a_2 (a_2),
									.a_1 (a_1),
									.a_0 (a_0),
									.b_3 (b_3),
									.b_2 (b_2),
									.b_1 (b_1),
									.b_0 (b_0),
									.x	(x_right),
									.y 	(y_right),
									.z 	(z_right)
									);			
			
MUX MUX_inst_x_left(
					.a_0	(x_left),
					.a_1	(1'b1),
					.a_2	(1'b0),
					.a_3	(x_left),
					.s_0	(b_7),
					.s_1	(a_7),
					.f		(signed_x_left)
					);
					
MUX MUX_inst_z_left(
					.a_0	(z_left),
					.a_1	(1'b0),
					.a_2	(1'b1),
					.a_3	(z_left),
					.s_0	(b_7),
					.s_1	(a_7),
					.f		(signed_z_left)
					);

MUX MUX_inst_x_out(
					.a_0	(1'b0),
					.a_1	(x_right),
					.a_2	(1'b1),
					.a_3	(),
					.s_0	(y_left),
					.s_1	(signed_x_left),
					.f		(x)
					);

MUX MUX_inst_z_out(
					.a_0	(1'b0),
					.a_1	(z_right),
					.a_2	(1'b1),
					.a_3	(),
					.s_0	(y_left),
					.s_1	(signed_z_left),
					.f		(z)
					);

MUX MUX_inst_y_out(
					.a_0	(1'b0),
					.a_1	(1'b0),
					.a_2	(1'b0),
					.a_3	(1'b1),
					.s_0	(y_left),
					.s_1	(y_right),
					.f		(y)
					);
					
endmodule