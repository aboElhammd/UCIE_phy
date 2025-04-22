module tx_initiated_point_test_wrapper (
	//inputs 
		//main signals 
			input        clk,    // Clock
			input        i_en, // Clock Enable
			input        rst_n,  // Asynchronous reset active low
		//test paramters 
			input        i_mainband_or_valtrain_test, //0 means mainbadnd 1 means valpattern
			input        i_lfsr_or_perlane  ,   // 0 means lfsr test 1 means perlane 
		//communcating with pattern generators 
			input        i_pattern_finished , 
		//talking with sideband 
			input [3:0]  i_sideband_message,
			input [15:0] i_sideband_data, //takes from it the main band lanes result 
			input 		 i_busy,i_sideband_message_valid,
			input 	     i_falling_edge_busy,
			input 		 i_msg_info , // new //one bit that represents valid result from partner 
		//communictating with pattern compartors 
			input [15:0] i_comparison_results, //comes from mainband pattern detectors and represents remote partner result
			input 		 i_valid_result, // new //comes from valid pattern compartor
	//outputs 
		//communicating with sideband 
			output  [3:0]  o_sideband_message,
			output 		   o_valid,o_data_valid,
			output         o_msg_info,//new //one bit that represents valid lane result 
			output  [15:0] o_sideband_data, 
		//controling pattern generator 
			output  	   o_val_pattern_en,
			output  [1:0]  o_mainband_pattern_generator_cw,
		//communcating with pattern compartors 
			output  [1:0]  o_mainband_pattern_compartor_cw,
			output  	   o_comparison_valid_en,
		//communicating with the block that enabled the 
			output 		   o_test_ack,
			output 		   o_valid_result, //new
			output [15:0]  o_mainband_lanes_result //new
);
/*------------------------------------------------------------------------------
--tx signals   
------------------------------------------------------------------------------*/
	//outputs
		wire [3:0]	o_sideband_message_tx;
		wire 		o_valid_tx, o_data_valid_tx;
		wire 		o_test_ack_tx; 
		wire [15:0] o_sideband_data_tx;
/*------------------------------------------------------------------------------
--rx signals  
------------------------------------------------------------------------------*/
	//outputs
		wire [3:0]	o_sideband_message_rx;
		wire 		o_valid_rx, o_data_valid_rx;
		wire 		o_test_ack_rx; 
		wire [15:0] o_sideband_data_rx;
/*------------------------------------------------------------------------------
--assign statements  
------------------------------------------------------------------------------*/
assign o_valid     = o_valid_tx    || o_valid_rx ;
assign o_test_ack  = o_test_ack_tx && o_test_ack_rx ;
assign o_data_valid= o_data_valid_rx || o_data_valid_tx;
assign o_mainband_lanes_result=i_sideband_data;
assign o_valid_result=i_msg_info;
/*------------------------------------------------------------------------------
--tx instantiations  
------------------------------------------------------------------------------*/
 tx_initiated_point_test_tx tx_initiated_point_test_tx_inst(
	//inputs 
		.clk(clk),
		.rst_n(rst_n),
		//enable and test parameters     
		.i_en(i_en), 
		.i_mainband_or_valtrain_test(i_mainband_or_valtrain_test), //0 means mainbadnd 1 means valpattern
		.i_lfsr_or_perlane(i_lfsr_or_perlane)  ,   // 0 means lfsr test 1 means perlane 
		//communcating with pattern generators 
		.i_pattern_finished(i_pattern_finished) , 
		//talking with sideband 
		.i_sideband_message(i_sideband_message),
		.i_sideband_data(i_sideband_data),
		.i_sideband_message_valid       (i_sideband_message_valid),
		//handling muxing priorties 
		.i_busy_negedge_detected(i_falling_edge_busy), .i_valid_rx(o_valid_rx),
	//outputs
		//sideband outputs 
		.o_sideband_message(o_sideband_message_tx),
		.o_valid_tx(o_valid_tx),
		.o_sideband_data                (o_sideband_data_tx),
		.o_data_valid                   (o_data_valid_tx),
		//controling pattern generator 
		.o_val_pattern_en(o_val_pattern_en),
		.o_mainband_pattern_generator_cw(o_mainband_pattern_generator_cw),
		//finishing ack
		.o_test_ack_tx(o_test_ack_tx)
);
/*------------------------------------------------------------------------------
--rx instantiations  
------------------------------------------------------------------------------*/
tx_initiated_point_test_rx tx_initiated_point_test_rx_inst(
	//inputs 
		.clk(clk),
		.rst_n(rst_n),
		.i_en(i_en) ,
		//handling muxing priority
		.i_valid_tx(o_valid_tx),
		.i_busy_negedge_detected(i_falling_edge_busy),
		//test configurations inputs  // need to check the source of these signals 
		.i_mainband_or_valtrain_test(i_mainband_or_valtrain_test),
		.i_lfsr_or_perlane(i_lfsr_or_perlane),
		//communicting with sideband 
		.i_sideband_message(i_sideband_message),
		.i_sideband_message_valid       (i_sideband_message_valid),
		//communictating with pattern compartors 
		.i_comparison_results(i_comparison_results),
		.i_valid_result(i_valid_result),
		//communcitaing with analog 
	//outputs
		//communccating with sideband data  
		.o_sideband_message(o_sideband_message_rx),
		.o_sideband_data(o_sideband_data_rx),
		.o_valid_rx(o_valid_rx),
		.o_data_valid(o_data_valid_rx),
		.o_msg_info(o_msg_info),
		//communcating with pattern compartors 
		.o_mainband_pattern_compartor_cw(o_mainband_pattern_compartor_cw),
		.o_comparison_valid_en(o_comparison_valid_en),
		//finishing ack 
		.o_test_ack_rx(o_test_ack_rx)

);

/*------------------------------------------------------------------------------
--muxing tx and rx   
------------------------------------------------------------------------------*/
 mux_4_to_1 mux_4_to_1_inst(
	.sel_0(o_valid_tx), .sel_1(o_valid_rx),
	.in_1(4'b0000) ,  
	.in_2(o_sideband_message_tx) ,
	.in_3(o_sideband_message_rx) ,
	.in_4(o_sideband_message_rx),
    .out(o_sideband_message)
);
 /*------------------------------------------------------------------------------
 --MUXING TX AND RX   
 ------------------------------------------------------------------------------*/
  mux_4_to_1  #(.WIDTH(16)) mux_4_to_1_inst_2(
	.sel_0(o_data_valid_tx), .sel_1(o_data_valid_rx),
	.in_1(16'h0000) ,  
	.in_2(o_sideband_data_tx) ,
	.in_3(o_sideband_data_rx) ,
	.in_4(o_sideband_data_rx),
    .out (o_sideband_data)
);
endmodule : tx_initiated_point_test_wrapper
