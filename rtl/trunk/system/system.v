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
/*
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
  .);
*/

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
      assign main_mem_page0[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[0].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page0[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[0].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page0[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[0].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page0[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[0].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen1
    for (j=0; j < 8; j=j+1) begin : col_gen1
      assign main_mem_page1[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[1].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page1[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[1].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page1[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[1].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page1[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[1].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen2
    for (j=0; j < 8; j=j+1) begin : col_gen2
      assign main_mem_page2[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[2].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page2[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[2].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page2[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[2].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page2[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[2].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen3
    for (j=0; j < 8; j=j+1) begin : col_gen3
      assign main_mem_page3[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[3].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page3[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[3].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page3[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[3].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page3[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[3].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen4
    for (j=0; j < 8; j=j+1) begin : col_gen4
      assign main_mem_page4[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[4].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page4[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[4].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page4[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[4].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page4[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[4].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen5
    for (j=0; j < 8; j=j+1) begin : col_gen5
      assign main_mem_page5[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[5].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page5[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[5].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page5[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[5].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page5[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[5].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen6
    for (j=0; j < 8; j=j+1) begin : col_gen6
      assign main_mem_page6[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[6].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page6[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[6].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page6[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[6].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page6[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[6].col_gen[j].u_sram128x8_4.mem[k];
    end
  end
endgenerate

generate
  for (k=0; k < 128; k=k+1) begin : line_gen7
    for (j=0; j < 8; j=j+1) begin : col_gen7
      assign main_mem_page7[k*8+j][7:0] =   u_main_mem.u_mem_array.row_gen[7].col_gen[j].u_sram128x8_1.mem[k];
      assign main_mem_page7[k*8+j][15:8] =  u_main_mem.u_mem_array.row_gen[7].col_gen[j].u_sram128x8_2.mem[k];
      assign main_mem_page7[k*8+j][23:16] = u_main_mem.u_mem_array.row_gen[7].col_gen[j].u_sram128x8_3.mem[k];
      assign main_mem_page7[k*8+j][31:24] = u_main_mem.u_mem_array.row_gen[7].col_gen[j].u_sram128x8_4.mem[k];
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

/*
assign AL  = u_cpu.u_regfile.loop2[0].u_reg0.data_o;
assign AH  = u_cpu.u_regfile.loop2[0].u_reg1.data_o;
assign AX  = {AH,AL};
assign EAX = {u_cpu.u_regfile.loop2[0].u_reg3.data_o, u_cpu.u_regfile.loop2[0].u_reg2.data_o, AH, AL};

assign CL  = u_cpu.u_regfile.loop2[1].u_reg0.data_o;
assign CH  = u_cpu.u_regfile.loop2[1].u_reg1.data_o;
assign CX  = {CH,CL};
assign ECX = {u_cpu.u_regfile.loop2[1].u_reg3.data_o, u_cpu.u_regfile.loop2[1].u_reg2.data_o, CH, CL};

assign DL  = u_cpu.u_regfile.loop2[2].u_reg0.data_o;
assign DH  = u_cpu.u_regfile.loop2[2].u_reg1.data_o;
assign DX  = {DH,DL};
assign EDX = {u_cpu.u_regfile.loop2[2].u_reg3.data_o, u_cpu.u_regfile.loop2[2].u_reg2.data_o, DH, DL};

assign BL  = u_cpu.u_regfile.loop2[3].u_reg0.data_o;
assign BH  = u_cpu.u_regfile.loop2[3].u_reg1.data_o;
assign BX  = {BH,BL};
assign EBX = {u_cpu.u_regfile.loop2[3].u_reg3.data_o, u_cpu.u_regfile.loop2[3].u_reg3.data_o, BH, BL};

assign SP  = {u_cpu.u_regfile.loop2[4].u_reg1.data_o, u_cpu.u_regfile.loop2[4].u_reg0.data_o};
assign ESP = {u_cpu.u_regfile.loop2[4].u_reg3.data_o, u_cpu.u_regfile.loop2[4].u_reg2.data_o, SP};

assign BP  = {u_cpu.u_regfile.loop2[5].u_reg1.data_o, u_cpu.u_regfile.loop2[5].u_reg0.data_o};
assign EBP = {u_cpu.u_regfile.loop2[5].u_reg3.data_o, u_cpu.u_regfile.loop2[5].u_reg2.data_o, BP};

assign SI  = {u_cpu.u_regfile.loop2[6].u_reg1.data_o, u_cpu.u_regfile.loop2[6].u_reg0.data_o};
assign ESI = {u_cpu.u_regfile.loop2[6].u_reg3.data_o, u_cpu.u_regfile.loop2[6].u_reg2.data_o, SI};

assign DI  = {u_cpu.u_regfile.loop2[7].u_reg1.data_o, u_cpu.u_regfile.loop2[7].u_reg0.data_o};
assign EDI = {u_cpu.u_regfile.loop2[7].u_reg3.data_o, u_cpu.u_regfile.loop2[7].u_reg2.data_o, DI};

//MMX Registers

wire [63:0] MM0;
wire [63:0] MM1;
wire [63:0] MM2;
wire [63:0] MM3;
wire [63:0] MM4;
wire [63:0] MM5;
wire [63:0] MM6;
wire [63:0] MM7;

assign MM0 = u_cpu.u_mmx_regfile.loop2[0].data_o;
assign MM1 = u_cpu.u_mmx_regfile.loop2[1].data_o;
assign MM2 = u_cpu.u_mmx_regfile.loop2[2].data_o;
assign MM3 = u_cpu.u_mmx_regfile.loop2[3].data_o;
assign MM4 = u_cpu.u_mmx_regfile.loop2[4].data_o;
assign MM5 = u_cpu.u_mmx_regfile.loop2[5].data_o;
assign MM6 = u_cpu.u_mmx_regfile.loop2[6].data_o;
assign MM7 = u_cpu.u_mmx_regfile.loop2[7].data_o;

//Segment Registers

wire [15:0] ES;
wire [15:0] CS;
wire [15:0] SS;
wire [15:0] DS;
wire [15:0] FS;
wire [15:0] GS;

assign ES = u_cpu.u_seg_regfile.loop2[0].data_o;
assign CS = u_cpu.u_seg_regfile.loop2[1].data_o;
assign SS = u_cpu.u_seg_regfile.loop2[2].data_o;
assign DS = u_cpu.u_seg_regfile.loop2[3].data_o;
assign FS = u_cpu.u_seg_regfile.loop2[4].data_o;
assign GS = u_cpu.u_seg_regfile.loop2[5].data_o;
*/

endmodule

