////////////////////////////////////////////////////////////////////////////////
// PARAM_Wrapper
// Author: Ayman Sayed
// Date: 18/2/2025
// Version: 1.0
//
// This module serves as a wrapper for the PARAM_Module and PARAM_ModulePartner.
// It coordinates the parameter initialization process in a digital system by
// interfacing with sideband messages and managing the state of the process.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_MBINIT_Start_en: Signal indicating the start of the MBINIT process
// - i_RX_SbMessage: 4-bit input sideband message
// - i_Busy_SideBand: Signal indicating if the sideband is busy
// - i_falling_edge_busy: Signal indicating a falling edge on the busy signal
// - i_MaxDataRate: 4-bit input indicating the maximum data rate
// - i_RX_ClockMode: Input indicating the RX clock mode
// - i_RX_PhaseClock: Input indicating the RX phase clock
//
// Outputs:
// - o_TX_VoltageSwing: 5-bit output indicating the TX voltage swing
// - o_MaxDataRate: 4-bit output indicating the maximum data rate
// - o_TX_ClockMode: Output indicating the TX clock mode
// - o_TX_PhaseClock: Output indicating the TX phase clock
// - o_MBINIT_PARAM_end: Signal indicating the end of the PARAM process
// - o_ValidOutDatat_Module: Signal indicating valid output data from the module
// - o_ValidDataFieldParameters: Signal indicating valid data field parameters
// - o_train_error_req: Signal indicating a training error request
// - o_TX_SbMessage: 4-bit output sideband message
////////////////////////////////////////////////////////////////////////////////

module PARAM_Wrapper (
    input wire          CLK,
    input wire          rst_n,
    input wire          i_MBINIT_Start_en,
    input wire [3:0]    i_RX_SbMessage,
    // input wire          i_Busy_SideBand,
    input wire          i_falling_edge_busy,
    input               i_msg_valid,              

    input [4:0] 		i_TX_VoltageSwing,

    input wire [2:0]    i_MaxDataRate,
    input wire          i_RX_ClockMode,
    input wire          i_RX_PhaseClock,

    output reg [4:0]    o_TX_VoltageSwing,
    output reg [2:0]    o_MaxDataRate,
    output reg          o_TX_ClockMode,
    output reg          o_TX_PhaseClock,
    output reg          o_MBINIT_PARAM_end,
    output reg          o_ValidOutDatat_Module,
    output reg          o_ValidDataFieldParameters,
    output reg          o_train_error_req,
    output reg [3:0]    o_TX_SbMessage,
    output  [2:0]       o_Final_MaxDataRate
);

// Internal signals
wire [4:0]    TX_VoltageSwing_Module;
wire [2:0]    MaxDataRate_Module;
wire          TX_ClockMode_Module;
wire          TX_PhaseClock_Module;
wire          MBINIT_PARAM_Module_end;
wire          ValidOutDatat_Module;
wire          ValidDataFieldParameters;
wire          train_error_req;
wire [3:0]    TX_SbMessage_Module;

wire [2:0]    MaxDataRate_Partner;
wire          TX_ClockMode_Partner;
wire          TX_PhaseClock_Partner;
wire          MBINIT_PARAM_ModulePartner_end;
wire [3:0]    TX_SbMessage_Partner;
wire          ValidOutDatat_ModulePartner;
wire          ValidDataFieldParameters_Partner;

// Instantiate PARAM_Module
PARAM_Module u_PARAM_Module (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_MBINIT_Start_en(i_MBINIT_Start_en),
    .i_RX_SbMessage(i_RX_SbMessage),
    .i_Busy_SideBand(ValidOutDatat_ModulePartner),
    .i_falling_edge_busy(i_falling_edge_busy),
    .i_RX_MaxDataRate(i_MaxDataRate),
    .i_RX_ClockMode(i_RX_ClockMode),
    .i_RX_PhaseClock(i_RX_PhaseClock),
    .i_msg_valid(i_msg_valid),

    .o_TX_VoltageSwing(TX_VoltageSwing_Module),
    .o_MaxDataRate(MaxDataRate_Module),
    .o_TX_ClockMode(TX_ClockMode_Module),
    .o_TX_PhaseClock(TX_PhaseClock_Module),
    .o_MBINIT_PARAM_Module_end(MBINIT_PARAM_Module_end),
    .o_ValidOutDatat_Module(ValidOutDatat_Module),
    .o_ValidDataFieldParameters(ValidDataFieldParameters),
    .o_train_error_req(train_error_req),
    .o_TX_SbMessage(TX_SbMessage_Module),
    .o_Final_MaxDataRate(o_Final_MaxDataRate)
);

// Instantiate PARAM_ModulePartner
PARAM_ModulePartner u_PARAM_ModulePartner (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_MBINIT_Start_en(i_MBINIT_Start_en),
    .i_RX_SbMessage(i_RX_SbMessage),
    .i_falling_edge_busy(i_falling_edge_busy),
    .i_Busy_SideBand(ValidOutDatat_Module),
    .i_RX_VoltageSwing(i_TX_VoltageSwing),
    .i_RX_MaxDataRate(i_MaxDataRate),
    .i_RX_ClockMode(i_RX_ClockMode),
    .i_RX_PhaseClock(i_RX_PhaseClock),
    .i_rx_msg_valid (i_msg_valid),

    
    .o_MaxDataRate(MaxDataRate_Partner),
    .o_TX_ClockMode(TX_ClockMode_Partner),
    .o_TX_PhaseClock(TX_PhaseClock_Partner),
    .o_MBINIT_PARAM_ModulePartner_end(MBINIT_PARAM_ModulePartner_end),
    .o_TX_SbMessage(TX_SbMessage_Partner),
    .o_ValidOutDatat_ModulePartner(ValidOutDatat_ModulePartner),
    .o_ValidDataFieldParameters(ValidDataFieldParameters_Partner)
);



// Combinational output logic
always @(*) begin
    if (ValidDataFieldParameters_Partner && ValidOutDatat_ModulePartner) begin
        o_MaxDataRate = MaxDataRate_Partner;
        o_TX_ClockMode = TX_ClockMode_Partner;
        o_TX_PhaseClock = TX_PhaseClock_Partner;
        o_TX_SbMessage = TX_SbMessage_Partner;
    end else if (ValidOutDatat_Module && ValidDataFieldParameters) begin
        o_MaxDataRate = MaxDataRate_Module;
        o_TX_ClockMode = TX_ClockMode_Module;
        o_TX_PhaseClock = TX_PhaseClock_Module;
        o_TX_SbMessage = TX_SbMessage_Module;
    end else begin
        o_MaxDataRate = 4'b0000;
        o_TX_ClockMode = 1'b0;
        o_TX_PhaseClock = 1'b0;
        o_TX_SbMessage = 4'b0000;
    end
    o_TX_VoltageSwing = TX_VoltageSwing_Module;
    o_MBINIT_PARAM_end = MBINIT_PARAM_Module_end && MBINIT_PARAM_ModulePartner_end;
    o_ValidOutDatat_Module = ValidOutDatat_Module || ValidOutDatat_ModulePartner;
    o_ValidDataFieldParameters = ValidDataFieldParameters || ValidDataFieldParameters_Partner;
    o_train_error_req = train_error_req;
end


// // Combinational output logic
// reg [4:0]    TX_VoltageSwing_comb;
// reg [3:0]    MaxDataRate_comb;
// reg          TX_ClockMode_comb;
// reg          TX_PhaseClock_comb;
// reg          MBINIT_PARAM_Module_end_comb;
// reg          ValidOutDatat_Module_comb;
// reg          ValidDataFieldParameters_comb;
// reg          train_error_req_comb;
// reg [3:0]    TX_SbMessage_comb;

// always @(*) begin
//     if (ValidDataFieldParameters_Partner && ValidOutDatat_ModulePartner) begin
//         MaxDataRate_comb = MaxDataRate_Partner;
//         TX_ClockMode_comb = TX_ClockMode_Partner;
//         TX_PhaseClock_comb = TX_PhaseClock_Partner;
//         TX_SbMessage_comb = TX_SbMessage_Partner;
//     end else if (ValidOutDatat_Module && ValidDataFieldParameters) begin
//         MaxDataRate_comb = MaxDataRate_Module;
//         TX_ClockMode_comb = TX_ClockMode_Module;
//         TX_PhaseClock_comb = TX_PhaseClock_Module;
//         TX_SbMessage_comb = TX_SbMessage_Module;
//     end else begin
//         MaxDataRate_comb = 4'b0000;
//         TX_ClockMode_comb = 1'b0;
//         TX_PhaseClock_comb = 1'b0;
//         TX_SbMessage_comb = 4'b0000;
//     end
//     TX_VoltageSwing_comb = TX_VoltageSwing_Module;
//     MBINIT_PARAM_Module_end_comb = MBINIT_PARAM_Module_end && MBINIT_PARAM_ModulePartner_end;
//     ValidOutDatat_Module_comb = ValidOutDatat_Module || ValidOutDatat_ModulePartner;
//     ValidDataFieldParameters_comb = ValidDataFieldParameters || ValidDataFieldParameters_Partner;
//     train_error_req_comb = train_error_req;
// end

// // Register outputs
// always @(posedge CLK or negedge rst_n) begin
//     if (!rst_n) begin
//         o_TX_VoltageSwing <= 5'b00000;
//         o_MaxDataRate <= 4'b0000;
//         o_TX_ClockMode <= 1'b0;
//         o_TX_PhaseClock <= 1'b0;
//         o_MBINIT_PARAM_end <= 1'b0;
//         o_ValidOutDatat_Module <= 1'b0;
//         o_ValidDataFieldParameters <= 1'b0;
//         o_train_error_req <= 1'b0;
//         o_TX_SbMessage <= 4'b0000;
//     end else begin
//         o_TX_VoltageSwing <= TX_VoltageSwing_comb;
//         o_MaxDataRate <= MaxDataRate_comb;
//         o_TX_ClockMode <= TX_ClockMode_comb;
//         o_TX_PhaseClock <= TX_PhaseClock_comb;
//         o_MBINIT_PARAM_end <= MBINIT_PARAM_Module_end_comb;
//         o_ValidOutDatat_Module <= ValidOutDatat_Module_comb;
//         o_ValidDataFieldParameters <= ValidDataFieldParameters_comb;
//         o_train_error_req <= train_error_req_comb;
//         o_TX_SbMessage <= TX_SbMessage_comb;
//     end
// end

endmodule
