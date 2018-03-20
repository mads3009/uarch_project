/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: regfile                                      */
/* Description: CPU register file with 4 read ports and */
/* 2 write ports. The write ports write to the register */
/* only if their register addresses are different else  */
/* the register file will retain its state.             */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module regfile ();
input        clk;
input        rst_n;
input         wr_en1;
input         wr_en2;
input  [2:0]  wr_reg1;
input  [2:0]  wr_reg2;
input  [3:0]  wr_strb1;
input  [3:0]  wr_strb2;
input  [31:0] wr_data1;
input  [31:0] wr_data2;
input  [2:0]  rd_reg1;
input  [2:0]  rd_reg2;
input  [2:0]  rd_reg3;
input  [2:0]  rd_reg4;
output [31:0] wr_data1;
output [31:0] wr_data2;
output [31:0] wr_data3;
output [31:0] wr_data4;
endmodule

