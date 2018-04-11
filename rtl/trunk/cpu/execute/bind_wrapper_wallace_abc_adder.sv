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
input [31:0] C,
input        CIN,
input [31:0] S
);

reg [31:0] sum;

always @(posedge clk, posedge rst) begin
  if(rst) begin
    sum = 33'd0;
  end
  else begin
    sum = A + B + C + {31'd0,CIN};
  end
end

assert_APB_BYPASS_WR_chk : assert property(@(posedge clk) sum == S);

endmodule

module Wrapper;

//Binding the properties module with the arbiter module to instantiate the properties
bind wallace_abc_adder_top adder_props u_adder_props (
  .clk(clk),
  .rst(rst),
  .A(A),
  .B(B),
  .C(C),
  .CIN(CIN),
  .S(S)
);

endmodule

