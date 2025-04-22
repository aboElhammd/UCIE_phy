module SB_PACKET_ENCODER_WRAPPER (
	input 				i_clk,    
	input 				i_rst_n,
	input 				i_start_pattern_req,
	input 				i_rx_sb_pattern_samp_done,
	input 				i_rx_sb_rsp_delivered,
	input 				i_packet_valid,
	input               i_stop_cnt,
	input 				i_ser_done,
	input 				i_timeout_ctr_start,
	input 	   [63:0] 	i_framed_packet_phase,
	output reg 			o_start_pattern_done,
	output reg 			o_time_out,
	output reg          o_pattern_valid,
	output reg [63:0] 	o_final_packet	
);
/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
wire pattern_time_out;
wire[63:0] pattern;

/*------------------------------------------------------------------------------
-- Blocks Instantiation
------------------------------------------------------------------------------*/
SB_PATTERN_GEN gen_dut(
	.i_clk                    (i_clk),//
	.i_rst_n                  (i_rst_n),//
	.i_start_pattern_req      (i_start_pattern_req),//
	.i_rx_sb_pattern_samp_done(i_rx_sb_pattern_samp_done),//
	.i_ser_done               (i_ser_done),//
	.o_start_pattern_done     (o_start_pattern_done),//
	.o_pattern_time_out       (pattern_time_out),//
	.o_pattern                (pattern),//
	.o_pattern_valid          (o_pattern_valid)//
);

TIME_OUT_COUNTER time_out_dut (
	.i_clk                (i_clk),//
	.i_rst_n              (i_rst_n),//
	.i_rx_sb_rsp_delivered(i_rx_sb_rsp_delivered),//
	.o_time_out           (o_time_out),//
	.i_start_cnt          (i_timeout_ctr_start),//
	.i_pattern_time_out   (pattern_time_out),//
	.i_stop_cnt           (i_stop_cnt)//
);

SB_PACKET_ENCODER_MUX encoder_mux_dut (
	.i_framed_packet_phase(i_framed_packet_phase),//
	.o_final_packet       (o_final_packet),//
	.i_pattern            (pattern),//
	.i_pattern_valid      (o_pattern_valid),//
	.i_packet_valid       (i_packet_valid)//
	);

endmodule : SB_PACKET_ENCODER_WRAPPER
