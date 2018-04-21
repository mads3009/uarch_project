/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Byte rotate right                            */
/* Description: Supports data of width 2^N bytes        */
/********************************************************/

module byte_rotate_right #(parameter NUM_BYTES=16) ( amt, in, out);

// Paramters
parameter AMT_W = $clog2(NUM_BYTES);

// Input and Output ports
input  [AMT_W-1:0] amt;
input  [NUM_BYTES*8-1:0] in;

output [NUM_BYTES*8-1:0] out;

// Internal Variables
wire   [NUM_BYTES*8-1:0] inter[AMT_W:0];

// Shifter logic

genvar i, j;
generate begin: loop

for (i=0; i < NUM_BYTES*8; i=i+1) begin : gen_lvl1
  assign inter[0][i] = in[i];
end

for (j=1; j <= AMT_W; j=j+1) begin : gen_row
  for (i=0; i < NUM_BYTES; i=i+1) begin : gen_col
    if( i < (NUM_BYTES - NUM_BYTES/(2**j)) ) begin: lower
      mux2_8$ u_mux2_8_L(.Y(inter[j][i*8+7 -: 8]),.IN0(inter[j-1][i*8+7 -: 8]),.IN1(inter[j-1][(NUM_BYTES*8/(2**j)) + i*8 + 7 -: 8]),.S0(amt[AMT_W-j]));
    end
    else begin: upper
      mux2_8$ u_mux2_8_U(.Y(inter[j][i*8+7 -: 8]),.IN0(inter[j-1][i*8+7 -: 8]),.IN1(inter[j-1][i*8 - (NUM_BYTES - NUM_BYTES/(2**j))*8 + 7 -: 8]),.S0(amt[AMT_W-j]));
    end
  end
end

for (i=0; i < NUM_BYTES*8; i=i+1) begin : gen_lvlN
  assign out[i] = inter[AMT_W][i];
end

end
endgenerate

endmodule

