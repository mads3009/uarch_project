module TOP;

localparam halfcycle = 4;

reg [31:0] a,b;
reg cin;

    initial
       begin
		cin=1'b0;
		a=32'h0000;
		b=32'hffffffff;
#10;     
		cin=1'b1;
		a=32'h0000;
		b=32'hffffffff;
#10;       
       end
    
    // Run simulation for 15 ns.  
    initial #1200 $finish;

	wire [31:0] sum;
	wire cout;
	kogge_stone #(32) (a,b,cin,sum,cout);
 
endmodule

