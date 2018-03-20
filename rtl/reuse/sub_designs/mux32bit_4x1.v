/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: 32-bit register with  */
/* load signal.                       */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module mux32bit_4x1(Y, IN0, IN1, IN2, IN3, S0, S1);

input [31:0] IN0;
input [31:0] IN1;
input [31:0] IN2;
input [31:0] IN3;
input  S0;
input  S1;
output [31:0] Y;

mux4_16$ u_mux4_16_1(.Y(Y[15:0]),.IN0(IN0[15:0]),.IN1(IN1[15:0]),.IN2(IN2[15:0]),.IN3(IN3[15:0]),.S0(S0),.S1(S1) );
mux4_16$ u_mux4_16_2(.Y(Y[31:16]),.IN0(IN0[31:16]),.IN1(IN1[31:16]),.IN2(IN2[31:16]),.IN3(IN3[31:16]),.S0(S0),.S1(S1) );

endmodule

