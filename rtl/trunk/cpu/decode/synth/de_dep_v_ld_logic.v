module de_dep_v_ld_logic(
  input      clk,
  input      rst_n,
  input      V_de           ,
  input      repne          ,
  input      hlt            ,
  input      iret           ,
  input      eip_change     ,
  input[31:0]ECX            ,
  input      ZF             ,
  input [2:0]ag_dreg1       ,
  input [2:0]ag_dreg2       ,
  input [2:0]ag_dreg3       ,
  input      v_ag_ld_reg1   ,
  input      v_ag_ld_reg2   ,
  input      v_ag_ld_reg3   ,
  input      v_ag_ld_flag_ZF,
  input [2:0]ro_dreg1       ,
  input [2:0]ro_dreg2       ,
  input [2:0]ro_dreg3       ,
  input      v_ro_ld_reg1   ,
  input      v_ro_ld_reg2   ,
  input      v_ro_ld_reg3   ,
  input      v_ro_ld_flag_ZF,
  input [2:0]wb_dreg1       ,
  input [2:0]wb_dreg2       ,
  input [2:0]wb_dreg3       ,
  input      v_wb_ld_reg1   ,
  input      v_wb_ld_reg2   ,
  input      v_wb_ld_reg3   ,
  input      v_wb_ld_flag_ZF,
  input      stall_ag,
  input      ag_dep_stall,
  input      dc_exp,         

  output     hlt_stall,
  output     repne_stall,
  output     dep_stall,
  output     br_stall,
  output     iret_op,
  output     stall_de,
  output     V_ag,
  output     ld_ag,
  input      wb_mem_stall ,
  input      ro_dep_stall ,
  input      ro_cmps_stall,
  input      mem_rd_busy  
);

wire w_repne_stop;

assign br_stall = eip_change & V_de;
assign hlt_stall = hlt & V_de;
assign iret_op = iret & V_de; 

assign stall_de = wb_mem_stall || ro_dep_stall || ro_cmps_stall || mem_rd_busy || ag_dep_stall;
assign ld_ag = ~(stall_de) || dc_exp;

assign V_ag = ~(hlt || iret || dep_stall || w_repne_stop || dc_exp) & V_de;

//REPNE
wire w_repne_in0;
wire w_repne_in1;
wire w_repne_flag_regin;
wire r_repne_flag;

assign w_v_repne = repne && V_de;
assign w_repne_in0 = (|ECX) & w_v_repne;
assign w_repne_in1 = (|ECX) & ~(ZF);

assign w_repne_flag_regin = r_repne_flag ? w_repne_in1 : w_repne_in0;

dff$  u_reg(.r(rst_n),.s(1'b1),.clk(clk),.d(w_repne_flag_regin),.q(r_repne_flag),.qbar(/*Unused*/));

assign repne_stall = w_repne_flag_regin & V_de;

assign w_repne_stop = (w_v_repne & !(|ECX) & !r_repne_flag) ||
                      (r_repne_flag & (!(|ECX) || ZF));

//DEP STALL
assign dep_stall = (((v_ag_ld_reg1) && (ag_dreg1== 3'd1)) ||
                   ((v_ag_ld_reg2) && (ag_dreg2== 3'd1)) ||
                   ((v_ag_ld_reg3) && (ag_dreg3== 3'd1)) ||
                   ((v_ro_ld_reg1) && (ro_dreg1== 3'd1)) ||
                   ((v_ro_ld_reg2) && (ro_dreg2== 3'd1)) ||
                   ((v_ro_ld_reg3) && (ro_dreg3== 3'd1)) ||
                   ((v_wb_ld_reg1) && (wb_dreg1== 3'd1)) ||
                   ((v_wb_ld_reg2) && (wb_dreg2== 3'd1)) ||
                   ((v_wb_ld_reg3) && (wb_dreg3== 3'd1)) ||
                   ((v_ag_ld_flag_ZF || v_ro_ld_flag_ZF || v_wb_ld_flag_ZF) && r_repne_flag)) && V_de && repne;

endmodule
