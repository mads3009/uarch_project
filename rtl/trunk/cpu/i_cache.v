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

module i_cache(oe, index, tag_14_12, tag_11_9, ic_fill_data, ic_miss_ack, v_init, r_data, r_ready, ic_miss, ic_addr);
    input         oe;
    input  [3:0]  index;
    input  [2:0]  tag_14_12; 
    input  [2:0]  tag_11_9; 
    input  [255:0]ic_fill_data;
    input         ic_miss_ack;
    input         v_init;
    
    output [255:0]r_data;
    output        r_ready;
    output        ic_miss;
    output        ic_addr;
            	
    //Internal
    wire hit;
    wire [5:0] phy_tag;
    
    assign phy_tag = {tag_14_12,tag_11_9};
    
    assign ic_miss = ~hit && ~oe;
    assign ic_addr = {phy_tag,index,5'b0};
    
    assign r_ready = hit && ~oe;
    
    data_store ds(
        .index  (index),
        .oe     (oe),
        .fill_data  (ic_fill_data),
        .wr   (ic_miss_ack),
        .r_data     (r_data)
    );
    
    wire [5:0] tag_in_cache;
    wire valid;
    
    tag_store ts(
        .index (index),
        .oe(oe),
        .tag (tag_in_cache),
        .valid (valid),
        .wr (ic_miss_ack),
        .wr_tag(phy_tag),
        .v_init(v_init)
    );
    
    wire tag_match;
    assign tag_match = (tag_in_cache == phy_tag);
    
    assign r_ready = tag_match && hit && ~oe;

endmodule
 
module ramnB8w(A, DIN, WR, OE, DOUT);
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
    input [3:0] index,
    input       oe,
    input [5:0] wr_tag,
    input       wr,
    input       v_init,
    output [5:0] tag,
    output       valid
    );

    wire wr_upper, wr_lower;
    wire   [5:0] tag_upper;
    wire   [5:0] tag_lower;
    
    wire   [3:0] blah;
    
    assign wr_upper = wr && index[3];
    assign wr_lower = wr && ~index[3];
    
    ram8b8w$ ts_lower (.A(index[2:0]), .DIN({2'b0,wr_tag}), .OE(oe), .WR(wr_lower), .DOUT({blah[1:0],tag_lower}));
    ram8b8w$ ts_upper (.A(index[2:0]), .DIN({2'b0,wr_tag}), .OE(oe), .WR(wr_upper), .DOUT({blah[3:2],tag_upper}));
    
    assign tag = index[3] ? tag_upper : tag_lower;

    //latches for valid;
    wire [15:0] enables;
    wire tag_v_in;
    wire [15:0] tag_vs;
    wire [15:0] one_hot_wr;

    assign enable = v_init | wr;
    demux_1x16 demux (1'b1, index ,one_hot_wr);    
    assign tag_v_in = (v_init) ? 1'b0 : 1'b1;
    assign enables = (v_init) ? 16'hffff : one_hot_wr;

    genvar i;
    generate begin : loop
    for (i=0; i<16; i=i+1) begin
    latch$ valids(
        .en(enables[i]),
        .d(tag_v_in),
        .q(tag_vs[i]),
        .r(1'b1),
        .s(1'b1),
        .qbar ()
    );
    end
    end
    endgenerate

    mux_16x1 u_valid (tag_vs, index, valid);
endmodule

module data_store(
    input   [3:0]   index,
    input           oe,
    input   [255:0] fill_data,
    input           wr,
    output  [255:0] r_data
    );
    
    wire wr_upper, wr_lower;
    wire   [255:0] dout_upper;
    wire   [255:0] dout_lower;
    
    assign wr_upper = wr && index[3];
    assign wr_lower = wr && ~index[3];
    
    ramnB8w upper_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_upper), .DOUT(dout_upper));
    ramnB8w lower_ram (.A(index[2:0]), .DIN(fill_data), .OE(oe), .WR(wr_lower), .DOUT(dout_lower));
    
    assign r_data = index[3] ? dout_upper : dout_lower;

endmodule



