
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/eq_checker 

module eq_checker6(in1, in2, eq_out);
  input [5:0] in1, in2;
  output eq_out;
  wire [5:0] in1, in2;
  wire eq_out;
  wire n_0, n_1, n_2, n_3, n_4, n_5, n_6;
  nor3$ g369(.in0 (n_3), .in1 (n_6), .in2 (n_5), .out (eq_out));
  nand4$ g370(.in0 (n_2), .in1 (n_1), .in2 (n_0), .in3 (n_4), .out
       (n_6));
  xor2$ g371(.in0 (in1[4]), .in1 (in2[4]), .out (n_5));
  xnor2$ g376(.in0 (in1[0]), .in1 (in2[0]), .out (n_4));
  xor2$ g373(.in0 (in1[5]), .in1 (in2[5]), .out (n_3));
  xnor2$ g374(.in0 (in1[1]), .in1 (in2[1]), .out (n_2));
  xnor2$ g372(.in0 (in1[2]), .in1 (in2[2]), .out (n_1));
  xnor2$ g375(.in0 (in1[3]), .in1 (in2[3]), .out (n_0));
endmodule

