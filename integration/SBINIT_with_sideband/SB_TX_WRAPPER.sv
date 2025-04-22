module SB_TX_WRAPPER (
	input 				i_clk,
	input 				i_rst_n,
	input               i_start_pattern_req,
	input               i_rdi_msg,
	input 				i_data_valid,
	input 				i_msg_valid,
	input 		[2:0] 	i_state,
	input 		[3:0] 	i_sub_state,
	input 		[3:0] 	i_msg_no,
	input       [2:0]   i_msg_info,
	input 		[15:0] 	i_data_bus,
	input               i_rx_sb_pattern_samp_done,
	input               i_rx_sb_rsp_delivered,
	input               i_ser_done,
	input               i_stop_cnt,
	input 				i_tx_point_sweep_test_en,
	input 		[1:0]  	i_tx_point_sweep_test,
	input 		[1:0]	i_rdi_msg_code,
	input 		[3:0] 	i_rdi_msg_sub_code,
	input 		[1:0] 	i_rdi_msg_info,
	output reg          o_start_pattern_done,
	output reg          o_time_out,
	output reg  [63:0]  o_tx_data_out,
	output reg          o_busy 
	);

	reg packet_valid; 
	reg start_count;  
	reg [63:0] framed_packet_phase;
	reg [61:0] header; 
	reg [63:0] data;   
	reg header_valid; 
	reg d_valid; 
	reg header_encoder_enable;
	reg data_encoder_enable;
	reg header_frame_enable;
	reg data_frame_enable;
	reg packet_enable;

	SB_PACKET_ENCODER_WRAPPER packet_encoder_dut (
		.i_clk                    (i_clk),//
		.i_rst_n                  (i_rst_n),//
		.i_start_pattern_req      (i_start_pattern_req),//
		.i_rx_sb_pattern_samp_done(i_rx_sb_pattern_samp_done),//
		.i_rx_sb_rsp_delivered    (i_rx_sb_rsp_delivered),//
		.i_ser_done               (i_ser_done),//
		.o_time_out               (o_time_out),//
		.o_start_pattern_done     (o_start_pattern_done),//
		.i_packet_valid           (packet_valid),//
		.i_timeout_ctr_start      (start_count), //
		.i_framed_packet_phase    (framed_packet_phase), //
		.o_final_packet           (o_tx_data_out), //
		.i_stop_cnt               (i_stop_cnt) //
	);

	SB_PACKET_FRAMING packet_framing_dut (
		.i_clk                (i_clk), //
		.i_rst_n              (i_rst_n), //
		.i_ser_done           (i_ser_done), //
		.i_header             (header), //
		.i_data               (data), //
		.i_header_valid       (header_frame_enable), //
		.i_d_valid            (data_frame_enable), //
		.o_framed_packet_phase(framed_packet_phase), //
		.o_timeout_ctr_start  (start_count), //
		.o_packet_valid       (packet_valid) //
	);


	SB_HEADER_ENCODER header_encoder_dut (
		.i_clk             (i_clk), //
		.i_rst_n           (i_rst_n), //
		.i_rdi_msg         (i_rdi_msg), //
		.i_data_valid      (data_encoder_enable), //
		.i_msg_valid       (header_encoder_enable), //
		.i_state           (i_state), //
		.i_sub_state       (i_sub_state), //
		.i_msg_no          (i_msg_no), //
		.i_msg_info        (i_msg_info), //
		.o_header          (header), //
		.o_header_valid    (header_valid), //
		.i_rdi_msg_code          (i_rdi_msg_code), //
		.i_rdi_msg_info          (i_rdi_msg_info), //
		.i_rdi_msg_sub_code      (i_rdi_msg_sub_code), //
		.i_tx_point_sweep_test   (i_tx_point_sweep_test), //
		.i_tx_point_sweep_test_en(i_tx_point_sweep_test_en) //
	);

	SB_DATA_ENCODER data_encoder_dut (
		.i_clk         (i_clk), //
		.i_rst_n       (i_rst_n), //
		.i_data_valid  (data_encoder_enable), //
		.i_msg_valid   (header_encoder_enable), //
		.i_state       (i_state), //
		.i_sub_state   (i_sub_state), //
		.i_msg_no      (i_msg_no), //
		.i_data_bus    (i_data_bus), //
		.o_data_encoded(data), //
		.o_d_valid     (d_valid), //
		.i_rdi_msg               (i_rdi_msg), //
		.i_tx_point_sweep_test   (i_tx_point_sweep_test), //
		.i_tx_point_sweep_test_en(i_tx_point_sweep_test_en) //
	);

	SB_FSM sb_fsm_dut (
		.i_clk                  (i_clk), //
		.i_rst_n                (i_rst_n), //
		.i_msg_valid            (i_msg_valid), //
		.i_data_valid           (i_data_valid),
		.i_start_pattern_req    (i_start_pattern_req), //
		.i_rx_sb_rsp_delivered  (i_rx_sb_rsp_delivered), //
		.i_d_valid              (d_valid), //
		.i_header_valid         (header_valid), //
		.i_packet_valid         (packet_valid), //
		.i_start_pattern_done   (o_start_pattern_done), //
		.o_header_encoder_enable(header_encoder_enable), //
		.o_data_encoder_enable  (data_encoder_enable), //
		.o_header_frame_enable  (header_frame_enable), //
		.o_data_frame_enable    (data_frame_enable), //
		//.o_packet_enable        (packet_enable), //
		.o_busy                 (o_busy) //
		);

endmodule : SB_TX_WRAPPER
