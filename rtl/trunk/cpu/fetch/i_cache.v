/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: i_cache                                      */
/* Description: 512 B direct mapped icache              */
/*  of line size 32 bytes                               */
/* Author: Madhuri Gontala                              */
/********************************************************/

module i_cache(clk, rst_n, ren, index, tag_14_12, tag_11_9, ic_fill_data, ic_miss_ack, ic_exp, r_data, ic_hit, ic_miss, ic_miss_addr, ic_miss_ack_addr);
    input         clk;
    input         rst_n;
    input         ren;
    input  [3:0]  index;
    input  [2:0]  tag_14_12; 
    input  [2:0]  tag_11_9; 
    input  [255:0]ic_fill_data;
    input         ic_miss_ack;
    input         ic_exp;
    input  [31:0] ic_miss_ack_addr;
    
    output [255:0]r_data;
    output        ic_hit;
    output        ic_miss;
    output [31:0] ic_miss_addr;
            	
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
    
    eq_checker6 check_tag (.in1(tag_in_cache), .in2(phy_tag), .eq_out(tag_match));

    and2$ u_hit(.out(hit), .in0(tag_match), .in1(tag_valid));
    nand2$ u_not_hit(.out(not_hit), .in0(tag_match), .in1(tag_valid));
    
    //Outputs
    and4$ u_ic_hit (.out(ic_hit), .in0(hit), .in1(not_ic_miss_ack), .in2(ren), .in3(not_ic_exp));
    and4$ u_ic_miss(.out(ic_miss), .in0(not_hit), .in1(ren), .in2(not_ic_exp), .in3(not_ic_miss_ack));
    assign ic_miss_addr = {phy_tag,index,5'b0};

    wire [3:0] index_muxed;
    mux_nbit_2x1 #4 u_index_muxed (.a0(index), .a1(ic_miss_ack_addr[8:5]), .sel(ic_miss_ack), .out(index_muxed));

    // FIXME
    wire [3:0] index_del,index_del0;
    //assign #1 index_del = index_muxed;
    bufferH256$ u_buff0[3:0] (.out(index_del0), .in(index_muxed)); 
    bufferH256$ u_buff1[3:0] (.out(index_del), .in(index_del0)); 
    // FIXME END

    data_store ds(
        .clk    (clk),
        .index  (index_del),
        .oe     (1'b0),
        .fill_data  (ic_fill_data),
        .ic_miss_ack_bar (not_ic_miss_ack),
        .r_data     (r_data)
    );

    tag_store ts(
        .clk    (clk),
        .index (index_del),
        .oe   (1'b0),
        .tag (tag_in_cache),
        .tag_valid (tag_valid),
        .ic_miss_ack_bar (not_ic_miss_ack),
        .wr_tag(ic_miss_ack_addr[14:9])
    );


endmodule
 
module tag_store(
    input clk,
    input [3:0] index,
    input       oe,
    input [5:0] wr_tag,
    input       ic_miss_ack_bar,
    output [5:0] tag,
    output       tag_valid
    );

    wire wr_neg_cycle;
    wire wr_upper, wr_lower;
    wire   [5:0] tag_upper;
    wire   [5:0] tag_lower;
    wire    valid_upper;
    wire    valid_lower;
    
    wire   [1:0] blah;
    
    wire index3; 
    wire not_index3;

    buffer$ u_buffer_1(.out(w_clk_001), .in(clk));
    buffer$ u_buffer_2(.out(w_clk_002), .in(w_clk_001));
    buffer$ u_buffer_3(.out(w_clk_003), .in(w_clk_002));
    buffer$ u_buffer_4(.out(w_clk_004), .in(w_clk_003));
    buffer$ u_buffer_5(.out(w_clk_005), .in(w_clk_004));
    buffer$ u_buffer_6(.out(w_clk_del), .in(w_clk_005));

    or3$ u_wr_neg_cycle(.out(wr_neg_cycle), .in0(clk), .in1(ic_miss_ack_bar), .in2(w_clk_del));

    assign index3 = index[3];
    inv1$ u_indexlower (.in(index3), .out(not_index3));

    or2$ u_wr_upper (.in0(wr_neg_cycle), .in1(not_index3), .out(wr_upper));
    or2$ u_wr_lower (.in0(wr_neg_cycle), .in1(index3), .out(wr_lower));
   
    ram8b8w$ ts_lower (.A(index[2:0]), .DIN({2'b1,wr_tag}), .OE(oe), .WR(wr_lower), .DOUT({blah[0],valid_lower,tag_lower}));
    ram8b8w$ ts_upper (.A(index[2:0]), .DIN({2'b1,wr_tag}), .OE(oe), .WR(wr_upper), .DOUT({blah[1],valid_upper,tag_upper}));
    
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
    input           ic_miss_ack_bar,
    output  [255:0] r_data
    );
    
    wire wr_neg_cycle;
    wire wr_upper, wr_lower;
    wire   [255:0] dout_upper;
    wire   [255:0] dout_lower;
    wire index3; 
    wire not_index3;

    buffer$ u_buffer_1(.out(w_clk_001), .in(clk));
    buffer$ u_buffer_2(.out(w_clk_002), .in(w_clk_001));
    buffer$ u_buffer_3(.out(w_clk_003), .in(w_clk_002));
    buffer$ u_buffer_4(.out(w_clk_004), .in(w_clk_003));
    buffer$ u_buffer_5(.out(w_clk_005), .in(w_clk_004));
    buffer$ u_buffer_6(.out(w_clk_del), .in(w_clk_005));

    or3$ u_wr_neg_cycle(.out(wr_neg_cycle), .in0(clk), .in1(ic_miss_ack_bar), .in2(w_clk_del));


    assign index3 = index[3];
    inv1$ u_indexlower (.in(index3), .out(not_index3));

    or2$ u_wr_upper (.in0(wr_neg_cycle), .in1(not_index3), .out(wr_upper));
    or2$ u_wr_lower (.in0(wr_neg_cycle), .in1(index3), .out(wr_lower));
   
    ram_nB_8w upper_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_upper), .DOUT(dout_upper));
    ram_nB_8w lower_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_lower), .DOUT(dout_lower));
    
    //FIXME : Huge fanout for sel;
    mux_nbit_2x1 #256 u_r_data (.a0(dout_lower), .a1(dout_upper), .sel(index[3]), .out(r_data));

endmodule



