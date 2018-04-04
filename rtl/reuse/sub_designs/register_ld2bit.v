module register_ld2bit #(parameter N=32) (clk, rst_n, set_n, data_i1, data_i2, data_i3, data_o, ld);
input              clk;
input              rst_n;
input              set_n;
input  [1:0]       ld;
input  [N-1:0] data_i1;
input  [N-1:0] data_i2;
input  [N-1:0] data_i3;

output [N-1:0] data_o;

// Internal variables
wire   [N-1:0]   w_mux_out;

genvar i;
generate
for (i=0; i < N; i=i+1) begin : gen_reg
  dff$  u_reg(.r(rst_n),.s(set_n),.clk(clk),.d(w_mux_out[i]),.q(data_o[i]),.qbar(/*Unused*/));
  mux4$ u_mux(.outb(w_mux_out[i]),.in0(data_o[i]),.in1(data_i1[i]), .in2(data_i2[i]), .in3(data_i3[i]), .s0(ld[0]), .s1(ld[1]));
end
endgenerate

endmodule

