`timescale 1ns / 1ps


module RegisterFile #(parameter SIZE = 32)(
    input Load_En,
    input [4:0] A_sel,
    input [4:0] B_sel,
    input [SIZE-1 :0] D_data,
    input [4:0] Dest_sel,
    input clk,
    input rst,
    output [SIZE-1 :0] A_data,
    output [SIZE-1 :0] B_data
    );
    
    wire [31:0] Reg [31:0];
    wire [31:0] Decoder_out;

    
    DECODER #(.SIZE(5)) decoder(.IN(Dest_sel), .OUT(Decoder_out));
    
    mux32 muxA(
    Reg[0],Reg[1],Reg[2],Reg[3],Reg[4],Reg[5],Reg[6],Reg[7],Reg[8],Reg[9],
    Reg[10],Reg[11],Reg[12],Reg[13],Reg[14],Reg[15],Reg[16],Reg[17],Reg[18],Reg[19],
    Reg[20],Reg[21],Reg[22],Reg[23],Reg[24],Reg[25],Reg[26],Reg[27],Reg[28],Reg[29],
    Reg[30],Reg[31],
    A_sel,
    A_data 
    );
    
    mux32 muxB(
    Reg[0],Reg[1],Reg[2],Reg[3],Reg[4],Reg[5],Reg[6],Reg[7],Reg[8],Reg[9],
    Reg[10],Reg[11],Reg[12],Reg[13],Reg[14],Reg[15],Reg[16],Reg[17],Reg[18],Reg[19],
    Reg[20],Reg[21],Reg[22],Reg[23],Reg[24],Reg[25],Reg[26],Reg[27],Reg[28],Reg[29],
    Reg[30],Reg[31],
    B_sel,
    B_data  
    );
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1)
        begin
            REGISTER #(.SIZE(32)) Reg(.Rin(D_data),.En((Decoder_out[i] & Load_En)),.Rout(Reg[i]),.clk(clk), .rst(rst));
        end
    endgenerate
    
    
endmodule
