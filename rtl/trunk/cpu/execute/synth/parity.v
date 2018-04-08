module parity (in, out);
input [7:0]in;
output out;


assign out = ~^in;

endmodule 
