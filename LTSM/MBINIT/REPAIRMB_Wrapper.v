module REPAIRMB_Wrapper (
    input                   CLK,
    input                   rst_n,
    input                   MBINIT_REVERSALMB_end,
    input [3:0]             i_RX_SbMessage,
    // input                   i_Busy_SideBand,
    input                   i_falling_edge_busy,
    input                   i_Transmitter_initiated_Data_to_CLK_done,
    input [15:0]            i_Transmitter_initiated_Data_to_CLK_Result,
    input [1:0]             i_Functional_Lanes, 
    input                   i_msg_valid,
    // input                   i_Done_Repeater,
    output   [3:0]          o_TX_SbMessage,
    output                  o_MBINIT_REPAIRMB_end,
    output                  o_ValidOutDatat_REPAIRMB,
    // output                o_Width_Degrade_en,
    output   [1:0]          o_Functional_Lanes_out_tx,
    output   [1:0]          o_Functional_Lanes_out_rx,
    output                  o_Transmitter_initiated_Data_to_CLK_en,
    output                  o_perlane_Transmitter_initiated_Data_to_CLK,
    output                  o_mainband_Transmitter_initiated_Data_to_CLK,
    // output                o_tx_msg_info_valid_repairmb,
    // output                o_Start_Repeater,
    output                  o_train_error,
    output [2:0]            o_msg_info_repairmb 
);

wire [3:0] TX_SbMessage_Module;
wire MBINIT_REPAIRMB_Module_end;
wire ValidOutDatat_Module;
// wire Width_Degrade_en_Module;

wire apply_repeater;
// wire tx_msg_info_valid_repairmb_Module;

wire [3:0] TX_SbMessage_ModulePartner;
wire MBINIT_REPAIRMB_ModulePartner_end;
wire ValidOutDatat_ModulePartner;
// wire Width_Degrade_en_ModulePartner;
// wire Start_Repeater_ModulePartner;
wire train_error_ModulePartner;

wire Start_Repeater; // from rx send to tx
wire Done_Repeater ; //from tx send to tx after finish the repeate

REPAIRMB_Module REPAIRMB_Module_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .MBINIT_REVERSALMB_end(MBINIT_REVERSALMB_end),
    .i_RX_SbMessage(i_RX_SbMessage),
    .i_Busy_SideBand(ValidOutDatat_ModulePartner),
    .i_falling_edge_busy(i_falling_edge_busy),
    .i_msg_valid(i_msg_valid),
    .i_Start_Repeater(Start_Repeater),
    // .i_Functional_Lanes_ModulePrtner(Functional_Lanes_out_rx),
    .i_Transmitter_initiated_Data_to_CLK_done(i_Transmitter_initiated_Data_to_CLK_done),
    .i_Transmitter_initiated_Data_to_CLK_Result(i_Transmitter_initiated_Data_to_CLK_Result),
    .apply_repeater(apply_repeater),
    .o_TX_SbMessage(TX_SbMessage_Module),
    .o_Done_Repeater(Done_Repeater),
    .o_MBINIT_REPAIRMB_Module_end(MBINIT_REPAIRMB_Module_end),
    .o_ValidOutDatat_REPAIRMB_Module(ValidOutDatat_Module),
    // .o_Width_Degrade_en(Width_Degrade_en_Module),
    .o_Functional_Lanes(o_Functional_Lanes_out_tx),
    .o_Transmitter_initiated_Data_to_CLK_en(o_Transmitter_initiated_Data_to_CLK_en),
    .o_perlane_Transmitter_initiated_Data_to_CLK(o_perlane_Transmitter_initiated_Data_to_CLK),
    .o_mainband_Transmitter_initiated_Data_to_CLK(o_mainband_Transmitter_initiated_Data_to_CLK),
    .o_msg_info_repairmb(o_msg_info_repairmb)
    // .o_tx_msg_info_valid_repairmb(tx_msg_info_valid_repairmb_Module)
);

REPAIRMB_Module_Partner REPAIRMB_Module_Partner_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .MBINIT_REVERSALMB_end(MBINIT_REVERSALMB_end),
    .i_Busy_SideBand(ValidOutDatat_Module),
    .i_falling_edge_busy(i_falling_edge_busy),
    .i_RX_SbMessage(i_RX_SbMessage),
    .i_msg_valid(i_msg_valid),
    .i_Functional_Lanes(i_Functional_Lanes),
    .i_Done_Repeater(Done_Repeater),
    .o_Start_Repeater(Start_Repeater),
    .o_train_error(o_train_error),
    .o_MBINIT_REPAIRMB_Module_Partner_end(MBINIT_REPAIRMB_ModulePartner_end),
    .o_ValidOutDatat_REPAIRMB_Module_Partner(ValidOutDatat_ModulePartner),
    .o_TX_SbMessage(TX_SbMessage_ModulePartner),
    // .o_Width_Degrade_en(Width_Degrade_en_ModulePartner),
    .o_Functional_Lanes(o_Functional_Lanes_out_rx),
    .apply_repeater(apply_repeater)
);

// Combinational output logic
assign o_TX_SbMessage = ValidOutDatat_ModulePartner ? TX_SbMessage_ModulePartner : 
                        ValidOutDatat_Module ? TX_SbMessage_Module : 4'b0000;
assign o_MBINIT_REPAIRMB_end = MBINIT_REPAIRMB_Module_end && MBINIT_REPAIRMB_ModulePartner_end;
assign o_ValidOutDatat_REPAIRMB = ValidOutDatat_ModulePartner || ValidOutDatat_Module;
// assign o_Width_Degrade_en = Width_Degrade_en_Module || Width_Degrade_en_ModulePartner;
// assign o_Start_Repeater = Start_Repeater_ModulePartner;
// assign o_train_error = train_error_ModulePartner;

// assign o_Functional_Lanes_out_tx = Functional_Lanes_out_tx;
// assign o_Functional_Lanes_out_rx = Functional_Lanes_out_rx;
// assign o_Transmitter_initiated_Data_to_CLK_en = Transmitter_initiated_Data_to_CLK_en_Module;
// assign o_perlane_Transmitter_initiated_Data_to_CLK = perlane_Transmitter_initiated_Data_to_CLK_Module;
// assign o_mainband_Transmitter_initiated_Data_to_CLK = mainband_Transmitter_initiated_Data_to_CLK_Module;
// assign o_tx_msg_info_valid_repairmb = tx_msg_info_valid_repairmb_Module;

endmodule // REPAIRMB_Wrapper
