module mux16bit_8x1 (Y, IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, S0, S1, S2);
input [15:0]  IN0;
input [15:0]  IN1;
input [15:0]  IN2;
input [15:0]  IN3;
input [15:0]  IN4;
input [15:0]  IN5;
input [15:0]  IN6;
input [15:0]  IN7;
input         S0;
input         S1;
input         S2;
output [15:0] Y;

mux8bit_8x1 mux0 (.IN0(IN0[7:0]), .IN1(IN1[7:0]), .IN2(IN2[7:0]), .IN3(IN3[7:0]), .IN4(IN4[7:0]), .IN5(IN5[7:0]), .IN6(IN6[7:0]), .IN7(IN7[7:0]), .S0(S0), .S1(S1), .S2(S2), .Y(Y[7:0]));
mux8bit_8x1 mux1 (.IN0(IN0[15:8]), .IN1(IN1[15:8]), .IN2(IN2[15:8]), .IN3(IN3[15:8]), .IN4(IN4[15:8]), .IN5(IN5[15:8]), .IN6(IN6[15:8]), .IN7(IN7[15:8]), .S0(S0), .S1(S1), .S2(S2), .Y(Y[15:8]));

endmodule


