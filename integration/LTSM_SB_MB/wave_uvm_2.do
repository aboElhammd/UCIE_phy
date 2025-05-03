onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MODULE -group CLOCK_LANES_OUT /top/LTSM_SB_MB_inst_1/o_CKP
add wave -noupdate -expand -group MODULE -group CLOCK_LANES_OUT /top/LTSM_SB_MB_inst_1/o_CKN
add wave -noupdate -expand -group MODULE -group CLOCK_LANES_OUT /top/LTSM_SB_MB_inst_1/o_TRACK
add wave -noupdate -expand -group MODULE -expand -group VALID_LANE_IN /top/LTSM_SB_MB_inst_1/i_RVLD_L
add wave -noupdate -expand -group MODULE /top/LTSM_SB_MB_inst_1/i_deser_valid_val
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_0
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_1
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_2
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_3
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_4
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_5
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_6
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_7
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_8
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_9
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_10
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_11
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_12
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_13
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_14
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_15
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_deser_valid_data
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /top/LTSM_SB_MB_inst_1/i_deser_data_sb
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT -radix hexadecimal /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_0
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_1
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_2
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_3
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_4
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_5
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_6
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_7
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_8
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_9
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_10
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_11
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_12
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_13
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_14
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT -radix hexadecimal /top/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_15
add wave -noupdate -expand -group MODULE -expand -group VALID_LANE_OUT /top/LTSM_SB_MB_inst_1/o_TVLD_L
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/LTSM_SB_MB_inst_1/sync_sb_rx_msg_valid
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/i_rx_msg_no_string_1
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/LTSM_SB_MB_inst_1/sb_rx_data_bus
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/LTSM_SB_MB_inst_1/sb_rx_msg_info
add wave -noupdate -expand -group MODULE -expand -group LTSM -color Magenta /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/LTSM_SB_MB_inst_1/sync_sb_tx_msg_valid
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/LTSM_SB_MB_inst_1/sb_tx_msg_valid
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/o_tx_msg_no_string_1
add wave -noupdate -expand -group MODULE -expand -group LTSM -radix unsigned /top/LTSM_SB_MB_inst_1/sb_tx_msg_no
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/LTSM_SB_MB_inst_1/sb_tx_data_bus
add wave -noupdate -expand -group MODULE -expand -group LTSM -color {Cornflower Blue} /top/LTSM_SB_MB_inst_1/sb_tx_msg_info
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/sub_state_1
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/CS_top_1
add wave -noupdate -expand -group MODULE -expand -group LTSM /top/NS_top_1
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/CLK
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/rst_n
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/start_setup
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/i_Transmitter_initiated_Data_to_CLK_Result
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/o_Functional_Lanes
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/done_setup
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/CS
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/NS
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/CLK
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/rst_n
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_start_check
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_second_check
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_Functional_Lanes
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_done_check
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_go_to_repeat
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_go_to_train_error
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_continue
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CS
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/NS
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/o_Start_Repeater
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group TX /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_tx_inst/cs
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group TX /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_tx_inst/ns
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group RX /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_rx_inst/cs
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group RX /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_rx_inst/ns
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/clk
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/rst_n
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_mainband_or_valtrain_test
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_lfsr_or_perlane
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_message
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_data
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_busy
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_message_valid
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_comparison_results
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_message
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_valid
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_data
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_pattern_compartor_cw
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_test_ack
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_valid_result
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_lanes_result
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_clk
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rx_d2c_pt_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_datavref_or_valvref
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_comparison_results
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rx_msg_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_encoded_SB_msg
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_data_bus
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_data_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_rx_d2c_pt_done
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_comparison_result
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /top/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_mainband_pattern_comparator_cw
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/i_clk
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/Valid_pattern_enable
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/valid_frame_enable
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/o_done
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/enable_detector
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/o_TVLD_L
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /top/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/TVLD_L
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_clk
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/match0
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/match1
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/match2
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/match3
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 -radix unsigned /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/consec_counter
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/RVLD_L
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/error_threshold
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_enable_cons
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_enable_128
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 -color {Cornflower Blue} /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_enable_detector
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/detection_result
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/o_valid_frame_detect
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_enable_scrambeling_pattern
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_functional_tx_lanes
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_enable_reversal
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/o_Lfsr_tx_done
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /top/LTSM_SB_MB_inst_1/LFSR_TX_inst/o_enable_frame
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /top/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /top/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /top/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /top/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_functional_rx_lanes
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /top/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_enable_Descrambeling_pattern
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /top/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_enable_buffer
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /top/LTSM_SB_MB_inst_1/LFSR_RX_inst/enable_pattern_comparitor
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Type_comp
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/enable_pattern_comparitor
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 -color {Cornflower Blue} /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_0
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_1
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_2
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_3
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_4
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_5
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_6
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_7
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_8
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_9
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_10
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_11
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_12
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_13
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_14
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_15
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 -color {Cornflower Blue} /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_0
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_1
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_2
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_3
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_4
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_5
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_6
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_7
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_8
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_9
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_10
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_11
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_12
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_13
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_14
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_15
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Max_error_Threshold_per_lane
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Max_error_Threshold_aggregate
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 -radix binary /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/o_per_lane_error
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /top/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/o_error_done
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_clk
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rst_n
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_data_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_state
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_sub_state
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_no
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_info
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test_en
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_code
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_sub_code
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_info
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 -radix hexadecimal /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/o_header
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/o_header_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_code
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -expand -group SB_TX_HEADER_ENCODER_1 -radix binary /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_info
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_clk
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_rst_n
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_start_EN
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -radix hexadecimal /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_header
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test_en
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_msg_no
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_msg_info
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_dec_header_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/MsgCode
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/MsgSubCode
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/i_clk
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/i_rst_n
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/i_data_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/i_header_is_valid_on_bus
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/i_data
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/o_data_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/o_data
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/MsgCode
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -group data_decoder /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_data_decoder_dut/MsgSubCode
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_clk
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_rst_n
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_write_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_read_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_data_in
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_data_out
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_empty
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_ser_done_sampled
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_full
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FIFO /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/memory
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND /top/LTSM_SB_MB_inst_1/o_SBCLK
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND /top/LTSM_SB_MB_inst_1/o_sb_fifo_data
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/i_clk
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/i_rst_n
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/i_header
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/i_data
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/i_header_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/i_d_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/i_ser_done
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/o_framed_packet_phase
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/o_timeout_ctr_start
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/o_packet_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/total_header
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/cp
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/dp
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/cp_ready
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/dp_ready
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/msg_with_data
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/header_phase_sent
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/READY_TO_SEND_HEADER
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_Packet_Framing /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/packet_framing_dut/READY_TO_SEND_DATA
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_clk
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_rst_n
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_start_pattern_req
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_msg_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_data_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_d_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_header_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_packet_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_rx_sb_rsp_delivered
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/i_start_pattern_done
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_header_encoder_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_data_encoder_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_header_frame_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_data_frame_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_busy
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/cs
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/ns
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_pattern_enable_next
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_header_encoder_enable_next
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_data_encoder_enable_next
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_header_frame_enable_next
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_data_frame_enable_next
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group SB_TX_FSM /top/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/sb_fsm_dut/o_start_pattern_done_next
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_clk
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_rst_n
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_de_ser_done
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_header_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_rdi_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_data_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_deser_data
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/i_state
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_msg_valid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_header_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rdi_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_data_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_parity_error
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_adapter_enable
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_de_ser_done_sampled
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/ns
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_msg_valid_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_header_enable_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rdi_enable_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_data_enable_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_parity_error_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/o_adapter_enable_reg
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/MsgCode
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/MsgCode_part_2
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/dstid
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/opcode
add wave -noupdate -expand -group MODULE -expand -group SIDEBAND -group rx_fsm /top/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_fsm_dut/dp
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_clk
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_SBINIT_en
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_start_pattern_done
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_start_pattern_req
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_encoded_SB_msg
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_SBINIT_end
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/sync_sb_start_pattern_req
add wave -noupdate -expand -group MODULE -group SBINIT /top/LTSM_SB_MB_inst_1/sync_sb_start_pattern_done
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /top/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_fast_clock
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /top/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_slow_clock
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /top/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_fast_pulse
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /top/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/o_slow_pulse
add wave -noupdate -expand -group MODULE /top/LTSM_SB_MB_inst_1/i_rst_n
add wave -noupdate -expand -group MODULE /top/LTSM_SB_MB_inst_1/i_lp_data
add wave -noupdate -expand -group MODULE /top/LTSM_SB_MB_inst_1/i_start_training_RDI
add wave -noupdate -expand -group MODULE /top/LTSM_SB_MB_inst_1/o_pl_data
add wave -noupdate /top/CS_top_1
add wave -noupdate /top/NS_top_1
add wave -noupdate /top/sub_state_1
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/state_timeout
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/o_MBINIT_mainband_pattern_generator_cw
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/o_MBINIT_mainband_pattern_comparator_cw
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_data_tx
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_data_rx
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_comparison_results
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/cs
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/ns
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/cs
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/ns
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_sideband_message
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_phy_retrain_req_was_sent_or_received
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_error_req_was_sent_or_received
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/i_first_8_tx_lanes_are_functional
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/i_second_8_tx_lanes_are_functional
add wave -noupdate -group other /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/no_problem_in_tx_and_rx_lanes
add wave -noupdate -expand -group interface /top/sb_intf/clk
add wave -noupdate -expand -group interface -color {Dark Orchid} /top/i_rx_msg_no_string_1
add wave -noupdate -expand -group interface -color {Cornflower Blue} /top/sb_intf/deser_data
add wave -noupdate -expand -group interface -color Magenta /top/sb_intf/de_ser_done
add wave -noupdate -expand -group interface /top/sb_intf/de_ser_done_sampled
add wave -noupdate -expand -group interface /top/sb_intf/TXCKSB
add wave -noupdate -expand -group interface -color {Dark Orchid} /top/o_tx_msg_no_string_1
add wave -noupdate -expand -group interface -color {Cornflower Blue} /top/sb_intf/fifo_data_out
add wave -noupdate -expand -group interface /top/sb_intf/clk_ser_en
add wave -noupdate -expand -group interface /top/sb_intf/pack_finished
add wave -noupdate /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/U_TX_SBINIT/i_start_pattern_done
add wave -noupdate /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/U_TX_SBINIT/i_rx_msg_valid
add wave -noupdate /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/U_TX_SBINIT/o_encoded_SB_msg_tx
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/i_local_ckp
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/i_local_ckn
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/i_dig_clk
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/i_rst_n
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/i_start_clk_training
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/i_ltsm_in_reset
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/o_CKP
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/o_CKN
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/o_TRACK
add wave -noupdate -group CLK_GEN_1 /top/LTSM_SB_MB_inst_1/clock_generator_inst/o_done
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/i_dig_clk
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/i_half_pll_clk
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/i_rst_n
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/i_RCLK
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/i_start_clk_training
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/i_clear_results
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/o_result
add wave -noupdate -group CLK_DET_CKP_1 -color Magenta -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/iteration_counter
add wave -noupdate -group CLK_DET_CKP_1 -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/receiving_counter
add wave -noupdate -group CLK_DET_CKP_1 -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/local_counter
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/pattern_in_zeros_sync
add wave -noupdate -group CLK_DET_CKP_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckp_inst/pattern_in_zeros
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/i_dig_clk
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/i_half_pll_clk
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/i_rst_n
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/i_RCLK
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/i_start_clk_training
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/i_clear_results
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/o_result
add wave -noupdate -group CLK_DET_CKN_1 -color Magenta -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/iteration_counter
add wave -noupdate -group CLK_DET_CKN_1 -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/receiving_counter
add wave -noupdate -group CLK_DET_CKN_1 -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/local_counter
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/pattern_in_zeros_sync
add wave -noupdate -group CLK_DET_CKN_1 /top/LTSM_SB_MB_inst_1/clock_detector_ckn_inst/pattern_in_zeros
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/i_dig_clk
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/i_half_pll_clk
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/i_rst_n
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/i_RCLK
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/i_start_clk_training
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/i_clear_results
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/o_result
add wave -noupdate -group CLK_DET_TRK_1 -color Magenta -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/iteration_counter
add wave -noupdate -group CLK_DET_TRK_1 -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/receiving_counter
add wave -noupdate -group CLK_DET_TRK_1 -radix unsigned /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/local_counter
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/pattern_in_zeros_sync
add wave -noupdate -group CLK_DET_TRK_1 /top/LTSM_SB_MB_inst_1/clock_detector_trk_inst/pattern_in_zeros
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/MBINI_REPAIRCLK_init_req
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/MBINIT_REPAIRCLK_init_resp
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/MBINIT_REPAIRCLK_result_req
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/MBINIT_REPAIRCLK_result_resp
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/MBINIT_REPAIRCLK_done_req
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/MBINIT_REPAIRCLK_done_resp
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/IDLE
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_INIT_REQ
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/CLKPATTERN
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_RESULT_REQ
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_CHECK_RESULT
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_DONE_REQ
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_DONE
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_HANDLE_VALID
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_CHECK_BUSY_RESULT
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/REPAIRCLK_CHECK_BUSY_DONE
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/CLK
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/rst_n
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_MBINIT_CAL_end
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_CLK_Track_done
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_Rx_SbMessage
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_Busy_SideBand
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_msg_valid
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_falling_edge_busy
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_ValidOutDatat_ModulePartner
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/i_Clock_track_result_logged
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/o_train_error_req
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/o_MBINIT_REPAIRCLK_Pattern_En
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/o_MBINIT_REPAIRCLK_Module_end
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/o_TX_SbMessage
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/o_ValidOutDatat_Module
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/CS
add wave -noupdate -group MBINIT_REPEIRCLK_MODULE /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/RepairCLK_Wrapper_inst/u1/NS
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/CLK
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/rst_n
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/i_REPAIRCLK_end
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/i_VAL_Pattern_done
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/i_Rx_SbMessage
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/i_msg_valid
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/i_falling_edge_busy
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/i_VAL_Result_logged_RXSB
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/i_VAL_Result_logged_COMB
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/o_train_error_req
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/o_MBINIT_REPAIRVAL_Pattern_En
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/o_MBINIT_REPAIRVAL_end
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/o_TX_SbMessage
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/o_VAL_Result_logged
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/o_enable_cons
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/o_ValidOutDatatREPAIRVAL
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/train_error_req
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/MBINIT_REPAIRVAL_Pattern_En
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/MBINIT_REPAIRVAL_Module_end
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/MBINIT_REPAIRVAL_ModulePartner_end
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/TX_SbMessage_ModulePartner
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/TX_SbMessage_Module
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/ValidOutDatat_Module
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/VAL_Result_logged
add wave -noupdate -expand -group {MBINIT REPAIRVAL} /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRVAL_Wrapper_inst/ValidOutDatat_ModulePartner
add wave -noupdate /top/LTSM_SB_MB_inst_1/LTSM_TOP_inst/o_tx_data_bus
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28331875 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 102
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {28016304 ns} {28766109 ns}
