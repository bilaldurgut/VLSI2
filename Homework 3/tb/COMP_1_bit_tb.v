module COMP_1_bit_tb;

reg a, b;

wire x, y, z;

initial 
	begin
		a <= 0;
		b <= 0;
		#10;
		a <= 1;
		b <= 0;
		#10;
		a <= 0;
		b <= 1;
		#10;
		a <= 1;
		b <= 1;
		#10
		$finish;
	end

COMP_1_bit COMP_1_bit_inst (
							.a	(a),
							.b	(b),
							.x	(x),
							.y	(y),
							.z	(z)
							);
							
endmodule