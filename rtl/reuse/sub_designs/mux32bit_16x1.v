module mux32bit_16x1 (Y, IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, IN10, IN11, IN12, IN13, IN14, IN15, S0, S1, S2, S3);
input [31:0]  IN0;
input [31:0]  IN1;
input [31:0]  IN2;
input [31:0]  IN3;
input [31:0]  IN4;
input [31:0]  IN5;
input [31:0]  IN6;
input [31:0]  IN7;
input [31:0]  IN8;
input [31:0]  IN9;
input [31:0]  IN10;
input [31:0]  IN11;
input [31:0]  IN12;
input [31:0]  IN13;
input [31:0]  IN14;
input [31:0]  IN15;
input        S0;
input        S1;
input        S2;
input        S3;
output [31:0] Y;

wire [31:0] mux0_out;
wire [31:0] mux1_out;
wire [31:0] mux2_out;
wire [31:0] mux3_out;
mux4_32 mux0(mux0_out, IN0, IN1, IN2, IN3, S0, S1);
mux4_32 mux1(mux1_out, IN4, IN5, IN6, IN7, S0, S1);
mux4_32 mux2(mux2_out, IN8, IN9, IN10, IN11, S0, S1);
mux4_32 mux3(mux3_out, IN12, IN13, IN14, IN15, S0, S1);
mux4_32 mux4(Y, mux0_out, mux1_out, mux2_out, mux3_out, S2, S3);

endmodule


