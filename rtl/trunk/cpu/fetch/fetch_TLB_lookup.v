module fetch_TLB_lookup(
  input [44*8-1:0] TLB,
  input [19:0] CS_limit,
  input f_ren,
  input [31:0] f_address,  
  output reg [2:0] f_PFN,
  output ic_prot_exp,
  output ic_page_fault
);

//Logic that checks TLB entries and gives the PFN, exceptions
wire [7:0] f_TLB_hits;
wire f_TLB_hit;
genvar i;
generate begin : loop
for (i=0; i<8; i=i+1) begin : eq_checker_gen
  eq_checker #22 u_chk_tlbhits({TLB[44*i+43: 44*i+24], TLB[44*i+3], TLB[44*i+2]}, {f_address[31:12],1'b1,1'b1}, f_TLB_hits[i]);
end
end
endgenerate

assign ic_prot_exp = f_ren && ({f_address[31:5],5'b0} > CS_limit);
assign ic_page_fault = f_ren && (~(|(f_TLB_hits)));

always @(*) begin
  case (f_TLB_hits)
    8'h01 : f_PFN = TLB[6:4];
    8'h02 : f_PFN = TLB[  44+6:  44+4];
    8'h04 : f_PFN = TLB[2*44+6:2*44+4];
    8'h08 : f_PFN = TLB[3*44+6:3*44+4];
    8'h10 : f_PFN = TLB[4*44+6:4*44+4];
    8'h20 : f_PFN = TLB[5*44+6:5*44+4];
    8'h40 : f_PFN = TLB[6*44+6:6*44+4];
    8'h80 : f_PFN = TLB[7*44+6:7*44+4];
    default : f_PFN = 3'h0;
  endcase
end

endmodule
