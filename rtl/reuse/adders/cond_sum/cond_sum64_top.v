module cond_sum64_top ( clk, rst, A, B, CIN, S, COUT );

input             clk, rst;
input      [63:0] A, B;
input             CIN;
output reg [63:0] S;
output reg        COUT;

wire [63:0] sum;
wire carry;

cond_sum64 u_cond_sum64 (.A(A[63:0]), .B(B[63:0]), .CIN(CIN), .S(sum), .COUT(carry) );

always @(posedge clk, posedge rst)
begin
  if(rst)
  begin
    S <= 64'd0;
    COUT <= 1'b0;
  end
  else
  begin
    S <= sum;
    COUT <= carry;
  end
end

endmodule

