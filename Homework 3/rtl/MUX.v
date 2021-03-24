module MUX	
(
input
		a_0,
		a_1,
		a_2,
		a_3,
		
		s_0,
		s_1,
		
output
		f
);
reg f_d;

always@(*)
	case({s_1,s_0})
		
		0: f_d <= a_0;
		1: f_d <= a_1;
		2: f_d <= a_2;
		3: f_d <= a_3;
	
	endcase

assign f = f_d;

endmodule