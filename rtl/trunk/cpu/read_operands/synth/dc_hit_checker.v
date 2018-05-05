/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache hit checker module                    */
/* Description: Generates busy, hit and miss signals    */
/********************************************************/

module dc_hit_checker( phy_tag, ts_tag2, ts_valid2, ts_tag1, ts_valid1,
                       tag_eq2, tag_eq1, tlb_pcd, ren, wen, v_mem_read, 
                       dc_miss_ack, access2_reg, access2_combo, dc_rd_exp, io_ack, io_access, 
                       mem_rd_ready, mem_wr_done, mem_rd_busy, mem_wr_busy, dc_miss,
                       dc_hit, dc_rd_hit, dc_wr_hit);

input  [6:0] phy_tag;
input  [6:0] ts_tag2;
input        ts_valid2;
input  [6:0] ts_tag1;
input        ts_valid1;
input        tlb_pcd;
input        ren;
input        wen;
input        v_mem_read;
input        dc_miss_ack;
input        dc_rd_exp;
input        access2_reg;
input        access2_combo;
input        io_ack;
input        io_access;

output       mem_rd_ready;
output       mem_wr_done;
output       mem_rd_busy;
output       mem_wr_busy;
output       dc_miss;
output       dc_hit;
output       dc_rd_hit;
output       dc_wr_hit;
output       tag_eq2;
output       tag_eq1;
// output       dc_evict;

// Internal Variables
wire w_tag_eq, w_tlb_pcd_bar, w_dc_miss_ack_bar, w_dc_rd_exp_bar;

wire  [6:0] ts_tag;
wire        ts_valid;

inv1$ u_inv1_1(.in(tlb_pcd), .out(w_tlb_pcd_bar));
inv1$ u_inv1_2(.in(dc_miss_ack), .out(w_dc_miss_ack_bar));
inv1$ u_inv1_3(.in(dc_rd_exp), .out(w_dc_rd_exp_bar));

eq_checker #(.WIDTH(7)) u_eq_checker2(.in1(phy_tag), .in2(ts_tag2), .eq_out(tag_eq2));
eq_checker #(.WIDTH(7)) u_eq_checker3(.in1(phy_tag), .in2(ts_tag1), .eq_out(tag_eq1));

mux2$ u_mux2$_g1[8:0] (.in0({tag_eq1, ts_tag1, ts_valid1}), .in1({tag_eq2, ts_tag2, ts_valid2}), .s0(tag_eq2), .outb({w_tag_eq, ts_tag, ts_valid}));

// dc_rd_hit = !tlb_pcd & !dc_miss_ack & !dc_rd_exp & ts_valid & ren & w_tag_eq
and3$ u_and3_1(.in0(w_tlb_pcd_bar), .in1(w_dc_miss_ack_bar), .in2(ts_valid), .out(n_001));
and3$ u_and3_2(.in0(n_001), .in1(ren), .in2(w_dc_rd_exp_bar), .out(n_002));
and2$ u_and2_1(.in0(n_002), .in1(w_tag_eq), .out(dc_rd_hit));

// dc_wr_hit = !tlb_pcd & !dc_miss_ack & ts_valid & wen & w_tag_eq
and3$ u_and3_3(.in0(w_tlb_pcd_bar), .in1(w_dc_miss_ack_bar), .in2(ts_valid), .out(n_003));
and2$ u_and2_6(.in0(n_003), .in1(wen), .out(n_004));
and2$ u_and2_2(.in0(n_004), .in1(w_tag_eq), .out(dc_wr_hit));

// dc_hit = dc_rd_hit | dc_wr_hit
or2$ u_or2_1(.in0(dc_rd_hit), .in1(dc_wr_hit), .out(dc_hit));

// dc_miss = !tlb_pcd & !(dc_rd_exp & ren) & (ren | wen) & !(w_tag_eq & ts_valid)
or2$ u_or2_2(.in0(ren), .in1(wen), .out(n_005));
nand2$ u_nand2_1(.in0(dc_rd_exp), .in1(ren), .out(n_901));
and3$ u_and3_5(.in0(w_tlb_pcd_bar), .in1(n_901), .in2(n_005), .out(n_006));
nand2$ u_nand2_2(.in0(w_tag_eq), .in1(ts_valid), .out(n_007));
and2$ u_and2_3(.in0(n_006), .in1(n_007), .out(dc_miss));

/*
// dc_evict = dc_miss & ts_valid & ts_dirty & !dc_miss_ack
and4$ u_and3_6(.in0(dc_miss), .in1(ts_valid), .in2(ts_dirty), .in3(w_dc_miss_ack_bar), .out(dc_evict));
*/

// mem_rd_ready, mem_wr_done, mem_rd_busy & mem_wr_busy generation
inv1$ u_inv1_4(.out(w_access2_combo_bar), .in(access2_combo));
mux2$ u_mux2_1(.outb(n_101), .in0(w_access2_combo_bar), .in1(1'b1), .s0(access2_reg));

and2$ u_and2_4(.in0(dc_rd_hit), .in1(n_101), .out(n_102));
and2$ u_and2_5(.in0(dc_wr_hit), .in1(n_101), .out(n_103));

mux2$ u_mux2_2(.outb(mem_rd_ready), .in0(n_102), .in1(io_ack), .s0(io_access));
mux2$ u_mux2_3(.outb(mem_wr_done), .in0(n_103), .in1(io_ack), .s0(io_access));

inv1$ u_inv1_5(.out(w_v_mem_read_bar), .in(v_mem_read));
inv1$ u_inv1_6(.out(w_wen_bar), .in(wen));

nor2$ u_nor2_2(.in0(mem_rd_ready), .in1(w_v_mem_read_bar), .out(mem_rd_busy));
nor2$ u_nor2_3(.in0(mem_wr_done), .in1(w_wen_bar), .out(mem_wr_busy));

endmodule

