/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Write fifo                                   */
/* Description: Fifo of depth 4, generates empty, full  */
/* and count (# of fifo contents) signals.              */
/********************************************************/

module wr_fifo(clk, rst_n, fifo_empty, fifo_full, fifo_empty_bar, fifo_full_bar, 
               fifo_cnt, wr, wr_data, rd, rd_data);

parameter DATA_W = 8*8+32+2;

input               clk;
input               rst_n;
input               wr;
input               rd;
input  [DATA_W-1:0] wr_data;
output [DATA_W-1:0] rd_data;
output              fifo_empty;
output              fifo_full;
output              fifo_empty_bar;
output              fifo_full_bar;
output [2:0]        fifo_cnt;

// Internal Variables
wire [DATA_W-1:0] r_mem[3:0];
wire [DATA_W-1:0] w_data_temp0, w_data_temp1;
wire [1:0]        r_rd_ptr, r_wr_ptr, w_rd_ptr_inc, w_wr_ptr_inc;
wire [2:0]        r_fifo_cnt, w_fifo_cnt_inc, w_fifo_cnt_dec, w_fifo_cnt;
wire [3:0]        ld_mem;
wire              fifo_full_bar, fifo_empty_bar;
wire              w_ld_fifo_cnt, w_ld_rd_ptr, w_ld_wr_ptr, w_fif_cnt_mux_sel;
wire [1:0]        w_rd_ptr_bar;
wire [3:0]        w_wr_ptr_eq;

// rd_ptr update
register #(.N(2)) u_rd_ptr_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_rd_ptr_inc), .data_o(r_rd_ptr), .ld(w_ld_rd_ptr));

adder2bit u_rd_ptr_adder(.a(r_rd_ptr), .b(2'd1), .sum(w_rd_ptr_inc));

and2$ u_and2_1(.out(w_ld_rd_ptr), .in0(rd), .in1(fifo_empty_bar));


// wr_ptr update
register #(.N(2)) u_wr_ptr_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_wr_ptr_inc), .data_o(r_wr_ptr), .ld(w_ld_wr_ptr));

adder2bit u_rd_ptr_adder(.a(r_wr_ptr), .b(2'd1), .sum(w_wr_ptr_inc));

and2$ u_and2_2(.out(w_ld_wr_ptr), .in0(wr), .in1(fifo_full_bar));

// fifo_cnt update
register #(.N(3)) u_fifo_cnt_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_fifo_cnt), .data_o(r_fifo_cnt), .ld(w_ld_fifo_cnt));

adder3bit u_fifo_cnt_inc_adder(.a(r_fifo_cnt), .b(3'd1), .sum(w_fifo_cnt_inc));
adder3bit u_fifo_cnt_dec_adder(.a(r_fifo_cnt), .b(3'd7), .sum(w_fifo_cnt_dec));

muxNbit_2x1 #(.N(3)) u_mux_fifo_cnt(.IN0(w_fifo_cnt_dec), .IN1(w_fifo_cnt_inc), .S0(w_fif_cnt_mux_sel), .Y(w_fifo_cnt));

and2$ u_and2_3(.out(w_fif_cnt_mux_sel), .in0(wr), .in1(fifo_full_bar));

or2$ u_or2_1(.out(w_temp0), .in0(w_ld_rd_ptr), .in1(w_ld_wr_ptr));
nand4$ u_nand4_1(.out(w_temp1), .in0(wr), .in1(rd), .in2(fifo_full_bar), .in3(fifo_empty_bar));
and2$ u_and2_4(.out(w_ld_fifo_cnt), .in0(w_temp0), .in1(w_temp1));

// fifo_full and fifo_empty generation
nor3$ u_nor3_1(.out(fifo_empty), .in0(r_fifo_cnt[2]), .in1(r_fifo_cnt[1]), .in2(r_fifo_cnt[0]));

inv1$ u_inv1_1(.out(w_temp2), .in(r_fifo_cnt[1]));
inv1$ u_inv1_2(.out(w_temp3), .in(r_fifo_cnt[0]));
and3$ u_and3_1(.out(fifo_full), .in0(r_fifo_cnt[2]), .in1(w_temp2), .in2(w_temp3));

inv1$ u_inv1_3(.out(fifo_empty_bar), .in(fifo_empty));
inv1$ u_inv1_4(.out(fifo_full_bar), .in(fifo_full));

// mem write
genvar i;
generate
  for(i=0;i<4;i=i+1) begin: fifo_mem_gen
    and2$ u_and2_i(.out(ld_mem[i]), .in0(w_ld_wr_ptr), .in1(w_wr_ptr_eq[i]));
    register #(.N(DATA_W)) u_fifo_mem_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(wr_data), .data_o(r_mem[i]), .ld(ld_mem[i]));
  end
endgenerate

inv1$ inv1_5(.out(w_rd_ptr_bar[0]), .in(r_wr_ptr[0]));
inv1$ inv1_6(.out(w_rd_ptr_bar[1]), .in(r_wr_ptr[1]));

and2$ u_and2_5(.out(w_wr_ptr_eq[0]), .in0(w_rd_ptr_bar[0]), .in1(w_rd_ptr_bar[1]));
and2$ u_and2_6(.out(w_wr_ptr_eq[1]), .in0(r_wr_ptr[0]), .in1(w_rd_ptr_bar[1]));
and2$ u_and2_7(.out(w_wr_ptr_eq[2]), .in0(w_rd_ptr_bar[0]), .in1(r_wr_ptr[1]));
and2$ u_and2_8(.out(w_wr_ptr_eq[3]), .in0(r_wr_ptr[0]), .in1(r_wr_ptr[1]));

// mem read
muxNbit_2x1 #(.N(DATA_W)) u_muxNbit_2x1_1(.IN0(r_mem[0]), .IN1(r_mem[1]), .S0(r_rd_ptr[0]), .Y(w_data_temp0));
muxNbit_2x1 #(.N(DATA_W)) u_muxNbit_2x1_2(.IN0(r_mem[2]), .IN1(r_mem[3]), .S0(r_rd_ptr[0]), .Y(w_data_temp1));
muxNbit_2x1 #(.N(DATA_W)) u_muxNbit_2x1_3(.IN0(w_data_temp0), .IN1(w_data_temp1), .S0(r_rd_ptr[1]), .Y(rd_data);

endmodule

