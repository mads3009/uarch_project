/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Bitwise shift left                           */
/* Description: Supports data of width 2^N bits         */
/********************************************************/

module bit_shift_left_flgs #(parameter WIDTH=32) ( amt, sin, in, out, out_cf, sr2_count_0);

// Paramters
parameter AMT_W = $clog2(WIDTH);

// Input and Output ports
input  [AMT_W-1:0] amt;
input  [WIDTH-1:0] in;
input              sin;
output [WIDTH-1:0] out;
output [WIDTH:0] out_cf;
output           sr2_count_0;

// Internal Variables
wire   [WIDTH:0] inter[AMT_W:0];
wire   [WIDTH:0] in_ch;

// Shifter logic
assign in_ch = {1'b0,in};

genvar i, j;
generate

for (i=0; i < WIDTH+1; i=i+1) begin : gen_lvl1
  assign inter[0][i] = in_ch[i];
end

for (j=1; j <= AMT_W; j=j+1) begin : gen_row
  for (i=0; i < WIDTH+1; i=i+1) begin : gen_col
    if( i >= (WIDTH/(2**j)) )
      mux2$ u_mux_1bit(.outb(inter[j][i]), .in0(inter[j-1][i]), .in1(inter[j-1][i-(WIDTH/(2**j))]), .s0(amt[AMT_W-j]));
    else
      mux2$ u_mux_1bit(.outb(inter[j][i]), .in0(inter[j-1][i]), .in1(sin), .s0(amt[AMT_W-j]));
  end
end

for (i=0; i < WIDTH+1; i=i+1) begin : gen_lvlN
  assign out_cf[i] = inter[AMT_W][i];
end

endgenerate
assign out = out_cf[WIDTH-1:0];
zero5 u_zero(.in(amt), .out(sr2_count_0));

endmodule

module sal_flags(in, alu1_op_size, flags);
input [32:0] in;
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

assign flag8[CF]  = in[8];
assign flag16[CF] = in[16];
assign flag32[CF] = in[32];

xnor2$ u_xnor0(.out(flag8[OF]), .in0(in[8]), .in1(in[7]));
xnor2$ u_xnor1(.out(flag16[OF]), .in0(in[16]), .in1(in[15]));
xnor2$ u_xnor2(.out(flag32[OF]), .in0(in[32]), .in1(in[31]));

assign flag8[SF]  = in[7];
assign flag16[SF] = in[15];
assign flag32[SF] = in[31];

zero8  u_z8 (.in(in[7:0]), .out(flag8[ZF]));
zero16 u_z16(.in(in[15:0]), .out(flag16[ZF]));
zero32 u_z32(.in(in[31:0]), .out(flag32[ZF]));

parity u_par8 (.in(in[7:0]), .out(flag8[PF]));
parity u_par16(.in(in[7:0]), .out(flag16[PF]));
parity u_par32 (.in(in[7:0]), .out(flag32[PF]));

assign flag8[AF]  = 1'b0;
assign flag16[AF] = 1'b0;
assign flag32[AF] = 1'b0;

mux_nbit_4x1 #6 flag_mux(.a0(flag8), .a1(flag16), .a2(flag32), .a3(6'b0), .sel(alu1_op_size), .out(flags));

endmodule

