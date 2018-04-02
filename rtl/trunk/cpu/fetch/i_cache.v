/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: i_cache                                      */
/* Description: CPU register file with 4 read ports and */
/* 2 write ports. The write ports write to the register */
/* only if their register addresses are different else  */
/* the register file will retain its state.             */
/* Author: Madhuri Gontala                              */
/********************************************************/

module i_cache(clk, rst_n, ren, index, tag_14_12, tag_11_9, ic_fill_data, ic_miss_ack, r_data, ic_hit, ic_miss, ic_addr);
    input         clk;
    input         rst_n;
    input         ren;
    input  [3:0]  index;
    input  [2:0]  tag_14_12; 
    input  [2:0]  tag_11_9; 
    input  [255:0]ic_fill_data;
    input         ic_miss_ack;
    
    output [255:0]r_data;
    output        ic_hit;
    output        ic_miss;
    output        ic_addr;
            	
    //Internal
    wire hit;
    wire [5:0] phy_tag;
   
    //FIXME : remove
    wire v_init;
    assign v_init=1'b0; 

    assign phy_tag = {tag_14_12,tag_11_9};
   
    wire nothit;
    NOT u_not_hit (hit, not_hit); 
    //assign ic_miss = ~hit && ren;
    and2$ u_ic_miss(ic_miss, not_hit, ren);

    assign ic_addr = {phy_tag,index,5'b0};
    
    and2$ u_ic_hit (ic_hit, hit, ren);
    
    data_store ds(
        .clk    (clk),
        .index  (index),
        .oe     (1'b1),
        .fill_data  (ic_fill_data),
        .wr   (ic_miss_ack),
        .r_data     (r_data)
    );
    
    wire [5:0] tag_in_cache;
    wire tag_match, tag_valid;
    
    tag_store ts(
        .clk    (clk),
        .index (index),
        .oe(1'b1),
        .tag (tag_in_cache),
        .tag_valid (tag_valid),
        .wr (ic_miss_ack),
        .wr_tag(phy_tag),
        .v_init(v_init)
    );
    
    eq_checker #6 check_tag (tag_in_cache, phy_tag, tag_match);
    
    and2$ u_hit (hit, tag_match, tag_valid);

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
    input       v_init,
    output [5:0] tag,
    output       tag_valid
    );

    wire w_wr;
    and2$ u_w_wr(w_wr,clk,wr);

    wire wr_upper, wr_lower;
    wire   [5:0] tag_upper;
    wire   [5:0] tag_lower;
    
    wire   [3:0] blah;
    
    wire index_lower;
    NOT u_indexlower (index[3], index_lower);
    and2$ u_wr_upper (w_wr, index[3], wr_upper);
    and2$ u_wr_lower (w_wr, index_lower, wr_lower);

    ram8b8w$ ts_lower (.A(index[2:0]), .DIN({2'b0,wr_tag}), .OE(oe), .WR(wr_lower), .DOUT({blah[1:0],tag_lower}));
    ram8b8w$ ts_upper (.A(index[2:0]), .DIN({2'b0,wr_tag}), .OE(oe), .WR(wr_upper), .DOUT({blah[3:2],tag_upper}));
    
    //FIXME : fanout 6;
    mux_nbit_2x1 #6 u_tag (tag_lower, tag_upper, index[3], tag);

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

endmodule

module data_store(
    input           clk,
    input   [3:0]   index,
    input           oe,
    input   [255:0] fill_data,
    input           wr,
    output  [255:0] r_data
    );
    
    wire w_wr;
    and2$ u_w_wr (w_wr,clk,wr);

    wire wr_upper, wr_lower;
    wire   [255:0] dout_upper;
    wire   [255:0] dout_lower;
    
    wire index_lower;
    NOT u_indexlower (index[3], index_lower);
    and2$ u_wr_upper (w_wr, index[3], wr_upper);
    and2$ u_wr_lower (w_wr, index_lower, wr_lower);
    
    ram_nB_8w upper_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_upper), .DOUT(dout_upper));
    ram_nB_8w lower_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_lower), .DOUT(dout_lower));
    
    //FIXME : Huge fanout for sel;
    mux_nbit_2x1 #256 u_r_data (dout_lower, dout_upper, index[3], r_data);

endmodule



