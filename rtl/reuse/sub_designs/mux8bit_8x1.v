module mux8bit_8x1 (Y, IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, S0, S1, S2);
input [7:0]  IN0;
input [7:0]  IN1;
input [7:0]  IN2;
input [7:0]  IN3;
input [7:0]  IN4;
input [7:0]  IN5;
input [7:0]  IN6;
input [7:0]  IN7;
input        S0;
input        S1;
input        S2;
output [7:0] Y;

wire [7:0] mux0_out;
wire [7:0] mux1_out;
mux4_8$ mux0 (.IN0(IN0), .IN1(IN1), .IN2(IN2), .IN3(IN3), .S0(S0), .S1(S1), .Y(mux0_out));
mux4_8$ mux1 (.IN0(IN4), .IN1(IN5), .IN2(IN6), .IN3(IN7), .S0(S0), .S1(S1), .Y(mux1_out));
mux2_8$ mux2 (.IN0(mux0_out), .IN1(mux1_out), .S0(S2), .Y(Y));

endmodule	
