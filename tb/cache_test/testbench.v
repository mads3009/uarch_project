/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Description: Cache testbench                         */
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
wire        m_mmu_cyc;
wire        m_mmu_we;
wire [3:0]  m_mmu_strb;
wire [31:0] m_mmu_addr;
wire [31:0] m_mmu_data_o;

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


// ********** Hardcoded entries ***********
//TLB entries
reg [43:0] TLB[7:0]; 

//Segment_limit_Regs (In their order)
reg [19:0] ES_limit;
reg [19:0] CS_limit;
reg [19:0] SS_limit;
reg [19:0] DS_limit;
reg [19:0] FS_limit;
reg [19:0] GS_limit;


//Fetch TLB lookup
fetch_TLB_lookup u_fe_tlb_lookup(
  .TLB({TLB[7], TLB[6], TLB[5], TLB[4], TLB[3], TLB[2], TLB[1], TLB[0]}),  
  .CS_limit     (CS_limit),
  .f_ren        (w_fe_ren),
  .f_address    (w_fe_address),  
  .f_PFN        (w_fe_PFN),
  .ic_prot_exp  (w_ic_prot_exp),
  .ic_page_fault(w_ic_page_fault)
);

or2$ u_ic_exp(.out(w_ic_exp), .in0(w_ic_prot_exp), .in1(w_ic_page_fault));

//Instruction cache
i_cache u_i_cache (
  .clk          (clk),
  .rst_n        (rst_n),
  .ren          (w_fe_ren),
  .index        (w_fe_address_off[8:5]),
  .tag_14_12    (w_fe_PFN),
  .tag_11_9     (w_fe_address_off[11:9]),
  .ic_fill_data (w_ic_data_fill),
  .ic_miss_ack  (w_ic_miss_ack),
  .ic_exp       (w_ic_exp),
  .r_data       ({w_icache_upper_data,w_icache_lower_data}),
  .ic_hit       (w_ic_hit),
  .ic_miss      (w_ic_miss),
  .ic_miss_addr (w_ic_miss_addr)
);              


//MMU
mmu u_mmu( 
  .clk(clk), 
  .rst_n(rst_n), 
  .ic_miss(w_ic_miss), 
  .ic_miss_addr(w_ic_miss_addr), 
  .ic_data_fill(w_ic_data_fill), 
  .ic_miss_ack(w_ic_miss_ack), 
  .dc_miss(w_dc_miss), 
  .dc_miss_addr(w_dc_miss_addr), 
  .dc_data_fill(w_dc_data_fill), 
  .dc_miss_ack(w_dc_miss_ack), 
  .io_access(w_io_access), 
  .io_rw(w_io_rw), 
  .io_addr(w_io_addr), 
  .io_wr_data(w_io_wr_data), 
  .io_rd_data(w_io_rd_data), 
  .io_ack(w_io_ack), 
  .dc_evict(w_dc_evict), 
  .dc_evict_addr(w_dc_evict_addr), 
  .dc_evict_data(w_dc_evict_data), 
  .ld_ro(w_ld_ro), 
  .m_cyc(mmu_cyc), 
  .m_we(mmu_we), 
  .m_strb(mmu_strb), 
  .m_addr(mmu_addr), 
  .m_data_o(mmu_data_o), 
  .m_ack(mmu_ack), 
  .m_data_i(mmu_data_i)
  );

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



/////////////////////////////////////
// Clock generation
/////////////////////////////////////

always #5 clk <= ~clk;



endmodule

