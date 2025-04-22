module SB_RX_WRAPPER (
	input 				i_clk,
	input 				i_rst_n,
	input      [3:0]    i_state,
	input               i_de_ser_done,
	input       [63:0]  i_deser_data,
	output reg          o_rx_sb_start_pattern,
	output reg			o_rx_sb_pattern_samp_done,
	output reg          o_rdi_msg,
	output reg          o_msg_valid,
	output reg          o_parity_error,
	output reg          o_rx_rsp_delivered,
	output reg          o_adapter_enable,
	output reg          o_tx_point_sweep_test_en,
	output reg  [1:0]   o_tx_point_sweep_test,
	output reg  [3:0]   o_msg_no,
	output reg  [2:0]   o_msg_info,
	output reg  [15:0]  o_data,
	output reg  [1:0]   o_rdi_msg_code,
	output reg  [3:0]   o_rdi_msg_sub_code,
	output reg  [1:0]   o_rdi_msg_info,
	output reg          o_de_ser_done_sampled
);

/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
wire header_valid;
wire data_valid;
wire rdi_valid;
wire header_enable;
wire data_enable;
wire rdi_enable;

/*------------------------------------------------------------------------------
-- Blocks Instantiation
------------------------------------------------------------------------------*/
SB_RX_FSM rx_fsm_dut (
	.i_clk                    (i_clk), //
	.i_rst_n                  (i_rst_n), //
	.i_de_ser_done            (i_de_ser_done), //
	.i_header_valid           (header_valid), //
	.i_rdi_valid              (rdi_valid), //
	.i_data_valid             (data_valid), //
	.i_deser_data             (i_deser_data), //
	.i_state                  (i_state), //
	.o_de_ser_done_sampled    (o_de_ser_done_sampled),
	.o_rx_sb_start_pattern    (o_rx_sb_start_pattern), //
	.o_rx_sb_pattern_samp_done(o_rx_sb_pattern_samp_done), //
	.o_msg_valid              (o_msg_valid), //
	.o_header_enable          (header_enable), //
	.o_rdi_enable             (rdi_enable), //
	.o_data_enable            (data_enable), //
	.o_parity_error           (o_parity_error), //
	.o_rx_rsp_delivered       (o_rx_rsp_delivered), //
	.o_adapter_enable         (o_adapter_enable) //
);

SB_RX_HEADER_DECODER rx_header_decoder_dut (
	.i_clk                   (i_clk), //
	.i_rst_n                 (i_rst_n), //
	.i_start_EN              (header_enable), //
	.i_header                (i_deser_data), //
	.o_tx_point_sweep_test_en(o_tx_point_sweep_test_en), //
	.o_tx_point_sweep_test   (o_tx_point_sweep_test), //
	.o_msg_no                (o_msg_no), //
	.o_msg_info              (o_msg_info), //
	.o_dec_header_valid      (header_valid) //
);

SB_DATA_DECODER rx_data_decoder_dut (
	.i_clk        (i_clk), //
	.i_rst_n      (i_rst_n), //
	.i_data_enable(data_enable), //
	.i_header_is_valid_on_bus(header_enable),
	.i_data       (i_deser_data), //
	.o_data_valid (data_valid), //  
	.o_data       (o_data) //
);

SB_RX_RDI_DECODER rx_rdi_decoder_dut (
	.i_clk             (i_clk), //
	.i_rst_n           (i_rst_n), //
	.o_rdi_msg         (o_rdi_msg), //
	.i_rdi_start_EN    (rdi_enable), //
	.i_rdi_header      (i_deser_data), //
	.o_rdi_msg_code    (o_rdi_msg_code), //
	.o_rdi_msg_sub_code(o_rdi_msg_sub_code), //
	.o_rdi_msg_info    (o_rdi_msg_info), //
	.o_rdi_msg_valid   (rdi_valid) //
);



endmodule : SB_RX_WRAPPER
