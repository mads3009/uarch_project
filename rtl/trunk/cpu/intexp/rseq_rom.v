/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Decoded signals stored in ROM for iret, int &*/
/* exception handling.                                  */
/********************************************************/

module rseq_rom(
  input oe,
  input [2:0] rseq_addr,
  output [127:0] rseq_data  
);

rom64b32w$ rom0(.A({2'b00,rseq_addr}), .OE(oe), .DOUT(rseq_data[63:0]));
rom64b32w$ rom1(.A({2'b00,rseq_addr}), .OE(oe), .DOUT(rseq_data[127:64]));

endmodule
