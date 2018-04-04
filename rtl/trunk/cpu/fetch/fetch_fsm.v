module fetch_fsm(
  input     clk,
  input     rst_n,
  input     de_p,
  input     eip_4,
  input     ic_hit,
  input     r_V_de,
  output reg [1:0] f_ld_buf,
  output reg [1:0] f_curr_st,
  output reg [1:0] f_next_st,
  output reg  f_address_sel
  );

  localparam IDLE    = 3'b000;
  localparam STATE_11  = 3'b111;
  localparam STATE_01  = 3'b101;
  localparam STATE_10  = 3'b110;
  localparam FE_STALL_11 = 3'b011;
  localparam FE_STALL_01 = 3'b001;

  reg next_f_address_sel;

  always @(*) begin
    case(f_curr_st)
    IDLE : begin
      if(eip_4 && ic_hit) begin
        f_next_st = STATE_10;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b11;
      end
      else if (ic_hit) begin
        f_next_st <= STATE_11;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b11;
      end
      else begin
        f_next_st <= IDLE;
        next_f_address_sel = 1'b0;
        f_ld_buf <= 2'b11;
      end
    end

    STATE_10 : begin
      if(ic_hit) begin
        f_next_st <= STATE_01;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b01;
      end
      else begin
        f_next_st <= STATE_10;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b00;
      end
    end

    STATE_01 : begin
      if(~de_p && ic_hit && r_V_de) begin
        f_next_st <= STATE_11;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b10;
      end
      else if(~de_p && r_V_de) begin
        f_next_st <= FE_STALL_01;
        next_f_address_sel = 1'b0;
        f_ld_buf <= 2'b00;
      end
      else begin
        f_next_st <= STATE_01;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b00;
      end
    end

    STATE_11 : begin
      if(de_p && ic_hit & r_V_de) begin
        f_next_st <= STATE_01;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b01;
      end
      else if(de_p && r_V_de) begin
        f_next_st <= FE_STALL_11;
        next_f_address_sel = 1'b0;
        f_ld_buf <= 2'b00;
      end
      else begin
        f_next_st <= STATE_11;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b00;
      end
    end

    FE_STALL_11 : begin
      if(ic_hit) begin
        f_next_st <= STATE_01;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b01;
      end
      else begin
        f_next_st <= FE_STALL_11;
        next_f_address_sel = 1'b0;
        f_ld_buf <= 2'b00;
      end
    end

    FE_STALL_01 : begin
      if(ic_hit) begin
        f_next_st <= STATE_11;
        next_f_address_sel = 1'b1;
        f_ld_buf <= 2'b10;
      end
      else begin
        f_next_st <= FE_STALL_01;
        next_f_address_sel = 1'b0;
        f_ld_buf <= 2'b00;
      end
    end
  
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      f_curr_st <= IDLE;
      f_address_sel <= 1'b0;
    end
    else begin
      f_curr_st <= f_next_st;
      f_address_sel <= next_f_address_sel;
    end
  end
  
endmodule
