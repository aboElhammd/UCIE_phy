module SB_FSM (
    input       i_clk,    
    input       i_rst_n, 
    input       i_start_pattern_req,
    input       i_msg_valid,
    input       i_data_valid,
    input       i_d_valid,
    input       i_header_valid,
    input       i_packet_valid,
    input       i_rx_sb_rsp_delivered,
    input       i_start_pattern_done,    // sent from pattern generator as indication for pattern done
    output reg  o_header_encoder_enable, // enable for header encoder
    output reg  o_data_encoder_enable,   // enable for data encoder
    output reg  o_header_frame_enable,   // enable for header frame
    output reg  o_data_frame_enable,     // enable for data frame
    output reg  o_busy
);

/*------------------------------------------------------------------------------
--  LOCAL PARAMETERS
------------------------------------------------------------------------------*/
localparam IDLE          = 0;
localparam PATTERN_GEN   = 1;
localparam LTSM_ENCODE   = 2;
localparam DATA_FRAME    = 3;
localparam HEADER_FRAME  = 4;
localparam END_MESSAGE   = 5;


/*------------------------------------------------------------------------------
-- INTERNAL REGS   
------------------------------------------------------------------------------*/
reg [2:0] cs, ns;

// Internal signals for outputs
reg o_pattern_enable_next;
reg o_header_encoder_enable_next;
reg o_data_encoder_enable_next;
reg o_header_frame_enable_next;
reg o_data_frame_enable_next;
reg o_start_pattern_done_next;


/*------------------------------------------------------------------------------
-- State transition logic   
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin 
    if (~i_rst_n) begin
        cs <= IDLE;
    end else begin
        cs <= ns;
    end
end


/*------------------------------------------------------------------------------
-- Next state logic   
------------------------------------------------------------------------------*/
always @(*) begin 
    case (cs)
        IDLE: begin
            if (i_start_pattern_req) begin
                ns = PATTERN_GEN;
            end
            else if (i_msg_valid) begin
                ns = LTSM_ENCODE;
            end
            else begin
                ns = IDLE;
            end
        end

        PATTERN_GEN: begin
            if (i_start_pattern_done) begin
                ns = IDLE;
            end
            else begin
                ns = PATTERN_GEN;
            end
        end 

        LTSM_ENCODE: begin
            if (i_d_valid) begin
                ns = DATA_FRAME;
            end
            else if (i_header_valid) begin
                ns = HEADER_FRAME;
            end
            else begin
                ns = LTSM_ENCODE;
            end
        end 

        DATA_FRAME: begin
            if (i_header_valid) begin
                ns = HEADER_FRAME;
            end
            else begin
                ns = DATA_FRAME;
            end
        end 

        HEADER_FRAME: begin
            if (i_packet_valid) begin
                ns = END_MESSAGE;
            end
            else begin
                ns = HEADER_FRAME;
            end
        end 

        END_MESSAGE: begin
            ns = IDLE;
        end 

        default: ns = IDLE;
    endcase
end


/*------------------------------------------------------------------------------
-- Output logic (combinational)   
------------------------------------------------------------------------------*/
always @(*) begin 
    // Default values
    o_pattern_enable_next           = 0;
    o_header_encoder_enable_next    = 0;
    o_data_encoder_enable_next      = 0;
    o_header_frame_enable_next      = 0;
    o_data_frame_enable_next        = 0;
    o_start_pattern_done_next       = 0;
    o_busy                          = 0;

    case (cs)
        IDLE: begin
            if (ns == PATTERN_GEN) begin
                o_pattern_enable_next = 1;
            end
            else if (ns == LTSM_ENCODE) begin
                o_header_encoder_enable_next = 1;
                if (i_data_valid) begin
                	o_data_encoder_enable_next = 1;
                end
            end
        end 

        PATTERN_GEN: begin
            if (ns == IDLE) begin
                o_start_pattern_done_next = 1;
                o_busy = 0;
            end
        end  

        LTSM_ENCODE: begin
            o_busy = 1;
            if (ns == DATA_FRAME) begin
                o_data_frame_enable_next = 1;
            end
            else if (ns == HEADER_FRAME) begin
                o_header_frame_enable_next = 1;
            end
        end 

        DATA_FRAME: begin
            o_busy = 1;
            if (ns == HEADER_FRAME) begin
                o_header_frame_enable_next = 1;
            end
        end 

        HEADER_FRAME: begin
            o_busy = 1;
        end  

        END_MESSAGE: begin
            if (ns == IDLE) begin
                o_busy = 0;
            end
        end

        default: o_busy = 0;
    endcase
end


/*------------------------------------------------------------------------------
-- Register outputs  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        o_header_encoder_enable <= 0;
        o_data_encoder_enable   <= 0;
        o_header_frame_enable   <= 0;
        o_data_frame_enable     <= 0;
    end 
    else begin
        o_header_encoder_enable <= o_header_encoder_enable_next;
        o_data_encoder_enable   <= o_data_encoder_enable_next;
        o_header_frame_enable   <= o_header_frame_enable_next;
        o_data_frame_enable     <= o_data_frame_enable_next;
    end
end


endmodule : SB_FSM