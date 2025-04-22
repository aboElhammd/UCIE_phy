onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_clk
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_rst_n
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_start_training_RDI_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_LINKINIT_DONE_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_ACTIVE_DONE_1
add wave -noupdate -expand -group TOP_1 -color Violet /TB_LTSM_with_sideband/MODULE_inst_1/i_busy
add wave -noupdate -expand -group TOP_1 -radix unsigned /TB_LTSM_with_sideband/MODULE_inst_1/i_decoded_SB_msg
add wave -noupdate -expand -group TOP_1 -color Turquoise /TB_LTSM_with_sideband/i_rx_msg_no_string_1
add wave -noupdate -expand -group TOP_1 -color Yellow /TB_LTSM_with_sideband/MODULE_inst_1/i_rx_msg_valid
add wave -noupdate -expand -group TOP_1 -color {Orange Red} -radix binary /TB_LTSM_with_sideband/MODULE_inst_1/i_rx_msg_info
add wave -noupdate -expand -group TOP_1 -color {Medium Orchid} -radix binary -childformat {{{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[15]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[14]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[13]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[12]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[11]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[10]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[9]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[8]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[7]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[6]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[5]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[4]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[3]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[2]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[1]} -radix binary} {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[0]} -radix binary}} -subitemconfig {{/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[15]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[14]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[13]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[12]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[11]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[10]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[9]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[8]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[7]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[6]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[5]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[4]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[3]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[2]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[1]} {-color {Medium Orchid} -height 15 -radix binary} {/TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus[0]} {-color {Medium Orchid} -height 15 -radix binary}} /TB_LTSM_with_sideband/MODULE_inst_1/i_rx_data_bus
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_1/SBINIT_inst/i_clk
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_1/SBINIT_inst/i_rst_n
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_1/SBINIT_inst/i_SBINIT_en
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_1/SBINIT_inst/i_start_pattern_done
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_1/SBINIT_inst/o_start_pattern_req
add wave -noupdate -expand -group TOP_1 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_1/SBINIT_inst/o_SBINIT_end
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_EN
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/i_CLK_Track_done_1
add wave -noupdate -expand -group TOP_1 -group MBINIT -radix binary /TB_LTSM_with_sideband/i_logged_clk_result_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/i_VAL_Pattern_done_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/i_logged_val_result_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/i_REVERSAL_done_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/o_MBINIT_REPAIRCLK_Pattern_En_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/o_MBINIT_REPAIRVAL_Pattern_En_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/o_MBINIT_mainband_pattern_generator_cw_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/o_MBINIT_mainband_pattern_comparator_cw_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/o_MBINIT_REVERSALMB_ApplyReversal_En_1
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/go_to_trainerror_MBINIT
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_tx_Functional_Lanes_out
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_rx_Functional_Lanes_out
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_Transmitter_initiated_Data_to_CLK_en
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_Vref
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_highest_common_speed
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_REVERSALMB_LaneID_Pattern_En
add wave -noupdate -expand -group TOP_1 -group MBINIT /TB_LTSM_with_sideband/MODULE_inst_1/MBINIT_DONE
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/clk
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/i_en
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/rst_n
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/i_valid_framing_error
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/i_phyretrain_resolved_state
add wave -noupdate -expand -group TOP_1 -group MBTRAIN /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/i_highest_common_speed
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_tx_instance/o_valid_tx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_mainband_or_valtrain_test
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group TX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_test_ack
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/cs
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/ns
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/verf_cal_rx_instance/o_valid_rx
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_sideband_message
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_valid
add wave -noupdate -expand -group TOP_1 -group MBTRAIN -group VREF_CAL -group RX /TB_LTSM_with_sideband/MODULE_inst_1/MBTRAIN_inst/vref_cal_wrapper_inst/o_mainband_or_valtrain_test
add wave -noupdate -expand -group TOP