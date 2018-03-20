/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: DMA master interface   */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module dma_master_if( clk, rst_n, m_cyc, m_we, m_strb, m_addr, m_data_o, m_ack, m_data_i, 
                      d_ready, d_data_in, d_addr, d_init, d_done, disk_addr, mem_addr,
                      transfer_size, init_transfer, interrupt, int_clear);
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

// DMA master-slave interface
input [31:0] disk_addr;
input [31:0] mem_addr;
input [31:0] transfer_size;
input [31:0] init_transfer;

// Internal Variables
wire         w_init_transfer_del;
wire         w_init_transfer_del_bar;
wire         w_start_transfer;

wire [1:0]   w_start_offset;
wire [1:0]   w_end_offset;
wire [31:0]  w_end_mem_addr;
wire [15:0]  w_transfer_size_sum;
wire [15:0]  w_num_transfers;
wire         w_transfer_size_sum01;

wire  [1:0]  r_start_offset;
wire  [1:0]  r_end_offset;
wire  [15:0] r_num_transfers;
wire  [1:0]  r_transfer_size_sum_lsb;

// Logic for start_transfer
dff$ init_trans_reg (.r(rst_n), .s(1'b1), .clk(clk), .d(init_transfer[0]), .q(w_init_transfer_del), .qbar(/*Unused*/));
inv1$ u_inv1(.in(w_init_transfer_del), .out(w_init_transfer_del_bar));
and2$ u_and1(.in0(init_transfer[0]), .in1(w_init_transfer_del_bar), .out(w_start_transfer));

// Logic to compute start_offset, end_offset and num_transfers 
assign w_start_offset = mem_addr[1:0];

wallace_abc_adder u_wallace_adder(.A(mem_addr), .B(transfer_size), .C(32'hFFFF_FFFF), .CIN(1'b0), .S(w_end_mem_addr));

assign w_end_offset = w_end_mem_addr[1:0];

cond_sum16 u_cond_sum16_1(.A(transfer_size[15:0]), .B({14'd0, w_start_offset}), .CIN(1'b0), .S(w_transfer_size_sum), .COUT(/*unused*/));
or2$ u_or1(.in0(w_transfer_size_sum[1]), .in1(w_transfer_size_sum[0]), .out(w_transfer_size_sum01));
cond_sum16 u_cond_sum16_2(.A({2'd0, w_transfer_size_sum[15:2]}), .B({15'd0, w_transfer_size_sum01}), .CIN(1'b0), .S(w_num_transfers), .COUT(/*unused*/));

register #(.N(2)) u_reg0(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_start_offset), .data_o(r_start_offset), .ld(w_start_transfer));
register #(.N(2)) u_reg1(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_end_offset), .data_o(r_end_offset), .ld(w_start_transfer));
register #(.N(16)) u_reg2(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_num_transfers), .data_o(r_num_transfers), .ld(w_start_transfer));
register #(.N(2)) u_reg3(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_transfer_size_sum[1:0]), .data_o(r_transfer_size_sum_lsb), .ld(w_start_transfer));

dma_master_controller u_dma_master_controller(
  .clk(clk), 
  .rst_n(rst_n), 
  .interrupt(interrupt), 
  .int_clear(int_clear),
  .m_cyc(m_cyc), 
  .m_we(m_we), 
  .m_strb(m_strb), 
  .m_addr(m_addr), 
  .m_data_i(m_data_i), 
  .m_ack(m_ack), 
  .m_data_o(m_data_o),
  .d_ready(d_ready), 
  .d_data_in(d_data_in),
  .d_addr(d_addr), 
  .d_init(d_init), 
  .d_done(d_done),
  .disk_addr(disk_addr), 
  .mem_addr(mem_addr), 
  .num_transfers(r_num_transfers),
  .transfer_size_sum_lsb(r_transfer_size_sum_lsb),
  .start_transfer(w_start_transfer),
  .start_offset(r_start_offset),
  .end_offset(r_end_offset)
  );

endmodule

