module SB_RX_WRAPPER (
	input 				i_clk,
	input               i_clk_pll,
	input               RXCKSB,
	input 				i_rst_n,
	//input               i_de_ser_done,
	input            	RXDATASB,
	input      [3:0]    i_state,
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
	output reg  [1:0]   o_rdi_msg_info
	);


reg header_valid;
reg data_valid;
reg rdi_valid;
reg header_enable;
reg data_enable;
reg rdi_enable;
 
wire [63:0] deser_data;
wire  de_ser_done;
wire de_ser_done_sync;
wire de_ser_done_sampled;

SB_RX_DESER rx_deser_dut (
	.i_clk       (RXCKSB),
	.i_clk_pll   (i_clk_pll),
	.i_rst_n     (i_rst_n),
	.ser_data_in (RXDATASB),
	.i_de_ser_done_sampled(de_ser_done_sampled),
	.par_data_out(deser_data),
	.de_ser_done (de_ser_done)
);

// DF_SYNC #(
// 	.WIDTH(1) ) 
// ff_sync (
// 	.clk       (i_clk),
// 	.rst_n     (i_rst_n),
// 	.async_data(de_ser_done),
// 	.sync_data (de_ser_done_sync)
// );

SB_RX_FSM rx_fsm_dut (
	.i_clk                    (i_clk), //
	.i_rst_n                  (i_rst_n), //
	.i_de_ser_done            (de_ser_done), //
	.i_header_valid           (header_valid), //
	.i_rdi_valid              (rdi_valid), //
	.i_data_valid             (data_valid), //
	.i_deser_data             (deser_data), //
	.i_state                  (i_state), //
	.o_de_ser_done_sampled    (de_ser_done_sampled),
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
	.i_header                (deser_data), //
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
	.i_data       (deser_data), //
	.o_data_valid (data_valid), //  
	.o_data       (o_data) //
);

SB_RX_RDI_DECODER rx_rdi_decoder_dut (
	.i_clk             (i_clk), //
	.i_rst_n           (i_rst_n), //
	.o_rdi_msg         (o_rdi_msg), //
	.i_rdi_start_EN    (rdi_enable), //
	.i_rdi_header      (deser_data), //
	.o_rdi_msg_code    (o_rdi_msg_code), //
	.o_rdi_msg_sub_code(o_rdi_msg_sub_code), //
	.o_rdi_msg_info    (o_rdi_msg_info), //
	.o_rdi_msg_valid   (rdi_valid) //
);



endmodule : SB_RX_WRAPPER
