module fetch_control (
  input clk,
  input rst_n,
  input f_reset_fsm,
  input [31:0] r_EIP,
  input ic_hit,
  input de_p,
  input V_de,
  //input all stalls
  
  output [1:0] f_ld_buf,
  output f_address_sel,
  output f_ren,   
  output ld_de,
  output V_de
);

reg [2:0] f_curr_state,

wire EIP_1;

//EIP_1
assign EIP_1 = r_EIP[4];

//ren //FIXME mads: not of all future stalls and not int_trig
assign f_ren = 1'b1; 

endmodule
