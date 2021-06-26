`timescale 1ns / 1ps

module ALU(
    input [31:0] A,B,
    input [2:0] G_select,
    output  [31:0] Gout,
    output CarryF,OverflowF, NegativeF, ZeroF

    );

wire Cout, mode_select;//, Cin ;
wire [1:0] operation_select;
wire [31:0] r_arth, r_logic;

assign operation_select = G_select[1:0]; 
assign mode_select = G_select[2]; 


Arithmetic_Circuit u1
(
.A(A),
.B(B),
.R(r_arth), 
.cont_signal(operation_select), 
.zero_flag(ZeroF), 
.carry_flag(CarryF), 
.negative_flag(NegativeF), 
.overflow_flag(OverflowF), 
.Cout(Cout)
);

Logic_Circuit u2
(
.A(A), 
.B(B), 
.result(r_logic), 
.select(operation_select)
);



assign Gout = (!mode_select) ? r_arth : ((operation_select == 2'b11) ? B : r_logic);



endmodule



