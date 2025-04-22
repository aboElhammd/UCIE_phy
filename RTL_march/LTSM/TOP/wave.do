onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TOP_1 /TB_LTSM_TOP/i_clk
add wave -noupdate -expand -group TOP_1 /TB_LTSM_TOP/i_rst_n
add wave -noupdate -expand -group TOP_1 /TB_LTSM_TOP/i_start_training_RDI_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_TOP/i_LINKINIT_DONE_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_TOP/i_ACTIVE_DONE_1
add wave -noupdate -expand -group TOP_1 -color Violet /TB_LTSM_TOP/i_busy_1
add wave -noupdate -expand -group TOP_1 -radix unsigned /TB_LTSM_TOP/MODULE_inst_1/i_decoded_SB_msg
add wave -noupdate -expand -group TOP_1 -color Turquoise /TB_LTSM_TOP/i_rx_msg_no_string_1
add wave -noupdate -expand -group TOP_1 -color Yellow /TB_LTSM_TOP/i_rx_msg_valid_1
add wave -noupdate -expand -group TOP_1 -color {Orange Red} -radix binary /TB_LTSM_TOP/MODULE_inst_1/i_rx_msg_info
add wave -noupdate -expand -group TOP_1 -color {Medium Orchid} -radix binary -childformat {{{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[15]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[14]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[13]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[12]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[11]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[10]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[9]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[8]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[7]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[6]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[5]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[4]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[3]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[2]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[1]} -radix binary} {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[0]} -radix binary}} -subitemconfig {{/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[15]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[14]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[13]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[12]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[11]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[10]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[9]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[8]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[7]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[6]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[5]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[4]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[3]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[2]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[1]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus[0]} {-color {Medium Orchid} -height 15 -radix binary}} /TB_LTSM_TOP/MODULE_inst_1/i_rx_data_bus
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_TOP/MODULE_inst_1/SBINIT_inst/i_clk
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_TOP/MODULE_inst_1/SBINIT_inst/i_rst_n
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_TOP/MODULE_inst_1/SBINIT_inst/i_SBINIT_en
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_TOP/MODULE_inst_1/SBINIT_inst/i_start_pattern_done
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_TOP/MODULE_inst_1/SBINIT_inst/o_start_pattern_req
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_TOP/MODULE_inst_1/SBINIT_inst/o_SBINIT_end
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_EN
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/i_CLK_Track_done_1
add wave -noupdate -expand -group TOP_1 -group MBINIT -radix binary /TB_LTSM_TOP/i_logged_clk_result_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/i_VAL_Pattern_done_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/i_logged_val_result_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/i_REVERSAL_done_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/o_MBINIT_REPAIRCLK_Pattern_En_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/o_MBINIT_REPAIRVAL_Pattern_En_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/o_MBINIT_mainband_pattern_generator_cw_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/o_MBINIT_mainband_pattern_comparator_cw_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/o_MBINIT_REVERSALMB_ApplyReversal_En_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/go_to_trainerror_MBINIT
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_tx_Functional_Lanes_out
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_rx_Functional_Lanes_out
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_Transmitter_initiated_Data_to_CLK_en
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_Vref
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_highest_common_speed
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_REVERSALMB_LaneID_Pattern_En
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_TOP/MODULE_inst_1/MBINIT_DONE
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/clk
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/i_en
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/rst_n
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/i_valid_framing_error
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/i_phyretrain_resolved_state
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/i_highest_common_speed
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/o_valid_tx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_mainband_or_valtrain_test
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_test_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/o_valid_rx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_mainband_or_valtrain_test
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_test_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_valid_tx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_test_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_point_test_en
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_tx_inst/o_timeout_disable
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/o_valid_rx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/o_point_test_en
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/linkspeed_rx_inst/o_test_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_link_speeed_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_phy_retrain_req_was_sent_or_received
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_error_req_was_sent_or_received
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_speed_degrade_req_was_sent_or_received
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group LINKSPEED -expand -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/linkspeed_wrapper_inst/o_repair_req_was_sent_or_received
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_mainband_or_valtrain_test
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_test_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_tx_inst/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_tx_inst/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_tx_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_tx_inst/o_valid_tx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_mainband_or_valtrain_test
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/o_test_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_rx_inst/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_rx_inst/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_rx_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group TRAIN_CENTER -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/train_center_cal_wrapper_inst/train_center_cal_rx_inst/o_valid_rx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/o_sideband_data_lanes_encoding
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_tx_instance_1/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_tx_instance_1/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_tx_instance_1/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group TX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_tx_instance_1/o_valid_tx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_rx_instance_1/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_rx_instance_1/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_rx_instance_1/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group REPAIR -group RX /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/repair_wrapper_inst/repair_rx_instance_1/o_valid_rx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/o_pi_step
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/o_curret_operating_speed
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/o_phyretrain_error_encoding
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/o_phyretrain_en
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_TOP/MODULE_inst_1/MBTRAIN_inst/o_mbtrain_ack
add wave -noupdate -expand -group TOP_1 -expand -group {TX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/i_Transmitter_initiated_Data_to_CLK_done
add wave -noupdate -expand -group TOP_1 -expand -group {TX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/i_Transmitter_initiated_Data_to_CLK_Result
add wave -noupdate -expand -group TOP_1 -expand -group {TX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -expand -group {TX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -expand -group {TX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/o_Transmitter_initiated_Data_to_CLK_en
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/i_Receiver_initiated_Data_to_CLK_done
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} -radix binary /TB_LTSM_TOP/MODULE_inst_1/i_Receiver_initiated_Data_to_CLK_Result
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} /TB_LTSM_TOP/MODULE_inst_1/o_MBTRAIN_Receiver_initiated_Data_to_CLK_en
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/i_clk
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/i_rst_n
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/i_phyretrain_en
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/i_enter_from_active_or_mbtrain
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/i_linkspeed_lanes_status
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/i_clear_resolved_state
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/o_PHYRETRAIN_end
add wave -noupdate -expand -group TOP_1 -group PHYRETRAIN /TB_LTSM_TOP/MODULE_inst_1/PHYRETRAIN_inst/o_resolved_state
add wave -noupdate -expand -group TOP_1 -group TAINERROR /TB_LTSM_TOP/MODULE_inst_1/TRAINERROR_inst/i_clk
add wave -noupdate -expand -group TOP_1 -group TAINERROR /TB_LTSM_TOP/MODULE_inst_1/TRAINERROR_inst/i_rst_n
add wave -noupdate -expand -group TOP_1 -group TAINERROR /TB_LTSM_TOP/MODULE_inst_1/TRAINERROR_inst/i_trainerror_en
add wave -noupdate -expand -group TOP_1 -group TAINERROR /TB_LTSM_TOP/MODULE_inst_1/TRAINERROR_inst/o_TRAINERROR_HS_end
add wave -noupdate -expand -group TOP_1 -color Turquoise /TB_LTSM_TOP/o_tx_msg_no_string_1
add wave -noupdate -expand -group TOP_1 -color Yellow /TB_LTSM_TOP/o_tx_msg_valid_1
add wave -noupdate -expand -group TOP_1 -color {Orange Red} -radix binary /TB_LTSM_TOP/o_tx_msg_info_1
add wave -noupdate -expand -group TOP_1 -color {Medium Orchid} -radix binary /TB_LTSM_TOP/o_tx_data_bus_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_TOP/o_tx_data_valid_1
add wave -noupdate -expand -group TOP_1 -expand -group {pattern gen/comp} /TB_LTSM_TOP/i_pattern_generation_done_1
add wave -noupdate -expand -group TOP_1 -expand -group {pattern gen/comp} -radix binary /TB_LTSM_TOP/i_comparsion_results_1
add wave -noupdate -expand -group TOP_1 -expand -group {vref & func lanes} /TB_LTSM_TOP/o_reciever_ref_volatge_1
add wave -noupdate -expand -group TOP_1 -expand -group {vref & func lanes} /TB_LTSM_TOP/o_functional_tx_lanes_1
add wave -noupdate -expand -group TOP_1 -expand -group {vref & func lanes} /TB_LTSM_TOP/o_functional_rx_lanes_1
add wave -noupdate -expand -group TOP_1 -expand -group States /TB_LTSM_TOP/o_tx_sub_state_1
add wave -noupdate -expand -group TOP_1 -expand -group States /TB_LTSM_TOP/sub_state_1
add wave -noupdate -expand -group TOP_1 -expand -group States /TB_LTSM_TOP/CS_top_1
add wave -noupdate -expand -group TOP_1 -expand -group States /TB_LTSM_TOP/NS_top_1
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_clk
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_rst_n
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_start_training_RDI_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_LINKINIT_DONE_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_ACTIVE_DONE_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_busy_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_rx_msg_no_string_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/i_rx_msg_valid_2
add wave -noupdate -group TOP_2 -radix binary /TB_LTSM_TOP/MODULE_inst_2/i_rx_msg_info
add wave -noupdate -group TOP_2 -radix binary /TB_LTSM_TOP/MODULE_inst_2/i_rx_data_bus
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/o_tx_msg_no_string_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/MODULE_inst_2/i_Transmitter_initiated_Data_to_CLK_done
add wave -noupdate -group TOP_2 -radix binary /TB_LTSM_TOP/MODULE_inst_2/i_Transmitter_initiated_Data_to_CLK_Result
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/MODULE_inst_2/o_MBINIT_REVERSALMB_ApplyReversal_En
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/MODULE_inst_2/i_REVERSAL_done
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/sub_state_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/CS_top_2
add wave -noupdate -group TOP_2 /TB_LTSM_TOP/NS_top_2
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/reset_counter
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/o_Functional_Lanes_out_tx
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/o_Functional_Lanes_out_rx
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/i_Functional_Lanes
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_start_check
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/i_second_check
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_done_check
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_go_to_repeat
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_go_to_train_error
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CHECKER_REPAIRMB_Module_Partner_inst/o_continue
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/CS
add wave -noupdate /TB_LTSM_TOP/MODULE_inst_1/MBINIT_inst/REPAIRMB_Wrapper_inst/REPAIRMB_Module_Partner_inst/NS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3545 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 289
configure wave -valuecolwidth 77
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
WaveRestoreZoom {3323 ns} {3707 ns}
