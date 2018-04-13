
// Generated by Cadence Encounter(R) RTL Compiler RC14.28 - v14.20-s067_1

// Verification Directory fv/adderNbit 

module adderNbit(a, b, sum);
  input [2:0] a, b;
  output [2:0] sum;
  wire [2:0] a, b;
  wire [2:0] sum;
  wire n_0, n_1, n_2, n_4, n_5, n_6, n_8;
  xnor2$ g631(.in0 (n_8), .in1 (n_2), .out (sum[2]));
  nor2$ g633(.in0 (n_6), .in1 (n_0), .out (n_8));
  xor2$ g632(.in0 (n_4), .in1 (n_5), .out (sum[1]));
  nor2$ g635(.in0 (n_5), .in1 (n_1), .out (n_6));
  xnor2$ g634(.in0 (a[1]), .in1 (b[1]), .out (n_4));
  xor2$ g637(.in0 (a[0]), .in1 (b[0]), .out (sum[0]));
  xor2$ g636(.in0 (a[2]), .in1 (b[2]), .out (n_2));
  nor2$ g638(.in0 (a[1]), .in1 (b[1]), .out (n_1));
  and2$ g639(.in0 (a[1]), .in1 (b[1]), .out (n_0));
  nand2$ g640(.in0 (a[0]), .in1 (b[0]), .out (n_5));
endmodule

