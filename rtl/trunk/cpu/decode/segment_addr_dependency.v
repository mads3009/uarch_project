module segment_addr_dependency(cmps_op,
                               mod,
                               reg_op,
                               seg3_sel,
                               prefix_seg_reg,
                               mod_rm_pr,
                               stack_read,
                               stack_write,
                               seg3_needed_in,
                               seg3_sel_over,
                               prefix_seg_over,
                               seg2_sel,
                               dseg_in,
                               ld_seg_in,
                               seg1_needed,
                               seg2_needed,
                               seg3_needed,
                               seg1,
                               seg2,
                               seg3,
                               dseg,
                               ld_seg
                               );


input       cmps_op;
input [1:0] mod;
input [2:0] reg_op;
input [2:0] seg3_sel;
input [2:0] prefix_seg_reg;
input       mod_rm_pr;
input       stack_read;
input       stack_write;
input       seg3_needed_in;
input       seg3_sel_over;
input       prefix_seg_over;
input       seg2_sel;
input [2:0] dseg_in;
input       ld_seg_in;
output      seg1_needed;
output      seg2_needed;
output      seg3_needed;
output [2:0]seg1;
output [2:0]seg2;
output [2:0]seg3;
output [2:0]dseg;
output      ld_seg;

localparam DS = 3'd3;
localparam ES = 3'd0;
localparam SS = 3'd2;
//Internal wires



//Source and destination segment Register adrress

mux3bit_2x1 muxseg1_0(.Y(seg1), .IN0(DS), .IN1(prefix_seg_reg), .s0(prefix_seg_over)); 
mux3bit_2x1 muxseg2_0(.Y(seg2), .IN0(SS), .IN1(ES), .s0(seg2_sel)); 
mux3bit_2x1 muxseg3_0(.Y(seg3), .IN0(seg3_sel), .IN1(reg_op), .s0(seg3_sel_over)); 

mux3bit_2x1 muxdseg(.Y(dseg), .IN0(dseg_in), .IN1(reg_op), .s0(seg3_sel_over)); 
assign ld_seg = ld_seg_in;

//Segment Dependency Logic

dependency_seg dep(.cmps_op(cmps_op),
                   .mod(mod),
                   .mod_rm_pr(mod_rm_pr),
                   .stack_read(stack_read),
                   .stack_write(stack_write),
                   .seg3_needed_in(seg3_needed_in),
                   .seg1_needed(seg1_needed),
                   .seg2_needed(seg2_needed),
                   .seg3_needed(seg3_needed));

endmodule


