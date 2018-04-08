/*************** Microarchiture Project******************/
/********************************************************/
/* Module: N-bit adder                                  */
/********************************************************/

module adderNbit (a, b, sum);
parameter N=3;

input  [N-1:0] a,b;
output [N-1:0] sum;

assign sum = a+b;

endmodule

