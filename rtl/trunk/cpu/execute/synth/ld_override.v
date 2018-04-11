module ld_override( ld_override, alu1_op, ld_flags_in, ld_flags_out);
input        ld_override;
input  [3:0] alu1_op;
input  [5:0] ld_flags_in;
output [5:0] ld_flags_out;

assign ld_flags_out = ((alu1_op[3:1] == 3'b001) & (ld_override == 1'b1))? 6'd0 : ld_flags_in;

endmodule

