/******* Microarchiture Project********/
/* Module: mem_arry                   */
/* Description: 32kB memory array     */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module mem_array (ce, oe, wr, rd, strb, addr, data_i, data_o);
// Input and Output ports
input  [14:0] addr;
input  [3:0]  strb;
input         ce, oe, wr, rd;
input  [31:0] data_i;
output [31:0] data_o;

// Internal variables
wire [7:0]  w_row_decoded, w_col_decoded;
wire [31:0] w_data[7:0][7:0];
wire [31:0] w_col_data_temp[7:0];
wire [7:0]  w_col_rd_enbar;
wire [3:0]  w_chip_wr[7:0][7:0];
wire [3:0]  w_strb_bar;

wire [31:0] data_i_del;
assign #0.5 data_i_del = data_i; 
// logic
decoder3_8$ u_decoder3_8_row (.SEL(addr[14:12]), .Y(), .YBAR(w_row_decoded) );
decoder3_8$ u_decoder3_8_col (.SEL(addr[4:2]), .Y(), .YBAR(w_col_decoded) );

inv1$ u_inv_1(.in(oe), .out(oebar));
inv1$ u_inv_2[3:0] (.in(strb[3:0]), .out(w_strb_bar[3:0]));

genvar i,j;
generate begin : mem_gen
  for (i=0; i < 8; i=i+1) begin : row_gen
    for(j=0; j < 8; j=j+1) begin : col_gen

tri_buf32 u_tri_buf32_1( .enbar(oebar), .in(data_i_del), .out(w_data[i][j]) );
or4$ u_or4_1 (.in0(wr), .in1(w_row_decoded[i]), .in2(w_col_decoded[j]), .in3(w_strb_bar[0]), .out(w_chip_wr[i][j][0]) );
or4$ u_or4_2 (.in0(wr), .in1(w_row_decoded[i]), .in2(w_col_decoded[j]), .in3(w_strb_bar[1]), .out(w_chip_wr[i][j][1]) );
or4$ u_or4_3 (.in0(wr), .in1(w_row_decoded[i]), .in2(w_col_decoded[j]), .in3(w_strb_bar[2]), .out(w_chip_wr[i][j][2]) );
or4$ u_or4_4 (.in0(wr), .in1(w_row_decoded[i]), .in2(w_col_decoded[j]), .in3(w_strb_bar[3]), .out(w_chip_wr[i][j][3]) );
sram128x8$ u_sram128x8_1 (.A(addr[11:5]),.DIO(w_data[i][j][7:0]),.OE(oe),.WR(w_chip_wr[i][j][0]), .CE(ce));
sram128x8$ u_sram128x8_2 (.A(addr[11:5]),.DIO(w_data[i][j][15:8]),.OE(oe),.WR(w_chip_wr[i][j][1]), .CE(ce));
sram128x8$ u_sram128x8_3 (.A(addr[11:5]),.DIO(w_data[i][j][23:16]),.OE(oe),.WR(w_chip_wr[i][j][2]), .CE(ce));
sram128x8$ u_sram128x8_4 (.A(addr[11:5]),.DIO(w_data[i][j][31:24]),.OE(oe),.WR(w_chip_wr[i][j][3]), .CE(ce));

    end
  end

  for(j=0; j < 8; j=j+1) begin : col_mux_gen
    col_mux u_col_mux(.Y(w_col_data_temp[j]), 
            .IN0(w_data[0][j]), 
            .IN1(w_data[1][j]), 
            .IN2(w_data[2][j]), 
            .IN3(w_data[3][j]), 
            .IN4(w_data[4][j]), 
            .IN5(w_data[5][j]), 
            .IN6(w_data[6][j]), 
            .IN7(w_data[7][j]), 
            .S0(addr[12]), 
            .S1(addr[13]), 
            .S2(addr[14]) 
           );
  
    or3$ u_or3( .in0(rd), .in1(oe), .in2(w_col_decoded[j]), .out(w_col_rd_enbar[j]) );
    tri_buf32 u_tri_buf32_2( .enbar(w_col_rd_enbar[j]), .in(w_col_data_temp[j]), .out(data_o) );
  end
end
endgenerate

endmodule

module  tri_buf32(enbar, in, out);
	input enbar;
 	input  [31:0] in;
	output [31:0] out;

tristate16H$ u_tristate16H_1 (.enbar(enbar), .in(in[15:0]), .out(out[15:0]) );
tristate16H$ u_tristate16H_2 (.enbar(enbar), .in(in[31:16]), .out(out[31:16]) );

endmodule

module col_mux(Y, IN0, IN1, IN2, IN3, IN4, IN5, IN6, IN7, S0, S1, S2);
input [31:0] IN0;
input [31:0] IN1;
input [31:0] IN2;
input [31:0] IN3;
input [31:0] IN4;
input [31:0] IN5;
input [31:0] IN6;
input [31:0] IN7;
input  S0;
input  S1;
input  S2;
output [31:0] Y;

wire [31:0] temp1, temp2;

mux4_16$ u_mux4_16_1(.Y(temp1[15:0]),.IN0(IN0[15:0]),.IN1(IN1[15:0]),.IN2(IN2[15:0]),.IN3(IN3[15:0]),.S0(S0),.S1(S1) );
mux4_16$ u_mux4_16_2(.Y(temp1[31:16]),.IN0(IN0[31:16]),.IN1(IN1[31:16]),.IN2(IN2[31:16]),.IN3(IN3[31:16]),.S0(S0),.S1(S1) );

mux4_16$ u_mux4_16_3(.Y(temp2[15:0]),.IN0(IN4[15:0]),.IN1(IN5[15:0]),.IN2(IN6[15:0]),.IN3(IN7[15:0]),.S0(S0),.S1(S1) );
mux4_16$ u_mux4_16_4(.Y(temp2[31:16]),.IN0(IN4[31:16]),.IN1(IN5[31:16]),.IN2(IN6[31:16]),.IN3(IN7[31:16]),.S0(S0),.S1(S1) );

mux2_16$ u_mux2_16_1(.Y(Y[15:0]),.IN0(temp1[15:0]),.IN1(temp2[15:0]),.S0(S2));
mux2_16$ u_mux2_16_2(.Y(Y[31:16]),.IN0(temp1[31:16]),.IN1(temp2[31:16]),.S0(S2));

endmodule


