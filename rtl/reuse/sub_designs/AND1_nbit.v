module AND1_nbit (a,en,out);
	parameter WIDTH = 32;
   	input [WIDTH-1:0] a;
   	input en;
   	output [WIDTH-1:0] out;

	genvar i;
	generate begin : loop 
	for (i=0; i<WIDTH; i=i+1) begin : and_gen
    	and2$ u_and (out[i], a[i], en);
	end
	end
	endgenerate

endmodule
