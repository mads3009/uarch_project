/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: DMA master controller */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module dma_master_controller( clk, rst_n, m_cyc, m_we, m_strb, m_addr, m_data_o, m_ack, m_data_i,
            d_ready, d_data_in, d_addr, d_init, d_done, disk_addr, mem_addr, num_transfers,
            start_transfer, start_offset, end_offset, transfer_size_sum_lsb, interrupt, int_clear);
// Input and Output ports
input         clk;
input         rst_n;
input         int_clear;

output        interrupt;

// DMA master interfce
output        m_cyc;
output        m_we;
output [3:0]  m_strb;
output [31:0] m_addr;
output [31:0] m_data_o;

input         m_ack;
input  [31:0] m_data_i; // unused port as DMA performs only memory writes

// DMA-DISK interface
input         d_ready;
input  [31:0] d_data_in;

output [9:0]  d_addr;
output        d_init;
output        d_done;

// DMA master slave interface
input [31:0] disk_addr; // unused as disk is behavioral
input [31:0] mem_addr;
input [15:0] num_transfers;
input [1:0]  transfer_size_sum_lsb;
input        start_transfer;
input [1:0]  start_offset;
input [1:0]  end_offset;

// Internal Variables
wire [2:0]  w_curr_st;
wire        w_num_trans_eq1;
wire        w_num_trans_eq2;
wire        w_trans_cnt_eq2;
wire        w_start_transfer_del;
wire        w_trans_success;
wire        w_ld_next;
wire        w_curr_st_int;

wire [31:0] r_curr_addr, w_next_addr, w_next_addr_sum;
wire [15:0] r_trans_count, w_next_trans_count, w_next_trans_count_sum;
wire [9:0]  r_d_addr;
wire [15:0] w_next_d_addr, w_next_d_addr_sum;

localparam INT = 3'b010;

eq_checker16 u_eq_checker1 (.in1(num_transfers), .in2(16'd1), .eq_out(w_num_trans_eq1));
eq_checker16 u_eq_checker2 (.in1(num_transfers), .in2(16'd2), .eq_out(w_num_trans_eq2));
eq_checker16 u_eq_checker3 (.in1(r_trans_count), .in2(16'd2), .eq_out(w_trans_cnt_eq2));

dff$ init_trans_reg (.r(rst_n), .s(1'b1), .clk(clk), .d(start_transfer), .q(w_start_transfer_del), .qbar(/*Unused*/));

// DMA master interface
assign m_we = 1'b1;
assign m_cyc = w_curr_st[2];
assign m_data_o = d_data_in;

// m_addr and r_trans_count generation

and2$ u_and1(.in0(m_cyc), .in1(m_ack), .out(w_trans_success));
or2$ u_or10(.in0(w_trans_success), .in1(w_start_transfer_del), .out(w_ld_next));

// m_addr
cond_sum32 u_cond_sum32_1(.A({r_curr_addr[31:2], 2'd0}), .B(32'd4), .CIN(1'b0), .S(w_next_addr_sum), .COUT(/*unused*/));

mux32bit_2x1 u_mux32bit_2x1_1(.Y(w_next_addr), .IN0(w_next_addr_sum), .IN1(mem_addr), .S0(w_start_transfer_del));
register #(.N(32)) u_reg0(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_next_addr), .data_o(r_curr_addr), .ld(w_ld_next));

// trans_count
cond_sum16 u_cond_sum16_1(.A(r_trans_count), .B(16'hFFFF), .CIN(1'b0), .S(w_next_trans_count_sum), .COUT(/*unused*/));

mux2_16$ u_mux2_16_1(.Y(w_next_trans_count),.IN0(w_next_trans_count_sum),.IN1(num_transfers),.S0(w_start_transfer_del));

register #(.N(16)) u_reg1(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_next_trans_count), .data_o(r_trans_count), .ld(w_ld_next));

assign m_addr = r_curr_addr;

// m_strb generation
wire [3:0] temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8;
wire [3:0] w_strb_access1, w_strb_access2, w_strb_access3;

decoder2_4$ u_decoder2_4_1(.SEL(transfer_size_sum_lsb),.Y(temp1),.YBAR(/*unused*/));
assign temp2[3] = temp1[3];
or2$ u_or1(.in0(temp1[2]), .in1(temp1[3]), .out(temp2[2]));
or3$ u_or2(.in0(temp1[1]), .in1(temp1[2]), .in2(temp1[3]), .out(temp2[1]));
or4$ u_or3(.in0(temp1[0]), .in1(temp1[1]), .in2(temp1[2]), .in3(temp1[3]), .out(temp2[0]));

decoder2_4$ u_decoder2_4_2(.SEL(start_offset),.Y(temp3),.YBAR(/*unused*/));
assign temp4[0] = temp3[0];
or2$ u_or4(.in0(temp3[1]), .in1(temp3[0]), .out(temp4[1]));
or3$ u_or5(.in0(temp3[2]), .in1(temp3[1]), .in2(temp3[0]), .out(temp4[2]));
or4$ u_or6(.in0(temp3[3]), .in1(temp3[2]), .in2(temp3[1]), .in3(temp3[0]), .out(temp4[3]));

and2$ u_and2[3:0] (.in0(temp2[3:0]), .in1(temp4[3:0]), .out(temp7[3:0]));
mux2$ u_mux2_1[3:0] (.in0(temp4[3:0]), .in1(temp7[3:0]), .s0(w_num_trans_eq1), .outb(w_strb_access1[3:0]));

assign w_strb_access2 = 4'b1111;

decoder2_4$ u_decoder2_4_3(.SEL(end_offset),.Y(temp5),.YBAR(/*unused*/));
assign temp6[3] = temp5[3];
or2$ u_or7(.in0(temp5[2]), .in1(temp5[3]), .out(temp6[2]));
or3$ u_or8(.in0(temp5[1]), .in1(temp5[2]), .in2(temp5[3]), .out(temp6[1]));
or4$ u_or9(.in0(temp5[0]), .in1(temp5[1]), .in2(temp5[2]), .in3(temp5[3]), .out(temp6[0]));

assign w_strb_access3 = temp6;

mux3$ u_mux3[3:0] (.in0(w_strb_access1[3:0]), .in1(w_strb_access3[3:0]), .in2(w_strb_access2[3:0]), .s1(w_curr_st[1]), .s0(w_curr_st[0]), .outb(m_strb[3:0]));

// DMA-DISK interface
assign d_init = w_start_transfer_del;
assign d_done = w_curr_st_int;

// r_d_addr
cond_sum16 u_cond_sum16_2(.A({6'd0, r_d_addr}), .B(16'd1), .CIN(1'b0), .S(w_next_d_addr_sum), .COUT(/*unused*/));

mux2_16$ u_mux2_16_2(.Y(w_next_d_addr),.IN0(w_next_d_addr_sum),.IN1(16'd0),.S0(w_start_transfer_del));

register #(.N(10)) u_reg2(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_next_d_addr[9:0]), .data_o(r_d_addr), .ld(w_ld_next));

assign d_addr = r_d_addr;

// Interrupt generation
assign interrupt = w_curr_st_int;

eq_checker3 u_eq_checker3_1(.in1(w_curr_st[2:0]), .in2(INT), .eq_out(w_curr_st_int));

// DMA master controller fsm
dma_master_controller_fsm u_dma_master_controller_fsm(
  .clk(clk), 
  .rst_n(rst_n), 
  .curr_st(w_curr_st), 
  .start_transfer(start_transfer), 
  .d_ready(d_ready), 
  .num_trans_eq1(w_num_trans_eq1),
  .num_trans_eq2(w_num_trans_eq2),
  .trans_cnt_eq2(w_trans_cnt_eq2),
  .m_ack(m_ack),
  .int_clear(int_clear)
);

endmodule

