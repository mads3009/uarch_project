/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache hit checker module                    */
/* Description: Generates busy, hit and miss signals    */
/********************************************************/

module dc_hit_checker( phy_tag, ts_tag, ts_valid, ts_dirty, tlb_pcd, ren, wen, v_mem_read, 
                       dc_miss_ack, access2_reg, access2_combo, dc_exp, io_ack, io_access, 
                       mem_rd_ready, mem_wr_done, mem_rd_busy, mem_wr_busy, dc_miss, dc_evict, 
                       dc_hit, dc_rd_hit, dc_wr_hit);

input  [5:0] phy_tag;
input  [5:0] ts_tag;
input        ts_valid;
input        ts_dirty;
input        tlb_pcd;
input        ren;
input        wen;
input        v_mem_read;
input        dc_miss_ack;
input        dc_exp;
input        access2_reg;
input        access2_combo;
input        io_ack;
input        io_access;

output       mem_rd_ready;
output       mem_wr_done;
output       mem_rd_busy;
output       mem_wr_busy;
output       dc_miss;
output       dc_evict;
output       dc_hit;
output       dc_rd_hit;
output       dc_wr_hit;

// Internal Variables
wire w_tag_eq, w_tlb_pcd_bar, w_dc_miss_ack_bar, w_dc_exp_bar;

inv1$ u_inv1_1(.in(tlb_pcd), .out(w_tlb_pcd_bar));
inv1$ u_inv1_2(.in(dc_miss_ack), .out(w_dc_miss_ack_bar));
inv1$ u_inv1_3(.in(dc_exp), .out(w_dc_exp_bar));

eq_checker6 u_eq_checker6(.in1(phy_tag), .in2(ts_tag), .eq_out(w_tag_eq));

// dc_rd_hit = !tlb_pcd & !dc_miss_ack & !dc_exp & ts_valid & ren & w_tag_eq
and3$ u_and3_1(.in0(w_tlb_pcd_bar), .in1(w_dc_miss_ack_bar), .in2(ts_valid), .out(n_001));
and3$ u_and3_2(.in0(n_001), .in1(ren), .in2(w_dc_exp_bar), .out(n_002));
and2$ u_and2_1(.in0(n_002), .in1(w_tag_eq), .out(dc_rd_hit));

// dc_wr_hit = !tlb_pcd & !dc_miss_ack & !dc_exp & ts_valid & wen & w_tag_eq
and3$ u_and3_3(.in0(w_tlb_pcd_bar), .in1(w_dc_miss_ack_bar), .in2(ts_valid), .out(n_003));
and3$ u_and3_4(.in0(n_003), .in1(wen), .in2(w_dc_exp_bar), .out(n_004));
and2$ u_and2_2(.in0(n_004), .in1(w_tag_eq), .out(dc_wr_hit));

// dc_hit = dc_rd_hit | dc_wr_hit
or2$ u_or2_1(.in0(dc_rd_hit), .in1(dc_wr_hit), .out(dc_hit));

// dc_miss = !tlb_pcd & !dc_exp & (ren | wen) & !(w_tag_eq & ts_valid)
or2$ u_or2_2(.in0(ren), .in1(wen), .out(n_005));
and3$ u_and3_5(.in0(w_tlb_pcd_bar), .in1(w_dc_exp_bar), .in2(n_005), .out(n_006));
nand2$ u_nand2_1(.in0(w_tag_eq), .in1(ts_valid), .out(n_007));
and2$ u_and2_3(.in0(n_006), .in1(n_007), .out(dc_miss));

// dc_evict = dc_miss & ts_valid & ts_dirty
and3$ u_and3_6(.in0(dc_miss), .in1(ts_valid), .in2(ts_dirty), .out(dc_evict));

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

