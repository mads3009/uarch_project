/*************** Microarchiture Project******************/
/********************************************************/
/* Module: dcache evict combo logic module              */
/* Description: Generates evict signals                 */
/********************************************************/

module evict_combo( dc_evict, dc_miss, dc_miss_ack, ts_valid2, ts_dirty2, ts_lru2, 
                    ts_valid1, ts_dirty1, ts_lru1, evict_way2, evict_way1);

input                 dc_miss;
input                 dc_miss_ack;
input                 ts_valid2;
input                 ts_dirty2;
input                 ts_lru2;
input                 ts_valid1;
input                 ts_dirty1;
input                 ts_lru1;

output                dc_evict;
output                evict_way2;
output                evict_way1;

// Internal variables
reg evict_way2, evict_way1;
wire w_ts_valid, w_ts_dirty;

always @(*) begin
  case({ts_valid2, ts_valid1, ts_lru2, ts_lru1})
  4'b0000, 4'b0001, 4'b0010, 4'b0011: {evict_way2, evict_way1} = 2'b01;
  4'b0100, 4'b0101, 4'b0110, 4'b0111: {evict_way2, evict_way1} = 2'b10;
  4'b1000, 4'b1001, 4'b1010, 4'b1011: {evict_way2, evict_way1} = 2'b01;
  4'b1100: {evict_way2, evict_way1} = 2'b01;
  4'b1101: {evict_way2, evict_way1} = 2'b10;
  4'b1110: {evict_way2, evict_way1} = 2'b01;
  4'b1111: {evict_way2, evict_way1} = 2'b01;
  endcase
end

assign w_ts_valid = evict_way2 ? ts_valid2 : ts_valid1;
assign w_ts_dirty = evict_way2 ? ts_dirty2 : ts_dirty1;

assign dc_evict = dc_miss & w_ts_valid & w_ts_dirty & !dc_miss_ack;

endmodule

