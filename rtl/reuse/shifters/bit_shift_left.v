/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Bitwise shift left                           */
/* Description: Supports data of width 2^N bits         */
/********************************************************/

module bit_shift_left #(parameter WIDTH=32) ( amt, sin, in, out);

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
generate begin: loop

for (i=0; i < WIDTH; i=i+1) begin : gen_lvl1
  assign inter[0][i] = in[i];
end

for (j=1; j <= AMT_W; j=j+1) begin : gen_row
  for (i=0; i < WIDTH; i=i+1) begin : gen_col
    if( i >= (WIDTH/(2**j)) ) begin: upper
      mux_1bit u_mux_1bit(.outb(inter[j][i]), .in0(inter[j-1][i]), .in1(inter[j-1][i-(WIDTH/(2**j))]), .s0(amt[AMT_W-j]));
    end
    else begin: lower
      mux_1bit u_mux_1bit(.outb(inter[j][i]), .in0(inter[j-1][i]), .in1(sin), .s0(amt[AMT_W-j]));
    end
  end
end

for (i=0; i < WIDTH; i=i+1) begin : gen_lvlN
  assign out[i] = inter[AMT_W][i];
end

end
endgenerate

endmodule


