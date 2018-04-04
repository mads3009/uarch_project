module mux_8x1 ( 
    input a0,
    input a1,
    input a2,
    input a3,
    input a4,
    input a5,
    input a6,
    input a7,
    input [2:0] sel,
    output out
  );

   //FIXME: may need buffers for fanout > 4
   
  wire mux0_out;
  wire mux1_out;
  mux4$ mux0 (.in0(a0), .in1(a1), .in2(a2), .in3(a3), .s0(sel[0]), .s1(sel[1]), .outb(mux0_out));
  mux4$ mux1 (.in0(a4), .in1(a5), .in2(a6), .in3(a7), .s0(sel[0]), .s1(sel[1]), .outb(mux1_out));
  mux2$ mux2 (.in0(mux0_out), .in1(mux1_out), .s0(sel[2]), .outb(out));

endmodule
