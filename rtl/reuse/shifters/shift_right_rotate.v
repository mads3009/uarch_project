module shift_right_rotate #(parameter WIDTH=32) (amt, in, out);

// Paramters
parameter AMT_W = $clog2(WIDTH);
parameter N=8; //for byte

// Input and Output ports
input  [AMT_W-1:0] amt;
input  [N*WIDTH-1:0] in;
output [N*WIDTH-1:0] out;

// Internal Variables
wire   [N*WIDTH-1:0] inter[AMT_W:0];

// Shifter logic

genvar i, j, k;
generate

for (i=0; i < N*WIDTH; i=i+1) begin : gen_lvl1
  assign inter[0][i] = in[i];
end

for (j=1; j <= AMT_W; j=j+1) begin : gen_row
  for (i=0; i < WIDTH; i=i+1) begin : gen_col
    if( i < (WIDTH - WIDTH/(2**j)) ) begin : lower
      mux_nbit_2x1 #N u_mux0(.out(inter[j][N*i+7 : N*i]), .a0(inter[j-1][N*i+7 : N*i]), .a1(inter[j-1][N*(i+WIDTH/(2**j))+7 : N*(i+WIDTH/(2**j))]), .sel(amt[AMT_W-j]));
    end
    else begin : upper
      mux_nbit_2x1 #N u_mux1(.out(inter[j][N*i+7 : N*i]), .a0(inter[j-1][N*i+7 : N*i]), .a1(inter[j-1][N*(i-WIDTH/(2**j))+7 : N*(i-WIDTH/(2**j))]), .sel(amt[AMT_W-j]));
    end
  end
end

for (i=0; i < WIDTH; i=i+1) begin : gen_lvlN
  assign out[i] = inter[AMT_W][i];
end

endgenerate

endmodule

