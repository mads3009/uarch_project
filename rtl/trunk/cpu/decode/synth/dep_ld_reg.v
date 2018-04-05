module dep_ld_reg    (cmps_op,
                          mod,
                          mod_rm_pr,
                          sib_pr, 
                          sr1_needed,
                          sr2_needed,
                          sr1_rm,
                          sr2_rm,
                          sr3_eax,
                          sr3_esp,
                          ld_sr1,
                          ld_sr2,
                          in1_needed,
                          in2_needed,
                          in3_needed, 
                          in4_needed, 
                          eax_needed, 
                          esp_needed,
                          ld_r1,
                          ld_r2
                          );

input      cmps_op;   
input [1:0]mod;
input      mod_rm_pr;
input      sib_pr;
input      sr1_needed;
input      sr2_needed;
input      sr1_rm;
input      sr2_rm;
input      sr3_eax;
input      sr3_esp;
input      ld_sr1;
input      ld_sr2;
output     in1_needed;
output     in2_needed;
output     in3_needed;
output     in4_needed;
output     eax_needed;
output     esp_needed;
output     ld_r1;
output     ld_r2;

assign in1_needed = cmps_op || (mod_rm_pr & (mod!=2'b11));
assign in2_needed = cmps_op || sib_pr;
assign in3_needed = sr1_needed & ((!sr1_rm) || ((mod==2'b11) & mod_rm_pr));
assign in4_needed = sr2_needed & ((!sr2_rm) || ((mod==2'b11) & mod_rm_pr));
assign eax_needed = sr3_eax;
assign esp_needed = sr3_esp;
assign ld_r1 = ld_sr1 & ( (!sr1_rm) || ((mod==2'b11) & mod_rm_pr));
assign ld_r2 = ld_sr2 & ( (!sr2_rm) || ((mod==2'b11) & mod_rm_pr));

endmodule
