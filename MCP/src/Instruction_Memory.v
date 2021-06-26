
`timescale 1ns / 1ps


module Instruction_Memory #(parameter ADDR_WIDTH = 32,
	  parameter DATA_WIDTH = 32
	  
	)
	(
    input [ADDR_WIDTH-1:0] Address_out,
    
    output reg [DATA_WIDTH-1:0] inst_out
    );
	
	always@(*)
	begin
		case(Address_out)
      
        0 : 	inst_out <= 32'h000010b7;
        4 : 	inst_out <= 32'h00020137;
        8 : 	inst_out <= 32'h000081b7;
        12: 	inst_out <= 32'h00009237;
        16: 	inst_out <= 32'h0000b2b7;
        20: 	inst_out <= 32'h0001e337;
        24: 	inst_out <= 32'h000006b7;
        28: 	inst_out <= 32'h40110133;
        32: 	inst_out <= 32'h1e208e63;
        36: 	inst_out <= 32'h00d686b3;
        40: 	inst_out <= 32'h02d2c263;
        44: 	inst_out <= 32'h004353b3;
        48: 	inst_out <= 32'h0013f433;
        52: 	inst_out <= 32'h40130333;
        56: 	inst_out <= 32'hfe1412e3;
        60: 	inst_out <= 32'h003686b3;
        64: 	inst_out <= 32'h0056c863;
        68: 	inst_out <= 32'h405686b3;
        72: 	inst_out <= 32'hfc1048e3;
        76: 	inst_out <= 32'h405686b3;
        80: 	inst_out <= 32'h00020b37;
        84: 	inst_out <= 32'h00020b37;
        88: 	inst_out <= 32'h00020b37;
        92: 	inst_out <= 32'hfc1048e3;

    
	


           default: inst_out <= {7'b0000000, 5'd0, 5'd0, 3'b000, 5'd0, 7'b0110011}	;
		endcase
		
	end

     
 

	
endmodule