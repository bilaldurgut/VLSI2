`timescale 1ns / 1ps
module add
  #(parameter WIDTH = 32)

   (
	input 	[WIDTH-1 : 0]		A,
	input 	[WIDTH-1 : 0]		B,
	
	
	output 	[WIDTH-1 : 0]		sum,
	output 						Cout

);
     
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
  

  // Create the Full Adders
  genvar             ii;

    for (ii=0; ii<WIDTH; ii=ii+1) 
      begin
        full_adder full_adder_inst
            ( 
              .A	(A[ii]),
              .B	(B[ii]),
              .Cin	(w_C[ii]),
              .sum 	(w_SUM[ii]),
              .Cout ()
              );
      end

 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
 
    for (jj=0; jj<WIDTH; jj=jj+1) 
      begin
        assign w_G[jj]   = A[jj] & B[jj];
        assign w_P[jj]   = A[jj] | B[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
 
   
  assign w_C[0] = 1'b0; // no carry input on first adder
  assign Cout = w_C[WIDTH];
  assign sum = w_SUM;
  
 
endmodule // carry_lookahead_adder