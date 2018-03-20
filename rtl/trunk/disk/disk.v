/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: disk                                         */
/* Description: Behavioral model of disk (32GB). Assume */
/* 750ns delay to produce data to DMA.                  */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module disk( clk, rst_n, d_ready, d_data, d_addr, d_init, d_done );

// DMA-DISK interface
input         clk;
input         rst_n;
output        d_ready;
output [31:0] d_data;

input  [9:0]  d_addr;
input         d_init;
input         d_done;

reg  [31:0] d_data;

// Internal variables
localparam NUM_CYC = 108; // 750/7
integer i;

reg [31:0] disk_data[1023:0];
reg [15:0] count;


always @(posedge d_init) begin
  for(i=0; i<1024; i=i+1) begin: disk_data_init
    disk_data[i] <= $random();
  end 
end

always @(*) begin
  d_data = disk_data[d_addr];
end

always @(posedge clk, negedge rst_n) begin
  if(~rst_n)
    count <= 16'd0;
  else if(d_init)
    count <= 16'd1;
  else if(d_done)
    count <= 16'd0;
  else if((count != 16'd0) && (count != NUM_CYC))
    count <= count + 16'd1;
  else
    count <= count;
end

assign d_ready = (count == NUM_CYC);

endmodule
