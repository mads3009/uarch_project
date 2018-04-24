
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/fetch_fsm 

module fetch_fsm(clk, rst_n, de_p, eip_4, ic_hit, r_V_de, int, ic_exp,
     dc_exp, de_br_stall, f_ld_buf, f_curr_st, f_next_st,
     f_address_sel, f_nextstate_01_11);
  input clk, rst_n, de_p, eip_4, ic_hit, r_V_de, int, ic_exp, dc_exp,
       de_br_stall;
  output [1:0] f_ld_buf;
  output [2:0] f_curr_st, f_next_st;
  output f_address_sel, f_nextstate_01_11;
  wire clk, rst_n, de_p, eip_4, ic_hit, r_V_de, int, ic_exp, dc_exp,
       de_br_stall;
  wire [1:0] f_ld_buf;
  wire [2:0] f_curr_st, f_next_st;
  wire f_address_sel, f_nextstate_01_11;
  wire UNCONNECTED, UNCONNECTED0, UNCONNECTED1, n_0, n_1, n_2, n_3, n_4;
  wire n_5, n_6, n_7, n_8, n_9, n_10, n_11, n_12;
  wire n_13, n_14, n_15, n_16, n_17, n_18, n_19, n_20;
  wire n_21, n_22, n_23, n_24, n_25, n_26, n_27, n_28;
  wire n_29, n_30, n_31, n_32, n_33, n_34, n_35, n_36;
  wire n_37, n_38, n_41, n_42, n_44, n_45, n_46, n_48;
  wire n_50, n_52, n_54;
  assign f_address_sel = f_curr_st[2];
  dff$ f_address_sel_reg(.r (rst_n), .s (1'b1), .clk (clk), .d (n_54),
       .q (f_curr_st[2]), .qbar (UNCONNECTED));
  and3$ g3389(.in0 (n_42), .in1 (n_52), .in2 (n_48), .out (n_54));
  dff$ \f_curr_st_reg[1] (.r (rst_n), .s (1'b1), .clk (clk), .d (n_50),
       .q (f_curr_st[1]), .qbar (UNCONNECTED0));
  nand3$ g3394(.in0 (n_41), .in1 (n_38), .in2 (n_20), .out (n_52));
  nor3$ g3384(.in0 (n_37), .in1 (n_46), .in2 (n_45), .out
       (f_nextstate_01_11));
  and2$ g3385(.in0 (f_next_st[1]), .in1 (n_48), .out (n_50));
  dff$ \f_curr_st_reg[0] (.r (rst_n), .s (1'b1), .clk (clk), .d (n_44),
       .q (f_curr_st[0]), .qbar (UNCONNECTED1));
  nor2$ g3388(.in0 (n_46), .in1 (n_45), .out (f_next_st[2]));
  and2$ g3390(.in0 (f_next_st[0]), .in1 (n_48), .out (n_44));
  nand3$ g3392(.in0 (n_5), .in1 (n_42), .in2 (n_13), .out (n_46));
  nand3$ g3387(.in0 (n_36), .in1 (n_25), .in2 (n_41), .out
       (f_next_st[1]));
  nand2$ g3391(.in0 (n_34), .in1 (n_41), .out (f_ld_buf[1]));
  nand3$ g3393(.in0 (n_33), .in1 (n_29), .in2 (n_15), .out
       (f_ld_buf[0]));
  nand2$ g3397(.in0 (n_35), .in1 (f_curr_st[0]), .out (n_38));
  nor2$ g3399(.in0 (n_31), .in1 (n_23), .out (n_37));
  nand3$ g3400(.in0 (n_32), .in1 (n_19), .in2 (n_30), .out
       (f_next_st[0]));
  nor2$ g3395(.in0 (n_21), .in1 (n_22), .out (n_36));
  nand2$ g3409(.in0 (n_27), .in1 (n_28), .out (n_35));
  nand2$ g3396(.in0 (n_26), .in1 (n_12), .out (n_34));
  or2$ g3404(.in0 (n_32), .in1 (f_curr_st[0]), .out (n_33));
  nand2$ g3407(.in0 (n_32), .in1 (n_30), .out (n_31));
  nand3$ g3411(.in0 (n_24), .in1 (n_6), .in2 (f_curr_st[1]), .out
       (n_29));
  nand4$ g3398(.in0 (r_V_de), .in1 (de_p), .in2 (n_28), .in3 (n_7),
       .out (n_42));
  nand2$ g3416(.in0 (n_9), .in1 (f_curr_st[2]), .out (n_27));
  nand2$ g3401(.in0 (n_18), .in1 (n_16), .out (n_26));
  nand3$ g3402(.in0 (n_8), .in1 (n_24), .in2 (f_curr_st[2]), .out
       (n_25));
  nor2$ g3405(.in0 (n_41), .in1 (eip_4), .out (n_23));
  nand2$ g3408(.in0 (n_11), .in1 (n_2), .out (n_45));
  nor2$ g3410(.in0 (ic_hit), .in1 (n_17), .out (n_22));
  nand2$ g3419(.in0 (ic_hit), .in1 (n_4), .out (n_32));
  nor3$ g3403(.in0 (n_30), .in1 (r_V_de), .in2 (n_20), .out (n_21));
  nand3$ g3406(.in0 (ic_hit), .in1 (n_1), .in2 (n_14), .out (n_19));
  nand4$ g3415(.in0 (r_V_de), .in1 (ic_hit), .in2 (n_10), .in3
       (f_curr_st[0]), .out (n_18));
  nand2$ g3417(.in0 (n_16), .in1 (f_curr_st[1]), .out (n_17));
  or2$ g3418(.in0 (n_16), .in1 (f_curr_st[1]), .out (n_15));
  nand2$ g3420(.in0 (ic_hit), .in1 (n_14), .out (n_41));
  nand3$ g3421(.in0 (n_12), .in1 (n_30), .in2 (f_curr_st[2]), .out
       (n_13));
  nand4$ g3422(.in0 (r_V_de), .in1 (n_10), .in2 (n_28), .in3 (n_12),
       .out (n_11));
  inv1$ g3424(.in (n_8), .out (n_9));
  nor2$ g3412(.in0 (n_30), .in1 (n_20), .out (n_7));
  nand2$ g3413(.in0 (n_3), .in1 (f_curr_st[2]), .out (n_6));
  or2$ g3414(.in0 (n_16), .in1 (n_12), .out (n_5));
  nor4$ g3423(.in0 (dc_exp), .in1 (ic_exp), .in2 (int), .in3
       (de_br_stall), .out (n_48));
  nor2$ g3425(.in0 (n_0), .in1 (de_p), .out (n_8));
  inv1$ g3429(.in (n_20), .out (n_4));
  nor2$ g3431(.in0 (n_28), .in1 (n_30), .out (n_24));
  or2$ g3426(.in0 (f_curr_st[0]), .in1 (f_curr_st[2]), .out (n_16));
  nand2$ g3427(.in0 (de_p), .in1 (r_V_de), .out (n_3));
  or2$ g3432(.in0 (ic_hit), .in1 (f_curr_st[2]), .out (n_2));
  nand2$ g3430(.in0 (f_curr_st[2]), .in1 (f_curr_st[1]), .out (n_20));
  nor2$ g3428(.in0 (f_curr_st[2]), .in1 (f_curr_st[1]), .out (n_14));
  inv1$ g3438(.in (ic_hit), .out (n_28));
  inv1$ g3433(.in (f_curr_st[0]), .out (n_30));
  inv1$ g3434(.in (f_curr_st[1]), .out (n_12));
  inv1$ g3437(.in (eip_4), .out (n_1));
  inv1$ g3436(.in (r_V_de), .out (n_0));
  inv1$ g3435(.in (de_p), .out (n_10));
endmodule
