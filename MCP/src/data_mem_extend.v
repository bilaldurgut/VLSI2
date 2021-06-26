`timescale 1ns / 1ps


module data_mem_extend(
    input [31:0] data_in,
    input [2:0] data_sel, 
    output reg [31:0] data_out 
    );
    
   
always@(*)
  begin
  
    if (data_sel==3'd0)
    begin
        data_out<={ {24{data_in[7]}}, data_in[7:0]};
    end
    
    else if(data_sel==3'd1)
    begin
        data_out<={ {16{data_in[15]}}, data_in[15:0]};
    end
    
    else if(data_sel==3'd2)
    begin
        data_out<={ {24{1'b0}}, data_in[7:0]};
    end
    
    else if(data_sel==3'd3)
    begin
        data_out<={ {16{1'b0}}, data_in[15:0]};
    end
    
    else
    begin
        data_out<= data_in;
    end
    
  end

endmodule
