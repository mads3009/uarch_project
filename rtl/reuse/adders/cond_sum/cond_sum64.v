module cond_sum64 ( A, B, CIN, S, COUT );

input  [63:0] A, B;
input         CIN;
output [63:0] S;
output        COUT;

wire [63:0] S_temp;

cond_sum32 u_cond_sum32_low   (.A(A[31:0]), .B(B[31:0]), .CIN(CIN), .S(S[31:0]), .COUT(c32) );
cond_sum32 u_cond_sum32_high0 (.A(A[63:32]), .B(B[63:32]), .CIN(1'b0), .S(S_temp[31:0]), .COUT(COUT0 ) );
cond_sum32 u_cond_sum32_high1 (.A(A[63:32]), .B(B[63:32]), .CIN(1'b1), .S(S_temp[63:32]), .COUT(COUT1 ) );

mux2$ u_mux1[31:0] ( .in0(S_temp[31:0]), .in1(S_temp[63:32]), .s0(c32), .outb(S[63:32]) );

mux2$ u_mux2 ( .in0(COUT0), .in1(COUT1), .s0(c32), .outb(COUT) );

endmodule
