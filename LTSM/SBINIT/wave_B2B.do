onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MODULE /TB_SBINIT_WRAPPER/dut/i_clk
add wave -noupdate -expand -group MODULE /TB_SBINIT_WRAPPER/dut/i_rst_n
add wave -noupdate -expand -group MODULE /TB_SBINIT_WRAPPER/dut/i_SBINIT_en
add wave -noupdate -expand -group MODULE /TB_SBINIT_WRAPPER/dut/i_start_pattern_done
add wave -noupdate -expand -group MODULE /TB_SBINIT_WRAPPER/dut/i_SB_Busy
add wave -noupdate -expand -group MODULE -color Blue /TB_SBINIT_WRAPPER/i_decoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /TB_SBINIT_WRAPPER/dut/o_start_pattern_req
add wave -noupdate -expand -group MODULE -color {Orange Red} /TB_SBINIT_WRAPPER/o_encoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /TB_SBINIT_WRAPPER/dut/o_SBINIT_end
add wave -noupdate -expand -group MODULE -group TX /TB_SBINIT_WRAPPER/dut/U_TX_SBINIT/o_valid_tx
add wave -noupdate -expand -group MODULE -group TX /TB_SBINIT_WRAPPER/CS_tx
add wave -noupdate -expand -group MODULE -group TX /TB_SBINIT_WRAPPER/NS_tx
add wave -noupdate -expand -group MODULE -group RX /TB_SBINIT_WRAPPER/dut_partner/U_RX_SBINIT/o_valid_rx
add wave -noupdate -expand -group MODULE -group RX /TB_SBINIT_WRAPPER/CS_rx
add wave -noupdate -expand -group MODULE -group RX /TB_SBINIT_WRAPPER/NS_rx
add wave -noupdate -expand -group MODULE_PARTNER /TB_SBINIT_WRAPPER/dut_partner/i_clk
add wave -noupdate -expand -group MODULE_PARTNER /TB_SBINIT_WRAPPER/dut_partner/i_rst_n
add wave -noupdate -expand -group MODULE_PARTNER /TB_SBINIT_WRAPPER/dut_partner/i_SBINIT_en
add wave -noupdate -expand -group MODULE_PARTNER /TB_SBINIT_WRAPPER/dut_partner/i_start_pattern_done
add wave -noupdate -expand -group MODULE_PARTNER /TB_SBINIT_WRAPPER/dut_partner/i_SB_Busy
add wave -noupdate -expand -group MODULE_PARTNER -color {Orange Red} /TB_SBINIT_WRAPPER/i_decoded_sideband_msg_partner
add wave -noupdate -expand -group MODULE_PARTNER /TB_SBINIT_WRAPPER/dut_partner/o_start_pattern_req
add wave -noupdate -expand -group MODULE_PARTNER -color Blue /TB_SBINIT_WRAPPER/o_encoded_sideband_msg_partner
add wave -noupdate -expand -group MODULE_PARTNER /TB_SBINIT_WRAPPER/dut_partner/o_SBINIT_end
add wave -noupdate -expand -group MODULE_PARTNER -group TX_PARTNER /TB_SBINIT_WRAPPER/dut_partner/U_TX_SBINIT/o_valid_tx
add wave -noupdate -expand -group MODULE_PARTNER -group TX_PARTNER /TB_SBINIT_WRAPPER/CS_tx_partner
add wave -noupdate -expand -group MODULE_PARTNER -group TX_PARTNER /TB_SBINIT_WRAPPER/NS_tx_partner
add wave -noupdate -expand -group MODULE_PARTNER -group RX_PARTNER /TB_SBINIT_WRAPPER/dut_partner/U_RX_SBINIT/o_valid_rx
add wave -noupdate -expand -group MODULE_PARTNER -group RX_PARTNER /TB_SBINIT_WRAPPER/CS_rx_partner
add wave -noupdate -expand -group MODULE_PARTNER -group RX_PARTNER /TB_SBINIT_WRAPPER/NS_rx_partner
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {124 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 174
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
WaveRestoreZoom {0 ns} {684 ns}
