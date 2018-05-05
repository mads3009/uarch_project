/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache evict logic module                    */
/* Description: Generates evict signals, addr and data  */
/********************************************************/

module dc_evict_gen ( dc_evict, dc_evict_addr, dc_evict_data, dc_miss_ack, dc_miss, ts_tag2,
                      ts_valid2, ts_dirty2, ts_lru2, ts_tag1, ts_valid1, ts_dirty1, ts_lru1,
                      mem_rw_addr, dc_rd_data_way2, dc_rd_data_way1, evict_way2, evict_way1);

localparam C_LINE_W = 16*8; // 16 Bytes

input                 dc_miss;
input                 dc_miss_ack;
input [6:0]           ts_tag2;
input                 ts_valid2;
input                 ts_dirty2;
input                 ts_lru2;
input [6:0]           ts_tag1;
input                 ts_valid1;
input                 ts_dirty1;
input                 ts_lru1;
input [31:0]          mem_rw_addr;
input [C_LINE_W-1:0]  dc_rd_data_way2;
input [C_LINE_W-1:0]  dc_rd_data_way1;

output                dc_evict;
output [31:0]         dc_evict_addr;
output [C_LINE_W-1:0] dc_evict_data;
output                evict_way2;
output                evict_way1;

// Internal variables

muxNbit_2x1 #(.N(32)) u_muxNbit_2x1_1(.IN0({17'd0, ts_tag1,mem_rw_addr[7:4],4'd0}), .IN1({17'd0, ts_tag2,mem_rw_addr[7:4],4'd0}), .S0(evict_way2), .Y(dc_evict_addr));

muxNbit_2x1 #(.N(C_LINE_W)) u_muxNbit_2x1_2(.IN0(dc_rd_data_way1), .IN1(dc_rd_data_way2), .S0(evict_way2), .Y(dc_evict_data));

evict_combo u_evict_combo(
  .dc_miss_ack(dc_miss_ack),
  .dc_miss(dc_miss),
  .ts_valid2(ts_valid2),
  .ts_dirty2(ts_dirty2),
  .ts_lru2(ts_lru2),
  .ts_valid1(ts_valid1),
  .ts_dirty1(ts_dirty1),
  .ts_lru1(ts_lru1),
  .dc_evict(dc_evict),
  .evict_way2(evict_way2),
  .evict_way1(evict_way1)
  );

endmodule

