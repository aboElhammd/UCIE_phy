onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/i_clk
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/i_rst_n
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/i_phyretrain_en
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/i_enter_from_active_or_mbtrain
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/i_linkspeed_lanes_status
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/i_SB_Busy
add wave -noupdate -expand -group MODULE -radix binary /TB_PHYRETRAIN/MODULE_inst/i_rx_msg_info
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/i_decoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/i_rx_msg_valid
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/o_encoded_sideband_msg_mod
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/o_tx_msg_valid
add wave -noupdate -expand -group MODULE -radix binary /TB_PHYRETRAIN/MODULE_inst/o_tx_msg_info
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/o_PHYRETRAIN_end
add wave -noupdate -expand -group MODULE /TB_PHYRETRAIN/MODULE_inst/o_resolved_state
add wave -noupdate -expand -group MODULE -group TX_SIGNALS /TB_PHYRETRAIN/CS_tx
add wave -noupdate -expand -group MODULE -group TX_SIGNALS /TB_PHYRETRAIN/NS_tx
add wave -noupdate -expand -group MODULE -group TX_SIGNALS /TB_PHYRETRAIN/MODULE_inst/wp_tx_valid
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS /TB_PHYRETRAIN/CS_rx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS /TB_PHYRETRAIN/NS_rx
add wave -noupdate -expand -group MODULE -expand -group RX_SIGNALS /TB_PHYRETRAIN/MODULE_inst/wp_rx_valid
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_clk
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_rst_n
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_phyretrain_en
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_enter_from_active_or_mbtrain
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_linkspeed_lanes_status
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_SB_Busy
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_rx_msg_info
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/i_decoded_sideband_msg_partner
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/i_rx_msg_valid
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/o_encoded_sideband_msg_partner
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/o_tx_msg_valid
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/o_tx_msg_info
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/o_PHYRETRAIN_end
add wave -noupdate -expand -group PARTNER /TB_PHYRETRAIN/PARTNER_inst/o_resolved_state
add wave -noupdate -expand -group PARTNER -group TX_SIGNALS /TB_PHYRETRAIN/CS_tx_partner
add wave -noupdate -expand -group PARTNER -group TX_SIGNALS /TB_PHYRETRAIN/NS_tx_partner
add wave -noupdate -expand -group PARTNER -group TX_SIGNALS /TB_PHYRETRAIN/PARTNER_inst/wp_tx_valid
add wave -noupdate -expand -group PARTNER -group RX_SIGNALS /TB_PHYRETRAIN/CS_rx_partner
add wave -noupdate -expand -group PARTNER -group RX_SIGNALS /TB_PHYRETRAIN/NS_rx_partner
add wave -noupdate -expand -group PARTNER -group RX_SIGNALS /TB_PHYRETRAIN/PARTNER_inst/wp_rx_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {421 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 169
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
WaveRestoreZoom {3281 ns} {3702 ns}
