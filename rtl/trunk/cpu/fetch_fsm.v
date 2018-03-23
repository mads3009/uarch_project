module fetch_fsm(
    input       clk,
    input       rst_n,
    input       second,
    input       de_p,
    input       eip_4,
    output reg [1:0] ld_buf,
    output reg [1:0] curr_st
    );

    localparam IDLE        = 2'b00;
    localparam STATE_11    = 2'b11;
    localparam STATE_01    = 2'b01;

    always @(posedge clk or negedge rst_n) begin

        if(~rst_n) begin
            curr_st <= IDLE;
            ld_buf <= 2'b00;
        end

        else begin
        case(curr_st)

        IDLE : begin
            if(~second & eip_4) begin
                curr_st <= STATE_01;
                ld_buf <= 2'b01;
            end
            else begin
                curr_st <= IDLE;
                ld_buf <= 2'b11;
            end
        end

        STATE_01 : begin
            if(de_p) begin
                curr_st <= STATE_01;
                ld_buf <= 2'b00;
            end
            else begin
                curr_st <= STATE_11;
                ld_buf <= 2'b10;
            end
        end

        STATE_11 : begin
            if(~de_p) begin
                curr_st <= STATE_11;
                ld_buf <= 2'b00;
            end
            else begin
                curr_st <= STATE_01;
                ld_buf <= 2'b01;
            end
        end
    
        endcase
        end
    end
    
endmodule
