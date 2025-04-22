module REVERSALMB_Wrapper (
    input wire          CLK,
    input wire          rst_n,
    input wire          i_REPAIRVAL_end,
    input wire          i_REVERSAL_done,
    input               i_LaneID_Pattern_done,
    input wire          i_falling_edge_busy,
    input wire [3:0]    i_Rx_SbMessage,
    input               i_msg_valid,
    // input wire          i_Busy_SideBand,
    input wire [15:0]   i_REVERSAL_Result_logged_RXSB,
    input wire [15:0]   i_REVERSAL_Result_logged_COMB,
    // input wire          i_valid_REVERSAL_Pattern_result_logged,

    // output reg          o_MBINIT_REVERSALMB_ValidFraming_En,
    output   [1:0]    o_MBINIT_REVERSALMB_LaneID_Pattern_En,
    output            o_MBINIT_REVERSALMB_ApplyReversal_En,
    output            o_MBINIT_REVERSALMB_end,
    output   [3:0]    o_TX_SbMessage,
    // output            o_MBINIT_REVERSAL_Pattern_Detection_En,
    output   [1:0]    o_Clear_Pattern_Comparator,
    output   [15:0]   o_REVERSAL_Pattern_Result_logged,
    output            o_ValidOutDatatREVERSALMB,
    output            o_ValidDataFieldParameters,
    output            o_train_error_req_reversalmb

);

wire ValidOutDatat_Module;
wire ValidOutDatat_ModulePartner;
wire ValidDataFieldParameters_modulePartner;
wire [3:0] TX_SbMessage_Module;
wire [3:0] TX_SbMessage_ModulePartner;
wire MBINIT_REVERSALMB_Module_end;
wire MBINIT_REVERSALMB_ModulePartner_end;
wire [1:0] MBINIT_REVERSALMB_LaneID_Pattern_En;
// wire MBINIT_REVERSALMB_ValidFraming_En;
wire MBINIT_REVERSALMB_ApplyReversal_En;
wire MBINIT_REVERSAL_Pattern_Detection_En;
wire [15:0] REVERSAL_Pattern_Result_logged;
wire [1:0]  Clear_Pattern_Comparator;
wire train_error_req;

wire [3:0]    o_TX_SbMessage_comb;
wire          o_MBINIT_REVERSALMB_end_comb;
wire          o_valid_REVERSALMB_comb;
wire          o_ValidDataFieldParameters_comb;


// Instantiate REVERSALMB_Module
REVERSALMB_Module u1 (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_REPAIRVAL_end(i_REPAIRVAL_end),
    .i_REVERSAL_done(i_REVERSAL_done),
    .i_Rx_SbMessage(i_Rx_SbMessage),
    .i_Busy_SideBand(ValidOutDatat_ModulePartner),
    .i_LaneID_Pattern_done(i_LaneID_Pattern_done),
    .i_falling_edge_busy(i_falling_edge_busy),
    .i_REVERSAL_Result_logged(i_REVERSAL_Result_logged_RXSB),
    .i_msg_valid(i_msg_valid),

    .o_MBINIT_REVERSALMB_LaneID_Pattern_En(MBINIT_REVERSALMB_LaneID_Pattern_En),
    // .o_MBINIT_REVERSALMB_ValidFraming_En(MBINIT_REVERSALMB_ValidFraming_En),
    .o_MBINIT_REVERSALMB_ApplyReversal_En(MBINIT_REVERSALMB_ApplyReversal_En),
    .o_MBINIT_REVERSALMB_Module_end(MBINIT_REVERSALMB_Module_end),
    .o_TX_SbMessage(TX_SbMessage_Module),
    .o_ValidOutDatat_Module(ValidOutDatat_Module),
    .o_train_error_req_reversalmb(o_train_error_req_reversalmb)
);

// Instantiate REVERSALMB_ModulePartner
REVERSALMB_ModulePartner u2 (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_REPAIRVAL_end(i_REPAIRVAL_end),
    .i_REVERSAL_Pattern_Result_logged(i_REVERSAL_Result_logged_COMB),
    .i_Rx_SbMessage(i_Rx_SbMessage),
    .i_falling_edge_busy(i_falling_edge_busy),
    .i_Busy_SideBand(ValidOutDatat_Module),
    .i_msg_valid(i_msg_valid),

    // .i_valid_REVERSAL_Pattern_result_logged(i_valid_REVERSAL_Pattern_result_logged),
    // .o_MBINIT_REVERSAL_Pattern_Detection_En(MBINIT_REVERSAL_Pattern_Detection_En),
    .o_REVERSAL_Pattern_Result_logged(REVERSAL_Pattern_Result_logged),
    .o_TX_SbMessage(TX_SbMessage_ModulePartner),
    .o_Clear_Pattern_Comparator(Clear_Pattern_Comparator), 
    .o_MBINIT_REVERSALMB_ModulePartner_end(MBINIT_REVERSALMB_ModulePartner_end),
    .o_ValidOutDatat_ModulePartner(ValidOutDatat_ModulePartner),
    .o_ValidDataFieldParameters_modulePartner(ValidDataFieldParameters_modulePartner)
);

// Combinational output logic
assign o_TX_SbMessage                          = ValidOutDatat_ModulePartner ? TX_SbMessage_ModulePartner :
                                                 ValidOutDatat_Module ? TX_SbMessage_Module : 4'b0000;
assign o_MBINIT_REVERSALMB_end                 = MBINIT_REVERSALMB_Module_end && MBINIT_REVERSALMB_ModulePartner_end;
assign o_ValidOutDatatREVERSALMB               = ValidOutDatat_ModulePartner || ValidOutDatat_Module;
assign o_ValidDataFieldParameters              = ValidDataFieldParameters_modulePartner;
assign o_MBINIT_REVERSALMB_LaneID_Pattern_En   = MBINIT_REVERSALMB_LaneID_Pattern_En;
assign o_MBINIT_REVERSALMB_ApplyReversal_En    = MBINIT_REVERSALMB_ApplyReversal_En;
assign o_Clear_Pattern_Comparator              = Clear_Pattern_Comparator | MBINIT_REVERSALMB_LaneID_Pattern_En ;
assign o_REVERSAL_Pattern_Result_logged        = REVERSAL_Pattern_Result_logged;
endmodule