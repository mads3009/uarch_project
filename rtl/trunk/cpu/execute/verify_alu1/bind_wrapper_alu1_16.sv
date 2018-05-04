module alu1_props(
    clk, 
    rst,
    sr1,
    sr2,
    mem_out,
    mem_out_latched,
    eax,
    alu1_op,
    alu1_op_size,
    mem_rd_size ,
    CF_in,
    AF_in,
    DF_in,
    df_val,
    ld_flag_CF_in,
    ld_flag_PF_in,
    ld_flag_AF_in,
    ld_flag_ZF_in,
    ld_flag_SF_in,
    ld_flag_OF_in,
    ISR, 
    alu_res1_in,  
    alu1_flags_in, 
    cmps_flags_in, 
    df_val_ex_in,
    ld_flag_CF_out_in,
    ld_flag_PF_out_in,
    ld_flag_AF_out_in,
    ld_flag_ZF_out_in,
    ld_flag_SF_out_in,
    ld_flag_OF_out_in       );

input clk;
input rst;
input [31:0]sr1;
input [31:0]sr2;
input [31:0]mem_out;
input [31:0]mem_out_latched ;
input [31:0]eax;
input [3:0] alu1_op;
input [1:0] alu1_op_size;
input [1:0] mem_rd_size;
input CF_in;
input AF_in;
input DF_in;
input df_val;
input ISR;
input ld_flag_CF_in;
input ld_flag_PF_in;
input ld_flag_AF_in;
input ld_flag_ZF_in;
input ld_flag_SF_in;
input ld_flag_OF_in;
input [31:0]alu_res1_in;  
input [5:0] alu1_flags_in; 
input [5:0] cmps_flags_in; 
input df_val_ex_in;
input ld_flag_CF_out_in;
input ld_flag_PF_out_in;
input ld_flag_AF_out_in;
input ld_flag_ZF_out_in;
input ld_flag_SF_out_in;
input ld_flag_OF_out_in;


reg [31:0]alu_res1;  
reg [5:0] alu1_flags; 
reg [5:0] cmps_flags; 
reg df_val_ex;
reg ld_flag_CF;
reg ld_flag_PF;
reg ld_flag_AF;
reg ld_flag_ZF;
reg ld_flag_SF;
reg ld_flag_OF;
reg [32:0]alu_res1_33;
reg [31:0]cmps_res;
reg [32:0]cmps_res_33;
reg [4:0] alu_res_af;



localparam CF = 3'd0;
localparam PF = 3'd1;
localparam AF = 3'd2;
localparam ZF = 3'd3;
localparam SF = 3'd4;
localparam OF = 3'd5;

always @(posedge clk, posedge rst) begin
  if(rst) begin
    alu_res1   = 32'd0;
    alu1_flags = 6'd0;
    cmps_flags = 6'd0;
    df_val_ex  = 1'd0;
    ld_flag_CF = 6'd0;
    ld_flag_PF = 6'd0;
    ld_flag_AF = 6'd0;
    ld_flag_ZF = 6'd0;
    ld_flag_SF = 6'd0;
    ld_flag_OF = 6'd0;
    
  end
  else begin
    case(alu1_op)
//or
    4'b0000: begin
      alu_res1   = sr1 | sr2;
      alu1_flags[CF] = 1'b0; 
      alu1_flags[PF] = ~^alu_res1[7:0]; 
      alu1_flags[AF] = 1'b0; 
      alu1_flags[ZF] = ~|alu_res1[15:0]; 
      alu1_flags[SF] = alu_res1[15]; 
      alu1_flags[OF] = 1'b0; 

    end
//and    
    4'b0001: begin
      alu_res1   = sr1 & sr2;
      alu1_flags[CF] = 1'b0; 
      alu1_flags[PF] = ~^alu_res1[7:0]; 
      alu1_flags[AF] = 1'b0; 
      alu1_flags[ZF] = ~|alu_res1[15:0]; 
      alu1_flags[SF] = alu_res1[15]; 
      alu1_flags[OF] = 1'b0;
    end
//sal         
    4'b0010: begin
      alu_res1       = sr1 << sr2[4:0];
      alu_res1_33    = sr1 << sr2[4:0];
      alu1_flags[CF] = alu_res1_33[16]; 
      alu1_flags[PF] = ~^alu_res1[7:0]; 
      alu1_flags[AF] = 1'b0; 
      alu1_flags[ZF] = ~|alu_res1[15:0]; 
      alu1_flags[SF] = alu_res1[15]; 
      alu1_flags[OF] = (alu_res1[15] == alu1_flags[CF]) ? 1'b0 : 1'b1 ; 
     end
//sar
    4'b0011: begin
      alu_res1       = $signed(sr1[15:0]) >>> $signed(sr2[4:0]);
      alu_res1_33    = $signed({sr1[15:0],1'b0}) >>> $signed(sr2[4:0]);
      alu1_flags[CF] = alu_res1_33[0]; 
      alu1_flags[PF] = ~^alu_res1[7:0]; 
      alu1_flags[AF] = 1'b0; 
      alu1_flags[ZF] = ~|alu_res1[15:0]; 
      alu1_flags[SF] = alu_res1[15]; 
      alu1_flags[OF] = 1'b0 ; 

     end

    4'b0100: begin
      alu_res1       = sr1 ;
      alu1_flags[CF] =sr1[0]; 
      alu1_flags[PF] =sr1[2]; 
      alu1_flags[AF] =sr1[4]; 
      alu1_flags[ZF] =sr1[6]; 
      alu1_flags[SF] =sr1[7]; 
      alu1_flags[OF] =sr1[11];
 
    end

    4'b0101: begin
      alu_res1       = sr2 ;
    
      alu1_flags[CF] =sr1[0]; 
      alu1_flags[PF] =sr1[2]; 
      alu1_flags[AF] =sr1[4]; 
      alu1_flags[ZF] =sr1[6]; 
      alu1_flags[SF] =sr1[7]; 
      alu1_flags[OF] =sr1[11];
 
    end
   
    4'b0110: begin
      alu_res1       = 32'd0 ;
     
      alu1_flags[CF] =sr1[0]; 
      alu1_flags[PF] =sr1[2]; 
      alu1_flags[AF] =sr1[4]; 
      alu1_flags[ZF] =sr1[6]; 
      alu1_flags[SF] =sr1[7]; 
      alu1_flags[OF] =sr1[11]; 
    end
 
    4'b0111: begin
      alu_res1       = ~sr1 ;
     
      alu1_flags[CF] =sr1[0]; 
      alu1_flags[PF] =sr1[2]; 
      alu1_flags[AF] =sr1[4]; 
      alu1_flags[ZF] =sr1[6]; 
      alu1_flags[SF] =sr1[7]; 
      alu1_flags[OF] =sr1[11]; 
    end

    4'b1000: begin
      alu_res1       = sr1 + 32'd1 ;
      alu_res1_33    = {1'b0,sr1[15:0]} + 17'd1 ;
      alu_res_af    =  {1'b0,sr1[3:0]} + 5'd1;
      alu1_flags[CF] = alu_res1_33[16]; 
      alu1_flags[PF] = ~^alu_res1[7:0]; 
      alu1_flags[AF] = alu_res_af[4]; 
      alu1_flags[ZF] = ~|alu_res1[15:0]; 
      alu1_flags[SF] = alu_res1[15]; 
      alu1_flags[OF] = ( (sr1[15] == 1'b0)&(sr1[15] != alu_res1[15]) ) ? 1'b1 : 1'b0; 
    end

    4'b1001: begin
      alu_res1       = sr1 + sr2 ;
      alu_res1_33    = {1'b0,sr1[15:0]} + {1'b0,sr2[15:0]} ;
      alu_res_af    =  sr1[3:0] + sr2[3:0];
      alu1_flags[CF] = alu_res1_33[16]; 
      alu1_flags[PF] = ~^alu_res1[7:0]; 
      alu1_flags[AF] = alu_res_af[4]; 
      alu1_flags[ZF] = ~|alu_res1[15:0]; 
      alu1_flags[SF] = alu_res1[15]; 
      alu1_flags[OF] = ( (sr1[15] == sr2[15])&(sr1[15] != alu_res1[15]) ) ? 1'b1 : 1'b0;  
    end

    4'b1010: begin
      if (DF_in == 1'b0)
      begin 
      	alu_res1 = sr1 + 32'd2 ;
      end
      else
      begin
        alu_res1 = sr1 - 32'd2;
      end
      alu1_flags[CF] = 6'd0; 
      alu1_flags[PF] = 6'd0; 
      alu1_flags[AF] = 6'd0; 
      alu1_flags[ZF] = 6'd0; 
      alu1_flags[SF] = 6'd0; 
      alu1_flags[OF] = 6'd0; 

    end


    4'b1011: begin
      alu_res1      = sr1 ;
      alu_res1_33   = {1'b0,eax[15:0]} - {1'b0, sr1[15:0]} ;
      alu1_flags[CF] = (eax[15:0]< sr1[15:0])? 1'b1: 1'b0; 
      alu1_flags[PF] = ~^alu_res1_33[7:0]; 
      alu1_flags[AF] = (eax[3:0] < sr1[3:0]) ? 1'b1: 1'b0; 
      alu1_flags[ZF] = ~|(alu_res1_33[15:0]); 
      alu1_flags[SF] = alu_res1_33[15]; 
      alu1_flags[OF] = ( (eax[15] == (!sr1[15]))&(eax[15] != alu_res1_33[15]) ) ? 1'b1 : 1'b0;  
    end

    4'b1100: begin
      if ( (eax[3:0] > 4'h9) | (AF_in ==1'b1))
      begin
        alu_res1[7:0]  = eax[7:0] + 8'h6;
        alu_res1[31:8] = eax[31:8];
        alu1_flags[AF] = 1'b1;
      end 
      else
      begin
        alu_res1       = eax;
        alu1_flags[AF] = 1'b0;
      end

      if ( (eax[7:0] > 8'h99) | (CF_in ==1'b1))
      begin
        alu_res1[7:0] = alu_res1[7:0] + 8'h60; 
        alu_res1[31:8] = alu_res1[31:8];
        alu1_flags[CF] = 1'b1;
      end 
      else
      begin
        alu_res1       = alu_res1;
        alu1_flags[CF] = 1'b0;
      end
      alu1_flags[PF] = ~^alu_res1[7:0]; 
      alu1_flags[ZF] = ~|alu_res1[7:0]; 
      alu1_flags[SF] = alu_res1[7]; 
      alu1_flags[OF] =  1'b0;  
    end
  
   endcase
   if ( (alu1_op[3:1] == 3'b001) & (sr2[4:0] ==5'd0))
   begin
     ld_flag_CF = 6'd0;
     ld_flag_PF = 6'd0;
     ld_flag_AF = 6'd0;
     ld_flag_ZF = 6'd0;
     ld_flag_SF = 6'd0;
     ld_flag_OF = 6'd0;
   end
   else
   begin
     ld_flag_CF = ld_flag_CF_in;
     ld_flag_PF = ld_flag_PF_in;
     ld_flag_AF = ld_flag_AF_in;
     ld_flag_ZF = ld_flag_ZF_in;
     ld_flag_SF = ld_flag_SF_in;
     ld_flag_OF = ld_flag_OF_in;
   end
    
   cmps_res       = mem_out_latched - mem_out;  
   cmps_res_33    = {1'b0,mem_out_latched[15:0]} - {1'b0, mem_out[15:0]} ;  
   cmps_flags[CF] = (mem_out_latched[15:0]< mem_out[15:0])? 1'b1 : 1'b0; 
   cmps_flags[PF] = ~^cmps_res[7:0]; 
   cmps_flags[AF] = (mem_out_latched[3:0] < mem_out[3:0]) ? 1'b1 : 1'b0; 
   cmps_flags[ZF] = ~|cmps_res[15:0]; 
   cmps_flags[SF] = cmps_res[15]; 
   cmps_flags[OF] = ( (mem_out_latched[15] == (!mem_out[15]))&(mem_out_latched[15] != cmps_res[15]) ) ? 1'b1 : 1'b0;  
   df_val_ex      = ISR ? sr1[10] : df_val; 
   end
  end

assert_alu_res1_chk   : assert property(@(posedge clk) alu_res1   == alu_res1_in);
assert_alu1_flags_chk : assert property(@(posedge clk) alu1_flags == alu1_flags_in);
assert_cmps_flags_chk : assert property(@(posedge clk) cmps_flags == cmps_flags_in);
assert_df_val_ex_chk  : assert property(@(posedge clk) df_val_ex  == df_val_ex_in);
assert_ld_flag_cf_chk : assert property(@(posedge clk) ld_flag_CF == ld_flag_CF_out_in);
assert_ld_flag_pf_chk : assert property(@(posedge clk) ld_flag_PF == ld_flag_PF_out_in);
assert_ld_flag_af_chk : assert property(@(posedge clk) ld_flag_AF == ld_flag_AF_out_in);
assert_ld_flag_zf_chk : assert property(@(posedge clk) ld_flag_ZF == ld_flag_ZF_out_in);
assert_ld_flag_sf_chk : assert property(@(posedge clk) ld_flag_SF == ld_flag_SF_out_in);
assume_mem_rd_size    : assume property(@(posedge clk) mem_rd_size == 2'b01);
assume_alu1_op_size   : assume property(@(posedge clk)alu1_op_size == 2'b01);
assume_alu1_op        : assume property(@(posedge clk)((alu1_op >= 4'b0000) && (alu1_op <= 4'b1100)));

endmodule
 
module Wrapper;

//Binding the properties module with the arbiter module to instantiate the properties
bind alu1_top alu1_props u_alu1_props (
      .clk                               (clk),                       
      .rst                               (rst),
      .sr1                               (sr1),
      .sr2                               (sr2),
      .mem_out                           (mem_out),
      .mem_out_latched                   (mem_out_latched),
      .eax                               (eax),
      .alu1_op                           (alu1_op),
      .alu1_op_size                      (alu1_op_size),
      .mem_rd_size                       (mem_rd_size),
      .CF_in                             (CF_in),
      .AF_in                             (AF_in),
      .DF_in                             (DF_in),
      .df_val                            (df_val),
      .ld_flag_CF_in                     (ld_flag_CF_in),
      .ld_flag_PF_in                     (ld_flag_PF_in),
      .ld_flag_AF_in                     (ld_flag_AF_in),
      .ld_flag_ZF_in                     (ld_flag_ZF_in),
      .ld_flag_SF_in                     (ld_flag_SF_in),
      .ld_flag_OF_in                     (ld_flag_OF_in),
      .ISR                               (ISR), 
      .alu_res1_in                       (alu_res1),  
      .alu1_flags_in                     (alu1_flags), 
      .cmps_flags_in                     (cmps_flags), 
      .df_val_ex_in                      (df_val_ex),
      .ld_flag_CF_out_in                 (ld_flag_CF),
      .ld_flag_PF_out_in                 (ld_flag_PF),
      .ld_flag_AF_out_in                 (ld_flag_AF),
      .ld_flag_ZF_out_in                 (ld_flag_ZF),
      .ld_flag_SF_out_in                 (ld_flag_SF),
      .ld_flag_OF_out_in                 (ld_flag_OF)       );





endmodule


