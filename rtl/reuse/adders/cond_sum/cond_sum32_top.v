module cond_sum32_top ( clk, rst, A, B, CIN, S, COUT );

input             clk, rst;
input      [31:0] A, B;
input             CIN;
output reg [31:0] S;
output reg        COUT;

wire [31:0] sum;
wire carry;

cond_sum32 u_cond_sum32 (.A(A[31:0]), .B(B[31:0]), .CIN(CIN), .S(sum), .COUT(carry) );

always @(posedge clk, posedge rst)
begin
  if(rst)
  begin
    S <= 32'd0;
    COUT <= 1'b0;
  end
  else
  begin
    S <= sum;
    COUT <= carry;
  end
end

endmodule
