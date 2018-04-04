module rom_value_select(sr1_sel_reg,
                        sr1_sel_mem,
                        sr2_sel_reg,
                        sr2_sel_mem,
                        imm_sel_16,
                        imm_sel_32,
                        stack_off_sel_16,
                        stack_off_sel_32,
                        reg_rw_size_in,
                        mem_rd_size_in,
                        mem_wr_size_in,
                        alu1_op_size_in,
                        alu1_op1,
                        alu1_op2,
                        alu1_op3,
                        base_sel_in,
                        disp_sel_in,
                        SIB_pr_in,
                        mod,
                        mod_rm_pr,
                        reg_op,
                        prefix_op_size,
                        reg_rw_size_no_over,
                        mem_rd_size_no_over,
                        mem_wr_size_no_over,
                        alu1_op_size_no_over,
		        ret_op,
                        ld_seg,
                        sr1_sel,
                        sr2_sel,
                        imm_sel,
                        stack_off_sel,
                        reg_rw_size,
                        mem_rd_size,
                        mem_wr_size,
                        alu1_op_size,
                        alu1_op,
                        base_sel,
                        disp_sel,
                        SIB_pr);



input [1:0]  sr1_sel_reg;
input [1:0]  sr1_sel_mem;
input [1:0]  sr2_sel_reg;
input [1:0]  sr2_sel_mem;
input [1:0]  imm_sel_16;
input [1:0]  imm_sel_32;
input [1:0]  stack_off_sel_16;
input [1:0]  stack_off_sel_32;
input [1:0]  reg_rw_size_in;
input [1:0]  mem_rd_size_in;
input [1:0]  mem_wr_size_in;
input [1:0]  alu1_op_size_in;
input [3:0]  alu1_op1;
input [3:0]  alu1_op2;
input [3:0]  alu1_op3;
input        base_sel_in;
input  [1:0] disp_sel_in;
input        SIB_pr_in;
input  [1:0] mod;
input        mod_rm_pr;
input  [2:0] reg_op;
input        prefix_op_size;
input        reg_rw_size_no_over;
input        mem_rd_size_no_over;
input        mem_wr_size_no_over;
input        ret_op;
input        ld_seg;
input        alu1_op_size_no_over;
output [1:0] sr1_sel;
output [1:0] sr2_sel;
output [1:0] imm_sel;
output [1:0] stack_off_sel;
output [1:0] reg_rw_size;
output [1:0] mem_rd_size;
output [1:0] mem_wr_size;
output [1:0] alu1_op_size;
output [3:0] alu1_op;
output       base_sel;
output [1:0] disp_sel;
output       SIB_pr;

//Wires
wire [1:0] w_reg_size;
wire [1:0] w_mem_rd_0;
wire [1:0] w_mem_rd_1;
wire [1:0] w_mem_wr;
wire [1:0] w_alu_op;


and3$ modsel(.out(mod_sel), .in0(mod[0]), .in1(mod[1]), .in2(mod_rm_pr));

//SR sel
mux2bit_2x1 mux_sr1 (.Y(sr1_sel), .IN0(sr1_sel_mem), .IN1(sr1_sel_reg), .s0(mod_sel));
mux2bit_2x1 mux_sr2 (.Y(sr2_sel), .IN0(sr2_sel_mem), .IN1(sr2_sel_reg), .s0(mod_sel));

//Imm and stack sel
mux2bit_2x1 mux_imm (.Y(imm_sel), .IN0(imm_sel_32), .IN1(imm_sel_16), .s0(prefix_op_size));
mux2bit_2x1 mux_stk (.Y(stack_off_sel), .IN0(stack_off_sel_32), .IN1(stack_off_sel_16), .s0(prefix_op_size));

//reg read size
mux2bit_2x1 mux_reg0 (.Y(w_reg_size), .IN0(reg_rw_size_in), .IN1(2'b01), .s0(prefix_op_size));
mux2bit_2x1 mux_reg1 (.Y(reg_rw_size), .IN0(w_reg_size), .IN1(reg_rw_size_in), .s0(reg_rw_size_no_over));

//mem read size
nand2$ nand_ret_sel(.out(ret_sel), .in0(ret_op), .in1(ld_seg));
mux2bit_2x1 mux_mem0 (.Y(w_mem_rd_0), .IN0(2'b10), .IN1(2'b01), .s0(ret_sel));
mux2bit_2x1 mux_mem1 (.Y(w_mem_rd_1), .IN0(mem_rd_size_in), .IN1(w_mem_rd_0), .s0(prefix_op_size));
mux2bit_2x1 mux_mem2 (.Y(mem_rd_size), .IN0(w_mem_rd_1), .IN1(mem_rd_size_in), .s0(mem_rd_size_no_over));

//mem write size
mux2bit_2x1 mux_mem3 (.Y(w_mem_wr), .IN0(mem_wr_size_in), .IN1(2'b01), .s0(prefix_op_size));
mux2bit_2x1 mux_mem4 (.Y(mem_wr_size), .IN0(w_mem_wr), .IN1(mem_wr_size_in), .s0(mem_wr_size_no_over));

//alu1 size
mux2bit_2x1 mux_alu0 (.Y(w_alu_op), .IN0(alu1_op_size_in), .IN1(2'b01), .s0(prefix_op_size));
mux2bit_2x1 mux_alu1 (.Y(alu1_op_size), .IN0(w_alu_op), .IN1(alu1_op_size_in), .s0(alu1_op_size_no_over));

//alu1 op select

nand2$ nand0 (.out(w_nand0), .in0(reg_op[2]), .in1(reg_op[0]));
and2$  and0  (.out(alu1_op_sel0), .in0(w_nand0), .in1(reg_op[0]));
and2$  and1  (.out(alu1_op_sel1), .in0(w_nand0), .in1(reg_op[2]));
mux4bit_3x1 mux_aluop (.Y(alu1_op), .IN0(alu1_op1), .IN1(alu1_op2), .IN2(alu1_op3), .s0(alu1_op_sel0), .s1(alu1_op_sel1));

//Base, disp, sib

and2$  base  (.out(base_sel), .in0(base_sel_in), .in1(mod_rm_pr));
and2$  sib   (.out(SIB_pr), .in0(SIB_pr_in), .in1(mod_rm_pr));
and2$  disp0 (.out(disp_sel[0]), .in0(disp_sel_in[0]), .in1(mod_rm_pr));
and2$  disp1 (.out(disp_sel[1]), .in0(disp_sel_in[1]), .in1(mod_rm_pr));

endmodule
