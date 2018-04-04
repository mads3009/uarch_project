module mux4bit_2x1(Y, IN0, IN1, s0);
input  [3:0]IN0;
input  [3:0]IN1;
input       s0;
output [3:0]Y;

mux2$ mux0(.outb(Y[0]), .in0(IN0[0]), .in1(IN1[0]), .s0(s0));
mux2$ mux1(.outb(Y[1]), .in0(IN0[1]), .in1(IN1[1]), .s0(s0));
mux2$ mux2(.outb(Y[2]), .in0(IN0[2]), .in1(IN1[2]), .s0(s0));
mux2$ mux3(.outb(Y[3]), .in0(IN0[3]), .in1(IN1[3]), .s0(s0));

endmodule

