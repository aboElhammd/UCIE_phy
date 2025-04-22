onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB_LTSM_with_sideband/i_clk
add wave -noupdate /TB_LTSM_with_sideband/i_rst_n
add wave -noupdate /TB_LTSM_with_sideband/module_start_pattern_req
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg
add wave -noupdate /TB_LTSM_with_sideband/module_data_valid
add wave -noupdate /TB_LTSM_with_sideband/module_msg_valid
add wave -noupdate /TB_LTSM_with_sideband/module_state
add wave -noupdate /TB_LTSM_with_sideband/module_sub_state
add wave -noupdate /TB_LTSM_with_sideband/module_msg_info
add wave -noupdate /TB_LTSM_with_sideband/module_data_bus
add wave -noupdate -color Cyan /TB_LTSM_with_sideband/module_ser_done
add wave -noupdate /TB_LTSM_with_sideband/module_stop_cnt
add wave -noupdate /TB_LTSM_with_sideband/module_tx_point_sweep_test_en
add wave -noupdate /TB_LTSM_with_sideband/module_tx_point_sweep_test
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg_code
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg_sub_code
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg_info
add wave -noupdate /TB_LTSM_with_sideband/module_de_ser_done
add wave -noupdate /TB_LTSM_with_sideband/module_deser_data
add wave -noupdate /TB_LTSM_with_sideband/module_start_pattern_done
add wave -noupdate /TB_LTSM_with_sideband/module_time_out
add wave -noupdate /TB_LTSM_with_sideband/module_busy
add wave -noupdate /TB_LTSM_with_sideband/module_rx_sb_start_pattern
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg_out
add wave -noupdate /TB_LTSM_with_sideband/module_msg_valid_out
add wave -noupdate /TB_LTSM_with_sideband/module_parity_error
add wave -noupdate /TB_LTSM_with_sideband/module_adapter_enable
add wave -noupdate /TB_LTSM_with_sideband/module_tx_point_sweep_test_out
add wave -noupdate /TB_LTSM_with_sideband/module_msg_no_out
add wave -noupdate /TB_LTSM_with_sideband/module_msg_info_out
add wave -noupdate /TB_LTSM_with_sideband/module_data_out
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg_code_out
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg_sub_code_out
add wave -noupdate /TB_LTSM_with_sideband/module_rdi_msg_info_out
add wave -noupdate /TB_LTSM_with_sideband/partner_start_pattern_req
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg
add wave -noupdate /TB_LTSM_with_sideband/partner_data_valid
add wave -noupdate /TB_LTSM_with_sideband/partner_msg_valid
add wave -noupdate /TB_LTSM_with_sideband/partner_state
add wave -noupdate /TB_LTSM_with_sideband/partner_sub_state
add wave -noupdate /TB_LTSM_with_sideband/partner_msg_no
add wave -noupdate /TB_LTSM_with_sideband/partner_msg_info
add wave -noupdate /TB_LTSM_with_sideband/partner_data_bus
add wave -noupdate /TB_LTSM_with_sideband/partner_ser_done
add wave -noupdate /TB_LTSM_with_sideband/partner_stop_cnt
add wave -noupdate /TB_LTSM_with_sideband/partner_tx_point_sweep_test_en
add wave -noupdate /TB_LTSM_with_sideband/partner_tx_point_sweep_test
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg_code
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg_sub_code
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg_info
add wave -noupdate /TB_LTSM_with_sideband/partner_de_ser_done
add wave -noupdate /TB_LTSM_with_sideband/partner_start_pattern_done
add wave -noupdate /TB_LTSM_with_sideband/partner_time_out
add wave -noupdate /TB_LTSM_with_sideband/partner_busy
add wave -noupdate /TB_LTSM_with_sideband/partner_rx_sb_start_pattern
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg_out
add wave -noupdate /TB_LTSM_with_sideband/partner_msg_valid_out
add wave -noupdate /TB_LTSM_with_sideband/partner_parity_error
add wave -noupdate /TB_LTSM_with_sideband/partner_adapter_enable
add wave -noupdate /TB_LTSM_with_sideband/partner_tx_point_sweep_test_out
add wave -noupdate -color Yellow /TB_LTSM_with_sideband/module_msg_no
add wave -noupdate -color Yellow /TB_LTSM_with_sideband/partner_msg_no_out
add wave -noupdate /TB_LTSM_with_sideband/partner_msg_info_out
add wave -noupdate /TB_LTSM_with_sideband/partner_data_out
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg_code_out
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg_sub_code_out
add wave -noupdate /TB_LTSM_with_sideband/partner_rdi_msg_info_out
add wave -noupdate -color Cyan /TB_LTSM_with_sideband/TX_module_data
add wave -noupdate -color Cyan /TB_LTSM_with_sideband/RX_module_data
add wave -noupdate /TB_LTSM_with_sideband/module_busy_reg
add wave -noupdate /TB_LTSM_with_sideband/partner_busy_reg
add wave -noupdate /TB_LTSM_with_sideband/falling_edge_busy_module
add wave -noupdate /TB_LTSM_with_sideband/falling_edge_busy_partner
add wave -noupdate /TB_LTSM_with_sideband/mod_tx_data_reg1
add wave -noupdate /TB_LTSM_with_sideband/mod_tx_data_reg2
add wave -noupdate /TB_LTSM_with_sideband/mod_tx_data_reg3
add wave -noupdate /TB_LTSM_with_sideband/partner_tx_data_reg1
add wave -noupdate /TB_LTSM_with_sideband/partner_tx_data_reg2
add wave -noupdate /TB_LTSM_with_sideband/partner_tx_data_reg3
add wave -noupdate -label Module_tx_cs /TB_LTSM_with_sideband/Module/tx_wrapper/sb_fsm_dut/cs
add wave -noupdate -label Module_rx_cs /TB_LTSM_with_sideband/Module/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -label Partner_tx_cs /TB_LTSM_with_sideband/Partner/tx_wrapper/sb_fsm_dut/cs
add wave -noupdate -label Partner_rx_cs /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -color Cyan /TB_LTSM_with_sideband/TX_partner_data
add wave -noupdate -color Cyan /TB_LTSM_with_sideband/RX_partner_data
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_clk
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_rst_n
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_header
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test_en
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_tx_point_sweep_test
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_msg_no
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_msg_info
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/o_dec_header_valid
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/test_type_reg
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/i_start_EN
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/MsgCode
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/MsgSubCode
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/Opcode
add wave -noupdate -group {Header Decoder} -color {Dark Orchid} /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_header_decoder_dut/MsgInfo
add wave -noupdate -group {RX FSM} -label Partner_rx_cs /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/RESET
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_clk
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_rst_n
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_de_ser_done
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_header_valid
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_rdi_valid
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_data_valid
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_deser_data
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/i_state
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_msg_valid
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_header_enable
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rdi_enable
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_data_enable
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_parity_error
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_adapter_enable
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/cs
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/ns
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_start_pattern_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_sb_pattern_samp_done_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_msg_valid_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_header_enable_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rdi_enable_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_data_enable_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_parity_error_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_rx_rsp_delivered_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/o_adapter_enable_reg
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/MsgCode
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/Partner/rx_wrapper/rx_fsm_dut/MsgCode_part_2
add wave -noupdate -group {RX FSM} -color Yellow /TB_LTSM_with_sideband/