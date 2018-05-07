/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Top level testbench for SoC                  */
/********************************************************/

module testbench;

// Parameters

parameter ADDR_DMA_REG_DISK_ADDR = 32'h8000_0000;
parameter ADDR_DMA_REG_MEM_ADDR  = 32'h8000_0004;
parameter ADDR_DMA_REG_T_SIZE    = 32'h8000_0008;
parameter ADDR_DMA_REG_INIT_TRAN = 32'h8000_000C;

parameter ADDR_KEY_REG_POL_STAT = 32'hC000_0000;
parameter ADDR_KEY_REG_KEY_VAL  = 32'hC000_0004;

parameter ADDR_MAIN_MEM_MIN = 32'h0000_0000;
parameter ADDR_MAIN_MEM_MAX = 32'h0000_7FFF;

//system ports
reg         clk;
reg         rst_n;

integer i,j,k;

initial begin
  clk = 1'b1;
  rst_n = 1'b0;
  #100;
  rst_n = 1'b1;

  #20000;

  $display("");
  $finish;
end

/////////////////////////////////////
// Clock generation
/////////////////////////////////////

always #(11.8/2) clk <= ~clk;

//Instantiate the system
system u_system(
  .clk    (clk),
  .rst_n  (rst_n)
);


initial
begin
  $vcdplusfile("tb.vpd");
  $vcdplusmemon();
  $vcdpluson();
end 

wire [3:0] ld_reg1_strb;
wire [3:0] ld_reg2_strb;
wire [3:0] ld_reg3_strb;
wire [2:0] dreg1;
wire [2:0] dreg2;
wire [2:0] dreg3;
wire [2:0] dmm;
wire [2:0] dseg;

assign V_wb = u_system.u_cpu.r_V_wb;
assign ld_mm = u_system.u_cpu.w_v_wb_ld_mm;
assign ld_mem = u_system.u_cpu.w_v_wb_ld_mem;
assign ld_reg1 = testbench.u_system.u_cpu.w_v_wb_ld_reg1;
assign ld_reg2 = testbench.u_system.u_cpu.w_v_wb_ld_reg2;
assign ld_reg3 = testbench.u_system.u_cpu.w_v_wb_ld_reg3;
assign ld_reg1_strb = testbench.u_system.u_cpu.w_v_wb_ld_reg1_strb;
assign ld_reg2_strb = testbench.u_system.u_cpu.w_v_wb_ld_reg2_strb;
assign ld_reg3_strb = testbench.u_system.u_cpu.w_v_wb_ld_reg3_strb;
assign ld_seg = testbench.u_system.u_cpu.w_v_wb_ld_seg;
assign ld_CF = testbench.u_system.u_cpu.w_v_wb_ld_flag_CF;
assign ld_ZF = testbench.u_system.u_cpu.w_v_wb_ld_flag_ZF;
assign ld_OF = testbench.u_system.u_cpu.w_v_wb_ld_flag_OF;
assign ld_SF = testbench.u_system.u_cpu.w_v_wb_ld_flag_SF;
assign ld_PF = testbench.u_system.u_cpu.w_v_wb_ld_flag_PF;
assign ld_AF = testbench.u_system.u_cpu.w_v_wb_ld_flag_AF;
assign ld_DF = testbench.u_system.u_cpu.w_v_wb_ld_flag_DF;

assign dreg1 = testbench.u_system.u_cpu.r_wb_dreg1;
assign dreg2 = testbench.u_system.u_cpu.r_wb_dreg2;
assign dreg3 = testbench.u_system.u_cpu.r_wb_dreg3;
assign dmm = testbench.u_system.u_cpu.r_wb_dmm;
assign dseg = testbench.u_system.u_cpu.r_wb_dseg;

//Forcing EIP
reg [31:0] force_EIP;
initial begin
  if(!$value$plusargs("EIP=%h",force_EIP))
    force u_system.u_cpu.r_EIP = 32'h00;
  else
    force u_system.u_cpu.r_EIP = force_EIP;
    
  wait (rst_n);
  @(posedge clk)
  release u_system.u_cpu.r_EIP;
end

//Logging the test
always @(u_system.EAX,u_system.ECX,u_system.EDX,u_system.EBX,u_system.ESP,u_system.EBP,u_system.ESI,u_system.EDI) begin
  $display("Registers: EAX:%8h  ECX:%8h  EDX:%8h  EBX:%8h  ESP:%8h  EBP:%8h  ESI:%8h  EDI:%8h  ", u_system.EAX,  u_system.ECX,  u_system.EDX,  u_system.EBX,  u_system.ESP,  u_system.EBP,  u_system.ESI,  u_system.EDI); 
end

always @(u_system.CF, u_system.PF, u_system.AF, u_system.ZF, u_system.SF, u_system.OF, u_system.DF) begin
    $display("Flags: CF=%b  PF=%b  AF=%b  ZF=%b  SF=%b  OF=%b  DF=%b", u_system.CF, u_system.PF, u_system.AF, u_system.ZF, u_system.SF, u_system.OF, u_system.DF);
end

always @(u_system.MM0 , u_system.MM1 , u_system.MM2 , u_system.MM3 , u_system.MM4 , u_system.MM5 , u_system.MM6 , u_system.MM7)
    $display("MMX regs: MM0 = %h %h  MM1 = %h %h  MM2 = %h %h MM3 = %h %h MM4 = %h %h MM5 = %h %h MM6 = %h %h MM7 = %h %h ",
            u_system.MM0[63:32], u_system.MM0[31:0], u_system.MM1[63:32], u_system.MM1[31:0], u_system.MM2[63:32], u_system.MM2[31:0], u_system.MM3[63:32], u_system.MM3[31:0], u_system.MM4[63:32], u_system.MM4[31:0], u_system.MM5[63:32], u_system.MM5[31:0], u_system.MM6[63:32], u_system.MM6[31:0], u_system.MM7[63:32], u_system.MM7[31:0] );

always @(u_system.ES , u_system.CS , u_system.SS , u_system.DS , u_system.FS ,u_system.GS)
    $display("Segments: ES=%h  CS=%h  SS=%h  DS=%h  FS=%h  GS=%h ", u_system.ES, u_system.CS, u_system.SS, u_system.DS, u_system.FS, u_system.GS);

`ifndef NO_DEBUG
always @(posedge u_system.u_cpu.w_dc_evict) begin
  @(posedge clk)
  if(u_system.u_cpu.w_dc_evict)
    $display("EVICT dcache line with phy addr= 0x%h  Index=%h  Frame=%h", u_system.u_cpu.w_dc_evict_addr, u_system.u_cpu.w_dc_evict_addr[8:4], u_system.u_cpu.w_dc_evict_addr[14:12]);
end

always @(posedge u_system.u_cpu.u_dcache.mem_rd_ready) begin
  @(posedge clk)
  if(u_system.u_cpu.u_dcache.mem_rd_ready)
      $display("%0t MEM_READ_done : Addr=%h Size=%h: %h %h %h %h",$time, u_system.u_cpu.u_dcache.w_mem_rw_addr_curr, u_system.u_cpu.u_dcache.w_mem_rw_size, u_system.u_cpu.u_dcache.mem_rd_data[63:48],u_system.u_cpu.u_dcache.mem_rd_data[47:32],u_system.u_cpu.u_dcache.mem_rd_data[31:16],u_system.u_cpu.u_dcache.mem_rd_data[15:0]);
end

`endif

//DCACHE
genvar g;
generate begin : get_dcache
  for (g=0; g<16; g=g+1) begin : dcache2
    always @(u_system.dcache_way2[g]) begin
      $display("%0t DCACHE_way2 : Addr=%h Size=%h: Index=%2d %h %h %h %h",$time, u_system.u_cpu.u_dcache.w_mem_rw_addr_curr, u_system.u_cpu.u_dcache.w_mem_rw_size, g, u_system.dcache_way2[g][127:96], 
          u_system.dcache_way2[g][95:64], u_system.dcache_way2[g][63:32], u_system.dcache_way2[g][31:0]);
    end    
  end 
  for (g=0; g<16; g=g+1) begin : dcache1
    always @(u_system.dcache_way1[g]) begin
      $display("%0t DCACHE_way1 : Addr=%h Size=%h: Index=%2d %h %h %h %h",$time, u_system.u_cpu.u_dcache.w_mem_rw_addr_curr, u_system.u_cpu.u_dcache.w_mem_rw_size, g, u_system.dcache_way1[g][127:96],
          u_system.dcache_way1[g][95:64], u_system.dcache_way1[g][63:32], u_system.dcache_way1[g][31:0]);
    end    
  end 
end
endgenerate

`ifndef NO_DEBUG
generate begin : get_dtag
  for (g=0; g<16; g=g+1) begin : dtag1
    always @(u_system.dc_ts_way1[g]) begin
      $display("%0t DTAG_1 : Addr=%h : REN=%b Index=%2d  %h",$time, u_system.u_cpu.u_dcache.w_mem_rw_addr_curr, u_system.u_cpu.u_dcache.ren, g, u_system.dc_ts_way1[g]);
    end    
  end 
  for (g=0; g<16; g=g+1) begin : dtag2
    always @(u_system.dc_ts_way2[g]) begin
      $display("%0t DTAG_2 : Addr=%h : REN=%b Index=%2d  %h",$time, u_system.u_cpu.u_dcache.w_mem_rw_addr_curr, u_system.u_cpu.u_dcache.ren, g, u_system.dc_ts_way2[g]);
    end    
  end 
end
endgenerate
`endif

`ifndef NO_DEBUG
//ICACHE
generate begin : get_icache
  for (g=0; g<16; g=g+1) begin : icache
    always @(u_system.icache[g]) begin
      $display("%0t ICACHE %3d : %h %h %h %h",$time,g, u_system.icache[g][32*8-1:24*8] , u_system.icache[g][24*8-1:16*8] , u_system.icache[g][16*8-1:8*8] , u_system.icache[g][8*8-1:0]);
    end    
  end 
end
endgenerate
`endif

//Main memory
generate
  for (g=0; g < 1024; g=g+1) begin : mainmem
      always @(u_system.main_mem_page0[g])
        $display("%0t Frame0 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page0[g]);
      always @(u_system.main_mem_page1[g])
        $display("%0t Frame1 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page1[g]);
      always @(u_system.main_mem_page2[g])     
        $display("%0t Frame2 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page2[g]);
      always @(u_system.main_mem_page3[g])    
        $display("%0t Frame3 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page3[g]);
      always @(u_system.main_mem_page4[g])    
        $display("%0t Frame4 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page4[g]);
      always @(u_system.main_mem_page5[g])    
        $display("%0t Frame5 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page5[g]);
      always @(u_system.main_mem_page6[g])    
        $display("%0t Frame6 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page6[g]);
      always @(u_system.main_mem_page7[g])     
        $display("%0t Frame7 [0x%3h] : %h",$time,g<<2,u_system.main_mem_page7[g]);
    end
endgenerate

//Interrupt and exceptions
always @(u_system.u_cpu.int)
  $display("%0t INT changed. Val=%b", $time, u_system.u_cpu.int);

always @(posedge clk) begin
  if(u_system.u_cpu.w_dc_exp)
    $display("%0t DC EXCEPTION  EIP:0x%h  dc_prot_exp=%b  dc_pg_fault=%b", $time, u_system.u_cpu.r_ro_EIP_curr, u_system.u_cpu.w_dc_prot_exp, u_system.u_cpu.w_dc_page_fault);
  if(u_system.u_cpu.w_de_ic_exp & u_system.u_cpu.r_V_de)
    $display("%0t DE IC EXCEPTION  EIP:0x%h de_ic_prot_exp=%b  de_ic_pg_fault=%b", $time, u_system.u_cpu.r_EIP, u_system.u_cpu.w_de_ic_prot_exp, u_system.u_cpu.w_de_ic_page_fault);
  //if(u_system.u_cpu.w_fe_ic_exp)
  //  $display("%0t FE IC EXCEPTION  fe_ic_prot_exp=%b  fe_ic_pg_fault=%b", $time, u_system.u_cpu.w_fe_ic_prot_exp, u_system.u_cpu.w_fe_ic_page_fault);
end

`ifndef NO_DEBUG
//For every opcode in WB
always @(posedge clk) begin
 if(V_wb == 1'b1) begin
    $display("\n%0t Opcode= 0x%h  PC:0x%h",  $time, u_system.u_cpu.r_wb_opcode, u_system.u_cpu.r_ex_EIP_curr);

    //Printing registers
    if(ld_reg1 == 1'b1 && ld_reg2 == 1'b1 && ld_reg3 == 1'b1)
      $display("Load Reg1 :%b  (%d) Reg2 strbs:%b (%d) Reg3 strbs:%b (%d)", ld_reg1_strb, dreg1, ld_reg2_strb, dreg2, ld_reg3_strb, dreg3); 
    else if(ld_reg1 == 1'b1 && ld_reg2 == 1'b1)
      $display("Load Reg1 :%b  (%d) Reg2 strbs:%b (%d)", ld_reg1_strb, dreg1, ld_reg2_strb, dreg2); 
    else if(ld_reg1 == 1'b1 && ld_reg3 == 1'b1)
      $display("Load Reg1 :%b  (%d) Reg3 strbs:%b (%d)", ld_reg1_strb, dreg1, ld_reg3_strb, dreg3); 
    else if(ld_reg2 == 1'b1 && ld_reg3 == 1'b1)
      $display("Load Reg2 :%b  (%d) Reg3 strbs:%b (%d)", ld_reg2_strb, dreg2, ld_reg3_strb, dreg3); 
    else if(ld_reg1 == 1'b1)
      $display("Load Reg1 : %b (%d)", ld_reg1_strb, dreg1); 
    else if(ld_reg2 == 1'b1)
      $display("Load Reg2 : %b (%d)", ld_reg2_strb, dreg2); 
    else if(ld_reg3 == 1'b1)
      $display("Load Reg3 : %b (%d)", ld_reg3_strb, dreg3); 
 
    //Printing EFLAGS
    if(ld_CF || ld_PF || ld_AF || ld_ZF || ld_SF || ld_OF || ld_DF)
    $display("Load Flags: (%b) ", {ld_CF,ld_PF,ld_AF,ld_ZF,ld_SF,ld_OF,ld_DF});

    //Printing MM
    if(ld_mm)
    $display("Load MMX regs: (%d) ", dmm);

    //Printing SEG
    if(ld_seg)
    $display("Load Segments: (%d) ", dseg);
   
    //Printing MEM 
    if(ld_mem)
    $display("Load Memory: Addr(%h) Size:%d : %h %h", u_system.u_cpu.r_wb_mem_wr_addr, u_system.u_cpu.r_wb_mem_wr_size, u_system.u_cpu.w_wb_mem_wr_data[63:32], u_system.u_cpu.w_wb_mem_wr_data[31:0]);

    //Printing EIP 
    if(u_system.u_cpu.r_wb_eip_change)
      #1 $display("Load EIP: actual_val=%h", u_system.u_cpu.r_EIP);

  end
end
`endif

// Initialize i-cache and d-cache tag stores
initial begin
  for (i=0;i<8;i=i+1)  begin
    u_system.u_cpu.u_i_cache.ts.ts_lower.mem[i] = 8'h00;
    u_system.u_cpu.u_i_cache.ts.ts_upper.mem[i] = 8'h00;
  end
  for (i=0;i<8;i=i+1)  begin
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[0].col_gen[0].u_ram8b8w_way2.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[0].col_gen[1].u_ram8b8w_way2.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[1].col_gen[0].u_ram8b8w_way2.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[1].col_gen[1].u_ram8b8w_way2.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[0].col_gen[0].u_ram8b8w_way1.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[0].col_gen[1].u_ram8b8w_way1.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[1].col_gen[0].u_ram8b8w_way1.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[1].col_gen[1].u_ram8b8w_way1.mem[i] = 8'h00;
  end
end

// Initialize TLB and segment limit registers
initial begin
  u_system.u_cpu.TLB[0] = 44'h0000000000c;
  u_system.u_cpu.TLB[1] = 44'h0200000002e;
  u_system.u_cpu.TLB[2] = 44'h0400000005e;
  u_system.u_cpu.TLB[3] = 44'h0b00000004e;
  u_system.u_cpu.TLB[4] = 44'h0c00000007e;
  u_system.u_cpu.TLB[5] = 44'h0a00000005e;
  u_system.u_cpu.TLB[6] = 44'h8000000000f;
  u_system.u_cpu.TLB[7] = 44'hC000000000f;
  
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[0] = 44'h0000000000c;
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[1] = 44'h0200000002e;
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[2] = 44'h0400000005e;
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[3] = 44'h0b00000004e;
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[4] = 44'h0c00000007e;
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[5] = 44'h0a00000005e;
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[6] = 44'h8000000000f;
  u_system.u_cpu.u_dcache.u_tlb.r_tlb_mem[7] = 44'hC000000000f;

  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[0] = 44'h0000000000c;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[1] = 44'h0200000002e;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[2] = 44'h0400000005e;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[3] = 44'h0b00000004e;
  //u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[3] = 44'h0400100004e;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[4] = 44'h0c00000007e;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[5] = 44'h0a00000005e;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[6] = 44'h8000000000f;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[7] = 44'hC000000000f;

  u_system.u_cpu.CS_limit = 20'h04fff;
  u_system.u_cpu.DS_limit = 20'h011ff;
  u_system.u_cpu.SS_limit = 20'h04000;
  u_system.u_cpu.ES_limit = 20'h00419;
  u_system.u_cpu.FS_limit = 20'h003ff;
  u_system.u_cpu.GS_limit = 20'h007ff;

end

//Initialize memory
reg [15:0] init_num_lines[1:0];
reg [15:0] init_mem_addr[(2**15)-1:0];
reg [7:0]  init_mem_data[(2**15)-1:0];
reg [2:0]  chip_arr_row;
reg [2:0]  chip_arr_col;
reg [1:0]  chip_byte_idx;
reg [6:0]  chip_line_addr;
reg [15:0] chip_addr;

reg [7:0] data0[(2**12)-1:0];

reg [63:0] oprom_data0[255:0];
reg [63:0] oprom_data1[255:0];

reg [63:0] subrom_data0 [255:0];
reg [48:0] subrom_data1 [255:0];

reg [31:0] modrom_data [31:0];
reg [63:0] int_exp_data0 [7:0];
reg [63:0] int_exp_data1 [7:0];
reg [63:0] int_exp_data2 [7:0];


initial begin
    $readmemh("../../scripts/hex_data0.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen0
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[0].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

    $readmemh("../../scripts/hex_data1.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen1
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[1].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

    $readmemh("../../scripts/hex_data2.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen2
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[2].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

    $readmemh("../../scripts/hex_data3.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen3
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[3].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

    $readmemh("../../scripts/hex_data4.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen4
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[4].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

    $readmemh("../../scripts/hex_data5.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen5
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[5].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

    $readmemh("../../scripts/hex_data6.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen6
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[6].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

    $readmemh("../../scripts/hex_data7.txt",data0);
    for (k=0; k < 128; k=k+1) begin : line_gen7
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[0].u_sram128x8_1.mem[k] = data0[k*32+(4*0)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[0].u_sram128x8_2.mem[k] = data0[k*32+(4*0)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[0].u_sram128x8_3.mem[k] = data0[k*32+(4*0)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[0].u_sram128x8_4.mem[k] = data0[k*32+(4*0)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[1].u_sram128x8_1.mem[k] = data0[k*32+(4*1)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[1].u_sram128x8_2.mem[k] = data0[k*32+(4*1)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[1].u_sram128x8_3.mem[k] = data0[k*32+(4*1)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[1].u_sram128x8_4.mem[k] = data0[k*32+(4*1)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[2].u_sram128x8_1.mem[k] = data0[k*32+(4*2)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[2].u_sram128x8_2.mem[k] = data0[k*32+(4*2)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[2].u_sram128x8_3.mem[k] = data0[k*32+(4*2)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[2].u_sram128x8_4.mem[k] = data0[k*32+(4*2)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[3].u_sram128x8_1.mem[k] = data0[k*32+(4*3)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[3].u_sram128x8_2.mem[k] = data0[k*32+(4*3)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[3].u_sram128x8_3.mem[k] = data0[k*32+(4*3)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[3].u_sram128x8_4.mem[k] = data0[k*32+(4*3)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[4].u_sram128x8_1.mem[k] = data0[k*32+(4*4)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[4].u_sram128x8_2.mem[k] = data0[k*32+(4*4)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[4].u_sram128x8_3.mem[k] = data0[k*32+(4*4)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[4].u_sram128x8_4.mem[k] = data0[k*32+(4*4)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[5].u_sram128x8_1.mem[k] = data0[k*32+(4*5)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[5].u_sram128x8_2.mem[k] = data0[k*32+(4*5)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[5].u_sram128x8_3.mem[k] = data0[k*32+(4*5)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[5].u_sram128x8_4.mem[k] = data0[k*32+(4*5)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[6].u_sram128x8_1.mem[k] = data0[k*32+(4*6)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[6].u_sram128x8_2.mem[k] = data0[k*32+(4*6)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[6].u_sram128x8_3.mem[k] = data0[k*32+(4*6)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[6].u_sram128x8_4.mem[k] = data0[k*32+(4*6)+3];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[7].u_sram128x8_1.mem[k] = data0[k*32+(4*7)+0];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[7].u_sram128x8_2.mem[k] = data0[k*32+(4*7)+1];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[7].u_sram128x8_3.mem[k] = data0[k*32+(4*7)+2];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[7].col_gen[7].u_sram128x8_4.mem[k] = data0[k*32+(4*7)+3];
    end

//Initializing OPROM
    $readmemb("../../scripts/oprom_dump_lower.txt",oprom_data0);
    for (k = 0; k < 32; k= k+1) begin 
       u_system.u_cpu.u_decode.op_rom_gen[0].rom0.mem[k] = oprom_data0[k];
       u_system.u_cpu.u_decode.op_rom_gen[1].rom0.mem[k] = oprom_data0[k+32];
       u_system.u_cpu.u_decode.op_rom_gen[2].rom0.mem[k] = oprom_data0[k+2*32];
       u_system.u_cpu.u_decode.op_rom_gen[3].rom0.mem[k] = oprom_data0[k+3*32];
       u_system.u_cpu.u_decode.op_rom_gen[4].rom0.mem[k] = oprom_data0[k+4*32];
       u_system.u_cpu.u_decode.op_rom_gen[5].rom0.mem[k] = oprom_data0[k+5*32];
       u_system.u_cpu.u_decode.op_rom_gen[6].rom0.mem[k] = oprom_data0[k+6*32];
       u_system.u_cpu.u_decode.op_rom_gen[7].rom0.mem[k] = oprom_data0[k+7*32];
    end

    $readmemb("../../scripts/oprom_dump_upper.txt",oprom_data1);
    for (k = 0; k < 32; k= k+1) begin
       u_system.u_cpu.u_decode.op_rom_gen[0].rom1.mem[k] = oprom_data1[k];
       u_system.u_cpu.u_decode.op_rom_gen[1].rom1.mem[k] = oprom_data1[k+32]; 
       u_system.u_cpu.u_decode.op_rom_gen[2].rom1.mem[k] = oprom_data1[k+2*32];
       u_system.u_cpu.u_decode.op_rom_gen[3].rom1.mem[k] = oprom_data1[k+3*32];
       u_system.u_cpu.u_decode.op_rom_gen[4].rom1.mem[k] = oprom_data1[k+4*32];
       u_system.u_cpu.u_decode.op_rom_gen[5].rom1.mem[k] = oprom_data1[k+5*32];
       u_system.u_cpu.u_decode.op_rom_gen[6].rom1.mem[k] = oprom_data1[k+6*32];
       u_system.u_cpu.u_decode.op_rom_gen[7].rom1.mem[k] = oprom_data1[k+7*32];
    end

//Initializing SUBOPROM
    $readmemb("../../scripts/subrom_dump_lower.txt",subrom_data0);
    
    for (k = 0; k < 32; k= k+1) begin
       u_system.u_cpu.u_decode.sub_rom_gen[0].subrom0.mem[k] = subrom_data0[k];
       u_system.u_cpu.u_decode.sub_rom_gen[1].subrom0.mem[k] = subrom_data0[k+32]; 
       u_system.u_cpu.u_decode.sub_rom_gen[2].subrom0.mem[k] = subrom_data0[k+2*32];
       u_system.u_cpu.u_decode.sub_rom_gen[3].subrom0.mem[k] = subrom_data0[k+3*32];
       u_system.u_cpu.u_decode.sub_rom_gen[4].subrom0.mem[k] = subrom_data0[k+4*32];
       u_system.u_cpu.u_decode.sub_rom_gen[5].subrom0.mem[k] = subrom_data0[k+5*32];
       u_system.u_cpu.u_decode.sub_rom_gen[6].subrom0.mem[k] = subrom_data0[k+6*32];
       u_system.u_cpu.u_decode.sub_rom_gen[7].subrom0.mem[k] = subrom_data0[k+7*32];
    end 

    $readmemb("../../scripts/subrom_dump_upper.txt",subrom_data1);

    for (k = 0; k < 32; k= k+1) begin
       u_system.u_cpu.u_decode.sub_rom_gen[0].subrom1.mem[k] = subrom_data1[k];
       u_system.u_cpu.u_decode.sub_rom_gen[1].subrom1.mem[k] = subrom_data1[k+32];
       u_system.u_cpu.u_decode.sub_rom_gen[2].subrom1.mem[k] = subrom_data1[k+2*32];
       u_system.u_cpu.u_decode.sub_rom_gen[3].subrom1.mem[k] = subrom_data1[k+3*32];
       u_system.u_cpu.u_decode.sub_rom_gen[4].subrom1.mem[k] = subrom_data1[k+4*32];
       u_system.u_cpu.u_decode.sub_rom_gen[5].subrom1.mem[k] = subrom_data1[k+5*32];
       u_system.u_cpu.u_decode.sub_rom_gen[6].subrom1.mem[k] = subrom_data1[k+6*32];
       u_system.u_cpu.u_decode.sub_rom_gen[7].subrom1.mem[k] = subrom_data1[k+7*32];
    end

//Initializing MODROM
    $readmemb("../../scripts/modrom.txt",modrom_data);
    
    for (k = 0; k < 32; k= k+1) begin
       u_system.u_cpu.u_decode.modrom.mem[k] = modrom_data[k];
    end

//Initializing RSEQ ROM
    $readmemb("../../scripts/introm_dump0.txt",int_exp_data0);
    $readmemb("../../scripts/introm_dump1.txt",int_exp_data1);
    $readmemb("../../scripts/introm_dump2.txt",int_exp_data2);
    for (k = 0; k < 8; k= k+1) begin
       u_system.u_cpu.u_rseq_rom.rom0.mem[k] = int_exp_data0[k];
       u_system.u_cpu.u_rseq_rom.rom1.mem[k] = int_exp_data1[k];
       u_system.u_cpu.u_rseq_rom.rom2.mem[k] = int_exp_data2[k];

    end

end
endmodule

