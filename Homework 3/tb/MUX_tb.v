module MUX_tb;

reg [3:0] a;

reg [1:0] s;

wire 
		a_0	,
		a_1	,
		a_2	,
		a_3	,
			
		s_0	,
		s_1	,
		
		f	;

always 
	begin
		#5
		if (a < 15) a = a + 1;
		else 		a =  4'h0;
	end
always 
	begin
		#80	
		if (s < 3) 	s = s + 1;
		else 		s = 2'b00;
	end
	
initial
	begin
		s = 0;
		a = 0;		
		#400
		$finish;
	end

assign {a_3,a_2,a_1,a_0} = a;

assign {s_1,s_0} = s;

MUX MUX_inst 	(
				.a_0 	(a_0),
				.a_1 	(a_1),
				.a_2 	(a_2),
				.a_3 	(a_3),
					
				.s_0 	(s_0),
				.s_1 	(s_1),
				
				.f		(f)
				);
endmodule
