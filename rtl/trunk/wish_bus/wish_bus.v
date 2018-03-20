/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: bus crossbar                                 */
/* Description: Bus interconnect crossbar between DMA   */
/* master port & MMU master port and DMA slave port,    */
/* Keyboard (Simple IO) & Main memory.                  */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module wish_bus ( clk, rst_n, m_mmu_cyc, m_mmu_we, m_mmu_strb,
                  m_mmu_addr, m_mmu_data_i, m_mmu_ack, m_mmu_data_o,
                  m_dma_cyc, m_dma_we, m_dma_strb, m_dma_addr,
                  m_dma_data_i, m_dma_ack, m_dma_data_o, s_mem_cyc,
                  s_mem_we, s_mem_strb, s_mem_addr, s_mem_data_i,
                  s_mem_ack, s_mem_data_o, s_dma_cyc, s_dma_we,
                  s_dma_strb, s_dma_addr, s_dma_data_i, s_dma_ack,
                  s_dma_data_o, s_key_cyc, s_key_we, s_key_strb,
                  s_key_addr, s_key_data_i, s_key_ack, s_key_data_o );

// system ports
input         clk;
input         rst_n;

// MMU master port
input         m_mmu_cyc;
input         m_mmu_we;
input  [3:0]  m_mmu_strb;
input  [31:0] m_mmu_addr;
input  [31:0] m_mmu_data_i;

output        m_mmu_ack;
output [31:0] m_mmu_data_o;

// DMA master port
input         m_dma_cyc;
input         m_dma_we;
input  [3:0]  m_dma_strb;
input  [31:0] m_dma_addr;
input  [31:0] m_dma_data_i;

output        m_dma_ack;
output [31:0] m_dma_data_o;

// Main memory slave port
output        s_mem_cyc;
output        s_mem_we;
output [3:0]  s_mem_strb;
output [31:0] s_mem_addr;
output [31:0] s_mem_data_o;

input         s_mem_ack;
input [31:0]  s_mem_data_i;

// DMA slave port
output        s_dma_cyc;
output        s_dma_we;
output [3:0]  s_dma_strb;
output [31:0] s_dma_addr;
output [31:0] s_dma_data_o;

input         s_dma_ack;
input [31:0]  s_dma_data_i;

// Keyboard slave port
output         s_key_cyc;
output         s_key_we;
output  [3:0]  s_key_strb;
output  [31:0] s_key_addr;
output  [31:0] s_key_data_o;

input          s_key_ack;
input [31:0]   s_key_data_i;

// Internal variables

wire         m_cyc;
wire         m_we;
wire  [3:0]  m_strb;
wire  [31:0] m_addr;
wire  [31:0] m_data_i;

wire         s_ack;
wire [31:0]  s_data_i;

wire [2:0]   curr_st;

mux2$ u_mux2_1 (.in0(m_mmu_cyc), .in1(m_dma_cyc), .outb(m_cyc), .s0(curr_st[2]));
mux2$ u_mux2_2 (.in0(m_mmu_we), .in1(m_dma_we), .outb(m_we), .s0(curr_st[2]));
mux2$ u_mux2_3[3:0] (.in0(m_mmu_strb[3:0]), .in1(m_dma_strb[3:0]), .outb(m_strb[3:0]), .s0(curr_st[2]));
mux2$ u_mux2_4[31:0] (.in0(m_mmu_addr[31:0]), .in1(m_dma_addr[31:0]), .outb(m_addr[31:0]), .s0(curr_st[2]));
mux2$ u_mux2_5[31:0] (.in0(m_mmu_data_i[31:0]), .in1(m_dma_data_i[31:0]), .outb(m_data_i[31:0]), .s0(curr_st[2]));

assign s_dma_cyc    = m_cyc;
assign s_dma_we     = m_we;
assign s_dma_strb   = m_strb;
assign s_dma_addr   = m_addr;
assign s_dma_data_o = m_data_i;

assign s_mem_cyc    = m_cyc;
assign s_mem_we     = m_we;
assign s_mem_strb   = m_strb;
assign s_mem_addr   = m_addr;
assign s_mem_data_o = m_data_i;

assign s_key_cyc    = m_cyc;
assign s_key_we     = m_we;
assign s_key_strb   = m_strb;
assign s_key_addr   = m_addr;
assign s_key_data_o = m_data_i;

mux3$ u_mux3_1(.in0(s_mem_ack), .in1(s_dma_ack), .in2(s_key_ack), .s0(m_addr[31]), .s1(m_addr[30]), .outb(s_ack));
mux3$ u_mux3_2[31:0] (.in0(s_mem_data_i[31:0]), .in1(s_dma_data_i[31:0]), .in2(s_key_data_i[31:0]), .s0(m_addr[31]), .s1(m_addr[30]), .outb(s_data_i[31:0]));

mux2$ u_mux2_6[31:0] (.in0(s_data_i[31:0]), .in1(32'd0), .outb(m_mmu_data_o[31:0]), .s0(curr_st[2]));
mux2$ u_mux2_7 (.in0(s_ack), .in1(1'd0), .outb(m_mmu_ack), .s0(curr_st[2]));

mux2$ u_mux2_8[31:0] (.in1(s_data_i[31:0]), .in0(32'd0), .outb(m_dma_data_o[31:0]), .s0(curr_st[2]));
mux2$ u_mux2_9 (.in1(s_ack), .in0(1'd0), .outb(m_dma_ack), .s0(curr_st[2]));

wish_fsm u_wish_fsm(
  .clk(clk), 
  .rst_n(rst_n),
  .m_mmu_cyc(m_mmu_cyc),
  .m_dma_cyc(m_dma_cyc),
  .m_mmu_ack(m_mmu_ack),
  .m_dma_ack(m_dma_ack),
  .curr_st(curr_st)
  );

endmodule
