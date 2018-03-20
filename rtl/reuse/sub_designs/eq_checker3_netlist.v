
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/eq_checker 

module eq_checker3(in1, in2, eq_out);
  input [2:0] in1, in2;
  output eq_out;
  wire [2:0] in1, in2;
  wire eq_out;
  wire n_0, n_1, n_2;
  and3$ g74(.in0 (n_0), .in1 (n_2), .in2 (n_1), .out (eq_out));
  xnor2$ g75(.in0 (in1[2]), .in1 (in2[2]), .out (n_2));
  xnor2$ g77(.in0 (in1[0]), .in1 (in2[0]), .out (n_1));
  xnor2$ g76(.in0 (in1[1]), .in1 (in2[1]), .out (n_0));
endmodule
