`timescale 1ns / 1ps


module Data_memory
	#(parameter ADDR_WIDTH = 5,
	  parameter DATA_WIDTH = 32
	  //parameter DEPTH = 32
	  )
	(
    input [ADDR_WIDTH-1:0] Address_out,
    input [DATA_WIDTH-1:0] Data_out,
    input MW,
    input clk,rst,
    input [1:0] MEM_CONT,
    output [DATA_WIDTH-1:0] Data_in
    );
    
   
	
	localparam DEPTH = 2**ADDR_WIDTH;
	
	reg [DATA_WIDTH-1:0] temp_data;
	reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];
	integer i;
	
	always @(posedge clk)
	begin
		if(rst)
			for (i = 0; i < DEPTH; i= i+1)
				mem[i] <= 0;
		else if(MW)
		  case(MEM_CONT)
		  
                    2'b00:
                    begin
                        mem[Address_out][7:0] = Data_out[7:0];
                    end
                    2'b01:
                    begin
                        mem[Address_out][15:0] = Data_out[15:0];
                    end
                    2'b10:
                    begin
                        mem[Address_out][31:0] = Data_out[31:0];
                    end		  
		  
		  
		  endcase
		
	end

	assign Data_in = !MW ? mem[Address_out] : 'hz;
	
endmodule


