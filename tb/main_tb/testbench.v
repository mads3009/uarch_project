/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: disk top level modeule                       */
/* Description: System level testbench to verify bus.   */
/* Author: Sharukh S. Shaikh                            */
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

initial
   begin
      $vcdplusfile("tb.vpd");
      $vcdpluson(0, testbench); 
   end 


//Initialize memory
reg [(2**15)-1:0] lines[1:0];
reg [15:0] addrs[(2**15)-1:0];
reg [7:0] datas[(2**15)-1:0];
reg [2:0] r;
reg [2:0] c;
reg [1:0] b;
reg [6:0] l;
reg [15:0] addr;

integer k;
initial begin
    $readmemh("../../scripts/num_lines.txt",lines);
    $readmemh("../../scripts/hex_data.txt",datas);
    $readmemh("../../scripts/hex_addr.txt",addrs);

    
        $display("lines=%d",lines[0]);

    for (k=0; k < 10; k=k+1) begin : line_gen
        addr = addrs[k];
        $display("addr=%b",addr);
 
        r = addr[14:12];
        b = addr[1:0];
        c = addr[4:2];
        l = addr[11:5];
    
        if(b == 2'b0) 
          u_system.u_main_mem.u_mem_array.row_gen[0].col_gen[0].u_sram128x8_1.mem[0] =  datas[k]; 
        else if(b == 2'b1) 
          u_system.u_main_mem.u_mem_array.row_gen[0].col_gen[0].u_sram128x8_2.mem[0] =  datas[k]; 
        else if(b == 2'b10) 
          u_system.u_main_mem.u_mem_array.row_gen[0].col_gen[0].u_sram128x8_3.mem[0] =  datas[k]; 
        else 
          u_system.u_main_mem.u_mem_array.row_gen[0].col_gen[0].u_sram128x8_4.mem[0] =  datas[k]; 
        
    end

end

endmodule

