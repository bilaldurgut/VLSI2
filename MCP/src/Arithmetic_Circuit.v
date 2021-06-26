module Arithmetic_Circuit 
    #(parameter WIDTH = 32)
( 
input 	[WIDTH-1:0] A,B,

input 	[1:0] cont_signal, 

output 	[WIDTH-1:0] R,

output 	zero_flag,
		overflow_flag,
		negative_flag,
		carry_flag,
		Cout
);
wire Cout_sub,Cout_add;  
wire [WIDTH-1:0] R_add,R_sub,R_Sltu,R_Slt,R_wire;  
     
add u1( 
.A		(A),
.B		(B),
.sum	(R_add),
.Cout	(Cout_add)
);

sub u2( 
.A		(A),
.B		(B),
.sum	(R_sub),
.Cout	(Cout_sub)
);

SLT SLT_inst
(
.A	(A    ),
.B	(B    ),
.R	(R_Slt)
);

SLTU SLTU_inst
(
.A	(A    ),
.B	(B    ),
.R	(R_Sltu)
);


// load - add - sub selection
assign R_wire = (cont_signal [1] == 1'b1 ) ? ((cont_signal [0] == 1'b1) ? R_Slt : R_Sltu) : ((cont_signal [0] == 1'b1) ? R_sub : R_add); 

assign Cout = (cont_signal [0] == 1'b1) ? Cout_sub : Cout_add;

//carry flag
assign carry_flag = (cont_signal [0] == 1'b1) ? Cout_sub : Cout_add; //Cout

//negative_flag
assign negative_flag = R[WIDTH-1]; //if number is neg, flag is 1

//zero_flag
assign zero_flag = ~(|R); //zero_flag is 1 if R_wire bits are all zero

//overflow_flag

assign overflow_flag = (cont_signal == 2'b00) ? (( A[WIDTH-1] & B[WIDTH-1]		& (~R_wire[WIDTH-1])) 	|	(( ~A[WIDTH-1])& (~B[WIDTH-1])	& R_wire[WIDTH-1]) ) ://0 => add operation
												(( A[WIDTH-1] & (~B[WIDTH-1]) 	& (~R_wire[WIDTH-1])) 	| 	(( ~A[WIDTH-1])& (B[WIDTH-1]) 	& R_wire[WIDTH-1]) ) ;//1 => sub operation


assign R = R_wire;

endmodule 