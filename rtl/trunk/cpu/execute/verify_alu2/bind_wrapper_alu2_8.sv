module alu2_props(
    clk, 
    rst,
    EIP_next,
    sr1,
    sr2,
    esp,
    DF_in,
    mem_rd_size ,
    mem_wr_size ,
    alu2_op,
    alu_res2  
);
input clk;
input rst;
input [31:0]EIP_next;
input [31:0]sr1;
input [31:0]sr2;
input [31:0]esp;
input DF_in;
input [1:0] mem_rd_size;
input [1:0] mem_wr_size;
input [3:0] alu2_op;
input [31:0]alu_res2;  


reg [31:0]r_alu_res2;  

always @(posedge clk, posedge rst) begin
  if(rst) begin
    r_alu_res2   = 32'd0;
  end
  else begin
    case(alu2_op)
    
    4'b0000: begin
      r_alu_res2   = sr1;
    end
   
    4'b0001: begin
      r_alu_res2   = sr2;
    end
        
    4'b0010: begin
      r_alu_res2       = EIP_next;
      end

    4'b0101: begin
      if (DF_in == 1'b0)
        begin 
      	r_alu_res2 = sr2 + 32'd1 ;
        end
      else if (DF_in == 1'b1) 
      begin
        r_alu_res2 = sr2 - 32'd1;
      end
     end

    4'b0110: begin
      r_alu_res2       =  esp - 32'd1 ;
    end

    4'b0100: begin
      r_alu_res2       = esp + 32'd1 ;
    end
   
    4'b1000: begin
      r_alu_res2       = esp + 32'd2 + sr1 ;
     end
    endcase
   end
  end

assert_alu_res2_chk   : assert property(@(posedge clk) r_alu_res2   == alu_res2);
assume_mem_rd_size   : assume property(@(posedge clk) mem_rd_size == 2'b00);
assume_mem_wr_size   : assume property(@(posedge clk) mem_wr_size == 2'b00);
assume_alu2_op        : assume property(@(posedge clk)((alu2_op >= 4'b0000) && (alu2_op <= 4'b0010)|| (alu2_op == 4'b0101) || (alu2_op == 4'b0110) || (alu2_op == 4'b0100)|| 
                                                       (alu2_op == 4'b1000)  ));

endmodule
 
module Wrapper;

//Binding the properties module with the arbiter module to instantiate the properties
bind alu2_top alu2_props u_alu2_props (
      .clk                               (clk),                       
      .rst                               (rst),
      .EIP_next                          (EIP_next),
      .sr1                               (sr1),
      .sr2                               (sr2),
      .esp                               (esp),
      .alu2_op                           (alu2_op),
      .mem_rd_size                       (mem_rd_size),
      .mem_wr_size                       (mem_wr_size),
      .DF_in                             (DF_in),
      .alu_res2                          (alu_res2)
);


endmodule


