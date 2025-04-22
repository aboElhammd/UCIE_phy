onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_SBINIT_WRAPPER/i_clk
add wave -noupdate /TB_SBINIT_WRAPPER/i_rst_n
add wave -noupdate /TB_SBINIT_WRAPPER/i_SBINIT_en
add wave -noupdate /TB_SBINIT_WRAPPER/i_start_pattern_done
add wave -noupdate /TB_SBINIT_WRAPPER/i_SB_Busy
add wave -noupdate /TB_SBINIT_WRAPPER/i_decoded_SB_msg
add wave -noupdate /TB_SBINIT_WRAPPER/o_start_pattern_req
add wave -noupdate -color Gold /TB_SBINIT_WRAPPER/o_encoded_SB_msg
add wave -noupdate /TB_SBINIT_WRAPPER/o_SBINIT_end
add wave -noupdate -group TX_signals /TB_SBINIT_WRAPPER/CS_tx
add wave -noupdate -group TX_signals /TB_SBINIT_WRAPPER/NS_tx
add wave -noupdate -group TX_signals /TB_SBINIT_WRAPPER/dut/U_TX_SBINIT/o_valid_tx
add wave -noupdate -group RX_signals /TB_SBINIT_WRAPPER/CS_rx
add wave -noupdate -group RX_signals /TB_SBINIT_WRAPPER/NS_rx
add wave -noupdate -group RX_signals /TB_SBINIT_WRAPPER/dut/U_RX_SBINIT/o_valid_rx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {445 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {259 ns} {513 ns}
