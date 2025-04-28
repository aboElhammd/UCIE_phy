////////////////////////////////////////////////////////////////////////////////
// REPAIRVAL_Module
// Author: Ayman Sayed
// Date: 19/2/2025
// Version: 1.0
//
// This module implements a state machine for a validation repair process in a digital
// system. The module interfaces with sideband messages to coordinate the 
// validation repair process and signals when the process is complete.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_REPAIRVAL_end: Signal indicating the end of the REPAIRVAL process
// - i_VAL_Pattern_done: Signal indicating the validation pattern is done
// - i_Rx_SbMessage: 4-bit input sideband message
// - i_Busy_SideBand: Signal indicating if the sideband is busy
// - i_train_error_req: Signal indicating a training error request
// - i_VAL_Result_logged: Signal indicating the validation result is logged
//
// Outputs:
// - o_train_error_req: Signal indicating a training error request
// - o_MBINIT_REPAIRVAL_Pattern_En: Signal enabling the validation repair pattern
// - o_MBINIT_REPAIRVAL_Module_end: Signal indicating the end of the validation repair process
// - o_TX_SbMessage: 4-bit output sideband message
// - o_ValidOutDatat_Module: Signal indicating if the module is valid
//
// The state machine has several states:
// - IDLE: Initial state, waiting for the REPAIRVAL end signal
// - REPAIRVAL_INIT_REQ: State indicating a validation repair initialization request
// - VAL_PATTERN: State indicating the clock pattern generation
// - REPAIRVAL_RESULT_REQ: State indicating a validation repair result request
// - REPAIRVAL_CHECK_RESULT: State checking the validation repair result
// - REPAIRVAL_DONE_REQ: State indicating a validation repair done request
// - REPAIRVAL_DONE: State indicating the validation repair process is complete
//
// The state transitions are based on the input signals and the current state.
// The output signals are driven based on the current state.
////////////////////////////////////////////////////////////////////////////////
module REPAIRVAL_Module (
    
    input               CLK,
    input               rst_n,
    input               i_REPAIRCLK_end,
    input               i_VAL_Pattern_done,
    input [3:0]         i_Rx_SbMessage,
    input               i_Busy_SideBand,
    input               i_falling_edge_busy,
    input               i_VAL_Result_logged, //from rx_sb when it responed with resp on result on i_Rx_SbMessage
    input               i_msg_valid,
    output reg          o_train_error_req,
    output reg          o_MBINIT_REPAIRVAL_Pattern_En,
    output reg          o_MBINIT_REPAIRVAL_Module_end,
    output reg [3:0]    o_TX_SbMessage,
    output reg          o_ValidOutDatat_Module
);


// reg  go_to_result_req;
// reg  go_to_done_req;
reg [3:0] CS, NS;   // CS current state, NS next state

////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////

localparam MBINI_REPAIRVAL_init_req     = 4'b0001;
localparam MBINIT_REPAIRVAL_init_resp   = 4'b0010;
localparam MBINIT_REPAIRVAL_result_req  = 4'b0011;
localparam MBINIT_REPAIRVAL_result_resp = 4'b0100;
localparam MBINIT_REPAIRVAL_done_req    = 4'b0101;
localparam MBINIT_REPAIRVAL_done_resp   = 4'b0110;


////////////////////////////////////////////////////////////////////////////////
// State machine states MODULE
////////////////////////////////////////////////////////////////////////////////
localparam IDLE                             = 0;
localparam REPAIRVAL_INIT_REQ               = 1;
localparam CLKPATTERN                       = 2;
localparam REPAIRVAL_RESULT_REQ             = 3;
localparam REPAIRVAL_CHECK_RESULT           = 4;
localparam REPAIRVAL_DONE_REQ               = 5;
localparam REPAIRVAL_DONE                   = 6;
localparam REPAIRVAL_HANDLE_VALID           = 7;
localparam REPAIRVAL_CHECK_BUSY_RESULT      = 8;
localparam REPAIRVAL_CHECK_BUSY_DONE        = 9;

////////////////////////////////////////////////////////////////////////////////
// State machine logic for the REPAIR_CLK_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE;
    end else begin
        CS <= NS;
    end
end

////////////////////////////////////////////////////////////////////////////////
// Next state logic for the REPAIR_CLK_Module
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    NS = CS; // Default to hold state
    case (CS)
        IDLE: begin
            if (i_REPAIRCLK_end && ~i_Busy_SideBand) NS = REPAIRVAL_INIT_REQ;
        end
        REPAIRVAL_INIT_REQ: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
            else if (i_falling_edge_busy && ~i_Busy_SideBand) NS = REPAIRVAL_HANDLE_VALID;
        end
        REPAIRVAL_HANDLE_VALID: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
            else if (i_Rx_SbMessage == MBINIT_REPAIRVAL_init_resp && i_msg_valid) NS = CLKPATTERN;
            else if (i_Rx_SbMessage == MBINIT_REPAIRVAL_result_resp && i_msg_valid) NS = REPAIRVAL_CHECK_RESULT;
            else if (i_Rx_SbMessage == MBINIT_REPAIRVAL_done_resp && i_msg_valid)  NS=REPAIRVAL_DONE;
        end
        CLKPATTERN: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
            else if (i_VAL_Pattern_done) NS = REPAIRVAL_CHECK_BUSY_RESULT;
        end
        REPAIRVAL_CHECK_BUSY_RESULT: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRVAL_RESULT_REQ;
        end
        REPAIRVAL_RESULT_REQ: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
            else if (i_falling_edge_busy && ~i_Busy_SideBand) NS = REPAIRVAL_HANDLE_VALID;
        end
        REPAIRVAL_CHECK_RESULT: begin
            if (~i_REPAIRCLK_end || ~i_VAL_Result_logged) 
            NS = IDLE;
            else 
            NS = REPAIRVAL_CHECK_BUSY_DONE;
        end
        REPAIRVAL_CHECK_BUSY_DONE: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRVAL_DONE_REQ;
        end
        REPAIRVAL_DONE_REQ: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
            else if (i_falling_edge_busy && ~i_Busy_SideBand) NS = REPAIRVAL_HANDLE_VALID;
        end
        REPAIRVAL_DONE: begin
            if (~i_REPAIRCLK_end) NS = IDLE;
        end
        default: NS = IDLE;
    endcase
end
////////////////////////////////////////////////////////////////////////////////
// Registered output logic for the REPAIR_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_train_error_req               <= 0;
        o_MBINIT_REPAIRVAL_Pattern_En   <= 0;
        o_MBINIT_REPAIRVAL_Module_end   <= 0;
        o_TX_SbMessage                  <= 4'b0000;
        o_ValidOutDatat_Module          <= 0;
    end else begin
        // Default values
        o_train_error_req               <= 0;
        o_MBINIT_REPAIRVAL_Pattern_En   <= 0;
        o_MBINIT_REPAIRVAL_Module_end   <= 0;
        o_TX_SbMessage                  <= 4'b0000;
        o_ValidOutDatat_Module          <= 0;

        case (NS)
            REPAIRVAL_INIT_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINI_REPAIRVAL_init_req;
            end
            CLKPATTERN: begin
                o_MBINIT_REPAIRVAL_Pattern_En <= 1;
            end
            REPAIRVAL_RESULT_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRVAL_result_req;
            end
            REPAIRVAL_CHECK_RESULT: begin
                if (~i_VAL_Result_logged) o_train_error_req <= 1;
            end
            REPAIRVAL_DONE_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRVAL_done_req;
            end
            REPAIRVAL_DONE: begin
                o_MBINIT_REPAIRVAL_Module_end <= 1;
            end
            default: begin
                o_train_error_req               <= 0;
                o_MBINIT_REPAIRVAL_Pattern_En   <= 0;
                o_MBINIT_REPAIRVAL_Module_end   <= 0;
                o_TX_SbMessage                  <= 4'b0000;
                o_ValidOutDatat_Module          <= 0;      
            end
        endcase
    end
end
endmodule


