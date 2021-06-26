`timescale 1ns / 1ps


module Imm_Block(input [31:0] inst,
                 input [2:0] im_sel,
                 output reg [31:0] im_out
    );
    
    always@(*)
    begin
        if(im_sel == 3'b000) //I-immediate
            begin
            im_out = { {21{inst[31]}},inst[30:20]};
            end
        if(im_sel == 3'b001) //S-immediate
            begin
            im_out = { {21{inst[31]}},inst[30:25],inst[11:7]};
            end    
        if(im_sel == 3'b010) //B-immediate
            begin
            im_out = { {20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
            end   
        if(im_sel == 3'b011) //U-immediate
            begin
             im_out = { {12{1'b0}},inst[31:12] }; 
            end   
         if(im_sel == 3'b100) //J-immediate
            begin

              im_out = {1'b0, {12{inst[31]}},inst[30:25],inst[24:21],inst[20],inst[19:12]}; 
            end      
    end
endmodule
