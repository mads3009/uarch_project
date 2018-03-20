/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: DMA module with slave */
/* and master interface.              */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module dma ( clk, rst_n, s_cyc, s_we, s_strb, s_addr, s_data_i, s_ack, s_data_o, 
             m_cyc, m_we, m_strb, m_addr, m_data_o, m_ack, m_data_i, d_ready, 
             d_data_in, d_addr, d_init, d_done, interrupt, int_clear);

// Input and Output ports
input         clk;
input         rst_n;
input         int_clear;

output        interrupt;

// DMA slave interface
input         s_cyc;
input         s_we;
input  [3:0]  s_strb; // unused port as DMA slave write to all bytes in a 32-bit reg (default)
input  [31:0] s_addr;
input  [31:0] s_data_i;

output        s_ack;
output [31:0] s_data_o;

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

// Internal variables

wire [31:0] w_disk_addr;
wire [31:0] w_mem_addr;
wire [31:0] w_transfer_size;
wire [31:0] w_init_transfer;

dma_slave_if u_dma_slave_if(
  .clk(clk), 
  .rst_n(rst_n), 
  .s_cyc(s_cyc), 
  .s_we(s_we), 
  .s_strb(s_strb), 
  .s_addr(s_addr), 
  .s_data_i(s_data_i), 
  .s_ack(s_ack), 
  .s_data_o(s_data_o),
  .disk_addr(w_disk_addr), 
  .mem_addr(w_mem_addr), 
  .transfer_size(w_transfer_size), 
  .init_transfer(w_init_transfer)
  );

dma_master_if u_dma_master_if(
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
  .disk_addr(w_disk_addr), 
  .mem_addr(w_mem_addr), 
  .transfer_size(w_transfer_size), 
  .init_transfer(w_init_transfer)
  );

endmodule

