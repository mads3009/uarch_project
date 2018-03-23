module mux_4x1 (
   input [3:0] a,
   input [1:0] sel,
   output out
);
;
	wire w1,w2;

	mux_2x1 u_mux0 (a[0],a[1],sel[0],w1);
	mux_2x1 u_mux1 (a[2],a[3],sel[0],w2);
	
	mux_2x1 u_mux2 (w1,w2,sel[1],out);

endmodule

