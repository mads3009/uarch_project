/*************** Microarchiture Project*******************/
/*********************************************************/
/* Module: TLB address generator                         */
/* Description: Generates the address to index into TLB. */
/*********************************************************/

module tlb_addr_gen ( mem_rw_addr_vpn, tlb_pn0, tlb_pn1, tlb_pn2, tlb_pn3, 
                      tlb_pn4, tlb_pn5, tlb_pn6, tlb_pn7, tlb_addr);

input  [19:0] mem_rw_addr_vpn;
input  [19:0] tlb_pn0;
input  [19:0] tlb_pn1;
input  [19:0] tlb_pn2;
input  [19:0] tlb_pn3;
input  [19:0] tlb_pn4;
input  [19:0] tlb_pn5;
input  [19:0] tlb_pn6;
input  [19:0] tlb_pn7;
output [2:0]  tlb_addr;

wire [7:0] w_eq_pg;

eq_checker20 u_eq_checker20_0(.in1(tlb_pn0), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[0]));
eq_checker20 u_eq_checker20_1(.in1(tlb_pn1), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[1]));
eq_checker20 u_eq_checker20_2(.in1(tlb_pn2), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[2]));
eq_checker20 u_eq_checker20_3(.in1(tlb_pn3), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[3]));
eq_checker20 u_eq_checker20_4(.in1(tlb_pn4), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[4]));
eq_checker20 u_eq_checker20_5(.in1(tlb_pn5), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[5]));
eq_checker20 u_eq_checker20_6(.in1(tlb_pn6), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[6]));
eq_checker20 u_eq_checker20_7(.in1(tlb_pn7), .in2(mem_rw_addr_vpn), .eq_out(w_eq_pg[7]));

pencoder8_3v$(.enbar(1'b0), .X(w_eq_pg), .Y(tlb_addr), .valid(/*Unused*/));

endmodule

