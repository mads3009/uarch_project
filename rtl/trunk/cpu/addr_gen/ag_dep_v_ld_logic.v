module ag_dep_v_ld_logic(
  input      V_ag         ,
  input      eip_change   ,
  input[2:0] in1          ,
  input[2:0] in2          ,
  input      in1_needed   ,
  input      in2_needed   ,
  input[2:0] seg1         ,
  input[2:0] seg2         ,
  input      seg1_needed  ,
  input      seg2_needed  ,
  input      esp_needed   ,
  input[2:0] ro_dreg1     ,
  input[2:0] ro_dreg2     ,
  input[2:0] ro_dreg3     ,
  input      v_ro_ld_reg1 ,
  input      v_ro_ld_reg2 ,
  input      v_ro_ld_reg3 ,
  input[2:0] ex_dreg1     ,
  input[2:0] ex_dreg2     ,
  input[2:0] ex_dreg3     ,
  input      v_ex_ld_reg1 ,
  input      v_ex_ld_reg2 ,
  input      v_ex_ld_reg3 ,
  input[2:0] wb_dreg1     ,
  input[2:0] wb_dreg2     ,
  input[2:0] wb_dreg3     ,
  input      v_wb_ld_reg1 ,
  input      v_wb_ld_reg2 ,
  input      v_wb_ld_reg3 ,
  input[2:0] ro_dseg      ,
  input      v_ro_ld_seg  ,
  input[2:0] ex_dseg      ,
  input      v_ex_ld_seg  ,
  input[2:0] wb_dseg      ,
  input      v_wb_ld_seg  ,
  input      stall_ro     ,
  input      ro_dep_stall ,
  input      ro_cmps_stall,
  input      mem_rd_busy  ,
  input      dc_exp       ,

  input      ld_reg1      ,
  input      ld_reg2      ,
  input      ld_reg3      ,
  input      ld_flag_ZF   ,
  output     v_ag_ld_reg1 ,
  output     v_ag_ld_reg2 ,
  output     v_ag_ld_reg3 ,
  output     v_ag_ld_flag_ZF,

  output     dep_stall    ,
  output     br_stall     ,
  output     stall_ag     ,
  output     V_ro         ,
  output     ld_ro        
);

assign v_ag_ld_reg1 = ld_reg1 && V_ag;
assign v_ag_ld_reg2 = ld_reg2 && V_ag;
assign v_ag_ld_reg3 = ld_reg3 && V_ag;
assign v_ag_ld_flag_ZF = ld_flag_ZF && V_ag;

assign br_stall = eip_change && V_ag;

assign stall_ag = stall_ro || ro_dep_stall || ro_cmps_stall;

assign ld_ro = !stall_ag || dc_exp;

assign V_ro = V_ag & !(dep_stall || dc_exp);
assign dep_stall = (( in1_needed &&(((in1 == ro_dreg1) && v_ro_ld_reg1) ||
                                      ((in1 == ro_dreg2) && v_ro_ld_reg2) ||
                                      ((in1 == ro_dreg3) && v_ro_ld_reg3) ||
                                      ((in1 == ex_dreg1) && v_ex_ld_reg1) ||
                                      ((in1 == ex_dreg2) && v_ex_ld_reg2) ||
                                      ((in1 == ex_dreg3) && v_ex_ld_reg3) ||
                                      ((in1 == wb_dreg1) && v_wb_ld_reg1) ||
                                      ((in1 == wb_dreg2) && v_wb_ld_reg2) ||
                                      ((in1 == wb_dreg3) && v_wb_ld_reg3)))   ||
                      ( in2_needed &&(((in2 == ro_dreg1) && v_ro_ld_reg1) ||
                                      ((in2 == ro_dreg2) && v_ro_ld_reg2) ||
                                      ((in2 == ro_dreg3) && v_ro_ld_reg3) ||
                                      ((in2 == ex_dreg1) && v_ex_ld_reg1) ||
                                      ((in2 == ex_dreg2) && v_ex_ld_reg2) ||
                                      ((in2 == ex_dreg3) && v_ex_ld_reg3) ||
                                      ((in2 == wb_dreg1) && v_wb_ld_reg1) ||
                                      ((in2 == wb_dreg2) && v_wb_ld_reg2) ||
                                      ((in2 == wb_dreg3) && v_wb_ld_reg3)))   ||
                      ( esp_needed &&(((3'h4 == ro_dreg1) && v_ro_ld_reg1) ||
                                      ((3'h4 == ro_dreg2) && v_ro_ld_reg2) ||
                                      ((3'h4 == ro_dreg3) && v_ro_ld_reg3) ||
                                      ((3'h4 == ex_dreg1) && v_ex_ld_reg1) ||
                                      ((3'h4 == ex_dreg2) && v_ex_ld_reg2) ||
                                      ((3'h4 == ex_dreg3) && v_ex_ld_reg3) ||
                                      ((3'h4 == wb_dreg1) && v_wb_ld_reg1) ||
                                      ((3'h4 == wb_dreg2) && v_wb_ld_reg2) ||
                                      ((3'h4 == wb_dreg3) && v_wb_ld_reg3)))   ||
                      ( seg1_needed&&(((seg1 == ro_dseg) && v_ro_ld_seg) ||
                                      ((seg1 == ex_dseg) && v_ex_ld_seg) ||
                                      ((seg1 == wb_dseg) && v_wb_ld_seg)))   ||
                      ( seg2_needed&&(((seg2 == ro_dseg) && v_ro_ld_seg) ||
                                      ((seg2 == ex_dseg) && v_ex_ld_seg) ||
                                      ((seg2 == wb_dseg) && v_wb_ld_seg)))  ) && V_ag;


endmodule
