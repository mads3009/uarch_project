module register_addr_dependency(sr1_needed,
                                sr2_needed,
                                sr1_eax,
                                sr2_ecx,
                                sr3_eax,
                                sr3_esp,
                                sr1_rm,
                                sr2_rm,
                                mod,
                                base,
                                index,
                                r_m,
                                mod_rm_pr,
                                sib_pr,
                                cmps_op,
                                cxchg_op,
                                reg_op,
                                reg_rw_size,
                                prefix_repne,
                                ld_sr1,
                                ld_sr2,
                                stack_read,
                                stack_write,
                                in1_needed,
                                in2_needed,
                                in3_needed,
                                in4_needed,
                                in1,
                                in2,
                                in3,
                                in4,
                                reg8_sr1_HL_sel,
                                reg8_sr2_HL_sel,
                                dreg1,
                                dreg2,
                                dreg3,
                                ld_reg1_strb,
                                ld_reg2_strb,
                                ld_reg3_strb,
                                ld_reg1,
                                ld_reg2,
                                ld_reg3

                                );

input       sr1_needed;
input       sr2_needed;
input       sr1_eax;
input       sr2_ecx;
input       sr3_eax;
input       sr3_esp;
input       sr1_rm;
input       sr2_rm;
input  [1:0]mod;
input  [2:0]base;
input  [2:0]index;
input  [2:0]r_m;
input       mod_rm_pr;
input       sib_pr;
input       cmps_op;
input       cxchg_op;
input  [2:0]reg_op;
input  [1:0]reg_rw_size;
input       prefix_repne;
input       ld_sr1;
input       ld_sr2;
input       stack_read;
input       stack_write;

output      in1_needed;
output      in2_needed;
output      in3_needed;
output      in4_needed;
output [2:0]in1; 
output [2:0]in2; 
output [2:0]in3; 
output [2:0]in4;
output      reg8_sr1_HL_sel;
output      reg8_sr2_HL_sel;
output [2:0]dreg1;
output [2:0]dreg2;
output [2:0]dreg3;
output [3:0]ld_reg1_strb;
output [3:0]ld_reg2_strb;
output [3:0]ld_reg3_strb;
output      ld_reg1;
output      ld_reg2;
output      ld_reg3;


//Internal wires
wire [2:0] w_base_rm;
wire [2:0] w_in3_rm_regop;
wire [2:0] w_in4_rm_regop;

wire [2:0]w_esi_r;
wire [2:0]w_edi_r;
wire [2:0]w_eax_r;
wire [2:0]w_ecx_r;
wire in3_4_sel;
wire reg8_HL_sel;

wire in3_reg8_msb;
wire in4_reg8_msb;
wire [2:0]w_in3;
wire [2:0]w_in4;

// Register Address

//in1
mux3bit_2x1 muxin1_0(.Y(w_base_rm), .IN0(r_m), .IN1(base), .s0(sib_pr));
mux3bit_2x1 muxin1_1(.Y(in1), .IN0(w_base_rm), .IN1(3'd6), .s0(cmps_op));

//in2
mux3bit_2x1 muxin2_0(.Y(in2), .IN0(index), .IN1(3'd7), .s0(cmps_op));

//in3

mux3bit_2x1 muxin3_0(.Y(w_in3_rm_regop), .IN0(reg_op), .IN1(r_m), .s0(sr1_rm));
mux3bit_2x1 muxin3_1(.Y(w_esi_r), .IN0(w_in3_rm_regop), .IN1(3'd6), .s0(cmps_op));
mux3bit_2x1 muxin3_2(.Y(w_eax_r), .IN0(w_esi_r), .IN1(3'd0), .s0(sr1_eax));

nor2$ norin3_0(.out(in3_4_sel), .in0(reg_rw_size[0]), .in1(reg_rw_size[1]));
mux3bit_2x1 muxin3_4(.Y(w_in3), .IN0(w_eax_r), .IN1({1'b0,w_eax_r[1:0]}), .s0(in3_4_sel));

assign in3_reg8_msb = w_eax_r[2];
assign in3 = w_in3;

//in4
mux3bit_2x1 muxin4_0(.Y(w_in4_rm_regop), .IN0(reg_op), .IN1(r_m), .s0(sr2_rm));
mux3bit_2x1 muxin4_1(.Y(w_edi_r), .IN0(w_in4_rm_regop), .IN1(3'd7), .s0(cmps_op));
mux3bit_2x1 muxin4_2(.Y(w_ecx_r), .IN0(w_edi_r), .IN1(3'd1), .s0(sr2_ecx));
mux3bit_2x1 muxin4_4(.Y(w_in4), .IN0(w_ecx_r), .IN1({1'b0,w_ecx_r[1:0]}), .s0(in3_4_sel));

assign in4_reg8_msb = w_ecx_r[2];
assign in4 = w_in4;


//reg_HL_sel
nor2$ norsel(.out(reg8_HL_sel), .in0(reg_rw_size[0]), .in1(reg_rw_size[1]));
mux2$ mux0_HL_sel(.outb(reg8_sr1_HL_sel), .in0(1'd0), .in1(in3_reg8_msb), .s0(reg8_HL_sel));
mux2$ mux1_HL_sel(.outb(reg8_sr2_HL_sel), .in0(1'd0), .in1(in4_reg8_msb), .s0(reg8_HL_sel));

// Dependency Logic 
//Fix behavioral
dep_ld_reg dep(.cmps_op(cmps_op),
                   .mod(mod),
                   .mod_rm_pr(mod_rm_pr),
                   .sib_pr(sib_pr), 
                   .sr1_needed(sr1_needed),
                   .sr2_needed(sr2_needed),
                   .sr1_rm(sr1_rm),
                   .sr2_rm(sr2_rm),
                   .sr3_eax(sr3_eax),
                   .sr3_esp(sr3_esp),
                   .ld_sr1(ld_sr1),
                   .ld_sr2(ld_sr2),
                   .in1_needed(in1_needed),
                   .in2_needed(in2_needed),
                   .in3_needed(in3_needed), 
                   .in4_needed(in4_needed), 
                   .eax_needed(eax_needed), 
                   .esp_needed(esp_needed),
                   .ld_r1(ld_r1),
                   .ld_r2(ld_r2)
                    ); 


//Dreg and Loads
wire [2:0]w_dreg2;
wire [3:0]w_ld1_0;
wire [3:0]w_ld1_1;
wire [3:0]w_ld1_2;
wire [3:0]w_ld2_0;
wire [3:0]w_ld2_1;
wire [3:0]w_ld2_2;
wire [3:0]w_ld2_3;
or2$ or_stack (.out(stack_op), .in0(stack_read), .in1(stack_write));

assign dreg1 = w_in3;
mux3bit_2x1 mux_dreg_0 (.Y(w_dreg2), .IN0(w_in4), .IN1(3'd0), .s0(cxchg_op));
mux3bit_2x1 mux_dreg_1 (.Y(dreg2), .IN0(w_dreg2), .IN1(3'd4), .s0(stack_op));

assign dreg3 = 3'd1;

mux4bit_2x1 mux_ld1reg_0 (.Y(w_ld1_0), .IN0(4'b0001), .IN1(4'b0010), .s0(in3_reg8_msb));
mux4bit_2x1 mux_ld1reg_1 (.Y(w_ld1_1), .IN0(w_ld1_0), .IN1(4'b0011), .s0(reg_rw_size[0]));
mux4bit_2x1 mux_ld1reg_2 (.Y(w_ld1_2), .IN0(w_ld1_1), .IN1(4'b1111), .s0(reg_rw_size[1]));
mux4bit_2x1 mux_ld1reg_3 (.Y(ld_reg1_strb), .IN0(4'b0000), .IN1(w_ld1_2), .s0(ld_r1));
or4$ or_ldreg1(.out(ld_reg1), .in0(ld_reg1_strb[0]), .in1(ld_reg1_strb[1]), .in2(ld_reg1_strb[2]), .in3(ld_reg1_strb[3]));


mux4bit_2x1 mux_ld2reg_0 (.Y(w_ld2_0), .IN0(4'b0001), .IN1(4'b0010), .s0(in4_reg8_msb));
mux4bit_2x1 mux_ld2reg_1 (.Y(w_ld2_1), .IN0(w_ld2_0), .IN1(4'b0011), .s0(reg_rw_size[0]));
mux4bit_2x1 mux_ld2reg_2 (.Y(w_ld2_2), .IN0(w_ld2_1), .IN1(4'b1111), .s0(reg_rw_size[1]));
mux4bit_2x1 mux_ld2reg_3 (.Y(w_ld2_3), .IN0(4'b0000), .IN1(w_ld2_2), .s0(ld_r2));
mux4bit_2x1 mux_ld2reg_4 (.Y(ld_reg2_strb), .IN0(w_ld2_3), .IN1(4'b1111), .s0(stack_op));
or4$ or_ldreg2(.out(ld_reg2), .in0(ld_reg2_strb[0]), .in1(ld_reg2_strb[1]), .in2(ld_reg2_strb[2]), .in3(ld_reg2_strb[3]));

assign ld_reg3_strb[0] = prefix_repne;
assign ld_reg3_strb[1] = prefix_repne;
assign ld_reg3_strb[2] = prefix_repne;
assign ld_reg3_strb[3] = prefix_repne;
assign ld_reg3 = prefix_repne;



endmodule

 
