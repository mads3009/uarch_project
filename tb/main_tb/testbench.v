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

always #6 clk <= ~clk;

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

integer k,j;
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
        chip_arr_col = chip_addr[4:2];
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

end

endmodule

