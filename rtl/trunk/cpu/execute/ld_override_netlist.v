
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/ld_override 

module ld_override(ld_override, alu1_op, ld_flags_in, ld_flags_out);
  input ld_override;
  input [3:0] alu1_op;
  input [5:0] ld_flags_in;
  output [5:0] ld_flags_out;
  wire ld_override;
  wire [3:0] alu1_op;
  wire [5:0] ld_flags_in;
  wire [5:0] ld_flags_out;
  wire n_0, n_1, n_2, n_3, n_5, n_6, n_25, n_26;
  nor2$ g453(.in0 (n_26), .in1 (n_6), .out (ld_flags_out[5]));
  nor2$ g454(.in0 (n_26), .in1 (n_0), .out (ld_flags_out[4]));
  nor2$ g457(.in0 (n_26), .in1 (n_2), .out (ld_flags_out[3]));
  nor2$ g458(.in0 (n_26), .in1 (n_5), .out (ld_flags_out[2]));
  nor2$ g455(.in0 (n_26), .in1 (n_1), .out (ld_flags_out[1]));
  nor2$ g456(.in0 (n_26), .in1 (n_3), .out (ld_flags_out[0]));
  inv1$ g462(.in (ld_flags_in[5]), .out (n_6));
  inv1$ g463(.in (ld_flags_in[2]), .out (n_5));
  inv1$ g465(.in (ld_flags_in[0]), .out (n_3));
  inv1$ g466(.in (ld_flags_in[3]), .out (n_2));
  inv1$ g467(.in (ld_flags_in[1]), .out (n_1));
  inv1$ g460(.in (ld_flags_in[4]), .out (n_0));
  nor3$ g5(.in0 (n_25), .in1 (alu1_op[2]), .in2 (alu1_op[3]), .out
       (n_26));
  nand2$ g6(.in0 (alu1_op[1]), .in1 (ld_override), .out (n_25));
endmodule
