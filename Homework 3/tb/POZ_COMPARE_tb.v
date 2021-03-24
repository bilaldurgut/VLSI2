module POZ_COMPARE_tb;

//input drivers
reg [3:0]
		a,
		b;
//inputs
wire 
		a_0,
		a_1,
        a_2,
        a_3,
        b_0,
        b_1,
        b_2,
        b_3;
//outputs
wire 	x, 
		y,
		z;

initial
	begin
		//1
		a <= 7;
		b <= 3;
		#10
		//2
		a <= 12;
		b <= 7;
		#10
		//3
		a <= 15;
		b <= 9;
		#10
		//4
		a <= 3;
		b <= 5;
		#10
		//5
		a <= 7;
		b <= 9;
		#10
		//6
		a <= 11;
		b <= 13;
		#10
		//7
		a <= 11;
		b <= 11;
		#10
		//8
		a <= 8;
		b <= 8;
		#10
		//9
		a <= 15;
		b <= 15;
		#10
		$finish;
	end

assign a_0 = a[0];
assign a_1 = a[1];
assign a_2 = a[2];
assign a_3 = a[3];

assign b_0 = b[0];
assign b_1 = b[1];
assign b_2 = b[2];
assign b_3 = b[3];


POZ_COMPARE POZ_COMPARE_inst(
							.a_0	(a_0),
							.a_1	(a_1),
							.a_2	(a_2),
							.a_3	(a_3),
							.b_0	(b_0),
							.b_1	(b_1),
							.b_2	(b_2),
							.b_3	(b_3),
							.x		(x),
							.y		(y),
							.z		(z)
							);


endmodule