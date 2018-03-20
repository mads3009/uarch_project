module cond_sum32 ( A, B, CIN, S, COUT );

input  [31:0] A, B;
input         CIN;
output [31:0] S;
output        COUT;

wire [31:0] S_temp;

cond_sum16 u_cond_sum16_low   (.A(A[15:0]), .B(B[15:0]), .CIN(CIN), .S(S[15:0]), .COUT(c16) );
cond_sum16 u_cond_sum16_high0 (.A(A[31:16]), .B(B[31:16]), .CIN(1'b0), .S(S_temp[15:0]), .COUT(COUT0 ) );
cond_sum16 u_cond_sum16_high1 (.A(A[31:16]), .B(B[31:16]), .CIN(1'b1), .S(S_temp[31:16]), .COUT(COUT1 ) );

mux2$ u_mux1[15:0] ( .in0(S_temp[15:0]), .in1(S_temp[31:16]), .s0(c16), .outb(S[31:16]) );

mux2$ u_mux2 ( .in0(COUT0), .in1(COUT1), .s0(c16), .outb(COUT) );

endmodule
