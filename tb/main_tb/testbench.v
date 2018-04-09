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

//system ports
reg         clk;
reg         rst_n;

/////////////////////////////////////
// Clock and Reset generation
/////////////////////////////////////
initial begin
  clk = 1'b0;
  rst_n = 1'b0;
  #100;
  rst_n = 1'b1;
  #100000;
  $finish;
end

always #4 clk <= ~clk;

//Instantiate the system
system u_system(
  .clk    (clk),
  .rst_n  (rst_n)
);

//Initialize memory
initial begin
  $readmemh("scripts/num_lines.txt",,,u_system_u_main_mem.u_mem_array.row_gen[i].col_gen[j].u_sram128x8_1.mem[k])
end

endmodule

