module RAM
#(
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 5
)
(
input clk,
input rst,
inout [DATA_WIDTH-1 : 0] data,
input [ADDR_WIDTH-1 : 0] addr,
input we
);

localparam DEPTH = 2**ADDR_WIDTH;

reg [DATA_WIDTH-1 : 0] mem [DEPTH-1 : 0];
reg [DATA_WIDTH-1 : 0] tmp_data;

integer i;

always@(posedge clk)
begin
	if(rst)
	begin
		for (i = 0; i < DEPTH; i = i+1)
			mem[i] <= 0;
	end
	else
	begin
	if(we)
	begin
		mem[addr] <= data;
	end
	else
	begin
		tmp_data <= mem[addr];
	end
	end
end

assign data = !we ? tmp_data : 'hz;

endmodule