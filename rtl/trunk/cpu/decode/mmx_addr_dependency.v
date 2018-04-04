module mmx_addr_dependency(mm1_needed_in,
                                mm2_needed_in,
                                sr1_rm,
                                sr2_rm,
                                mod,
                                r_m,
                                mod_rm_pr,
                                reg_op,
                                ld_mm_in,
                                ret_op,
                                ld_mm,
                                mm1_needed,
                                mm2_needed,
                                mm1,
                                mm2,
                                mm_sr1_sel_L,
                                mm_sr2_sel,
                                dmm);
input       mm1_needed_in;
input       mm2_needed_in;
input       sr1_rm;
input       sr2_rm;
input  [1:0]mod;
input  [2:0]r_m;
input       mod_rm_pr;
input  [2:0]reg_op;
input       ld_mm_in;
input       ret_op;
output      ld_mm;
output      mm1_needed;
output      mm2_needed;
output [2:0]mm1; 
output [2:0]mm2; 
output      mm_sr1_sel_L;
output      mm_sr2_sel;
output [2:0]dmm;

//MMX address

mux3bit_2x1 mux0 (.Y(mm1), .IN0(reg_op), .IN1(r_m), .s0(sr1_rm));
mux3bit_2x1 mux1 (.Y(mm2), .IN0(reg_op), .IN1(r_m), .s0(sr2_rm));
assign dmm = mm1;
//MMX Dependency, Load and sel

dep_ld_mmx dep    (.mm1_needed_in(mm1_needed_in),
                   .mm2_needed_in(mm2_needed_in),
                   .sr1_rm(sr1_rm),
                   .sr2_rm(sr2_rm),
                   .mod(mod),
                   .ret_op(ret_op),
                   .mod_rm_pr(mod_rm_pr),
                   .ld_mm_in(ld_mm_in),
                   .ld_mm(ld_mm),
                   .mm1_needed(mm1_needed),
                   .mm2_needed(mm2_needed),
                   .mm_sr1_sel_L(mm_sr1_sel_L),
                   .mm_sr2_sel(mm_sr2_sel)
                   );

endmodule



                   


