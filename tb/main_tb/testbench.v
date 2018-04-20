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
  force u_system.u_cpu.u_i_cache.ts.ts_lower.WR = 1'b1;
  force u_system.u_cpu.u_i_cache.ts.ts_upper.WR = 1'b1;

  force testbench.u_system.u_cpu.u_i_cache.ds.lower_ram.WR = 1'b1;
  force testbench.u_system.u_cpu.u_i_cache.ds.upper_ram.WR = 1'b1;

  force u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[0].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[1].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[2].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[3].u_ram8b8w$.WR = 1'b1;

  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[0].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[1].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[2].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[3].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[4].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[5].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[6].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[7].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[8].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[9].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[10].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[11].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[12].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[13].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[14].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[15].u_ram8b8w$.WR = 1'b1;

  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[0].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[1].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[2].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[3].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[4].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[5].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[6].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[7].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[8].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[9].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[10].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[11].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[12].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[13].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[14].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[15].u_ram8b8w$.WR = 1'b1;

  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[0].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[1].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[2].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[3].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[4].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[5].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[6].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[7].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[8].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[9].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[10].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[11].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[12].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[13].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[14].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[15].u_ram8b8w$.WR = 1'b1;

  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[0].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[1].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[2].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[3].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[4].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[5].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[6].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[7].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[8].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[9].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[10].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[11].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[12].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[13].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[14].u_ram8b8w$.WR = 1'b1;
  force u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[15].u_ram8b8w$.WR = 1'b1;

  clk = 1'b1;
  rst_n = 1'b0;
  #100;

  release u_system.u_cpu.u_i_cache.ts.ts_lower.WR;
  release u_system.u_cpu.u_i_cache.ts.ts_upper.WR;

  release u_system.u_cpu.u_i_cache.ds.lower_ram.WR;
  release u_system.u_cpu.u_i_cache.ds.upper_ram.WR;

  release u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[0].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[1].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[2].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[3].u_ram8b8w$.WR;

  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[0].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[1].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[2].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[3].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[4].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[5].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[6].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[7].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[8].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[9].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[10].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[11].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[12].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[13].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[14].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[0].col_gen[15].u_ram8b8w$.WR;

  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[0].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[1].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[2].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[3].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[4].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[5].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[6].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[7].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[8].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[9].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[10].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[11].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[12].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[13].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[14].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[1].col_gen[15].u_ram8b8w$.WR;

  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[0].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[1].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[2].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[3].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[4].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[5].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[6].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[7].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[8].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[9].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[10].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[11].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[12].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[13].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[14].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[2].col_gen[15].u_ram8b8w$.WR;

  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[0].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[1].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[2].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[3].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[4].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[5].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[6].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[7].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[8].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[9].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[10].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[11].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[12].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[13].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[14].u_ram8b8w$.WR;
  release u_system.u_cpu.u_dcache.u_dc_data_store.row_gen[3].col_gen[15].u_ram8b8w$.WR;

  rst_n = 1'b1;
  
  // FIXME
  force u_system.u_cpu.u_seg_regfile.seg_loop.loop2[3].u_seg_reg.data_o = 16'h0A00;

  #1000;

  $finish;
end

/////////////////////////////////////
// Clock generation
/////////////////////////////////////

always #4 clk <= ~clk;

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

// Initialize i-cache and d-cache tag stores
initial begin
  for (i=0;i<8;i=i+1)  begin
    u_system.u_cpu.u_i_cache.ts.ts_lower.mem[i] = 8'h00;
    u_system.u_cpu.u_i_cache.ts.ts_upper.mem[i] = 8'h00;
  end
  for (i=0;i<8;i=i+1)  begin
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[0].u_ram8b8w$.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[1].u_ram8b8w$.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[2].u_ram8b8w$.mem[i] = 8'h00;
    u_system.u_cpu.u_dcache.u_dc_tag_store.row_gen[3].u_ram8b8w$.mem[i] = 8'h00;
  end
end

/*
//Initialize registers to some non zero values
initial begin
  u_system.u_cpu.u_regfile.loop2[0].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[1].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[2].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[3].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[4].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[5].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[6].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[7].u_reg0.data[7:0] = 8'h1;
  u_system.u_cpu.u_regfile.loop2[0].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[1].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[2].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[3].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[4].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[5].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[6].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[7].u_reg1.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[0].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[1].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[2].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[3].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[4].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[5].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[6].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[7].u_reg2.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[0].u_reg3.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[1].u_reg3.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[2].u_reg3.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[3].u_reg3.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[4].u_reg3.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[5].u_reg3.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[6].u_reg3.data[7:0] = 8'h0;
  u_system.u_cpu.u_regfile.loop2[7].u_reg3.data[7:0] = 8'h0;

  u_system.u_cpu.u_regfile.loop2[0].u_reg0.gen_reg[0].u_reg = 1'b1;
  u_system.u_cpu.u_regfile.loop2[1].u_reg0.gen_reg[0].u_reg = 1'b1;
  u_system.u_cpu.u_regfile.loop2[2].u_reg0.gen_reg[0].u_reg = 1'b1;
  u_system.u_cpu.u_regfile.loop2[3].u_reg0.gen_reg[0].u_reg = 1'b1;
  u_system.u_cpu.u_regfile.loop2[4].u_reg0.gen_reg[0].u_reg = 1'b1;
  u_system.u_cpu.u_regfile.loop2[5].u_reg0.gen_reg[0].u_reg = 1'b1;
  u_system.u_cpu.u_regfile.loop2[6].u_reg0.gen_reg[0].u_reg = 1'b1;
  u_system.u_cpu.u_regfile.loop2[7].u_reg0.gen_reg[0].u_reg = 1'b1;
end
*/

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
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[4] = 44'h0c00000007e;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[5] = 44'h0a00000005e;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[6] = 44'h8000000000f;
  u_system.u_cpu.u_dc_exp_checker.u_tlb.r_tlb_mem[7] = 44'hC000000000f;

  u_system.u_cpu.CS_limit = 20'h04fff;
  u_system.u_cpu.DS_limit = 20'h011ff;
  u_system.u_cpu.SS_limit = 20'h04000;
  u_system.u_cpu.ES_limit = 20'h003ff;
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

/*
    for (k=0; k < init_num_lines[0]; k=k+1) begin : line_gen
        chip_addr = init_mem_addr[k];
        $display("addr=%b",chip_addr);
 
        chip_arr_row = chip_addr[14:12];
        chip_byte_idx = chip_addr[1:0];
        chip_arr_col = chip_addr[4:2];[
        chip_line_addr = chip_addr[11:5];
        u_system.u_main_mem.u_mem_array.mem_gen.row_gen[init_mem_addr[k][14:12]].col_gen[init_mem_addr[k][4:2]].u_sram128x8_1.mem[init_mem_addr[k][11:5]] =  init_mem_data[k]; 

        if(chip_byte_idx == 2'b0) 
          u_system.u_main_mem.u_mem_array.row_gen[chip_arr_row].col_gen[chip_arr_col].u_sram128x8_1.mem[chip_line_addr] =  init_mem_data[k]; 
        else if(chip_byte_idx == 2'b1) 
          u_system.u_main_mem.u_mem_array.row_gen[chip_arr_row].col_gen[chip_arr_col].u_sram128x8_2.mem[chip_line_addr] =  init_mem_data[k]; 
        else if(chip_byte_idx == 2'b10) 
          u_system.u_main_mem.u_mem_array.row_gen[chip_arr_row].col_gen[chip_arr_col].u_sram128x8_3.mem[chip_line_addr] =  init_mem_data[k]; 
        else 
          u_system.u_main_mem.u_mem_array.row_gen[chip_arr_row].col_gen[chip_arr_col].u_sram128x8_4.mem[chip_line_addr] =  init_mem_data[k]; 
      
    end
*/

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

