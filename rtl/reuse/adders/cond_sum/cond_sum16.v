module cond_sum16 ( A, B, CIN, S, COUT );

input  [15:0] A, B;
input        CIN;
output [15:0] S;
output       COUT;

wire [15:0] S_temp;

cond_sum8 u_cond_sum8_low   (.A(A[7:0]), .B(B[7:0]), .CIN(CIN), .S(S[7:0]), .COUT(c8  ) );
cond_sum8 u_cond_sum8_high0 (.A(A[15:8]), .B(B[15:8]), .CIN(1'b0), .S(S_temp[7:0]), .COUT(COUT0 ) );
cond_sum8 u_cond_sum8_high1 (.A(A[15:8]), .B(B[15:8]), .CIN(1'b1), .S(S_temp[15:8]), .COUT(COUT1 ) );

mux2$ u_mux1[15:8] ( .in0(S_temp[7:0]), .in1(S_temp[15:8]), .s0(c8), .outb(S[15:8]) );

mux2$ u_mux2 ( .in0(COUT0), .in1(COUT1), .s0(c8), .outb(COUT) );

endmodule
