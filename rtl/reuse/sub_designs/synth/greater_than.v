module greater_than #(parameter WIDTH = 32) (in1, in2, gt_out);

input [WIDTH-1:0] in1, in2;
output            gt_out;

assign gt_out = (in1 > in2);

endmodule

