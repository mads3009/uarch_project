/*************** Microarchiture Project*******************/
/*********************************************************/
/* Module: Translation lookaside buffer with 3 read ports*/
/* Description: Translates VPN to PPN                    */
/*********************************************************/

module tlb ( tlb_pn0, tlb_pn1, tlb_pn2, tlb_pn3, tlb_pn4, tlb_pn5, tlb_pn6, tlb_pn7, 
             tlb_addr1, tlb_vpn1, tlb_phy_pn1,  tlb_valid1, tlb_pr1, tlb_rw1, tlb_pcd1, 
             tlb_addr2, tlb_vpn2, tlb_phy_pn2,  tlb_valid2, tlb_pr2, tlb_rw2, tlb_pcd2,
             tlb_addr3, tlb_vpn3, tlb_phy_pn3,  tlb_valid3, tlb_pr3, tlb_rw3, tlb_pcd3);

output [19:0] tlb_pn0;
output [19:0] tlb_pn1;
output [19:0] tlb_pn2;
output [19:0] tlb_pn3;
output [19:0] tlb_pn4;
output [19:0] tlb_pn5;
output [19:0] tlb_pn6;
output [19:0] tlb_pn7;
input  [2:0]  tlb_addr1;
output [19:0] tlb_vpn1;
output [19:0] tlb_phy_pn1;
output        tlb_valid1;
output        tlb_pr1;
output        tlb_rw1;
output        tlb_pcd1;
input  [2:0]  tlb_addr2;
output [19:0] tlb_vpn2;
output [19:0] tlb_phy_pn2;
output        tlb_valid2;
output        tlb_pr2;
output        tlb_rw2;
output        tlb_pcd2;
input  [2:0]  tlb_addr3;
output [19:0] tlb_vpn3;
output [19:0] tlb_phy_pn3;
output        tlb_valid3;
output        tlb_pr3;
output        tlb_rw3;
output        tlb_pcd3;

reg [43:0] r_tlb_mem[7:0];


assign tlb_pn0 = r_tlb_mem[0][43-:20];
assign tlb_pn1 = r_tlb_mem[1][43-:20];
assign tlb_pn2 = r_tlb_mem[2][43-:20];
assign tlb_pn3 = r_tlb_mem[3][43-:20];
assign tlb_pn4 = r_tlb_mem[4][43-:20];
assign tlb_pn5 = r_tlb_mem[5][43-:20];
assign tlb_pn6 = r_tlb_mem[6][43-:20];
assign tlb_pn7 = r_tlb_mem[7][43-:20];

// Read port 1
wire [43:0] w_temp0, w_temp1;

mux4$ u_mux4_1[43:0] (.outb(w_temp0[43:0]), .in0(r_tlb_mem[0][43:0]), .in1(r_tlb_mem[1][43:0]), .in2(r_tlb_mem[2][43:0]), .in3(r_tlb_mem[3][43:0]), .s0(tlb_addr1[0]), .s1(tlb_addr1[1]));

mux4$ u_mux4_2[43:0] (.outb(w_temp1[43:0]), .in0(r_tlb_mem[4][43:0]), .in1(r_tlb_mem[5][43:0]), .in2(r_tlb_mem[6][43:0]), .in3(r_tlb_mem[7][43:0]), .s0(tlb_addr1[0]), .s1(tlb_addr1[1]));

muxNbit_2x1 #(.N(44)) u_muxNbit_2x1_1(.IN0(w_temp0), .IN1(w_temp1), .S0(tlb_addr1[2]), .Y({tlb_vpn1, tlb_phy_pn1, tlb_valid1, tlb_pr1, tlb_rw1, tlb_pcd1}));

// Read port 2
wire [43:0] w_temp2, w_temp3;

mux4$ u_mux4_3[43:0] (.outb(w_temp2[43:0]), .in0(r_tlb_mem[0][43:0]), .in1(r_tlb_mem[1][43:0]), .in2(r_tlb_mem[2][43:0]), .in3(r_tlb_mem[3][43:0]), .s0(tlb_addr2[0]), .s1(tlb_addr2[1]));

mux4$ u_mux4_4[43:0] (.outb(w_temp3[43:0]), .in0(r_tlb_mem[4][43:0]), .in1(r_tlb_mem[5][43:0]), .in2(r_tlb_mem[6][43:0]), .in3(r_tlb_mem[7][43:0]), .s0(tlb_addr2[0]), .s1(tlb_addr2[1]));

muxNbit_2x1 #(.N(44)) u_muxNbit_2x1_2(.IN0(w_temp2), .IN1(w_temp3), .S0(tlb_addr2[2]), .Y({tlb_vpn2, tlb_phy_pn2, tlb_valid2, tlb_pr2, tlb_rw2, tlb_pcd2}));

// Read port 3
wire [43:0] w_temp4, w_temp5;

mux4$ u_mux4_5[43:0] (.outb(w_temp4[43:0]), .in0(r_tlb_mem[0][43:0]), .in1(r_tlb_mem[1][43:0]), .in2(r_tlb_mem[2][43:0]), .in3(r_tlb_mem[3][43:0]), .s0(tlb_addr3[0]), .s1(tlb_addr3[1]));

mux4$ u_mux4_6[43:0] (.outb(w_temp5[43:0]), .in0(r_tlb_mem[4][43:0]), .in1(r_tlb_mem[5][43:0]), .in2(r_tlb_mem[6][43:0]), .in3(r_tlb_mem[7][43:0]), .s0(tlb_addr3[0]), .s1(tlb_addr3[1]));

muxNbit_2x1 #(.N(44)) u_muxNbit_2x1_3(.IN0(w_temp4), .IN1(w_temp5), .S0(tlb_addr3[2]), .Y({tlb_vpn3, tlb_phy_pn3, tlb_valid3, tlb_pr3, tlb_rw3, tlb_pcd3}));

endmodule

