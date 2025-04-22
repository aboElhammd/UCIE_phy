module REPAIRVAL_Wrapper (
    input wire          CLK,
    input wire          rst_n,
    input wire          i_REPAIRCLK_end,
    input wire          i_VAL_Pattern_done,
    input wire [3:0]    i_Rx_SbMessage,
    input wire          i_msg_valid,
    // input wire          i_Busy_SideBand,
    input wire          i_falling_edge_busy,
    input wire          i_VAL_Result_logged_RXSB,
    input wire          i_VAL_Result_logged_COMB,
    // input reg           i_valid_val_result_logged,
    output              o_train_error_req,
    output              o_MBINIT_REPAIRVAL_Pattern_En,
    output              o_MBINIT_REPAIRVAL_end,
    output  [3:0]       o_TX_SbMessage,
    // output reg          o_MBINIT_REPAIRVAL_Detection_GetResult,
    output              o_VAL_Result_logged,
    output              o_enable_cons,
    output              o_ValidOutDatatREPAIRVAL
    // output reg          o_ValidMsgInfoREPAIRVAL

);
// Internal signals
wire          train_error_req;
wire          MBINIT_REPAIRVAL_Pattern_En;
wire          MBINIT_REPAIRVAL_Module_end;
wire          MBINIT_REPAIRVAL_ModulePartner_end;
wire          valid_val_result_logged;

wire [3:0]    TX_SbMessage_ModulePartner;
wire [3:0]    TX_SbMessage_Module;
wire          ValidOutDatat_Module;
wire          MBINIT_REPAIRVAL_Detection_GetResult;
wire          VAL_Result_logged;
wire          ValidOutDatat_ModulePartner;
// wire          ValidMsgInfoREPAIRVAL_ModulePartner;

wire [3:0]    o_TX_SbMessage_comb;
wire          o_MBINIT_REPAIRVAL_end_comb;
wire          o_valid_REPAIRVAL_comb;
// wire          o_ValidMsgInfoREPAIRVAL_comb;


    // Instantiate REPAIRVAL_Module
    REPAIRVAL_Module u1 (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_REPAIRCLK_end(i_REPAIRCLK_end),
        .i_VAL_Pattern_done(i_VAL_Pattern_done),
        .i_Rx_SbMessage(i_Rx_SbMessage),
        .i_Busy_SideBand(ValidOutDatat_ModulePartner),
        .i_msg_valid(i_msg_valid),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_VAL_Result_logged(i_VAL_Result_logged_RXSB),
        .o_train_error_req(train_error_req),
        .o_MBINIT_REPAIRVAL_Pattern_En(MBINIT_REPAIRVAL_Pattern_En),
        .o_MBINIT_REPAIRVAL_Module_end(MBINIT_REPAIRVAL_Module_end),
        .o_TX_SbMessage(TX_SbMessage_Module),
        .o_ValidOutDatat_Module(ValidOutDatat_Module)
    );
    // Instantiate REPAIRVAL_ModulePartner
    REPAIRVAL_ModulePartner u2 (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_REPAIRCLK_end(i_REPAIRCLK_end),
        .i_VAL_Result_logged(i_VAL_Result_logged_COMB),
        .i_Rx_SbMessage(i_Rx_SbMessage),
        .i_msg_valid(i_msg_valid),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_Busy_SideBand(ValidOutDatat_Module),
        // .i_valid_val_result_logged(i_valid_val_result_logged),
        // .o_MBINIT_REPAIRVAL_Detection_GetResult(MBINIT_REPAIRVAL_Detection_GetResult),
        .o_VAL_Result_logged(VAL_Result_logged),
        .o_TX_SbMessage(TX_SbMessage_ModulePartner),
        .o_MBINIT_REPAIRVAL_ModulePartner_end(MBINIT_REPAIRVAL_ModulePartner_end),
        .o_ValidOutDatat_ModulePartner(ValidOutDatat_ModulePartner),
        .o_enable_cons(o_enable_cons)
        // .o_ValidMsgInfoREPAIRVAL_ModulePartner(ValidMsgInfoREPAIRVAL_ModulePartner)
    );


// Combinational output logic
assign o_TX_SbMessage           = ValidOutDatat_ModulePartner ? TX_SbMessage_ModulePartner :
                                  ValidOutDatat_Module ? TX_SbMessage_Module : 4'b0000;
assign o_MBINIT_REPAIRVAL_end   = MBINIT_REPAIRVAL_Module_end && MBINIT_REPAIRVAL_ModulePartner_end;
assign o_train_error_req        = train_error_req;
assign o_MBINIT_REPAIRVAL_Pattern_En = MBINIT_REPAIRVAL_Pattern_En;
assign o_VAL_Result_logged      = VAL_Result_logged;
assign o_ValidOutDatatREPAIRVAL = ValidOutDatat_ModulePartner || ValidOutDatat_Module;
endmodule
