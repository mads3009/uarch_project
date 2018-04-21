module muxNbit_2x1 #(parameter N = 32) (IN0, IN1, S0, Y);

input  [N-1:0] IN0;
input  [N-1:0] IN1;
input          S0;
output [N-1:0] Y;

genvar i;
generate
  for (i=0; i<N; i=i+1) begin : loop
    mux2$ u_mux2(.outb(Y[i]), .in0(IN0[i]), .in1(IN1[i]), .s0(S0));
  end
endgenerate

endmodule

