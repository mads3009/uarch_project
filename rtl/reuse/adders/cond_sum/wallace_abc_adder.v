module wallace_abc_adder ( A, B, C, CIN, S );

input  [31:0] A, B, C;
input         CIN;
output [31:0] S;

wire [31:0] lvl_s, lvl_c;

genvar i;
generate
for (i=0; i < 32; i=i+1) begin : gen_lvl1
  fa u_fa ( .a(A[i]), .b(B[i]), .cin(C[i]), .sum(lvl_s[i]), .cout(lvl_c[i]) );
end
endgenerate

cond_sum32 u_cond_sum32 (.A(lvl_s), .B({lvl_c[30:0],1'b0}), .CIN(CIN), .S(S[31:0]), .COUT(/*unused*/) );

endmodule
