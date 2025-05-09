module SB_RX_FSM (
    input               i_clk,                      // Clock signal
    input               i_rst_n,                    // Active-low reset signal
    input               i_de_ser_done,              // Signal indicating deserialization is done
    input               i_header_valid,             // Signal indicating header is valid
    input               i_rdi_valid,                // Signal indicating RDI is valid
    input               i_data_valid,               // Signal indicating data is valid
    input       [63:0]  i_deser_data,               // Deserialized data input
    input       [3:0]   i_state,                    // Current state input (used for reset condition)
    output reg          o_rx_sb_start_pattern,      // Output to start pattern detection
    output reg          o_rx_sb_pattern_samp_done,  // Output indicating pattern sampling is done
    //output reg          o_rdi_msg,                // Output indicating RDI message
    output reg          o_msg_valid,                // Output indicating message is valid
    output reg          o_header_enable,            // Output to enable header decoding
    output reg          o_rdi_enable,               // Output to enable RDI decoding
    output reg          o_data_enable,              // Output to enable data decoding
    output reg          o_parity_error,             // indication to LTSM that parity error occur
    output reg          o_rx_rsp_delivered,         // indication that RX recieved response
    output reg          o_adapter_enable,           // indication that this message will be sent to adapter
    output reg          o_de_ser_done_sampled       // Ack for de_ser_done from desrializer
);


/*------------------------------------------------------------------------------
--  LOCAL PARAMETERS
------------------------------------------------------------------------------*/
// FSM states
localparam IDLE            = 0;  
localparam PATTERN_DETECT  = 1;
localparam GENERAL_DECODE  = 2;
localparam RDI_DECODE      = 3;
localparam HEADER_DECODE   = 4;
localparam DATA_DECODE     = 5;
localparam ADAPTER         = 6;

// States parameters
localparam RESET = 0;


/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
reg [2:0] cs, ns;

reg o_rx_sb_start_pattern_reg;
reg o_rx_sb_pattern_samp_done_reg;
reg o_msg_valid_reg;
reg o_header_enable_reg;
reg o_rdi_enable_reg;
reg o_data_enable_reg;
reg o_parity_error_reg;
reg o_rx_rsp_delivered_reg;
reg o_adapter_enable_reg;

wire[3:0] MsgCode;
wire[3:0] MsgCode_part_2;
wire[2:0] dstid;
wire[4:0] opcode;
reg dp;

assign MsgCode = i_deser_data [21:18];
assign dstid = i_deser_data [58:56];
assign opcode = i_deser_data [4:0];
assign MsgCode_part_2 = i_deser_data [17:14];


/*------------------------------------------------------------------------------
-- Block To Ack Receiving De_Ser_Done   
------------------------------------------------------------------------------*/ 
always @(posedge i_clk or negedge i_rst_n) begin 
    if(~i_rst_n) begin
        o_de_ser_done_sampled <= 0;
    end else begin
        o_de_ser_done_sampled <= i_de_ser_done;
    end
end

/*------------------------------------------------------------------------------
-- Regisetering Data Parity Bit   
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin : proc_
    if(~i_rst_n) begin
        dp <= 0;
    end 
    else begin
        if (cs == HEADER_DECODE) begin
            dp = i_deser_data[63];
        end
    end
end

/*------------------------------------------------------------------------------
-- State Transition Logic   
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin 
    if (~i_rst_n) begin
        cs <= IDLE;
    end else begin
        cs <= ns;
    end
end

/*------------------------------------------------------------------------------
-- Next State Logic   
------------------------------------------------------------------------------*/
always @(*) begin 
    case (cs)
        IDLE: begin
            if (i_de_ser_done) begin
                if(correct_pattern(i_deser_data)) begin
                    ns = PATTERN_DETECT;
                end
                else begin
                    ns = IDLE;
                end
            end
            else begin
                ns = IDLE;
            end
        end

        PATTERN_DETECT: begin
            if (i_de_ser_done) begin
                if(correct_pattern(i_deser_data)) begin
                    ns = GENERAL_DECODE;
                end
                else begin
                    ns = PATTERN_DETECT;
                end
            end
            else begin
                ns = PATTERN_DETECT;
            end
        end 

        GENERAL_DECODE: begin
            if (i_state == RESET) begin
                ns = IDLE;
            end
            else begin
                if (i_de_ser_done) begin
                    if(correct_pattern(i_deser_data)) begin
                        ns = GENERAL_DECODE;
                    end
                    else begin
                        // Bypass to adapter
                        if (dstid[0]) begin
                            ns = ADAPTER;
                        end
                        else begin
                            if (^i_deser_data[62:0]) begin
                                ns = GENERAL_DECODE;
                            end
                            else begin
                                // RDI Message
                                if (MsgCode == 0) begin
                                    ns = RDI_DECODE;
                                end
                                else begin
                                    ns = HEADER_DECODE;
                                end
                            end
                        end  
                    end
                end
                else begin
                    ns = GENERAL_DECODE;
                end
            end    
        end 

        RDI_DECODE: begin
            if (i_state == RESET) begin
                ns = IDLE;
            end
            else begin
                if (i_rdi_valid) begin
                    ns = GENERAL_DECODE;
                end
                else begin
                    ns = RDI_DECODE;
                end
            end
        end 

        ADAPTER: begin
            ns = GENERAL_DECODE;
        end 

        HEADER_DECODE: begin
            if (i_state == RESET) begin
                ns = IDLE;
            end
            else begin
                if (i_header_valid) begin
                    if (opcode == 5'b11011) begin // Message with data
                        ns = DATA_DECODE;
                    end
                    // if (opcode == 5'b10010)
                    else begin // Message without data
                       ns = GENERAL_DECODE;
                    end

                end
                else begin
                   ns = HEADER_DECODE;
                end
            end   
        end 

        DATA_DECODE: begin 
            if (i_state == RESET) begin
                ns = IDLE;
            end
            else begin
                if (i_data_valid) begin
                    ns = GENERAL_DECODE;
                end
                else begin
                    if (i_de_ser_done) begin
                        if (^{i_deser_data,dp}) begin
                            ns = GENERAL_DECODE;
                        end
                        else begin
                            ns = DATA_DECODE;
                        end
                    end 
                    else begin
                        ns = DATA_DECODE;
                    end
                end    
            end
        end 

        default: ns = IDLE;
    endcase
end

/*------------------------------------------------------------------------------
-- Output logic (combinational)   
------------------------------------------------------------------------------*/
always @(*) begin 
    // Default values
    // o_rx_sb_start_pattern_reg = 0;
    o_rx_sb_pattern_samp_done_reg = 0;
    o_msg_valid_reg = 0;
    o_header_enable_reg = 0;
    o_rdi_enable_reg = 0;
    o_data_enable_reg = 0;
    o_parity_error_reg = 0;
    o_rx_rsp_delivered_reg = 0;
    o_adapter_enable_reg = 0;

    case (cs)
        // IDLE: begin
        //     if (ns == PATTERN_DETECT && i_state == RESET) begin
        //         o_rx_sb_start_pattern_reg = 1;
        //     end
        //     else begin
        //         o_rx_sb_start_pattern_reg = 0;
        //     end
        // end 

        PATTERN_DETECT: begin
            if (ns == GENERAL_DECODE) begin
                o_rx_sb_pattern_samp_done_reg = 1;
            end
        end  

        GENERAL_DECODE: begin
            if (^i_deser_data[62:0] && !correct_pattern(i_deser_data)) begin
                o_parity_error_reg = 1;
            end
            else begin
                if (ns == RDI_DECODE) begin
                    o_rdi_enable_reg = 1;
                end
                else if (ns == HEADER_DECODE) begin
                    // o_rx_sb_start_pattern_reg = 0;
                    o_header_enable_reg = 1;
                    if (MsgCode_part_2 == 10) begin
                        o_rx_rsp_delivered_reg = 1;
                    end
                end
            end
        end 

        RDI_DECODE: begin
            if (ns == GENERAL_DECODE) begin
                o_msg_valid_reg = 1;
            end
        end 

        ADAPTER: begin
            o_adapter_enable_reg = 1;
        end 

        HEADER_DECODE: begin
            if (ns == GENERAL_DECODE) begin
                o_msg_valid_reg = 1;
            end
        end 

        DATA_DECODE: begin
            if (ns == GENERAL_DECODE && i_data_valid) begin
                o_msg_valid_reg = 1;
            end
            else if (i_de_ser_done) begin
                if (^{i_deser_data,dp}) begin
                    o_parity_error_reg = 1;
                end
                else begin
                    o_data_enable_reg = 1;
                end
            end
        end  
 
    endcase
end


/*------------------------------------------------------------------------------
-- Register outputs   
------------------------------------------------------------------------------*/ 
always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        // o_rx_sb_start_pattern <= 0;
        o_rx_sb_pattern_samp_done <= 0; 
        o_msg_valid <= 0;                
        o_header_enable <= 0;            
        o_rdi_enable <= 0;               
        o_data_enable <= 0; 
        o_parity_error <= 0;
        o_rx_rsp_delivered <= 0;
        o_adapter_enable <= 0;
    end 
    else begin
        // o_rx_sb_start_pattern <= o_rx_sb_start_pattern_reg;
        o_rx_sb_pattern_samp_done <= o_rx_sb_pattern_samp_done_reg; 
        o_msg_valid <= o_msg_valid_reg;                
        o_header_enable <= o_header_enable_reg;            
        o_rdi_enable <= o_rdi_enable_reg;               
        o_data_enable <= o_data_enable_reg; 
        o_parity_error <= o_parity_error_reg;
        o_rx_rsp_delivered <= o_rx_rsp_delivered_reg;
        o_adapter_enable <= o_adapter_enable_reg;
    end
end


always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        o_rx_sb_start_pattern       <= 0;
    end 
    else if (ns == PATTERN_DETECT && i_state == RESET) begin
        o_rx_sb_start_pattern      <= 1;
    end
    else if (cs == GENERAL_DECODE && ns == HEADER_DECODE) begin
        o_rx_sb_start_pattern       <= 0;
    end
end


/*------------------------------------------------------------------------------
-- Function to detect pattern
------------------------------------------------------------------------------*/ 
function correct_pattern (input [63:0] data);
    integer i;
    correct_pattern = 0; 
    if (data[63] != 1) begin
        correct_pattern = 0;
    end 
    else begin
        for (i = 0; i < 62; i = i + 1) begin
            if (data[i] == data[i+2]) begin
                correct_pattern = 1; 
            end
            else begin
                correct_pattern = 0;
            end
        end
    end   
endfunction

endmodule 