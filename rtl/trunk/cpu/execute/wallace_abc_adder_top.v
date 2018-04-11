module wallace_abc_adder_top ( clk, rst, A, B, C, CIN, S );

input             clk;
input             rst;
input      [31:0] A, B, C;
input             CIN;
output reg [31:0] S;

wire [31:0] sum;

wallace_abc_adder u_wallace_abc_adder (.A(A), .B(B), .C(C), .CIN(CIN), .S(sum));

always @(posedge clk, posedge rst)
begin
  if(rst)
  begin
    S <= 32'd0;
  end
  else
  begin
    S <= sum;
  end
end

endmodule

