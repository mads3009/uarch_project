/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: i_cache                                      */
/* Description: 512 B direct mapped icache              */
/*  of line size 32 bytes                               */
/* Author: Madhuri Gontala                              */
/********************************************************/

module i_cache(clk, rst_n, ren, index, tag_14_12, tag_11_9, ic_fill_data, ic_miss_ack, ic_exp, r_data, ic_hit, ic_miss, ic_miss_addr);
    input         clk;
    input         rst_n;
    input         ren;
    input  [3:0]  index;
    input  [2:0]  tag_14_12; 
    input  [2:0]  tag_11_9; 
    input  [255:0]ic_fill_data;
    input         ic_miss_ack;
    input         ic_exp;
    
    output [255:0]r_data;
    output        ic_hit;
    output        ic_miss;
    output        ic_miss_addr;
            	
    wire [5:0] phy_tag;
    assign phy_tag = {tag_14_12,tag_11_9};
  
    //Internal
    wire hit;
    wire nothit;
    wire not_ic_exp; 
    wire not_ic_miss_ack; 

    inv1$ u_not_ic_exp (.in(ic_exp), .out(not_ic_exp)); 
    inv1$ u_not_ic_miss_ack (.in(ic_miss_ack), .out(not_ic_miss_ack)); 

    wire [5:0] tag_in_cache;
    wire tag_match, tag_valid;
    
    //FIXME - Change to structural 
    eq_checker #6 check_tag (.in1(tag_in_cache), .in2(phy_tag), .eq_out(tag_match));

    and2$ u_hit(.out(hit), .in0(tag_match), .in1(tag_valid));
    inv1$ u_not_hit (.in(hit), .out(not_hit)); 
    
    //Outputs
    and3$ u_ic_hit (.out(ic_hit), .in0(hit), .in1(not_ic_miss_ack), .in2(ren));
    and3$ u_ic_miss(.out(ic_miss), .in0(not_hit), .in1(ren), .in2(not_ic_exp));
    assign ic_miss_addr = {phy_tag,index,5'b0};

    data_store ds(
        .clk    (clk),
        .index  (index),
        .oe     (1'b1),
        .fill_data  (ic_fill_data),
        .wr   (not_ic_miss_ack),
        .r_data     (r_data)
    );

    tag_store ts(
        .clk    (clk),
        .index (index),
        .oe   (1'b1),
        .tag (tag_in_cache),
        .tag_valid (tag_valid),
        .wr (not_ic_miss_ack),
        .wr_tag(phy_tag)
    );


endmodule
 
module ram_nB_8w(A, DIN, WR, OE, DOUT);
    parameter N = 32;
    input [2:0] A;
    input [8*N-1:0] DIN ;
    input WR, OE;
    output [8*N-1:0] DOUT ;
    
    genvar i;
    generate begin : loop
    for (i=0; i<N; i=i+1) 
        ram8b8w$ ram_forcache (.A(A), .DIN(DIN[8*i+7:8*i]), .OE(OE), .WR(WR), .DOUT(DOUT[8*i+7:8*i]));
    end
    endgenerate
endmodule


module tag_store(
    input clk,
    input [3:0] index,
    input       oe,
    input [5:0] wr_tag,
    input       wr,
    output [5:0] tag,
    output       tag_valid
    );

    wire wr_neg_cycle;
    and2$ u_wr_neg_cycle(.out(wr_neg_cycle), .in0(clk), .in1(wr));

    wire wr_upper, wr_lower;
    wire   [5:0] tag_upper;
    wire   [5:0] tag_lower;
    wire    valid_upper;
    wire    valid_lower;
    
    wire   [1:0] blah;
    
    wire index3; 
    wire not_index3;
    assign index3 = index[3];
    inv1$ u_indexlower (.in(index3), .out(not_index3));

    or2$ u_wr_upper (.in0(wr_neg_cycle), .in1(not_index3), .out(wr_upper));
    or2$ u_wr_lower (.in0(wr_neg_cycle), .in1(index3), .out(wr_lower));
    
    ram8b8w$ ts_lower (.A(index[2:0]), .DIN({2'b0,wr_tag}), .OE(oe), .WR(wr_lower), .DOUT({blah[0],valid_lower,tag_lower}));
    ram8b8w$ ts_upper (.A(index[2:0]), .DIN({2'b0,wr_tag}), .OE(oe), .WR(wr_upper), .DOUT({blah[1],valid_upper,tag_upper}));
    
    //FIXME : fanout 6;
    mux_nbit_2x1 #6 u_tag (.a0(tag_lower), .a1(tag_upper), .sel(index[3]), .out(tag));
    mux_nbit_2x1 #1 u_tag_valid (.a0(valid_lower), .a1(valid_upper), .sel(index[3]), .out(tag_valid));

/*
    //dffs for valid;
    wire [15:0] enables;
    wire [15:0] tag_v_in;
    wire [15:0] tag_vs;
    wire [15:0] one_hot_wr;

    assign enable = v_init | wr;
    demux_1x16 demux (1'b1, index ,one_hot_wr);    
    assign tag_v_in = (v_init) ? 16'b0 : 16'hffff;
    assign enables = (v_init) ? 16'hffff : one_hot_wr;

    dff16$ u_valids(
        .CLK(clk),
        .D(tag_v_in),
        .Q(tag_vs),
        .CLR(1'b1),
        .PRE(1'b1),
        .QBAR ()
    );
    mux_16x1 u_valid (tag_vs, index, tag_valid);
*/

endmodule

module data_store(
    input           clk,
    input   [3:0]   index,
    input           oe,
    input   [255:0] fill_data,
    input           wr,
    output  [255:0] r_data
    );
    
    wire wr_neg_cycle;
    or2$ u_wr_neg_cycle (.out(wr_neg_cycle), .in0(clk), .in1(wr));

    wire wr_upper, wr_lower;
    wire   [255:0] dout_upper;
    wire   [255:0] dout_lower;
   
    wire index3; 
    wire not_index3;
    assign index3 = index[3];
    inv1$ u_indexlower (.in(index3), .out(not_index3));

    or2$ u_wr_upper (.in0(wr_neg_cycle), .in1(not_index3), .out(wr_upper));
    or2$ u_wr_lower (.in0(wr_neg_cycle), .in1(index3), .out(wr_lower));
    
    ram_nB_8w upper_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_upper), .DOUT(dout_upper));
    ram_nB_8w lower_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_lower), .DOUT(dout_lower));
    
    //FIXME : Huge fanout for sel;
    mux_nbit_2x1 #256 u_r_data (.a0(dout_lower), .a1(dout_upper), .sel(index[3]), .out(r_data));

endmodule



