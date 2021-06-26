`timescale 1ns / 1ps

module MCP_tb(

    );
    reg clk, rst;
    MCP uut (.clk(clk), .rst(rst));
    
    initial begin
    clk = 0;
    rst = 0;
    #10;
    
    rst = 1;
    #10;
    rst = 0;
    #10000;    
    $finish();
    
    end
    
    always #10 clk = ~clk;
endmodule
