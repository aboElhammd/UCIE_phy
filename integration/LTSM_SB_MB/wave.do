onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/dig_clk
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_clk_sb
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_ckp
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_ckn
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_rst_n
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lp_data
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_start_training_RDI
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_deser_valid_val
add wave -noupdate -expand -group MODULE -group CLOCK_lANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_CKP
add wave -noupdate -expand -group MODULE -group CLOCK_lANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_CKN
add wave -noupdate -expand -group MODULE -group CLOCK_lANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_TRACK
add wave -noupdate -expand -group MODULE -group CLOCK_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_CKP
add wave -noupdate -expand -group MODULE -group CLOCK_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_CKN
add wave -noupdate -expand -group MODULE -group CLOCK_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_TRACK
add wave -noupdate -expand -group MODULE -group VALID_LANE_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_RVLD_L
add wave -noupdate -expand -group MODULE -group VALID_LANE_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_RVLD_L
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_0
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_1
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_2
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_3
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_4
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_5
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_6
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_7
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_8
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_9
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_10
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_11
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_12
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_13
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_14
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_lfsr_rx_lane_15
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_deser_valid_data
add wave -noupdate -expand -group MODULE -group DATA_LANES_IN /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/i_deser_data_sb
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT -radix hexadecimal /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_15
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_14
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_13
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_12
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_11
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_10
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_9
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_8
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_7
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_6
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_5
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_4
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_3
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_2
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_1
add wave -noupdate -expand -group MODULE -group DATA_LANES_OUT -radix hexadecimal /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_lfsr_tx_lane_0
add wave -noupdate -expand -group MODULE -expand -group VALID_LANE_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_TVLD_L
add wave -noupdate -expand -group MODULE -expand -group VALID_LANE_OUT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_TVLD_L
add wave -noupdate -expand -group MODULE /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_pl_data
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/i_clk
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sync_sb_rx_msg_valid
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/i_rx_msg_no_string_1
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sb_rx_data_bus
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sb_rx_msg_info
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sb_tx_msg_valid
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sb_tx_data_valid
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/o_tx_msg_no_string_1
add wave -noupdate -expand -group MODULE -expand -group LTSM -radix unsigned /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sb_tx_msg_no
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sb_tx_data_bus
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sb_tx_msg_info
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/sub_state_1
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/CS_top_1
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/NS_top_1
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/i_time_out
add wave -noupdate -expand -group MODULE -expand -group LTSM /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/state_timeout
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/CLK
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/rst_n
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/start_setup
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/i_Transmitter_initiated_Data_to_CLK_Result
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/o_Functional_Lanes
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/Functional_Lane_Setup_inst/done_setup
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/w_Functional_Lanes
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/CS
add wave -noupdate -expand -group MODULE -group REPAIRMB_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_inst/NS
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/CLK
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/rst_n
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_start_check
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_second_check
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_Functional_Lanes
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_done_check
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_go_to_repeat
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_go_to_train_error
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_continue
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CS
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/NS
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/o_Start_Repeater
add wave -noupdate -expand -group MODULE -group REPAIRMB_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/MBINIT_inst/REPAIRMB_Wrapper_inst/o_train_error
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/clk
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/rst_n
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_mainband_or_valtrain_test
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_lfsr_or_perlane
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_message
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_data
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_busy
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_message_valid
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_comparison_results
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_message
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_valid
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_data
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_pattern_compartor_cw
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_test_ack
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_valid_result
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_lanes_result
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group TX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_tx_inst/cs
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group TX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_tx_inst/ns
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group TX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_tx_inst/cs
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group TX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_tx_inst/ns
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group RX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_rx_inst/cs
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group RX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_rx_inst/ns
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group RX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_rx_inst/cs
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 -group RX /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/tx_initiated_point_test_rx_inst/ns
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/clk
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/rst_n
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_mainband_or_valtrain_test
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_lfsr_or_perlane
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_message
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_data
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_busy
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_sideband_message_valid
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/i_comparison_results
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_message
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_valid
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_sideband_data
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_pattern_compartor_cw
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_test_ack
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_valid_result
add wave -noupdate -expand -group MODULE -group TX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/tx_d2c_pt_inst/o_mainband_lanes_result
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_clk
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rx_d2c_pt_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_datavref_or_valvref
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_comparison_results
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rx_msg_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_encoded_SB_msg
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_data_bus
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_data_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_rx_d2c_pt_done
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_comparison_result
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_mainband_pattern_comparator_cw
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_clk
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rx_d2c_pt_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_datavref_or_valvref
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_comparison_results
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_rx_msg_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_encoded_SB_msg
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_data_bus
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_tx_data_valid
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_rx_d2c_pt_done
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_comparison_result
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -group RX_D2C_PT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/rx_d2c_pt_inst/o_mainband_pattern_comparator_cw
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/i_clk
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/Valid_pattern_enable
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/valid_frame_enable
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/o_done
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/enable_detector
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/o_TVLD_L
add wave -noupdate -expand -group MODULE -group VAL_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/VALTRAIN_CTRL_inst/TVLD_L
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_clk
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/RVLD_L
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/error_threshold
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_enable_cons
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_enable_128
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 -color {Lime Green} /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/i_enable_detector
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/detection_result
add wave -noupdate -expand -group MODULE -group VAL_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_VALID_DET_inst/o_valid_frame_detect
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/i_clk1
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/i_clk2
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/i_rst_n
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/i_valid
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/i_mode
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/i_state_indicator
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/CKP
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/CKN
add wave -noupdate -expand -group MODULE -group CLK_GEN_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_gen/o_done
add wave -noupdate -expand -group MODULE -group CLK_DETECT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_det/i_clk
add wave -noupdate -expand -group MODULE -group CLK_DETECT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_det/i_rst_n
add wave -noupdate -expand -group MODULE -group CLK_DETECT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_det/RCKP_L
add wave -noupdate -expand -group MODULE -group CLK_DETECT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_det/RCKN_L
add wave -noupdate -expand -group MODULE -group CLK_DETECT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_det/clear_out
add wave -noupdate -expand -group MODULE -group CLK_DETECT_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/clock_det/o_Clock_track_result_logged
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_enable_scrambeling_pattern
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_functional_tx_lanes
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/i_enable_reversal
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/o_Lfsr_tx_done
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/counter_lfsr
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 -radix unsigned /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/counter_per_lane
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/o_enable_frame
add wave -noupdate -expand -group MODULE -group LFSR_TX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_TX_inst/current_state
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_functional_rx_lanes
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_enable_Descrambeling_pattern
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_enable_buffer
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/enable_pattern_comparitor
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_functional_rx_lanes
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_enable_Descrambeling_pattern
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/i_enable_buffer
add wave -noupdate -expand -group MODULE -group LFSR_RX_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LFSR_RX_inst/enable_pattern_comparitor
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Type_comp
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/enable_pattern_comparitor
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_0
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_1
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_2
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_3
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_4
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_5
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_6
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_7
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_8
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_9
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_10
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_11
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_12
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_13
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_14
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_15
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_0
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_1
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_2
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_3
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_4
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_5
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_6
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_7
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_8
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_9
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_10
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_11
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_12
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_13
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_14
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_15
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Max_error_Threshold_per_lane
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Max_error_Threshold_aggregate
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 -radix binary /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/o_per_lane_error
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/o_error_done
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_clk
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Type_comp
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_state
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/enable_pattern_comparitor
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_0
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_1
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_2
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_3
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_4
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_5
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_6
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_7
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_8
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_9
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_10
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_11
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_12
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_13
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_14
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_local_gen_15
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_0
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_1
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_2
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_3
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_4
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_5
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_6
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_7
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_8
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_9
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_10
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_11
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_12
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_13
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_14
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Data_by_15
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Max_error_Threshold_per_lane
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/i_Max_error_Threshold_aggregate
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 -radix binary /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/o_per_lane_error
add wave -noupdate -expand -group MODULE -group LFSR_COMP_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/PATTERN_COMP_inst/o_error_done
add wave -noupdate -expand -group MODULE -group SIDEBAND /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_SBCLK
add wave -noupdate -expand -group MODULE -group SIDEBAND /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_sb_fifo_data
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_data_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_state
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_sub_state
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_no
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test_en
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_sub_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 -radix hexadecimal /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/o_header
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/o_header_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code_reg
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 -radix binary /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/STATE_TRANSITIONED
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/RESET_MSG_SUBCODE_COUNTER
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/INCREMENT_MSG_SUBCODE_COUNTER
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code_saved_before_tests
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test_en_reg
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/header_members_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_data_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_state
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_sub_state
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_no
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test_en
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_sub_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 -radix hexadecimal /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/o_header
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/o_header_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code_reg
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 -radix binary /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/STATE_TRANSITIONED
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/RESET_MSG_SUBCODE_COUNTER
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/INCREMENT_MSG_SUBCODE_COUNTER
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code_saved_before_tests
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test_en_reg
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_HEADER_ENCODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/header_encoder_dut/header_members_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_start_EN
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -radix hexadecimal /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_header
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test_en
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_msg_no
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_dec_header_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/MsgCode
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/MsgSubCode
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_start_EN
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 -radix hexadecimal /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/i_header
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test_en
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_msg_no
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_msg_info
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/o_dec_header_valid
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/MsgCode
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_RX_HEADER_DECODER_1 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/rx_wrapper/rx_header_decoder_dut/MsgSubCode
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_write_enable
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_read_enable
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_data_in
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_data_out
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_empty
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_ser_done_sampled
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_full
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/memory
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_write_enable
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_read_enable
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/i_data_in
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_data_out
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_empty
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_ser_done_sampled
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/o_full
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_TX_FIFO /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SB_inst/tx_wrapper/tx_fifo_dut/memory
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_pll_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_data_in
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_enable
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_pack_finished
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/TXDATASB
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_pll_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_data_in
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_enable
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/i_pack_finished
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_SER_1 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_1/TXDATASB
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/ser_data_in
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_clk_pll
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_de_ser_done_sampled
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/par_data_out
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/de_ser_done
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_clk
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/ser_data_in
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_clk_pll
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_rst_n
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/i_de_ser_done_sampled
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/par_data_out
add wave -noupdate -expand -group MODULE -group SIDEBAND -group SB_DESER_1 /TB_LTSM_SB_MB/SB_RX_DESER_inst_1/de_ser_done
add wave -noupdate -expand -group MODULE -group SIDEBAND /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_SBCLK
add wave -noupdate -expand -group MODULE -group SIDEBAND /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/i_time_out
add wave -noupdate -expand -group MODULE -group SIDEBAND /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_sb_fifo_data
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_clk
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_SBINIT_en
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_start_pattern_done
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_start_pattern_req
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_encoded_SB_msg
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_SBINIT_end
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sync_sb_start_pattern_req
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sync_sb_start_pattern_done
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_clk
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_SBINIT_en
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_start_pattern_done
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/i_decoded_SB_msg
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_start_pattern_req
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_encoded_SB_msg
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/LTSM_TOP_inst/SBINIT_inst/o_SBINIT_end
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sync_sb_start_pattern_req
add wave -noupdate -expand -group MODULE -group SBINIT /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/sync_sb_start_pattern_done
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_fast_clock
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_slow_clock
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_fast_pulse
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/o_slow_pulse
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_fast_clock
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_slow_clock
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_rst_n
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/i_fast_pulse
add wave -noupdate -expand -group MODULE -group start_pattern_req_synchronizer /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/SBINIT_start_pattern_req_sync_inst/o_slow_pulse
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LTSM_TOP_inst/i_clk
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_msg_valid
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_msg_no
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/i_rx_msg_no_string_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_data_bus
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_msg_info
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LTSM_TOP_inst/i_busy
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_msg_valid
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/o_tx_msg_no_string_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_msg_no
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_data_bus
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_msg_info
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_data_valid
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/sub_state_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/CS_top_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/NS_top_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_start_training
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LTSM_TOP_inst/o_functional_tx_lanes
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LTSM_TOP_inst/o_functional_rx_lanes
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sync_sb_rx_start_training
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_0
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_1
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_2
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_3
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_4
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_5
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_6
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_7
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_8
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_9
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_10
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_11
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_12
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_13
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_14
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_15
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_0
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_1
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_2
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_3
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_4
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_5
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_6
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_7
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_8
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_9
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_10
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_11
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_12
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_13
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_14
add wave -noupdate -expand -group PARTNER -group DATA_LANES_IN_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/i_lfsr_rx_lane_15
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_0
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_1
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_2
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_3
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_4
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_5
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_6
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_7
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_8
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_9
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_10
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_11
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_12
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_13
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_14
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_15
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_0
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_1
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_2
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_3
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_4
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_5
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_6
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_7
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_8
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_9
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_10
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_11
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_12
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_13
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_14
add wave -noupdate -expand -group PARTNER -group DATA_LANES_OUT_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/o_lfsr_tx_lane_15
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_clk
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_rst_n
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_state
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_functional_tx_lanes
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_enable_reversal
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_0
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_1
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_2
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_3
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_4
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_5
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_6
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_7
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_8
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_9
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_10
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_11
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_12
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_13
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_14
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_15
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_Lfsr_tx_done
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_enable_frame
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_clk
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_rst_n
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_state
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_functional_tx_lanes
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/i_enable_reversal
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_0
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_1
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_2
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_3
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_4
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_5
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_6
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_7
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_8
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_9
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_10
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_11
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_12
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_13
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_14
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_lane_15
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_Lfsr_tx_done
add wave -noupdate -expand -group PARTNER -group LFSR_TX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_TX_inst/o_enable_frame
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_clk
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_rst_n
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Type_comp
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_state
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_0
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_1
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_2
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_3
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_4
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_5
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_6
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_7
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_8
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_9
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_10
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_11
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_12
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_13
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_14
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_15
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_0
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_1
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_2
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_3
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_4
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_5
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_6
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_7
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_8
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_9
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_10
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_11
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_12
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_13
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_14
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_15
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Max_error_Threshold_per_lane
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Max_error_Threshold_aggregate
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/o_per_lane_error
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/o_per_lane_error_reg
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/enable_pattern_comparitor
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_enable_buffer
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/o_error_done
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_clk
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_rst_n
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Type_comp
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_state
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_0
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_1
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_2
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_3
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_4
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_5
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_6
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_7
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_8
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_9
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_10
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_11
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_12
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_13
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_14
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_local_gen_15
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_0
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_1
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_2
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_3
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_4
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_5
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_6
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_7
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_8
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_9
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_10
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_11
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_12
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_13
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_14
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Data_by_15
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Max_error_Threshold_per_lane
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_Max_error_Threshold_aggregate
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/o_per_lane_error
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/o_per_lane_error_reg
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/enable_pattern_comparitor
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/i_enable_buffer
add wave -noupdate -expand -group PARTNER -group LFSR_COMP_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/PATTERN_COMP_inst/o_error_done
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_clk
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_rst_n
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_state
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_functional_rx_lanes
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_enable_buffer
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/enable_pattern_comparitor
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/delay_counter
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/cont
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_clk
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_rst_n
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_state
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_functional_rx_lanes
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/i_enable_buffer
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/enable_pattern_comparitor
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/delay_counter
add wave -noupdate -expand -group PARTNER -group LFSR_RX_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LFSR_RX_inst/cont
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_clk
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_msg_valid
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_data_valid
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_state
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_sub_state
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_msg_no
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_msg_info
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test_en
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_code
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_sub_code
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_info
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/o_header
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/o_header_valid
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/msg_code
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_clk
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_msg_valid
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_data_valid
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_state
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_sub_state
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_msg_no
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_msg_info
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test_en
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_tx_point_sweep_test
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_code
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_sub_code
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/i_rdi_msg_info
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/o_header
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/o_header_valid
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/msg_code
add wave -noupdate -expand -group PARTNER -group SB_TX_HEADER_ENCODER_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/tx_wrapper/header_encoder_dut/msg_sub_code
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_pll_clk
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_data_in
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_enable
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_pack_finished
add wave -noupdate -expand -group PARTNER -group SB_SER_2 -color Cyan /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/TXDATASB
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_pll_clk
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_data_in
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_enable
add wave -noupdate -expand -group PARTNER -group SB_SER_2 /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/i_pack_finished
add wave -noupdate -expand -group PARTNER -group SB_SER_2 -color Cyan /TB_LTSM_SB_MB/SB_TX_SERIALIZER_inst_2/TXDATASB
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_clk
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/ser_data_in
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_clk_pll
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_de_ser_done_sampled
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 -color {Green Yellow} /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/par_data_out
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/de_ser_done
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_clk
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/ser_data_in
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_clk_pll
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/i_de_ser_done_sampled
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 -color {Green Yellow} /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/par_data_out
add wave -noupdate -expand -group PARTNER -group SB_DESER_2 /TB_LTSM_SB_MB/SB_RX_DESER_inst_2/de_ser_done
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_clk
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_de_ser_done
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_header_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_rdi_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_data_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_deser_data
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_state
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_msg_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_header_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rdi_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_data_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_parity_error
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_adapter_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_de_ser_done_sampled
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/ns
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_clk
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_rst_n
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_de_ser_done
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_header_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_rdi_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_data_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_deser_data
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/i_state
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_msg_valid
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_header_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rdi_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_data_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_parity_error
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_adapter_enable
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/o_de_ser_done_sampled
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -expand -group PARTNER -group SB_RX_FSM_2 /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/SB_inst/rx_wrapper/rx_fsm_dut/ns
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_msg_valid
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_msg_no
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/i_rx_msg_no_string_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_data_bus
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_msg_info
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sync_sb_tx_msg_valid
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_msg_valid
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/o_tx_msg_no_string_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_msg_no
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_data_bus
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_msg_info
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_tx_data_valid
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/sub_state_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/CS_top_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/NS_top_2
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sb_rx_start_training
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LTSM_TOP_inst/o_functional_tx_lanes
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/LTSM_TOP_inst/o_functional_rx_lanes
add wave -noupdate -expand -group PARTNER /TB_LTSM_SB_MB/LTSM_SB_MB_inst_2/sync_sb_rx_start_training
add wave -noupdate /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_serliazer_valid_en
add wave -noupdate /TB_LTSM_SB_MB/LTSM_SB_MB_inst_1/o_serliazer_data_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2763594200 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 291
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
WaveRestoreZoom {2552269 ps} {2974919400 fs}
