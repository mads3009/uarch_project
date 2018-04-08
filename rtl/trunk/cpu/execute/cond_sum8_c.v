module cond_sum8_c ( A, B, CIN, S, COUT, c4 );

input  [7:0] A, B;
input        CIN;
output [7:0] S;
output       COUT;
output       c4;

wire c4;

nibble_low u_nibble_low   (.a(A[3:0]), .b(B[3:0]), .cin(CIN), .s(S[3:0]), .cout(c4  ) );
nibble_high u_nibble_high (.a(A[7:4]), .b(B[7:4]), .cin(c4 ), .s(S[7:4]), .cout(COUT) );

endmodule


