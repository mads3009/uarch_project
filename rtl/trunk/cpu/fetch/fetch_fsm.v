module fetch_fsm(
    input       clk,
    input       rst_n,
    input       de_p,
    input       eip_4,
    input       ic_hit,
    output reg [1:0] f_ld_buf,
    output reg [1:0] f_curr_st,
    output     [1:0] f_next_st,
    output      f_address_sel
    );

    localparam IDLE        = 2'b00;
    localparam STATE_11    = 2'b11;
    localparam STATE_01    = 2'b01;
    wire second;
assign second = 0;
    always @(posedge clk or negedge rst_n) begin

        if(~rst_n) begin
            f_curr_st <= IDLE;
            f_ld_buf <= 2'b00;
        end

        else begin
        case(f_curr_st)

        IDLE : begin
            if(~second & eip_4) begin
                f_curr_st <= STATE_01;
                f_ld_buf <= 2'b01;
            end
            else begin
                f_curr_st <= IDLE;
                f_ld_buf <= 2'b11;
            end
        end

        STATE_01 : begin
            if(de_p) begin
                f_curr_st <= STATE_01;
                f_ld_buf <= 2'b00;
            end
            else begin
                f_curr_st <= STATE_11;
                f_ld_buf <= 2'b10;
            end
        end

        STATE_11 : begin
            if(~de_p) begin
                f_curr_st <= STATE_11;
                f_ld_buf <= 2'b00;
            end
            else begin
                f_curr_st <= STATE_01;
                f_ld_buf <= 2'b01;
            end
        end
    
        endcase
        end
    end
    
endmodule
