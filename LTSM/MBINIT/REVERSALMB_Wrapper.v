module REVERSALMB_Wrapper (
/*************************************************************************
 * INPUTS
*************************************************************************/
// clock and reset
    input               i_clk,
    input               i_rst_n,

// LTSM related signals
    input               i_REVERSAL_EN,
    input               i_LaneID_Pattern_done,
    input               i_falling_edge_busy,
    input               i_ltsm_in_reset,

// sideband related signals
    input               i_msg_valid,
    input  [3:0]        i_Rx_SbMessage,
    input  [15:0]       i_REVERSAL_Result_logged_RXSB, // results for us
    input  [15:0]       i_REVERSAL_Result_logged_COMB, // results to send to partner
    input               i_SB_Busy,

/*************************************************************************
 * OUTPUTS   
*************************************************************************/
// MB generator related signals
    output   [1:0]      o_MBINIT_REVERSALMB_LaneID_Pattern_En,
    output              o_MBINIT_REVERSALMB_ApplyReversal_En,
    output   [1:0]      o_CW_Pattern_Comparator,

// LTSM related signlas
    output              o_REVERSAL_DONE,
    output              o_train_error_req_reversalmb,

// sideband related signals
    output  reg [3:0]   o_TX_SbMessage,
    output      [15:0]  o_REVERSAL_Pattern_Result_logged, // results to send to partner (data bus)
    output              o_tx_msg_valid, 
    output              o_tx_data_valid,
    output              o_reversalmb_stop_timeout_counter

);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////
    wire tx_reversalmb_done;
    wire rx_reversalmb_done;
    wire [3:0] encoded_SB_msg_tx;
    wire [3:0] encoded_SB_msg_rx;
    wire o_valid_tx;
    wire o_valid_rx;
    wire current_die_repeating_reversalmb;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////
    assign o_REVERSAL_DONE    = tx_reversalmb_done & rx_reversalmb_done;
    assign o_tx_msg_valid     =  o_valid_tx | o_valid_rx;

/////////////////////////////////////////
//////////// Instantsiations ////////////
///////////////////////////////////////// 

/************************************************************************************
* TX  
************************************************************************************/
    REVERSALMB_Module REVERSALMB_Module_inst(   
    /* -------------------------------------------------------------------------- */
    /*                               clock and reset                              */
    /* -------------------------------------------------------------------------- */
        .i_clk                              (i_clk),
        .i_rst_n                            (i_rst_n),
    /* -------------------------------------------------------------------------- */
    /*                            LTSM related signals                            */
    /* -------------------------------------------------------------------------- */
        .i_REVERSAL_EN                      (i_REVERSAL_EN), 
        .i_ltsm_in_reset                    (i_ltsm_in_reset),
        .o_tx_reversalmb_done               (tx_reversalmb_done),
        .o_train_error_req_reversalmb       (o_train_error_req_reversalmb),
    /* -------------------------------------------------------------------------- */
    /*                          sideband related signals                          */
    /* -------------------------------------------------------------------------- */
        .i_rx_msg_valid                     (i_msg_valid),
        .i_decoded_SB_msg                   (i_Rx_SbMessage),
        .i_rx_data_bus                      (i_REVERSAL_Result_logged_RXSB), 
        .i_falling_edge_busy                (i_falling_edge_busy), 
        .o_encoded_SB_msg_tx                (encoded_SB_msg_tx),
        .o_valid_tx                         (o_valid_tx),        
        .o_reversalmb_stop_timeout_counter  (o_reversalmb_stop_timeout_counter),
    /* -------------------------------------------------------------------------- */
    /*                               wrapper signals                              */
    /* -------------------------------------------------------------------------- */
        .i_rx_wrapper_valid                 (o_valid_rx),
        .o_current_die_repeating_reversalmb (current_die_repeating_reversalmb),
    /* -------------------------------------------------------------------------- */
    /*                         MB generator related signal                        */
    /* -------------------------------------------------------------------------- */
        .i_pattern_finished                 (i_LaneID_Pattern_done),
        .o_mainband_pattern_generator_cw    (o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .o_ApplyReversal_En                 (o_MBINIT_REVERSALMB_ApplyReversal_En)
    );

/************************************************************************************
* RX  
************************************************************************************/

REVERSALMB_ModulePartner REVERSALMB_ModulePartner_inst(
/* -------------------------------------------------------------------------- */
/*                               clock and reset                              */
/* -------------------------------------------------------------------------- */
    .i_clk                                          (i_clk),
    .i_rst_n                                        (i_rst_n),
/* -------------------------------------------------------------------------- */
/*                            LTSM related signals                            */
/* -------------------------------------------------------------------------- */
    .i_REVERSAL_EN                                  (i_REVERSAL_EN),
    .i_falling_edge_busy                            (i_falling_edge_busy), 
    .o_rx_reversalmb_done                           (rx_reversalmb_done),
/* -------------------------------------------------------------------------- */
/*                          sideband related signals                          */
/* -------------------------------------------------------------------------- */
    .i_rx_msg_valid                                 (i_msg_valid),
    .i_decoded_SB_msg                               (i_Rx_SbMessage),
    .i_SB_Busy                                      (i_SB_Busy), 
    .o_encoded_SB_msg_rx                            (encoded_SB_msg_rx),
    .o_tx_data_bus                                  (o_REVERSAL_Pattern_Result_logged),
    .o_tx_data_valid                                (o_tx_data_valid),
/* -------------------------------------------------------------------------- */
/*                               wrapper signals                              */
/* -------------------------------------------------------------------------- */
    .i_tx_wrapper_valid                             (o_valid_tx), 
    .i_current_die_repeating_reversalmb             (current_die_repeating_reversalmb),
    .o_valid_rx                                     (o_valid_rx),
/* -------------------------------------------------------------------------- */
/*                            MB compartor related                            */
/* -------------------------------------------------------------------------- */
    .i_REVERSAL_Pattern_Result_logged_for_partner   (i_REVERSAL_Result_logged_COMB), 
    .o_mainband_pattern_comparator_cw               (o_CW_Pattern_Comparator)

);

/////////////////////////////////////////
//// Handling SB encoded priorities /////
///////////////////////////////////////// 

always @ (*) begin
    case ({o_valid_tx, o_valid_rx})
        2'b00: begin
            o_TX_SbMessage = 4'b0000;
        end
        2'b01: begin
            o_TX_SbMessage = encoded_SB_msg_rx;
        end
        2'b10: begin
            o_TX_SbMessage = encoded_SB_msg_tx;
        end
        2'b11: begin
            o_TX_SbMessage = encoded_SB_msg_rx;
        end
        default: begin
            o_TX_SbMessage = 4'b0000;
        end
    endcase
end

endmodule 