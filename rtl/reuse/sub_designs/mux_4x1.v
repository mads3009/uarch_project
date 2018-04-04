module mux_4x1 (
   input [3:0] a,
   input [1:0] sel,
   output out
);
;
	mux4$ u_mux0 (.in0(a[0]), .in1(a[1]), .in2(a[2]), .in3(a[3]), .s0(sel[0]), .s1(sel[1]), .outb(out));

endmodule

