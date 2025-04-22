module selfcal_wrapper (
	//inputs
		input clk,    // Clock
		input rst_n,  // Asynchronous reset active low
		input i_en, 
	//communcating with sideband 
		input [3:0]  i_decoded_sideband_message ,
		input        i_busy,
		input 		 i_sideband_valid,
	//outputs 
		//communicating with sideband 
			output  [3:0] o_sideband_message ,
			output  o_valid,
		// finishing ack
			output  o_test_ack

);
/*------------------------------------------------------------------------------
--common signals   
------------------------------------------------------------------------------*/
wire o_busy_negedge_detected;
/*------------------------------------------------------------------------------
--tx signals   
------------------------------------------------------------------------------*/
	//output 
		//communcting with sideband
		wire [3:0] o_sideband_message_tx;
		wire       o_valid_tx;
		wire       o_test_ack_tx;
/*------------------------------------------------------------------------------
--rx signals   
------------------------------------------------------------------------------*/
	//output 
		//communcting with sideband
		wire [3:0] o_sideband_message_rx;
		wire       o_valid_rx;
		wire       o_test_ack_rx;
/*------------------------------------------------------------------------------
--assign statements   
------------------------------------------------------------------------------*/
assign o_test_ack=o_test_ack_rx && o_test_ack_tx;
assign o_valid=o_valid_rx || o_valid_tx;
/*------------------------------------------------------------------------------
--tx instantiations   
------------------------------------------------------------------------------*/
selfcal_tx selfcal_tx_inst(
	//inputs 
		 .clk(clk),    // Clock
		 .rst_n(rst_n),  // Asynchronous reset active low
		 .i_en(i_en),
		//communcating with sideband 
		.i_decoded_sideband_message(i_decoded_sideband_message) ,
		//handling_mux_priorities 
		.i_busy_negedge_detected(o_busy_negedge_detected),.i_valid_rx(o_valid_rx),
		.i_sideband_valid          (i_sideband_valid), 
	//output 
		//communcting with sideband
		.o_sideband_message(o_sideband_message_tx),
		.o_valid_tx(o_valid_tx),
		.o_test_ack(o_test_ack_tx)
);
/*------------------------------------------------------------------------------
--rx instantiations   
------------------------------------------------------------------------------*/
selfcal_rx  selfcal_rx_inst(
	//inputs 
		 .clk(clk),    // Clock
		 .rst_n(rst_n),  // Asynchronous reset active low
		 .i_en(i_en),
		//communcating with sideband 
		.i_decoded_sideband_message(i_decoded_sideband_message) ,
		//handling_mux_priorities 
		.i_busy_negedge_detected(o_busy_negedge_detected),.i_valid_tx(o_valid_tx),

	//output 
		//communcting with sideband
		.o_sideband_message(o_sideband_message_rx),
		.o_valid_rx(o_valid_rx),
		//finishing ack
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
/*------------------------------------------------------------------------------
-- negedge detector  
------------------------------------------------------------------------------*/
nedege_detector nedege_detector_inst(
	.clk(clk),    // Clock
	.rst_n(rst_n),  // Asynchronous reset active low
	.i_busy(i_busy),
	.o_busy_negedge_detected(o_busy_negedge_detected)
);
endmodule 
