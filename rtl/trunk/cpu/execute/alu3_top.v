module alu3_top (
    clk,
    rst,
    mm1,
    mm2,
    sr2,
    ecx,
    alu3_op,
    alu_res3
);


input clk;
input rst;
input [63:0]mm1;
input [63:0]mm2;
input [31:0]sr2;
input [31:0]ecx;
input [4:0] alu3_op;

output reg [63:0]alu_res3;

wire [63:0]w_alu_res3;

alu3 u_alu3(
  .mm1                 (mm1), 
  .mm2                 (mm2), 
  .sr2                 (sr2), 
  .ecx                 (ecx), 
  .alu3_op             (alu3_op), 
  .alu_res3            (w_alu_res3) 

);

always @(posedge clk, posedge rst)
begin
  if(rst)
  begin
    alu_res3   <= 63'd0; 
  end
  else
  begin
    alu_res3   <=w_alu_res3;
  end
end

endmodule
