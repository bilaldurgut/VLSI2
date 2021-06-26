`timescale 1ns / 1ps


    module LoadUse_Hazards(
         input [1:0] IDEX_MemRead,
         input [4:0] IDEX_RegisterRd,
         input [4:0] IFID_RegisterRs1,
         input [4:0] IFID_RegisterRs2,
         
         output reg LUHazard
        );
        
         always @(*) 
         begin
         if ((IDEX_MemRead == 2'b01) && ((IDEX_RegisterRd == IFID_RegisterRs1) | (IDEX_RegisterRd == IFID_RegisterRs2))) 
            LUHazard = 1'b1;
            
         else
            LUHazard = 1'b0;
          end 
         
        
    endmodule
