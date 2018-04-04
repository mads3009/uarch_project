module dependency_seg (cmps_op,
                       mod,
                       mod_rm_pr,
                       stack_read,
                       stack_write,
                       seg3_needed_in,
                       seg1_needed,
                       seg2_needed,
                       seg3_needed);

input       cmps_op;
input [1:0] mod;
input       mod_rm_pr;
input       stack_read;
input       stack_write;
input       seg3_needed_in;
output      seg1_needed;
output      seg2_needed;
output      seg3_needed;

assign seg1_needed = cmps_op || ((mod!=2'b11) & mod_rm_pr);
assign seg2_needed = cmps_op || stack_read || stack_write;
assign seg3_needed = seg3_needed_in;

endmodule
