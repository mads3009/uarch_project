module mux4bit_3x1(Y, IN0, IN1, IN2, s0, s1);
input  [3:0]IN0;
input  [3:0]IN1;
input  [3:0]IN2;
input       s0;
input       s1;
output [3:0]Y;

mux3$ mux0(.outb(Y[0]), .in0(IN0[0]), .in1(IN1[0]), .in2(IN2[0]), .s0(s0), .s1(s1));
mux3$ mux1(.outb(Y[1]), .in0(IN0[1]), .in1(IN1[1]), .in2(IN2[1]), .s0(s0), .s1(s1));
mux3$ mux2(.outb(Y[2]), .in0(IN0[2]), .in1(IN1[2]), .in2(IN2[2]), .s0(s0), .s1(s1));
mux3$ mux3(.outb(Y[3]), .in0(IN0[3]), .in1(IN1[3]), .in2(IN2[3]), .s0(s0), .s1(s1));

endmodule

