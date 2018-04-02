module cpu (clk, rst_n);
  input clk;
  input rst_n;

// ********** Hardcoded entries ***********
//TLB entries
reg [26:0] TLB[7:0]; 

//Segment_limit_Regs
reg [31:0] CS_limit;
reg [31:0] DS_limit;
reg [31:0] SS_limit;
reg [31:0] ES_limit;
reg [31:0] FS_limit;
reg [31:0] GS_limit;

//Segment_Regs
reg [31:0] r_CS;
reg [31:0] r_DS;
reg [31:0] r_SS;
reg [31:0] r_ES;
reg [31:0] r_FS;
reg [31:0] r_GS;

initial begin
  TLB[0] = 30'h0000;
  TLB[1] = 30'h0000;
  TLB[2] = 30'h0000;
  TLB[3] = 30'h0000;
  TLB[4] = 30'h0000;
  TLB[5] = 30'h0000;
  TLB[6] = 30'h0000;
  TLB[7] = 30'h0000;
  
  CS_limit = 32'h3ff;
  r_CS = 16'h000;
end

//Loads and Valids of pipeline latches
wire r_V_de;
wire r_V_ag;
wire r_V_ro;
wire r_V_ex;
wire r_V_wb;
wire w_ld_de;
wire w_ld_ag;
wire w_ld_ro;
wire w_ld_ex;
wire w_ld_wb;

//Output latches fetch -> decode
wire [127:0] r_de_ic_data_shifted;
wire [31:0]  r_de_EIP_curr;
wire [15:0]  r_de_CS_curr;

//EIP register
wire [31:0] r_EIP;
//FIXME - mads Incorporate wback of EIP
assign r_EIP = 32'h1000;

// ***************** FETCH STAGE ******************

//Input to fetch 
wire        w_de_p;
wire [31:0] w_de_EIP_next;

//Output of fetch
wire [127:0] w_de_ic_data_shifted;
wire [31:0]  w_de_EIP_curr;
wire [15:0]  w_de_CS_curr;
wire         w_V_de;

assign w_de_EIP_curr = r_EIP;
assign w_de_CS_curr = r_CS;

//ICACHE to/from MMU
wire          w_ic_miss;
wire [31:0]   w_ic_miss_address;
wire          w_ic_miss_ack;
wire [31:0]   w_ic_miss_ack_address;
wire [255:0]  w_ic_fill_data;

//Internal to fetch
wire [1:0]    r_f_curr_state;
wire [1:0]    w_f_next_state;
wire          w_f_address_sel; 
wire [31:0]   w_f_address;
wire [2:0]    w_f_PFN;
wire [1:0]    w_f_ld_buf;
wire          w_f_ren;
wire          w_ic_hit;
wire [127:0]  w_icache_lower_data;
wire [127:0]  w_icache_upper_data;
wire [127:0]  w_icache_lower_data_reg;
wire [127:0]  w_icache_upper_data_reg;
wire [127:0]  w_icache_shifted_lower_data;
wire [127:0]  w_icache_shifted_upper_data;

wire [31:0] w_EIP_plus_32;
kogge_stone #32 u_EIP_reg ( .a(r_EIP), .b(32'h10), .cin(1'b0), .out(w_EIP_plus_32), .vout(/*Unused*/) , .cout(/*Unused*/) ); 

//fetch_address
mux_nbit_2x1 #32 u_f_address( .a0(w_EIP_plus_32), .a1(r_EIP), .sel(w_f_address_sel), .out(w_f_address));

/*
//Fetch control
fetch_control u_f_control(
  .clk    (clk),
  .rst_n  (rst_n),
  .f_reset_fsm  (w_f_reset_fsm),
  .r_EIP  (r_EIP),
  .ic_hit (w_ic_hit),
  .de_p   (w_de_p),
);
*/

//Fetch FSM
fetch_fsm u_f_fsm (
  .clk      (clk),
  .rst_n    (rst_n),
  .de_p     (w_de_p),
  .eip_4    (r_EIP[4]),
  .ic_hit   (w_ic_hit),
  .r_V_de   (r_V_de),
  .f_ld_buf   (w_f_ld_buf),
  .f_curr_st  (r_f_curr_state),
  .f_next_st  (w_f_next_state),
  .f_address_sel  (w_f_address_sel)
  );

//Fetch TLB lookup
fetch_TLB_lookup u_f_tlb_lookup(
  .TLB({TLB[7], TLB[6], TLB[5], TLB[4], TLB[3], TLB[2], TLB[1], TLB[0]}),  
  .CS_limit     (CS_limit),
  .f_ren        (w_f_ren),
  .f_address    (w_f_address),  
  .f_PFN        (w_f_PFN),
  .ic_prot_exp  (w_ic_prot_exp),
  .ic_page_fault(w_ic_page_fault)
);

wire w_ic_exp;
or2$ u_ic_exp(.out(w_ic_exp), .in0(w_ic_prot_exp), .in1(w_ic_page_fault));

//Instruction cache
i_cache u_i_cache (
  .clk          (clk),
  .rst_n        (rst_n),
  .ren          (w_f_ren),
  .index        (w_f_address[8:5]),
  .tag_14_12    (w_f_PFN),
  .tag_11_9     (w_f_address[11:9]),
  .ic_fill_data (w_ic_fill_data),
  .ic_miss_ack  (w_ic_miss_ack),
  .ic_exp       (w_ic_exp),
  .r_data       ({w_icache_upper_data,w_icache_lower_data}),
  .ic_hit       (w_ic_hit),
  .ic_miss      (w_ic_miss),
  .ic_miss_addr (w_ic_miss_addr)
);              

/*
//Latching icache data
register #128 u_i_lower_data_reg (clk, rst_n, 1'b1, icache_lower_data, icache_lower_data_reg, f_ld_buf[0]);
register #128 u_i_upper_data_reg (clk, rst_n, 1'b1, icache_upper_data, icache_upper_data_reg, f_ld_buf[1]);

//shifted icache data
//FIXME : need to multiply EIP with 8, and need shift right rotate
shift_right #256 u_i_shifter_ldata (
  .amt(r_EIP[4:0]),
  .sin(1'b0),
  .in({icache_upper_data, icache_lower_data}),
  .out({icache_shifted_upper_data, icache_shifted_lower_data}),
  .sout()
  );
*/

//Output of decode latches
register #128 u_de_ic_data_shifted (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_de_ic_data_shifted), .data_o(r_de_ic_data_shifted));
register  #32 u_de_EIP_curr        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_de_EIP_curr       ), .data_o(r_de_EIP_curr       ));
register  #16 u_de_CS_curr         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_de_CS_curr        ), .data_o(r_de_CS_curr        ));
register   #1 u_V_de               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_V_de              ), .data_o(r_V_de              ));

// ***************** DECODE STAGE ******************

endmodule

