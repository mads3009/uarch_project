module EIP_reg (
  input clk,
  input rst_n,
  input [31:0] r_wb_alu_res1,
  input [31:0] r_wb_alu_res3,
  input r_wb_wr_eip_alu_res_sel,
  input [31:0] w_de_EIP_next,
  input [31:0] r_wb_EIP_next,
  input r_V_wb,
  input r_wb_eip_change,
  input r_wb_cond_wr_CF,
  input r_wb_cond_wr_ZF,
  input r_V_de,
  input w_de_br_stall,
  input w_not_stall_fe,
  input r_wb_pr_size_over,
  input w_wb_flag_ZF,
  input w_wb_flag_CF,
  input r_wb_ZF_expected,
  input r_wb_CF_expected,
  input w_de_ic_exp,
  
  output [31:0] r_EIP,
  output [1:0] ld_eip
);
 
wire [1:0]  w_EIP_sel;

wire w_wb_CF_as_expected;
wire w_wb_ZF_as_expected;
xnor2$ u_w_wb_CF_as_expected (.out(w_wb_CF_as_expected), .in0(r_wb_CF_expected), .in1(w_wb_flag_CF));
xnor2$ u_w_wb_ZF_as_expected (.out(w_wb_ZF_as_expected), .in0(r_wb_ZF_expected), .in1(w_wb_flag_ZF));

wire w_not_cond_wr_CF;
wire w_not_cond_wr_ZF;
inv1$  u_w_not_cond_wr_CF (.out(w_not_cond_wr_CF), .in(r_wb_cond_wr_CF));
inv1$  u_w_not_cond_wr_ZF (.out(w_not_cond_wr_ZF), .in(r_wb_cond_wr_ZF));

wire w_wb_CF_met;
wire w_wb_ZF_met;
or2$ u_w_wb_CF_met (.out(w_wb_CF_met), .in0(w_wb_CF_as_expected), .in1(w_not_cond_wr_CF));
or2$ u_w_wb_ZF_met (.out(w_wb_ZF_met), .in0(w_wb_ZF_as_expected), .in1(w_not_cond_wr_ZF));

inv1$ u_not_br_stall (.in(w_de_br_stall), .out(w_not_de_br_stall));
and2$ u_CF_ZF_x (.in0(w_wb_CF_met), .in1(w_wb_ZF_met), .out(w_mux_x_sel));
and2$ u_w_EIP_sel1 (.out(w_EIP_sel[1]), .in0(r_V_wb), .in1(r_wb_eip_change));
inv1$ u_w_de_not_ic_exp (.out(w_de_not_ic_exp), .in(w_de_ic_exp));
and4$ u_w_EIP_sel0 (.out(w_EIP_sel[0]), .in0(r_V_de), .in1(w_not_stall_fe), .in2(w_not_de_br_stall), .in3(w_de_not_ic_exp));

wire [31:0] w_eip_alu_res_temp;
wire [31:0] w_eip_alu_res;
mux_nbit_2x1 u_eip_alu_res_temp(.out(w_eip_alu_res_temp), .a0(r_wb_alu_res1), .a1(r_wb_alu_res3), .sel(r_wb_wr_eip_alu_res_sel));
mux_nbit_2x1 u_eip_alu_res     (.out(w_eip_alu_res), .a0(r_wb_EIP_next), .a1(w_eip_alu_res_temp), .sel(w_mux_x_sel));

wire [31:0] w_eip_alu_res_with_pr_over;
mux_nbit_2x1 u_eip_alu_res_with_pr_over(.out(w_eip_alu_res_with_pr_over), .a0(w_eip_alu_res), .a1({16'h0,w_eip_alu_res[15:0]}), .sel(r_wb_pr_size_over));
register_ld2bit u_r_EIP(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld({w_EIP_sel[1],w_EIP_sel[0]}), 
                        .data_i1(w_de_EIP_next), .data_i2(w_eip_alu_res_with_pr_over), .data_i3(w_eip_alu_res_with_pr_over), .data_o(r_EIP));

assign ld_eip = w_EIP_sel;

endmodule
