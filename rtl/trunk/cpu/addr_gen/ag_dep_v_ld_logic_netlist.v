
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/ag_dep_v_ld_logic 

module ag_dep_v_ld_logic(V_ag, eip_change, in1, in2, in1_needed,
     in2_needed, seg1, seg2, seg1_needed, seg2_needed, esp_needed,
     ro_dreg1, ro_dreg2, ro_dreg3, v_ro_ld_reg1, v_ro_ld_reg2,
     v_ro_ld_reg3, wb_dreg1, wb_dreg2, wb_dreg3, v_wb_ld_reg1,
     v_wb_ld_reg2, v_wb_ld_reg3, ro_dseg, v_ro_ld_seg, wb_dseg,
     v_wb_ld_seg, stall_ro, ro_dep_stall, ro_cmps_stall, mem_rd_busy,
     dc_exp, ld_reg1, ld_reg2, ld_reg3, ld_flag_ZF, v_ag_ld_reg1,
     v_ag_ld_reg2, v_ag_ld_reg3, v_ag_ld_flag_ZF, dep_stall, br_stall,
     stall_ag, V_ro, ld_ro, wb_mem_stall);
  input V_ag, eip_change, in1_needed, in2_needed, seg1_needed,
       seg2_needed, esp_needed, v_ro_ld_reg1, v_ro_ld_reg2,
       v_ro_ld_reg3, v_wb_ld_reg1, v_wb_ld_reg2, v_wb_ld_reg3,
       v_ro_ld_seg, v_wb_ld_seg, stall_ro, ro_dep_stall, ro_cmps_stall,
       mem_rd_busy, dc_exp, ld_reg1, ld_reg2, ld_reg3, ld_flag_ZF,
       wb_mem_stall;
  input [2:0] in1, in2, seg1, seg2, ro_dreg1, ro_dreg2, ro_dreg3,
       wb_dreg1, wb_dreg2, wb_dreg3, ro_dseg, wb_dseg;
  output v_ag_ld_reg1, v_ag_ld_reg2, v_ag_ld_reg3, v_ag_ld_flag_ZF,
       dep_stall, br_stall, stall_ag, V_ro, ld_ro;
  wire V_ag, eip_change, in1_needed, in2_needed, seg1_needed,
       seg2_needed, esp_needed, v_ro_ld_reg1, v_ro_ld_reg2,
       v_ro_ld_reg3, v_wb_ld_reg1, v_wb_ld_reg2, v_wb_ld_reg3,
       v_ro_ld_seg, v_wb_ld_seg, stall_ro, ro_dep_stall, ro_cmps_stall,
       mem_rd_busy, dc_exp, ld_reg1, ld_reg2, ld_reg3, ld_flag_ZF,
       wb_mem_stall;
  wire [2:0] in1, in2, seg1, seg2, ro_dreg1, ro_dreg2, ro_dreg3,
       wb_dreg1, wb_dreg2, wb_dreg3, ro_dseg, wb_dseg;
  wire v_ag_ld_reg1, v_ag_ld_reg2, v_ag_ld_reg3, v_ag_ld_flag_ZF,
       dep_stall, br_stall, stall_ag, V_ro, ld_ro;
  wire n_0, n_1, n_2, n_3, n_4, n_5, n_6, n_7;
  wire n_8, n_9, n_10, n_11, n_12, n_13, n_14, n_16;
  wire n_17, n_22, n_23, n_24, n_25, n_26, n_27, n_28;
  wire n_29, n_30, n_31, n_32, n_33, n_34, n_35, n_36;
  wire n_37, n_38, n_39, n_40, n_41, n_42, n_43, n_44;
  wire n_45, n_46, n_47, n_48, n_49, n_50, n_51, n_52;
  wire n_53, n_54, n_55, n_56, n_57, n_58, n_59, n_60;
  wire n_61, n_62, n_63, n_64, n_65, n_66, n_67, n_68;
  wire n_69, n_70, n_71, n_72, n_73, n_74, n_75, n_76;
  wire n_77, n_78, n_79, n_80, n_81, n_82, n_83, n_84;
  wire n_85, n_86, n_87, n_88, n_89, n_90, n_91, n_92;
  wire n_93, n_94, n_95, n_98, n_99, n_100, n_101, n_102;
  wire n_103, n_104, n_105, n_106, n_107, n_108, n_109, n_110;
  wire n_111, n_112, n_113, n_114, n_115, n_116, n_117, n_118;
  wire n_120, n_122, n_123, n_187, n_188;
  nor2$ g10688(.in0 (n_188), .in1 (n_8), .out (dep_stall));
  nor3$ g10689(.in0 (n_123), .in1 (n_122), .in2 (n_26), .out (V_ro));
  nand3$ g10696(.in0 (n_116), .in1 (n_117), .in2 (n_113), .out (n_123));
  nand2$ g10691(.in0 (n_120), .in1 (n_118), .out (n_122));
  nand2$ g10695(.in0 (n_114), .in1 (in2_needed), .out (n_118));
  nand2$ g10693(.in0 (n_115), .in1 (in1_needed), .out (n_120));
  nand2$ g10699(.in0 (n_112), .in1 (seg2_needed), .out (n_117));
  nand2$ g10701(.in0 (n_111), .in1 (esp_needed), .out (n_116));
  nand3$ g10697(.in0 (n_105), .in1 (n_107), .in2 (n_104), .out (n_115));
  nand3$ g10698(.in0 (n_110), .in1 (n_102), .in2 (n_106), .out (n_114));
  nand2$ g10700(.in0 (n_103), .in1 (seg1_needed), .out (n_113));
  nand2$ g10708(.in0 (n_109), .in1 (n_108), .out (n_112));
  nand3$ g10710(.in0 (n_90), .in1 (n_87), .in2 (n_88), .out (n_111));
  nor2$ g10709(.in0 (n_91), .in1 (n_92), .out (n_110));
  nand4$ g10711(.in0 (n_27), .in1 (n_32), .in2 (n_81), .in3
       (v_ro_ld_seg), .out (n_109));
  nand4$ g10712(.in0 (n_29), .in1 (n_31), .in2 (n_82), .in3
       (v_wb_ld_seg), .out (n_108));
  nor2$ g10702(.in0 (n_89), .in1 (n_84), .out (n_107));
  nor2$ g10703(.in0 (n_86), .in1 (n_85), .out (n_106));
  nor2$ g10704(.in0 (n_83), .in1 (n_101), .out (n_105));
  nor2$ g10705(.in0 (n_100), .in1 (n_99), .out (n_104));
  nand2$ g10706(.in0 (n_98), .in1 (n_94), .out (n_103));
  nor2$ g10707(.in0 (n_95), .in1 (n_93), .out (n_102));
  and4$ g10719(.in0 (n_64), .in1 (n_65), .in2 (n_66), .in3
       (v_wb_ld_reg2), .out (n_101));
  and4$ g10720(.in0 (n_60), .in1 (n_61), .in2 (n_62), .in3
       (v_ro_ld_reg2), .out (n_100));
  and4$ g10721(.in0 (n_57), .in1 (n_58), .in2 (n_59), .in3
       (v_wb_ld_reg3), .out (n_99));
  nand4$ g10722(.in0 (n_53), .in1 (n_54), .in2 (n_56), .in3
       (v_ro_ld_seg), .out (n_98));
  nand2$ g10728(.in0 (stall_ag), .in1 (n_25), .out (ld_ro));
  and4$ g10723(.in0 (n_50), .in1 (n_51), .in2 (n_55), .in3
       (v_ro_ld_reg3), .out (n_95));
  nand4$ g10724(.in0 (n_52), .in1 (n_41), .in2 (n_44), .in3
       (v_wb_ld_seg), .out (n_94));
  and4$ g10725(.in0 (n_43), .in1 (n_46), .in2 (n_48), .in3
       (v_wb_ld_reg1), .out (n_93));
  and4$ g10713(.in0 (n_42), .in1 (n_45), .in2 (n_47), .in3
       (v_wb_ld_reg2), .out (n_92));
  and4$ g10726(.in0 (n_49), .in1 (n_39), .in2 (n_63), .in3
       (v_ro_ld_reg1), .out (n_91));
  nor2$ g10727(.in0 (n_80), .in1 (n_79), .out (n_90));
  and4$ g10714(.in0 (n_22), .in1 (n_23), .in2 (n_34), .in3
       (v_ro_ld_reg3), .out (n_89));
  nor2$ g10730(.in0 (n_78), .in1 (n_77), .out (n_88));
  nor2$ g10732(.in0 (n_76), .in1 (n_75), .out (n_87));
  and4$ g10715(.in0 (n_24), .in1 (n_30), .in2 (n_37), .in3
       (v_ro_ld_reg2), .out (n_86));
  and4$ g10716(.in0 (n_73), .in1 (n_74), .in2 (n_40), .in3
       (v_wb_ld_reg3), .out (n_85));
  and4$ g10717(.in0 (n_70), .in1 (n_71), .in2 (n_72), .in3
       (v_wb_ld_reg1), .out (n_84));
  and4$ g10718(.in0 (n_67), .in1 (n_68), .in2 (n_69), .in3
       (v_ro_ld_reg1), .out (n_83));
  nor2$ g10729(.in0 (n_38), .in1 (n_36), .out (n_82));
  nor2$ g10731(.in0 (n_35), .in1 (n_33), .out (n_81));
  nor4$ g10747(.in0 (ro_dreg1[1]), .in1 (n_1), .in2 (n_9), .in3
       (ro_dreg1[0]), .out (n_80));
  nand2$ g10748(.in0 (n_17), .in1 (n_16), .out (stall_ag));
  nor4$ g10750(.in0 (wb_dreg1[1]), .in1 (n_11), .in2 (n_12), .in3
       (wb_dreg1[0]), .out (n_79));
  nor4$ g10755(.in0 (wb_dreg2[1]), .in1 (n_7), .in2 (n_3), .in3
       (wb_dreg2[0]), .out (n_78));
  nor4$ g10757(.in0 (wb_dreg3[1]), .in1 (n_6), .in2 (n_4), .in3
       (wb_dreg3[0]), .out (n_77));
  nor4$ g10774(.in0 (ro_dreg2[1]), .in1 (n_5), .in2 (n_10), .in3
       (ro_dreg2[0]), .out (n_76));
  nor4$ g10779(.in0 (ro_dreg3[1]), .in1 (n_0), .in2 (n_14), .in3
       (ro_dreg3[0]), .out (n_75));
  xnor2$ g10745(.in0 (in2[2]), .in1 (wb_dreg3[2]), .out (n_74));
  xnor2$ g10746(.in0 (in2[0]), .in1 (wb_dreg3[0]), .out (n_73));
  xnor2$ g10749(.in0 (in1[0]), .in1 (wb_dreg1[0]), .out (n_72));
  xnor2$ g10751(.in0 (in1[2]), .in1 (wb_dreg1[2]), .out (n_71));
  xnor2$ g10752(.in0 (in1[1]), .in1 (wb_dreg1[1]), .out (n_70));
  xnor2$ g10753(.in0 (in1[0]), .in1 (ro_dreg1[0]), .out (n_69));
  xnor2$ g10754(.in0 (in1[2]), .in1 (ro_dreg1[2]), .out (n_68));
  xnor2$ g10756(.in0 (in1[1]), .in1 (ro_dreg1[1]), .out (n_67));
  xnor2$ g10758(.in0 (in1[0]), .in1 (wb_dreg2[0]), .out (n_66));
  xnor2$ g10759(.in0 (in1[2]), .in1 (wb_dreg2[2]), .out (n_65));
  xnor2$ g10760(.in0 (in1[1]), .in1 (wb_dreg2[1]), .out (n_64));
  xnor2$ g10761(.in0 (in2[1]), .in1 (ro_dreg1[1]), .out (n_63));
  xnor2$ g10762(.in0 (in1[0]), .in1 (ro_dreg2[0]), .out (n_62));
  xnor2$ g10763(.in0 (in1[2]), .in1 (ro_dreg2[2]), .out (n_61));
  xnor2$ g10764(.in0 (in1[1]), .in1 (ro_dreg2[1]), .out (n_60));
  xnor2$ g10765(.in0 (in1[1]), .in1 (wb_dreg3[1]), .out (n_59));
  xnor2$ g10766(.in0 (in1[2]), .in1 (wb_dreg3[2]), .out (n_58));
  xnor2$ g10767(.in0 (in1[0]), .in1 (wb_dreg3[0]), .out (n_57));
  xnor2$ g10768(.in0 (seg1[0]), .in1 (ro_dseg[0]), .out (n_56));
  xnor2$ g10769(.in0 (in2[0]), .in1 (ro_dreg3[0]), .out (n_55));
  xnor2$ g10770(.in0 (seg1[2]), .in1 (ro_dseg[2]), .out (n_54));
  xnor2$ g10771(.in0 (seg1[1]), .in1 (ro_dseg[1]), .out (n_53));
  xnor2$ g10733(.in0 (seg1[1]), .in1 (wb_dseg[1]), .out (n_52));
  xnor2$ g10772(.in0 (in2[2]), .in1 (ro_dreg3[2]), .out (n_51));
  xnor2$ g10773(.in0 (in2[1]), .in1 (ro_dreg3[1]), .out (n_50));
  xnor2$ g10734(.in0 (in2[0]), .in1 (ro_dreg1[0]), .out (n_49));
  xnor2$ g10775(.in0 (in2[1]), .in1 (wb_dreg1[1]), .out (n_48));
  xnor2$ g10735(.in0 (in2[2]), .in1 (wb_dreg2[2]), .out (n_47));
  xnor2$ g10776(.in0 (in2[2]), .in1 (wb_dreg1[2]), .out (n_46));
  xnor2$ g10736(.in0 (in2[1]), .in1 (wb_dreg2[1]), .out (n_45));
  xnor2$ g10777(.in0 (seg1[0]), .in1 (wb_dseg[0]), .out (n_44));
  xnor2$ g10778(.in0 (in2[0]), .in1 (wb_dreg1[0]), .out (n_43));
  xnor2$ g10737(.in0 (in2[0]), .in1 (wb_dreg2[0]), .out (n_42));
  xnor2$ g10780(.in0 (seg1[2]), .in1 (wb_dseg[2]), .out (n_41));
  xnor2$ g10738(.in0 (in2[1]), .in1 (wb_dreg3[1]), .out (n_40));
  xnor2$ g10781(.in0 (in2[2]), .in1 (ro_dreg1[2]), .out (n_39));
  xor2$ g10782(.in0 (seg2[2]), .in1 (wb_dseg[2]), .out (n_38));
  xnor2$ g10739(.in0 (in2[1]), .in1 (ro_dreg2[1]), .out (n_37));
  xor2$ g10783(.in0 (seg2[0]), .in1 (wb_dseg[0]), .out (n_36));
  xor2$ g10784(.in0 (seg2[2]), .in1 (ro_dseg[2]), .out (n_35));
  xnor2$ g10740(.in0 (in1[0]), .in1 (ro_dreg3[0]), .out (n_34));
  xor2$ g10785(.in0 (seg2[0]), .in1 (ro_dseg[0]), .out (n_33));
  nand2$ g10786(.in0 (n_28), .in1 (ro_dseg[1]), .out (n_32));
  nand2$ g10787(.in0 (n_2), .in1 (seg2[1]), .out (n_31));
  xnor2$ g10741(.in0 (in2[2]), .in1 (ro_dreg2[2]), .out (n_30));
  nand2$ g10788(.in0 (n_28), .in1 (wb_dseg[1]), .out (n_29));
  nand2$ g10789(.in0 (n_13), .in1 (seg2[1]), .out (n_27));
  nand2$ g10790(.in0 (n_25), .in1 (V_ag), .out (n_26));
  xnor2$ g10742(.in0 (in2[0]), .in1 (ro_dreg2[0]), .out (n_24));
  xnor2$ g10743(.in0 (in1[2]), .in1 (ro_dreg3[2]), .out (n_23));
  xnor2$ g10744(.in0 (in1[1]), .in1 (ro_dreg3[1]), .out (n_22));
  and2$ g10796(.in0 (V_ag), .in1 (ld_reg2), .out (v_ag_ld_reg2));
  and2$ g10791(.in0 (V_ag), .in1 (eip_change), .out (br_stall));
  and2$ g10792(.in0 (V_ag), .in1 (ld_reg1), .out (v_ag_ld_reg1));
  and2$ g10795(.in0 (V_ag), .in1 (ld_flag_ZF), .out (v_ag_ld_flag_ZF));
  nor2$ g10797(.in0 (ro_cmps_stall), .in1 (mem_rd_busy), .out (n_17));
  nor2$ g10793(.in0 (ro_dep_stall), .in1 (wb_mem_stall), .out (n_16));
  and2$ g10794(.in0 (V_ag), .in1 (ld_reg3), .out (v_ag_ld_reg3));
  inv1$ g10811(.in (ro_dreg3[2]), .out (n_14));
  inv1$ g10810(.in (seg2[1]), .out (n_28));
  inv1$ g10814(.in (ro_dseg[1]), .out (n_13));
  inv1$ g10802(.in (wb_dreg1[2]), .out (n_12));
  inv1$ g10799(.in (v_wb_ld_reg1), .out (n_11));
  inv1$ g10798(.in (ro_dreg2[2]), .out (n_10));
  inv1$ g10813(.in (ro_dreg1[2]), .out (n_9));
  inv1$ g10800(.in (V_ag), .out (n_8));
  inv1$ g10801(.in (v_wb_ld_reg2), .out (n_7));
  inv1$ g10809(.in (v_wb_ld_reg3), .out (n_6));
  inv1$ g10808(.in (v_ro_ld_reg2), .out (n_5));
  inv1$ g10807(.in (dc_exp), .out (n_25));
  inv1$ g10804(.in (wb_dreg3[2]), .out (n_4));
  inv1$ g10805(.in (wb_dreg2[2]), .out (n_3));
  inv1$ g10812(.in (wb_dseg[1]), .out (n_2));
  inv1$ g10806(.in (v_ro_ld_reg1), .out (n_1));
  inv1$ g10803(.in (v_ro_ld_reg3), .out (n_0));
  nor2$ g2(.in0 (n_187), .in1 (n_123), .out (n_188));
  nand2$ g3(.in0 (n_118), .in1 (n_120), .out (n_187));
endmodule

