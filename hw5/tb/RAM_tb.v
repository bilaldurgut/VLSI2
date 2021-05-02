`timescale 1ns / 1ps

module RAM_tb # (

parameter ADDR_WIDTH = 5,
parameter DATA_WIDTH = 32
) ();

localparam DEPTH = 2**ADDR_WIDTH;
localparam CLKPER = 20;
reg clk;
reg we;
reg rst;
reg [ADDR_WIDTH-1:0] addr;
reg [DATA_WIDTH-1:0] tb_data;

wire [DATA_WIDTH-1:0] data;

reg [DATA_WIDTH-1:0] mem_read [0 : DEPTH-1];

initial $readmemb("inst.mem", mem_read);

RAM 
#(
.ADDR_WIDTH(ADDR_WIDTH),
.DATA_WIDTH(DATA_WIDTH)
) 
RAM_inst 
(
.clk(clk),
.rst(rst),
.addr(addr),
.data(data),
.we(we)
);

assign data = we ? tb_data : 'hz;

integer i;

initial begin

	rst = 0;
	clk = 0;
	addr = 0;
	tb_data = 32'd0;
	we = 0;
	#(3*CLKPER)
	rst = 1;
	#(3*CLKPER)
	rst = 0;
	we = 1;
	#(CLKPER/4)
	for (i = 0; i < DEPTH; i = i+1)
	begin
		tb_data <= mem_read[i];
		addr <= i;
		#(CLKPER);
		$display("mem[%2d] => %b",i,RAM_inst.mem[i]);
	end
	we = 0;
	#(CLKPER);
	for (i = 0; i < DEPTH; i = i+1)
	begin
		addr <= i;
		#(CLKPER);
		$display("data from reg %2d => %b",i,data);
	end
	
	$finish;

end

always #(CLKPER/2) clk = ~clk;

endmodule
