module cond_sum_abc (a, b, c, sum);

input  [3:0] a, b, c;
output [3:0] sum;

wire [3:0] temp_sum, temp_carry;

assign temp_carry[0] = 1'b0;

fa u_fa0 ( .a(a[0]), .b(b[0]), .cin(c[0]), .sum(temp_sum[0]), .cout(temp_carry[1]) );
fa u_fa1 ( .a(a[1]), .b(b[1]), .cin(c[1]), .sum(temp_sum[1]), .cout(temp_carry[2]) );
fa u_fa2 ( .a(a[2]), .b(b[2]), .cin(c[2]), .sum(temp_sum[2]), .cout(temp_carry[3]) );
fa u_fa3 ( .a(a[3]), .b(b[3]), .cin(c[3]), .sum(temp_sum[3]), .cout(/*Unused*/) );

nibble_low u_cond_sum4 (.a(temp_sum[3:0]), .b(temp_carry[3:0]), .cin(1'b0), .s(sum[3:0]), .cout(/*Unused*/) );

endmodule

