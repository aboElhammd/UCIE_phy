module vref_cal_wrapper (
	//inputs 
		//main control signlas 
			input clk,    // Clock
			input i_en, // Clock Enable
			input rst_n,  // Asynchronous reset active low
		//communicating with sideband 
			input [3:0]  i_decoded_sideband_message ,
			input 		 i_sideband_valid,
		//communicating with mbtrain 
			input [15:0]i_rx_lanes_result,
			input 		i_mainband_or_valtrain_test, //0 means mainbadnd 1 means valpattern
			input 		i_busy,
			input 		i_falling_edge_busy,
		//
			input    	i_test_ack,
	//outputs 
		//communicating with sideband 
			output [3:0] o_sideband_message ,
			output o_valid,
		//communicating with point test or eye width sweep blocks 
			output o_mainband_or_valtrain_test ,o_test_ack,
			output o_pt_en , o_eye_width_sweep_en,
		//analog component control word 
			output  [3:0] o_reciever_ref_voltage

);

/*------------------------------------------------------------------------------
--tx signals   
------------------------------------------------------------------------------*/
wire o_valid_tx;
wire [3:0] o_sideband_message_tx;
wire o_pt_en_tx, o_eye_width_sweep_en_tx;
wire o_test_ack_tx;
/*------------------------------------------------------------------------------
--rx signals   
------------------------------------------------------------------------------*/
wire o_valid_rx;
wire [3:0] o_sideband_message_rx;
wire o_pt_en_rx, o_eye_width_sweep_en_rx;
wire o_test_ack_rx;
/*------------------------------------------------------------------------------
--assign statements   
------------------------------------------------------------------------------*/
assign o_valid = o_valid_rx || o_valid_tx;
assign o_pt_en=o_pt_en_rx && o_pt_en_tx ;
assign o_eye_width_sweep_en=o_eye_width_sweep_en_rx && o_eye_width_sweep_en_tx;
assign o_test_ack=o_test_ack_rx && o_test_ack_tx; 
/*------------------------------------------------------------------------------
--tx instantiations   
------------------------------------------------------------------------------*/
 vref_cal_tx verf_cal_tx_instance(
	//inputs
		 .clk(clk),    // Clock
		 .rst_n(rst_n),  // Asynchronous reset active low
		 .i_en(i_en), 
		//communcating with sideband 
		 .i_decoded_sideband_message(i_decoded_sideband_message) ,
		//handling_mux_priorities 
		.i_busy_negedge_detected(i_falling_edge_busy),.i_valid_rx(o_valid_rx),
		//test configurations 
		.i_mainband_or_valtrain_test(i_mainband_or_valtrain_test), //0 means mainbadnd 1 means valpattern
		.i_sideband_valid           (i_sideband_valid),
		//communicating with point test 
		.i_rx_lanes_result          (i_rx_lanes_result),
		//communicating with point test 
		.i_test_ack                 (i_test_ack),
	//output 
		//communcting with sideband
		.o_sideband_message(o_sideband_message_tx),
		.o_valid_tx(o_valid_tx),
		//enabling point test block 
		.o_pt_en(o_pt_en_tx),.o_eye_width_sweep_en(o_eye_width_sweep_en_tx),
		.o_mainband_or_valtrain_test(o_mainband_or_valtrain_test) , 
		.o_test_ack(o_test_ack_tx)
);
/*------------------------------------------------------------------------------
--rx_instantiations   
------------------------------------------------------------------------------*/
vref_cal_rx  verf_cal_rx_instance(
	//inputs 
		 .clk(clk),    // Clock
		 .rst_n(rst_n),  // Asynchronous reset active low
		 .i_en(i_en),
		//communcating with sideband 
		 .i_decoded_sideband_message(i_decoded_sideband_message) ,
		 .i_sideband_valid           (i_sideband_valid),
		//handling_mux_priorities 
		.i_busy_negedge_detected(i_falling_edge_busy),.i_valid_tx(o_valid_tx),
		//test configurations 
		.i_mainband_or_valtrain_test(i_mainband_or_valtrain_test), //0 means mainbadnd 1 means valpattern
		.i_rx_lanes_result          (i_rx_lanes_result),
		//communicating with point test 
		.i_test_ack                 (i_test_ack),
	//output 
		//communcting with sideband
		.o_sideband_message(o_sideband_message_rx),
		.o_valid_rx(o_valid_rx),
		//enabling point test block 
		.o_pt_en(o_pt_en_rx),.o_eye_width_sweep_en(o_eye_width_sweep_en_rx),
		//analog component control word 
		.o_reciever_ref_voltage(o_reciever_ref_voltage),
		.o_test_ack(o_test_ack_rx)
);
/*------------------------------------------------------------------------------
--mux instantiations   
------------------------------------------------------------------------------*/
mux_4_to_1 mux_inst(
 	.sel_0(o_valid_tx), .sel_1(o_valid_rx),
	.in_1(4'b0000) , .in_2(o_sideband_message_tx) , .in_3(o_sideband_message_rx) , .in_4(o_sideband_message_rx),
	.out(o_sideband_message)
);

endmodule 
