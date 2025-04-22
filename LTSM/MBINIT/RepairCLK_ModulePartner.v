////////////////////////////////////////////////////////////////////////////////
// REPAIRCLK_ModulePartner
// Author: Ayman Sayed
// Date: 18/2/2025
// Version: 1.0
//
// This module implements a state machine for a clock repair process in a digital
// system. The module interfaces with sideband messages to coordinate the 
// clock repair process and signals when the process is complete.
//
// Inputs:
// - i_CLK: Clock signal
// - i_rst_n: Active low reset signal
// - i_MBINIT_CAL_end: Signal indicating the end of the MBINIT calibration
// - i_Clock_track_result_logged: 3-bit input indicating the clock track result
// - i_RX_SbMessage: 4-bit input sideband message
// - i_Train_error_req: Signal indicating a training error request
// - i_Busy_SideBand: Signal indicating if the sideband is busy
// - i_Valid_Clock_track_result_logged: Signal indicating if the clock track result is valid
//
// Outputs:
// - o_MBINIT_RepairCLK_Detection_En: Signal enabling the clock repair detection
// - o_Clock_track_result_logged: 3-bit output indicating the logged clock track result
// - o_TX_SbMessage: 4-bit output sideband message
// - o_MBINIT_REPAIRCLK_ModulePartner_end: Signal indicating the end of the clock repair process
// - o_ValidOutDatat_ModulePartner: Signal indicating if the module is valid
//
// The state machine has several states:
// - IDLE: Initial state, waiting for the MBINIT calibration end signal
// - REPAIRCLK_CHECK_INIT_REQ: State checking for a clock repair initialization request
// - REPAIRCLK_INIT_RESP: State responding to a clock repair initialization request
// - RAPAIRCLK_GET_COMPARE: State stopping the clock comparison
// - REPAIRCLK_RESULT_RESP: State responding to a clock repair result request
// - REPAIRCLK_DONE_RESP: State responding to a clock repair done request
// - REPAIRCLK_DONE: State indicating the clock repair process is complete
//
// The state transitions are based on the input signals and the current state.
// The output signals are driven based on the current state.
////////////////////////////////////////////////////////////////////////////////
module RepairCLK_ModulePartner (
    input wire              CLK,
    input wire              rst_n,
    input wire              i_MBINIT_CAL_end,
    input wire [2:0]        i_Clock_track_result_logged,
    input wire [3:0]        i_RX_SbMessage,
    input wire              i_falling_edge_busy, 
    input wire              i_Busy_SideBand,
    input                   i_msg_valid,
    // input wire              i_Valid_Clock_track_result_logged,

    // output reg              o_MBINIT_RepairCLK_Detection_GetResult,
    output reg [2:0]        o_Clock_track_result_logged,
    output reg [3:0]        o_TX_SbMessage,
    output reg              o_MBINIT_REPAIRCLK_ModulePartner_end,
    output reg              o_clear_clk_detection,
    output reg              o_ValidOutDatat_ModulePartner
    // output reg              o_ValidMsgInfoREPAIRCLK_modulePartner
);

////////////////////////////////////////////////////////////////////////////////
// State machine states MODULE_PARTNER
////////////////////////////////////////////////////////////////////////////////
    localparam IDLE                          = 0;
    localparam REPAIRCLK_CHECK_INIT_REQ      = 1;
    localparam REPAIRCLK_INIT_RESP           = 2;
    // localparam RAPAIRCLK_GET_COMPARE         = 3;
    localparam REPAIRCLK_RESULT_RESP         = 3;
    localparam REPAIRCLK_DONE_RESP           = 4;
    localparam REPAIRCLK_DONE                = 5;
    localparam REPAIRCLK_HANDLE_VALID        = 6;
    localparam REPAIRCLK_CHECK_BUSY_INIT     = 7;
    localparam REPAIRCLK_CHECK_BUSY_RESULT   = 8;
    localparam REPAIRCLK_CHECK_BUSY_DONE     = 9;

////////////////////////////////////////////////////////////////////////////////
// Sideband messages 
////////////////////////////////////////////////////////////////////////////////
    localparam MBINI_REPAIRCLK_init_req     = 4'b0001;
    localparam MBINIT_REPAIRCLK_init_resp   = 4'b0010;
    localparam MBINIT_REPAIRCLK_result_req  = 4'b0011;
    localparam MBINIT_REPAIRCLK_result_resp = 4'b0100;
    localparam MBINIT_REPAIRCLK_done_req    = 4'b0101;
    localparam MBINIT_REPAIRCLK_done_resp   = 4'b0110;

    reg [3:0] CS, NS;   // CS current state, NS next state
    // wire go_to_done_resp, go_to_result_resp, go_to_init_resp;

    // assign go_to_init_resp   = (CS == REPAIRCLK_CHECK_INIT_REQ && NS == REPAIRCLK_CHECK_BUSY) ? 1 : 0;
    // assign go_to_result_resp = (CS == RAPAIRCLK_GET_COMPARE && NS == REPAIRCLK_CHECK_BUSY) ? 1 : 0;
    // assign go_to_done_resp   = (CS == REPAIRCLK_HANDLE_VALID && NS == REPAIRCLK_CHECK_BUSY) ? 1 : 0;

////////////////////////////////////////////////////////////////////////////////
// State machine Transition for the REPAIR_CLK_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            CS <= IDLE;
        end else begin
            CS <= NS;
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Next state logic for the REPAIR_CLK_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(*) begin
        NS = CS;
        case (CS)
            IDLE: begin
                if (i_MBINIT_CAL_end) NS = REPAIRCLK_CHECK_INIT_REQ;
            end
            REPAIRCLK_CHECK_INIT_REQ: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (i_RX_SbMessage == MBINI_REPAIRCLK_init_req && i_msg_valid) NS = REPAIRCLK_CHECK_BUSY_INIT;
            end
            REPAIRCLK_CHECK_BUSY_INIT: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REPAIRCLK_INIT_RESP;
            end
            REPAIRCLK_INIT_RESP: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REPAIRCLK_HANDLE_VALID;
            end
            REPAIRCLK_HANDLE_VALID: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (i_RX_SbMessage == MBINIT_REPAIRCLK_result_req && i_msg_valid) NS = REPAIRCLK_CHECK_BUSY_RESULT;
                else if (i_RX_SbMessage == MBINIT_REPAIRCLK_done_req && i_msg_valid) NS = REPAIRCLK_CHECK_BUSY_DONE;
            end
            // RAPAIRCLK_GET_COMPARE: begin
            //     if (~i_MBINIT_CAL_end) NS = IDLE;
            //     else if (i_Valid_Clock_track_result_logged) NS = REPAIRCLK_CHECK_BUSY_RESULT;
            // end
            REPAIRCLK_CHECK_BUSY_RESULT: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REPAIRCLK_RESULT_RESP;
            end
            REPAIRCLK_RESULT_RESP: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REPAIRCLK_HANDLE_VALID;
            end
            REPAIRCLK_CHECK_BUSY_DONE: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REPAIRCLK_DONE_RESP;
            end
            REPAIRCLK_DONE_RESP: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REPAIRCLK_DONE;
            end
            REPAIRCLK_DONE: begin
                if (~i_MBINIT_CAL_end) NS = IDLE;
            end
            default: NS = IDLE;
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Registered output logic for the REPAIR_CLK_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            o_ValidOutDatat_ModulePartner <= 0;
            o_Clock_track_result_logged <= 3'b000;
            o_TX_SbMessage <= 4'b0000;
            o_MBINIT_REPAIRCLK_ModulePartner_end <= 0;
            o_clear_clk_detection <=0;
        end else begin
            o_ValidOutDatat_ModulePartner <= 0;
            o_Clock_track_result_logged <= 3'b000;
            o_TX_SbMessage <= 4'b0000;
            o_MBINIT_REPAIRCLK_ModulePartner_end <= 0;
            o_clear_clk_detection<=0;
            case (NS)
                REPAIRCLK_INIT_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REPAIRCLK_init_resp;
                    o_clear_clk_detection<=1;
                end
                REPAIRCLK_RESULT_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REPAIRCLK_result_resp;
                    o_Clock_track_result_logged <= i_Clock_track_result_logged;
                end
                REPAIRCLK_DONE_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REPAIRCLK_done_resp;
                end
                REPAIRCLK_DONE: begin
                    o_MBINIT_REPAIRCLK_ModulePartner_end <= 1;
                end
                default: begin
                    o_ValidOutDatat_ModulePartner <= 0;
                    o_Clock_track_result_logged <= 3'b000;
                    o_TX_SbMessage <= 4'b0000;
                    o_MBINIT_REPAIRCLK_ModulePartner_end <= 0;
                end
            endcase
        end
    end



// ////////////////////////////////////////////////////////////////////////////////
// // Combinational output logic for the REPAIR_CLK_ModulePartner
// ////////////////////////////////////////////////////////////////////////////////
//     always @(*) begin
//         // o_MBINIT_RepairCLK_Detection_GetResult = 0;
//         o_ValidOutDatat_ModulePartner = 0;
//         o_Clock_track_result_logged = 3'b000;
//         o_TX_SbMessage = 4'b0000;
//         o_MBINIT_REPAIRCLK_ModulePartner_end = 0;
//         // o_ValidMsgInfoREPAIRCLK_modulePartner=0;
//         case (CS)
//             REPAIRCLK_INIT_RESP: begin
//                 o_ValidOutDatat_ModulePartner = 1'b1;
//                 o_TX_SbMessage = MBINIT_REPAIRCLK_init_resp;
//             end
//             // RAPAIRCLK_GET_COMPARE: begin
//             //     o_MBINIT_RepairCLK_Detection_GetResult = 1;
//             // end
//             REPAIRCLK_RESULT_RESP: begin
//                 o_ValidOutDatat_ModulePartner = 1'b1;
//                 // o_ValidMsgInfoREPAIRCLK_modulePartner=1'b1;
//                 o_TX_SbMessage = MBINIT_REPAIRCLK_result_resp;
//                 o_Clock_track_result_logged = i_Clock_track_result_logged;
//             end
//             REPAIRCLK_DONE_RESP: begin
//                 o_ValidOutDatat_ModulePartner = 1'b1;
//                 o_TX_SbMessage = MBINIT_REPAIRCLK_done_resp;
//             end
//             REPAIRCLK_DONE: begin
//                 o_MBINIT_REPAIRCLK_ModulePartner_end = 1;
//             end
//             default : begin
//                 o_ValidOutDatat_ModulePartner = 0;
//                 o_Clock_track_result_logged = 3'b000;
//                 o_TX_SbMessage = 4'b0000;
//                 o_MBINIT_REPAIRCLK_ModulePartner_end = 0;
//                 // o_ValidMsgInfoREPAIRCLK_modulePartner=0;
//             end
//         endcase
//     end


endmodule
