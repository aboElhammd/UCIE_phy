onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_clk
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_rst_n
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/i_start_training_RDI_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/MODULE_inst_1/i_start_training_SB
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
add wave -noupdate -expand -group TOP_1 -group {TX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/i_Transmitter_initiated_Data_to_CLK_done
add wave -noupdate -expand -group TOP_1 -group {TX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/i_Transmitter_initiated_Data_to_CLK_Result
add wave -noupdate -expand -group TOP_1 -group {TX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group {TX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group {TX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/o_Transmitter_initiated_Data_to_CLK_en
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/i_Receiver_initiated_Data_to_CLK_done
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/i_Receiver_initiated_Data_to_CLK_Result
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK
add wave -noupdate -expand -group TOP_1 -group {RX D2C PT} /TB_LTSM_with_sideband/MODULE_inst_1/o_MBTRAIN_Receiver_initiated_Data_to_CLK_en
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/o_tx_msg_no_string_1
add wave -noupdate -expand -group TOP_1 -radix binary /TB_LTSM_with_sideband/MODULE_inst_1/o_tx_msg_info
add wave -noupdate -expand -group TOP_1 -radix binary /TB_LTSM_with_sideband/MODULE_inst_1/o_tx_data_bus
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/MODULE_inst_1/o_tx_msg_valid
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/MODULE_inst_1/o_tx_data_valid
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/MODULE_inst_1/o_functional_tx_lanes
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/MODULE_inst_1/o_functional_rx_lanes
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/sub_state_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/CS_top_1
add wave -noupdate -expand -group TOP_1 /TB_LTSM_with_sideband/NS_top_1
add wave -noupdate -group Sideband /TB_LTSM_with_sideband/i_clk
add wave -noupdate -group Sideband /TB_LTSM_with_sideband/i_rst_n
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_start_pattern_req
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_data_valid
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_msg_valid
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_state
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_sub_state
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_msg_info
add wave -noupdate -group Sideband -expand -group module -radix binary /TB_LTSM_with_sideband/module_data_bus
add wave -noupdate -group Sideband -expand -group module -color Cyan /TB_LTSM_with_sideband/module_ser_done
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_stop_cnt
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_tx_point_sweep_test_en
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_tx_point_sweep_test
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg_code
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg_sub_code
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg_info
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_deser_data
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_start_pattern_done
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_time_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_busy
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rx_sb_start_pattern
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_msg_valid_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_parity_error
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_adapter_enable
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_tx_point_sweep_test_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_msg_no_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_msg_info_out
add wave -noupdate -group Sideband -expand -group module -radix binary /TB_LTSM_with_sideband/module_data_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg_code_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg_sub_code_out
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/module_rdi_msg_info_out
add wave -noupdate -group Sideband -expand -group module -color Cyan /TB_LTSM_with_sideband/TX_module_data
add wave -noupdate -group Sideband -expand -group module -color Cyan /TB_LTSM_with_sideband/RX_partner_data
add wave -noupdate -group Sideband -expand -group module /TB_LTSM_with_sideband/Module/rx_wrapper/rx_deser_dut/de_ser_done
add wave -noupdate -group Sideband -expand -group module -label Module_tx_cs /TB_LTSM_with_sideband/Module/tx_wrapper/sb_fsm_dut/cs
add wave -noupdate -group Sideband -expand -group module -label Module_rx_cs /TB_LTSM_with_sideband/Module/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_clk
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_rst_n
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_msg_valid
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_data_valid
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_state
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_sub_state
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_msg_no
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/i_msg_info
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/o_header
add wave -noupdate -group Sideband -expand -group module -group header_encoder_module /TB_LTSM_with_sideband/Module/tx_wrapper/header_encoder_dut/o_header_valid
add wave -noupdate -group Sideband -expand -group module -group TX_out /TB_LTSM_with_sideband/Module/tx_wrapper/TXCKSB
add wave -noupdate -group Sideband -expand -group module -group TX_out /TB_LTSM_with_sideband/Module/tx_wrapper/TXDATASB
add wave -noupdate -group Sideband -expand -group module -group RX_out /TB_LTSM_with_sideband/Module/rx_wrapper/RXCKSB
add wave -noupdate -group Sideband -expand -group module -group RX_out /TB_LTSM_with_sideband/Module/rx_wrapper/RXDATASB
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_start_pattern_req
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_data_valid
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_msg_valid
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_state
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_sub_state
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_msg_no
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_msg_info
add wave -noupdate -group Sideband -group partner -radix binary /TB_LTSM_with_sideband/partner_data_bus
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_ser_done
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_stop_cnt
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_tx_point_sweep_test_en
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_tx_point_sweep_test
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg_code
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg_sub_code
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg_info
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_de_ser_done
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_start_pattern_done
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_time_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_busy
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rx_sb_start_pattern
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_msg_valid_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_parity_error
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_adapter_enable
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_tx_point_sweep_test_out
add wave -noupdate -group Sideband -group partner -color Yellow /TB_LTSM_with_sideband/module_msg_no
add wave -noupdate -group Sideband -group partner -color Yellow /TB_LTSM_with_sideband/partner_msg_no_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_msg_info_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_data_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg_code_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg_sub_code_out
add wave -noupdate -group Sideband -group partner /TB_LTSM_with_sideband/partner_rdi_msg_info_out
add wave -noupdate -group Sideband -group partner -color Cyan /TB_LTSM_with_sideband/TX_partner_data
add wave -noupdate -group Sideband -group partner -color Cyan /TB_LTSM_with_sideband/RX_module_data
add wave -noupdate -group Sideband -group partner -label Partner_tx_cs /TB_LTSM_with_sideband/Partner/tx_wrapper/sb_fsm_dut/cs
add wave -noupdate -group Sideband -group partner -label Partner_rx_cs /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_clk
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_rst_n
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_msg_valid
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_data_valid
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_state
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_sub_state
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_msg_no
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/i_msg_info
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/o_header
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/o_header_valid
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/msg_code
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/msg_sub_code
add wave -noupdate -group Sideband -group partner -expand -group header_encoder_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/header_encoder_dut/msg_info
add wave -noupdate -group Sideband -group partner -group TX_out /TB_LTSM_with_sideband/Partner/tx_wrapper/TXCKSB
add wave -noupdate -group Sideband -group partner -group TX_out /TB_LTSM_with_sideband/Partner/tx_wrapper/TXDATASB
add wave -noupdate -group Sideband -group partner -group RX_out /TB_LTSM_with_sideband/Partner/rx_wrapper/RXCKSB
add wave -noupdate -group Sideband -group partner -group RX_out /TB_LTSM_with_sideband/Partner/rx_wrapper/RXDATASB
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_clk
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_rst_n
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_header
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test_en
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_msg_no
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_msg_info
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_dec_header_valid
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/test_type_reg
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_start_EN
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/MsgCode
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/MsgSubCode
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/Opcode
add wave -noupdate -group Sideband -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/MsgInfo
add wave -noupdate -group Sideband -group {RX FSM} -label Partner_rx_cs /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/RESET
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_clk
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_rst_n
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_de_ser_done
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_header_valid
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_rdi_valid
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_data_valid
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_deser_data
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_state
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_msg_valid
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_header_enable
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rdi_enable
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_data_enable
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_parity_error
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_adapter_enable
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/ns
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_msg_valid_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_header_enable_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rdi_enable_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_data_enable_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_parity_error_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_adapter_enable_reg
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/MsgCode
add wave -noupdate -group Sideband -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/MsgCode_part_2
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_clk
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_rst_n
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_start_training_RDI
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_LINKINIT_DONE
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_ACTIVE_DONE
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_start_pattern_done
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_start_training_SB
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_time_out
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_busy
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/i_rx_msg_no_string_2
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_rx_msg_valid
add wave -noupdate -expand -group TOP_2 -radix binary /TB_LTSM_with_sideband/MODULE_inst_2/i_rx_data_bus
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/i_rx_msg_info
add wave -noupdate -expand -group TOP_2 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_2/SBINIT_inst/i_SBINIT_en
add wave -noupdate -expand -group TOP_2 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_2/SBINIT_inst/i_start_pattern_done
add wave -noupdate -expand -group TOP_2 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_2/SBINIT_inst/o_start_pattern_req
add wave -noupdate -expand -group TOP_2 -group SBINIT /TB_LTSM_with_sideband/MODULE_inst_2/SBINIT_inst/o_SBINIT_end
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/o_tx_msg_no_string_2
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/o_tx_msg_info
add wave -noupdate -expand -group TOP_2 -radix binary /TB_LTSM_with_sideband/MODULE_inst_2/o_tx_data_bus
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/o_tx_msg_valid
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/MODULE_inst_2/o_tx_data_valid
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/sub_state_2
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/CS_top_2
add wave -noupdate -expand -group TOP_2 /TB_LTSM_with_sideband/NS_top_2
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_clk
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_rst_n
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_data_valid
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_msg_valid
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_state
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_sub_state
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_msg_no
add wave -noupdate -group data_encode_partner -radix binary /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/i_data_bus
add wave -noupdate -group data_encode_partner -radix binary /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/o_data_encoded
add wave -noupdate -group data_encode_partner /TB_LTSM_with_sideband/Partner/tx_wrapper/data_encoder_dut/o_d_valid
add wave -noupdate -radix unsigned /TB_LTSM_with_sideband/MODULE_inst_2/o_encoded_SB_msg
add wave -noupdate /TB_LTSM_with_sideband/MODULE_inst_1/TRAINERROR_inst/U_TX_TRAINERROR_HS/CS
add wave -noupdate /TB_LTSM_with_sideband/MODULE_inst_1/TRAINERROR_inst/U_TX_TRAINERROR_HS/NS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7432 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 293
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {49152 ns}
