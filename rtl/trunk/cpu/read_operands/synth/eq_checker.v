module eq_checker #(parameter WIDTH = 6) (in1, in2, eq_out);

input [WIDTH-1:0] in1, in2;
output            eq_out;

assign eq_out = (in1 == in2);

endmodule
