module alu2_top (
    clk,
    rst,
    EIP_next,
    sr1,
    sr2,
    esp,
    DF_in,
    mem_rd_size,
    mem_wr_size,
    alu2_op,
    alu_res2

);


input clk;
input rst;
input EIP_next;
input [31:0]sr1;
input [31:0]sr2;
input [31:0]esp;
input DF_in;
input [1:0] mem_rd_size;
input [1:0] mem_wr_size;
input [3:0] alu2_op;

output reg [31:0]alu_res2;

wire [31:0]w_alu_res2;

alu2 u_alu2(
  .EIP_next            (EIP_next), 
  .sr1                 (sr1), 
  .sr2                 (sr2), 
  .esp                 (esp), 
  .DF_in               (DF_in),
  .mem_rd_size         (mem_rd_size),
  .mem_wr_size         (mem_wr_size),
  .alu2_op             (alu2_op), 
  .alu_res2            (w_alu_res2) 

);

always @(posedge clk, posedge rst)
begin
  if(rst)
  begin
    alu_res2   <= 32'd0; 
  end
  else
  begin
    alu_res2   <=w_alu_res2   ;
  end
end

endmodule
