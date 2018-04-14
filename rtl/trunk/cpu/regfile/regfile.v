//*******************************************************
//*************** Microarchiture Project*****************
//*******************************************************
//* Module: regfile                                      
//* Description: CPU register file with 4 read ports and 
//* 3 write ports. There are 4 strbs for ever write
//* (One per byte)
//* Author: Madhuri Gontala                            
//*******************************************************

module regfile (
input         clk,
input         rst_n,
input         wr_en1,
input         wr_en2,
input         wr_en3,
input  [2:0]  wr_reg1,
input  [2:0]  wr_reg2,
input  [2:0]  wr_reg3,
input  [3:0]  wr_strb1,
input  [3:0]  wr_strb2,
input  [3:0]  wr_strb3,
input  [31:0] wr_data1,
input  [31:0] wr_data2,
input  [31:0] wr_data3,
input  [2:0]  in1,
input  [2:0]  in2,
input  [2:0]  in3,
input  [2:0]  in4,
output [31:0] r_reg_data1,
output [31:0] r_reg_data2,
output [31:0] r_reg_data3,
output [31:0] r_reg_data4,
output [31:0] ESP,
output [31:0] ECX,
output [31:0] EAX
);

wire [31:0] regs[7:0];

assign ESP = regs[4];
assign ECX = regs[1];
assign EAX = regs[0];

//Read ports
mux_nbit_8x1 u_rdata1 (.a0(regs[0]), .a1(regs[1]), .a2(regs[2]), .a3(regs[3]), .a4(regs[4]), .a5(regs[5]), .a6(regs[6]), .a7(regs[7]), .sel(in1), .out(r_reg_data1));
mux_nbit_8x1 u_rdata2 (.a0(regs[0]), .a1(regs[1]), .a2(regs[2]), .a3(regs[3]), .a4(regs[4]), .a5(regs[5]), .a6(regs[6]), .a7(regs[7]), .sel(in2), .out(r_reg_data2));
mux_nbit_8x1 u_rdata3 (.a0(regs[0]), .a1(regs[1]), .a2(regs[2]), .a3(regs[3]), .a4(regs[4]), .a5(regs[5]), .a6(regs[6]), .a7(regs[7]), .sel(in3), .out(r_reg_data3));
mux_nbit_8x1 u_rdata4 (.a0(regs[0]), .a1(regs[1]), .a2(regs[2]), .a3(regs[3]), .a4(regs[4]), .a5(regs[5]), .a6(regs[6]), .a7(regs[7]), .sel(in4), .out(r_reg_data4));

//Write

//decoders
wire [7:0] decode_out[2:0];
decoder3_8$ u_w_decoder0 (.SEL(wr_reg1), .Y(decode_out[0]), .YBAR(/*Unused*/));
decoder3_8$ u_w_decoder1 (.SEL(wr_reg2), .Y(decode_out[1]), .YBAR(/*Unused*/));
decoder3_8$ u_w_decoder2 (.SEL(wr_reg3), .Y(decode_out[2]), .YBAR(/*Unused*/));

//decode outputs validated with corresponding strobes

wire [7:0] decode_out_strb0[2:0];
wire [7:0] decode_out_strb1[2:0];
wire [7:0] decode_out_strb2[2:0];
wire [7:0] decode_out_strb3[2:0];

AND1_nbit #8 u_dec_out_strb00 (.a(decode_out[0]), .en(wr_strb1[0]), .out(decode_out_strb0[0]) );
AND1_nbit #8 u_dec_out_strb10 (.a(decode_out[0]), .en(wr_strb1[1]), .out(decode_out_strb1[0]) );
AND1_nbit #8 u_dec_out_strb20 (.a(decode_out[0]), .en(wr_strb1[2]), .out(decode_out_strb2[0]) );
AND1_nbit #8 u_dec_out_strb30 (.a(decode_out[0]), .en(wr_strb1[3]), .out(decode_out_strb3[0]) );

AND1_nbit #8 u_dec_out_strb01 (.a(decode_out[1]), .en(wr_strb2[0]), .out(decode_out_strb0[1]) );
AND1_nbit #8 u_dec_out_strb11 (.a(decode_out[1]), .en(wr_strb2[1]), .out(decode_out_strb1[1]) );
AND1_nbit #8 u_dec_out_strb21 (.a(decode_out[1]), .en(wr_strb2[2]), .out(decode_out_strb2[1]) );
AND1_nbit #8 u_dec_out_strb31 (.a(decode_out[1]), .en(wr_strb2[3]), .out(decode_out_strb3[1]) );

AND1_nbit #8 u_dec_out_strb02 (.a(decode_out[2]), .en(wr_strb3[0]), .out(decode_out_strb0[2]) );
AND1_nbit #8 u_dec_out_strb12 (.a(decode_out[2]), .en(wr_strb3[1]), .out(decode_out_strb1[2]) );
AND1_nbit #8 u_dec_out_strb22 (.a(decode_out[2]), .en(wr_strb3[2]), .out(decode_out_strb2[2]) );
AND1_nbit #8 u_dec_out_strb32 (.a(decode_out[2]), .en(wr_strb3[3]), .out(decode_out_strb3[2]) );

wire [1:0] ld_reg_0 [7:0];
wire [1:0] ld_reg_1 [7:0];
wire [1:0] ld_reg_2 [7:0];
wire [1:0] ld_reg_3 [7:0];

genvar i;
generate begin
  for (i=0; i<8; i=i+1) begin : loop1
    pencoder_3_2 u_pencode0 (.a0(decode_out_strb0[0][i]), .a1(decode_out_strb0[1][i]), .a2(decode_out_strb0[2][i]), .out(ld_reg_0[i])); 
    pencoder_3_2 u_pencode1 (.a0(decode_out_strb1[0][i]), .a1(decode_out_strb1[1][i]), .a2(decode_out_strb1[2][i]), .out(ld_reg_1[i])); 
    pencoder_3_2 u_pencode2 (.a0(decode_out_strb2[0][i]), .a1(decode_out_strb2[1][i]), .a2(decode_out_strb2[2][i]), .out(ld_reg_2[i])); 
    pencoder_3_2 u_pencode3 (.a0(decode_out_strb3[0][i]), .a1(decode_out_strb3[1][i]), .a2(decode_out_strb3[2][i]), .out(ld_reg_3[i])); 
  end
end
endgenerate

generate begin : reg_loop
  for (i=0; i<8; i=i+1) begin : loop2
    register_ld2bit #8 u_reg0 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i1(wr_data1[ 7: 0]), .data_i2(wr_data2[ 7: 0]), .data_i3(wr_data3[ 7: 0]), .data_o(regs[i][ 7: 0]), .ld(ld_reg_0[i]));
    register_ld2bit #8 u_reg1 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i1(wr_data1[15: 8]), .data_i2(wr_data2[15: 8]), .data_i3(wr_data3[15: 8]), .data_o(regs[i][15: 8]), .ld(ld_reg_1[i]));
    register_ld2bit #8 u_reg2 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i1(wr_data1[23:16]), .data_i2(wr_data2[23:16]), .data_i3(wr_data3[23:16]), .data_o(regs[i][23:16]), .ld(ld_reg_2[i]));
    register_ld2bit #8 u_reg3 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i1(wr_data1[31:24]), .data_i2(wr_data2[31:24]), .data_i3(wr_data3[31:24]), .data_o(regs[i][31:24]), .ld(ld_reg_3[i]));
  end
end
endgenerate

endmodule

