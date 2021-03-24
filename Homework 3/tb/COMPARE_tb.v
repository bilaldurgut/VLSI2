module COMPARE_tb;

reg signed [7:0] a,b;

initial 
	begin
		a = -50;
		b = -90;
		#10
		a = 100;
		b =  90;
		#10
		a = -90;
		b = -90;
		#10
		a = -50;
		b = -40;
		#10
		a = 100;
        b =  70;
        #10
        a =  70;
        b =  90;
        #10
        a =  90;
        b =  90;
        #10;
	end

wire x,y,z;

wire	a_0, b_0, 
        a_1, b_1,
        a_2, b_2,
        a_3, b_3,
        a_4, b_4,
		a_5, b_5,
        a_6, b_6,
        a_7, b_7;
		
assign {a_7,a_6,a_5,a_4,a_3,a_2,a_1,a_0} = a;
assign {b_7,b_6,b_5,b_4,b_3,b_2,b_1,b_0} = b;

COMPARE COMPARE_inst(
					.a_0	(a_0),
					.a_1	(a_1),
					.a_2	(a_2),
					.a_3	(a_3),
					.a_4	(a_4),
					.a_5	(a_5),
					.a_6	(a_6),
					.a_7	(a_7),
					
					.b_0	(b_0),
					.b_1	(b_1),
					.b_2	(b_2),
					.b_3	(b_3),
					.b_4	(b_4),
					.b_5	(b_5),
					.b_6	(b_6),
					.b_7	(b_7),
					
					.x		(x),
					.y		(y),
					.z		(z)
					);



endmodule