`timescale 1ns / 1ps

module Shifter(
 input [31:0] in,
    input [2:0] sel,
    input [5:0] k,
    output [31:0] out
    );


    reg [31:0] shifted_data;    
    integer i;
    
    always @(*)
    begin
    shifted_data = in;
    case(sel)
    
        0: //Logical left
        begin
            for(i= 0; i<k; i=i+1)
            begin
                shifted_data = {shifted_data[30:0],{1{1'b0}}};
            end
            
        end
        
        1: //Logical right
        begin
            for(i= 0; i<k; i=i+1)
            begin
                shifted_data = {{1{1'b0}}, shifted_data[31:1]};
            end                 
        end
        
        2: //Arithmetic left
        begin
            for(i= 0; i<k; i=i+1)
            begin
                shifted_data = {shifted_data[30:0],{1{1'b0}}};
            end
        end
        
        3: //Arithmetic right
        begin
            for(i= 0; i<k; i=i+1)
            begin
                shifted_data = {{1{in[31]}}, shifted_data[31:1]};
            end           
        end
        
        default: shifted_data=shifted_data;
        
    endcase
    end
    
    assign out = shifted_data;
    
endmodule