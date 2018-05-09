/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache data store                            */
/* Description: 512B data store (RAM array)             */
/********************************************************/

module dc_data_store( clk, rst_n, index, dc_wr_mask_way2, dc_wr_mask_way1, dc_write_data,
                      dc_read_data_way2, dc_read_data_way1);

localparam C_LINE_W = 16*8; // 16 Bytes

input                 clk;
input                 rst_n;
output [3:0]          index;
output [15:0]         dc_wr_mask_way2;
output [15:0]         dc_wr_mask_way1;
input  [C_LINE_W-1:0] dc_write_data;

output [C_LINE_W-1:0] dc_read_data_way2;
output [C_LINE_W-1:0] dc_read_data_way1;

// Internal Variables
wire [C_LINE_W-1:0] w_rd_data_way2[1:0];
wire [C_LINE_W-1:0] w_rd_data_way1[1:0];
wire [1:0]          w_row_sel_bar;
wire [15:0]         w_array_wr_mask_way2[1:0];
wire [15:0]         w_array_wr_mask_way1[1:0];

// RAM array
assign w_row_sel_bar[0] = index[3];
// assign w_row_sel_bar[1] = ~index[3];
inv1$ u_inv1_1(.in(index[3]), .out(w_row_sel_bar[1]));

// Delayed clock
// FIXME
wire w_clk_del;
assign #2 w_clk_del = clk;
/* 
buffer$ u_buffer_1(.out(w_clk_001), .in(clk));
buffer$ u_buffer_2(.out(w_clk_002), .in(w_clk_001));
buffer$ u_buffer_3(.out(w_clk_003), .in(w_clk_002));
buffer$ u_buffer_4(.out(w_clk_004), .in(w_clk_003));
buffer$ u_buffer_5(.out(w_clk_005), .in(w_clk_004));
buffer$ u_buffer_6(.out(w_clk_del), .in(w_clk_005));
*/
genvar i,j;
generate
  for(j=0; j < 2; j=j+1) begin: row_gen
    for(i=0; i < 16; i=i+1) begin: col_gen
      nor4$ u_or4_way2 (.out(w_array_wr_mask_way2[j][i]), .in0(clk), .in1(w_row_sel_bar[j]), .in2(dc_wr_mask_way2[i]), .in3(w_clk_del));
      nand2$ u_and_not_way2(.in0(w_array_wr_mask_way2[j][i]), .in1(rst_n), .out(wr_in_way2));
      ram8b8w$ u_ram8b8w_way2 (.A(index[2:0]),.DIN(dc_write_data[8*i+7 -: 8]),.OE(1'b0),.WR(wr_in_way2), .DOUT(w_rd_data_way2[j][8*i+7 -: 8]));

      nor4$ u_or4_way1 (.out(w_array_wr_mask_way1[j][i]), .in0(clk), .in1(w_row_sel_bar[j]), .in2(dc_wr_mask_way1[i]), .in3(w_clk_del));
      nand2$ u_and_not_way1(.in0(w_array_wr_mask_way1[j][i]), .in1(rst_n), .out(wr_in_way1));
      ram8b8w$ u_ram8b8w_way1 (.A(index[2:0]),.DIN(dc_write_data[8*i+7 -: 8]),.OE(1'b0),.WR(wr_in_way1), .DOUT(w_rd_data_way1[j][8*i+7 -: 8]));
    end
  end
endgenerate

mux2$ u_mux2_1[C_LINE_W-1:0] (.outb(dc_read_data_way2[C_LINE_W-1:0]), .in0(w_rd_data_way2[0][C_LINE_W-1:0]), .in1(w_rd_data_way2[1][C_LINE_W-1:0]), .s0(index[3]));
mux2$ u_mux2_2[C_LINE_W-1:0] (.outb(dc_read_data_way1[C_LINE_W-1:0]), .in0(w_rd_data_way1[0][C_LINE_W-1:0]), .in1(w_rd_data_way1[1][C_LINE_W-1:0]), .s0(index[3]));

endmodule

