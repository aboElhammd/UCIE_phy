onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/i_clk
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/i_rst_n
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/i_rx_d2c_pt_en
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/i_datavref_or_valvref
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/i_comparison_results
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/i_decoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/o_encoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -radix binary /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE -radix binary /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/o_mainband_pattern_comparator_cw
add wave -noupdate -expand -group MODULE -radix binary /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -expand -group TX_SIGNALS /tb_rx_d2c_pt_with_pattern_integ/CS_tx
add wave -noupdate -expand -group MODULE -expand -group TX_SIGNALS /tb_rx_d2c_pt_with_pattern_integ/NS_tx
add wave -noupdate -expand -group MODULE -expand -group TX_SIGNALS /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/TX_inst/o_valid_tx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS /tb_rx_d2c_pt_with_pattern_integ/CS_rx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS /tb_rx_d2c_pt_with_pattern_integ/NS_rx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS /tb_rx_d2c_pt_with_pattern_integ/MODULE_inst/RX_inst/o_valid_rx
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/clk
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/rst_n
add wave -noupdate -expand -group PATTERN_GEN -radix binary /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/i_state
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_0
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_1
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_2
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_3
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_4
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_5
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_6
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_7
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_8
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_9
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_10
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_11
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_12
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_13
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_14
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/out_data_lane_15
add wave -noupdate -expand -group PATTERN_GEN /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/done
add wave -noupdate -expand -group PATTERN_GEN -radix unsigned /tb_rx_d2c_pt_with_pattern_integ/pattern_generator/counter_lfsr
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/i_clk
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/i_rst_n
add wave -noupdate -expand -group DETECTOR -radix binary /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/i_state
add wave -noupdate -expand -group DETECTOR -radix binary /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/locally_generated_patterns
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/enable_buffer
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_0
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_1
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_2
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_3
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_4
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_5
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_6
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_7
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_8
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_9
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_10
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_11
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_12
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_13
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_14
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/o_pattern_15
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/done
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_0
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_1
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_2
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_3
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_4
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_5
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_6
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_7
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_8
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_9
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_10
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_11
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_12
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_13
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_14
add wave -noupdate -expand -group DETECTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_detector_inst/out_local_pattern_15
add wave -noupdate -expand -group COMPARTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/clk
add wave -noupdate -expand -group COMPARTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/rst_n
add wave -noupdate -expand -group COMPARTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/Type_comp
add wave -noupdate -expand -group COMPARTOR -radix binary /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/i_state
add wave -noupdate -expand -group COMPARTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/enable_buffer
add wave -noupdate -expand -group COMPARTOR -radix binary /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/per_lane_error
add wave -noupdate -expand -group COMPARTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/error_counter
add wave -noupdate -expand -group COMPARTOR /tb_rx_d2c_pt_with_pattern_integ/pattern_comparison_inst/done_result
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/i_clk
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/i_rst_n
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/i_rx_d2c_pt_en
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/i_datavref_or_valvref
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/i_comparison_results
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/i_decoded_sideband_msg_partner
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/o_encoded_sideband_msg_partner
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/o_rx_d2c_pt_done
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE_PARTNER -radix binary /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE_PARTNER -radix binary /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/o_mainband_pattern_comparator_cw
add wave -noupdate -expand -group MODULE_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE_PARTNER -expand -group TX_SIGNALS_PARTNER /tb_rx_d2c_pt_with_pattern_integ/CS_tx_partner
add wave -noupdate -expand -group MODULE_PARTNER -expand -group TX_SIGNALS_PARTNER /tb_rx_d2c_pt_with_pattern_integ/NS_tx_partner
add wave -noupdate -expand -group MODULE_PARTNER -expand -group TX_SIGNALS_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/TX_inst/o_valid_tx
add wave -noupdate -expand -group MODULE_PARTNER -expand -group RX_SIGNALS_PARTNER /tb_rx_d2c_pt_with_pattern_integ/CS_rx_partner
add wave -noupdate -expand -group MODULE_PARTNER -expand -group RX_SIGNALS_PARTNER /tb_rx_d2c_pt_with_pattern_integ/NS_rx_partner
add wave -noupdate -expand -group MODULE_PARTNER -expand -group RX_SIGNALS_PARTNER /tb_rx_d2c_pt_with_pattern_integ/PARTNER_inst/RX_inst/o_valid_rx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {375 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
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
WaveRestoreZoom {0 ns} {536 ns}
