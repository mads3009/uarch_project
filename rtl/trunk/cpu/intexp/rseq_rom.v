module rseq_rom(
  input oe;
  input [2:0] rseq_addr;
  output [127:0] rseq_data;
  
);

rom64b8w$ rom0(.A(rseq_addr), .OE(oe), .DOUT(rseq_data[63:0]));
rom64b8w$ rom1(.A(rseq_addr), .OE(oe), .DOUT(rseq_data[127:64]));

endmodule
