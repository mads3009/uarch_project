module cond_sum8 ( A, B, CIN, S, COUT );

input  [7:0] A, B;
input        CIN;
output [7:0] S;
output       COUT;

wire c4;

nibble_low u_nibble_low   (.a(A[3:0]), .b(B[3:0]), .cin(CIN), .s(S[3:0]), .cout(c4  ) );
nibble_high u_nibble_high (.a(A[7:4]), .b(B[7:4]), .cin(c4 ), .s(S[7:4]), .cout(COUT) );

endmodule

module nibble_low (a, b, cin, s, cout);
input  [3:0] a, b;
input        cin;

output [3:0] s;
output       cout;

fa u_fa ( .a(a[0]), .b(b[0]), .cin(cin), .sum(s[0]), .cout(c1) );

mha u_mha1(.a(a[1]), .b(b[1]), .c0(c20), .c1(c21), .s0(s10), .s1(s11));
mux2$ u_mux1( .in0(s10), .in1(s11), .s0(c1), .outb(s[1]) );
mux2$ u_mux2( .in0(c20), .in1(c21), .s0(c1), .outb(c2) );

mha u_mha2(.a(a[2]), .b(b[2]), .c0(c30), .c1(c31), .s0(s20), .s1(s21));
mux2$ u_mux3( .in0(s20), .in1(s21), .s0(c2), .outb(s[2]) );

mha u_mha3(.a(a[3]), .b(b[3]), .c0(c40), .c1(c41), .s0(s30), .s1(s31));
mux2$ u_mux4( .in0(s30), .in1(s31), .s0(c30), .outb(s3c30) );
mux2$ u_mux5( .in0(s30), .in1(s31), .s0(c31), .outb(s3c31) );

mux2$ u_mux6( .in0(s3c30), .in1(s3c31), .s0(c2), .outb(s[3]) );

mux2$ u_mux7( .in0(c40), .in1(c41), .s0(c30), .outb(c4c30) );
mux2$ u_mux8( .in0(c40), .in1(c41), .s0(c31), .outb(c4c31) );

mux2$ u_mux9( .in0(c4c30), .in1(c4c31), .s0(c2), .outb(cout) );

endmodule

module nibble_high (a, b, cin, s, cout);

input  [7:4] a, b;
input        cin;

output [7:4] s;
output       cout;

mha u_mha1(.a(a[4]), .b(b[4]), .c0(c50), .c1(c51), .s0(s40), .s1(s41));
mux2$ u_mux1( .in0(s40), .in1(s41), .s0(cin), .outb(s[4]) );

mha u_mha2(.a(a[5]), .b(b[5]), .c0(c60), .c1(c61), .s0(s50), .s1(s51));
mux2$ u_mux2( .in0(s50), .in1(s51), .s0(c50), .outb(s5c50) );
mux2$ u_mux3( .in0(s50), .in1(s51), .s0(c51), .outb(s5c51) );

mux2$ u_mux4( .in0(s5c50), .in1(s5c51), .s0(cin), .outb(s[5]) );

mux2$ u_mux5( .in0(c60), .in1(c61), .s0(c50), .outb(c6c50) );
mux2$ u_mux6( .in0(c60), .in1(c61), .s0(c51), .outb(c6c51) );

mha u_mha3(.a(a[6]), .b(b[6]), .c0(c70), .c1(c71), .s0(s60), .s1(s61));
mux2$ u_mux7( .in0(s60), .in1(s61), .s0(c6c50), .outb(s6c6c50) );
mux2$ u_mux8( .in0(s60), .in1(s61), .s0(c6c51), .outb(s6c6c51) );

mux2$ u_mux9( .in0(s6c6c50), .in1(s6c6c51), .s0(cin), .outb(s[6]) );

mha u_mha4(.a(a[7]), .b(b[7]), .c0(c80), .c1(c81), .s0(s70), .s1(s71));
mux2$ u_mux10( .in0(s70), .in1(s71), .s0(c70), .outb(s7c70) );
mux2$ u_mux11( .in0(s70), .in1(s71), .s0(c71), .outb(s7c71) );

mux2$ u_mux12( .in0(s7c70), .in1(s7c71), .s0(c6c50), .outb(s7c7c6c50) );
mux2$ u_mux13( .in0(s7c70), .in1(s7c71), .s0(c6c51), .outb(s7c7c6c51) );

mux2$ u_mux14( .in0(s7c7c6c50), .in1(s7c7c6c51), .s0(cin), .outb(s[7]) );

mux2$ u_mux15( .in0(c80), .in1(c81), .s0(c70), .outb(c8c70) );
mux2$ u_mux16( .in0(c80), .in1(c81), .s0(c71), .outb(c8c71) );

mux2$ u_mux17( .in0(c8c70), .in1(c8c71), .s0(c6c50), .outb(c8c7c6c50) );
mux2$ u_mux18( .in0(c8c70), .in1(c8c71), .s0(c6c51), .outb(c8c7c6c51) );

mux2$ u_mux19( .in0(c8c7c6c50), .in1(c8c7c6c51), .s0(cin), .outb(cout) );

endmodule

module mha (a, b, c0, c1, s0, s1);

input  a, b;
output c0, c1, s0, s1;

wire temp1;

or2$   u_or1   ( .in0(a),    .in1(b), .out(c1)     );
nand2$ u_nand1 ( .in0(a),    .in1(b), .out(temp1)  );
inv1$  u_inv1  ( .in(temp1), .out(c0) );
nand2$ u_nand2 ( .in0(c1),   .in1(temp1), .out(s1) );
inv1$  u_inv2  ( .in(s1),    .out(s0) );

endmodule

module fa (
   input a,
   input b,
   input cin,
   output sum,	
   output cout
);

wire w1,w2,w3;

xor2$ u_xor1 ( .out(w1), .in0(a), .in1(b));
xor2$ u_xor2 ( .out(sum), .in0(w1), .in1(cin));

nand2$ u_nand1 ( .out(w2), .in0(a), .in1(b) );
nand2$ u_nand2 ( .out(w3), .in0(b), .in1(cin) );
nand2$ u_nand3 ( .out(w4), .in0(cin), .in1(a) );
nand3$ u_nand4 ( .out(cout), .in0(w2), .in1(w3), .in2(w4) );
   
endmodule
