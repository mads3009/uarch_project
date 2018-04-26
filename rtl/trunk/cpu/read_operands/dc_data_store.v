/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache data store                            */
/* Description: 512B data store (RAM array)             */
/********************************************************/

module dc_data_store( clk, index, dc_wr_mask, dc_write_data, dc_read_data);

localparam C_LINE_W = 16*8; // 16 Bytes

input                 clk;
output [4:0]          index;
output [15:0]         dc_wr_mask;
input  [C_LINE_W-1:0] dc_write_data;

output [C_LINE_W-1:0] dc_read_data;

// Internal Variables
wire [C_LINE_W-1:0] w_rd_data[3:0];
wire [3:0]          w_row_sel_bar;
wire [15:0]         w_array_wr_mask[3:0];

// RAM array
decoder2_4$ u_decoder2_4_1(.SEL(index[4:3]),.Y(/*Unused*/),.YBAR(w_row_sel_bar));

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
  for(j=0; j < 4; j=j+1) begin: row_gen
    for(i=0; i < 16; i=i+1) begin: col_gen
      or4$ u_or4_1 (.out(w_array_wr_mask[j][i]), .in0(clk), .in1(w_row_sel_bar[j]), .in2(dc_wr_mask[i]), .in3(w_clk_del));
      ram8b8w$ u_ram8b8w$ (.A(index[2:0]),.DIN(dc_write_data[8*i+7 -: 8]),.OE(1'b0),.WR(w_array_wr_mask[j][i]), .DOUT(w_rd_data[j][8*i+7 -: 8]));
    end
  end
endgenerate

mux4$ u_mux4_1[C_LINE_W-1:0] (.outb(dc_read_data[C_LINE_W-1:0]), .in0(w_rd_data[0][C_LINE_W-1:0]), .in1(w_rd_data[1][C_LINE_W-1:0]), .in2(w_rd_data[2][C_LINE_W-1:0]), .in3(w_rd_data[3][C_LINE_W-1:0]), .s0(index[3]), .s1(index[4]));

endmodule

