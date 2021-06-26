`timescale 1ns / 1ps


module Forwarding_Unit(
    input EXMEM_RegWrite,
     input MEMWB_RegWrite,
    input [4:0] EXMEM_RegisterRd,
    input [4:0] IDEX_RegisterRs1, IFID_RegisterRs1,
    input [4:0] IDEX_RegisterRs2, IFID_RegisterRs2,
    input [4:0] IFID_RegisterRd, //18 haziran
    input IFID_RegWrite, //18 haziran
    input [4:0] MEMWB_RegisterRd,
    output reg [1:0] Forward_A, Forward_B

    );
    always @(*) 
     begin
        if ( EXMEM_RegWrite && (EXMEM_RegisterRd != 0) && (EXMEM_RegisterRd == IDEX_RegisterRs1) )
            Forward_A = 2'b10;
         
        else if (( MEMWB_RegWrite & (MEMWB_RegisterRd != 0) & (MEMWB_RegisterRd == IDEX_RegisterRs1) )&  !( EXMEM_RegWrite & (EXMEM_RegisterRd != 0) & (EXMEM_RegisterRd == IDEX_RegisterRs1)))
            Forward_A = 2'b01;
            
          else if (( IFID_RegWrite && (IFID_RegisterRd != 0) && (IFID_RegisterRd == IDEX_RegisterRs1))&  !(( MEMWB_RegWrite & (MEMWB_RegisterRd != 0) & (MEMWB_RegisterRd == IDEX_RegisterRs1) )& ( EXMEM_RegWrite & (EXMEM_RegisterRd != 0) & (EXMEM_RegisterRd == IDEX_RegisterRs1))))
            Forward_A = 2'b11;
        else begin 
            Forward_A = 2'b00;
    end
    end
    
    always@(*)
    begin
        if ( EXMEM_RegWrite & (EXMEM_RegisterRd != 0) & (EXMEM_RegisterRd == IDEX_RegisterRs2) )
            Forward_B = 2'b10;
         
        else if (( MEMWB_RegWrite & (MEMWB_RegisterRd != 0) & (MEMWB_RegisterRd == IDEX_RegisterRs2) )
        & !( MEMWB_RegWrite & (EXMEM_RegisterRd != 0) & (EXMEM_RegisterRd == IDEX_RegisterRs2)))
            Forward_B = 2'b01;
            
         else if (( IFID_RegWrite && (IFID_RegisterRd != 0) && (IFID_RegisterRd == IDEX_RegisterRs2))&  !(( MEMWB_RegWrite & (MEMWB_RegisterRd != 0) & (MEMWB_RegisterRd == IDEX_RegisterRs2) )& ( EXMEM_RegWrite & (EXMEM_RegisterRd != 0) & (EXMEM_RegisterRd == IDEX_RegisterRs2))))
            Forward_B = 2'b11;    
        else
            Forward_B = 2'b00;
        
    end
        
        
    endmodule
