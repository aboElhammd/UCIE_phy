onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_TRAINERROR_HS_WRAPPER/i_clk
add wave -noupdate /TB_TRAINERROR_HS_WRAPPER/i_rst_n
add wave -noupdate /TB_TRAINERROR_HS_WRAPPER/i_trainerror_en
add wave -noupdate /TB_TRAINERROR_HS_WRAPPER/i_SB_Busy
add wave -noupdate /TB_TRAINERROR_HS_WRAPPER/i_decoded_SB_msg
add wave -noupdate -color Blue /TB_TRAINERROR_HS_WRAPPER/o_encoded_SB_msg
add wave -noupdate /TB_TRAINERROR_HS_WRAPPER/o_TRAINERROR_HS_end
add wave -noupdate -expand -group TX_signals /TB_TRAINERROR_HS_WRAPPER/CS_tx
add wave -noupdate -expand -group TX_signals /TB_TRAINERROR_HS_WRAPPER/NS_tx
add wave -noupdate -expand -group TX_signals /TB_TRAINERROR_HS_WRAPPER/dut/U_TX_TRAINERROR_HS/o_valid_tx
add wave -noupdate -expand -group RX_signals /TB_TRAINERROR_HS_WRAPPER/CS_rx
add wave -noupdate -expand -group RX_signals /TB_TRAINERROR_HS_WRAPPER/NS_rx
add wave -noupdate -expand -group RX_signals /TB_TRAINERROR_HS_WRAPPER/dut/U_RX_TRAINERROR_HS/o_valid_rx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {785 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 171
configure wave -valuecolwidth 175
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
WaveRestoreZoom {763 ns} {807 ns}
