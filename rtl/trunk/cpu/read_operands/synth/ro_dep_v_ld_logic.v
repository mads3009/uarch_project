module ro_dep_v_ld_logic(

  input       V_ro            ,
  input       eip_change      ,
  input[2:0]  in3             ,
  input[2:0]  in4             ,
  input       in3_needed      ,
  input       in4_needed      ,
  input[2:0]  seg3            ,
  input       seg3_needed     ,
  input       eax_needed      ,
  input       ecx_needed      ,
  input[2:0]  wb_dreg1        ,
  input[2:0]  wb_dreg2        ,
  input[2:0]  wb_dreg3        ,
  input       v_wb_ld_reg1    ,
  input       v_wb_ld_reg2    ,
  input       v_wb_ld_reg3    ,
  input[2:0]  mm1             ,
  input[2:0]  mm2             ,
  input       mm1_needed      ,
  input       mm2_needed      ,
  input[2:0]  wb_dmm          ,
  input       v_wb_ld_mm      ,
  input[2:0]  wb_dseg         ,
  input       v_wb_ld_seg     ,
  input       wb_mem_stall    ,
  input       mem_rd_busy     ,
  input       cmps_stall      ,
  input       dc_exp          ,

  input       ld_reg1         ,
  input       ld_reg2         ,
  input       ld_reg3         ,
  input       ld_flag_ZF      ,
  input       ld_seg          ,
  output      v_ro_ld_reg1    ,
  output      v_ro_ld_reg2    ,
  output      v_ro_ld_reg3    ,
  output      v_ro_ld_flag_ZF ,
  output      v_ro_ld_seg     ,

  output      dep_stall       ,
  output      br_stall        ,
  output      stall_ro        ,
  output      V_ex            ,
  output      ld_ex           
);

assign v_ro_ld_reg1 = ld_reg1 & V_ro;
assign v_ro_ld_reg2 = ld_reg2 & V_ro;
assign v_ro_ld_reg3 = ld_reg3 & V_ro;
assign v_ro_ld_seg = ld_seg & V_ro;
assign v_ro_ld_flag_ZF = ld_flag_ZF & V_ro;

assign br_stall = V_ro & eip_change;
assign stall_ro = wb_mem_stall;

assign ld_ex = !(stall_ro);

/*
  or3$ u_or_1 (.out(n10001), .in0(cmps_stall), .in1(dc_exp), .in2(dep_stall));
  nor2$ u_nor2_1(.out(n10002), .in0(n10001), .in1(mem_rd_busy));
  and2$ u_and2_1(.out(V_ex), .in0(n10002), .in1(V_ro));
*/

assign V_ex = V_ro && !(dep_stall || cmps_stall || mem_rd_busy || dc_exp);

assign dep_stall = (( in3_needed&&(((in3 == wb_dreg1) && v_wb_ld_reg1) ||
                                      ((in3 == wb_dreg2) && v_wb_ld_reg2) ||
                                      ((in3 == wb_dreg3) && v_wb_ld_reg3)))   ||
                      ( in4_needed &&(((in4 == wb_dreg1) && v_wb_ld_reg1) ||
                                      ((in4 == wb_dreg2) && v_wb_ld_reg2) ||
                                      ((in4 == wb_dreg3) && v_wb_ld_reg3)))   ||
                      ( eax_needed &&(((3'h0 == wb_dreg1) && v_wb_ld_reg1) ||
                                      ((3'h0 == wb_dreg2) && v_wb_ld_reg2) ||
                                      ((3'h0 == wb_dreg3) && v_wb_ld_reg3)))   ||
                      ( ecx_needed &&(((3'h1 == wb_dreg1) && v_wb_ld_reg1) ||
                                      ((3'h1 == wb_dreg2) && v_wb_ld_reg2) ||
                                      ((3'h1 == wb_dreg3) && v_wb_ld_reg3)))   ||
                      ( mm1_needed &&((mm1 == wb_dmm) && v_wb_ld_mm)) ||
                      ( mm2_needed &&((mm2 == wb_dmm) && v_wb_ld_mm)) ||
                      ( seg3_needed&&((seg3 == wb_dseg) && v_wb_ld_seg)) ) && V_ro;

endmodule
