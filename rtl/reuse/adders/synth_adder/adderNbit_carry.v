/*************** Microarchiture Project******************/
/********************************************************/
/* Module: N-bit adder                                  */
/********************************************************/

module adderNbit_carry (a, b, sum, cout);
parameter N=3;

input  [N-1:0] a,b;
output [N-1:0] sum;
output cout;

assign {cout, sum} = {1'b0,a}+{1'b0,b};

endmodule

