module LTSN_SB_MB #(
    localparam SER_WIDTH = 32
) (
    /*************************************************************************
    * INPUTS
    *************************************************************************/
    // clocks and resets 
    input                       i_clk,
    input                       i_clk_sb,
    input                       i_rst_n,  
    // RDI 
    input       [8*63:0]        i_lp_data, 
    // valid lane
    input       [SER_WIDTH-1:0] i_RVLD_L, 
    // Main band data lanes
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_0,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_1,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_2,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_3,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_4,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_5,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_6,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_7,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_8,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_9,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_10,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_11,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_12,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_13,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_14,
    input       [SER_WIDTH-1:0] i_lfsr_rx_lane_15,
    // communicating with analog domain
    input                       i_deserliazer_valid,
    /*************************************************************************
    * OUTPUTS
    *************************************************************************/
    // Clock lanes : CKP, CKN, TRACK
    output                      o_CKP,
    output                      o_CKN,
    output                      o_TRACK,
    // valid lane
    output      [SER_WIDTH-1:0] o_TVLD_L, 
    // Main band data lanes
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_0,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_1,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_2,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_3,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_4,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_5,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_6,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_7,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_8,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_9,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_10,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_11,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_12,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_13,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_14,
    output      [SER_WIDTH-1:0] o_lfsr_tx_lane_15,
    // RDI 
    output       [8*63:0]       o_pl_data,
    // communicating with analog domain
    output                      o_serliazer_en,
    output     [3:0]            o_reciever_ref_volatge,
    output     [3:0]            o_pi_step,
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// INTERNAL SIGNALS //////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/****************************************
* MAPPER related signals
****************************************/
wire [SER_WIDTH-1:0] o_mapper_lane_0;
wire [SER_WIDTH-1:0] o_mapper_lane_1;
wire [SER_WIDTH-1:0] o_mapper_lane_2;
wire [SER_WIDTH-1:0] o_mapper_lane_3;
wire [SER_WIDTH-1:0] o_mapper_lane_4;
wire [SER_WIDTH-1:0] o_mapper_lane_5;
wire [SER_WIDTH-1:0] o_mapper_lane_6;
wire [SER_WIDTH-1:0] o_mapper_lane_7;
wire [SER_WIDTH-1:0] o_mapper_lane_8;
wire [SER_WIDTH-1:0] o_mapper_lane_9;
wire [SER_WIDTH-1:0] o_mapper_lane_10;
wire [SER_WIDTH-1:0] o_mapper_lane_11;
wire [SER_WIDTH-1:0] o_mapper_lane_12;
wire [SER_WIDTH-1:0] o_mapper_lane_13;
wire [SER_WIDTH-1:0] o_mapper_lane_14;
wire [SER_WIDTH-1:0] o_mapper_lane_15;
/****************************************
* DEMAPPER related signals
****************************************/
/****************************************
* LFSR TX related signals
****************************************/
wire lfsr_tx_pattern_done;
wire [1:0] mainband_pattern_generator_cw;
/****************************************
* LFSR RX related signals
****************************************/
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_0;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_1;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_2;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_3;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_4;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_5;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_6;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_7;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_8;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_9;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_10;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_11;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_12;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_13;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_14;
wire [SER_WIDTH-1:0] o_lfsr_rx_bypass_15;

wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_0;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_1;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_2;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_3;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_4;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_5;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_6;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_7;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_8;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_9;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_10;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_11;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_12;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_13;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_14;
wire [SER_WIDTH-1:0] o_lfsr_rx_final_gen_15;

wire [1:0]  mainband_pattern_comparator_cw;
wire [15:0] lfsr_rx_comparison_results;
wire [15:0] aggregate_counter;
wire aggregate_error_found;
wire enable_pattern_comparitor;
/****************************************
* TX D2C POINT TEST related signals
****************************************/
wire tx_d2c_pt_en;
wire tx_d2c_pt_done;
wire tx_datatrain_or_valtrain;
wire tx_perlaneid_or_lfsr;
wire val_pattern_en_tx_d2c_pt;
wire val_comparison_en_tx_d2c_pt;
wire [15:0] tx_d2c_pt_results;
wire [1:0] mainband_pattern_generator_cw_tx_d2c_pt;
wire [1:0] mainband_pattern_comparator_cw_tx_d2c_pt;
wire [3:0] reciever_ref_volatge_tx_d2c_pt;
/****************************************
* RX D2C POINT TEST related signals
****************************************/
wire rx_d2c_pt_en;
wire rx_d2c_pt_done;
wire rx_datavref_or_valvref;
wire val_pattern_en_rx_d2c_pt;
wire val_comparison_en_rx_d2c_pt;
wire [15:0] rx_d2c_pt_results;
wire [1:0] mainband_pattern_generator_cw_rx_d2c_pt;
wire [1:0] mainband_pattern_comparator_cw_rx_d2c_pt;
/****************************************
* SIDEBAND related signals
****************************************/
wire sb_fifo_empty;
wire sb_start_pattern_done;
wire sb_rx_start_training;
wire sb_time_out;
wire sb_busy;
wire sb_rx_msg_valid;
wire sb_start_pattern_req;
wire sb_tx_rdi_msg_en;
wire sb_stop_cnt;
// muxed
wire [3:0]  sb_tx_msg_no;
wire [3:0]  sb_tx_msg_no_ltsm;
wire [3:0]  sb_tx_msg_no_rx_d2c_pt;
wire [3:0]  sb_tx_msg_no_tx_d2c_pt;
// muxed
wire [15:0] sb_tx_data_bus;
wire [15:0] sb_tx_data_bus_ltsm;
wire [15:0] sb_tx_data_bus_rx_d2c_pt;
wire [15:0] sb_tx_data_bus_tx_d2c_pt;
//muxed 
wire sb_tx_msg_valid;
wire sb_tx_msg_valid_ltsm;
wire sb_tx_msg_valid_rx_d2c_pt;
wire sb_tx_msg_valid_tx_d2c_pt;
//muxed
wire sb_tx_data_valid;
wire sb_tx_data_valid_ltsm;
wire sb_tx_data_valid_rx_d2c_pt;
wire sb_tx_data_valid_tx_d2c_pt;

wire [3:0]  sb_tx_state;
wire [3:0]  sb_tx_sub_state;
wire [2:0]  sb_rx_msg_info;
wire [15:0] sb_rx_data_bus;
wire [3:0]  sb_rx_msg_no;
wire [2:0]  sb_rx_msg_info;
/****************************************
* LTSM related signals
****************************************/
wire apply_reversal_en;
wire val_pattern_en_ltsm;
wire [3:0] reciever_ref_volatge_ltsm;
wire [1:0] mainband_pattern_generator_cw_ltsm;
wire [1:0] mainband_pattern_comparator_cw_ltsm;
wire [1:0] functional_tx_lanes;
wire [1:0] functional_rx_lanes
/****************************************
* VALID related signals
****************************************/
wire val_tx_pattern_done;
wire val_rx_comparison_result;
/****************************************
* CLOCK CONTROL related signals
****************************************/
wire clk_tx_pattern_done;
wire clk_tx_pattern_en;
wire detect_RCKP;
wire detect_RCKN;
wire detect_RTRK;
wire gen_enable_detector_CKP;
wire gen_enable_detector_CKN;
wire gen_enable_detector_Track;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// INSTANTIATIONS ////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/****************************************
* LTSM TOP
****************************************/
LTSM_TOP LTSM_TOP_inst (
    .i_clk                                                          (i_clk),
    .i_rst_n                                                        (i_rst_n),
    /*------------------------------------------------------------------------------------------------------------
     * RDI signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_start_training_RDI                                           (i_start_training_RDI_1),
    .i_go_to_phyretrain_ACTIVE                                      (i_go_to_phyretrain_ACTIVE_1),
    .i_lp_linkerror                                                 (i_lp_linkerror_1),
    .i_LINKINIT_DONE                                                (i_LINKINIT_DONE_1),
    .i_ACTIVE_DONE                                                  (i_ACTIVE_DONE_1),
    /*------------------------------------------------------------------------------------------------------------
     * SB signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_SB_fifo_empty                                                (sb_fifo_empty),
    .i_start_pattern_done                                           (sb_start_pattern_done),
    .i_start_training_SB                                            (sb_rx_start_training),
    .i_time_out                                                     (sb_time_out),
    .i_busy                                                         (sb_busy),
    .i_rx_msg_valid                                                 (sb_rx_msg_valid),
    .i_decoded_SB_msg                                               (sb_rx_msg_no),
    .i_rx_msg_info                                                  (sb_rx_msg_info),
    .i_rx_data_bus                                                  (sb_rx_data_bus),
    .o_start_pattern_req                                            (sb_start_pattern_req),
    .o_tx_state                                                     (sb_tx_state),
    .o_tx_sub_state                                                 (sb_tx_sub_state),
    .o_encoded_SB_msg                                               (sb_tx_msg_no_ltsm),
    .o_tx_msg_info                                                  (sb_tx_msg_info),
    .o_tx_data_bus                                                  (sb_tx_data_bus_ltsm),
    .o_tx_msg_valid                                                 (sb_tx_msg_valid),
    .o_tx_data_valid                                                (sb_tx_data_valid),
    .o_tx_rdi_msg_en                                                (sb_tx_rdi_msg_en),
    .o_MBTRAIN_timeout_disable                                      (sb_stop_cnt),
    /*------------------------------------------------------------------------------------------------------------
     * TX INITIATED D2C POINT TEST signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_Transmitter_initiated_Data_to_CLK_done                       (tx_d2c_pt_done),
    .i_Transmitter_initiated_Data_to_CLK_Result                     (tx_d2c_pt_results),
    .o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK       (tx_datatrain_or_valtrain),
    .o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK            (tx_perlaneid_or_lfsr),
    .o_Transmitter_initiated_Data_to_CLK_en                         (tx_d2c_pt_en),
    /*------------------------------------------------------------------------------------------------------------
     * RX INITIATED D2C POINT TEST signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_Receiver_initiated_Data_to_CLK_done                          (rx_d2c_pt_done),
    .i_Receiver_initiated_Data_to_CLK_Result                        (rx_d2c_pt_results),
    .o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK  (rx_datavref_or_valvref),
    .o_MBTRAIN_Receiver_initiated_Data_to_CLK_en                    (rx_d2c_pt_en),
    /*------------------------------------------------------------------------------------------------------------
     * LFSR TX signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_pattern_generation_done                                      (lfsr_tx_pattern_done),
    .i_REVERSAL_done                                                (lfsr_tx_pattern_done),
    .o_MBINIT_mainband_pattern_generator_cw                         (mainband_pattern_generator_cw_ltsm),
    .o_MBINIT_REVERSALMB_ApplyReversal_En                           (apply_reversal_en),
    /*------------------------------------------------------------------------------------------------------------
     * LFSR RX signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_comparsion_results                                           (lfsr_rx_comparison_results),
    .i_aggregate_counter                                            (aggregate_counter),
    .i_aggregate_error_found                                        (aggregate_error_found),
    .o_MBINIT_mainband_pattern_comparator_cw                        (mainband_pattern_comparator_cw_ltsm),
    /*------------------------------------------------------------------------------------------------------------
     * CLOCK CONTROLLER signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_CLK_Track_done                                               (clk_tx_pattern_done),
    .o_MBINIT_REPAIRCLK_Pattern_En                                  (clk_tx_pattern_en),
    /*------------------------------------------------------------------------------------------------------------
     * CLOCK PATTERN DETECTOR signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_logged_clk_result                                            ({detect_RCKP,detect_RCKN,detect_RTRK}),
    /*------------------------------------------------------------------------------------------------------------
     * VALID CONTROLLER signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_VAL_Pattern_done                                             (val_tx_pattern_done),
    .o_MBINIT_REPAIRVAL_Pattern_En                                  (val_pattern_en_ltsm),
    /*------------------------------------------------------------------------------------------------------------
     * VALID PATTERN DETECTOR signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_logged_val_result                                            (val_rx_comparison_result),
    /*------------------------------------------------------------------------------------------------------------
     * MAPPER/DEMAPPER signals
    ------------------------------------------------------------------------------------------------------------*/ 
    .o_mapper_demapper_en                                           (mapper_demapper_en), 
    /*------------------------------------------------------------------------------------------------------------
     * OTHERS 
    ------------------------------------------------------------------------------------------------------------*/
    .i_start_training_DVSEC                                         (i_start_training_DVSEC_1),
    .i_valid_framing_error                                          (i_valid_framing_error_1),
    .o_reciever_ref_volatge                                         (o_reciever_ref_volatge),
    .o_functional_tx_lanes                                          (functional_tx_lanes),
    .o_functional_rx_lanes                                          (functional_rx_lanes),
    .o_MBTRAIN_tx_eye_width_sweep_en                                (o_MBTRAIN_tx_eye_width_sweep_en_1),
    .o_MBTRAIN_rx_eye_width_sweep_en                                (o_MBTRAIN_rx_eye_width_sweep_en_1),
    .o_curret_operating_speed                                       (o_curret_operating_speed_1)
);
/****************************************
* SIDEBAND
****************************************/
SB_TOP_WRAPPER SB_inst (
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
    .o_busy                   (sb_busy),
    .o_rx_sb_start_pattern    (module_rx_sb_start_pattern),
    .o_rdi_msg                (module_rdi_msg_out),
    .o_msg_valid              (module_msg_valid_out),
    .o_parity_error           (module_parity_error),
    .o_adapter_enable         (module_adapter_enable),
    .o_tx_point_sweep_test    (module_tx_point_sweep_test_out),
    .o_msg_no                 (sb_rx_msg_no),
    .o_msg_info               (module_msg_info_out),
    .o_data                   (module_data_out),
    .o_rdi_msg_code           (module_rdi_msg_code_out),
    .o_rdi_msg_sub_code       (module_rdi_msg_sub_code_out),
    .o_rdi_msg_info           (module_rdi_msg_info_out),
    .TXCKSB                   (module_txcksb),
    .TXDATASB                 (module_txdatasb)
);
/****************************************
* TX INITIATED D2C POINT TEST
****************************************/
tx_initiated_point_test_wrapper tx_d2c_pt_inst (
    .clk                                (i_clk),    
    .rst_n                              (i_rst_n),  
    /*------------------------------------------------------------------------------------------------------------
     * LTSM signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_en                               (tx_d2c_pt_en), 
    .i_mainband_or_valtrain_test        (tx_datatrain_or_valtrain), 
    .i_lfsr_or_perlane                  (tx_perlaneid_or_lfsr), 
    .o_test_ack                         (tx_d2c_pt_done),
    /*------------------------------------------------------------------------------------------------------------
     * SB signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_sideband_message                 (sb_rx_msg_no),
    .i_sideband_data                    (sb_rx_data_bus),
    .i_sideband_message_valid           (sb_rx_msg_valid),
    .i_busy                             (sb_busy),
    .o_sideband_message                 (sb_tx_msg_no_tx_d2c_pt),
    .o_valid                            (sb_tx_msg_valid_tx_d2c_pt),
    .o_sideband_data                    (sb_tx_data_bus_tx_d2c_pt),
    /*------------------------------------------------------------------------------------------------------------
     * LFSR TX signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_pattern_finished                 (lfsr_tx_pattern_done | val_tx_pattern_done), 
    .o_mainband_pattern_generator_cw    (mainband_pattern_generator_cw_tx_d2c_pt),
    /*------------------------------------------------------------------------------------------------------------
     * LFSR RX signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_comparison_results               (lfsr_rx_comparison_results),
    .o_mainband_pattern_compartor_cw    (mainband_pattern_comparator_cw_tx_d2c_pt),
    /*------------------------------------------------------------------------------------------------------------
     * VALID CONTROLLER signals
    ------------------------------------------------------------------------------------------------------------*/
    .o_val_pattern_en                   (val_pattern_en_tx_d2c_pt),
    .o_comparison_valid_en              (val_comparison_en_tx_d2c_pt),
    /*------------------------------------------------------------------------------------------------------------
     * ANALOG signals
    ------------------------------------------------------------------------------------------------------------*/    
    .i_reciever_ref_voltage             (o_reciever_ref_volatge),
);
/****************************************
* RX INITIATED D2C POINT TEST
****************************************/
rx_initiated_point_test_wrapper rx_d2c_pt_inst (
    .i_clk                              (i_clk),
    .i_rst_n                            (i_rst_n),
    /*------------------------------------------------------------------------------------------------------------
     * LTSM signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_rx_d2c_pt_en                     (rx_d2c_pt_en),
    .i_datavref_or_valvref              (rx_datavref_or_valvref),
    .o_comparison_result                (rx_d2c_pt_results),
    .o_rx_d2c_pt_done                   (rx_d2c_pt_done),
    /*------------------------------------------------------------------------------------------------------------
     * SB signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_SB_Busy                          (sb_busy),
    .i_rx_msg_valid                     (sb_rx_msg_valid),
    .i_decoded_SB_msg                   (sb_rx_msg_no),
    .o_encoded_SB_msg                   (sb_tx_msg_no_rx_d2c_pt),
    .o_tx_data_bus                      (sb_tx_data_bus_rx_d2c_pt),
    .o_tx_data_valid                    (sb_tx_data_valid_rx_d2c_pt),
    .o_tx_msg_valid                     (sb_tx_msg_valid_rx_d2c_pt),
    /*------------------------------------------------------------------------------------------------------------
     * LFSR TX signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_pattern_finished                 (lfsr_tx_pattern_done | val_tx_pattern_done),
    .o_mainband_pattern_generator_cw    (mainband_pattern_generator_cw_rx_d2c_pt),
    /*------------------------------------------------------------------------------------------------------------
     * LFSR RX signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_comparison_results               (lfsr_rx_comparison_results),
    .o_mainband_pattern_comparator_cw   (mainband_pattern_comparator_cw_rx_d2c_pt),
    /*------------------------------------------------------------------------------------------------------------
     * VALID CONTROLLER signals
    ------------------------------------------------------------------------------------------------------------*/
    .o_val_pattern_en                   (val_pattern_en_rx_d2c_pt),
    .o_comparison_valid_en              (val_comparison_en_rx_d2c_pt)
);
/****************************************
* LFSR TRANSMITTER
****************************************/
LFSR_Transmitter #(
    .WIDTH (SER_WIDTH) 
) LFSR_TX_inst (
    .i_clk                            (i_clk),                      
    .i_rst_n                          (i_rst_n),                   
    .i_state                          (mainband_pattern_generator_cw),                    
    .i_enable_scrambeling_pattern     (i_enable_scrambeling_pattern), // should be: pl_trdy & lp_valid & lp_irdy
    .i_functional_tx_lanes            (functional_tx_lanes),      
    .i_enable_reversal                (apply_reversal_en),          
    .i_lane_0                         (o_mapper_lane_0),
    .i_lane_1                         (o_mapper_lane_1),
    .i_lane_2                         (o_mapper_lane_2),
    .i_lane_3                         (o_mapper_lane_3),
    .i_lane_4                         (o_mapper_lane_4),
    .i_lane_5                         (o_mapper_lane_5),
    .i_lane_6                         (o_mapper_lane_6),
    .i_lane_7                         (o_mapper_lane_7),
    .i_lane_8                         (o_mapper_lane_8),
    .i_lane_9                         (o_mapper_lane_9),
    .i_lane_10                        (o_mapper_lane_10),
    .i_lane_11                        (o_mapper_lane_11),
    .i_lane_12                        (o_mapper_lane_12),
    .i_lane_13                        (o_mapper_lane_13),
    .i_lane_14                        (o_mapper_lane_14),
    .i_lane_15                        (o_mapper_lane_15),
    .o_lane_0                         (o_lfsr_tx_lane_0),
    .o_lane_1                         (o_lfsr_tx_lane_1),
    .o_lane_2                         (o_lfsr_tx_lane_2),
    .o_lane_3                         (o_lfsr_tx_lane_3),
    .o_lane_4                         (o_lfsr_tx_lane_4),
    .o_lane_5                         (o_lfsr_tx_lane_5),
    .o_lane_6                         (o_lfsr_tx_lane_6),
    .o_lane_7                         (o_lfsr_tx_lane_7),
    .o_lane_8                         (o_lfsr_tx_lane_8),
    .o_lane_9                         (o_lfsr_tx_lane_9),
    .o_lane_10                        (o_lfsr_tx_lane_10),
    .o_lane_11                        (o_lfsr_tx_lane_11),
    .o_lane_12                        (o_lfsr_tx_lane_12),
    .o_lane_13                        (o_lfsr_tx_lane_13),
    .o_lane_14                        (o_lfsr_tx_lane_14),
    .o_lane_15                        (o_lfsr_tx_lane_15),
    .o_Lfsr_tx_done                   (lfsr_tx_pattern_done),
    .o_enable_frame                   (o_serliazer_en) // serliazer enable (data & valid)
);
/****************************************
* LFSR RECEIVER
****************************************/
LFSR_Receiver #(
    .WIDTH (SER_WIDTH) 
) LFSR_RX_inst (
    .i_clk                            (i_clk),
    .i_rst_n                          (i_rst_n),
    .i_state                          (mainband_pattern_comparator_cw),
    .i_functional_rx_lanes            (functional_rx_lanes),
    .i_enable_Descrambeling_pattern   (i_deserliazer_valid & mapper_demapper_en),
    .i_enable_buffer                  (i_deserliazer_valid),
    .i_data_in_0                      (i_lfsr_rx_lane_0),
    .i_data_in_1                      (i_lfsr_rx_lane_1),
    .i_data_in_2                      (i_lfsr_rx_lane_2),
    .i_data_in_3                      (i_lfsr_rx_lane_3),
    .i_data_in_4                      (i_lfsr_rx_lane_4),
    .i_data_in_5                      (i_lfsr_rx_lane_5),
    .i_data_in_6                      (i_lfsr_rx_lane_6),
    .i_data_in_7                      (i_lfsr_rx_lane_7),
    .i_data_in_8                      (i_lfsr_rx_lane_8),
    .i_data_in_9                      (i_lfsr_rx_lane_9),
    .i_data_in_10                     (i_lfsr_rx_lane_10),
    .i_data_in_11                     (i_lfsr_rx_lane_11),
    .i_data_in_12                     (i_lfsr_rx_lane_12),
    .i_data_in_13                     (i_lfsr_rx_lane_13),
    .i_data_in_14                     (i_lfsr_rx_lane_14),
    .i_data_in_15                     (i_lfsr_rx_lane_15),
    .o_Data_by_0                      (o_lfsr_rx_bypass_0),
    .o_Data_by_1                      (o_lfsr_rx_bypass_1),
    .o_Data_by_2                      (o_lfsr_rx_bypass_2),
    .o_Data_by_3                      (o_lfsr_rx_bypass_3),
    .o_Data_by_4                      (o_lfsr_rx_bypass_4),
    .o_Data_by_5                      (o_lfsr_rx_bypass_5),
    .o_Data_by_6                      (o_lfsr_rx_bypass_6),
    .o_Data_by_7                      (o_lfsr_rx_bypass_7),
    .o_Data_by_8                      (o_lfsr_rx_bypass_8),
    .o_Data_by_9                      (o_lfsr_rx_bypass_9),
    .o_Data_by_10                     (o_lfsr_rx_bypass_10),
    .o_Data_by_11                     (o_lfsr_rx_bypass_11),
    .o_Data_by_12                     (o_lfsr_rx_bypass_12),
    .o_Data_by_13                     (o_lfsr_rx_bypass_13),
    .o_Data_by_14                     (o_lfsr_rx_bypass_14),
    .o_Data_by_15                     (o_lfsr_rx_bypass_15),
    .o_final_gene_0                   (o_lfsr_rx_final_gen_0),
    .o_final_gene_1                   (o_lfsr_rx_final_gen_1),
    .o_final_gene_2                   (o_lfsr_rx_final_gen_2),
    .o_final_gene_3                   (o_lfsr_rx_final_gen_3),
    .o_final_gene_4                   (o_lfsr_rx_final_gen_4),
    .o_final_gene_5                   (o_lfsr_rx_final_gen_5),
    .o_final_gene_6                   (o_lfsr_rx_final_gen_6),
    .o_final_gene_7                   (o_lfsr_rx_final_gen_7),
    .o_final_gene_8                   (o_lfsr_rx_final_gen_8),
    .o_final_gene_9                   (o_lfsr_rx_final_gen_9),
    .o_final_gene_10                  (o_lfsr_rx_final_gen_10),
    .o_final_gene_11                  (o_lfsr_rx_final_gen_11),
    .o_final_gene_12                  (o_lfsr_rx_final_gen_12),
    .o_final_gene_13                  (o_lfsr_rx_final_gen_13),
    .o_final_gene_14                  (o_lfsr_rx_final_gen_14),
    .o_final_gene_15                  (o_lfsr_rx_final_gen_15),
    .enable_pattern_comparitor        (enable_pattern_comparitor)
);
/****************************************
* LFSR COMPARATOR
****************************************/
pattern_comparator #(
    .WIDTH (SER_WIDTH)
) PATTERN_COMP_inst (
    .i_clk                            (i_clk),
    .i_rst_n                          (i_rst_n),
    .i_Type_comp                      (1'b1),
    .i_state                          (mainband_pattern_comparator_cw),
    .enable_pattern_comparitor        (enable_pattern_comparitor),
    .i_local_gen_0                    (o_lfsr_rx_final_gen_0),
    .i_local_gen_1                    (o_lfsr_rx_final_gen_1),
    .i_local_gen_2                    (o_lfsr_rx_final_gen_2),
    .i_local_gen_3                    (o_lfsr_rx_final_gen_3),
    .i_local_gen_4                    (o_lfsr_rx_final_gen_4),
    .i_local_gen_5                    (o_lfsr_rx_final_gen_5),
    .i_local_gen_6                    (o_lfsr_rx_final_gen_6),
    .i_local_gen_7                    (o_lfsr_rx_final_gen_7),
    .i_local_gen_8                    (o_lfsr_rx_final_gen_8),
    .i_local_gen_9                    (o_lfsr_rx_final_gen_9),
    .i_local_gen_10                   (o_lfsr_rx_final_gen_10),
    .i_local_gen_11                   (o_lfsr_rx_final_gen_11),
    .i_local_gen_12                   (o_lfsr_rx_final_gen_12),
    .i_local_gen_13                   (o_lfsr_rx_final_gen_13),
    .i_local_gen_14                   (o_lfsr_rx_final_gen_14),
    .i_local_gen_15                   (o_lfsr_rx_final_gen_15),
    .i_Data_by_0                      (o_lfsr_rx_bypass_0),
    .i_Data_by_1                      (o_lfsr_rx_bypass_1),
    .i_Data_by_2                      (o_lfsr_rx_bypass_2),
    .i_Data_by_3                      (o_lfsr_rx_bypass_3),
    .i_Data_by_4                      (o_lfsr_rx_bypass_4),
    .i_Data_by_5                      (o_lfsr_rx_bypass_5),
    .i_Data_by_6                      (o_lfsr_rx_bypass_6),
    .i_Data_by_7                      (o_lfsr_rx_bypass_7),
    .i_Data_by_8                      (o_lfsr_rx_bypass_8),
    .i_Data_by_9                      (o_lfsr_rx_bypass_9),
    .i_Data_by_10                     (o_lfsr_rx_bypass_10),
    .i_Data_by_11                     (o_lfsr_rx_bypass_11),
    .i_Data_by_12                     (o_lfsr_rx_bypass_12),
    .i_Data_by_13                     (o_lfsr_rx_bypass_13),
    .i_Data_by_14                     (o_lfsr_rx_bypass_14),
    .i_Data_by_15                     (o_lfsr_rx_bypass_15),
    .i_Max_error_Threshold_per_lane   (12'h001),  // to be edited
    .i_Max_error_Threshold_aggregate  (16'h0001), // to be edited
    .o_per_lane_error                 (lfsr_rx_comparison_results),
    .o_error_counter                  (aggregate_counter),
    .o_error_done                     (aggregate_error_found)
);
/****************************************
* VALID CONTROLLER
****************************************/
Valtrain_Controller VALTRAIN_CTRL_inst (
    .i_clk                 (i_clk),
    .i_rst_n               (i_rst_n),
    .Valid_pattern_enable  (val_pattern_en_rx_d2c_pt | val_pattern_en_tx_d2c_pt | val_pattern_en_ltsm),
    .valid_frame_enable    (valid_frame_enable), //????
    .TVLD_L                (o_TVLD_L), 
    .o_done                (val_tx_pattern_done),
    .enable_detector       (tx_enable_detector)
);
/****************************************
* VALID PATTERN DETECTOR
****************************************/
Pattern_valid_detector PATTERN_VALID_DET_inst (
    .i_clk               (i_clk),
    .i_rst_n             (i_rst_n),
    .RVLD_L              (i_RVLD_L),
    .error_threshold     (12'h001),
    .i_enable_cons       ((mainband_pattern_comparator_cw == 11)? 1:0),
    .i_enable_128        ((mainband_pattern_comparator_cw == 10)? 1:0),
    .i_enable_detector   (val_comparison_en_rx_d2c_pt | val_comparison_en_tx_d2c_pt),
    .detection_result    (tx_enable_detector),
    .o_valid_en          (o_valid_en)
);
/****************************************
* MAPPER
****************************************/
Byte_To_lane_mapping #(
    .WIDTH       (SER_WIDTH),         
    .N_BYTES     (1024),     
    .NUM_LANES   (16)          
) MAPPER_inst (
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .i_in_data              (i_lp_data),
    .enable_mapper          (mapper_demapper_en),
    .i_functional_tx_lanes  (functional_tx_lanes),
    .o_lane_0               (o_mapper_lane_0),
    .o_lane_1               (o_mapper_lane_1),
    .o_lane_2               (o_mapper_lane_2),
    .o_lane_3               (o_mapper_lane_3),
    .o_lane_4               (o_mapper_lane_4),
    .o_lane_5               (o_mapper_lane_5),
    .o_lane_6               (o_mapper_lane_6),
    .o_lane_7               (o_mapper_lane_7),
    .o_lane_8               (o_mapper_lane_8),
    .o_lane_9               (o_mapper_lane_9),
    .o_lane_10              (o_mapper_lane_10),
    .o_lane_11              (o_mapper_lane_11),
    .o_lane_12              (o_mapper_lane_12),
    .o_lane_13              (o_mapper_lane_13),
    .o_lane_14              (o_mapper_lane_14),
    .o_lane_15              (o_mapper_lane_15)
);
/****************************************
* DEMAPPER
****************************************/
Lane_To_Byte_Demapping #(
    .WIDTH       (SER_WIDTH),        
    .N_BYTES     (64),         
    .NUM_LANES   (16)          
) DEMAPPER_inst (
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .i_lane_0               (o_lfsr_rx_bypass_0),
    .i_lane_1               (o_lfsr_rx_bypass_1),
    .i_lane_2               (o_lfsr_rx_bypass_2),
    .i_lane_3               (o_lfsr_rx_bypass_3),
    .i_lane_4               (o_lfsr_rx_bypass_4),
    .i_lane_5               (o_lfsr_rx_bypass_5),
    .i_lane_6               (o_lfsr_rx_bypass_6),
    .i_lane_7               (o_lfsr_rx_bypass_7),
    .i_lane_8               (o_lfsr_rx_bypass_8),
    .i_lane_9               (o_lfsr_rx_bypass_9),
    .i_lane_10              (o_lfsr_rx_bypass_10),
    .i_lane_11              (o_lfsr_rx_bypass_11),
    .i_lane_12              (o_lfsr_rx_bypass_12),
    .i_lane_13              (o_lfsr_rx_bypass_13),
    .i_lane_14              (o_lfsr_rx_bypass_14),
    .i_lane_15              (o_lfsr_rx_bypass_15),
    .enable_demapper        (mapper_demapper_en),
    .i_functional_rx_lanes  (functional_rx_lanes),
    .o_out_data             (o_pl_data)
);
/****************************************
* CLOCK CONTROLLER
****************************************/
UCIe_Clock_Mode_Generator CLK_MODE_GEN_inst (
    .i_clk1                  (i_clk1),
    .i_clk2                  (i_clk2),
    .i_rst_n                 (i_rst_n),
    .i_valid                 (i_valid),
    .i_mode                  (i_mode),
    .i_state_indicator       (clk_tx_pattern_en),
    .CKP                     (o_CKP),
    .CKN                     (o_CKN),
    .Track                   (o_TRACK),
    .o_done                  (clk_tx_pattern_done),
    .enable_detector_CKP     (gen_enable_detector_CKP),
    .enable_detector_CKN     (gen_enable_detector_CKN),
    .enable_detector_Track   (gen_enable_detector_Track)
);
/****************************************
* CLOCK PATTERN DETECTOR
****************************************/
UCIe_Clock_Pattern_Detector CLK_PATTERN_DET_inst (
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .RCKP_L                 (RCKP_L),
    .RCKN_L                 (RCKN_L),
    .RTRK_L                 (RTRK_L),
    .enable_detector_CKP    (gen_enable_detector_CKP),
    .enable_detector_CKN    (gen_enable_detector_CKN),
    .enable_detector_Track  (gen_enable_detector_Track),
    .detect_RCKP            (detect_RCKP),
    .detect_RCKN            (detect_RCKN),
    .detect_RTRK            (detect_RTRK)
);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////// MUXING //////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*---------------------------------------
 * sideband tx message number muxing
---------------------------------------*/
always @ (*) begin
    case ({tx_d2c_pt_en,rx_d2c_pt_en})
        2'b01: sb_tx_msg_no = sb_tx_msg_no_rx_d2c_pt;
        2'b10: sb_tx_msg_no = sb_tx_msg_no_tx_d2c_pt;
        default: sb_tx_msg_no = sb_tx_msg_no_ltsm;
    endcase
end
/*---------------------------------------
 * sideband tx message valid muxing
---------------------------------------*/
always @ (*) begin
    case ({tx_d2c_pt_en,rx_d2c_pt_en})
        2'b01: sb_tx_msg_valid = sb_tx_msg_valid_rx_d2c_pt;
        2'b10: sb_tx_msg_valid = sb_tx_msg_valid_tx_d2c_pt;
        default: sb_tx_msg_valid = sb_tx_msg_valid_ltsm;
    endcase
end
/*---------------------------------------
 * sideband tx data valid muxing
---------------------------------------*/
always @ (*) begin
    case ({tx_d2c_pt_en,rx_d2c_pt_en})
        2'b01: sb_tx_data_valid = sb_tx_data_valid_rx_d2c_pt;
        2'b10: sb_tx_data_valid = sb_tx_data_valid_tx_d2c_pt;
        default: sb_tx_data_valid = sb_tx_data_valid_ltsm;
    endcase
end
/*---------------------------------------
 * mainband_pattern_generator_cw muxing
---------------------------------------*/
always @ (*) begin
    case ({tx_d2c_pt_en,rx_d2c_pt_en})
        2'b01: mainband_pattern_generator_cw = mainband_pattern_generator_cw_rx_d2c_pt;
        2'b10: mainband_pattern_generator_cw = mainband_pattern_generator_cw_tx_d2c_pt;
        default: mainband_pattern_generator_cw = mainband_pattern_generator_cw_ltsm;
    endcase
end
/*---------------------------------------
 * mainband_pattern_comparator_cw muxing
---------------------------------------*/
always @ (*) begin
    case ({tx_d2c_pt_en,rx_d2c_pt_en})
        2'b01: mainband_pattern_comparator_cw = mainband_pattern_comparator_cw_rx_d2c_pt;
        2'b10: mainband_pattern_comparator_cw = mainband_pattern_comparator_cw_tx_d2c_pt;
        default: mainband_pattern_comparator_cw = mainband_pattern_comparator_cw_ltsm;
    endcase
end
 


endmodule
