module fetch_TLB_lookup(
  input [44*8-1:0] TLB,
  input [19:0] CS_limit,
  input f_ren,
  input [31:0] f_address,  
  input [31:0] f_address_off,  
  output [2:0] f_PFN,
  output ic_prot_exp,
  output ic_page_fault
);

wire [7:0] f_TLB_hits;
wire f_TLB_hit;
genvar i;
generate begin : loop
for (i=0; i<8; i=i+1) begin : eq_checker_gen
  eq_checker22 u_chk_tlbhits({TLB[44*i+43: 44*i+24], TLB[44*i+3], TLB[44*i+2]}, {f_address[31:12],1'b1,1'b1}, f_TLB_hits[i]);
end
end
endgenerate

//Page fault
wire [2:0] TLB_sel;
wire TLB_sel_valid;
wire not_TLB_sel_valid;
pencoder8_3v$ u_(.enbar(1'b0), .X(f_TLB_hits), .Y(TLB_sel), .valid(TLB_sel_valid));
inv1$  u_not_TLB_sel_valid (.out(not_TLB_sel_valid), .in(TLB_sel_valid));

and2$ u_ic_page_fault (.out(ic_page_fault), .in0(f_ren), .in1(not_TLB_sel_valid));

//PFN:
mux_nbit_8x1 #3 u_f_PFN (
  .a0(TLB[     6:     4]), 
  .a1(TLB[  44+6:  44+4]), 
  .a2(TLB[2*44+6:2*44+4]), 
  .a3(TLB[3*44+6:3*44+4]), 
  .a4(TLB[4*44+6:4*44+4]), 
  .a5(TLB[5*44+6:5*44+4]), 
  .a6(TLB[6*44+6:6*44+4]), 
  .a7(TLB[7*44+6:7*44+4]), 
  .sel(TLB_sel), 
  .out(f_PFN));

//Protection exception
wire offset_more_than_limit;
greater_than32 u_offset_more_than_limit (.in1({f_address_off[31:5],5'b11111}), .in2({12'h0,CS_limit}), .gt_out(offset_more_than_limit));

and2$ u_ic_prot_exp (.out(ic_prot_exp), .in0(f_ren), .in1(offset_more_than_limit));

endmodule
