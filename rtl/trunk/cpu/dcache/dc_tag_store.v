/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache tag store                             */
/* Description: Stores tag, valid and dirty bit for each*/
/*              cache block.                            */
/********************************************************/

module dc_tag_store u_dc_tag_store(
  clk,
  index,
  wr,
  data_in,
  data_out
  );

input        clk;
input  [4:0] index;
input        wr;
input  [7:0] data_in;
output [7:0] data_out;

// Internal Variables
wire [7:0]  w_rd_data[3:0];
wire [3:0]  w_row_sel_bar;
wire        w_array_wr_mask[3:0];

// RAM array
decoder2_4$ u_decoder2_4_1(.SEL(index[4:3]),.Y(/*Unused*/),.YBAR(w_row_sel_bar));

// Delayed clock
buffer$ u_buffer_1(.out(w_clk_001), .in(clk));
buffer$ u_buffer_2(.out(w_clk_002), .in(w_clk_001));
buffer$ u_buffer_3(.out(w_clk_003), .in(w_clk_002));
buffer$ u_buffer_4(.out(w_clk_004), .in(w_clk_003));
buffer$ u_buffer_5(.out(w_clk_005), .in(w_clk_004));
buffer$ u_buffer_6(.out(w_clk_del), .in(w_clk_005));

genvar j;
generate
  for(j=0; j < 4; j=j+1) begin: row_gen
    or4$ u_or4_1 (.out(w_array_wr_mask[j]), .in0(clk), .in1(w_row_sel_bar[j]), .in2(wr), .in3(w_clk_del));
    ram8b8w$ u_ram8b8w$ (.A(index[3:0]),.DIN(data_in),.OE(1'b0),.WR(w_array_wr_mask[j]), .DOUT(w_rd_data[j][7:0]));
  end
endgenerate

mux4$ u_mux4_1[7:0] (.outb(data_out[7:0]), .in0(w_rd_data[0][7:0]), .in1(w_rd_data[1][7:0]), .in2(w_rd_data[2][7:0]), .in3(w_rd_data[3][7:0]), .s0(index[3]), .s1(index[4]));

endmodule

