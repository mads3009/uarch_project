//*******************************************************
//*************** Microarchiture Project*****************
//*******************************************************
//* Module: mmx_regfile                                      
//* Description: MMX register file with 2 read ports and 
//* 1 write port. 
//* Author: Madhuri Gontala                              
//*******************************************************

module mmx_regfile (
input         clk,
input         rst_n,
input         wr_en,
input  [2:0]  wr_reg,
input  [63:0] wr_data,
input  [2:0]  mm1,
input  [2:0]  mm2,
output [63:0] r_mm_data1,
output [63:0] r_mm_data2
);

wire [63:0] mm_regs[7:0];

//Read ports
mux_nbit_8x1 #64 u_rdata1 (.a0(mm_regs[0]), .a1(mm_regs[1]), .a2(mm_regs[2]), .a3(mm_regs[3]), .a4(mm_regs[4]), .a5(mm_regs[5]), .a6(mm_regs[6]), .a7(mm_regs[7]), .sel(mm1), .out(r_mm_data1));
mux_nbit_8x1 #64 u_rdata2 (.a0(mm_regs[0]), .a1(mm_regs[1]), .a2(mm_regs[2]), .a3(mm_regs[3]), .a4(mm_regs[4]), .a5(mm_regs[5]), .a6(mm_regs[6]), .a7(mm_regs[7]), .sel(mm2), .out(r_mm_data2));

//Write

//decoder
wire [7:0] decode_out;
wire [7:0] ld_mm_reg;
decoder3_8$ u_w_ld_mm_reg (.SEL(wr_reg), .Y(decode_out), .YBAR(/*Unused*/));
AND1_nbit #8 u_dec_out (.a(decode_out), .en(wr_en), .out(ld_mm_reg) );

//Write to respective register
genvar i;
generate begin : mmx_loop
  for (i=0; i<8; i=i+1) begin : loop2
    register #64 u_mm_reg (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(wr_data), .data_o(mm_regs[i]), .ld(ld_mm_reg[i]));
  end
end
endgenerate

endmodule

