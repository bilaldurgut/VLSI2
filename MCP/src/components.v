`timescale 1ns / 1ps


module MUX #(parameter SIZE = 32)(
	input [SIZE-1:0] I0,
	input [SIZE-1:0] I1,
	input [SIZE-1:0] I2,
	input [SIZE-1:0] I3,
	input [1:0] S,
	output reg [SIZE-1:0] OUT
    );

    always @* begin
        case(S)
            2'b00: OUT = I0;
            2'b01: OUT = I1;
            2'b10: OUT = I2;
            2'b11: OUT = I3;
        endcase
    end

endmodule

module DECODER #(parameter SIZE = 5) (
    input [SIZE-1:0] IN,
    output reg [2**SIZE-1:0] OUT
);

  integer i;
  
  always @ (IN)
  begin

    for(i=0; i<2**SIZE; i=i+1)
    begin           
        if(i == IN) 
            OUT[i] = 1;
    else 
        OUT[i] = 0;
    end
  end

endmodule 




module mux32( input [31:0] in1,in2,in3,in4,in5,in6,in7,in8,in9,
            input [31:0] in10,in11,in12,in13,in14,in15,in16,in17,in18,in19,
            input [31:0] in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,
            input [31:0] in30,in31,in32,
            input [4:0] sel,
            output reg [31:0] out);
            
    
    
    always @(*) begin
        case(sel)
            5'b00000  : out <= in1;
            5'b00001  : out <= in2;
            5'b00010  : out <= in3;
            5'b00011  : out <= in4;
            5'b00100  : out <= in5;
            5'b00101  : out <= in6;
            5'b00110  : out <= in7;
            5'b00111  : out <= in8;
            5'b01000  : out <= in9;
            5'b01001  : out <= in10;
            5'b01010  : out <= in11;
            5'b01011  : out <= in12;
            5'b01100  : out <= in13;
            5'b01101  : out <= in14;
            5'b01110  : out <= in15;
            5'b01111  : out <= in16;
            5'b10000  : out <= in17;
            5'b10001  : out <= in18;
            5'b10010  : out <= in19;
            5'b10011  : out <= in20;
            5'b10100  : out <= in21;
            5'b10101  : out <= in22;
            5'b10110  : out <= in23;
            5'b10111  : out <= in24;
            5'b11000  : out <= in25;
            5'b11001  : out <= in26;
            5'b11010  : out <= in27;
            5'b11011  : out <= in28;
            5'b11100  : out <= in29;
            5'b11101  : out <= in30;
            5'b11110  : out <= in31;
            5'b11111  : out <= in32;
            default : out <=32'd0;
        endcase
    end
    endmodule
    
module MUX2#(parameter WIDTH=4)(
	
	input [WIDTH-1 : 0] C0,
    input [WIDTH-1 : 0] C1,
	input S,
	output reg [WIDTH-1 : 0] O);
	
	always @(*)
	case(S)
	   0: O = C0;	   
	   1: O = C1;
	endcase
endmodule

    
module MUX3#(parameter WIDTH=4)(
	
	input [WIDTH-1 : 0] C0,
    input [WIDTH-1 : 0] C1,
    input [WIDTH-1 : 0] C2,
	input [1:0] S,
	output reg [WIDTH-1 : 0] O);
	
	always @(*)
	case(S)
	   0: O = C0;	   
	   1: O = C1;
	   2: O = C2;
	   default: O = 0;
	endcase
endmodule

