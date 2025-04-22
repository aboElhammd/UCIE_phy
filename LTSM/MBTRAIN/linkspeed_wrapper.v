module linkspeed_wrapper (
	//inputs 
	    //main control signals 
		    input clk,    // Clock
		    input rst_n,  // Asynchronous reset active low
		    input i_en ,
		// talkinh with sideband 
		    input [3:0] i_sideband_message,
		    input i_busy,
			input i_falling_edge_busy,
			input i_sideband_valid,
	    //talking with point test block 
		  	input i_point_test_ack ,  
		    input [15:0]i_lanes_result, 
	    //still doesn't have a source 
		    input i_valid_framing_error,
		//communicating with mbtrain controller 
		    input i_first_8_tx_lanes_are_functional ,i_second_8_tx_lanes_are_functional,
		    input i_comming_from_repair,
    //outputs
	    //talking with sideband 
	   		output        o_timeout_disable, o_valid ,
	   		output [3:0]  o_sideband_message  ,
	    //talking with MBTRAIN fsm
			output        o_link_speeed_ack ,
			//next state flags
			output        o_phy_retrain_req_was_sent_or_received,o_error_req_was_sent_or_received, 
		                  o_speed_degrade_req_was_sent_or_received, o_repair_req_was_sent_or_received,
		//talking with phyretrain new 
			output  [1:0] o_phyretrain_error_encoding ,
		//talking with mbtrain controller new
			output        o_local_first_8_lanes_are_functional ,o_local_second_8_lanes_are_functional,
		// talking with point test 
		 	output        o_point_test_en	 , o_tx_lfsr_or_perlane , o_tx_mainband_or_valtrain_test 
);

/*------------------------------------------------------------------------------
--tx signals  
------------------------------------------------------------------------------*/
wire [3:0] o_sideband_message_tx;
wire       o_valid_tx;
wire       o_test_ack_tx,o_point_test_en_tx;
/*------------------------------------------------------------------------------
--rx signals   
------------------------------------------------------------------------------*/
wire [3:0] o_sideband_message_rx;
wire       o_valid_rx;
wire       o_test_ack_rx,o_point_test_en_rx;
/*------------------------------------------------------------------------------
--output signals that comes from both tx and rx  
------------------------------------------------------------------------------*/
//talking with MBTRAIN FSM
	assign o_link_speeed_ack = o_test_ack_rx && o_test_ack_tx;
//talking with point test 
	assign o_point_test_en   = o_point_test_en_rx && o_point_test_en_tx ;
//talkind with sideband 
	assign o_valid= o_valid_rx || o_valid_tx;  
/*------------------------------------------------------------------------------
--tx instantiations   
----------------------------------------.--------------------------------------*/
linkspeed_tx linkspeed_tx_inst(
	.clk                             (clk),
	.rst_n                           (rst_n),
	.i_sideband_message              (i_sideband_message),
	.i_rx_valid                      (o_valid_rx), // signal from rx 
	.i_point_test_ack                (i_point_test_ack),
	.i_sideband_valid				 (i_sideband_valid),
	.i_en(i_en) ,
	.i_busy_negedge_detected(i_falling_edge_busy) ,// comes from negedeg detector 
	.i_valid_framing_error (i_valid_framing_error) ,
	.i_lanes_result (i_lanes_result) ,
	//communicating with mbtrain controller 
    .i_first_8_tx_lanes_are_functional (i_first_8_tx_lanes_are_functional) ,
    .i_second_8_tx_lanes_are_functional(i_second_8_tx_lanes_are_functional),
    .i_comming_from_repair(i_comming_from_repair),
    // Outputs 
    //talking with point test 
    .o_test_ack(o_test_ack_tx), .o_point_test_en(o_point_test_en_tx) ,
    .o_tx_mainband_or_valtrain_test          (o_tx_mainband_or_valtrain_test),
    .o_tx_lfsr_or_perlane(o_tx_lfsr_or_perlane) ,
    // Talking with sideband 
	    .o_sideband_message              (o_sideband_message_tx),
	    .o_valid_tx                      (o_valid_tx),
	    .o_timeout_disable(o_timeout_disable),
   // Talking with MBTRAIN FSM
		.o_phy_retrain_req_was_sent_or_received(o_phy_retrain_req_was_sent_or_received),.o_error_req_was_sent_or_received(o_error_req_was_sent_or_received), 
		.o_speed_degrade_req_was_sent_or_received(o_speed_degrade_req_was_sent_or_received), 
		.o_repair_req_was_sent_or_received(o_repair_req_was_sent_or_received) ,
		//communicating with phy_Retrain
		.o_phyretrain_error_encoding(o_phyretrain_error_encoding),
		//talking with mbtrain controller
		.o_local_first_8_lanes_are_functional(o_local_first_8_lanes_are_functional) ,
		.o_local_second_8_lanes_are_functional(o_local_second_8_lanes_are_functional)
);
/*------------------------------------------------------------------------------
--rx instantiations   
------------------------------------------------------------------------------*/
linkspeed_rx linkspeed_rx_inst(
	.clk(clk),    // Clock
	.rst_n(rst_n),  // Asynchronous reset active low
	.i_sideband_message(i_sideband_message),
	.i_tx_valid(o_valid_tx),.i_en(i_en),
	.i_sideband_valid(i_sideband_valid),
	.i_point_test_ack(i_point_test_ack),
	.i_valid_framing_error(i_valid_framing_error), 
	.i_busy_negedge_detected(i_falling_edge_busy), // comes from negedeg detector 
	.i_lanes_result(i_lanes_result),
	//communicating with mbtrain controller 
    .i_first_8_tx_lanes_are_functional (i_first_8_tx_lanes_are_functional) ,
    .i_second_8_tx_lanes_are_functional(i_second_8_tx_lanes_are_functional),
    .i_comming_from_repair(i_comming_from_repair),
	//outputs 
		//talking with side band 
			.o_sideband_message(o_sideband_message_rx) ,
			.o_valid_rx(o_valid_rx),
		//talknig with point test block 
			.o_point_test_en(o_point_test_en_rx) , .o_test_ack(o_test_ack_rx)


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
