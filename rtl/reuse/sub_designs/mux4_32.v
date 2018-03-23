module mux4_32(out, in0, in1, in2, in3, s0, s1);
input [31:0]in0;
input [31:0]in1;
input [31:0]in2;
input [31:0]in3;
input s0, s1;
output [31:0]out;
mux4_16$ mux0(out[15:0], in0[15:0], in1[15:0], in2[15:0], in3[15:0], s0, s1);
mux4_16$ mux1(out[31:16], in0[31:16], in1[31:16], in2[31:16], in3[31:16], s0, s1);
endmodule
