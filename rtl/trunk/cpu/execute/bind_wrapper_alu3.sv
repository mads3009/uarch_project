module alu3_props(
    clk, 
    rst,
    mm1,
    mm2,
    sr2,
    ecx,
    alu3_op,
    alu_res3  
);
input clk;
input rst;
input [63:0]mm1;
input [63:0]mm2;
input [31:0]sr2;
input [31:0]ecx;
input [4:0] alu3_op;
input [63:0]alu_res3;  


reg [63:0]r_alu_res3;  
reg [63:0]r_alu_res3_tmp;  
reg [63:0]r_alu_res3_tmp1;  
reg [63:0]r_alu_res3_tmp2;  
reg [63:0]r_alu_res3_tmp3;  
reg [63:0]r_alu_res3_tmp4; 
reg [5:0] shft0; 
reg [5:0] shft1; 
reg [5:0] shft2; 
reg [5:0] shft3; 

always @(posedge clk, posedge rst) begin
  if(rst) begin
    r_alu_res3   = 63'd0;
  end
  else begin
    case(alu3_op)
    
    5'b00000: begin
      r_alu_res3[31:0]    = mm1[31:0] + mm2[31:0];
      r_alu_res3[63:32]   = mm1[63:32] + mm2[63:32];
    end
   
    5'b01000: begin
      
      r_alu_res3_tmp[15:0] = mm1[15:0] + mm2[15:0];
      r_alu_res3_tmp[31:16]= mm1[31:16] + mm2[31:16];
      r_alu_res3_tmp[47:32]= mm1[47:32] + mm2[47:32];
      r_alu_res3_tmp[63:48]= mm1[63:48] + mm2[63:48];
      r_alu_res3[15:0]     = r_alu_res3_tmp[15:0]; 
      r_alu_res3[31:16]    = r_alu_res3_tmp[31:16];
      r_alu_res3[47:32]    = r_alu_res3_tmp[47:32];
      r_alu_res3[63:48]    = r_alu_res3_tmp[63:48];
      if ((mm1[15] == mm2[15]) & (mm1[15] != r_alu_res3_tmp[15]))
      begin
         if(mm1[15] == 1'b1)
           begin 
           r_alu_res3[15:0] = 16'h8000;
           end
         else
           begin
           r_alu_res3[15:0] = 16'h7FFF;
           end
      end
      
      if ((mm1[31] == mm2[31]) & (mm1[31] != r_alu_res3_tmp[31]))
      begin
         if(mm1[31] == 1'b1)
           begin 
           r_alu_res3[31:16] = 16'h8000;
           end
         else
           begin
           r_alu_res3[31:16] = 16'h7FFF;
           end
      end

      if ((mm1[47] == mm2[47]) & (mm1[47] != r_alu_res3_tmp[47]))
      begin
         if(mm1[47] == 1'b1)
           begin 
           r_alu_res3[47:32] = 16'h8000;
           end
         else
           begin
           r_alu_res3[47:32] = 16'h7FFF;
           end
      end

      if ((mm1[63] == mm2[63]) & (mm1[63] != r_alu_res3_tmp[63]))
      begin
         if(mm1[63] == 1'b1)
           begin 
           r_alu_res3[63:48] = 16'h8000;
           end
         else
           begin
           r_alu_res3[63:48] = 16'h7FFF;
           end
      end
    end
        
    5'b10100: begin
      r_alu_res3[15:0]    = mm1[15:0] + mm2[15:0];
      r_alu_res3[31:16]    = mm1[31:16] + mm2[31:16];
      r_alu_res3[47:32]    = mm1[47:32] + mm2[47:32];
      r_alu_res3[63:48]    = mm1[63:48] + mm2[63:48];
      end

    5'b10010: begin
      shft0 = sr2[1:0] << 3'd4;
      shft1 = sr2[3:2] << 3'd4;
      shft2 = sr2[5:4] << 3'd4;
      shft3 = sr2[7:6] << 3'd4;
      r_alu_res3_tmp1    =  (mm2 >> shft0);
      r_alu_res3[15:0]   =  r_alu_res3_tmp1[15:0];
      r_alu_res3_tmp2    = (mm2 >> shft1);
      r_alu_res3[31:16]  =  r_alu_res3_tmp2[15:0];
      r_alu_res3_tmp3    = (mm2 >> shft2);
      r_alu_res3[47:32]  =  r_alu_res3_tmp3[15:0];
      r_alu_res3_tmp4    = (mm2 >> shft3);
      r_alu_res3[63:48]  =  r_alu_res3_tmp4[15:0];

    end

    5'b10001: begin
      r_alu_res3      =  mm2 ;
    end

    5'b10000: begin
      r_alu_res3       = mm1 ;
    end
   
    5'b11000: begin
      r_alu_res3[31:0] = ecx - 32'd1 ;
      r_alu_res3[63:32] = 32'd0 ;
     end
    endcase
   end
  end

assert_alu_res3_chk   : assert property(@(posedge clk) r_alu_res3   == alu_res3);
assume_alu3_op        : assume property(@(posedge clk)((alu3_op == 5'b00000) || (alu3_op == 5'b01000)|| (alu3_op == 5'b10100) || (alu3_op == 5'b10010) ||  
                                                       (alu3_op == 5'b10001) || (alu3_op == 5'b10000)|| (alu3_op == 5'b11000)   ));

endmodule
 
module Wrapper;

//Binding the properties module with the arbiter module to instantiate the properties
bind alu3_top alu3_props u_alu3_props (
      .clk                               (clk),                       
      .rst                               (rst),
      .mm1                               (mm1),
      .mm2                               (mm2),
      .sr2                               (sr2),
      .ecx                               (ecx),
      .alu3_op                           (alu3_op),
      .alu_res3                          (alu_res3)
);


endmodule


