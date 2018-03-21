module mux_16x1 (
   input [15:0] a,
   input [3:0] sel,
   output out
);

    wire [3:0] w;
	mux_4x1 u_mux0 (a[3:0],sel[1:0],w[0]);
	mux_4x1 u_mux1 (a[7:4],sel[1:0],w[1]);
	mux_4x1 u_mux2 (a[11:8],sel[1:0],w[2]);
	mux_4x1 u_mux3 (a[15:12],sel[1:0],w[3]);

	mux_4x1 u_mux_last (w[3:0],sel[3:2],out);	

endmodule

