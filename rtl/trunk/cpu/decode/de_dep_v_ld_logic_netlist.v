
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/de_dep_v_ld_logic 

module de_dep_v_ld_logic(clk, rst_n, V_de, repne, hlt, iret,
     eip_change, ECX, ZF, ag_dreg1, ag_dreg2, ag_dreg3, v_ag_ld_reg1,
     v_ag_ld_reg2, v_ag_ld_reg3, v_ag_ld_flag_ZF, ro_dreg1, ro_dreg2,
     ro_dreg3, v_ro_ld_reg1, v_ro_ld_reg2, v_ro_ld_reg3,
     v_ro_ld_flag_ZF, wb_dreg1, wb_dreg2, wb_dreg3, v_wb_ld_reg1,
     v_wb_ld_reg2, v_wb_ld_reg3, v_wb_ld_flag_ZF, stall_ag,
     ag_dep_stall, dc_exp, int, hlt_stall, repne_stall, dep_stall,
     br_stall, iret_op, stall_de, V_ag, ld_ag, wb_mem_stall,
     ro_dep_stall, ro_cmps_stall, mem_rd_busy);
  input clk, rst_n, V_de, repne, hlt, iret, eip_change, ZF,
       v_ag_ld_reg1, v_ag_ld_reg2, v_ag_ld_reg3, v_ag_ld_flag_ZF,
       v_ro_ld_reg1, v_ro_ld_reg2, v_ro_ld_reg3, v_ro_ld_flag_ZF,
       v_wb_ld_reg1, v_wb_ld_reg2, v_wb_ld_reg3, v_wb_ld_flag_ZF,
       stall_ag, ag_dep_stall, dc_exp, int, wb_mem_stall, ro_dep_stall,
       ro_cmps_stall, mem_rd_busy;
  input [31:0] ECX;
  input [2:0] ag_dreg1, ag_dreg2, ag_dreg3, ro_dreg1, ro_dreg2,
       ro_dreg3, wb_dreg1, wb_dreg2, wb_dreg3;
  output hlt_stall, repne_stall, dep_stall, br_stall, iret_op,
       stall_de, V_ag, ld_ag;
  wire clk, rst_n, V_de, repne, hlt, iret, eip_change, ZF,
       v_ag_ld_reg1, v_ag_ld_reg2, v_ag_ld_reg3, v_ag_ld_flag_ZF,
       v_ro_ld_reg1, v_ro_ld_reg2, v_ro_ld_reg3, v_ro_ld_flag_ZF,
       v_wb_ld_reg1, v_wb_ld_reg2, v_wb_ld_reg3, v_wb_ld_flag_ZF,
       stall_ag, ag_dep_stall, dc_exp, int, wb_mem_stall, ro_dep_stall,
       ro_cmps_stall, mem_rd_busy;
  wire [31:0] ECX;
  wire [2:0] ag_dreg1, ag_dreg2, ag_dreg3, ro_dreg1, ro_dreg2,
       ro_dreg3, wb_dreg1, wb_dreg2, wb_dreg3;
  wire hlt_stall, repne_stall, dep_stall, br_stall, iret_op, stall_de,
       V_ag, ld_ag;
  wire UNCONNECTED, n_1, n_2, n_3, n_4, n_5, n_6, n_7;
  wire n_8, n_9, n_10, n_11, n_12, n_13, n_14, n_15;
  wire n_17, n_18, n_19, n_20, n_22, n_23, n_24, n_25;
  wire n_26, n_28, n_29, n_30, n_31, n_32, n_33, n_34;
  wire n_35, n_36, n_37, n_38, n_39, n_40, n_41, n_42;
  wire n_43, n_44, n_45, n_46, n_47, n_48, n_49, n_50;
  wire n_51, n_52, n_53, n_56, n_57, n_58, n_59, n_60;
  wire n_61, n_62, n_63, n_64, n_66, r_repne_flag;
  nor3$ g6257(.in0 (n_66), .in1 (dep_stall), .in2 (n_39), .out (V_ag));
  dff$ u_reg(.r (rst_n), .s (1'b1), .clk (clk), .d (n_63), .q
       (r_repne_flag), .qbar (UNCONNECTED));
  nor2$ g6260(.in0 (n_64), .in1 (n_36), .out (dep_stall));
  nor2$ g6261(.in0 (n_59), .in1 (n_28), .out (n_66));
  nor4$ g6259(.in0 (n_60), .in1 (n_62), .in2 (n_61), .in3 (n_38), .out
       (repne_stall));
  nor3$ g6264(.in0 (n_57), .in1 (n_58), .in2 (n_56), .out (n_64));
  nor3$ g6262(.in0 (n_62), .in1 (n_61), .in2 (n_60), .out (n_63));
  nor2$ g6263(.in0 (n_61), .in1 (n_60), .out (n_59));
  nand4$ g6268(.in0 (n_50), .in1 (n_51), .in2 (n_53), .in3 (n_49), .out
       (n_58));
  nand4$ g6269(.in0 (n_44), .in1 (n_45), .in2 (n_46), .in3 (n_42), .out
       (n_57));
  nor4$ g6265(.in0 (n_48), .in1 (n_40), .in2 (n_43), .in3 (n_47), .out
       (n_61));
  nand2$ g6267(.in0 (n_41), .in1 (n_52), .out (n_56));
  nand2$ g6266(.in0 (stall_de), .in1 (n_1), .out (ld_ag));
  nand2$ g6273(.in0 (n_37), .in1 (n_2), .out (n_62));
  nand3$ g6285(.in0 (ag_dreg1[0]), .in1 (n_12), .in2 (v_ag_ld_reg1),
       .out (n_53));
  nand2$ g6272(.in0 (n_34), .in1 (r_repne_flag), .out (n_52));
  nand3$ g6286(.in0 (ag_dreg3[0]), .in1 (n_9), .in2 (v_ag_ld_reg3),
       .out (n_51));
  nand3$ g6287(.in0 (ro_dreg1[0]), .in1 (n_6), .in2 (v_ro_ld_reg1),
       .out (n_50));
  nand3$ g6288(.in0 (ro_dreg2[0]), .in1 (n_5), .in2 (v_ro_ld_reg2),
       .out (n_49));
  nand4$ g6274(.in0 (n_7), .in1 (n_10), .in2 (n_13), .in3 (n_4), .out
       (n_48));
  nand4$ g6275(.in0 (n_23), .in1 (n_30), .in2 (n_33), .in3 (n_24), .out
       (n_47));
  nand2$ g6276(.in0 (n_35), .in1 (n_19), .out (stall_de));
  nand3$ g6278(.in0 (ro_dreg3[0]), .in1 (n_32), .in2 (v_ro_ld_reg3),
       .out (n_46));
  nand3$ g6279(.in0 (wb_dreg2[0]), .in1 (n_29), .in2 (v_wb_ld_reg2),
       .out (n_45));
  nand3$ g6280(.in0 (ag_dreg2[0]), .in1 (n_26), .in2 (v_ag_ld_reg2),
       .out (n_44));
  nand4$ g6270(.in0 (n_11), .in1 (n_14), .in2 (n_20), .in3 (n_8), .out
       (n_43));
  nand3$ g6281(.in0 (wb_dreg3[0]), .in1 (n_22), .in2 (v_wb_ld_reg3),
       .out (n_42));
  nand3$ g6282(.in0 (wb_dreg1[0]), .in1 (n_17), .in2 (v_wb_ld_reg1),
       .out (n_41));
  nand4$ g6271(.in0 (n_18), .in1 (n_25), .in2 (n_31), .in3 (n_15), .out
       (n_40));
  or4$ g6289(.in0 (hlt), .in1 (dc_exp), .in2 (n_38), .in3 (iret), .out
       (n_39));
  nand2$ g6277(.in0 (n_3), .in1 (n_36), .out (n_37));
  nor3$ g6283(.in0 (wb_mem_stall), .in1 (ro_cmps_stall), .in2
       (mem_rd_busy), .out (n_35));
  or3$ g6284(.in0 (v_ag_ld_flag_ZF), .in1 (v_wb_ld_flag_ZF), .in2
       (v_ro_ld_flag_ZF), .out (n_34));
  nor2$ g6290(.in0 (ECX[7]), .in1 (ECX[6]), .out (n_33));
  nor2$ g6291(.in0 (ro_dreg3[2]), .in1 (ro_dreg3[1]), .out (n_32));
  nor2$ g6292(.in0 (ECX[23]), .in1 (ECX[22]), .out (n_31));
  nor2$ g6293(.in0 (ECX[5]), .in1 (ECX[4]), .out (n_30));
  nor2$ g6294(.in0 (wb_dreg2[2]), .in1 (wb_dreg2[1]), .out (n_29));
  nor2$ g6295(.in0 (r_repne_flag), .in1 (repne), .out (n_28));
  and2$ g6319(.in0 (V_de), .in1 (iret), .out (iret_op));
  nor2$ g6297(.in0 (ag_dreg2[2]), .in1 (ag_dreg2[1]), .out (n_26));
  nor2$ g6298(.in0 (ECX[21]), .in1 (ECX[20]), .out (n_25));
  nor2$ g6299(.in0 (ECX[1]), .in1 (ECX[0]), .out (n_24));
  nor2$ g6296(.in0 (ECX[3]), .in1 (ECX[2]), .out (n_23));
  nor2$ g6300(.in0 (wb_dreg3[2]), .in1 (wb_dreg3[1]), .out (n_22));
  and2$ g6303(.in0 (V_de), .in1 (hlt), .out (hlt_stall));
  nor2$ g6302(.in0 (ECX[31]), .in1 (ECX[30]), .out (n_20));
  nand2$ g6304(.in0 (V_de), .in1 (repne), .out (n_36));
  nor2$ g6305(.in0 (ag_dep_stall), .in1 (ro_dep_stall), .out (n_19));
  nor2$ g6306(.in0 (ECX[19]), .in1 (ECX[18]), .out (n_18));
  nor2$ g6307(.in0 (wb_dreg1[2]), .in1 (wb_dreg1[1]), .out (n_17));
  and2$ g6301(.in0 (V_de), .in1 (eip_change), .out (br_stall));
  nor2$ g6308(.in0 (ECX[17]), .in1 (ECX[16]), .out (n_15));
  nor2$ g6309(.in0 (ECX[29]), .in1 (ECX[28]), .out (n_14));
  nor2$ g6310(.in0 (ECX[15]), .in1 (ECX[14]), .out (n_13));
  nor2$ g6311(.in0 (ag_dreg1[2]), .in1 (ag_dreg1[1]), .out (n_12));
  and2$ g6312(.in0 (r_repne_flag), .in1 (ZF), .out (n_60));
  nor2$ g6313(.in0 (ECX[27]), .in1 (ECX[26]), .out (n_11));
  nor2$ g6314(.in0 (ECX[13]), .in1 (ECX[12]), .out (n_10));
  nor2$ g6315(.in0 (ag_dreg3[2]), .in1 (ag_dreg3[1]), .out (n_9));
  nor2$ g6316(.in0 (ECX[25]), .in1 (ECX[24]), .out (n_8));
  nor2$ g6317(.in0 (ECX[11]), .in1 (ECX[10]), .out (n_7));
  nor2$ g6318(.in0 (ro_dreg1[2]), .in1 (ro_dreg1[1]), .out (n_6));
  nor2$ g6320(.in0 (ro_dreg2[2]), .in1 (ro_dreg2[1]), .out (n_5));
  nor2$ g6321(.in0 (ECX[9]), .in1 (ECX[8]), .out (n_4));
  inv1$ g6322(.in (r_repne_flag), .out (n_3));
  inv1$ g6324(.in (int), .out (n_2));
  inv1$ g6325(.in (V_de), .out (n_38));
  inv1$ g6323(.in (dc_exp), .out (n_1));
endmodule

