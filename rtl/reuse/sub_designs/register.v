/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: N-bit width register  */
/* with load signal.                  */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module register #(parameter N=32) (clk, rst_n, set_n, data_i, data_o, ld);
input              clk;
input              rst_n;
input              set_n;
input              ld;
input  [N-1:0] data_i;

output [N-1:0] data_o;

// Internal variables
wire   [N-1:0]   w_mux_out;

genvar i;
generate
for (i=0; i < N; i=i+1) begin : gen_reg
  dff$  u_reg(.r(rst_n),.s(set_n),.clk(clk),.d(w_mux_out[i]),.q(data_o[i]),.qbar(/*Unused*/));
  mux2$ u_mux(.outb(w_mux_out[i]),.in0(data_o[i]),.in1(data_i[i]),.s0(ld));
end
endgenerate

endmodule

