module LTSM_SB_MB #(
    parameter SER_WIDTH = 32
) (
    /*************************************************************************
    * INPUTS
    *************************************************************************/
    // clocks and resets 
    input                       i_pll_mb_clk,      // main pll clock
    input                       i_pll_sb_clk,      // sideband clock (800 MHz)
    input                       i_rst_n, 
    input                       i_RCKP,      // Received CKP
    input                       i_RCKN,      // Received CKN
    input                       i_RTRACK,    // Received TRACK
    // RDI 
    input       [8*63:0]        i_lp_data, 
    input                       i_start_training_RDI,
    // valid lane
    input       [SER_WIDTH-1:0] i_RVLD_L, 
    input                       i_deser_valid_val,  // a valid signal from valid deserilaizer
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
    input                       i_deser_valid_data, // data lane deserializer
    // sideband
    input       [63:0]          i_deser_data_sb, 
    input                       i_deser_done_sb,    // when sideband deserializer finishs deseriliazing
    /*************************************************************************
    * OUTPUTS
    *************************************************************************/
    // Clock lanes : CKP, CKN, TRACK
    output                      o_CKP,
    output                      o_CKN,
    output                      o_TRACK,
    // valid lane
    output      [SER_WIDTH-1:0] o_TVLD_L, 
    output                      o_serliazer_valid_en,
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
    output                      o_serliazer_data_en,
    // RDI 
    output       [8*63:0]       o_pl_data,
    // sideband
    output                      o_deser_done_sampled_sb, 
    output                      o_ser_done_sampled_sb,
    output                      o_pack_finished_sb,
    output                      o_clk_ser_en_sb,
    output                      o_SBCLK,
    output      [63:0]          o_sb_fifo_data,
    // communicating with analog domain
    output                      o_diff_or_quad_clk,
    output     [3:0]            o_reciever_ref_volatge,
    output     [3:0]            o_pi_step
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
wire aggregate_error_found;
wire enable_pattern_comparitor;
/****************************************
* TX D2C POINT TEST related signals
****************************************/
wire tx_d2c_pt_en;
wire tx_d2c_pt_done;
wire tx_datatrain_or_valtrain;
wire tx_d2c_pt_valid_result;
wire tx_perlaneid_or_lfsr;
wire val_pattern_en_tx_d2c_pt;
wire val_comparison_en_tx_d2c_pt;
wire [15:0] tx_d2c_pt_data_results;
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
// ORed
wire [3:0]  sb_tx_msg_no;
wire [3:0]  sb_tx_msg_no_ltsm;
wire [3:0]  sb_tx_msg_no_rx_d2c_pt;
wire [3:0]  sb_tx_msg_no_tx_d2c_pt;
// ORed
wire [15:0] sb_tx_data_bus;
wire [15:0] sb_tx_data_bus_ltsm;
wire [15:0] sb_tx_data_bus_rx_d2c_pt;
wire [15:0] sb_tx_data_bus_tx_d2c_pt;
// ORed 
wire sb_tx_msg_valid;
wire sb_tx_msg_valid_ltsm;
wire sb_tx_msg_valid_rx_d2c_pt;
wire sb_tx_msg_valid_tx_d2c_pt;
// ORed
wire sb_tx_data_valid;
wire sb_tx_data_valid_ltsm;
wire sb_tx_data_valid_rx_d2c_pt;
wire sb_tx_data_valid_tx_d2c_pt;
//ORed
wire [2:0] sb_tx_msg_info;
wire [2:0] sb_tx_msg_info_ltsm;
wire sb_tx_msg_info_tx_d2c_pt;

wire [3:0]  sb_tx_state;
wire [3:0]  sb_tx_sub_state;
wire [2:0]  sb_rx_msg_info;
wire [15:0] sb_rx_data_bus;
wire [3:0]  sb_rx_msg_no;
wire [1:0]  sb_d2c_training_type = (tx_d2c_pt_en)? 2'b00 : (rx_d2c_pt_en)? 2'b10 : 2'b00;
/****************************************
* LTSM related signals
****************************************/
wire ltsm_apply_reversal_en;
wire ltsm_val_pattern_en;
wire [3:0] ltsm_reciever_ref_volatge;
wire [1:0] ltsm_mainband_pattern_generator_cw;
wire [1:0] ltsm_mainband_pattern_comparator_cw;
wire [1:0] ltsm_functional_tx_lanes;
wire [1:0] ltsm_functional_rx_lanes;
wire ltsm_final_clk_mode;
wire ltsm_valid_consec_detect;
wire ltsm_clear_clk_results;
wire ltsm_clk_tx_pattern_en;
wire falling_edge_busy;
/****************************************
* VALID related signals
****************************************/
wire val_tx_pattern_done;
wire val_rx_comparison_result;
wire valid_frame_detect;
/****************************************
* CLOCK CONTROL related signals
****************************************/
wire clk_tx_pattern_done;
wire dig_clk ;
wire clk_result_ckp;
wire clk_result_ckn;
wire clk_result_trk;
//wire [2:0] clk_logged_results;
// wire w_enable_detector_CKP;
// wire w_enable_detector_CKN;
// wire w_enable_detector_Track;

/****************************************
* SYNCHRONIZERS related signals
****************************************/
wire sync_sb_start_pattern_req;
wire sync_sb_start_pattern_done;
wire sync_sb_rx_start_training;
wire sync_sb_tx_msg_valid;
wire sync_sb_rx_msg_valid;
wire sync_sb_fifo_empty;
wire sync_sb_time_out;
wire sync_sb_stop_cnt;
wire sync_sb_busy;
wire sync_sb_rst_n;
wire sync_mb_rst_n;
wire sync_mb_pll_rst_n;
wire sync_sb_pll_rst_n;
wire clock_local_ckp;
/****************************************
* RDI related signals
****************************************/
wire sb_rx_rdi_msg;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// INSTANTIATIONS ////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/****************************************
* LTSM TOP
****************************************/
LTSM_TOP LTSM_TOP_inst (
    .i_clk                                                          (dig_clk),
    .i_rst_n                                                        (sync_mb_rst_n),
    /*------------------------------------------------------------------------------------------------------------
     * RDI signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_start_training_RDI                                           (i_start_training_RDI),
    .i_go_to_phyretrain_ACTIVE                                      (1'b0), // to be edited
    .i_lp_linkerror                                                 (1'b0), // to be edited
    .i_LINKINIT_DONE                                                (1'b1), // to be edited
    .i_ACTIVE_DONE                                                  (1'b1), // to be edited
    /*------------------------------------------------------------------------------------------------------------
     * SB signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_SB_fifo_empty                                                (sync_sb_fifo_empty),
    .i_start_pattern_done                                           (sync_sb_start_pattern_done),
    .i_start_training_SB                                            (sync_sb_rx_start_training),
    .i_time_out                                                     (sync_sb_time_out),
    .i_busy                                                         (sync_sb_busy),
    .i_rx_msg_valid                                                 (sync_sb_rx_msg_valid),
    .i_decoded_SB_msg                                               (sb_rx_msg_no),
    .i_rx_msg_info                                                  (sb_rx_msg_info),
    .i_rx_data_bus                                                  (sb_rx_data_bus),
    .o_start_pattern_req                                            (sb_start_pattern_req),
    .o_tx_state                                                     (sb_tx_state),
    .o_tx_sub_state                                                 (sb_tx_sub_state),
    .o_encoded_SB_msg                                               (sb_tx_msg_no_ltsm),
    .o_tx_msg_info                                                  (sb_tx_msg_info_ltsm),
    .o_tx_data_bus                                                  (sb_tx_data_bus_ltsm),
    .o_tx_msg_valid                                                 (sb_tx_msg_valid_ltsm),
    .o_tx_data_valid                                                (sb_tx_data_valid_ltsm),
    .o_tx_rdi_msg_en                                                (sb_tx_rdi_msg_en),
    .o_MBTRAIN_timeout_disable                                      (sb_stop_cnt),
    /*------------------------------------------------------------------------------------------------------------
     * TX INITIATED D2C POINT TEST signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_Transmitter_initiated_Data_to_CLK_done                       (tx_d2c_pt_done),
    .i_Transmitter_initiated_Data_to_CLK_Result                     (tx_d2c_pt_data_results),
    .i_Transmitter_initiated_Data_to_CLK_valid_result               (tx_d2c_pt_valid_result),
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
    .o_MBINIT_mainband_pattern_generator_cw                         (ltsm_mainband_pattern_generator_cw),
    .o_MBINIT_REVERSALMB_ApplyReversal_En                           (ltsm_apply_reversal_en),
    /*------------------------------------------------------------------------------------------------------------
     * LFSR RX signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_comparsion_results                                           (lfsr_rx_comparison_results),
    .i_aggregate_error_found                                        (aggregate_error_found),
    .o_MBINIT_mainband_pattern_comparator_cw                        (ltsm_mainband_pattern_comparator_cw),
    /*------------------------------------------------------------------------------------------------------------
     * CLOCK CONTROLLER signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_CLK_Track_done                                               (clk_tx_pattern_done),
    .o_MBINIT_REPAIRCLK_Pattern_En                                  (ltsm_clk_tx_pattern_en),
    .o_MBINIT_Final_ClockMode                                       (ltsm_final_clk_mode),
    .o_MBINIT_Final_ClockPhase                                      (o_diff_or_quad_clk),
    /*------------------------------------------------------------------------------------------------------------
     * CLOCK PATTERN DETECTOR signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_logged_clk_result                                            ({clk_result_ckp,clk_result_ckn,clk_result_trk}),
    .o_MBINIT_clear_clk_detection                                   (ltsm_clear_clk_results),
    /*------------------------------------------------------------------------------------------------------------
     * VALID CONTROLLER signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_VAL_Pattern_done                                             (val_tx_pattern_done),
    .o_MBINIT_REPAIRVAL_Pattern_En                                  (ltsm_val_pattern_en),
    /*------------------------------------------------------------------------------------------------------------
     * VALID PATTERN DETECTOR signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_logged_val_result                                            (val_rx_comparison_result),
    .i_valid_framing_error                                          (valid_frame_detect),
    .o_MBINIT_enable_cons                                           (ltsm_valid_consec_detect),
    /*------------------------------------------------------------------------------------------------------------
     * MAPPER/DEMAPPER signals
    ------------------------------------------------------------------------------------------------------------*/ 
    .o_mapper_demapper_en                                           (mapper_demapper_en), 
    /*------------------------------------------------------------------------------------------------------------
     * OTHERS 
    ------------------------------------------------------------------------------------------------------------*/
    .i_start_training_DVSEC                                         (1'b0), // to be edited
    .o_reciever_ref_volatge                                         (o_reciever_ref_volatge),
    .o_functional_tx_lanes                                          (ltsm_functional_tx_lanes),
    .o_functional_rx_lanes                                          (ltsm_functional_rx_lanes),
    .o_MBTRAIN_tx_eye_width_sweep_en                                (o_MBTRAIN_tx_eye_width_sweep_en_1),
    .o_MBTRAIN_rx_eye_width_sweep_en                                (o_MBTRAIN_rx_eye_width_sweep_en_1),
    .o_curret_operating_speed                                       (o_curret_operating_speed_1),
    .o_falling_edge_busy                                            (falling_edge_busy)
);
/****************************************
* SIDEBAND
****************************************/
SB_TOP_WRAPPER SB_inst (
    .i_clk                      (i_pll_sb_clk),
    .i_divided_clk              (sb_divided_clk),
    .i_rst_n                    (sync_sb_rst_n),
    .i_start_pattern_req        (sync_sb_start_pattern_req), 
    .i_rdi_msg                  ('b0), // to be edited
    .i_data_valid               (sb_tx_data_valid),
    .i_msg_valid                (sync_sb_tx_msg_valid),
    .i_state                    (sb_tx_state),
    .i_sub_state                (sb_tx_sub_state),
    .i_msg_no                   (sb_tx_msg_no),
    .i_msg_info                 (sb_tx_msg_info),
    .i_data_bus                 (sb_tx_data_bus),
    .i_stop_cnt                 (sync_sb_stop_cnt),
    .i_tx_point_sweep_test_en   (tx_d2c_pt_en | rx_d2c_pt_en),
    .i_tx_point_sweep_test      (sb_d2c_training_type),
    .i_rdi_msg_code             ('b0), // to be edited
    .i_rdi_msg_sub_code         ('b0), // to be edited
    .i_rdi_msg_info             ('b0), // to be edited
    .i_de_ser_done              (i_deser_done_sb), 
    .i_deser_data               (i_deser_data_sb),
    .o_de_ser_done_sampled      (o_deser_done_sampled_sb),
    .o_start_pattern_done       (sb_start_pattern_done),
    .o_time_out                 (sb_time_out),
    .o_busy                     (sb_busy),
    .o_rx_sb_start_pattern      (sb_rx_start_training),
    .o_rdi_msg                  (sb_rx_rdi_msg), // to be edited
    .o_msg_valid                (sb_rx_msg_valid),
    .o_parity_error             (module_o_parity_error),           // NOT USED !!
    .o_adapter_enable           (module_o_adapter_enable),         // NOT USED !!
    .o_tx_point_sweep_test_en   (module_o_tx_point_sweep_test_en), // NOT USED !!
    .o_tx_point_sweep_test      (module_o_tx_point_sweep_test),    // NOT USED !!
    .o_msg_no                   (sb_rx_msg_no), 
    .o_msg_info                 (sb_rx_msg_info),
    .o_data                     (sb_rx_data_bus),
    .o_rdi_msg_code             (module_o_rdi_msg_code),        // to be edited
    .o_rdi_msg_sub_code         (module_o_rdi_msg_sub_code),    // to be edited
    .o_rdi_msg_info             (module_o_rdi_msg_info),        // to be edited
    .TXCKSB                     (o_SBCLK), 
    .o_fifo_data                (o_sb_fifo_data),
    .o_ser_done_sampled         (o_ser_done_sampled_sb),
    .o_pack_finished            (o_pack_finished_sb),
    .o_clk_ser_en               (o_clk_ser_en_sb),
    .o_fifo_empty               (sb_fifo_empty)
);
 
/****************************************
* TX INITIATED D2C POINT TEST
****************************************/
tx_initiated_point_test_wrapper tx_d2c_pt_inst (
    .clk                                (dig_clk),    
    .rst_n                              (sync_mb_rst_n),  
    /*------------------------------------------------------------------------------------------------------------
     * LTSM signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_en                               (tx_d2c_pt_en), 
    .i_mainband_or_valtrain_test        (tx_datatrain_or_valtrain), 
    .i_lfsr_or_perlane                  (tx_perlaneid_or_lfsr), 
    .i_falling_edge_busy                (falling_edge_busy),
    .o_valid_result                     (tx_d2c_pt_valid_result),    
    .o_mainband_lanes_result            (tx_d2c_pt_data_results),   
    .o_test_ack                         (tx_d2c_pt_done),
    /*------------------------------------------------------------------------------------------------------------
     * SB signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_sideband_message                 (sb_rx_msg_no),
    .i_sideband_data                    (sb_rx_data_bus),
    .i_sideband_message_valid           (sync_sb_rx_msg_valid),
    .i_busy                             (sync_sb_busy),
    .i_msg_info                         (sb_rx_msg_info[1]),
    .o_msg_info                         (sb_tx_msg_info_tx_d2c_pt),
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
    .i_valid_result                     (val_rx_comparison_result),
    .o_val_pattern_en                   (val_pattern_en_tx_d2c_pt),
    .o_comparison_valid_en              (val_comparison_en_tx_d2c_pt)
);
/****************************************
* RX INITIATED D2C POINT TEST
****************************************/
rx_initiated_point_test_wrapper rx_d2c_pt_inst (
    .i_clk                              (dig_clk),
    .i_rst_n                            (sync_mb_rst_n),
    /*------------------------------------------------------------------------------------------------------------
     * LTSM signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_rx_d2c_pt_en                     (rx_d2c_pt_en),
    .i_datavref_or_valvref              (rx_datavref_or_valvref),
    .i_falling_edge_busy                (falling_edge_busy),
    .o_comparison_result                (rx_d2c_pt_results),
    .o_rx_d2c_pt_done                   (rx_d2c_pt_done),
    /*------------------------------------------------------------------------------------------------------------
     * SB signals
    ------------------------------------------------------------------------------------------------------------*/
    .i_SB_Busy                          (sync_sb_busy),
    .i_rx_msg_valid                     (sync_sb_rx_msg_valid),
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
    .i_clk                            (dig_clk),                      
    .i_rst_n                          (sync_mb_rst_n),                   
    .i_state                          (mainband_pattern_generator_cw),                    
    .i_enable_scrambeling_pattern     (1'b0), // should be: pl_trdy & lp_valid & lp_irdy
    .i_functional_tx_lanes            (ltsm_functional_tx_lanes),      
    .i_enable_reversal                (ltsm_apply_reversal_en),          
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
    .o_enable_frame                   (o_serliazer_data_en) // this bit should be delayed one clock cycle to be aligned with o_serliazer_valid_en
);
/****************************************
* LFSR RECEIVER
****************************************/
LFSR_Receiver #(
    .WIDTH (SER_WIDTH) 
) LFSR_RX_inst (
    .i_clk                            (dig_clk),
    .i_rst_n                          (sync_mb_rst_n),
    .i_state                          (mainband_pattern_comparator_cw),
    .i_functional_rx_lanes            (ltsm_functional_rx_lanes),
    .i_enable_Descrambeling_pattern   (1'b0), // should be i_deser_valid_data & mapper_demapper_en
    .i_enable_buffer                  (i_deser_valid_data),
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
    .i_clk                            (dig_clk),
    .i_rst_n                          (sync_mb_rst_n),
    .i_Type_comp                      (1'b1), // 0h: aggregate comparison , 1h: per lane comparison
    .i_enable_buffer                  (i_deser_valid_data),
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
    .o_error_done                     (aggregate_error_found)
);
/****************************************
* VALID CONTROLLER
****************************************/
Valtrain_Controller VALTRAIN_CTRL_inst (
    .i_clk                 (dig_clk),
    .i_rst_n               (sync_mb_rst_n),
    .Valid_pattern_enable  (val_pattern_en_rx_d2c_pt | val_pattern_en_tx_d2c_pt | ltsm_val_pattern_en),
    .valid_frame_enable    (o_serliazer_data_en), 
    .o_TVLD_L              (o_TVLD_L), 
    .o_done                (val_tx_pattern_done),
    .enable_detector       (o_serliazer_valid_en) 
);
/****************************************
* VALID PATTERN DETECTOR
****************************************/
Pattern_valid_detector PATTERN_VALID_DET_inst (
    .i_clk               (dig_clk),
    .i_rst_n             (sync_mb_rst_n),
    .RVLD_L              (i_RVLD_L),
    .error_threshold     (12'h001),
    .i_enable_cons       (ltsm_valid_consec_detect & ~(val_comparison_en_rx_d2c_pt | val_comparison_en_tx_d2c_pt)), // ltsm_valid_consec_detect: ayman mkhliha dayman b 1'b1 so i made & ~(val_comparison_en_rx_d2c_pt | val_comparison_en_tx_d2c_pt)
    .i_enable_128        (val_comparison_en_rx_d2c_pt | val_comparison_en_tx_d2c_pt), 
    .i_enable_detector   (i_deser_valid_val),
    .detection_result    (val_rx_comparison_result),
    .o_valid_frame_detect(valid_frame_detect) // this signal detects if there is a valid framing error (should be connected to LTSM TOP)
);
/****************************************
* MAPPER
****************************************/
Byte_To_lane_mapping #(
    .WIDTH       (SER_WIDTH),         
    .N_BYTES     (1024),     
    .NUM_LANES   (16)          
) MAPPER_inst (
    .i_clk                  (dig_clk),
    .i_rst_n                (sync_mb_rst_n),
    .i_in_data              (i_lp_data),
    .enable_mapper          (mapper_demapper_en),
    .i_functional_tx_lanes  (ltsm_functional_tx_lanes),
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
    .i_clk                  (dig_clk),
    .i_rst_n                (sync_mb_rst_n),
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
    .enable_demapper        (~enable_pattern_comparitor),
    .i_functional_rx_lanes  (ltsm_functional_rx_lanes),
    .o_out_data             (o_pl_data)
);
/****************************************
* CLOCK GEN/COMP WRAPPER
****************************************/
clock_generator clock_generator_inst (
    .i_dig_clk              (dig_clk),
    .i_rst_n                (sync_mb_rst_n),
    .i_local_ckp            (clock_local_ckp), // half rate clock
    .i_local_ckn            (~clock_local_ckp),
    .i_pll_clk              (i_pll_mb_clk),
    .i_start_clk_training   (ltsm_clk_tx_pattern_en),
    .i_ltsm_in_reset        (~|sb_tx_state),
    .o_CKP                  (o_CKP),
    .o_CKN                  (o_CKN),
    .o_TRACK                (o_TRACK),
    .o_done                 (clk_tx_pattern_done)
);
clock_detector clock_detector_ckp_inst (
    .i_dig_clk                      (dig_clk),
    .i_half_pll_clk                 (clock_local_ckp),
    .i_rst_n                        (sync_mb_rst_n),
    .i_RCLK                         (i_RCKP),
    .i_start_clk_training           (ltsm_clk_tx_pattern_en),
    .i_clear_results                (ltsm_clear_clk_results),
    .o_result                       (clk_result_ckp)
);
clock_detector clock_detector_ckn_inst (
    .i_dig_clk                      (dig_clk),
    .i_half_pll_clk                 (~clock_local_ckp),
    .i_rst_n                        (sync_mb_rst_n),
    .i_RCLK                         (i_RCKN),
    .i_start_clk_training           (ltsm_clk_tx_pattern_en),
    .i_clear_results                (ltsm_clear_clk_results),
    .o_result                       (clk_result_ckn)
);
clock_detector clock_detector_trk_inst (
    .i_dig_clk                      (dig_clk),
    .i_half_pll_clk                 (clock_local_ckp),
    .i_rst_n                        (sync_mb_rst_n),
    .i_RCLK                         (i_RTRACK),
    .i_start_clk_training           (ltsm_clk_tx_pattern_en),
    .i_clear_results                (ltsm_clear_clk_results),
    .o_result                       (clk_result_trk)
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////// CLOCK DIVIDERS ///////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/****************************************
* SIDEBAND CLOCK DIVIDER
****************************************/
Clock_Divider_by_8 sb_clk_div_inst (
    .i_pll_clk      (i_pll_sb_clk),
    .i_rst_n        (sync_sb_pll_rst_n),
    .o_divided_clk  (sb_divided_clk)
);
/****************************************
* MAINBAND CLOCK DIVIDER
****************************************/
clock_div_32 clock_div_32_inst_1 (
    .i_clk             (i_pll_mb_clk),
    .i_rst_n           (sync_mb_pll_rst_n),
    .o_div_clk         (dig_clk)
);  
/****************************************
* LOCAL CKP/CKN CLOCK DIVIDER
****************************************/
clock_div_2 clock_div_2_inst (
    .i_clk             (i_pll_mb_clk),
    .i_rst_n           (sync_mb_rst_n),
    .o_div_clk         (clock_local_ckp)
);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////// SYNCHRONIZERS ///////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*****************************************
* LTSM --> SB SYNCHRONIZERS (FAST -> SLOW)
*****************************************/
pulse_synchronizer SBINIT_start_pattern_req_sync_inst (
    .i_slow_clock       (sb_divided_clk),
    .i_fast_clock       (dig_clk),
    .i_slow_rst_n       (sync_sb_rst_n),
    .i_fast_rst_n       (sync_mb_rst_n),
    .i_fast_pulse       (sb_start_pattern_req),
    .o_slow_pulse       (sync_sb_start_pattern_req)
);

bit_synchronizer sb_tx_msg_valid_sync_inst (
    .i_clk      (sb_divided_clk),
    .i_rst_n    (sync_sb_rst_n),
    .i_data_in  (sb_tx_msg_valid),
    .o_data_out (sync_sb_tx_msg_valid)
);

pulse_synchronizer stop_timeout_count_sync_inst (
    .i_slow_clock       (sb_divided_clk),
    .i_fast_clock       (dig_clk),
    .i_slow_rst_n       (sync_sb_rst_n),
    .i_fast_rst_n       (sync_mb_rst_n),
    .i_fast_pulse       (sb_stop_cnt),
    .o_slow_pulse       (sync_sb_stop_cnt)
);
/****************************************
* SB --> LTSM SYNCHRONIZERS (SLOW -> FAST)
****************************************/
bit_synchronizer SBINIT_start_pattern_done_sync_inst (
    .i_clk      (dig_clk),
    .i_rst_n    (sync_mb_rst_n),
    .i_data_in  (sb_start_pattern_done),
    .o_data_out (sync_sb_start_pattern_done)
);

bit_synchronizer SB_start_training_sync_inst (
    .i_clk      (dig_clk),
    .i_rst_n    (sync_mb_rst_n),
    .i_data_in  (sb_rx_start_training),
    .o_data_out (sync_sb_rx_start_training)
);

bit_synchronizer SB_fifo_empty_sync_inst (
    .i_clk      (dig_clk),
    .i_rst_n    (sync_mb_rst_n),
    .i_data_in  (sb_fifo_empty),
    .o_data_out (sync_sb_fifo_empty)
);

bit_synchronizer SB_timeout_sync_inst (
    .i_clk      (dig_clk),
    .i_rst_n    (sync_mb_rst_n),
    .i_data_in  (sb_time_out),
    .o_data_out (sync_sb_time_out)
);

bit_synchronizer SB_busy_sync_inst (
    .i_clk      (dig_clk),
    .i_rst_n    (sync_mb_rst_n),
    .i_data_in  (sb_busy),
    .o_data_out (sync_sb_busy)
);

bit_synchronizer SB_rx_msg_valid_sync_inst (
    .i_clk      (dig_clk),
    .i_rst_n    (sync_mb_rst_n),
    .i_data_in  (sb_rx_msg_valid),
    .o_data_out (sync_sb_rx_msg_valid)
);
/****************************************
* RESET SYNCHRONIZERS
****************************************/
// Mainband (dig clock)
bit_synchronizer bit_synchronizer_mainband_digclk (
    .i_clk      (dig_clk), // all mainband resets synchronized with the slowest clock (pll_clk/32)
    .i_rst_n    (i_rst_n),
    .i_data_in  (1'b1),
    .o_data_out (sync_mb_rst_n)
);
//////////////////////////////////////////////////////////////////////////////////////////////////////
 /* the synchronizer below used to just synchronize the reset for the dig_clk generator block which //
   is the clock_div_32 since all other blocks resets is synchronized with this dig_clk so how can   //
   we synchronize the reset with dig_clk if the dig_clk generator is not working yet ? .. so the    //
   generator of the dig clock should be reseted synchronosly with the pll_clk                       //
   -----------------------------------------------------------------------------------------------  //
 * after generating the dig clock while the reset is already deasserted many clock cycles earlier   //
   the 1'b1 in the reset synchronizer can now propagate and de-asserts reset in all other blocks    //
   working with dig_clk */                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Mainband (pll clock)
bit_synchronizer bit_synchronizer_mainband_pllclk (
    .i_clk      (i_pll_mb_clk), // all mainband resets synchronized with the slowest clock (pll_clk/32)
    .i_rst_n    (i_rst_n),
    .i_data_in  (1'b1),
    .o_data_out (sync_mb_pll_rst_n)
);
// Sideband 
bit_synchronizer bit_synchronizer_sideband (
    .i_clk      (sb_divided_clk), 
    .i_rst_n    (i_rst_n),
    .i_data_in  (1'b1),
    .o_data_out (sync_sb_rst_n)
);
// Sideband (pll clock) ... this reset used only in sideband clock divider for the same reason above
bit_synchronizer bit_synchronizer_sideband_pllclk (
    .i_clk      (i_pll_sb_clk), 
    .i_rst_n    (i_rst_n),
    .i_data_in  (1'b1),
    .o_data_out (sync_sb_pll_rst_n)
);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////// ORing ///////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*---------------------------------------
 * sideband tx message number Oring
---------------------------------------*/
assign sb_tx_msg_no = sb_tx_msg_no_ltsm | sb_tx_msg_no_tx_d2c_pt | sb_tx_msg_no_rx_d2c_pt;
/*---------------------------------------
 * sideband tx message info Oring
---------------------------------------*/
assign sb_tx_msg_info = {sb_tx_msg_info_ltsm[2], (sb_tx_msg_info_ltsm[1]  | sb_tx_msg_info_tx_d2c_pt), sb_tx_msg_info_ltsm[0]}; // 34an el tx d2c pt haytl3 1 bit msg info w 3ayzeen el bus sa3tha ykun kdh 3'b010 or 3'b000
/*---------------------------------------
 * sideband tx data bus Oring
---------------------------------------*/
assign sb_tx_data_bus = sb_tx_data_bus_ltsm | sb_tx_data_bus_rx_d2c_pt | sb_tx_data_bus_tx_d2c_pt;
/*---------------------------------------
 * sideband tx message valid Oring
---------------------------------------*/
assign sb_tx_msg_valid = sb_tx_msg_valid_ltsm | sb_tx_msg_valid_rx_d2c_pt | sb_tx_msg_valid_tx_d2c_pt;
/*---------------------------------------
 * sideband tx data valid Oring
---------------------------------------*/
assign sb_tx_data_valid = sb_tx_data_valid_ltsm | sb_tx_data_valid_rx_d2c_pt;// | sb_tx_data_valid_tx_d2c_pt;
/*---------------------------------------
 * mainband_pattern_generator_cw ORing
---------------------------------------*/
assign mainband_pattern_generator_cw = ltsm_mainband_pattern_generator_cw | mainband_pattern_generator_cw_tx_d2c_pt | mainband_pattern_generator_cw_rx_d2c_pt;
/*---------------------------------------
 * mainband_pattern_comparator_cw ORing
---------------------------------------*/
assign mainband_pattern_comparator_cw = ltsm_mainband_pattern_comparator_cw | mainband_pattern_comparator_cw_tx_d2c_pt | mainband_pattern_comparator_cw_rx_d2c_pt;

 


endmodule