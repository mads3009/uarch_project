//*******************************************************
//*************** Microarchiture Project*****************
//*******************************************************
//* Module: seg_regfile                                      
//* Description: MMX register file with 2 read ports and 
//* 1 write port. 
//* Author: Madhuri Gontala                              
//*******************************************************

module seg_regfile (
input         clk,
input         rst_n,
input         wr_en,
input  [2:0]  wr_reg,
input  [15:0] wr_data,
input  [2:0]  seg1,
input  [2:0]  seg2,
output [15:0] r_seg_data1,
output [15:0] r_seg_data2
);

wire [15:0] seg_regs[7:0];

//Read ports
mux_nbit_8x1 #16 u_rdata1 (.a0(seg_regs[0]), .a1(seg_regs[1]), .a2(seg_regs[2]), .a3(seg_regs[3]), .a4(seg_regs[4]), .a5(seg_regs[5]), .a6(seg_regs[6]), .a7(seg_regs[7]), .sel(seg1), .out(r_seg_data1));
mux_nbit_8x1 #16 u_rdata2 (.a0(seg_regs[0]), .a1(seg_regs[1]), .a2(seg_regs[2]), .a3(seg_regs[3]), .a4(seg_regs[4]), .a5(seg_regs[5]), .a6(seg_regs[6]), .a7(seg_regs[7]), .sel(seg2), .out(r_seg_data2));

//Write

//decoder
wire [7:0] decode_out;
wire [7:0] ld_seg_reg;
decoder3_8$ u_w_ld_seg_reg (.SEL(wr_reg), .Y(decode_out), .YBAR(/*Unused*/));
AND1_nbit #8 u_dec_out (.a(decode_out), .en(wr_en), .out(ld_seg_reg) );

//Write to respective register
genvar i;
generate begin
  for (i=0; i<8; i=i+1) begin : loop2
    register #16 u_seg_reg (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(wr_data), .data_o(seg_regs[i]), .ld(ld_seg_reg[i]));
  end
end
endgenerate

endmodule

