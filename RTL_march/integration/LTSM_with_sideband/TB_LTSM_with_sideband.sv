module TB_LTSM_with_sideband;

/**************************************************************************************************************************************************
*************************************************************** LTSM RELATED **********************************************************************
**************************************************************************************************************************************************/

///////////////////////////////////
//////////// PARAMETERS ///////////
///////////////////////////////////

localparam REVERSAL_TO_TRAINERROR  = 0; // set to 1 if you want to test the scenario where the reversalmb state should go trainerror state
localparam REPAIRCLK_TO_TRAINERROR = 0; // set to 1 if you want to test the scenario where the repairclk  state should go trainerror state
localparam REPAIRMB_TO_TRAINERROR  = 0; // set to 1 if you want to test the scenario where the repairmb   state should go trainerror state

///////////////////////////////////
//////////// SIGNALS //////////////
///////////////////////////////////
/*--------------------------------
    * Module
--------------------------------*/
// Inputs
logic i_clk;
logic i_rst_n;
logic i_start_training_RDI_1;
logic i_go_to_phyretrain_ACTIVE_1;
logic i_lp_linkerror_1;
logic i_LINKINIT_DONE_1;
logic i_ACTIVE_DONE_1;
logic i_SB_fifo_empty_1;
//logic i_start_pattern_done_1;
//logic i_start_training_SB_1;
//logic i_time_out_1;
//logic i_busy_1;
//logic [3:0] i_decoded_SB_msg_1;
//logic [2:0] i_rx_msg_info_1;
//logic [15:0] i_rx_data_bus_1;
//logic i_rx_msg_valid_1;
logic i_Transmitter_initiated_Data_to_CLK_done_1;
logic [15:0] i_Transmitter_initiated_Data_to_CLK_Result_1;
logic i_Receiver_initiated_Data_to_CLK_done_1;
logic [15:0] i_Receiver_initiated_Data_to_CLK_Result_1;
logic i_CLK_Track_done_1;
logic [2:0] i_logged_clk_result_1;
logic i_VAL_Pattern_done_1;
logic i_logged_val_result_1;
logic i_pattern_generation_done_1;
logic [15:0] i_comparsion_results_1;
logic [15:0] i_aggregate_counter_1;
logic i_aggregate_error_found_1;
logic i_start_training_DVSEC_1;
logic i_valid_framing_error_1;
logic i_REVERSAL_done_1;


// Outputs
logic [3:0] o_reciever_ref_volatge_1;
logic [1:0] o_functional_tx_lanes_1;
logic [1:0] o_functional_rx_lanes_1;
logic o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK_1;
logic o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK_1;
logic o_Transmitter_initiated_Data_to_CLK_en_1;
logic o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK_1;
logic o_MBTRAIN_Receiver_initiated_Data_to_CLK_en_1;
logic o_MBTRAIN_tx_eye_width_sweep_en_1;
logic o_MBTRAIN_rx_eye_width_sweep_en_1;
logic o_MBINIT_REPAIRCLK_Pattern_En_1;
logic o_MBINIT_REPAIRVAL_Pattern_En_1;
logic [1:0] o_MBINIT_mainband_pattern_generator_cw_1;
logic [1:0] o_MBINIT_mainband_pattern_comparator_cw_1;
logic o_MBINIT_REVERSALMB_ApplyReversal_En_1;
logic o_start_pattern_req_1;
//logic [3:0] o_tx_state_1;
//logic [3:0] o_tx_sub_state_1;
//logic [3:0] o_encoded_SB_msg_1;
//bit [2:0] o_tx_msg_info_1;
//bit [15:0] o_tx_data_bus_1;
//logic o_tx_msg_valid_1;
//logic o_tx_data_valid_1;
logic o_tx_rdi_msg_en_1;
//logic o_MBTRAIN_timeout_disable_1;
logic [2:0] o_curret_operating_speed_1;

/*--------------------------------
    * Module Partner
--------------------------------*/
// Inputs
logic i_start_training_RDI_2;
logic i_go_to_phyretrain_ACTIVE_2;
logic i_lp_linkerror_2;
logic i_LINKINIT_DONE_2;
logic i_ACTIVE_DONE_2;
logic i_SB_fifo_empty_2;
//logic i_start_pattern_done_2;
//logic i_start_training_SB_2;
//logic i_time_out_2;
//logic i_busy_2;
//logic [3:0] i_decoded_SB_msg_2;
//logic [2:0] i_rx_msg_info_2;
//logic [15:0] i_rx_data_bus_2;
logic i_Transmitter_initiated_Data_to_CLK_done_2;
logic [15:0] i_Transmitter_initiated_Data_to_CLK_Result_2;
logic i_Receiver_initiated_Data_to_CLK_done_2;
logic [15:0] i_Receiver_initiated_Data_to_CLK_Result_2;
logic i_CLK_Track_done_2;
logic [2:0] i_logged_clk_result_2;
logic i_rx_msg_valid_2;
logic i_VAL_Pattern_done_2;
logic i_logged_val_result_2;
logic i_pattern_generation_done_2;
logic [15:0] i_comparsion_results_2;
logic [15:0] i_aggregate_counter_2;
logic i_aggregate_error_found_2;
logic i_start_training_DVSEC_2;
logic i_valid_framing_error_2;
logic i_REVERSAL_done_2;

// Outputs
logic [3:0] o_reciever_ref_volatge_2;
logic [1:0] o_functional_tx_lanes_2;
logic [1:0] o_functional_rx_lanes_2;
logic o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK_2;
logic o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK_2;
logic o_Transmitter_initiated_Data_to_CLK_en_2;
logic o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK_2;
logic o_MBTRAIN_Receiver_initiated_Data_to_CLK_en_2;
logic o_MBTRAIN_tx_eye_width_sweep_en_2;
logic o_MBTRAIN_rx_eye_width_sweep_en_2;
logic o_MBINIT_REPAIRCLK_Pattern_En_2;
logic o_MBINIT_REPAIRVAL_Pattern_En_2;
logic [1:0] o_MBINIT_mainband_pattern_generator_cw_2;
logic [1:0] o_MBINIT_mainband_pattern_comparator_cw_2;
logic o_MBINIT_REVERSALMB_ApplyReversal_En_2;
logic o_start_pattern_req_2;
//logic [3:0] o_tx_state_2;
//logic [3:0] o_tx_sub_state_2;
//logic [3:0] o_encoded_SB_msg_2;
//bit [2:0] o_tx_msg_info_2;
//bit [15:0] o_tx_data_bus_2;
//logic o_tx_msg_valid_2;
//logic o_tx_data_valid_2;
logic o_tx_rdi_msg_en_2;
//logic o_MBTRAIN_timeout_disable_2;
logic [2:0] o_curret_operating_speed_2;

// Internal signals
string i_rx_msg_no_string_1,i_rx_msg_no_string_2;
string o_tx_msg_no_string_1,o_tx_msg_no_string_2;
string sub_state_1, sub_state_2;

bit first_time_entering_reversalmb_1; // 1: TRUE , 0: FALSE
bit first_time_entering_reversalmb_2;
bit first_time_entering_repairmb_1;
bit first_time_entering_repairmb_2;


/**************************************************************************************************************************************************
*************************************************************** SIDEBAND RELATED ******************************************************************
**************************************************************************************************************************************************/
// Signals for Module instance
bit                 clk_sb;
logic               module_start_pattern_req;
logic               module_rdi_msg;
logic               module_data_valid;
logic               module_msg_valid;
logic       [3:0]   module_state;
logic       [3:0]   module_sub_state;
logic       [3:0]   module_msg_no;
logic       [2:0]   module_msg_info;
logic       [15:0]  module_data_bus;
logic               module_ser_done;
logic               module_stop_cnt;
logic               module_tx_point_sweep_test_en;
logic       [1:0]   module_tx_point_sweep_test;
logic       [1:0]   module_rdi_msg_code;
logic       [3:0]   module_rdi_msg_sub_code;
logic       [1:0]   module_rdi_msg_info;
logic               module_de_ser_done;
logic       [63:0]  module_deser_data;

logic              module_start_pattern_done;
logic              module_time_out;
logic      [63:0]  module_tx_data_out;
logic              module_busy;
logic              module_rx_sb_start_pattern;
logic              module_rdi_msg_out;
logic              module_msg_valid_out;
logic              module_parity_error;
logic              module_adapter_enable;
logic      [1:0]   module_tx_point_sweep_test_out;
logic      [3:0]   module_msg_no_out;
logic      [2:0]   module_msg_info_out;
logic      [15:0]  module_data_out;
logic      [1:0]   module_rdi_msg_code_out;
logic      [3:0]   module_rdi_msg_sub_code_out;
logic      [1:0]   module_rdi_msg_info_out;

// Signals for Partner instance
logic               partner_start_pattern_req;
logic               partner_rdi_msg;
logic               partner_data_valid;
logic               partner_msg_valid;
logic       [3:0]   partner_state;
logic       [3:0]   partner_sub_state;
logic       [3:0]   partner_msg_no;
logic       [2:0]   partner_msg_info;
logic       [15:0]  partner_data_bus;
logic               partner_ser_done;
logic               partner_stop_cnt;
logic               partner_tx_point_sweep_test_en;
logic       [1:0]   partner_tx_point_sweep_test;
logic       [1:0]   partner_rdi_msg_code;
logic       [3:0]   partner_rdi_msg_sub_code;
logic       [1:0]   partner_rdi_msg_info;
logic               partner_de_ser_done;
logic       [63:0]  partner_deser_data;

logic              partner_start_pattern_done;
logic              partner_time_out;
logic      [63:0]  partner_tx_data_out;
logic              partner_busy;
logic              partner_rx_sb_start_pattern;
logic              partner_rdi_msg_out;
logic              partner_msg_valid_out;
logic              partner_parity_error;
logic              partner_adapter_enable;
logic      [1:0]   partner_tx_point_sweep_test_out;
logic      [3:0]   partner_msg_no_out;
logic      [2:0]   partner_msg_info_out;
logic      [15:0]  partner_data_out;
logic      [1:0]   partner_rdi_msg_code_out;
logic      [3:0]   partner_rdi_msg_sub_code_out;
logic      [1:0]   partner_rdi_msg_info_out;

logic [63:0] TX_module_data, RX_module_data, TX_partner_data, RX_partner_data;

/*******************************************
* special connection
********************************************/

wire [3:0] o_tx_state_1 = module_state;
wire [3:0] o_tx_sub_state_1 = module_sub_state;
wire [3:0] o_tx_state_2 = partner_state;
wire [3:0] o_tx_sub_state_2 = partner_sub_state;

/********************************************/

int err_cnt = 0;
int crrct_cnt = 0;

logic module_busy_logic, partner_busy_logic;
logic falling_edge_busy_module = (module_busy_logic != Module.o_busy) && !Module.o_busy;
logic falling_edge_busy_partner = (partner_busy_logic != Partner.o_busy) && !Partner.o_busy;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// DUT INSTANTIATION /////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

LTSM_TOP MODULE_inst_1 (
    .i_clk                                                          (i_clk),
    .i_rst_n                                                        (i_rst_n),
    .i_start_training_RDI                                           (i_start_training_RDI_1),
    .i_go_to_phyretrain_ACTIVE                                      (i_go_to_phyretrain_ACTIVE_1),
    .i_lp_linkerror                                                 (i_lp_linkerror_1),
    .i_LINKINIT_DONE                                                (i_LINKINIT_DONE_1),
    .i_ACTIVE_DONE                                                  (i_ACTIVE_DONE_1),
    .i_SB_fifo_empty                                                (i_SB_fifo_empty_1),
    .i_start_pattern_done                                           (module_start_pattern_done),
    .i_start_training_SB                                            (module_rx_sb_start_pattern),
    .i_time_out                                                     (module_time_out),
    .i_busy                                                         (module_busy),
    .i_rx_msg_valid                                                 (module_msg_valid_out),
    .i_decoded_SB_msg                                               (module_msg_no_out),
    .i_rx_msg_info                                                  (module_msg_info_out),
    .i_rx_data_bus                                                  (module_data_out),
    .i_Transmitter_initiated_Data_to_CLK_done                       (i_Transmitter_initiated_Data_to_CLK_done_1),
    .i_Transmitter_initiated_Data_to_CLK_Result                     (i_Transmitter_initiated_Data_to_CLK_Result_1),
    .i_Receiver_initiated_Data_to_CLK_done                          (i_Receiver_initiated_Data_to_CLK_done_1),
    .i_Receiver_initiated_Data_to_CLK_Result                        (i_Receiver_initiated_Data_to_CLK_Result_1),
    .i_CLK_Track_done                                               (i_CLK_Track_done_1),
    .i_logged_clk_result                                            (i_logged_clk_result_1),
    .i_VAL_Pattern_done                                             (i_VAL_Pattern_done_1),
    .i_logged_val_result                                            (i_logged_val_result_1),
    .i_pattern_generation_done                                      (i_pattern_generation_done_1),
    .i_comparsion_results                                           (i_comparsion_results_1),
    .i_aggregate_counter                                            (i_aggregate_counter_1),
    .i_aggregate_error_found                                        (i_aggregate_error_found_1),
    .i_start_training_DVSEC                                         (i_start_training_DVSEC_1),
    .i_REVERSAL_done                                                (i_REVERSAL_done_1),
    .i_valid_framing_error                                          (i_valid_framing_error_1),
    .o_reciever_ref_volatge                                         (o_reciever_ref_volatge_1),
    .o_functional_tx_lanes                                          (o_functional_tx_lanes_1),
    .o_functional_rx_lanes                                          (o_functional_rx_lanes_1),
    .o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK       (o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK_1),
    .o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK            (o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK_1),
    .o_Transmitter_initiated_Data_to_CLK_en                         (o_Transmitter_initiated_Data_to_CLK_en_1),
    .o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK  (o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK_1),
    .o_MBTRAIN_Receiver_initiated_Data_to_CLK_en                    (o_MBTRAIN_Receiver_initiated_Data_to_CLK_en_1),
    .o_MBTRAIN_tx_eye_width_sweep_en                                (o_MBTRAIN_tx_eye_width_sweep_en_1),
    .o_MBTRAIN_rx_eye_width_sweep_en                                (o_MBTRAIN_rx_eye_width_sweep_en_1),
    .o_MBINIT_REPAIRCLK_Pattern_En                                  (o_MBINIT_REPAIRCLK_Pattern_En_1),
    .o_MBINIT_REPAIRVAL_Pattern_En                                  (o_MBINIT_REPAIRVAL_Pattern_En_1),
    .o_MBINIT_mainband_pattern_generator_cw                         (o_MBINIT_mainband_pattern_generator_cw_1),
    .o_MBINIT_mainband_pattern_comparator_cw                        (o_MBINIT_mainband_pattern_comparator_cw_1),
    .o_MBINIT_REVERSALMB_ApplyReversal_En                           (o_MBINIT_REVERSALMB_ApplyReversal_En_1),
    .o_start_pattern_req                                            (module_start_pattern_req),
    .o_tx_state                                                     (module_state),
    .o_tx_sub_state                                                 (module_sub_state),
    .o_encoded_SB_msg                                               (module_msg_no),
    .o_tx_msg_info                                                  (module_msg_info),
    .o_tx_data_bus                                                  (module_data_bus),
    .o_tx_msg_valid                                                 (module_msg_valid),
    .o_tx_data_valid                                                (module_data_valid),
    .o_tx_rdi_msg_en                                                (o_tx_rdi_msg_en_1),
    .o_MBTRAIN_timeout_disable                                      (module_stop_cnt),
    .o_curret_operating_speed                                       (o_curret_operating_speed_1)
);

LTSM_TOP MODULE_inst_2 (
    .i_clk                                                          (i_clk),
    .i_rst_n                                                        (i_rst_n),
    .i_start_training_RDI                                           (i_start_training_RDI_2),
    .i_go_to_phyretrain_ACTIVE                                      (i_go_to_phyretrain_ACTIVE_2),
    .i_lp_linkerror                                                 (i_lp_linkerror_2),
    .i_LINKINIT_DONE                                                (i_LINKINIT_DONE_2),
    .i_ACTIVE_DONE                                                  (i_ACTIVE_DONE_2),
    .i_SB_fifo_empty                                                (i_SB_fifo_empty_2),
    .i_start_pattern_done                                           (partner_start_pattern_done),
    .i_start_training_SB                                            (partner_rx_sb_start_pattern),
    .i_time_out                                                     (partner_time_out),
    .i_busy                                                         (partner_busy),
    .i_rx_msg_valid                                                 (partner_msg_valid_out),
    .i_decoded_SB_msg                                               (partner_msg_no_out),
    .i_rx_msg_info                                                  (partner_msg_info_out),
    .i_rx_data_bus                                                  (partner_data_out),    
    .i_Transmitter_initiated_Data_to_CLK_done                       (i_Transmitter_initiated_Data_to_CLK_done_2),
    .i_Transmitter_initiated_Data_to_CLK_Result                     (i_Transmitter_initiated_Data_to_CLK_Result_2),
    .i_Receiver_initiated_Data_to_CLK_done                          (i_Receiver_initiated_Data_to_CLK_done_2),
    .i_Receiver_initiated_Data_to_CLK_Result                        (i_Receiver_initiated_Data_to_CLK_Result_2),
    .i_CLK_Track_done                                               (i_CLK_Track_done_2),
    .i_logged_clk_result                                            (i_logged_clk_result_2),
    .i_VAL_Pattern_done                                             (i_VAL_Pattern_done_2),
    .i_logged_val_result                                            (i_logged_val_result_2),
    .i_pattern_generation_done                                      (i_pattern_generation_done_2),
    .i_comparsion_results                                           (i_comparsion_results_2),
    .i_aggregate_counter                                            (i_aggregate_counter_2),
    .i_aggregate_error_found                                        (i_aggregate_error_found_2),
    .i_start_training_DVSEC                                         (i_start_training_DVSEC_2),
    .i_REVERSAL_done                                                (i_REVERSAL_done_2),
    .i_valid_framing_error                                          (i_valid_framing_error_2),
    .o_reciever_ref_volatge                                         (o_reciever_ref_volatge_2),
    .o_functional_tx_lanes                                          (o_functional_tx_lanes_2),
    .o_functional_rx_lanes                                          (o_functional_rx_lanes_2),
    .o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK       (o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK_2),
    .o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK            (o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK_2),
    .o_Transmitter_initiated_Data_to_CLK_en                         (o_Transmitter_initiated_Data_to_CLK_en_2),
    .o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK  (o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK_2),
    .o_MBTRAIN_Receiver_initiated_Data_to_CLK_en                    (o_MBTRAIN_Receiver_initiated_Data_to_CLK_en_2),
    .o_MBTRAIN_tx_eye_width_sweep_en                                (o_MBTRAIN_tx_eye_width_sweep_en_2),
    .o_MBTRAIN_rx_eye_width_sweep_en                                (o_MBTRAIN_rx_eye_width_sweep_en_2),
    .o_MBINIT_REPAIRCLK_Pattern_En                                  (o_MBINIT_REPAIRCLK_Pattern_En_2),
    .o_MBINIT_REPAIRVAL_Pattern_En                                  (o_MBINIT_REPAIRVAL_Pattern_En_2),
    .o_MBINIT_mainband_pattern_generator_cw                         (o_MBINIT_mainband_pattern_generator_cw_2),
    .o_MBINIT_mainband_pattern_comparator_cw                        (o_MBINIT_mainband_pattern_comparator_cw_2),
    .o_MBINIT_REVERSALMB_ApplyReversal_En                           (o_MBINIT_REVERSALMB_ApplyReversal_En_2),
    .o_start_pattern_req                                            (partner_start_pattern_req),
    .o_tx_state                                                     (partner_state),
    .o_tx_sub_state                                                 (partner_sub_state),
    .o_encoded_SB_msg                                               (partner_msg_no),
    .o_tx_msg_info                                                  (partner_msg_info),
    .o_tx_data_bus                                                  (partner_data_bus),
    .o_tx_msg_valid                                                 (partner_msg_valid),
    .o_tx_data_valid                                                (partner_data_valid),
    .o_tx_rdi_msg_en                                                (o_tx_rdi_msg_en_2),
    .o_MBTRAIN_timeout_disable                                      (partner_stop_cnt),
    .o_curret_operating_speed                                       (o_curret_operating_speed_2)
);

SB_TOP_WRAPPER Module (
    .i_clk                    (clk_sb),
    .i_rst_n                  (i_rst_n),
    .i_start_pattern_req      (module_start_pattern_req),
    .i_rdi_msg                (module_rdi_msg),
    .i_data_valid             (module_data_valid),
    .i_msg_valid              (module_msg_valid),
    .i_state                  (module_state),
    .i_sub_state              (module_sub_state),
    .i_msg_no                 (module_msg_no),
    .i_msg_info               (module_msg_info),
    .i_data_bus               (module_data_bus),
    .i_ser_done               (module_ser_done),
    .i_stop_cnt               (module_stop_cnt),
    .i_tx_point_sweep_test_en (module_tx_point_sweep_test_en),
    .i_tx_point_sweep_test    (module_tx_point_sweep_test),
    .i_rdi_msg_code           (module_rdi_msg_code),
    .i_rdi_msg_sub_code       (module_rdi_msg_sub_code),
    .i_rdi_msg_info           (module_rdi_msg_info),
    .i_de_ser_done            (module_de_ser_done),
    .i_deser_data             (module_deser_data),
    .RXCKSB                   (partner_txcksb),
    .RXDATASB                 (partner_txdatasb),
    .o_start_pattern_done     (module_start_pattern_done),
    .o_time_out               (module_time_out),
    .o_tx_data_out            (module_tx_data_out),
    .o_busy                   (module_busy),
    .o_rx_sb_start_pattern    (module_rx_sb_start_pattern),
    .o_rdi_msg                (module_rdi_msg_out),
    .o_msg_valid              (module_msg_valid_out),
    .o_parity_error           (module_parity_error),
    .o_adapter_enable         (module_adapter_enable),
    .o_tx_point_sweep_test    (module_tx_point_sweep_test_out),
    .o_msg_no                 (module_msg_no_out),
    .o_msg_info               (module_msg_info_out),
    .o_data                   (module_data_out),
    .o_rdi_msg_code           (module_rdi_msg_code_out),
    .o_rdi_msg_sub_code       (module_rdi_msg_sub_code_out),
    .o_rdi_msg_info           (module_rdi_msg_info_out),
    .TXCKSB                   (module_txcksb),
    .TXDATASB                 (module_txdatasb)
);

// Instantiate the Partner
SB_TOP_WRAPPER Partner (
    .i_clk                    (clk_sb),
    .i_rst_n                  (i_rst_n),
    .i_start_pattern_req      (partner_start_pattern_req),
    .i_rdi_msg                (partner_rdi_msg),
    .i_data_valid             (partner_data_valid),
    .i_msg_valid              (partner_msg_valid),
    .i_state                  (partner_state),
    .i_sub_state              (partner_sub_state),
    .i_msg_no                 (partner_msg_no),
    .i_msg_info               (partner_msg_info),
    .i_data_bus               (partner_data_bus),
    .i_ser_done               (partner_ser_done),
    .i_stop_cnt               (partner_stop_cnt),
    .i_tx_point_sweep_test_en (partner_tx_point_sweep_test_en),
    .i_tx_point_sweep_test    (partner_tx_point_sweep_test),
    .i_rdi_msg_code           (partner_rdi_msg_code),
    .i_rdi_msg_sub_code       (partner_rdi_msg_sub_code),
    .i_rdi_msg_info           (partner_rdi_msg_info),
    .i_de_ser_done            (partner_de_ser_done),
    .i_deser_data             (partner_deser_data),
    .RXCKSB                   (module_txcksb),
    .RXDATASB                 (module_txdatasb),
    .o_start_pattern_done     (partner_start_pattern_done),
    .o_time_out               (partner_time_out),
    .o_tx_data_out            (partner_tx_data_out),
    .o_busy                   (partner_busy),
    .o_rx_sb_start_pattern    (partner_rx_sb_start_pattern),
    .o_rdi_msg                (partner_rdi_msg_out),
    .o_msg_valid              (partner_msg_valid_out),
    .o_parity_error           (partner_parity_error),
    .o_adapter_enable         (partner_adapter_enable),
    .o_tx_point_sweep_test    (partner_tx_point_sweep_test_out),
    .o_msg_no                 (partner_msg_no_out),
    .o_msg_info               (partner_msg_info_out),
    .o_data                   (partner_data_out),
    .o_rdi_msg_code           (partner_rdi_msg_code_out),
    .o_rdi_msg_sub_code       (partner_rdi_msg_sub_code_out),
    .o_rdi_msg_info           (partner_rdi_msg_info_out),
    .TXCKSB                   (partner_txcksb),
    .TXDATASB                 (partner_txdatasb)
);


/**************************************************************************************************************************************************
*************************************************************** STIMILUS GENERATION ***************************************************************
**************************************************************************************************************************************************/
///////////////////////////////////
//////// CLOCK GENERATION /////////
///////////////////////////////////

initial begin
    i_clk = 0;
    forever #8 i_clk = ~i_clk;
end

initial begin
    clk_sb =  0;
    forever #1 clk_sb = ~ clk_sb;
end

///////////////////////////////////
///////// INITIAL BLOCK ///////////
///////////////////////////////////
// Reset generation
initial begin
    i_rst_n = 0;
    #20;
    i_rst_n = 1;
end

// initiliaze sideband
initial begin
    // Initialize all inputs for Module
    module_rdi_msg = 0;
    module_ser_done = 1;
    module_tx_point_sweep_test_en = 0;
    module_tx_point_sweep_test = 0;
    module_rdi_msg_code = 0;
    module_rdi_msg_sub_code = 0;
    module_rdi_msg_info = 0;
    module_de_ser_done = 0;
    module_deser_data = 0;

    // Initialize all inputs for Partner
    partner_rdi_msg = 0;
    partner_ser_done = 1;
    partner_tx_point_sweep_test_en = 0;
    partner_tx_point_sweep_test = 0;
    partner_rdi_msg_code = 0;
    partner_rdi_msg_sub_code = 0;
    partner_rdi_msg_info = 0;
    partner_de_ser_done = 0;
    partner_deser_data = 0;
end

// initiliaze LTSM
initial begin
    first_time_entering_reversalmb_1 = 1;
    first_time_entering_reversalmb_2 = 1;
    first_time_entering_repairmb_1 = 1;
    first_time_entering_repairmb_2 = 1;
    // Initialize all module inputs
    i_start_training_RDI_1 = 0;
    i_start_training_DVSEC_1 = 0;
    i_go_to_phyretrain_ACTIVE_1 = 0;
    i_lp_linkerror_1 = 0;
    i_LINKINIT_DONE_1 = 0;
    i_ACTIVE_DONE_1 = 0;
    i_SB_fifo_empty_1 = 1;
    i_Transmitter_initiated_Data_to_CLK_done_1 = 0;
    i_Transmitter_initiated_Data_to_CLK_Result_1 = 0;
    i_Receiver_initiated_Data_to_CLK_done_1 = 0;
    i_Receiver_initiated_Data_to_CLK_Result_1 = 0;
    i_CLK_Track_done_1 = 0;
    i_logged_clk_result_1 = 0;
    i_VAL_Pattern_done_1 = 0;
    i_logged_val_result_1 = 0;
    i_pattern_generation_done_1 = 0;
    i_comparsion_results_1 = 0;
    i_aggregate_counter_1 = 0;
    i_aggregate_error_found_1 = 0;
    i_valid_framing_error_1 = 0;

    // Initialize all partner inputs
    i_start_training_RDI_2 = 0;
    i_start_training_DVSEC_2 = 0;
    i_go_to_phyretrain_ACTIVE_2 = 0;
    i_lp_linkerror_2 = 0;
    i_LINKINIT_DONE_2 = 0;
    i_ACTIVE_DONE_2 = 0;
    i_SB_fifo_empty_2 = 1;
    i_Transmitter_initiated_Data_to_CLK_done_2 = 0;
    i_Transmitter_initiated_Data_to_CLK_Result_2 = 0;
    i_Receiver_initiated_Data_to_CLK_done_2 = 0;
    i_Receiver_initiated_Data_to_CLK_Result_2 = 0;
    i_CLK_Track_done_2 = 0;
    i_logged_clk_result_2 = 0;
    i_VAL_Pattern_done_2 = 0;
    i_logged_val_result_2 = 0;
    i_pattern_generation_done_2 = 0;
    i_comparsion_results_2 = 0;
    i_aggregate_counter_2 = 0;
    i_aggregate_error_found_2 = 0;
    i_valid_framing_error_2 = 1;
    // Wait for reset to complete
    #30;

    // Apply random stimulus
    repeat (1) begin
        apply_inputs();
        #10;
    end

    // Finish simulation
    $stop;
end

///////////////////////////////////
////////////// TASKS //////////////
///////////////////////////////////  
/**********************************
* delay task 
**********************************/
task DELAY (input integer delay);
    repeat (delay) @(posedge i_clk);
endtask

// Task to apply random inputs
task apply_inputs();
    DELAY (1);
    i_start_training_RDI_1 = 1;
    DELAY (1);
    i_start_training_RDI_1 = 0;
    DELAY (20000);
endtask 

/**********************************
* i_LINKINIT_DONE & i_ACTIVE_DONE
**********************************/
// module
always @ (o_tx_state_1) begin
    if (o_tx_state_1 == 5) begin // LINKINIT
        DELAY (5); // after 5 clock cycles raise the ack
        i_LINKINIT_DONE_1 = 1;
        DELAY (1);
        i_LINKINIT_DONE_1 = 0;
    end else if (o_tx_state_1 == 6) begin // ACTIVE
        DELAY (5); // after 5 clock cycles raise the ack
        i_ACTIVE_DONE_1 = 1;
        DELAY (1);
        i_ACTIVE_DONE_1 = 0;
    end
end

// partner
always @ (o_tx_state_2) begin
    if (o_tx_state_2 == 5) begin // LINKINIT
        DELAY (5); // after 5 clock cycles raise the ack
        i_LINKINIT_DONE_2 = 1;
        DELAY (1);
        i_LINKINIT_DONE_2 = 0;
    end else if (o_tx_state_2 == 6) begin // ACTIVE
        DELAY (5); // after 5 clock cycles raise the ack
        i_ACTIVE_DONE_2 = 1;
        DELAY (1);
        i_ACTIVE_DONE_2 = 0;
    end
end

/*******************************************
* i_Transmitter_initiated_Data_to_CLK_done
*******************************************/
// module 
always @ (posedge o_Transmitter_initiated_Data_to_CLK_en_1) begin
    DELAY (15); // modelling tx iniated point test block processing delay 
    i_Transmitter_initiated_Data_to_CLK_done_1 = 1;
    /*------------------------------------------------
     * testing reversal state to train error state
    ------------------------------------------------*/
    if (REPAIRMB_TO_TRAINERROR) begin
        if (sub_state_1 == "REPAIRMB" && first_time_entering_repairmb_1) begin
            i_Transmitter_initiated_Data_to_CLK_Result_1 = 16'hff10; // < 50%
            first_time_entering_repairmb_1 = 0;
        end else if (sub_state_1 == "REPAIRMB" && !first_time_entering_repairmb_1) begin
            i_Transmitter_initiated_Data_to_CLK_Result_1 = 16'h01ff; // < 50%
            first_time_entering_repairmb_1 = 1;
        end   
    end else begin
        if (MODULE_inst_1.o_tx_state == 4) begin
            i_Transmitter_initiated_Data_to_CLK_Result_1 = 16'h01ff;
        end else begin
            i_Transmitter_initiated_Data_to_CLK_Result_1 = '1;
        end
    end
    DELAY (1);
    i_Transmitter_initiated_Data_to_CLK_done_1 = 0;
end

// partner 
always @ (posedge o_Transmitter_initiated_Data_to_CLK_en_2) begin
    DELAY (15); // modelling tx iniated point test block processing delay 
    i_Transmitter_initiated_Data_to_CLK_done_2 = 1;
    /*------------------------------------------------
     * testing reversal state to train error state
    ------------------------------------------------*/
    if (REPAIRMB_TO_TRAINERROR) begin
        if (sub_state_2 == "REPAIRMB" && first_time_entering_repairmb_2) begin
            i_Transmitter_initiated_Data_to_CLK_Result_2 = 16'h01ff; // < 50%
            first_time_entering_repairmb_2 = 0;
        end else if (sub_state_2 == "REPAIRMB" && !first_time_entering_repairmb_2) begin
            i_Transmitter_initiated_Data_to_CLK_Result_2 = 16'h01ff; // < 50%
            first_time_entering_repairmb_2 = 1;
        end   
    end else begin
        i_Transmitter_initiated_Data_to_CLK_Result_2 = '1;
    end
    DELAY (1);
    i_Transmitter_initiated_Data_to_CLK_done_2 = 0;
end

/*******************************************
* i_Receiver_initiated_Data_to_CLK_done
*******************************************/
// module 
always @ (posedge o_MBTRAIN_Receiver_initiated_Data_to_CLK_en_1) begin
    DELAY (15); // modelling rx iniated point test block processing delay 
    i_Receiver_initiated_Data_to_CLK_done_1 = 1;
    i_Receiver_initiated_Data_to_CLK_Result_1 = $random;
    DELAY (1);
    i_Receiver_initiated_Data_to_CLK_done_1 = 0;
end

// partner 
always @ (posedge o_MBTRAIN_Receiver_initiated_Data_to_CLK_en_2) begin
    DELAY (15); // modelling rx iniated point test block processing delay 
    i_Receiver_initiated_Data_to_CLK_done_2 = 1;
    i_Receiver_initiated_Data_to_CLK_Result_2 = $random;
    DELAY (1);
    i_Receiver_initiated_Data_to_CLK_done_2 = 0;
end

/*******************************************
* i_CLK_Track_done_2
*******************************************/
// module 
always @ (posedge o_MBINIT_REPAIRCLK_Pattern_En_1) begin
    DELAY (15);
    i_CLK_Track_done_1 = 1;
    /*------------------------------------------------
     * testing repairclk state to train error state
    ------------------------------------------------*/
    if (REPAIRCLK_TO_TRAINERROR) begin
        if (sub_state_1 == "REPAIRCLK") begin
            i_logged_clk_result_1 = 3'b011; 
        end 
    end else begin
        //i_logged_clk_result_1 = '1;
    end
    DELAY (1);
    i_CLK_Track_done_1 = 0;
end

// partner 
always @ (posedge o_MBINIT_REPAIRCLK_Pattern_En_2) begin
    DELAY (15);
    i_CLK_Track_done_2 = 1;
    i_logged_clk_result_2 = 3'b111;
    DELAY (1);
    i_CLK_Track_done_2 = 0;
end

/*******************************************
* i_VAL_Pattern_done
*******************************************/
// module 
always @ (posedge o_MBINIT_REPAIRVAL_Pattern_En_1) begin
    DELAY (15);
    i_VAL_Pattern_done_1 = 1;
    i_logged_val_result_1 = 1;
    DELAY (1);
    i_VAL_Pattern_done_1 = 0;
end

// partner
always @ (posedge o_MBINIT_REPAIRVAL_Pattern_En_2) begin
    DELAY (15);
    i_VAL_Pattern_done_2 = 1;
    i_logged_val_result_2 = 1;
    DELAY (1);
    i_VAL_Pattern_done_2 = 0;
end

/*******************************************
* i_pattern_generation_donern_done
*******************************************/
// module 
always @ (o_MBINIT_mainband_pattern_generator_cw_1) begin
    if (o_MBINIT_mainband_pattern_generator_cw_1 == 2'b10 || o_MBINIT_mainband_pattern_generator_cw_1 == 2'b11) begin
        DELAY (15);
        i_pattern_generation_done_1 = 1;
        DELAY (1);
        i_pattern_generation_done_1 = 0;
    end
end

// partner
always @ (o_MBINIT_mainband_pattern_generator_cw_2) begin
    if (o_MBINIT_mainband_pattern_generator_cw_2 == 2'b10 || o_MBINIT_mainband_pattern_generator_cw_2 == 2'b11) begin
        DELAY (15);
        i_pattern_generation_done_2 = 1;
        DELAY (1);
        i_pattern_generation_done_2 = 0;
    end
end

/*******************************************
* i_comparsion_results
*******************************************/
// module 
always @ (o_MBINIT_mainband_pattern_comparator_cw_1) begin
    if (o_MBINIT_mainband_pattern_comparator_cw_1 == 2'b10 || o_MBINIT_mainband_pattern_comparator_cw_1 == 2'b11 || o_MBINIT_mainband_pattern_comparator_cw_1 == 2'b01) begin
        DELAY (15);
    /*------------------------------------------------
     * testing reversal state to train error state
    ------------------------------------------------*/
    if (REVERSAL_TO_TRAINERROR) begin
        if (sub_state_1 == "REVERSALMB" && first_time_entering_reversalmb_1) begin
            i_comparsion_results_1 = 16'b0000000001111111; // < 50%
            first_time_entering_reversalmb_1 = 0;
        end else if (sub_state_1 == "REVERSALMB" && !first_time_entering_reversalmb_1) begin
            i_comparsion_results_1 = 16'b0000000001111111; // < 50%
            first_time_entering_reversalmb_1 = 1;
        end   
    end else begin
        i_comparsion_results_1 = '1;
    end
        i_aggregate_counter_1 = $random;
        i_aggregate_error_found_1 = $random;
    end
end

// partner 
always @ (o_MBINIT_mainband_pattern_comparator_cw_2) begin
    if (o_MBINIT_mainband_pattern_comparator_cw_2 == 2'b10 || o_MBINIT_mainband_pattern_comparator_cw_2 == 2'b11 || o_MBINIT_mainband_pattern_comparator_cw_2 == 2'b01) begin
        DELAY (15);
    /*------------------------------------------------
     * testing reversal state to train error state
    ------------------------------------------------*/
    if (REVERSAL_TO_TRAINERROR) begin
        if (sub_state_2 == "REVERSALMB" && first_time_entering_reversalmb_2) begin
            i_comparsion_results_2 = 16'b0000000001111111; // < 50%
            first_time_entering_reversalmb_2 = 0;
        end else if (sub_state_2 == "REVERSALMB" && !first_time_entering_reversalmb_2) begin
            i_comparsion_results_2 = 16'b0000011111111111; // < 50%
            first_time_entering_reversalmb_2 = 1;
        end   
    end else begin
        i_comparsion_results_2 = '1;
    end
        i_aggregate_counter_2 = $random;
        i_aggregate_error_found_2 = $random;
    end
end


/*******************************************
* i_REVERSAL_done
*******************************************/    
// module 
always @ (posedge o_MBINIT_REVERSALMB_ApplyReversal_En_1) begin
    DELAY (1);
    i_REVERSAL_done_1 = 1;
    DELAY (1);
    i_REVERSAL_done_1 = 0;
end

// partner
always @ (posedge o_MBINIT_REVERSALMB_ApplyReversal_En_2) begin
    DELAY (1);
    i_REVERSAL_done_2 = 1;
    DELAY (1);
    i_REVERSAL_done_2 = 0;
end

/**************************************
 * modelling channel transfer delay
**************************************/
// // Module
// logic [63:0] mod_tx_data_logic1;
// logic [63:0] mod_tx_data_logic2;
// logic [63:0] mod_tx_data_logic3;

// always @ (posedge i_clk or negedge i_rst_n) begin
//     if (!i_rst_n) begin
//         mod_tx_data_logic1 <= 0;
//         mod_tx_data_logic2 <= 0;
//         mod_tx_data_logic3 <= 0;
//     end else begin
//         if (TX_module_data != 0) begin
//             mod_tx_data_logic1 <= TX_module_data;
//         end
//             mod_tx_data_logic2 <= mod_tx_data_logic1;
//             mod_tx_data_logic3 <= mod_tx_data_logic2;
//     end
// end

// assign RX_module_data =  mod_tx_data_logic3; // output from module , input to partner after 3 clk cycles

// // partner
// logic [63:0] partner_tx_data_logic1;
// logic [63:0] partner_tx_data_logic2;
// logic [63:0] partner_tx_data_logic3;

// always @ (posedge i_clk or negedge i_rst_n) begin
//     if (!i_rst_n) begin
//         partner_tx_data_logic1 <= 0;
//         partner_tx_data_logic2 <= 0;
//         partner_tx_data_logic3 <= 0;
//     end else begin
//         if (TX_partner_data != 0) begin
//             partner_tx_data_logic1 <= TX_partner_data;
//         end 
//             partner_tx_data_logic2 <= partner_tx_data_logic1;
//             partner_tx_data_logic3 <= partner_tx_data_logic2;            
//     end
// end

// assign RX_partner_data = partner_tx_data_logic3; // output from partner , input to module after 3 clk cycles

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// FOR DEBUGGING ONLY ////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////
//////////// FSM STATES ///////////
///////////////////////////////////
/*---------------------------------
* FSM main States
---------------------------------*/
typedef enum {  
    RESET                = 0,
    FINISH_RESET         = 1,
    SBINIT               = 2,
    MBINIT               = 3,
    MBTRAIN              = 4,
    LINKINIT             = 5,
    ACTIVE               = 6,
    TRAINERROR_HS        = 7,
    TRAINERROR           = 8,
    LINKMGMT_RETRAIN     = 9,
    PHYRETRAIN           = 10,
    L1_L2                = 11
} states_tx;

/*---------------------------------
* FSM sub States
---------------------------------*/
localparam PARAM                = 0;
localparam CAL                  = 1;
localparam REPAIRCLK            = 2;
localparam REPAIRVAL            = 3;
localparam REVERSALMB           = 4;
localparam REPAIRMB             = 5;

localparam VALVREF              = 0;
localparam DATAVREF             = 1;
localparam SPEEDIDLE            = 2;
localparam TXSELFCAL            = 3;
localparam RXCLKCAL             = 4;
localparam VALTRAINCENTER       = 5;
localparam VALTRAINVREF         = 6;
localparam DATATRAINCENTER1     = 7;
localparam DATATRAINVREF        = 8;
localparam RXDESKEW             = 9;
localparam DATATRAINCENTER2     = 10;
localparam LINKSPEED            = 11;
localparam REPAIR               = 12;


states_tx CS_top_1, NS_top_1, CS_top_2, NS_top_2;

always @ (*) begin
CS_top_1 = states_tx'(MODULE_inst_1.CS);
NS_top_1 = states_tx'(MODULE_inst_1.NS);
CS_top_2 = states_tx'(MODULE_inst_2.CS);
NS_top_2 = states_tx'(MODULE_inst_2.NS);
end
// module 
always @ (*) begin
sub_state_1 = "UNKNOWN";
case (CS_top_1) 
    MBINIT: begin
        case (o_tx_sub_state_1)
            0: sub_state_1 = "PARAM";
            1: sub_state_1 = "CAL";
            2: sub_state_1 = "REPAIRCLK";
            3: sub_state_1 = "REPAIRVAL";
            4: sub_state_1 = "REVERSALMB";
            5: sub_state_1 = "REPAIRMB";
            default: sub_state_1 = "UNKNOWN";
        endcase
    end
    MBTRAIN: begin
        case (o_tx_sub_state_1)
            0: sub_state_1 = "VALVREF";
            1: sub_state_1 = "DATAVREF";
            2: sub_state_1 = "SPEEDIDLE";
            3: sub_state_1 = "TXSELFCAL";
            4: sub_state_1 = "RXCLKCAL";
            5: sub_state_1 = "VALTRAINCENTER";
            6: sub_state_1 = "VALTRAINVREF";
            7: sub_state_1 = "DATATRAINCENTER1";
            8: sub_state_1 = "DATATRAINVREF";
            9: sub_state_1 = "RXDESKEW";
            10: sub_state_1 = "DATATRAINCENTER2";
            11: sub_state_1 = "LINKSPEED";
            12: sub_state_1 = "REPAIR";
            default : sub_state_1 = "UNKNOWN";
        endcase
    end
endcase
end

//partner
always @ (*) begin
sub_state_2 = "UNKNOWN";
case (CS_top_2) 
    MBINIT: begin
        case (o_tx_sub_state_2)
            0: sub_state_2 = "PARAM";
            1: sub_state_2 = "CAL";
            2: sub_state_2 = "REPAIRCLK";
            3: sub_state_2 = "REPAIRVAL";
            4: sub_state_2 = "REVERSALMB";
            5: sub_state_2 = "REPAIRMB";
            default: sub_state_2 = "UNKNOWN";
        endcase
    end
    MBTRAIN: begin
        case (o_tx_sub_state_2)
            0: sub_state_2 = "VALVREF";
            1: sub_state_2 = "DATAVREF";
            2: sub_state_2 = "SPEEDIDLE";
            3: sub_state_2 = "TXSELFCAL";
            4: sub_state_2 = "RXCLKCAL";
            5: sub_state_2 = "VALTRAINCENTER";
            6: sub_state_2 = "VALTRAINVREF";
            7: sub_state_2 = "DATATRAINCENTER1";
            8: sub_state_2 = "DATATRAINVREF";
            9: sub_state_2 = "RXDESKEW";
            10: sub_state_2 = "DATATRAINCENTER2";
            11: sub_state_2 = "LINKSPEED";
            12: sub_state_2 = "REPAIR";
            default : sub_state_2 = "UNKOWN";
        endcase
    end
endcase
end

// module 
always @ (*) begin
i_rx_msg_no_string_1 = "UNKNOWN"; // Default case

case (CS_top_1)
    SBINIT: begin
        case (MODULE_inst_1.i_decoded_SB_msg)
            3: i_rx_msg_no_string_1 = "SBINIT_OUT_OF_RESET_MSG";
            1: i_rx_msg_no_string_1 = "SBINIT_DONE_REQ_MSG";
            2: i_rx_msg_no_string_1 = "SBINIT_DONE_RESP_MSG";
        endcase
    end
    MBINIT: begin
        case (o_tx_sub_state_1)
            PARAM: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "PARAM_CONFIG_REQ";
                    2: i_rx_msg_no_string_1 = "PARAM_CONFIG_RESP";
                    3: i_rx_msg_no_string_1 = "PARAM_SBFE_REQ";
                    4: i_rx_msg_no_string_1 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "CAL_DONE_REQ";
                    2: i_rx_msg_no_string_1 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIRCLK_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRCLK_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRCLK_RESULT_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRCLK_RESULT_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRCLK_DONE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIRVAL_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRVAL_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRVAL_RESULT_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRVAL_RESULT_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRVAL_DONE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REVERSALMB_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REVERSALMB_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: i_rx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: i_rx_msg_no_string_1 = "REVERSALMB_RESULT_REQ";
                    6: i_rx_msg_no_string_1 = "REVERSALMB_RESULT_RESP";
                    7: i_rx_msg_no_string_1 = "REVERSALMB_DONE_REQ";
                    8: i_rx_msg_no_string_1 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIRMB_START_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRMB_START_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRMB_END_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRMB_END_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    MBTRAIN: begin
        case (o_tx_sub_state_1)
            VALVREF: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "VALVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "VALVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "VALVREF_END_REQ";
                    4: i_rx_msg_no_string_1 = "VALVREF_END_RESP";
                endcase
            end
            DATAVREF: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATAVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATAVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATAVREF_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATAVREF_END_RESP";
                endcase
            end
            SPEEDIDLE: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "SPEEDIDLE_DONE_REQ";
                    2: i_rx_msg_no_string_1 = "SPEEDIDLE_DONE_RESP";
                endcase
            end
            TXSELFCAL: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "TXSELFCAL_DONE_REQ";
                    2: i_rx_msg_no_string_1 = "TXSELFCAL_DONE_RESP";
                endcase
            end
            RXCLKCAL: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "RXCLKCAL_START_REQ";
                    2: i_rx_msg_no_string_1 = "RXCLKCAL_START_RESP";
                    3: i_rx_msg_no_string_1 = "RXCLKCAL_DONE_REQ";
                    4: i_rx_msg_no_string_1 = "RXCLKCAL_DONE_RESP";
                endcase
            end
            VALTRAINCENTER: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "VALTRAINCENTER_START_REQ";
                    2: i_rx_msg_no_string_1 = "VALTRAINCENTER_START_RESP";
                    3: i_rx_msg_no_string_1 = "VALTRAINCENTER_DONE_REQ";
                    4: i_rx_msg_no_string_1 = "VALTRAINCENTER_DONE_RESP";
                endcase
            end
            VALTRAINVREF: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "VALTRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "VALTRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "VALTRAINVREF_DONE_REQ";
                    4: i_rx_msg_no_string_1 = "VALTRAINVREF_DONE_RESP";
                endcase
            end
            DATATRAINCENTER1: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATATRAINCENTER1_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATATRAINCENTER1_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATATRAINCENTER1_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATATRAINCENTER1_END_RESP";
                endcase
            end
            DATATRAINVREF: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATATRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATATRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATATRAINVREF_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATATRAINVREF_END_RESP";
                endcase
            end
            RXDESKEW: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "RXDESKEW_START_REQ";
                    2: i_rx_msg_no_string_1 = "RXDESKEW_START_RESP";
                    3: i_rx_msg_no_string_1 = "RXDESKEW_END_REQ";
                    4: i_rx_msg_no_string_1 = "RXDESKEW_END_RESP";
                endcase
            end
            DATATRAINCENTER2: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATATRAINCENTER2_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATATRAINCENTER2_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATATRAINCENTER2_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATATRAINCENTER2_END_RESP";
                endcase
            end
            LINKSPEED: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "LINKSPEED_START_REQ";
                    2: i_rx_msg_no_string_1 = "LINKSPEED_START_RESP";
                    3: i_rx_msg_no_string_1 = "LINKSPEED_ERROR_REQ";
                    4: i_rx_msg_no_string_1 = "LINKSPEED_ERROR_RESP";
                    5: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                    6: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                    7: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                    8: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                    9: i_rx_msg_no_string_1 = "LINKSPEED_DONE_REQ";
                    10: i_rx_msg_no_string_1 = "LINKSPEED_DONE_RESP";
                    11: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                    12: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                endcase
            end
            REPAIR: begin
                case (MODULE_inst_1.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIR_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIR_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIR_END_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIR_END_RESP";
                    7: i_rx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_REQ";
                    8: i_rx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    TRAINERROR_HS: begin
        case (MODULE_inst_1.i_decoded_SB_msg)
            15: i_rx_msg_no_string_1 = "TRAINERROR_REQ";
            14: i_rx_msg_no_string_1 = "TRAINERROR_RESP";
        endcase
    end
    PHYRETRAIN: begin
        case (MODULE_inst_1.i_decoded_SB_msg)
            1: i_rx_msg_no_string_1 = "PHYRETRAIN_START_REQ";
            2: i_rx_msg_no_string_1 = "PHYRETRAIN_START_RESP";
        endcase
    end
endcase
end

always @ (*) begin
o_tx_msg_no_string_1 = "UNKNOWN"; // Default case

case (CS_top_1)
    SBINIT: begin
        case (MODULE_inst_1.o_encoded_SB_msg)
            3: o_tx_msg_no_string_1 = "SBINIT_OUT_OF_RESET_MSG";
            1: o_tx_msg_no_string_1 = "SBINIT_DONE_REQ_MSG";
            2: o_tx_msg_no_string_1 = "SBINIT_DONE_RESP_MSG";
        endcase
    end
    MBINIT: begin
        case (o_tx_sub_state_1)
            PARAM: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "PARAM_CONFIG_REQ";
                    2: o_tx_msg_no_string_1 = "PARAM_CONFIG_RESP";
                    3: o_tx_msg_no_string_1 = "PARAM_SBFE_REQ";
                    4: o_tx_msg_no_string_1 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "CAL_DONE_REQ";
                    2: o_tx_msg_no_string_1 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIRCLK_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRCLK_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRCLK_RESULT_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRCLK_RESULT_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRCLK_DONE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIRVAL_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRVAL_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRVAL_RESULT_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRVAL_RESULT_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRVAL_DONE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REVERSALMB_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REVERSALMB_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: o_tx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: o_tx_msg_no_string_1 = "REVERSALMB_RESULT_REQ";
                    6: o_tx_msg_no_string_1 = "REVERSALMB_RESULT_RESP";
                    7: o_tx_msg_no_string_1 = "REVERSALMB_DONE_REQ";
                    8: o_tx_msg_no_string_1 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIRMB_START_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRMB_START_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRMB_END_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRMB_END_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    MBTRAIN: begin
        case (o_tx_sub_state_1)
            VALVREF: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "VALVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "VALVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "VALVREF_END_REQ";
                    4: o_tx_msg_no_string_1 = "VALVREF_END_RESP";
                endcase
            end
            DATAVREF: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATAVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATAVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATAVREF_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATAVREF_END_RESP";
                endcase
            end
            SPEEDIDLE: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "SPEEDIDLE_DONE_REQ";
                    2: o_tx_msg_no_string_1 = "SPEEDIDLE_DONE_RESP";
                endcase
            end
            TXSELFCAL: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "TXSELFCAL_DONE_REQ";
                    2: o_tx_msg_no_string_1 = "TXSELFCAL_DONE_RESP";
                endcase
            end
            RXCLKCAL: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "RXCLKCAL_START_REQ";
                    2: o_tx_msg_no_string_1 = "RXCLKCAL_START_RESP";
                    3: o_tx_msg_no_string_1 = "RXCLKCAL_DONE_REQ";
                    4: o_tx_msg_no_string_1 = "RXCLKCAL_DONE_RESP";
                endcase
            end
            VALTRAINCENTER: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "VALTRAINCENTER_START_REQ";
                    2: o_tx_msg_no_string_1 = "VALTRAINCENTER_START_RESP";
                    3: o_tx_msg_no_string_1 = "VALTRAINCENTER_DONE_REQ";
                    4: o_tx_msg_no_string_1 = "VALTRAINCENTER_DONE_RESP";
                endcase
            end
            VALTRAINVREF: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "VALTRAINVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "VALTRAINVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "VALTRAINVREF_DONE_REQ";
                    4: o_tx_msg_no_string_1 = "VALTRAINVREF_DONE_RESP";
                endcase
            end
            DATATRAINCENTER1: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATATRAINCENTER1_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATATRAINCENTER1_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATATRAINCENTER1_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATATRAINCENTER1_END_RESP";
                endcase
            end
            DATATRAINVREF: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATATRAINVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATATRAINVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATATRAINVREF_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATATRAINVREF_END_RESP";
                endcase
            end
            RXDESKEW: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "RXDESKEW_START_REQ";
                    2: o_tx_msg_no_string_1 = "RXDESKEW_START_RESP";
                    3: o_tx_msg_no_string_1 = "RXDESKEW_END_REQ";
                    4: o_tx_msg_no_string_1 = "RXDESKEW_END_RESP";
                endcase
            end
            DATATRAINCENTER2: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATATRAINCENTER2_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATATRAINCENTER2_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATATRAINCENTER2_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATATRAINCENTER2_END_RESP";
                endcase
            end
            LINKSPEED: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "LINKSPEED_START_REQ";
                    2: o_tx_msg_no_string_1 = "LINKSPEED_START_RESP";
                    3: o_tx_msg_no_string_1 = "LINKSPEED_ERROR_REQ";
                    4: o_tx_msg_no_string_1 = "LINKSPEED_ERROR_RESP";
                    5: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                    6: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                    7: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                    8: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                    9: o_tx_msg_no_string_1 = "LINKSPEED_DONE_REQ";
                    10: o_tx_msg_no_string_1 = "LINKSPEED_DONE_RESP";
                    11: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                    12: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                endcase
            end
            REPAIR: begin
                case (MODULE_inst_1.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIR_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIR_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIR_END_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIR_END_RESP";
                    7: o_tx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_REQ";
                    8: o_tx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    TRAINERROR_HS: begin
        case (MODULE_inst_1.o_encoded_SB_msg)
            15: o_tx_msg_no_string_1 = "TRAINERROR_REQ";
            14: o_tx_msg_no_string_1 = "TRAINERROR_RESP";
        endcase
    end
    PHYRETRAIN: begin
        case (MODULE_inst_1.o_encoded_SB_msg)
            1: o_tx_msg_no_string_1 = "PHYRETRAIN_START_REQ";
            2: o_tx_msg_no_string_1 = "PHYRETRAIN_START_RESP";
        endcase
    end
endcase
end

// partner
always @ (*) begin
i_rx_msg_no_string_2 = "UNKNOWN"; // Default case

case (CS_top_2)
    SBINIT: begin
        case (MODULE_inst_2.i_decoded_SB_msg)
            3: i_rx_msg_no_string_2 = "SBINIT_OUT_OF_RESET_MSG";
            1: i_rx_msg_no_string_2 = "SBINIT_DONE_REQ_MSG";
            2: i_rx_msg_no_string_2 = "SBINIT_DONE_RESP_MSG";
        endcase
    end
    MBINIT: begin
        case (o_tx_sub_state_2)
            PARAM: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "PARAM_CONFIG_REQ";
                    2: i_rx_msg_no_string_2 = "PARAM_CONFIG_RESP";
                    3: i_rx_msg_no_string_2 = "PARAM_SBFE_REQ";
                    4: i_rx_msg_no_string_2 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "CAL_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REVERSALMB_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REVERSALMB_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_REQ";
                    6: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_RESP";
                    7: i_rx_msg_no_string_2 = "REVERSALMB_DONE_REQ";
                    8: i_rx_msg_no_string_2 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIRMB_START_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRMB_START_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRMB_END_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRMB_END_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    MBTRAIN: begin
        case (o_tx_sub_state_2)
            VALVREF: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "VALVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "VALVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "VALVREF_END_REQ";
                    4: i_rx_msg_no_string_2 = "VALVREF_END_RESP";
                endcase
            end
            DATAVREF: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATAVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATAVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATAVREF_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATAVREF_END_RESP";
                endcase
            end
            SPEEDIDLE: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "SPEEDIDLE_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "SPEEDIDLE_DONE_RESP";
                endcase
            end
            TXSELFCAL: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "TXSELFCAL_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "TXSELFCAL_DONE_RESP";
                endcase
            end
            RXCLKCAL: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "RXCLKCAL_START_REQ";
                    2: i_rx_msg_no_string_2 = "RXCLKCAL_START_RESP";
                    3: i_rx_msg_no_string_2 = "RXCLKCAL_DONE_REQ";
                    4: i_rx_msg_no_string_2 = "RXCLKCAL_DONE_RESP";
                endcase
            end
            VALTRAINCENTER: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "VALTRAINCENTER_START_REQ";
                    2: i_rx_msg_no_string_2 = "VALTRAINCENTER_START_RESP";
                    3: i_rx_msg_no_string_2 = "VALTRAINCENTER_DONE_REQ";
                    4: i_rx_msg_no_string_2 = "VALTRAINCENTER_DONE_RESP";
                endcase
            end
            VALTRAINVREF: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "VALTRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "VALTRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "VALTRAINVREF_DONE_REQ";
                    4: i_rx_msg_no_string_2 = "VALTRAINVREF_DONE_RESP";
                endcase
            end
            DATATRAINCENTER1: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATATRAINCENTER1_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATATRAINCENTER1_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATATRAINCENTER1_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATATRAINCENTER1_END_RESP";
                endcase
            end
            DATATRAINVREF: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATATRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATATRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATATRAINVREF_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATATRAINVREF_END_RESP";
                endcase
            end
            RXDESKEW: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "RXDESKEW_START_REQ";
                    2: i_rx_msg_no_string_2 = "RXDESKEW_START_RESP";
                    3: i_rx_msg_no_string_2 = "RXDESKEW_END_REQ";
                    4: i_rx_msg_no_string_2 = "RXDESKEW_END_RESP";
                endcase
            end
            DATATRAINCENTER2: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATATRAINCENTER2_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATATRAINCENTER2_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATATRAINCENTER2_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATATRAINCENTER2_END_RESP";
                endcase
            end
            LINKSPEED: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "LINKSPEED_START_REQ";
                    2: i_rx_msg_no_string_2 = "LINKSPEED_START_RESP";
                    3: i_rx_msg_no_string_2 = "LINKSPEED_ERROR_REQ";
                    4: i_rx_msg_no_string_2 = "LINKSPEED_ERROR_RESP";
                    5: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                    6: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                    7: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                    8: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                    9: i_rx_msg_no_string_2 = "LINKSPEED_DONE_REQ";
                    10: i_rx_msg_no_string_2 = "LINKSPEED_DONE_RESP";
                    11: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                    12: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                endcase
            end
            REPAIR: begin
                case (MODULE_inst_2.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIR_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIR_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIR_END_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIR_END_RESP";
                    7: i_rx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_REQ";
                    8: i_rx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    TRAINERROR_HS: begin
        case (MODULE_inst_2.i_decoded_SB_msg)
            15: i_rx_msg_no_string_2 = "TRAINERROR_REQ";
            14: i_rx_msg_no_string_2 = "TRAINERROR_RESP";
        endcase
    end
    PHYRETRAIN: begin
        case (MODULE_inst_2.i_decoded_SB_msg)
            1: i_rx_msg_no_string_2 = "PHYRETRAIN_START_REQ";
            2: i_rx_msg_no_string_2 = "PHYRETRAIN_START_RESP";
        endcase
    end
endcase
end

always @ (*) begin
o_tx_msg_no_string_2 = "UNKNOWN"; // Default case

case (CS_top_2)
    SBINIT: begin
        case (MODULE_inst_2.o_encoded_SB_msg)
            3: o_tx_msg_no_string_2 = "SBINIT_OUT_OF_RESET_MSG";
            1: o_tx_msg_no_string_2 = "SBINIT_DONE_REQ_MSG";
            2: o_tx_msg_no_string_2 = "SBINIT_DONE_RESP_MSG";
        endcase
    end
    MBINIT: begin
        case (o_tx_sub_state_2)
            PARAM: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "PARAM_CONFIG_REQ";
                    2: o_tx_msg_no_string_2 = "PARAM_CONFIG_RESP";
                    3: o_tx_msg_no_string_2 = "PARAM_SBFE_REQ";
                    4: o_tx_msg_no_string_2 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "CAL_DONE_REQ";
                    2: o_tx_msg_no_string_2 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "REPAIRCLK_INIT_REQ";
                    2: o_tx_msg_no_string_2 = "REPAIRCLK_INIT_RESP";
                    3: o_tx_msg_no_string_2 = "REPAIRCLK_RESULT_REQ";
                    4: o_tx_msg_no_string_2 = "REPAIRCLK_RESULT_RESP";
                    5: o_tx_msg_no_string_2 = "REPAIRCLK_DONE_REQ";
                    6: o_tx_msg_no_string_2 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "REPAIRVAL_INIT_REQ";
                    2: o_tx_msg_no_string_2 = "REPAIRVAL_INIT_RESP";
                    3: o_tx_msg_no_string_2 = "REPAIRVAL_RESULT_REQ";
                    4: o_tx_msg_no_string_2 = "REPAIRVAL_RESULT_RESP";
                    5: o_tx_msg_no_string_2 = "REPAIRVAL_DONE_REQ";
                    6: o_tx_msg_no_string_2 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "REVERSALMB_INIT_REQ";
                    2: o_tx_msg_no_string_2 = "REVERSALMB_INIT_RESP";
                    3: o_tx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: o_tx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: o_tx_msg_no_string_2 = "REVERSALMB_RESULT_REQ";
                    6: o_tx_msg_no_string_2 = "REVERSALMB_RESULT_RESP";
                    7: o_tx_msg_no_string_2 = "REVERSALMB_DONE_REQ";
                    8: o_tx_msg_no_string_2 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "REPAIRMB_START_REQ";
                    2: o_tx_msg_no_string_2 = "REPAIRMB_START_RESP";
                    3: o_tx_msg_no_string_2 = "REPAIRMB_END_REQ";
                    4: o_tx_msg_no_string_2 = "REPAIRMB_END_RESP";
                    5: o_tx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: o_tx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    MBTRAIN: begin
        case (o_tx_sub_state_2)
            VALVREF: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "VALVREF_START_REQ";
                    2: o_tx_msg_no_string_2 = "VALVREF_START_RESP";
                    3: o_tx_msg_no_string_2 = "VALVREF_END_REQ";
                    4: o_tx_msg_no_string_2 = "VALVREF_END_RESP";
                endcase
            end
            DATAVREF: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "DATAVREF_START_REQ";
                    2: o_tx_msg_no_string_2 = "DATAVREF_START_RESP";
                    3: o_tx_msg_no_string_2 = "DATAVREF_END_REQ";
                    4: o_tx_msg_no_string_2 = "DATAVREF_END_RESP";
                endcase
            end
            SPEEDIDLE: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "SPEEDIDLE_DONE_REQ";
                    2: o_tx_msg_no_string_2 = "SPEEDIDLE_DONE_RESP";
                endcase
            end
            TXSELFCAL: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "TXSELFCAL_DONE_REQ";
                    2: o_tx_msg_no_string_2 = "TXSELFCAL_DONE_RESP";
                endcase
            end
            RXCLKCAL: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "RXCLKCAL_START_REQ";
                    2: o_tx_msg_no_string_2 = "RXCLKCAL_START_RESP";
                    3: o_tx_msg_no_string_2 = "RXCLKCAL_DONE_REQ";
                    4: o_tx_msg_no_string_2 = "RXCLKCAL_DONE_RESP";
                endcase
            end
            VALTRAINCENTER: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "VALTRAINCENTER_START_REQ";
                    2: o_tx_msg_no_string_2 = "VALTRAINCENTER_START_RESP";
                    3: o_tx_msg_no_string_2 = "VALTRAINCENTER_DONE_REQ";
                    4: o_tx_msg_no_string_2 = "VALTRAINCENTER_DONE_RESP";
                endcase
            end
            VALTRAINVREF: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "VALTRAINVREF_START_REQ";
                    2: o_tx_msg_no_string_2 = "VALTRAINVREF_START_RESP";
                    3: o_tx_msg_no_string_2 = "VALTRAINVREF_DONE_REQ";
                    4: o_tx_msg_no_string_2 = "VALTRAINVREF_DONE_RESP";
                endcase
            end
            DATATRAINCENTER1: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "DATATRAINCENTER1_START_REQ";
                    2: o_tx_msg_no_string_2 = "DATATRAINCENTER1_START_RESP";
                    3: o_tx_msg_no_string_2 = "DATATRAINCENTER1_END_REQ";
                    4: o_tx_msg_no_string_2 = "DATATRAINCENTER1_END_RESP";
                endcase
            end
            DATATRAINVREF: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "DATATRAINVREF_START_REQ";
                    2: o_tx_msg_no_string_2 = "DATATRAINVREF_START_RESP";
                    3: o_tx_msg_no_string_2 = "DATATRAINVREF_END_REQ";
                    4: o_tx_msg_no_string_2 = "DATATRAINVREF_END_RESP";
                endcase
            end
            RXDESKEW: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "RXDESKEW_START_REQ";
                    2: o_tx_msg_no_string_2 = "RXDESKEW_START_RESP";
                    3: o_tx_msg_no_string_2 = "RXDESKEW_END_REQ";
                    4: o_tx_msg_no_string_2 = "RXDESKEW_END_RESP";
                endcase
            end
            DATATRAINCENTER2: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "DATATRAINCENTER2_START_REQ";
                    2: o_tx_msg_no_string_2 = "DATATRAINCENTER2_START_RESP";
                    3: o_tx_msg_no_string_2 = "DATATRAINCENTER2_END_REQ";
                    4: o_tx_msg_no_string_2 = "DATATRAINCENTER2_END_RESP";
                endcase
            end
            LINKSPEED: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "LINKSPEED_START_REQ";
                    2: o_tx_msg_no_string_2 = "LINKSPEED_START_RESP";
                    3: o_tx_msg_no_string_2 = "LINKSPEED_ERROR_REQ";
                    4: o_tx_msg_no_string_2 = "LINKSPEED_ERROR_RESP";
                    5: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                    6: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                    7: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                    8: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                    9: o_tx_msg_no_string_2 = "LINKSPEED_DONE_REQ";
                    10: o_tx_msg_no_string_2 = "LINKSPEED_DONE_RESP";
                    11: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                    12: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                endcase
            end
            REPAIR: begin
                case (MODULE_inst_2.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_2 = "REPAIR_INIT_REQ";
                    2: o_tx_msg_no_string_2 = "REPAIR_INIT_RESP";
                    3: o_tx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_REQ";
                    4: o_tx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_RESP";
                    5: o_tx_msg_no_string_2 = "REPAIR_END_REQ";
                    6: o_tx_msg_no_string_2 = "REPAIR_END_RESP";
                    7: o_tx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_REQ";
                    8: o_tx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    TRAINERROR_HS: begin
        case (MODULE_inst_2.o_encoded_SB_msg)
            15: o_tx_msg_no_string_2 = "TRAINERROR_REQ";
            14: o_tx_msg_no_string_2 = "TRAINERROR_RESP";
        endcase
    end
    PHYRETRAIN: begin
        case (MODULE_inst_2.o_encoded_SB_msg)
            1: o_tx_msg_no_string_2 = "PHYRETRAIN_START_REQ";
            2: o_tx_msg_no_string_2 = "PHYRETRAIN_START_RESP";
        endcase
    end
endcase
end
endmodule 