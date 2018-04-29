
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/intexp_fsm 

module intexp_fsm(clk, rst_n, ld_ag, iret_op, int, ic_exp, dc_exp,
     end_bit, v_de, v_ag, v_ro, v_ex, v_wb, fifo_empty_bar, int_clear,
     block_ic_ren, rseq_mux_sel, curr_st);
  input clk, rst_n, ld_ag, iret_op, int, ic_exp, dc_exp, end_bit, v_de,
       v_ag, v_ro, v_ex, v_wb, fifo_empty_bar;
  output int_clear, block_ic_ren, rseq_mux_sel;
  output [2:0] curr_st;
  wire clk, rst_n, ld_ag, iret_op, int, ic_exp, dc_exp, end_bit, v_de,
       v_ag, v_ro, v_ex, v_wb, fifo_empty_bar;
  wire int_clear, block_ic_ren, rseq_mux_sel;
  wire [2:0] curr_st;
  wire UNCONNECTED, UNCONNECTED0, UNCONNECTED1, n_0, n_1, n_2, n_3, n_4;
  wire n_5, n_6, n_7, n_8, n_9, n_10, n_11, n_14;
  wire n_15, n_17, n_18, n_19, n_20, n_21, n_22, n_23;
  wire n_24, n_25, n_26, n_27, n_28, n_29;
  dff$ \curr_st_reg[0] (.r (rst_n), .s (1'b1), .clk (clk), .d (n_29),
       .q (curr_st[0]), .qbar (UNCONNECTED));
  dff$ \curr_st_reg[1] (.r (rst_n), .s (1'b1), .clk (clk), .d (n_28),
       .q (curr_st[1]), .qbar (UNCONNECTED0));
  nand4$ g715(.in0 (n_14), .in1 (n_26), .in2 (n_25), .in3 (n_22), .out
       (n_29));
  dff$ \curr_st_reg[2] (.r (rst_n), .s (1'b1), .clk (clk), .d (n_27),
       .q (curr_st[2]), .qbar (UNCONNECTED1));
  nor3$ g716(.in0 (n_21), .in1 (n_24), .in2 (n_3), .out (n_28));
  nand3$ g717(.in0 (n_20), .in1 (n_26), .in2 (n_5), .out (n_27));
  nand2$ g720(.in0 (n_23), .in1 (n_18), .out (n_25));
  mux2$ g718(.s0 (n_23), .in0 (n_17), .in1 (n_19), .outb (n_24));
  nand2$ g719(.in0 (n_2), .in1 (n_21), .out (n_22));
  nand4$ g721(.in0 (n_10), .in1 (n_11), .in2 (n_15), .in3 (n_19), .out
       (n_20));
  or2$ g726(.in0 (n_17), .in1 (n_19), .out (n_18));
  and2$ g723(.in0 (int), .in1 (n_17), .out (int_clear));
  nand4$ g722(.in0 (n_8), .in1 (n_15), .in2 (n_1), .in3 (curr_st[1]),
       .out (n_26));
  nand2$ g724(.in0 (n_6), .in1 (rseq_mux_sel), .out (n_14));
  nor2$ g725(.in0 (iret_op), .in1 (block_ic_ren), .out (n_21));
  nand3$ g727(.in0 (n_11), .in1 (n_15), .in2 (n_10), .out (n_23));
  nor2$ g730(.in0 (n_9), .in1 (curr_st[1]), .out (n_19));
  nor2$ g732(.in0 (n_9), .in1 (n_7), .out (n_17));
  nand2$ g728(.in0 (n_8), .in1 (n_7), .out (block_ic_ren));
  nand2$ g729(.in0 (n_4), .in1 (n_0), .out (n_6));
  nand2$ g731(.in0 (n_4), .in1 (rseq_mux_sel), .out (n_5));
  and2$ g736(.in0 (n_7), .in1 (curr_st[2]), .out (n_3));
  or3$ g733(.in0 (ic_exp), .in1 (int), .in2 (dc_exp), .out (n_2));
  nor4$ g734(.in0 (v_wb), .in1 (v_ex), .in2 (v_ro), .in3
       (fifo_empty_bar), .out (n_1));
  or2$ g735(.in0 (n_0), .in1 (curr_st[2]), .out (n_9));
  nor2$ g740(.in0 (v_wb), .in1 (fifo_empty_bar), .out (n_10));
  nand2$ g737(.in0 (ld_ag), .in1 (end_bit), .out (n_4));
  nor2$ g738(.in0 (curr_st[2]), .in1 (curr_st[0]), .out (n_8));
  and2$ g739(.in0 (curr_st[2]), .in1 (curr_st[1]), .out (rseq_mux_sel));
  nor2$ g741(.in0 (v_de), .in1 (v_ag), .out (n_15));
  nor2$ g742(.in0 (v_ro), .in1 (v_ex), .out (n_11));
  inv1$ g743(.in (curr_st[1]), .out (n_7));
  inv1$ g744(.in (curr_st[0]), .out (n_0));
endmodule

