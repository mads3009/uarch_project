module FA (
   input a,
   input b,
   input cin,
   output sum,	
   output cout
);

wire w1,w2,w3;

xor2$ xor1(w1, a, b);
xor2$ xor2(sum, w1, cin);

nand2$ nand1 (w2,a, b);
nand2$ nand2 (w3,cin, w1);
nand2$ nand3 (cout,w2, w3);
   
endmodule
