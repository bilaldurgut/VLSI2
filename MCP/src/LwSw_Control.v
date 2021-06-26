`timescale 1ns / 1ps

    module LwSw_Control(
     input [1:0]MEMWB_MD,
     input EXMEM_MW,
     input [4:0] MEMWB_RegisterRd,EXMEM_RegisterRs2,
     output reg LwSw_sel
        );
        
         always @(*) 
         begin
         if (((MEMWB_MD == 2'b01) & EXMEM_MW  ) && ( (MEMWB_RegisterRd != 0) && (MEMWB_RegisterRd == EXMEM_RegisterRs2) ))
            LwSw_sel = 1'b1;
         
         else  
            LwSw_sel = 1'b0;
         end 
     
    
    endmodule
