/*************** Microarchiture Project********************/
/**********************************************************/
/* Module: dcache read data generator                     */
/* Description: Generates the 16-byte read data adjuested */
/*              with read address offset.                 */
/**********************************************************/

module mem_rd_data_gen( clk, rst_n, dc_rd_data, addr_offset, access2_reg, 
                        dc_read_hit, io_rd_data, io_ack, mem_rd_data);

localparam C_LINE_W = 16*8; // 16 Bytes

input                 clk;
input                 rst_n;
input  [C_LINE_W-1:0] dc_rd_data;
input  [3:0]          addr_offset;
input                 access2_reg;
input                 dc_read_hit;
input  [31:0]         io_rd_data;
input                 io_ack;

output [63:0]         mem_rd_data;

// Internal Variables

wire [C_LINE_W-1:0] w_data_temp;
wire [63:0]         w_temp0, w_temp1, w_temp2;
wire                w_ld_mdr;
wire                w_access2_reg_bar;
wire [3:0]          w_addr_offset_bar;
wire [3:0]          w_addr_offset_com;
wire [7:0]          w_sel_mask;

// Generate mem_rd_data

byte_rotate_left #(.NUM_BYTES(16)) u_data_rotate_left(.amt(addr_offset), .in(dc_rd_data), .out(w_data_temp));

assign w_temp0 = w_data_temp[63:0];

inv1$ u_inv1_1(.out(w_access2_reg_bar), .in(access2_reg));
and2$ u_and2_1(.out(w_ld_mdr), .in0(dc_read_hit), .in1(w_access2_reg_bar));

register #(.N(64)) u_mdr (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_data_temp[63:0]), .data_o(w_temp1), .ld(w_ld_mdr));


// Compute addr_offset_com = 16-addr_offset

inv1$ u_inv1_2[3:0] (.in(addr_offset[3:0]), .out(w_addr_offset_bar[3:0]));
nibble_low u_nibble_low(.a(w_addr_offset_bar), .b(4'd0), .cin(1'b1), .s(w_addr_offset_com), .cout(/*Unused*/) );

bit_shift_left #(.WIDTH(8)) u_mask_sll(.amt(w_addr_offset_com), .sin(1'b0), .in(8'hFF), .out(w_sel_mask));

// Select between cache output and MDR

genvar i;
generate
  for(i=0; i < 8; i=i+1) begin: loop
    mux2_8$ u_mux2_8_1(.Y(w_temp2[i*8+7 -: 8]),.IN0(w_temp1[i*8+7 -: 8]),.IN1(w_data_temp[i*8+7 -: 8]),.S0(w_sel_mask[i]));
  end
endgenerate

// Select between memory or IO
muxNbit_2x1 #(.N(64)) u_muxNbit_2x1_1(.IN0(w_temp2), .IN1({32'h0000_0000,io_rd_data}), .S0(io_ack), .Y(mem_rd_data));

endmodule

