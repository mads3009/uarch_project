//EE382M-Verification of Digital Systems
//Formal Property Verification
//
//
//Modules - adder_props
//SystemVerilog Properties for the module - cond_sum32

module adder_props(
input        clk,
input        rst,
input [31:0] A,
input [31:0] B,
input        CIN,
input [31:0] S,
input        COUT
);

reg [31:0] sum;
reg        carry;

always @(posedge clk, posedge rst) begin
  if(rst) begin
    {carry, sum} = 33'd0;
  end
  else begin
    {carry, sum} = {1'b0,A} + {1'b0, B} + {32'd0,CIN};
  end
end

assert_APB_BYPASS_WR_chk : assert property(@(posedge clk) {carry,sum} == {COUT,S});

endmodule

module Wrapper;

//Binding the properties module with the arbiter module to instantiate the properties
bind cond_sum32_top adder_props u_adder_props (
  .clk(clk),
  .rst(rst),
  .A(A),
  .B(B),
  .CIN(CIN),
  .COUT(COUT),
  .S(S)
);

endmodule

