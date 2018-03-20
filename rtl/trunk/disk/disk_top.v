/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: disk top level modeule                       */
/* Description: Disk with DMA interface                 */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module disk_top( clk, rst_n, s_cyc, s_we, s_strb, s_addr, s_data_i, s_ack, s_data_o, m_cyc, 
                 m_we, m_strb, m_addr, m_data_o, m_ack, m_data_i, interrupt, int_clear );

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

// Internal variables

wire [31:0] d_data;
wire [9:0]  d_addr;
wire        d_init;
wire        d_done;
wire        d_ready;

disk u_disk(
  .clk(clk), 
  .rst_n(rst_n), 
  .d_ready(d_ready), 
  .d_data(d_data), 
  .d_addr(d_addr),
  .d_init(d_init), 
  .d_done(d_done)
  );

dma u_dma(
  .clk(clk), 
  .rst_n(rst_n), 
  .s_cyc(s_cyc), 
  .s_we(s_we), 
  .s_strb(s_strb), 
  .s_addr(s_addr), 
  .s_data_i(s_data_i), 
  .s_ack(s_ack), 
  .s_data_o(s_data_o),
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
  .d_data_in(d_data), 
  .d_addr(d_addr),
  .d_init(d_init), 
  .d_done(d_done)
  );

endmodule
