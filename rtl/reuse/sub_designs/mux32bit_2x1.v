/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: 32-bit wide 2x1 mux   */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module mux32bit_2x1(Y, IN0, IN1, S0);

input [31:0] IN0;
input [31:0] IN1;
input  S0;
output [31:0] Y;

mux2_16$ u_mux2_16_1(.Y(Y[15:0]),.IN0(IN0[15:0]),.IN1(IN1[15:0]),.S0(S0));
mux2_16$ u_mux2_16_2(.Y(Y[31:16]),.IN0(IN0[31:16]),.IN1(IN1[31:16]),.S0(S0));

endmodule

