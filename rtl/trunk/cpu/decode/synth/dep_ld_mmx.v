module dep_ld_mmx    (mm1_needed_in,
                      mm2_needed_in,
                      sr1_rm,
                      sr2_rm,
                      mod,
                      mod_rm_pr,
                      ld_mm_in,
                      ret_op,
                      ld_mm,
                      mm1_needed,
                      mm2_needed,
                      mm_sr1_sel_L,
                      mm_sr2_sel);

input       mm1_needed_in;
input       mm2_needed_in;
input       sr1_rm;
input       sr2_rm;
input  [1:0]mod;
input       mod_rm_pr;
input       ld_mm_in;
input       ret_op;
output      ld_mm;
output      mm1_needed;
output      mm2_needed;
output      mm_sr1_sel_L;
output      mm_sr2_sel;

assign mm1_needed = (mm1_needed_in & ((!sr1_rm) || ( (mod==2'b11) & mod_rm_pr)));
assign mm2_needed = (mm2_needed_in & ((!sr2_rm) || ( (mod==2'b11) & mod_rm_pr)));

assign ld_mm = (ld_mm_in & ((!sr1_rm) || ((mod==2'b11) & mod_rm_pr)));
assign mm_sr1_sel_L =( (sr1_rm) &  (mod != 2'b11) )& (!ret_op) ;
assign mm_sr2_sel =( (sr2_rm) &  (mod != 2'b11) );

endmodule


