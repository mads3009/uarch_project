/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache exception checker module              */
/* Description: Generates page fault & protection exp   */
/********************************************************/

module dc_exp_checker(v_ro_mem_read, v_ro_ld_mem, isr, mem_wr_addr, mem_wr_addr_end, seg_wr_limit, 
                      wr_addr_offset_end, mem_rd_addr, mem_rd_addr_end, seg_rd_limit, rd_addr_offset_end, 
                      dc_rd_exp, dc_wr_exp, dc_exp, dc_prot_exp, dc_page_fault);

input        v_ro_mem_read;
input        v_ro_ld_mem;
input        isr;
input [31:0] mem_wr_addr;
input [31:0] mem_wr_addr_end;
input [31:0] seg_wr_limit;
input [31:0] wr_addr_offset_end;
input [31:0] mem_rd_addr;
input [31:0] mem_rd_addr_end;
input [31:0] seg_rd_limit;
input [31:0] rd_addr_offset_end;
output       dc_rd_exp;
output       dc_wr_exp;
output       dc_exp;
output       dc_prot_exp;
output       dc_page_fault;

// Internal Variables

wire [19:0]         w_tlb_pn0,w_tlb_pn1,w_tlb_pn2,w_tlb_pn3,w_tlb_pn4,w_tlb_pn5,w_tlb_pn6,w_tlb_pn7;
wire [2:0]          w_tlb_addr1;
wire [19:0]         w_tlb_phy_pn1;
wire                w_tlb_rw1;
wire                w_tlb_valid1;
wire                w_tlb_pr1;
wire [2:0]          w_tlb_addr2;
wire [19:0]         w_tlb_phy_pn2;
wire                w_tlb_rw2;
wire                w_tlb_valid2;
wire                w_tlb_pr2;
wire [2:0]          w_tlb_addr3;
wire [19:0]         w_tlb_phy_pn3;
wire                w_tlb_rw3;
wire                w_tlb_valid3;
wire                w_tlb_pr3;
wire [2:0]          w_tlb_addr4;
wire [19:0]         w_tlb_phy_pn4;
wire                w_tlb_rw4;
wire                w_tlb_valid4;
wire                w_tlb_pr4;

tlb u_tlb(
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),

  .tlb_addr1(w_tlb_addr1),
  .tlb_phy_pn1(w_tlb_phy_pn1),
  .tlb_vpn1(/*Unused*/),
  .tlb_valid1(w_tlb_valid1),
  .tlb_pr1(w_tlb_pr1),
  .tlb_rw1(w_tlb_rw1),
  .tlb_pcd1(/*Unused*/),

  .tlb_addr2(w_tlb_addr2),
  .tlb_phy_pn2(w_tlb_phy_pn2),
  .tlb_vpn2(/*Unused*/),
  .tlb_valid2(w_tlb_valid2),
  .tlb_pr2(w_tlb_pr2),
  .tlb_rw2(w_tlb_rw2),
  .tlb_pcd2(/*Unused*/),

  .tlb_addr3(w_tlb_addr3),
  .tlb_phy_pn3(w_tlb_phy_pn3),
  .tlb_vpn3(/*Unused*/),
  .tlb_valid3(w_tlb_valid3),
  .tlb_pr3(w_tlb_pr3),
  .tlb_rw3(w_tlb_rw3),
  .tlb_pcd3(/*Unused*/),

  .tlb_addr4(w_tlb_addr4),
  .tlb_phy_pn4(w_tlb_phy_pn4),
  .tlb_vpn4(/*Unused*/),
  .tlb_valid4(w_tlb_valid4),
  .tlb_pr4(w_tlb_pr4),
  .tlb_rw4(w_tlb_rw4),
  .tlb_pcd4(/*Unused*/)

  );

tlb_addr_gen u_tlb_addr_gen_rd(
  .mem_rw_addr_vpn(mem_rd_addr[31:12]),
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr(w_tlb_addr1),
  .tlb_addr_valid(w_tlb_addr_valid1)
  );

tlb_addr_gen u_tlb_addr_gen_wr(
  .mem_rw_addr_vpn(mem_wr_addr[31:12]),
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr(w_tlb_addr2),
  .tlb_addr_valid(w_tlb_addr_valid2)
  );

tlb_addr_gen u_tlb_addr_gen_rd_end(
  .mem_rw_addr_vpn(mem_rd_addr_end[31:12]),
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr(w_tlb_addr3),
  .tlb_addr_valid(w_tlb_addr_valid3)
  );

tlb_addr_gen u_tlb_addr_gen_wr_end(
  .mem_rw_addr_vpn(mem_wr_addr_end[31:12]),
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr(w_tlb_addr4),
  .tlb_addr_valid(w_tlb_addr_valid4)
  );

inv1$ u_w_tlb_addr_valid1_bar (.out(w_tlb_addr_valid1_bar), .in(w_tlb_addr_valid1));
inv1$ u_w_tlb_addr_valid2_bar (.out(w_tlb_addr_valid2_bar), .in(w_tlb_addr_valid2));
inv1$ u_w_tlb_addr_valid3_bar (.out(w_tlb_addr_valid3_bar), .in(w_tlb_addr_valid3));
inv1$ u_w_tlb_addr_valid4_bar (.out(w_tlb_addr_valid4_bar), .in(w_tlb_addr_valid4));

inv1$ u_inv1_1(.in(v_ro_mem_read), .out(w_v_ro_mem_read_bar));
inv1$ u_inv1_2(.in(v_ro_ld_mem), .out(w_v_ro_ld_mem_bar));
inv1$ u_inv1_3(.in(isr), .out(w_isr_bar));

//hit miss RW
nand3$ u_nand3_1(.in0(w_tlb_valid1), .in1(w_tlb_pr1), .in2(w_tlb_addr_valid1), .out(w_tlb_rd_hit_bar));
nand3$ u_nand3_2(.in0(w_tlb_valid2), .in1(w_tlb_pr2), .in2(w_tlb_addr_valid2), .out(w_tlb_wr_hit_bar));
nand3$ u_nand3_12(.in0(w_tlb_valid3), .in1(w_tlb_pr3), .in2(w_tlb_addr_valid3), .out(w_tlb_rd_end_hit_bar));
nand3$ u_nand3_22(.in0(w_tlb_valid4), .in1(w_tlb_pr4), .in2(w_tlb_addr_valid4), .out(w_tlb_wr_end_hit_bar));
inv1$ u_inv1_4(.in(w_tlb_rw2), .out(w_tlb_wr_rw_bar));
inv1$ u_inv1_42(.in(w_tlb_rw4), .out(w_tlb_wr_end_rw_bar));

nand4$ u_nand2_3(.in0(w_tlb_rd_hit_bar), .in1(v_ro_mem_read), .in2(w_isr_bar), .in3(w_tlb_rd_end_hit_bar), .out(w_dc_rd_page_fault_bar));
nand4$ u_nand2_4(.in0(w_tlb_wr_hit_bar), .in1(v_ro_ld_mem), .in2(w_isr_bar), .in3(w_tlb_wr_end_hit_bar), .out(w_dc_wr_page_fault_bar));

// Segment limit checking
greater_than32 u_greater_than32_1(.in1(rd_addr_offset_end), .in2(seg_rd_limit), .gt_out(w_rd_limit_cross));
greater_than32 u_greater_than32_2(.in1(wr_addr_offset_end), .in2(seg_wr_limit), .gt_out(w_wr_limit_cross));

and3$ u_and3_1(.in0(w_rd_limit_cross), .in1(v_ro_mem_read), .in2(w_isr_bar), .out(w_dc_rd_prot_exp));
nand4$ u_nand3_3(.in0(w_rd_limit_cross), .in1(v_ro_mem_read), .in2(w_isr_bar), .in3(w_tlb_addr_valid1), .out(w_dc_rd_prot_exp_bar));

nor3$ u_nor2_1(.in0(w_tlb_wr_rw_bar), .in1(w_wr_limit_cross), .in2(w_tlb_wr_end_rw_bar), .out(n_001));
nor4$ u_or3_1(.in0(n_001), .in1(w_v_ro_ld_mem_bar), .in2(isr), .in3(w_tlb_addr_valid2_bar), .out(w_dc_wr_prot_exp_start));
nor4$ u_or3_111(.in0(n_001), .in1(w_v_ro_ld_mem_bar), .in2(isr), .in3(w_tlb_addr_valid4_bar), .out(w_dc_wr_prot_exp_end));
nand2$ u_ (.out(w_dc_wr_prot_exp_bar), .in0(w_dc_wr_prot_exp_start), .in1(w_dc_wr_prot_exp_end));

//dc prot exp, dc page fault
nand2$ u_nand2_5(.in0(w_dc_rd_page_fault_bar), .in1(w_dc_wr_page_fault_bar), .out(dc_page_fault));
nand2$ u_nand2_6(.in0(w_dc_rd_prot_exp_bar), .in1(w_dc_wr_prot_exp_bar), .out(dc_prot_exp));

//dc_exp
nand4$ u_nand4_1(.in0(w_dc_wr_prot_exp_bar), .in1(w_dc_rd_prot_exp_bar), .in2(w_dc_rd_page_fault_bar), .in3(w_dc_wr_page_fault_bar), .out(dc_exp));

//read/wr exp
nand2$ u_nand2_7(.in0(w_dc_rd_prot_exp_bar), .in1(w_dc_rd_page_fault_bar), .out(dc_rd_exp));
nand2$ u_nand2_8(.in0(w_dc_wr_prot_exp_bar), .in1(w_dc_wr_page_fault_bar), .out(dc_wr_exp));

endmodule

