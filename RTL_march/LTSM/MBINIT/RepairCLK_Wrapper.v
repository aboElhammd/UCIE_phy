////////////////////////////////////////////////////////////////////////////////
// RepairCLK_Wrapper
// Author: Ayman Sayed
// Date: 18/2/2025
// Version: 1.0
//
// This module serves as a wrapper for the REPAIRCLK_Module and RepairCLK_ModulePartner.
// It coordinates the clock repair process in a digital system by interfacing with
// sideband messages and managing the state of the repair process.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_MBINIT_CAL_end: Signal indicating the end of the MBINIT calibration
// - i_CLK_Track_done: Signal indicating the completion of clock tracking
// - i_Rx_SbMessage: 4-bit input sideband message
// - i_Busy_SideBand: Signal indicating if the sideband is busy
// - i_train_error_req: Signal indicating a training error request
// - i_Clock_track_result_logged: 3-bit input indicating the clock track result
//
// Outputs:
// - o_train_error_req: Signal indicating a training error request
// - o_MBINIT_REPAIRCLK_Pattern_En: Signal enabling the clock repair pattern
// - o_MBINIT_REPAIRCLK_end: Signal indicating the end of the clock repair process
// - o_TX_SbMessage: 4-bit output sideband message
// - o_MBINIT_RepairCLK_Detection_GetResult: Signal enabling the clock repair detection
// - o_Clock_track_result_logged: 3-bit output indicating the logged clock track result
//
// The module instantiates two sub-modules:
// - REPAIRCLK_Module: Handles the main clock repair logic
// - RepairCLK_ModulePartner: Handles the partner clock repair logic
//
// The output signals are driven based on the internal signals from the sub-modules
// and the current state of the repair process.
////////////////////////////////////////////////////////////////////////////////

module RepairCLK_Wrapper (
    input wire          CLK,
    input wire          rst_n,
    input wire          i_MBINIT_CAL_end,
    input wire          i_CLK_Track_done,
    input wire [3:0]    i_Rx_SbMessage,
    // input wire          i_Busy_SideBand,
    input wire          i_falling_edge_busy,
    input               i_msg_valid,   
    input wire [2:0]    i_Clock_track_result_logged_RXSB, // from sideband
    input wire [2:0]    i_Clock_track_result_logged_COMB, // from comparator
    // input wire          i_Valid_Clock_track_result_logged, //from comparator when valid result is available (sending _the_result)
    output           o_train_error_req,
    output           o_MBINIT_REPAIRCLK_Pattern_En,
    output           o_MBINIT_REPAIRCLK_end,
    output  [3:0]    o_TX_SbMessage,
    // output reg          o_MBINIT_RepairCLK_Detection_GetResult,
    output  [2:0]    o_Clock_track_result_logged,
    output           o_ValidOutDatatREPAIRCLK
    // output reg          o_ValidMsgInfoREPAIRCLK

);
// Internal signals
wire          train_error_req;
wire          MBINIT_REPAIRCLK_Pattern_En;
wire          MBINIT_REPAIRCLK_Module_end;
wire          MBINIT_REPAIRCLK_ModulePartner_end;
// wire          Valid_Clock_track_result_logged;

wire [3:0]    TX_SbMessage_ModulePartner;
wire [3:0]    TX_SbMessage_Module;
wire          ValidOutDatat_Module;
// wire          MBINIT_RepairCLK_Detection_GetResult;
wire [2:0]    Clock_track_result_logged;
wire          ValidOutDatat_ModulePartner;
wire          ValidMsgInfoREPAIRCLK_modulePartner;

wire [3:0]    o_TX_SbMessage_comb;
wire          o_MBINIT_CAL_end_comb;
wire          o_valid_REPAIRCLK_comb;
// wire          o_ValidMsgInfoREPAIRCLK_comb;


    // Instantiate REPAIRVAL_Module
    REPAIRCLK_Module u1 (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_MBINIT_CAL_end(i_MBINIT_CAL_end),
        .i_CLK_Track_done(i_CLK_Track_done),
        .i_Rx_SbMessage(i_Rx_SbMessage),
        .i_Busy_SideBand(ValidOutDatat_ModulePartner),
        .i_msg_valid(i_msg_valid),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_Clock_track_result_logged(i_Clock_track_result_logged_RXSB),
        .o_train_error_req(train_error_req),
        .o_MBINIT_REPAIRCLK_Pattern_En(MBINIT_REPAIRCLK_Pattern_En),
        .o_MBINIT_REPAIRCLK_Module_end(MBINIT_REPAIRCLK_Module_end),
        .o_TX_SbMessage(TX_SbMessage_Module),
        .o_ValidOutDatat_Module(ValidOutDatat_Module)
    );
    // Instantiate RepairCLK_ModulePartner
    RepairCLK_ModulePartner u2 (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_MBINIT_CAL_end(i_MBINIT_CAL_end),
        .i_Clock_track_result_logged(i_Clock_track_result_logged_COMB),
        .i_msg_valid(i_msg_valid),     
        .i_RX_SbMessage(i_Rx_SbMessage),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_Busy_SideBand(ValidOutDatat_Module),
        // .i_Valid_Clock_track_result_logged(i_Valid_Clock_track_result_logged),
        // .o_MBINIT_RepairCLK_Detection_GetResult(MBINIT_RepairCLK_Detection_GetResult),
        .o_Clock_track_result_logged(Clock_track_result_logged),
        .o_TX_SbMessage(TX_SbMessage_ModulePartner),
        .o_MBINIT_REPAIRCLK_ModulePartner_end(MBINIT_REPAIRCLK_ModulePartner_end),
        .o_ValidOutDatat_ModulePartner(ValidOutDatat_ModulePartner)
        // .o_ValidMsgInfoREPAIRCLK_modulePartner(ValidMsgInfoREPAIRCLK_modulePartner)
    );

    // Combinational output logic
    assign o_TX_SbMessage                  = ValidOutDatat_ModulePartner ? TX_SbMessage_ModulePartner :
                                             ValidOutDatat_Module ? TX_SbMessage_Module : 4'b0000;
    assign o_MBINIT_REPAIRCLK_end          = MBINIT_REPAIRCLK_Module_end && MBINIT_REPAIRCLK_ModulePartner_end;
    assign o_train_error_req               = train_error_req;
    assign o_MBINIT_REPAIRCLK_Pattern_En   = MBINIT_REPAIRCLK_Pattern_En;
    assign o_Clock_track_result_logged     = Clock_track_result_logged;
    assign o_ValidOutDatatREPAIRCLK        = ValidOutDatat_ModulePartner || ValidOutDatat_Module;



// // Combinational output logic
//     assign o_TX_SbMessage_comb           = ValidOutDatat_ModulePartner ? TX_SbMessage_ModulePartner :
//                                         ValidOutDatat_Module ? TX_SbMessage_Module : 4'b0000;
//     assign o_MBINIT_REPAIRCLK_end_comb   = MBINIT_REPAIRCLK_Module_end && MBINIT_REPAIRCLK_ModulePartner_end;
//     assign o_valid_REPAIRCLK_comb        = ValidOutDatat_ModulePartner || ValidOutDatat_Module;
//     // assign o_ValidMsgInfoREPAIRCLK_comb  = ValidMsgInfoREPAIRCLK_modulePartner ;
//     always @(posedge CLK or negedge rst_n) begin
//         if (!rst_n) begin
//             o_TX_SbMessage                  <= 4'b0000;
//             o_MBINIT_REPAIRCLK_end          <= 0;
//             o_train_error_req               <= 0;
//             o_MBINIT_REPAIRCLK_Pattern_En   <= 0;
//             // o_MBINIT_RepairCLK_Detection_GetResult <= 0;
//             o_Clock_track_result_logged     <= 3'b000;
//             o_ValidOutDatatREPAIRCLK        <= 0;
//             // o_ValidMsgInfoREPAIRCLK         <= 0;
//         end else begin
//             // Set o_MBINIT_CAL_end when both end signals are 1
//             o_TX_SbMessage                          <= o_TX_SbMessage_comb;
//             o_MBINIT_REPAIRCLK_end                  <= o_MBINIT_REPAIRCLK_end_comb;
//             o_train_error_req                       <= train_error_req;
//             o_MBINIT_REPAIRCLK_Pattern_En           <= MBINIT_REPAIRCLK_Pattern_En;
//             // o_MBINIT_RepairCLK_Detection_GetResult  <= MBINIT_RepairCLK_Detection_GetResult;
//             o_Clock_track_result_logged             <= Clock_track_result_logged;
//             o_ValidOutDatatREPAIRCLK                <= o_valid_REPAIRCLK_comb;
//             // o_ValidMsgInfoREPAIRCLK                 <= o_ValidMsgInfoREPAIRCLK_comb;
//         end
//     end
endmodule