onerror {resume}
quietly virtual signal -install /TB_SBINIT_with_sideband/Partner { (context /TB_SBINIT_with_sideband/Partner )&{o_time_out ,o_tx_data_out , tx_wrapper/sb_fsm_dut/cs , tx_wrapper/sb_fsm_dut/ns }} TX_SB_p
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/i_clk
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/i_rst_n
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/i_SBINIT_en
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/i_start_pattern_done
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/i_SB_Busy
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/i_decoded_sideband_msg_mod
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/o_encoded_sideband_msg_mod
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/o_start_pattern_req
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/o_tx_msg_valid
add wave -noupdate -expand -group module_SBINIT /TB_SBINIT_with_sideband/dut/o_SBINIT_end
add wave -noupdate -expand -group module_SBINIT -group TX /TB_SBINIT_with_sideband/CS_tx
add wave -noupdate -expand -group module_SBINIT -group TX /TB_SBINIT_with_sideband/NS_tx
add wave -noupdate -expand -group module_SBINIT -group RX /TB_SBINIT_with_sideband/CS_rx
add wave -noupdate -expand -group module_SBINIT -group RX /TB_SBINIT_with_sideband/NS_rx
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/i_clk
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/i_rst_n
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/i_SBINIT_en
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/i_start_pattern_done
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/i_SB_Busy
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/i_decoded_sideband_msg_partner
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/o_encoded_sideband_msg_partner
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/o_start_pattern_req
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/o_tx_msg_valid
add wave -noupdate -expand -group partner_SBINIT /TB_SBINIT_with_sideband/dut_partner/o_SBINIT_end
add wave -noupdate -expand -group partner_SBINIT -group TX_partner /TB_SBINIT_with_sideband/CS_tx_partner
add wave -noupdate -expand -group partner_SBINIT -group TX_partner /TB_SBINIT_with_sideband/NS_tx_partner
add wave -noupdate -expand -group partner_SBINIT -group RX_partner /TB_SBINIT_with_sideband/CS_rx_partner
add wave -noupdate -expand -group partner_SBINIT -group RX_partner /TB_SBINIT_with_sideband/NS_rx_partner
add wave -noupdate -group SB_mod -expand -group TX_SB /TB_SBINIT_with_sideband/Module/o_tx_data_out
add wave -noupdate -group SB_mod -expand -group TX_SB /TB_SBINIT_with_sideband/Module/o_time_out
add wave -noupdate -group SB_mod -expand -group TX_SB /TB_SBINIT_with_sideband/Module/tx_wrapper/sb_fsm_dut/cs
add wave -noupdate -group SB_mod -expand -group TX_SB /TB_SBINIT_with_sideband/Module/tx_wrapper/sb_fsm_dut/ns
add wave -noupdate -group SB_mod -expand -group RX_SB /TB_SBINIT_with_sideband/Module/i_deser_data
add wave -noupdate -group SB_mod -expand -group RX_SB /TB_SBINIT_with_sideband/Module/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group SB_mod -expand -group RX_SB /TB_SBINIT_with_sideband/Module/rx_wrapper/rx_fsm_dut/ns
add wave -noupdate -group SB_partner -expand -group TX_SB_p /TB_SBINIT_with_sideband/Partner/o_time_out
add wave -noupdate -group SB_partner -expand -group TX_SB_p /TB_SBINIT_with_sideband/Partner/o_tx_data_out
add wave -noupdate -group SB_partner -expand -group TX_SB_p /TB_SBINIT_with_sideband/Partner/tx_wrapper/sb_fsm_dut/cs
add wave -noupdate -group SB_partner -expand -group TX_SB_p /TB_SBINIT_with_sideband/Partner/tx_wrapper/sb_fsm_dut/ns
add wave -noupdate -group SB_partner -group RX_SB_p /TB_SBINIT_with_sideband/Partner/rx_wrapper/i_deser_data
add wave -noupdate -group SB_partner -group RX_SB_p /TB_SBINIT_with_sideband/Partner/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group SB_partner -group RX_SB_p /TB_SBINIT_with_sideband/Partner/rx_wrapper/rx_fsm_dut/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {635 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 174
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ns} {2240 ns}
