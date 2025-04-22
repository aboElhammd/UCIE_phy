////////////////////////////////////////////////////////////////////////////////
// CAL_ModuleWrapper
// Author: Ayman Sayed
// Date: 17/2/2025
// Version: 1.0
//
// This module wraps the CAL_Module and CAL_ModulePartner modules. It manages
// the busy signal and prioritizes the output from CAL_ModulePartner when both
// modules are active.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_MBINIT_PARAM_end: Enable signal for the calibration process
// - i_train_error_req: Signal indicating a training error request
// - i_RX_SbMessage: 4-bit input sideband message
// - i_Busy_SideBand: Signal indicating if the system is busy
//
// Outputs:
// - o_TX_SbMessage: 4-bit output sideband message
// - o_MBINIT_CAL_Module_end: Signal indicating the end of the calibration process
// - o_MBINIT_CAL_ModulePartner_end: Signal indicating the end of the partner calibration process
// - o_MBINIT_CAL_end: Signal indicating the end of the overall calibration process
////////////////////////////////////////////////////////////////////////////////

module CAL_ModuleWrapper (
    input                   CLK,
    input                   rst_n,
    input                   i_MBINIT_PARAM_end,
    input [3:0]             i_RX_SbMessage,
    // input                   i_Busy_SideBand,
    input                   i_falling_edge_busy,
    input                   i_msg_valid,

    output   [3:0]        o_TX_SbMessage,
    output                o_MBINIT_CAL_end,
    output                o_ValidOutDatatCAL
);

wire [3:0]              TX_SbMessage_Module;
wire [3:0]              TX_SbMessage_ModulePartner;
wire                    MBINIT_CAL_Module_end;
wire                    MBINIT_CAL_ModulePartner_end;
wire                    ValidOutDatat_Module;
wire                    ValidOutDatat_ModulePartner;

wire [3:0] o_TX_SbMessage_comb;
wire       o_MBINIT_CAL_end_comb;
wire       o_valid_cal_comb;



// Instantiate CAL_Module
CAL_Module cal_module_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_MBINIT_PARAM_end(i_MBINIT_PARAM_end),
    .i_RX_SbMessage(i_RX_SbMessage),
    .i_msg_valid(i_msg_valid),
    .i_Busy_SideBand(ValidOutDatat_ModulePartner),
    .i_falling_edge_busy(i_falling_edge_busy),
    .o_TX_SbMessage(TX_SbMessage_Module),
    .o_ValidOutDatat_Module(ValidOutDatat_Module),
    .o_MBINIT_CAL_Module_end(MBINIT_CAL_Module_end)
);

// Instantiate CAL_ModulePartner
CAL_ModulePartner cal_module_partner_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_MBINIT_PARAM_end(i_MBINIT_PARAM_end),
    .i_RX_SbMessage(i_RX_SbMessage),
    .i_Busy_SideBand(o_ValidOutDatatCAL),
    .i_falling_edge_busy(i_falling_edge_busy),
    .o_TX_SbMessage(TX_SbMessage_ModulePartner),
    .o_ValidOutDatat_ModulePartner(ValidOutDatat_ModulePartner),
    .o_MBINIT_CAL_ModulePartner_end(MBINIT_CAL_ModulePartner_end)
);

// Combinational output logic
assign o_TX_SbMessage = ValidOutDatat_ModulePartner ? TX_SbMessage_ModulePartner :
                        ValidOutDatat_Module ? TX_SbMessage_Module : 4'b0000;

assign o_MBINIT_CAL_end = MBINIT_CAL_Module_end && MBINIT_CAL_ModulePartner_end;

assign o_ValidOutDatatCAL = ValidOutDatat_ModulePartner || ValidOutDatat_Module;
endmodule