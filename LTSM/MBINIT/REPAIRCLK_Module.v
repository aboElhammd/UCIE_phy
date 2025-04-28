////////////////////////////////////////////////////////////////////////////////
// REPAIRCLK_Module
// Author: Ayman Sayed
// Date: 18/2/2025
// Version: 1.0
//
// This module implements a state machine for a clock repair process in a digital
// system. The module interfaces with sideband messages to coordinate the 
// clock repair process and signals when the process is complete.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_MBINIT_CAL_end: Signal indicating the end of the MBINIT calibration
// - i_CLK_Track_done: Signal indicating the clock tracking is done
// - i_Rx_SbMessage: 4-bit input sideband message
// - i_Busy_SideBand: Signal indicating if the sideband is busy
// - i_train_error_req: Signal indicating a training error request
// - i_Clock_track_result_logged: 3-bit input indicating the clock track result
//
// Outputs:
// - o_train_error_req: Signal indicating a training error request
// - o_MBINIT_REPAIRCLK_Pattern_En: Signal enabling the clock repair pattern
// - o_MBINIT_REPAIRCLK_Module_end: Signal indicating the end of the clock repair process
// - o_TX_SbMessage: 4-bit output sideband message
// - o_ValidOutDatat_Module: Signal indicating if the module is valid
//
// The state machine has several states:
// - IDLE: Initial state, waiting for the MBINIT calibration end signal
// - REPAIRCLK_INIT_REQ: State indicating a clock repair initialization request
// - CLKPATTERN: State indicating the clock pattern generation
// - REPAIRCLK_RESULT_REQ: State indicating a clock repair result request
// - REPAIRCLK_CHECK_RESULT: State checking the clock repair result
// - REPAIRCLK_DONE_REQ: State indicating a clock repair done request
// - REPAIRCLK_DONE: State indicating the clock repair process is complete
//
// The state transitions are based on the input signals and the current state.
// The output signals are driven based on the current state.
////////////////////////////////////////////////////////////////////////////////
module REPAIRCLK_Module (
    input               CLK,
    input               rst_n,
    input               i_MBINIT_CAL_end,
    input               i_CLK_Track_done,
    input [3:0]         i_Rx_SbMessage,
    input               i_Busy_SideBand,
    input               i_msg_valid,
    input               i_falling_edge_busy, 
    input [2:0]         i_Clock_track_result_logged, //from rx_sb when it responed with resp on result on i_Rx_SbMessage

    output reg          o_train_error_req,
    output reg          o_MBINIT_REPAIRCLK_Pattern_En,
    output reg          o_MBINIT_REPAIRCLK_Module_end,
    output reg [3:0]    o_TX_SbMessage,
    output reg          o_ValidOutDatat_Module
);

// reg  go_to_result_req;
// reg  go_to_done_req;
reg [3:0] CS, NS;   // CS current state, NS next state

////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////

localparam MBINI_REPAIRCLK_init_req     = 4'b0001;
localparam MBINIT_REPAIRCLK_init_resp   = 4'b0010;
localparam MBINIT_REPAIRCLK_result_req  = 4'b0011;
localparam MBINIT_REPAIRCLK_result_resp = 4'b0100;
localparam MBINIT_REPAIRCLK_done_req    = 4'b0101;
localparam MBINIT_REPAIRCLK_done_resp   = 4'b0110;

////////////////////////////////////////////////////////////////////////////////
// State machine states MODULE
////////////////////////////////////////////////////////////////////////////////
localparam IDLE                             = 0;
localparam REPAIRCLK_INIT_REQ               = 1;
localparam CLKPATTERN                       = 2;
localparam REPAIRCLK_RESULT_REQ             = 3;
localparam REPAIRCLK_CHECK_RESULT           = 4;
localparam REPAIRCLK_DONE_REQ               = 5;
localparam REPAIRCLK_DONE                   = 6;
localparam REPAIRCLK_HANDLE_VALID           = 7;
localparam REPAIRCLK_CHECK_BUSY_RESULT      = 8;
localparam REPAIRCLK_CHECK_BUSY_DONE        = 9;

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
            if (i_MBINIT_CAL_end && ~i_Busy_SideBand) NS = REPAIRCLK_INIT_REQ;
        end
        REPAIRCLK_INIT_REQ: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REPAIRCLK_HANDLE_VALID;
        end
        REPAIRCLK_HANDLE_VALID: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
            else if (i_Rx_SbMessage == MBINIT_REPAIRCLK_init_resp && i_msg_valid) NS = CLKPATTERN;
            else if (i_Rx_SbMessage == MBINIT_REPAIRCLK_result_resp && i_msg_valid) NS = REPAIRCLK_CHECK_RESULT;
            else if (i_Rx_SbMessage == MBINIT_REPAIRCLK_done_resp && i_msg_valid)  NS=REPAIRCLK_DONE;
        end
        CLKPATTERN: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
            else if (i_CLK_Track_done) NS = REPAIRCLK_CHECK_BUSY_RESULT;
        end
        REPAIRCLK_CHECK_BUSY_RESULT: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRCLK_RESULT_REQ;
        end
        REPAIRCLK_RESULT_REQ: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
            else if (i_falling_edge_busy && ~i_Busy_SideBand) NS = REPAIRCLK_HANDLE_VALID;
        end
        REPAIRCLK_CHECK_RESULT: begin
            if (~i_MBINIT_CAL_end || i_Clock_track_result_logged != 3'b111) 
            NS = IDLE;
            else 
            NS = REPAIRCLK_CHECK_BUSY_DONE;
        end
        REPAIRCLK_CHECK_BUSY_DONE: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRCLK_DONE_REQ;
        end
        REPAIRCLK_DONE_REQ: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
            else if (i_falling_edge_busy && ~i_Busy_SideBand) NS = REPAIRCLK_HANDLE_VALID;
        end
        REPAIRCLK_DONE: begin
            if (~i_MBINIT_CAL_end) NS = IDLE;
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
        o_MBINIT_REPAIRCLK_Pattern_En   <= 0;
        o_MBINIT_REPAIRCLK_Module_end   <= 0;
        o_TX_SbMessage                  <= 4'b0000;
        o_ValidOutDatat_Module          <= 0;
    end else begin
        // Default values
        o_train_error_req               <= 0;
        o_MBINIT_REPAIRCLK_Pattern_En   <= 0;
        o_MBINIT_REPAIRCLK_Module_end   <= 0;
        o_TX_SbMessage                  <= 4'b0000;
        o_ValidOutDatat_Module          <= 0;

        case (NS)
            REPAIRCLK_INIT_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINI_REPAIRCLK_init_req;
            end
            CLKPATTERN: begin
                o_MBINIT_REPAIRCLK_Pattern_En <= 1;
            end
            REPAIRCLK_RESULT_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRCLK_result_req;
            end
            REPAIRCLK_CHECK_RESULT: begin
                if (i_Clock_track_result_logged != 3'b111 ) o_train_error_req <= 1;
            end
            REPAIRCLK_DONE_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRCLK_done_req;
            end
            REPAIRCLK_DONE: begin
                o_MBINIT_REPAIRCLK_Module_end <= 1;
            end
            default: begin
                o_train_error_req               <= 0;
                o_MBINIT_REPAIRCLK_Pattern_En   <= 0;
                o_MBINIT_REPAIRCLK_Module_end   <= 0;
                o_TX_SbMessage                  <= 4'b0000;
                o_ValidOutDatat_Module          <= 0;      
            end
        endcase
    end
end



// ////////////////////////////////////////////////////////////////////////////////
// // Combinational output logic for the REPAIR_Module
// ////////////////////////////////////////////////////////////////////////////////
// always @(*) begin
//     // Default values
//     o_train_error_req               = 0;
//     o_MBINIT_REPAIRCLK_Pattern_En   = 0;
//     o_MBINIT_REPAIRCLK_Module_end   = 0;
//     o_TX_SbMessage                  = 4'b0000;
//     o_ValidOutDatat_Module          = 0;

//     case (NS)
//         REPAIRCLK_INIT_REQ: begin
//             o_ValidOutDatat_Module = 1'b1;
//             o_TX_SbMessage = MBINI_REPAIRCLK_init_req;
//         end
//         CLKPATTERN: begin
//             o_MBINIT_REPAIRCLK_Pattern_En = 1;
//         end
//         REPAIRCLK_RESULT_REQ: begin
//             o_ValidOutDatat_Module = 1'b1;
//             o_TX_SbMessage = MBINIT_REPAIRCLK_result_req;
//         end
//         REPAIRCLK_CHECK_RESULT: begin
//             if (i_Clock_track_result_logged != 3'b111 ) o_train_error_req=1;
//         end
//         REPAIRCLK_DONE_REQ: begin
//             o_ValidOutDatat_Module = 1'b1;
//             o_TX_SbMessage = MBINIT_REPAIRCLK_done_req;
//         end
//         REPAIRCLK_DONE: begin
//             o_MBINIT_REPAIRCLK_Module_end = 1;
//         end
//         default: begin
//             o_train_error_req               = 0;
//             o_MBINIT_REPAIRCLK_Pattern_En   = 0;
//             o_MBINIT_REPAIRCLK_Module_end   = 0;
//             o_TX_SbMessage                  = 4'b0000;
//             o_ValidOutDatat_Module          = 0;      
//         end
//     endcase
// end
endmodule


