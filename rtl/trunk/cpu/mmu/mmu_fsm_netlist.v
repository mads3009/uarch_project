
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/mmu_fsm 

module mmu_fsm(clk, rst_n, ld_ro, io_access, io_rw, ic_miss, dc_miss,
     dc_evict_flag, mmu_ack, curr_st, next_st, count_eq3, count_eq7);
  input clk, rst_n, ld_ro, io_access, io_rw, ic_miss, dc_miss,
       dc_evict_flag, mmu_ack, count_eq3, count_eq7;
  output [2:0] curr_st, next_st;
  wire clk, rst_n, ld_ro, io_access, io_rw, ic_miss, dc_miss,
       dc_evict_flag, mmu_ack, count_eq3, count_eq7;
  wire [2:0] curr_st, next_st;
  wire UNCONNECTED, UNCONNECTED0, UNCONNECTED1, n_0, n_1, n_2, n_3, n_4;
  wire n_5, n_6, n_7, n_8, n_9, n_10, n_11, n_12;
  wire n_13, n_14, n_15, n_16, n_17, n_18, n_19, n_20;
  wire n_21, n_22, n_23, n_24, n_25, n_26, n_28;
  dff$ \curr_st_reg[0] (.r (rst_n), .s (1'b1), .clk (clk), .d
       (next_st[0]), .q (curr_st[0]), .qbar (UNCONNECTED));
  nand2$ g1345(.in0 (n_28), .in1 (n_16), .out (next_st[0]));
  dff$ \curr_st_reg[2] (.r (rst_n), .s (1'b1), .clk (clk), .d
       (next_st[2]), .q (curr_st[2]), .qbar (UNCONNECTED0));
  nand2$ g1348(.in0 (n_26), .in1 (mmu_ack), .out (n_28));
  dff$ \curr_st_reg[1] (.r (rst_n), .s (1'b1), .clk (clk), .d
       (next_st[1]), .q (curr_st[1]), .qbar (UNCONNECTED1));
  nand3$ g1350(.in0 (n_19), .in1 (n_25), .in2 (n_5), .out (next_st[2]));
  nand3$ g1351(.in0 (n_8), .in1 (n_24), .in2 (n_9), .out (n_26));
  nand2$ g1349(.in0 (n_23), .in1 (n_22), .out (next_st[1]));
  nand3$ g1353(.in0 (n_0), .in1 (n_21), .in2 (ic_miss), .out (n_25));
  nand3$ g1360(.in0 (n_1), .in1 (n_18), .in2 (io_access), .out (n_24));
  nand2$ g1352(.in0 (n_20), .in1 (dc_miss), .out (n_23));
  nand2$ g1355(.in0 (n_17), .in1 (curr_st[1]), .out (n_22));
  nand2$ g1354(.in0 (n_13), .in1 (n_3), .out (n_21));
  nand2$ g1356(.in0 (n_11), .in1 (n_4), .out (n_20));
  or4$ g1359(.in0 (n_12), .in1 (n_14), .in2 (n_2), .in3 (curr_st[2]),
       .out (n_19));
  nor2$ g1361(.in0 (io_rw), .in1 (n_15), .out (n_18));
  nand2$ g1362(.in0 (n_7), .in1 (curr_st[0]), .out (n_17));
  or3$ g1358(.in0 (n_15), .in1 (ld_ro), .in2 (n_14), .out (n_16));
  nand3$ g1363(.in0 (n_14), .in1 (n_10), .in2 (n_12), .out (n_13));
  nand3$ g1365(.in0 (n_14), .in1 (n_10), .in2 (n_6), .out (n_11));
  nand4$ g1357(.in0 (n_12), .in1 (n_14), .in2 (count_eq7), .in3
       (curr_st[2]), .out (n_9));
  nand3$ g1364(.in0 (n_14), .in1 (count_eq3), .in2 (curr_st[1]), .out
       (n_8));
  nand2$ g1366(.in0 (dc_evict_flag), .in1 (n_6), .out (n_7));
  nand2$ g1367(.in0 (n_14), .in1 (curr_st[2]), .out (n_5));
  nand2$ g1369(.in0 (n_12), .in1 (n_6), .out (n_15));
  nand2$ g1371(.in0 (curr_st[0]), .in1 (curr_st[2]), .out (n_4));
  nand2$ g1368(.in0 (curr_st[1]), .in1 (curr_st[2]), .out (n_3));
  nor2$ g1370(.in0 (ic_miss), .in1 (dc_evict_flag), .out (n_2));
  inv1$ g1377(.in (ld_ro), .out (n_1));
  inv1$ g1375(.in (io_access), .out (n_10));
  inv1$ g1373(.in (curr_st[2]), .out (n_6));
  inv1$ g1374(.in (curr_st[0]), .out (n_14));
  inv1$ g1372(.in (curr_st[1]), .out (n_12));
  inv1$ g1376(.in (dc_miss), .out (n_0));
endmodule

