module compare(in0, in1, out);
input [7:0] in0;
input [7:0] in1;
output out;

assign out = (in0 > in1) ? 1'b0 : 1'b1;

endmodule
  

