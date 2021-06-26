
`timescale 1ns / 1ps

module Branch_Control_Block(
	input V,C,N,Z,
    input [31:0] Imm, Address_out,
    input PL, JB, 
    input [1:0] BC,
	input clk,
	input rst,
    output [31:0] PC_Control,
	output reg load_disable
    );

    wire [3:0] control_signal;
    assign control_signal = {PL, JB, BC};
	
	reg disable_reg;
	
	reg [31:0]  pc_next,pc;
	
	always @(posedge clk)
    begin 
        if(rst)
        begin
            load_disable <= 0;
        end
        else 
        begin
            load_disable <= disable_reg;
        end  
    end 

    always @(posedge clk)
    begin 
        if(rst)
        begin
            pc <= 0;
        end
        else 
        begin
            pc <= pc_next;
        end  
    end   

    always@(*)
    begin

	
		if(!control_signal[3])
		begin
			pc_next <= pc + 4; 
			disable_reg <= 1'b0;
		end
		else
		begin
			case (control_signal[2:0])
			
			3'b100: begin 
						pc_next <= Address_out;
						disable_reg <= 1'b1;
					end
			3'b111: begin 
						pc_next <= pc + Imm - 32'd8;
						disable_reg <= 1'b1;
					end
			3'b000: begin 
				if(Z==1'b1)
				begin
					pc_next <= pc + Imm - 32'd8;
					disable_reg <= 1'b1;
				end
				else 
				begin
					pc_next <= pc + 4;
					disable_reg <= 1'b0;
				end
					end
			3'b001: begin 
				if(Z==1'b0)
				begin
					pc_next <= pc + Imm - 32'd8;
					disable_reg <= 1'b1;
				end
				else 
				begin
					pc_next <= pc + 4;
					disable_reg <= 1'b0;
				end
					end
			3'b010: begin 
				if(N==1'b0 )//& Z==1'b0)
				begin
					pc_next <= pc + Imm - 32'd8;
					disable_reg <= 1'b1;
				end
				else 
				begin
					pc_next <= pc + 4;
					disable_reg <= 1'b0;
				end
				end
			3'b011: begin 
				if(N==1'b1)
				begin
					pc_next <= pc + Imm - 32'd8;
					disable_reg <= 1'b1;
				end
				else 
				begin
					pc_next <= pc + 4;
					disable_reg <= 1'b0;
				end 
				end
			endcase
		end
	
   end

	assign PC_Control = pc_next;
    
endmodule