module alu1_top (
    clk,
    rst,
    sr1,
    sr2,
    mem_out,
    mem_out_latched ,
    eax,
    alu1_op,
    alu1_op_size,
    mem_rd_size,
    CF_in,
    AF_in,
    DF_in,
    df_val,
    ISR,
    ld_flag_CF_in,
    ld_flag_PF_in,
    ld_flag_AF_in,
    ld_flag_ZF_in,
    ld_flag_SF_in,
    ld_flag_OF_in,
    alu_res1,
    alu1_flags,
    cmps_flags,
    df_val_ex,
    ld_flag_CF,
    ld_flag_PF,
    ld_flag_AF,
    ld_flag_ZF,
    ld_flag_SF,
    ld_flag_OF
);


input clk;
input rst;
input [31:0]sr1;
input [31:0]sr2;
input [31:0]mem_out;
input [31:0]mem_out_latched ;
input [31:0]eax;
input [3:0] alu1_op;
input [1:0] alu1_op_size;
input [1:0] mem_rd_size;
input CF_in;
input AF_in;
input DF_in;
input df_val;
input ISR;
input ld_flag_CF_in;
input ld_flag_PF_in;
input ld_flag_AF_in;
input ld_flag_ZF_in;
input ld_flag_SF_in;
input ld_flag_OF_in;

output reg [31:0]alu_res1;
output reg [5:0] alu1_flags;
output reg [5:0] cmps_flags;
output reg df_val_ex;
output reg ld_flag_CF;
output reg ld_flag_PF;
output reg ld_flag_AF;
output reg ld_flag_ZF;
output reg ld_flag_SF;
output reg ld_flag_OF;




wire [31:0]w_alu_res1;
wire [5:0] w_alu1_flags;
wire [5:0] w_cmps_flags;
wire       w_df_val_ex;
wire w_ld_flag_CF;
wire w_ld_flag_PF;
wire w_ld_flag_AF;
wire w_ld_flag_ZF;
wire w_ld_flag_SF;
wire w_ld_flag_OF;



alu1 u_alu1(
  .sr1                 (sr1), 
  .sr2                 (sr2), 
  .mem_out             (mem_out), 
  .mem_out_latched     (mem_out_latched), 
  .eax                 (eax), 
  .alu1_op             (alu1_op),
  .alu1_op_size        (alu1_op_size),
  .mem_rd_size         (mem_rd_size),
  .CF_in               (CF_in),
  .AF_in               (AF_in),
  .DF_in               (DF_in),
  .df_val              (df_val),
  .ISR                 (ISR),
  .ld_flag_CF_in       (ld_flag_CF_in),  
  .ld_flag_PF_in       (ld_flag_PF_in),
  .ld_flag_AF_in       (ld_flag_AF_in),
  .ld_flag_ZF_in       (ld_flag_ZF_in),
  .ld_flag_SF_in       (ld_flag_SF_in),
  .ld_flag_OF_in       (ld_flag_OF_in),
  .alu_res1            (w_alu_res1), 
  .alu1_flags          (w_alu1_flags),
  .cmps_flags          (w_cmps_flags),
  .df_val_ex           (w_df_val_ex),
  .ld_flag_CF          (w_ld_flag_CF),
  .ld_flag_PF          (w_ld_flag_PF),
  .ld_flag_AF          (w_ld_flag_AF),
  .ld_flag_ZF          (w_ld_flag_ZF),
  .ld_flag_SF          (w_ld_flag_SF),
  .ld_flag_OF          (w_ld_flag_OF)



);

always @(posedge clk, posedge rst)
begin
  if(rst)
  begin
    alu_res1   <= 32'd0; 
    alu1_flags <= 6'd0;
    cmps_flags <= 6'd0;
    df_val_ex  <= 1'b0;
    ld_flag_CF <= 1'b0; 
    ld_flag_PF <= 1'b0;
    ld_flag_AF <= 1'b0;
    ld_flag_ZF <= 1'b0;
    ld_flag_SF <= 1'b0;
    ld_flag_OF <= 1'b0;

  end
  else
  begin
    alu_res1   <=w_alu_res1   ;
    alu1_flags <=w_alu1_flags;
    cmps_flags <=w_cmps_flags;
    df_val_ex  <=w_df_val_ex ;
    ld_flag_CF <=w_ld_flag_CF;
    ld_flag_PF <=w_ld_flag_PF;
    ld_flag_AF <=w_ld_flag_AF;
    ld_flag_ZF <=w_ld_flag_ZF;
    ld_flag_SF <=w_ld_flag_SF;
    ld_flag_OF <=w_ld_flag_OF;

  end
end

endmodule
