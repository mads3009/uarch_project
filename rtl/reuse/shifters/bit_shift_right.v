/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Bitwise shift right                          */
/* Description: Supports data of width 2^N bits         */
/********************************************************/

module bit_shift_right #(parameter WIDTH=32) (amt, sin, in, out);

// Paramters
parameter AMT_W = $clog2(WIDTH);

// Input and Output ports
input  [AMT_W-1:0] amt;
input  [WIDTH-1:0] in;
input              sin;

output [WIDTH-1:0] out;

// Internal Variables
wire   [WIDTH-1:0] inter[AMT_W:0];

// Shifter logic

genvar i, j;
generate

for (i=0; i < WIDTH; i=i+1) begin : gen_lvl1
  assign inter[0][i] = in[i];
end

for (j=1; j <= AMT_W; j=j+1) begin : gen_row
  for (i=0; i < WIDTH; i=i+1) begin : gen_col
    if( i < (WIDTH - WIDTH/(2**j)) )
      mux_1bit u_mux_1bit(.outb(inter[j][i]), .in0(inter[j-1][i]), .in1(inter[j-1][(WIDTH/(2**j))+i]), .s0(amt[AMT_W-j]));
    else
      mux_1bit u_mux_1bit(.outb(inter[j][i]), .in0(inter[j-1][i]), .in1(sin), .s0(amt[AMT_W-j]));
  end
end

for (i=0; i < WIDTH; i=i+1) begin : gen_lvlN
  assign out[i] = inter[AMT_W][i];
end

endgenerate

endmodule

