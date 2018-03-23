module mux_2x1 (a0,a1,sel,out);
    input a0;
    input a1;
    input sel;
    output out;

	wire selb;
	wire w1,w2;

	nand2$ u_na(selb,sel,sel);

    nand2$ u_nand1(w1,a0,selb);
    nand2$ u_nand2(w2,a1,sel);
    nand2$ u_nand3(out,w1,w2);

endmodule
