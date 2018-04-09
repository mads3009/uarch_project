/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache module                                */
/* Description: 512B Direct mapped data cache with cache*/
/* block size = 16 Bytes and #cache blocks = 32. Hence, */
/* physical addr[14:0]: 6bit tag+5bit index+4bit BoB.   */
/********************************************************/

module dcache( clk, rst_n, v_mem_read,  mem_conflict, wr_fifo_empty, wr_fifo_to_be_full,
               mem_rd_size, mem_wr_size, mem_rd_addr, mem_wr_addr, mem_wr_data, mem_rd_data,
               mem_rd_ready, mem_wr_done,mem_rd_busy, mem_wr_busy, dc_miss, dc_miss_addr, 
               dc_data_fill, dc_miss_ack, io_access, io_rw, io_addr, io_wr_data, io_rd_data, 
               io_ack, dc_evict, dc_evict_addr, dc_evict_data, dc_exp, ld_ro);

localparam C_LINE_W = 16*8; // 16 Bytes

// System ports
input                 clk;
input                 rst_n;

// Read-Operand or Write-Back request
input                 v_mem_read;
input                 wr_fifo_empty;
input                 wr_fifo_to_be_full;

input  [1:0]          mem_rd_size;
input  [1:0]          mem_wr_size;
input  [31:0]         mem_rd_addr;
input  [31:0]         mem_wr_addr;
input  [63:0]         mem_wr_data;

output [63:0]         mem_rd_data;
output                mem_rd_ready;
output                mem_wr_done;
output                mem_rd_busy; // must be used to stall pipeline
output                mem_wr_busy; // must not be used to stall pipeline

// Pipeline dependencies
input                 dc_exp;
input                 ld_ro;
input                 mem_conflict;

// MMU - data cache miss handling interface
output                dc_miss;
output [31:0]         dc_miss_addr;
output                dc_evict;
output [31:0]         dc_evict_addr;
output [C_LINE_W-1:0] dc_evict_data;
input  [C_LINE_W-1:0] dc_data_fill;
input                 dc_miss_ack;

// MMU - IO access interface
output                io_access;
output                io_rw;
output [31:0]         io_addr;
output [31:0]         io_wr_data;

input  [31:0]         io_rd_data;
input                 io_ack;


// Internal variables
wire [15:0]         w_dc_wr_mask;
wire [C_LINE_W-1:0] w_dc_wr_data;
wire [C_LINE_W-1:0] w_dc_rd_data;
wire [31:0]         w_mem_rw_addr_curr, w_mem_rw_addr_next, w_mem_rw_addr;
wire [1:0]          w_mem_rw_size;

wire                w_dc_read_hit, w_dc_write_hit;
wire                r_access2, w_access2, w_access2_muxout;
wire [5:0]          w_phy_tag;
wire [5:0]          w_ts_tag;
wire                w_ts_valid, w_ts_dirty;
wire [7:0]          w_ts_data_in;
wire                w_ts_wr_enb;

wire [19:0]         w_tlb_pn0,w_tlb_pn1,w_tlb_pn2,w_tlb_pn3,w_tlb_pn4,w_tlb_pn5,w_tlb_pn6,w_tlb_pn7;
wire [2:0]          w_tlb_addr;
wire [20:0]         w_tlb_phy_pn;
wire                w_tlb_pcd;
wire [2:0]          w_tlb_addr1;
wire [20:0]         w_tlb_phy_pn1;
wire                w_tlb_pcd1;
wire [2:0]          w_tlb_addr2;
wire [20:0]         w_tlb_phy_pn2;
wire                w_tlb_pcd2;
wire [2:0]          w_tlb_addr3;
wire [20:0]         w_tlb_phy_pn3;
wire                w_tlb_pcd3;

// Assign statements

assign dc_miss_addr = {17'd0, w_phy_tag,w_mem_rw_addr[8:4],4'd0};
assign dc_evict_addr = {17'd0, w_ts_tag,w_mem_rw_addr[8:4],4'd0};
assign dc_evict_data = w_dc_rd_data;

// io_access = w_tlb_pcd & (ren | wen) & !dc_exp
inv1$ u_inv1_1(.out(w_dc_exp_bar), .in(dc_exp));
and3$ u_and3_1(.out(io_access), .in0(w_tlb_pcd), .in1(n_3), .in2(w_dc_exp_bar));
or2$ u_or2_1(.out(n_3), .in0(ren), .in1(wen));

assign io_rw = wen;
assign io_addr = {w_mem_rw_addr[31:2],2'd0};
assign io_wr_data = mem_wr_data[31:0];

// Generate dc_wr_data and dc_wr_mask
dc_wr_data_gen u_dc_wr_data_gen(
  .mem_wr_size(mem_wr_size),
  .mem_wr_data(mem_wr_data),
  .addr_offset(mem_wr_addr[3:0]),
  .access2_reg(r_access2),
  .dc_write_hit(w_dc_write_hit),
  .dc_miss_ack(dc_miss_ack),
  .dc_data_fill(dc_data_fill),
  .dc_wr_data(w_dc_wr_data),
  .dc_wr_mask(w_dc_wr_mask)
  );

// Generate mem_rd_data
mem_rd_data_gen u_mem_rd_data_gen(
  .clk(clk),
  .rst_n(rst_n),
  .dc_rd_data(w_dc_rd_data),
  .addr_offset(mem_rd_addr[3:0]),
  .access2_reg(r_access2),
  .dc_read_hit(w_dc_read_hit),
  .io_rd_data(io_rd_data),
  .io_ack(io_ack),
  .mem_rd_data(mem_rd_data)
  );

// D-cache data store
dc_data_store u_dc_data_store(
  .clk(clk),
  .index(w_mem_rw_addr[8:4]),
  .dc_wr_mask(w_dc_wr_mask),
  .dc_write_data(w_dc_wr_data),
  .dc_read_data(w_dc_rd_data)
  );

// D-cache tag store
muxNbit_2x1 #(.N(8)) u_muxNbit_2x1_0 (.IN0({w_phy_tag,1'b1, 1'b0}), .IN1({w_phy_tag,1'b1, 1'b1}), .S0(dc_miss_ack), .Y(w_ts_data_in));

nor2$ u_nor2(.out(w_ts_wr_enb), .in0(w_dc_wr_hit), .in1(dc_miss_ack));

dc_tag_store u_dc_tag_store(
  .clk(clk),
  .index(w_mem_rw_addr[8:4]),
  .wr(w_ts_wr_enb),
  .data_in(w_ts_data_in),
  .data_out({w_ts_tag, w_ts_valid, w_ts_dirty})
  );

// TLB instantiation and dcache hit/miss checking

assign w_phy_tag = {w_tlb_phy_pn[2:0],w_mem_rw_addr[11:9]};

mux3$ u_mux3_1[20:0] (.outb({w_tlb_phy_pn, w_tlb_pcd}), .in0({w_tlb_phy_pn1, w_tlb_pcd1}), .in1({w_tlb_phy_pn2, w_tlb_pcd2}), .in2({w_tlb_phy_pn3, w_tlb_pcd3}), .s0(ren), .s1(r_access2));

tlb u_tlb(
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr1(w_tlb_addr1),
  .tlb_phy_pn1(w_tlb_phy_pn1),
  .tlb_vpn1(/*Unused*/),
  .tlb_valid1(/*Unused*/),
  .tlb_pr1(/*Unused*/),
  .tlb_rw1(/*Unused*/),
  .tlb_pcd1(w_tlb_pcd1),
  .tlb_addr2(w_tlb_addr2),
  .tlb_phy_pn2(w_tlb_phy_pn2),
  .tlb_vpn2(/*Unused*/),
  .tlb_valid2(/*Unused*/),
  .tlb_pr2(/*Unused*/),
  .tlb_rw2(/*Unused*/),
  .tlb_pcd2(w_tlb_pcd2),
  .tlb_addr3(w_tlb_addr3),
  .tlb_phy_pn3(w_tlb_phy_pn3),
  .tlb_vpn3(/*Unused*/),
  .tlb_valid3(/*Unused*/),
  .tlb_pr3(/*Unused*/),
  .tlb_rw3(/*Unused*/),
  .tlb_pcd3(w_tlb_pcd3)
  );

tlb_addr_gen u_tlb_addr_gen_wr(
  .mem_rw_addr_vpn(mem_wr_addr[31:12]),
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr(w_tlb_addr1)
  );

tlb_addr_gen u_tlb_addr_gen_rd(
  .mem_rw_addr_vpn(mem_rd_addr[31:12]),
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr(w_tlb_addr2)
  );

tlb_addr_gen u_tlb_addr_gen_rw(
  .mem_rw_addr_vpn(w_mem_rw_addr[31:12]),
  .tlb_pn0(w_tlb_pn0),
  .tlb_pn1(w_tlb_pn1),
  .tlb_pn2(w_tlb_pn2),
  .tlb_pn3(w_tlb_pn3),
  .tlb_pn4(w_tlb_pn4),
  .tlb_pn5(w_tlb_pn5),
  .tlb_pn6(w_tlb_pn6),
  .tlb_pn7(w_tlb_pn7),
  .tlb_addr(w_tlb_addr3)
  );


dc_hit_checker u_dc_hit_checker(
  .phy_tag(w_phy_tag),
  .ts_tag(w_ts_tag),
  .ts_valid(w_ts_valid),
  .ts_dirty(w_ts_dirty),
  .tlb_pcd(w_tlb_pcd),
  .ren(ren),
  .wen(wen),
  .v_mem_read(v_mem_read),  
  .dc_miss_ack(dc_miss_ack),
  .access2_reg(r_access2),
  .access2_combo(w_access2),
  .io_ack(io_ack),
  .dc_exp(dc_exp),
  .io_access(io_access),
  .mem_rd_ready(mem_rd_ready),
  .mem_wr_done(mem_wr_done),
  .mem_rd_busy(mem_rd_busy),
  .mem_wr_busy(mem_wr_busy),
  .dc_miss(dc_miss),
  .dc_hit(w_dc_hit),
  .dc_rd_hit(w_dc_rd_hit),
  .dc_wr_hit(w_dc_wr_hit),
  .dc_evict(dc_evict)
  );

// Arbitrate between read and write requests
dc_arbiter u_dc_arbiter(
  .clk(clk), 
  .rst_n(rst_n), 
  .v_mem_read(v_mem_read),  
  .mem_conflict(mem_conflict), 
  .wr_fifo_empty(wr_fifo_empty), 
  .wr_fifo_to_be_full(wr_fifo_to_be_full),
  .ld_ro(ld_ro),
  .mem_wr_done(mem_wr_done),
  .ren(ren),
  .wen(wen)
 );

muxNbit_2x1 #(.N(2)) u_muxNbit_2x1_1(.IN0(mem_wr_size), .IN1(mem_rd_size), .S0(ren), .Y(w_mem_rw_size));
muxNbit_2x1 #(.N(32)) u_muxNbit_2x1_2(.IN0(mem_wr_addr), .IN1(mem_rd_addr), .S0(ren), .Y(w_mem_rw_addr_curr));

cond_sum32 u_cond_sum32(.A(mem_rw_addr), .B(32'd16), .CIN(1'b0), .S(w_mem_rw_addr_next), .COUT(/*unused*/));
muxNbit_2x1 u_muxNbit_2x1_3(.IN0(w_mem_rw_addr_curr), .IN1(w_mem_rw_addr_next), .S0(r_access2), .Y(w_mem_rw_addr));

// Generate access2 signals for memory accesses which take 2 cycles to complete the access
dff$ u_access2 (.r(rst_n), .s(1'b1), .clk(clk), .d(w_access2_muxout), .q (r_access2), .qbar (/*Unused*/));

and2$ u_and2_2(.out(n_2), .in0(w_dc_rd_hit), .in1(ld_ro));
and2$ u_and2_3(.out(n_0), .in0(w_dc_hit), .in1(w_access2));
nor2$ u_nor2_1(.out(n_1), .in0(mem_wr_done), .in1(in_2));
mux2$ u_mux2_1(.outb(w_access2_muxout), .in0(n_0), .in1(n_1), .s0(r_access2));

access2_combo_gen u_access2_combo_gen(.access2_combo(w_access2), .offset(w_mem_rw_addr[3:0]), .size(w_mem_rw_size));

endmodule

