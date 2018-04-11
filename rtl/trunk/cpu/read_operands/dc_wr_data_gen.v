/*************** Microarchiture Project*******************/
/*********************************************************/
/* Module: dcache write data generator                   */
/* Description: Generates the 16-byte write data and mask*/
/*********************************************************/

module dc_wr_data_gen( mem_wr_size, addr_offset, mem_wr_data, access2_reg,
                       dc_data_fill, dc_miss_ack, dc_wr_hit, dc_wr_data, dc_wr_mask);

localparam C_LINE_W = 16*8; // 16 Bytes

input  [1:0]          mem_wr_size;
input  [63:0]         mem_wr_data;
input  [3:0]          addr_offset;
input                 access2_reg;
input  [C_LINE_W-1:0] dc_data_fill;
input                 dc_miss_ack;
input                 dc_wr_hit;

output [C_LINE_W-1:0] dc_wr_data;
output [15:0]         dc_wr_mask;

// Internal variables
wire [3:0]          w_addr_offset_bar;
wire [3:0]          w_addr_offset_com;
wire [15:0]         w_temp1, w_temp2, w_temp3, w_temp4, w_temp5;
wire [C_LINE_W-1:0] w_data_temp;
wire                w_dc_wr_hit_bar;

// Generate dc_wr_data and dc_wr_mask

// Compute addr_offset_com = 16-addr_offset
inv1$ u_inv1_1[3:0] (.in(addr_offset[3:0]), .out(w_addr_offset_bar[3:0]));
nibble_low u_nibble_low(.a(w_addr_offset_bar), .b(4'd0), .cin(1'b1), .s(w_addr_offset_com), .cout(/*Unused*/) );

// Compute dc_wr_mask
mux4_16$ u_mux4_16_1(.Y(w_temp1), .IN0(16'hFF_FE), .IN1(16'hFF_FC), .IN2(16'hFF_F0), .IN3(16'hFF_00), .S0(mem_wr_size[0]), .S1(mem_wr_size[1]));

bit_shift_left #(.WIDTH(16)) u_mask_sll(.amt(addr_offset), .sin(1'b1), .in(w_temp1), .out(w_temp2));
bit_shift_right #(.WIDTH(16)) u_mask_srl(.amt(w_addr_offset_com), .sin(1'b1), .in(w_temp1), .out(w_temp3));

mux2_16$ u_mux2_16_1(.Y(w_temp4),.IN0(w_temp2),.IN1(w_temp3),.S0(access2_reg));
inv1$ u_inv1_2(.in(dc_wr_hit), .out(w_dc_wr_hit_bar));
or2$ u_or2_1[15:0] (.out(w_temp5[15:0]), .in0(w_temp4[15:0]), .in1(w_dc_wr_hit_bar));

mux2_16$ u_mux2_16_2(.Y(dc_wr_mask), .IN0(w_temp5),.IN1(16'h00_00),.S0(dc_miss_ack));

// Compute dc_wr_data

byte_rotate_left #(.NUM_BYTES(16)) u_data_rotate_left(.amt(addr_offset), .in({64'h0000_0000_0000_0000, mem_wr_data}), .out(w_data_temp));

muxNbit_2x1 #(.N(C_LINE_W)) u_muxNbit_2x1_1(.IN0(w_data_temp), .IN1(dc_data_fill), .S0(dc_miss_ack), .Y(dc_wr_data));

endmodule

