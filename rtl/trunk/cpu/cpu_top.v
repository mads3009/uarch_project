module cpu_top
(
  input clk,
  input rst_n
);

//Signals between fetch and decode
//Output of fetch
  wire [1:0] f_ld_buf;
  wire [127:0] f_lower_data;
  wire [127:0] f_upper_data;

//Input to fetch
  wire de_p;
    
// ***************** FETCH STAGE ******************

// Fetch FSM
fetch_fsm u_fetch_fsm (
  .clk      (clk),
  .rst_n    (rst_n),
  .second   (f_second),
  .de_p     (de_p),
  .eip_4    (EIP_reg[4]),
  .ld_buf   (f_ld_buf),
  .curr_st  (f_state)
  );

//Instruction cache
i_cache u_i_cache (
  .clk          (clk),
  .ren          (f_ren),
  .index        (f_address[8:5]),
  .tag_14_12    (),
  .tag_11_9     (f_address[11:9]),
  .ic_fill_data (),
  .ic_miss_ack  (),
  .v_init       (),
  .r_data       (),
  .r_ready      (),
  .ic_miss      (),
  .ic_addr      ()
);              

endmodule


