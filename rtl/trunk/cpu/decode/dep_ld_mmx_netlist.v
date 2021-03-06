
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/dep_ld_mmx 

module dep_ld_mmx(mm1_needed_in, mm2_needed_in, sr1_rm, sr2_rm, mod,
     mod_rm_pr, ld_mm_in, ret_op, eip_ch, ld_mm, mm1_needed,
     mm2_needed, mm_sr1_sel_L, mm_sr2_sel);
  input mm1_needed_in, mm2_needed_in, sr1_rm, sr2_rm, mod_rm_pr,
       ld_mm_in, ret_op, eip_ch;
  input [1:0] mod;
  output ld_mm, mm1_needed, mm2_needed, mm_sr1_sel_L, mm_sr2_sel;
  wire mm1_needed_in, mm2_needed_in, sr1_rm, sr2_rm, mod_rm_pr,
       ld_mm_in, ret_op, eip_ch;
  wire [1:0] mod;
  wire ld_mm, mm1_needed, mm2_needed, mm_sr1_sel_L, mm_sr2_sel;
  wire n_0, n_1, n_2, n_4, n_5, n_6, n_9;
  and2$ g338(.in0 (n_9), .in1 (ld_mm_in), .out (ld_mm));
  and2$ g339(.in0 (n_9), .in1 (mm1_needed_in), .out (mm1_needed));
  and2$ g340(.in0 (n_6), .in1 (mm2_needed_in), .out (mm2_needed));
  nand2$ g341(.in0 (n_4), .in1 (n_1), .out (mm_sr1_sel_L));
  nand2$ g342(.in0 (n_5), .in1 (sr1_rm), .out (n_9));
  nand2$ g343(.in0 (n_5), .in1 (sr2_rm), .out (n_6));
  nand3$ g346(.in0 (n_0), .in1 (n_2), .in2 (sr1_rm), .out (n_4));
  and2$ g345(.in0 (n_2), .in1 (sr2_rm), .out (mm_sr2_sel));
  nand3$ g344(.in0 (mod[1]), .in1 (mod_rm_pr), .in2 (mod[0]), .out
       (n_5));
  nand2$ g347(.in0 (mod[1]), .in1 (mod[0]), .out (n_2));
  inv1$ g349(.in (ret_op), .out (n_1));
  inv1$ g348(.in (eip_ch), .out (n_0));
endmodule

