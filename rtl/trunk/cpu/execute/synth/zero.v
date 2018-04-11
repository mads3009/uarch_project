module zero (in, out);
input [4:0]in;
output out;


assign out = ~|in;

endmodule 
