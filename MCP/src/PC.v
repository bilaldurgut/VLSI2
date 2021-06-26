`timescale 1ns / 1ps


module PC(
    input [31:0] PC_new,
    input clk,rst,
    output reg [31:0] PC
    );
    
    always @(posedge clk)
    begin
    if(rst)
        PC = 32'd0;
    else
        PC = PC_new;
    end
    
endmodule
