module cond_sum32_c ( A, B, CIN, S, COUT, c4, c8, c16 );

input  [31:0] A, B;
input         CIN;
output [31:0] S;
output        COUT;
output        c4;
output        c8;
output        c16;

wire [31:0] S_temp;

cond_sum16_c u_cond_sum16_low   (.A(A[15:0]), .B(B[15:0]), .CIN(CIN), .S(S[15:0]), .COUT(c16), .c8(c8), .c4(c4) );
cond_sum16_c u_cond_sum16_high0 (.A(A[31:16]), .B(B[31:16]), .CIN(1'b0), .S(S_temp[15:0]), .COUT(COUT0 ),  .c8(/*unused*/), .c4(/*unused*/)  );
cond_sum16_c u_cond_sum16_high1 (.A(A[31:16]), .B(B[31:16]), .CIN(1'b1), .S(S_temp[31:16]), .COUT(COUT1 ), .c8(/*unused*/), .c4(/*unused*/)  );

mux2$ u_mux1[15:0] ( .in0(S_temp[15:0]), .in1(S_temp[31:16]), .s0(c16), .outb(S[31:16]) );

mux2$ u_mux2 ( .in0(COUT0), .in1(COUT1), .s0(c16), .outb(COUT) );


endmodule

module add_flags(A, B, s, c32, c16, c8, c4, flags, alu1_op_size);
input [31:0] A;
input [31:0] B;
input [31:0] s;
input        c32;
input        c16;
input        c8;
input        c4;
input [1:0]  alu1_op_size;
output [5:0] flags;
localparam CF = 3'd0;
localparam PF = 3'd1;
localparam AF = 3'd2;
localparam ZF = 3'd3;
localparam SF = 3'd4;
localparam OF = 3'd5;

wire [5:0] flag8;
wire [5:0] flag16;
wire [5:0] flag32;



// try synthesis
xnor2$ u_msb8 (.out(msb_sign8), .in0(A[7]), .in1(B[7]));
xnor2$ u_msb16(.out(msb_sign16), .in0(A[15]), .in1(B[15]));
xnor2$ u_msb32(.out(msb_sign32), .in0(A[31]), .in1(B[31]));

xor2$ u_check8 (.out(w_check8), .in0(A[7]), .in1(s[7]));
xor2$ u_check16(.out(w_check16), .in0(A[15]), .in1(s[15]));
xor2$ u_check32(.out(w_check32), .in0(A[31]), .in1(s[31]));

and2$ u_of8 (.out(flag8[OF]), .in0(msb_sign8), .in1(w_check8)); 
and2$ u_of16 (.out(flag16[OF]), .in0(msb_sign16), .in1(w_check16)); 
and2$ u_of32 (.out(flag32[OF]), .in0(msb_sign32), .in1(w_check32)); 

assign flag8[CF]  = c8;
assign flag16[CF] = c16;
assign flag32[CF] = c32;

assign flag8[SF]  = s[7];
assign flag16[SF] = s[15];
assign flag32[SF] = s[31];

zero8  u_z8 (.in(s[7:0]), .out(flag8[ZF]));
zero16 u_z16(.in(s[15:0]), .out(flag16[ZF]));
zero32 u_z32(.in(s), .out(flag32[ZF]));

parity u_par8 (.in(s[7:0]), .out(flag8[PF]));
parity u_par16(.in(s[7:0]), .out(flag16[PF]));
parity u_par32 (.in(s[7:0]), .out(flag32[PF]));

assign flag8[AF]  = c4;
assign flag16[AF] = c4;
assign flag32[AF] = c4;

mux_nbit_4x1 #6 flag_mux(.a0(flag8), .a1(flag16), .a2(flag32), .a3(6'b0), .sel(alu1_op_size), .out(flags));

endmodule

