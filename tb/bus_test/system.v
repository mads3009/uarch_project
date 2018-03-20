/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: disk top level modeule                       */
/* Description: System level testbench to verify bus.   */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module testbench();

// Parameters

parameter ADDR_DMA_REG_DISK_ADDR = 32'h8000_0000;
parameter ADDR_DMA_REG_MEM_ADDR  = 32'h8000_0004;
parameter ADDR_DMA_REG_T_SIZE    = 32'h8000_0008;
parameter ADDR_DMA_REG_INIT_TRAN = 32'h8000_000C;

parameter ADDR_KEY_REG_POL_STAT = 32'hC000_0000;
parameter ADDR_KEY_REG_KEY_VAL  = 32'hC000_0004;

parameter ADDR_MAIN_MEM_MIN = 32'h0000_0000;
parameter ADDR_MAIN_MEM_MAX = 32'h0000_7FFF;

// system ports
reg         clk;
reg         rst_n;
reg         int_clear;
wire        interrupt;

// MMU master port
reg         m_mmu_cyc;
reg         m_mmu_we;
reg  [3:0]  m_mmu_strb;
reg  [31:0] m_mmu_addr;
reg  [31:0] m_mmu_data_o;

wire        m_mmu_ack;
wire [31:0] m_mmu_data_i;

// DMA master port
wire        m_dma_cyc;
wire        m_dma_we;
wire [3:0]  m_dma_strb;
wire [31:0] m_dma_addr;
wire [31:0] m_dma_data_o;

wire        m_dma_ack;
wire [31:0] m_dma_data_i;

// Main memory slave port
wire        s_mem_cyc;
wire        s_mem_we;
wire [3:0]  s_mem_strb;
wire [31:0] s_mem_addr;
wire [31:0] s_mem_data_o;

wire        s_mem_ack;
wire [31:0] s_mem_data_i;

// DMA slave port
wire        s_dma_cyc;
wire        s_dma_we;
wire [3:0]  s_dma_strb;
wire [31:0] s_dma_addr;
wire [31:0] s_dma_data_o;

wire        s_dma_ack;
wire [31:0] s_dma_data_i;

// Keyboard slave port
wire        s_key_cyc;
wire        s_key_we;
wire [3:0]  s_key_strb;
wire [31:0] s_key_addr;
wire [31:0] s_key_data_o;

wire        s_key_ack;
wire [31:0] s_key_data_i;

/////////////////////////////////////
// Bus instantiation
/////////////////////////////////////

wish_bus u_wish_bus( 
  .clk(clk), 
  .rst_n(rst_n), 
  // MMU Master port
  .m_mmu_cyc(m_mmu_cyc), 
  .m_mmu_we(m_mmu_we), 
  .m_mmu_strb(m_mmu_strb),
  .m_mmu_addr(m_mmu_addr), 
  .m_mmu_data_i(m_mmu_data_o), 
  .m_mmu_ack(m_mmu_ack), 
  .m_mmu_data_o(m_mmu_data_i),
  // DMA master port
  .m_dma_cyc(m_dma_cyc), 
  .m_dma_we(m_dma_we), 
  .m_dma_strb(m_dma_strb), 
  .m_dma_addr(m_dma_addr),
  .m_dma_data_i(m_dma_data_o), 
  .m_dma_ack(m_dma_ack), 
  .m_dma_data_o(m_dma_data_i), 
  // Memory slave port
  .s_mem_cyc(s_mem_cyc),
  .s_mem_we(s_mem_we), 
  .s_mem_strb(s_mem_strb), 
  .s_mem_addr(s_mem_addr), 
  .s_mem_data_o(s_mem_data_o), 
  .s_mem_ack(s_mem_ack), 
  .s_mem_data_i(s_mem_data_i),
  // DMA slave port
  .s_dma_cyc(s_dma_cyc), 
  .s_dma_we(s_dma_we),
  .s_dma_strb(s_dma_strb), 
  .s_dma_addr(s_dma_addr), 
  .s_dma_data_o(s_dma_data_o), 
  .s_dma_ack(s_dma_ack),
  .s_dma_data_i(s_dma_data_i), 
  // Keyboard slave port
  .s_key_cyc(s_key_cyc), 
  .s_key_we(s_key_we), 
  .s_key_strb(s_key_strb),
  .s_key_addr(s_key_addr), 
  .s_key_data_o(s_key_data_o),
  .s_key_ack(s_key_ack), 
  .s_key_data_i(s_key_data_i)
  );

/////////////////////////////////////
// Main memory module
/////////////////////////////////////

main_mem u_main_mem(
  .clk(clk),
  .rst_n(rst_n),
  .s_cyc(s_mem_cyc),
  .s_we(s_mem_we),
  .s_strb(s_mem_strb), 
  .s_addr(s_mem_addr), 
  .s_data_i(s_mem_data_o), 
  .s_ack(s_mem_ack), 
  .s_data_o(s_mem_data_i)
  );

/////////////////////////////////////
// Simple IO device
// Keyboard instantiation
/////////////////////////////////////

keyboard u_keyboard(
  .clk(clk),
  .rst_n(rst_n),
  .s_cyc(s_key_cyc),
  .s_we(s_key_we),
  .s_strb(s_key_strb), 
  .s_addr(s_key_addr), 
  .s_data_i(s_key_data_o), 
  .s_ack(s_key_ack), 
  .s_data_o(s_key_data_i)
  );

/////////////////////////////////////
// Complex IO device
// DISK with DMA instantiation
/////////////////////////////////////
 
disk_top u_disk_top(
  .clk(clk), 
  .rst_n(rst_n),
  .interrupt(interrupt), 
  .int_clear(int_clear),
  // DMA slave port
  .s_cyc(s_dma_cyc), 
  .s_we(s_dma_we), 
  .s_strb(s_dma_strb), 
  .s_addr(s_dma_addr), 
  .s_data_i(s_dma_data_o), 
  .s_ack(s_dma_ack), 
  .s_data_o(s_dma_data_i),
  // DMA master port
  .m_cyc(m_dma_cyc), 
  .m_we(m_dma_we), 
  .m_strb(m_dma_strb), 
  .m_addr(m_dma_addr),  
  .m_data_o(m_dma_data_o),
  .m_ack(m_dma_ack), 
  .m_data_i(m_dma_data_i)
  );

/////////////////////////////////////
// State variables
/////////////////////////////////////


wire [31:0] main_mem[4095:0];

genvar i,j,k;
generate
  for (i=0; i < 4; i=i+1) begin : row_gen
    for (k=0; k < 128; k=k+1) begin : line_gen
      for (j=0; j < 8; j=j+1) begin : col_gen
        assign main_mem[1024*i+k*8+j][7:0] = u_main_mem.u_mem_array.row_gen[i].col_gen[j].u_sram128x8_1.mem[k];
        assign main_mem[1024*i+k*8+j][15:8] = u_main_mem.u_mem_array.row_gen[i].col_gen[j].u_sram128x8_2.mem[k];
        assign main_mem[1024*i+k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[i].col_gen[j].u_sram128x8_3.mem[k];
        assign main_mem[1024*i+k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[i].col_gen[j].u_sram128x8_4.mem[k];
      end
    end
  end
endgenerate

/////////////////////////////////////
// Testbench
/////////////////////////////////////

initial begin
  clk = 1'b0;
  rst_n = 1'b0;
  int_clear = 1'b0;
  m_mmu_cyc = 1'b0;
  m_mmu_we  = 1'b0;
  m_mmu_strb = 4'd0;
  m_mmu_addr = 32'd0;
  m_mmu_data_o = 32'd0;
  #100;
  rst_n = 1'b1;
  #100;
  mmu_write(ADDR_DMA_REG_DISK_ADDR, 32'hDEAD_BEEF);
  mmu_write(ADDR_DMA_REG_MEM_ADDR, 32'h0000_0001);
  mmu_write(ADDR_DMA_REG_T_SIZE, 32'd21);
  mmu_write(ADDR_DMA_REG_INIT_TRAN, 32'd1);
  #10000;
  $finish;
end

/////////////////////////////////////
// Clock generation
/////////////////////////////////////

always #3.5 clk <= ~clk;

/////////////////////////////////////
// Tasks
/////////////////////////////////////

task mmu_write;
input [31:0] addr;
input [31:0] data;
begin
  @(posedge clk);
  #0.1;
  m_mmu_cyc = 1'b1;
  m_mmu_we  = 1'b1;
  m_mmu_strb = 4'b1111;
  m_mmu_addr = addr;
  m_mmu_data_o = data;
  @(posedge clk);
  #0.1;
  m_mmu_cyc = 1'b0;
  m_mmu_we  = 1'b0;
  m_mmu_strb = 4'b0000;
end
endtask


endmodule

