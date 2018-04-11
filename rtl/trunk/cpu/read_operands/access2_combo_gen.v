/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Access2 combinational signal generation      */
/* Description: Detect if 2nd access is required        */
/********************************************************/

module access2_combo_gen(access2_combo, offset, size);

input  [3:0] offset;
input  [1:0] size;
output       access2_combo;

wire w_size_eq2, w_offset_eq15, w_size_eq4, w_offset_gt12, w_size_eq8, w_offset_gt8;

assign w_offset_gt8 = offset > 4'd8;
assign w_offset_gt12 = offset > 4'd12;
assign w_offset_eq15 = offset == 4'd15;

assign w_size_eq8 = size == 2'b11;
assign w_size_eq4 = size == 2'b10;
assign w_size_eq2 = size == 2'b01;

assign access2_combo = (w_size_eq2 & w_offset_eq15) | (w_size_eq4 & w_offset_gt12) | (w_size_eq8 & w_offset_gt8);

endmodule

