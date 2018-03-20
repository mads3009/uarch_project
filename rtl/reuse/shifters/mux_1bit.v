module mux_1bit(outb, in0, in1, s0);

input in0, in1, s0;
output outb;

mux2$ u_mux2x1(outb, in0, in1, s0);

endmodule
