/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache tag store                             */
/* Description: Stores tag, valid and dirty bit for each*/
/*              cache block.                            */
/********************************************************/

module dc_tag_store (
  clk,
  rst_n,
  index,
  wr,
  data_in_way2,
  data_in_way1,
  data_out_way2,
  data_out_way1
  );

input         clk;
input         rst_n;
input  [3:0]  index;
input         wr;
input  [15:0] data_in_way2;
input  [15:0] data_in_way1;
output [15:0] data_out_way2;
output [15:0] data_out_way1;

// Internal Variables
wire [15:0]   w_rd_data_way2[1:0];
wire [15:0]   w_rd_data_way1[1:0];
wire [3:0]    w_row_sel_bar;
wire          w_array_wr_mask[1:0];

// RAM array
assign w_row_sel_bar[0] = index[3];
// assign w_row_sel_bar[1] = ~index[3];
inv1$ u_inv1_1(.in(index[3]), .out(w_row_sel_bar[1]));

// Delayed clock
// FIXME
wire w_clk_del;
assign #3 w_clk_del = clk;
/*
buffer$ u_buffer_1(.out(w_clk_001), .in(clk));
buffer$ u_buffer_2(.out(w_clk_002), .in(w_clk_001));
buffer$ u_buffer_3(.out(w_clk_003), .in(w_clk_002));
buffer$ u_buffer_4(.out(w_clk_004), .in(w_clk_003));
buffer$ u_buffer_5(.out(w_clk_005), .in(w_clk_004));
buffer$ u_buffer_6(.out(w_clk_del), .in(w_clk_005));
*/
inv1$ u_not_rst(.in(rst_n), .out(rst_n_not));

genvar j,i;
generate
  for(j=0; j < 2; j=j+1) begin: row_gen
      nor4$ u_or4_way2 (.out(w_array_wr_mask[j]), .in0(clk), .in1(w_row_sel_bar[j]), .in2(wr), .in3(w_clk_del));
    for(i=0; i < 2; i=i+1) begin: col_gen
      nand2$ u_and_not_rst_or(.in0(w_array_wr_mask[j]), .in1(rst_n), .out(wr_in));
      ram8b8w$ u_ram8b8w_way2 (.A(index[2:0]),.DIN(data_in_way2[8*i+7 -: 8]),.OE(1'b0),.WR(wr_in), .DOUT(w_rd_data_way2[j][8*i+7 -: 8]));

      ram8b8w$ u_ram8b8w_way1 (.A(index[2:0]),.DIN(data_in_way1[8*i+7 -: 8]),.OE(1'b0),.WR(wr_in), .DOUT(w_rd_data_way1[j][8*i+7 -: 8]));
    end
  end
endgenerate

mux2$ u_mux2_way2[15:0] (.outb(data_out_way2[15:0]), .in0(w_rd_data_way2[0][15:0]), .in1(w_rd_data_way2[1][15:0]), .s0(index[3]));
mux2$ u_mux2_way1[15:0] (.outb(data_out_way1[15:0]), .in0(w_rd_data_way1[0][15:0]), .in1(w_rd_data_way1[1][15:0]), .s0(index[3]));

endmodule

