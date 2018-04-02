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
end


//Signals between fetch and decode
//Output of fetch
wire [127:0] w_ic_data_shifted;
wire [31:0]  w_de_EIP_curr;
wire [15:0]  w_de_CS_curr;
wire         V_de;
wire         w_ld_de;

//Input to fetch 
wire        w_de_p;
wire [31:0] w_de_EIP_next;

// ***************** FETCH STAGE ******************

wire [1:0]    r_f_curr_state;
wire [1:0]    w_f_next_state;
wire          w_f_address_sel; 
wire [31:0]   w_f_address;
wire [2:0]    w_f_PFN;
wire [1:0]    w_f_ld_buf;
wire          w_f_ren;
wire          w_ic_hit;
wire          w_ic_miss;
wire [31:0]   w_ic_miss_address;
wire          w_ic_miss_ack;
wire [31:0]   w_ic_miss_ack_address;
wire [255:0]  w_ic_fill_data;
wire [127:0]  w_icache_lower_data;
wire [127:0]  w_icache_upper_data;
wire [127:0]  w_icache_lower_data_reg;
wire [127:0]  w_icache_upper_data_reg;
wire [127:0]  w_icache_shifted_lower_data;
wire [127:0]  w_icache_shifted_upper_data;

// EIP register
wire [31:0] r_EIP;
//FIXME - mads Incorporate wback of EIP
assign r_EIP = 32'h1000;


wire [31:0] w_EIP_plus_32;
kogge_stone #32 u_EIP_reg ( .a(r_EIP), .b(32'h10), .cin(1'b0), .out(w_EIP_plus_32), .vout(/*Unused*/) , .cout(/*Unused*/) ); 

// fetch_address
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
  .f_ld_buf   (w_f_ld_buf),
  .f_curr_st  (r_f_curr_state),
  .f_next_st  (w_f_next_state),
  .f_address_sel  (w_f_address_sel)
  );

//Fetch TLB lookup
fetch_TLB_lookup u_f_tlb_lookup(
  .TLB({TLB[7], TLB[6], TLB[5], TLB[4], TLB[3], TLB[2], TLB[1], TLB[0]}),  
  .CS_limit   (CS_limit),
  .f_ren      (w_f_ren),
  .f_address  (w_f_address),  
  .f_PFN      (w_f_PFN),
  .f_prot_exp (w_f_prot_exp),
  .f_pg_fault (w_f_pg_fault)
);


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
  .r_data       ({w_icache_upper_data,w_icache_lower_data}),
  .ic_hit       (w_ic_hit),
  .ic_miss      (w_ic_miss),
  .ic_addr      (w_ic_miss_addr)
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

endmodule

