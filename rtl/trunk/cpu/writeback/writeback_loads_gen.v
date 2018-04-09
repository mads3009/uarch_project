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
                 
  output[3:0] v_wb_ld_reg1_strb,
  output[3:0] v_wb_ld_reg2_strb,
  output[3:0] v_wb_ld_reg3_strb,
  output      v_wb_ld_reg1     ,
  output      v_wb_ld_reg2     ,
  output      v_wb_ld_reg3     ,
  output      v_wb_ld_mm       ,
  output      v_wb_ld_seg      ,
  output      v_wb_ld_mem      
);

assign v_wb_ld_reg1 = V_wb & ld_reg1 & ((~cxchg_op) || ZF_new) & ((~cond_wr_CF) || (CF_flag==CF_expected));
assign v_wb_ld_reg2 = V_wb & ld_reg2 & ((~cxchg_op) || (~ZF_new)) & ((~cond_wr_CF) || (CF_flag==CF_expected));
assign v_wb_ld_reg2 = V_wb & ld_reg3;
 
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

endmodule
