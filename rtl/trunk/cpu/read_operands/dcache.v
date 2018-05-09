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
               io_ack, dc_evict, dc_evict_addr, dc_evict_data, dc_rd_exp, ld_ro, ro_IDT_and_ISR, 
               cmps_op, cmps_flag_bar );

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
input                 dc_rd_exp;
input                 ld_ro;
input                 mem_conflict;
input                 ro_IDT_and_ISR;
input                 cmps_op;
input                 cmps_flag_bar;

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
wire [15:0]         w_dc_wr_mask_way2, w_dc_wr_mask_way1;
wire                w_evict_way2, w_evict_way1, r_evict_way2, r_evict_way1;
wire [C_LINE_W-1:0] w_dc_wr_data;
wire [C_LINE_W-1:0] w_dc_rd_data_way2, w_dc_rd_data_way1;
wire [31:0]         w_mem_rw_addr_curr, w_mem_rw_addr_next, w_mem_rw_addr;
wire [1:0]          w_mem_rw_size;

wire                w_dc_rd_hit, w_dc_wr_hit;
wire                r_access2, w_access2, w_access2_muxout;
wire [6:0]          w_phy_tag;
wire [6:0]          w_ts_tag2;
wire                w_ts_valid2, w_ts_dirty2, w_ts_lru2;
wire [6:0]          w_ts_tag1;
wire                w_ts_valid1, w_ts_dirty1, w_ts_lru1;
wire [6:0]          r_ts_tag2;
wire                r_ts_valid2, r_ts_dirty2, r_ts_lru2;
wire [6:0]          r_ts_tag1;
wire                r_ts_valid1, r_ts_dirty1, r_ts_lru1;
wire [15:0]         w_ts_data_in_way2, w_ts_data_in_way1;
wire                w_ts_wr_enb;
wire                w_tag_eq2, w_tag_eq1, w_tag_eq2_bar, w_tag_eq1_bar;

wire [19:0]         w_tlb_pn0,w_tlb_pn1,w_tlb_pn2,w_tlb_pn3,w_tlb_pn4,w_tlb_pn5,w_tlb_pn6,w_tlb_pn7;
wire [2:0]          w_tlb_addr;
wire [19:0]         w_tlb_phy_pn;
wire                w_tlb_pcd;
wire [2:0]          w_tlb_addr1;
wire [19:0]         w_tlb_phy_pn1;
wire                w_tlb_pcd1;
wire [2:0]          w_tlb_addr2;
wire [19:0]         w_tlb_phy_pn2;
wire                w_tlb_pcd2;
wire [2:0]          w_tlb_addr3;
wire [19:0]         w_tlb_phy_pn3;
wire                w_tlb_pcd3;

// Assign statements

assign dc_miss_addr = {17'd0, w_phy_tag,w_mem_rw_addr[7:4],4'd0};

// io_access = w_tlb_pcd & (ren | wen) & !(dc_rd_exp & ren)
nand2$ u_nand2_1(.out(n_801), .in0(dc_rd_exp), .in1(ren));
and3$ u_and3_1(.out(io_access), .in0(w_tlb_pcd), .in1(n_3), .in2(n_801));
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
  .dc_wr_hit(w_dc_wr_hit),
  .dc_miss_ack(dc_miss_ack),
  .dc_data_fill(dc_data_fill),
  .dc_wr_data(w_dc_wr_data),
  .evict_way2_reg(r_evict_way2),
  .evict_way1_reg(r_evict_way1),
  .dc_wr_mask_way2(w_dc_wr_mask_way2),
  .dc_wr_mask_way1(w_dc_wr_mask_way1),
  .tag_eq2(w_tag_eq2),
  .tag_eq1(w_tag_eq1)
  );

// Generate mem_rd_data
mem_rd_data_gen u_mem_rd_data_gen(
  .clk(clk),
  .rst_n(rst_n),
  .dc_rd_data_way2(w_dc_rd_data_way2),
  .dc_rd_data_way1(w_dc_rd_data_way1),
  .tag_eq2(w_tag_eq2),
  .addr_offset(mem_rd_addr[3:0]),
  .access2_reg(r_access2),
  .dc_read_hit(w_dc_rd_hit),
  .io_rd_data(io_rd_data),
  .io_ack(io_ack),
  .mem_rd_data(mem_rd_data),
  .dc_miss_ack(dc_miss_ack),
  .ren(ren)
  );

// FIXME
wire [3:0] index_del;
assign #0.6 index_del = w_mem_rw_addr[7:4];
//bufferH1024$ u_buff0[3:0] (.out(index_del), .in(w_mem_rw_addr[7:4]));

// FIXME END

// D-cache data store
dc_data_store u_dc_data_store(
  .clk(clk),
  .rst_n(rst_n),
  .index(index_del),
  .dc_wr_mask_way2(w_dc_wr_mask_way2),
  .dc_wr_mask_way1(w_dc_wr_mask_way1),
  .dc_write_data(w_dc_wr_data),
  .dc_read_data_way2(w_dc_rd_data_way2),
  .dc_read_data_way1(w_dc_rd_data_way1)
  );

// D-cache tag store

inv1$ u_inv1_g1(.in(w_tag_eq2), .out(w_tag_eq2_bar));
inv1$ u_inv1_g2(.in(w_tag_eq1), .out(w_tag_eq1_bar));

wire clk_bar_del, clk_del;

assign #2.2 clk_bar_del = ~clk;
//bufferHInv64$ u_c1 (.out(clk1), .in(clk));
//bufferH16$ u_c2 (.out(clk2), .in(clk1));
//bufferH1024$ u_c3 (.out(clk_bar_del), .in(clk2));

assign #1.7 clk_del = clk;
//bufferH1024$ u_c11 (.out(clk11), .in(clk));
//bufferH1024$ u_c12 (.out(clk12), .in(clk11));
//bufferH1024$ u_c13 (.out(clk_del), .in(clk12));

dff$ u_tag_store_sample_reg[19:0] (.clk(clk_bar_del), .r(rst_n), .s(1'b1), .d({w_ts_tag2, w_ts_valid2, w_ts_dirty2, w_ts_lru2, w_ts_tag1, w_ts_valid1, w_ts_dirty1, w_ts_lru1}), .q({r_ts_tag2, r_ts_valid2, r_ts_dirty2, r_ts_lru2, r_ts_tag1, r_ts_valid1, r_ts_dirty1, r_ts_lru1}), .qbar(/*Unused*/));

dff$ u_evict_sample_reg[1:0] (.clk(clk_del), .r(rst_n), .s(1'b1), .d({w_evict_way2, w_evict_way1}), .q({r_evict_way2, r_evict_way1}), .qbar(/*Unused*/));

wire [15:0] w_ts_data_in_way2_temp1, w_ts_data_in_way1_temp1;

muxNbit_2x1 #(.N(16)) u_muxNbit_m2 (.IN0({6'd0,r_ts_tag2, r_ts_valid2, r_ts_dirty2, 1'b0}), .IN1({6'd0, w_phy_tag,1'b1, 1'b0, 1'b1}), .S0(r_evict_way2), .Y(w_ts_data_in_way2_temp1));

muxNbit_2x1 #(.N(16)) u_muxNbit_m1 (.IN0({6'd0,r_ts_tag1, r_ts_valid1, r_ts_dirty1, 1'b0}), .IN1({6'd0, w_phy_tag,1'b1, 1'b0, 1'b1}), .S0(r_evict_way1), .Y(w_ts_data_in_way1_temp1));

or2$ u_or2_g1(.in0(r_ts_dirty2), .in1(wen), .out(n801));
mux2$ u_mux2_g101(.in0(r_ts_dirty2), .in1(n801), .outb(w_new_dirty2), .s0(w_tag_eq2));

or2$ u_or2_g2(.in0(r_ts_dirty1), .in1(wen), .out(n802));
mux2$ u_mux2_g102(.in0(r_ts_dirty1), .in1(n802), .outb(w_new_dirty1), .s0(w_tag_eq1));

muxNbit_2x1 #(.N(16)) u_muxNbit_m4 (.IN0({6'd0, r_ts_tag2, r_ts_valid2, w_new_dirty2, w_tag_eq2}), .IN1(w_ts_data_in_way2_temp1), .S0(dc_miss_ack), .Y(w_ts_data_in_way2));

muxNbit_2x1 #(.N(16)) u_muxNbit_m3 (.IN0({6'd0, r_ts_tag1, r_ts_valid1, w_new_dirty1, w_tag_eq1}), .IN1(w_ts_data_in_way1_temp1), .S0(dc_miss_ack), .Y(w_ts_data_in_way1));

nor3$ u_nor3_g1(.out(w_ts_wr_enb), .in0(w_dc_wr_hit), .in1(dc_miss_ack), .in2(w_dc_rd_hit));

wire [5:0] blah2, blah1;

dc_tag_store u_dc_tag_store(
  .clk(clk),
  .rst_n(rst_n),
  .index(index_del),
  .wr(w_ts_wr_enb),
  .data_in_way2(w_ts_data_in_way2),
  .data_in_way1(w_ts_data_in_way1),
  .data_out_way2({blah2, w_ts_tag2, w_ts_valid2, w_ts_dirty2, w_ts_lru2}),
  .data_out_way1({blah1, w_ts_tag1, w_ts_valid1, w_ts_dirty1, w_ts_lru1})
  );

// TLB instantiation and dcache hit/miss checking

and2$ u_ren_and_isr ( .in0(ren), .in1(ro_IDT_and_ISR), .out(ren_and_ro_IDT));
mux_nbit_2x1 #7 u_w_phy_tag(.a0({w_tlb_phy_pn[2:0],w_mem_rw_addr[11:8]}), .a1(w_mem_rw_addr[14:8]), .out(w_phy_tag), .sel(ren_and_ro_IDT));
//assign w_phy_tag = ren & ro_IDT_and_ISR ? w_mem_rw_addr[14:8] : {w_tlb_phy_pn[2:0],w_mem_rw_addr[11:8]};

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
  .tlb_pcd3(w_tlb_pcd3),
  .tlb_addr4(/*Unused*/),
  .tlb_phy_pn4(/*Unused*/),
  .tlb_vpn4(/*Unused*/),
  .tlb_valid4(/*Unused*/),
  .tlb_pr4(/*Unused*/),
  .tlb_rw4(/*Unused*/),
  .tlb_pcd4(/*Unused*/)
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
  .tlb_addr(w_tlb_addr1),
  .tlb_addr_valid(/*Unused*/)
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
  .tlb_addr(w_tlb_addr2),
  .tlb_addr_valid(/*Unused*/)
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
  .tlb_addr(w_tlb_addr3),
  .tlb_addr_valid(/*Unused*/)
  );


dc_hit_checker u_dc_hit_checker(
  .phy_tag(w_phy_tag),
  .ts_tag2(w_ts_tag2),
  .ts_valid2(w_ts_valid2),
  .ts_tag1(w_ts_tag1),
  .ts_valid1(w_ts_valid1),
  .tlb_pcd(w_tlb_pcd),
  .ren(ren),
  .wen(wen),
  .v_mem_read(v_mem_read),  
  .dc_miss_ack(dc_miss_ack),
  .access2_reg(r_access2),
  .access2_combo(w_access2),
  .io_ack(io_ack),
  .dc_rd_exp(dc_rd_exp),
  .io_access(io_access),
  .mem_rd_ready(mem_rd_ready),
  .mem_wr_done(mem_wr_done),
  .mem_rd_busy(mem_rd_busy),
  .mem_wr_busy(mem_wr_busy),
  .dc_miss(dc_miss),
  .dc_hit(w_dc_hit),
  .dc_rd_hit(w_dc_rd_hit),
  .dc_wr_hit(w_dc_wr_hit),
  .tag_eq2(w_tag_eq2),
  .tag_eq1(w_tag_eq1)
  );

/*
// When cache was direct mapped
assign dc_evict_addr = {17'd0, w_ts_tag,w_mem_rw_addr[7:4],4'd0};
assign dc_evict_data = w_dc_rd_data;
dc_evict = dc_miss & ts_valid & ts_dirty & !dc_miss_ack; // dc_hit_checker snippet
*/

dc_evict_gen u_dc_evict_gen(
  .dc_evict(dc_evict),
  .dc_evict_addr(dc_evict_addr),
  .dc_evict_data(dc_evict_data),
  .dc_miss_ack(dc_miss_ack),
  .dc_miss(dc_miss),
  .ts_tag2(w_ts_tag2),
  .ts_valid2(w_ts_valid2),
  .ts_dirty2(w_ts_dirty2),
  .ts_lru2(w_ts_lru2),
  .ts_tag1(w_ts_tag1),
  .ts_valid1(w_ts_valid1),
  .ts_dirty1(w_ts_dirty1),
  .ts_lru1(w_ts_lru1),
  .mem_rw_addr(w_mem_rw_addr),
  .dc_rd_data_way2(w_dc_rd_data_way2),
  .dc_rd_data_way1(w_dc_rd_data_way1),
  .evict_way2(w_evict_way2),
  .evict_way1(w_evict_way1)
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

cond_sum32 u_cond_sum32(.A(w_mem_rw_addr_curr), .B(32'd16), .CIN(1'b0), .S(w_mem_rw_addr_next), .COUT(/*unused*/));
muxNbit_2x1 u_muxNbit_2x1_3(.IN0(w_mem_rw_addr_curr), .IN1(w_mem_rw_addr_next), .S0(r_access2), .Y(w_mem_rw_addr));

// Generate access2 signals for memory accesses which take 2 cycles to complete the access
dff$ u_access2 (.r(rst_n), .s(1'b1), .clk(clk), .d(w_access2_muxout), .q (r_access2), .qbar (/*Unused*/));

and2$ u_and2_3(.out(n_0), .in0(w_dc_hit), .in1(w_access2));

and3$ u_and3_g1(.out(n_22), .in0(w_dc_rd_hit), .in1(cmps_op), .in2(cmps_flag_bar));
and2$ u_and2_2(.out(n_2), .in0(w_dc_rd_hit), .in1(ld_ro));
nor3$ u_nor2_1(.out(n_1), .in0(mem_wr_done), .in1(n_2), .in2(n_22));

mux2$ u_mux2_1(.outb(w_access2_muxout), .in0(n_0), .in1(n_1), .s0(r_access2));

access2_combo_gen u_access2_combo_gen(.access2_combo(w_access2), .offset(w_mem_rw_addr[3:0]), .size(w_mem_rw_size));

endmodule

