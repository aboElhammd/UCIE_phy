onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/i_clk
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/i_rst_n
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/i_rx_d2c_pt_en
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/i_datavref_or_valvref
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/i_pattern_finished
add wave -noupdate -expand -group MODULE -radix hexadecimal /tb_rx_initiated_point_test_wrapper/MODULE_inst/i_comparison_results
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/i_decoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/o_encoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -radix binary /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_tx_data_bus
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_tx_data_valid
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_rx_d2c_pt_done
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_val_pattern_en
add wave -noupdate -expand -group MODULE -radix binary /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_mainband_pattern_generator_cw
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_comparison_valid_en
add wave -noupdate -expand -group MODULE -radix binary /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_mainband_pattern_comparator_cw
add wave -noupdate -expand -group MODULE /tb_rx_initiated_point_test_wrapper/MODULE_inst/o_comparison_result
add wave -noupdate -expand -group MODULE -expand -group TX_SIGNALS -color Khaki /tb_rx_initiated_point_test_wrapper/CS_tx
add wave -noupdate -expand -group MODULE -expand -group TX_SIGNALS -color Khaki /tb_rx_initiated_point_test_wrapper/NS_tx
add wave -noupdate -expand -group MODULE -expand -group TX_SIGNALS -color Khaki /tb_rx_initiated_point_test_wrapper/MODULE_inst/TX_inst/o_valid_tx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS -color Blue /tb_rx_initiated_point_test_wrapper/CS_rx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS -color Blue /tb_rx_initiated_point_test_wrapper/NS_rx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS -color Blue /tb_rx_initiated_point_test_wrapper/MODULE_inst/RX_inst/o_valid_rx
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/i_clk
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/i_rst_n
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/i_rx_d2c_pt_en
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/i_datavref_or_valvref
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/i_pattern_finished
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/i_comparison_results
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/i_SB_Busy
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/i_decoded_sideband_msg_partner
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/o_encoded_sideband_msg_partner
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_tx_data_valid
add wave -noupdate -group PARTNER -radix binary /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_tx_data_bus
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_tx_msg_valid
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_rx_d2c_pt_done
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_val_pattern_en
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_mainband_pattern_generator_cw
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_comparison_valid_en
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_mainband_pattern_comparator_cw
add wave -noupdate -group PARTNER /tb_rx_initiated_point_test_wrapper/PARTNER_inst/o_comparison_result
add wave -noupdate -group PARTNER -expand -group TX_SIGNALS /tb_rx_initiated_point_test_wrapper/CS_tx_partner
add wave -noupdate -group PARTNER -expand -group TX_SIGNALS /tb_rx_initiated_point_test_wrapper/NS_tx_partner
add wave -noupdate -group PARTNER -expand -group TX_SIGNALS /tb_rx_initiated_point_test_wrapper/PARTNER_inst/TX_inst/o_valid_tx
add wave -noupdate -group PARTNER -expand -group RX_SIGNALS /tb_rx_initiated_point_test_wrapper/CS_rx_partner
add wave -noupdate -group PARTNER -expand -group RX_SIGNALS /tb_rx_initiated_point_test_wrapper/NS_rx_partner
add wave -noupdate -group PARTNER -expand -group RX_SIGNALS /tb_rx_initiated_point_test_wrapper/PARTNER_inst/RX_inst/o_valid_rx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {395 ns} 0 Red default}
quietly wave cursor active 1
configure wave -namecolwidth 248
configure wave -valuecolwidth 69
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
WaveRestoreZoom {221 ns} {469 ns}
