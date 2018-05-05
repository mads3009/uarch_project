/*************** Microarchiture Project********************/
/**********************************************************/
/* Module: dcache read data generator                     */
/* Description: Generates the 16-byte read data adjuested */
/*              with read address offset.                 */
/**********************************************************/

module mem_rd_data_gen( clk, rst_n, dc_rd_data_way2, dc_rd_data_way1, tag_eq2, addr_offset,
                        access2_reg, dc_read_hit, io_rd_data, io_ack, mem_rd_data, dc_miss_ack, ren);

localparam C_LINE_W = 16*8; // 16 Bytes

input                 clk;
input                 rst_n;
input  [C_LINE_W-1:0] dc_rd_data_way2;
input  [C_LINE_W-1:0] dc_rd_data_way1;
input                 tag_eq2;
input  [3:0]          addr_offset;
input                 access2_reg;
input                 dc_read_hit;
input  [31:0]         io_rd_data;
input                 io_ack;
input                 dc_miss_ack;
input                 ren;

output [63:0]         mem_rd_data;

// Internal Variables

wire [C_LINE_W-1:0] w_data_temp_way2, w_data_temp_way1;
wire [63:0]         w_temp1, w_temp1_way2, w_temp1_way1, w_temp2_way2, w_temp2_way1, w_temp3_way2, w_temp3_way1, w_temp4;
wire                w_ld_mdr;
wire                w_access2_reg_bar;
wire [3:0]          w_addr_offset_bar;
wire [3:0]          w_addr_offset_com;
wire [7:0]          w_sel_mask;
wire                r_tag_eq2;

register #(.N(1)) u_tag_eq2_reg (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(tag_eq2), .data_o(r_tag_eq2), .ld(dc_read_hit));

// Generate mem_rd_data

byte_rotate_right #(.NUM_BYTES(16)) u_data_rotate_right_way2(.amt(addr_offset), .in(dc_rd_data_way2), .out(w_data_temp_way2));
byte_rotate_right #(.NUM_BYTES(16)) u_data_rotate_right_way1(.amt(addr_offset), .in(dc_rd_data_way1), .out(w_data_temp_way1));

inv1$ u_inv1_1(.out(w_access2_reg_bar), .in(access2_reg));
and2$ u_and2_1(.out(w_ld_mdr), .in0(dc_read_hit), .in1(w_access2_reg_bar));

register #(.N(64)) u_mdr_way2 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_data_temp_way2[63:0]), .data_o(w_temp1_way2), .ld(w_ld_mdr));
register #(.N(64)) u_mdr_way1 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_data_temp_way1[63:0]), .data_o(w_temp1_way1), .ld(w_ld_mdr));

muxNbit_2x1 #(.N(64)) u_muxNbit_2x1_2_way2(.IN0(w_temp1_way1), .IN1(w_temp1_way2), .S0(r_tag_eq2), .Y(w_temp1));

// Compute addr_offset_com = 16-addr_offset

inv1$ u_inv1_2[3:0] (.in(addr_offset[3:0]), .out(w_addr_offset_bar[3:0]));
nibble_low u_nibble_low(.a(w_addr_offset_bar), .b(4'd0), .cin(1'b1), .s(w_addr_offset_com), .cout(/*Unused*/) );

bit_shift_left #(.WIDTH(8)) u_mask_sll(.amt(w_addr_offset_com[2:0]), .sin(1'b0), .in(8'hFF), .out(w_sel_mask));

// Select between cache output and MDR

genvar i;
generate
  for(i=0; i < 8; i=i+1) begin: loop
    mux2_8$ u_mux2_8_1_way2(.Y(w_temp2_way2[i*8+7 -: 8]),.IN0(w_temp1[i*8+7 -: 8]),.IN1(w_data_temp_way2[i*8+7 -: 8]),.S0(w_sel_mask[i]));
    mux2_8$ u_mux2_8_1_way1(.Y(w_temp2_way1[i*8+7 -: 8]),.IN0(w_temp1[i*8+7 -: 8]),.IN1(w_data_temp_way1[i*8+7 -: 8]),.S0(w_sel_mask[i]));
  end
endgenerate

// Select between memory or IO

mux_nbit_4x1 #(.N(64)) u_mux_nbit_4x1 (.a0(w_data_temp_way1[63:0]),.a1(w_data_temp_way2[63:0]),.a2(w_temp2_way1),.a3(w_temp2_way2),.sel({access2_reg,tag_eq2}),.out(w_temp4));

mux_nbit_4x1 #(.N(64)) u_mux_nbit_4x2 (.a0(64'd0),.a1(64'd0),.a2(w_temp4),.a3({32'h0000_0000,io_rd_data}),.sel({!dc_miss_ack&ren,io_ack}),.out(mem_rd_data));

endmodule

