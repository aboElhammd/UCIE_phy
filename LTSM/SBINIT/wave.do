onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_TX_SBINIT/i_clk
add wave -noupdate /TB_TX_SBINIT/i_rst_n
add wave -noupdate /TB_TX_SBINIT/i_SBINIT_en
add wave -noupdate /TB_TX_SBINIT/i_start_pattern_done
add wave -noupdate /TB_TX_SBINIT/i_decoded_SB_msg
add wave -noupdate /TB_TX_SBINIT/i_SB_Busy
add wave -noupdate /TB_TX_SBINIT/i_rx_valid
add wave -noupdate /TB_TX_SBINIT/o_start_pattern_req
add wave -noupdate /TB_TX_SBINIT/o_encoded_SB_msg_tx
add wave -noupdate /TB_TX_SBINIT/o_SBINIT_end
add wave -noupdate -color Red /TB_TX_SBINIT/o_valid_tx
add wave -noupdate /TB_TX_SBINIT/CS_tb
add wave -noupdate /TB_TX_SBINIT/NS_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {264895 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {218383 ps} {359477 ps}
