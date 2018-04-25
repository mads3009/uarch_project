/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: System on Chip                               */
/* Description: SoC with Main memory, DMA, keyboard,    */
/* wishbone bus and CPU.                                */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module system(clk, rst_n);

// system ports
input clk;
input rst_n;

// Internal variables
wire        int_clear;
wire        int;

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
  .interrupt(int), 
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
// CPU instantiation
/////////////////////////////////////

cpu u_cpu(
  .clk(clk),
  .rst_n(rst_n),
  .int(int),
  .int_clear(int_clear),
  // MMU master port
  .m_cyc(m_mmu_cyc), 
  .m_we(m_mmu_we), 
  .m_strb(m_mmu_strb), 
  .m_addr(m_mmu_addr),  
  .m_data_o(m_mmu_data_o),
  .m_ack(m_mmu_ack), 
  .m_data_i(m_mmu_data_i)
  );

/////////////////////////////////////
// State variables
/////////////////////////////////////

//Main Memory 

wire [31:0] main_mem_page0[1023:0];
wire [31:0] main_mem_page1[1023:0];
wire [31:0] main_mem_page2[1023:0];
wire [31:0] main_mem_page3[1023:0];
wire [31:0] main_mem_page4[1023:0];
wire [31:0] main_mem_page5[1023:0];
wire [31:0] main_mem_page6[1023:0];
wire [31:0] main_mem_page7[1023:0];

genvar j,k;

generate
  for (k=0; k < 128; k=k+1) begin : line_gen0
    for (j=0; j < 8; j=j+1) begin : col_gen0
      assign main_mem_page0[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page0[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page0[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page0[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen1
    for (j=0; j < 8; j=j+1) begin : col_gen1
      assign main_mem_page1[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page1[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page1[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page1[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen2
    for (j=0; j < 8; j=j+1) begin : col_gen2
      assign main_mem_page2[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page2[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page2[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page2[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen3
    for (j=0; j < 8; j=j+1) begin : col_gen3
      assign main_mem_page3[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page3[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page3[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page3[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen4
    for (j=0; j < 8; j=j+1) begin : col_gen4
      assign main_mem_page4[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page4[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page4[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page4[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen5
    for (j=0; j < 8; j=j+1) begin : col_gen5
      assign main_mem_page5[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page5[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page5[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page5[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen6
    for (j=0; j < 8; j=j+1) begin : col_gen6
      assign main_mem_page6[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page6[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page6[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page6[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen7
    for (j=0; j < 8; j=j+1) begin : col_gen7
      assign main_mem_page7[k*8+j][7:0] =   u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page7[k*8+j][15:8] =  u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page7[k*8+j][23:16] = u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page7[k*8+j][31:24] = u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

//Registers

wire [31:0] EAX;
wire [31:0] ECX;
wire [31:0] EDX;
wire [31:0] EBX;
wire [31:0] ESP;
wire [31:0] EBP;
wire [31:0] ESI;
wire [31:0] EDI;
wire [15:0] AX;
wire [15:0] CX;
wire [15:0] DX;
wire [15:0] BX;
wire [15:0] SP;
wire [15:0] BP;
wire [15:0] SI;
wire [15:0] DI;
wire  [7:0] AL; 
wire  [7:0] AH; 
wire  [7:0] CL; 
wire  [7:0] CH; 
wire  [7:0] DL; 
wire  [7:0] DH; 
wire  [7:0] BL; 
wire  [7:0] BH; 

assign AL  = u_cpu.u_regfile.reg_loop.loop2[0].u_reg0.data_o;
assign AH  = u_cpu.u_regfile.reg_loop.loop2[0].u_reg1.data_o;
assign AX  = {AH,AL};
assign EAX = {u_cpu.u_regfile.reg_loop.loop2[0].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[0].u_reg2.data_o, AH, AL};

assign CL  = u_cpu.u_regfile.reg_loop.loop2[1].u_reg0.data_o;
assign CH  = u_cpu.u_regfile.reg_loop.loop2[1].u_reg1.data_o;
assign CX  = {CH,CL};
assign ECX = {u_cpu.u_regfile.reg_loop.loop2[1].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[1].u_reg2.data_o, CH, CL};

assign DL  = u_cpu.u_regfile.reg_loop.loop2[2].u_reg0.data_o;
assign DH  = u_cpu.u_regfile.reg_loop.loop2[2].u_reg1.data_o;
assign DX  = {DH,DL};
assign EDX = {u_cpu.u_regfile.reg_loop.loop2[2].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[2].u_reg2.data_o, DH, DL};

assign BL  = u_cpu.u_regfile.reg_loop.loop2[3].u_reg0.data_o;
assign BH  = u_cpu.u_regfile.reg_loop.loop2[3].u_reg1.data_o;
assign BX  = {BH,BL};
assign EBX = {u_cpu.u_regfile.reg_loop.loop2[3].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[3].u_reg2.data_o, BH, BL};

assign SP  = {u_cpu.u_regfile.reg_loop.loop2[4].u_reg1.data_o, u_cpu.u_regfile.reg_loop.loop2[4].u_reg0.data_o};
assign ESP = {u_cpu.u_regfile.reg_loop.loop2[4].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[4].u_reg2.data_o, SP};

assign BP  = {u_cpu.u_regfile.reg_loop.loop2[5].u_reg1.data_o, u_cpu.u_regfile.reg_loop.loop2[5].u_reg0.data_o};
assign EBP = {u_cpu.u_regfile.reg_loop.loop2[5].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[5].u_reg2.data_o, BP};

assign SI  = {u_cpu.u_regfile.reg_loop.loop2[6].u_reg1.data_o, u_cpu.u_regfile.reg_loop.loop2[6].u_reg0.data_o};
assign ESI = {u_cpu.u_regfile.reg_loop.loop2[6].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[6].u_reg2.data_o, SI};

assign DI  = {u_cpu.u_regfile.reg_loop.loop2[7].u_reg1.data_o, u_cpu.u_regfile.reg_loop.loop2[7].u_reg0.data_o};
assign EDI = {u_cpu.u_regfile.reg_loop.loop2[7].u_reg3.data_o, u_cpu.u_regfile.reg_loop.loop2[7].u_reg2.data_o, DI};

//MMX Registers
wire [63:0] MM0;
wire [63:0] MM1;
wire [63:0] MM2;
wire [63:0] MM3;
wire [63:0] MM4;
wire [63:0] MM5;
wire [63:0] MM6;
wire [63:0] MM7;

assign MM0 = u_cpu.u_mmx_regfile.mmx_loop.loop2[0].u_mm_reg.data_o;
assign MM1 = u_cpu.u_mmx_regfile.mmx_loop.loop2[1].u_mm_reg.data_o;
assign MM2 = u_cpu.u_mmx_regfile.mmx_loop.loop2[2].u_mm_reg.data_o;
assign MM3 = u_cpu.u_mmx_regfile.mmx_loop.loop2[3].u_mm_reg.data_o;
assign MM4 = u_cpu.u_mmx_regfile.mmx_loop.loop2[4].u_mm_reg.data_o;
assign MM5 = u_cpu.u_mmx_regfile.mmx_loop.loop2[5].u_mm_reg.data_o;
assign MM6 = u_cpu.u_mmx_regfile.mmx_loop.loop2[6].u_mm_reg.data_o;
assign MM7 = u_cpu.u_mmx_regfile.mmx_loop.loop2[7].u_mm_reg.data_o;

//Segment Registers
wire [15:0] ES;
wire [15:0] CS;
wire [15:0] SS;
wire [15:0] DS;
wire [15:0] FS;
wire [15:0] GS;

assign ES = u_cpu.u_seg_regfile.seg_loop.loop2[0].u_seg_reg.data_o;
assign CS = u_cpu.u_seg_regfile.seg_loop.loop2[1].u_seg_reg.data_o;
assign SS = u_cpu.u_seg_regfile.seg_loop.loop2[2].u_seg_reg.data_o;
assign DS = u_cpu.u_seg_regfile.seg_loop.loop2[3].u_seg_reg.data_o;
assign FS = u_cpu.u_seg_regfile.seg_loop.loop2[4].u_seg_reg.data_o;
assign GS = u_cpu.u_seg_regfile.seg_loop.loop2[5].u_seg_reg.data_o;

localparam sys_CF=4'd0;
localparam sys_PF=4'd2;
localparam sys_AF=4'd4;
localparam sys_ZF=4'd6;
localparam sys_SF=4'd7;
localparam sys_DF=4'd10;
localparam sys_OF=4'd11;

wire CF;
wire AF;
wire PF;
wire SF;
wire ZF;
wire DF;
wire OF;

assign CF = u_cpu.r_EFLAGS[sys_CF];
assign PF = u_cpu.r_EFLAGS[sys_PF];
assign AF = u_cpu.r_EFLAGS[sys_AF];
assign ZF = u_cpu.r_EFLAGS[sys_ZF];
assign SF = u_cpu.r_EFLAGS[sys_SF];
assign DF = u_cpu.r_EFLAGS[sys_DF];
assign OF = u_cpu.r_EFLAGS[sys_OF];

//DCACHE
wire [16*8-1:0] dcache[31:0];
generate
  for (k=0; k < 4; k=k+1) begin : d_row
    for (j=0; j < 16; j=j+1) begin : d_col
      assign dcache[k*8+0][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[0];
      assign dcache[k*8+1][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[1];
      assign dcache[k*8+2][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[2];
      assign dcache[k*8+3][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[3];
      assign dcache[k*8+4][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[4];
      assign dcache[k*8+5][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[5];
      assign dcache[k*8+6][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[6];
      assign dcache[k*8+7][8*j+7:8*j] =   u_cpu.u_dcache.u_dc_data_store.row_gen[k].col_gen[j].u_ram8b8w$.mem[7];
    end
  end
endgenerate

//ICACHE
wire [32*8-1:0] icache[15:0];
generate
    for (j=0; j < 32; j=j+1) begin : i_col0
      assign icache[0][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[0];
      assign icache[1][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[1];
      assign icache[2][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[2];
      assign icache[3][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[3];
      assign icache[4][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[4];
      assign icache[5][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[5];
      assign icache[6][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[6];
      assign icache[7][8*j+7:8*j] =   u_cpu.u_i_cache.ds.lower_ram.loop.mem_gen[j].ram_forcache.mem[7];
    end
    for (j=0; j < 32; j=j+1) begin : i_col1
      assign icache[8+0][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[0];
      assign icache[8+1][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[1];
      assign icache[8+2][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[2];
      assign icache[8+3][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[3];
      assign icache[8+4][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[4];
      assign icache[8+5][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[5];
      assign icache[8+6][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[6];
      assign icache[8+7][8*j+7:8*j] =   u_cpu.u_i_cache.ds.upper_ram.loop.mem_gen[j].ram_forcache.mem[7];
    end
endgenerate

endmodule

