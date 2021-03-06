module greater_than_for_flags #(parameter WIDTH = 32) (in1, in2, gt_out);

input [WIDTH-1:0] in1, in2;
output            gt_out;

assign gt_out = (({1'b0,in1}) > ({1'b0,in2}));

endmodule

