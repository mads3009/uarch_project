module ex_dep_v_ld_logic(
  input      V_ex           ,
  input      eip_change     ,
  input      AF_needed      ,
  input      DF_needed      ,
  input      CF_needed      ,
  input      v_wb_ld_flag_AF,
  input      v_wb_ld_flag_DF,
  input      v_wb_ld_flag_CF,
  input      wb_mem_stall   ,
  
  input      ld_reg1        ,
  input      ld_reg2        ,
  input      ld_reg3        ,
  input      ld_flag_ZF     ,
  input      ld_seg         ,
  input      ld_mm          ,
  input      ld_mem         ,
  output     v_ro_ld_reg1   ,
  output     v_ro_ld_reg2   ,
  output     v_ro_ld_reg3   ,
  output     v_ro_ld_flag_ZF,
  output     v_ro_ld_seg    ,
  output     v_ro_ld_mm     ,
  output     v_ro_ld_mem    ,

  output     dep_stall      ,
  output     br_stall       ,
  output     V_wb           ,
  output     ld_wb          
);

assign v_ro_ld_reg1   = V_ex & ld_reg1   ;
assign v_ro_ld_reg2   = V_ex & ld_reg2   ;
assign v_ro_ld_reg3   = V_ex & ld_reg3   ;
assign v_ro_ld_flag_ZF= V_ex & ld_flag_ZF;
assign v_ro_ld_seg    = V_ex & ld_seg    ;
assign v_ro_ld_mm     = V_ex & ld_mm     ;
assign v_ro_ld_mem    = V_ex & ld_mem    ;

assign dep_stall = V_ex & ( (AF_needed && v_wb_ld_flag_AF) ||
                            (CF_needed && v_wb_ld_flag_CF) ||
                            (DF_needed && v_wb_ld_flag_DF) );

assign br_stall = V_ex & eip_change;

assign V_wb = V_ex & !dep_stall;

assign ld_wb = !(wb_mem_stall);

endmodule
