module writeback_loads_gen (
  input       V_wb             ,
  input       CF_expected      ,
  input       cond_wr_CF       ,
  input       CF_flag          ,
  input       cxchg_op         ,
  input       ZF_new           ,
  input       ld_mem           ,
  input       ld_seg           ,
  input       ld_mm            ,
  input       ld_reg1          ,
  input       ld_reg2          ,
  input       ld_reg3          ,
  input[3:0]  ld_reg1_strb     ,
  input[3:0]  ld_reg2_strb     ,
  input[3:0]  ld_reg3_strb     ,
  input       ld_flag_ZF,
  input       ld_flag_AF,
  input       ld_flag_DF,
  input       ld_flag_CF,
  input       eip_change,
                 
  output      br_stall,
  output[3:0] v_wb_ld_reg1_strb,
  output[3:0] v_wb_ld_reg2_strb,
  output[3:0] v_wb_ld_reg3_strb,
  output      v_wb_ld_reg1     ,
  output      v_wb_ld_reg2     ,
  output      v_wb_ld_reg3     ,
  output      v_wb_ld_mm       ,
  output      v_wb_ld_seg      ,
  output      v_wb_ld_mem,     
  output      v_wb_ld_flag_ZF,
  output      v_wb_ld_flag_AF,
  output      v_wb_ld_flag_DF,
  output      v_wb_ld_flag_CF
);

assign br_stall = eip_change & V_wb;

assign v_wb_ld_reg1 = V_wb & ld_reg1 & ((~cxchg_op) || ZF_new) & ((~cond_wr_CF) || (CF_flag==CF_expected));
assign v_wb_ld_reg2 = V_wb & ld_reg2 & ((~cxchg_op) || (~ZF_new)) & ((~cond_wr_CF) || (CF_flag==CF_expected));
assign v_wb_ld_reg3 = V_wb & ld_reg3;
 
genvar i;
generate begin
  for (i=0;i<4;i=i+1) begin : loop1
    assign v_wb_ld_reg1_strb[i] = V_wb & ld_reg1_strb[i] & ((~cxchg_op) || ZF_new) & ((~cond_wr_CF) || (CF_flag==CF_expected));
  end
end
endgenerate

generate begin
  for (i=0;i<4;i=i+1) begin : loop2
    assign v_wb_ld_reg2_strb[i] = V_wb & ld_reg2_strb[i] & ((~cxchg_op) || ZF_new) & ((~cond_wr_CF) || (CF_flag==CF_expected));
  end
end
endgenerate

generate begin
  for (i=0;i<4;i=i+1) begin : loop3
    assign v_wb_ld_reg3_strb[i] = V_wb & ld_reg3_strb[i]; 
  end
end
endgenerate

assign v_wb_ld_mm = V_wb & ld_mm;
assign v_wb_ld_seg = V_wb & ld_seg;

assign v_wb_ld_mem = V_wb & ld_mem & ((~cxchg_op) || ZF_new);

assign  v_wb_ld_flag_ZF = ld_flag_ZF & V_wb;
assign  v_wb_ld_flag_AF = ld_flag_AF & V_wb;
assign  v_wb_ld_flag_DF = ld_flag_DF & V_wb;
assign  v_wb_ld_flag_CF = ld_flag_CF & V_wb;

endmodule
