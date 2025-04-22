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
			input [15:0] i_sideband_data,
			input 		 i_busy,i_sideband_message_valid,
		//communictating with pattern compartors 
			input [15:0] i_comparison_results,
		//communcitaing with analog 
			input [3:0]  i_reciever_ref_voltage,
	//outputs 
		//communicating with sideband 
			output  [3:0]  o_sideband_message,
			output 		   o_valid,
			output  [15:0] o_sideband_data,
			output         o_sb_data_pattern ,
			               o_sb_burst_count  ,
			               o_sb_comparison_mode,
		//controling pattern generator 
			output  	   o_val_pattern_en,
			output  [1:0]  o_mainband_pattern_generator_cw,
		//communcating with pattern compartors 
			output  [1:0]  o_mainband_pattern_compartor_cw,
			output  	   o_comparison_valid_en,
		//analog componenets control word 
			output  [3:0]  o_pi_step,
		//analog componenets control word
			output  [3:0]  o_reciever_ref_volatge,
		//finishing ack 
			output 		   o_test_ack
);
/*------------------------------------------------------------------------------
--tx signals   
------------------------------------------------------------------------------*/
	//outputs
		wire [3:0]o_sideband_message_tx;
		wire o_valid_tx;
		wire o_test_ack_tx; 
/*------------------------------------------------------------------------------
--rx signals  
------------------------------------------------------------------------------*/
	//outputs
		wire [3:0]o_sideband_message_rx;
		wire o_valid_rx;
		wire o_test_ack_rx; 
/*------------------------------------------------------------------------------
--negedge detector signals   
------------------------------------------------------------------------------*/
wire o_busy_negedge_detected;
/*------------------------------------------------------------------------------
--assign statements  
------------------------------------------------------------------------------*/
assign o_valid    = o_valid_tx    || o_valid_rx ;
assign o_test_ack = o_test_ack_tx && o_test_ack_rx ;
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
		.i_busy_negedge_detected(o_busy_negedge_detected), .i_valid_rx(o_valid_rx),
	//outputs
		//sideband outputs 
		.o_sideband_message(o_sideband_message_tx),
		.o_valid_tx(o_valid_tx),
		.o_sb_data_pattern(o_sb_data_pattern) ,
		.o_sb_burst_count(o_sb_burst_count)   ,
		.o_sb_comparison_mode(o_sb_comparison_mode),
		//controling pattern generator 
		.o_val_pattern_en(o_val_pattern_en),
		.o_mainband_pattern_generator_cw(o_mainband_pattern_generator_cw),
		//analog componenets control word 
		.o_pi_step(o_pi_step),
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
		.i_busy_negedge_detected(o_busy_negedge_detected),
		//test configurations inputs  // need to check the source of these signals 
		.i_mainband_or_valtrain_test(i_mainband_or_valtrain_test),
		.i_lfsr_or_perlane(i_lfsr_or_perlane),
		//communicting with sideband 
		.i_sideband_message(i_sideband_message),
		.i_sideband_message_valid       (i_sideband_message_valid),
		//communictating with pattern compartors 
		.i_comparison_results(i_comparison_results),
		//communcitaing with analog 
		.i_reciever_ref_voltage(i_reciever_ref_voltage),
	//outputs
		//communccating with sideband data  
		.o_sideband_message(o_sideband_message_rx),
		.o_sideband_data(o_sideband_data),
		.o_valid_rx(o_valid_rx),
		//communcating with pattern compartors 
		.o_mainband_pattern_compartor_cw(o_mainband_pattern_compartor_cw),
		.o_comparison_valid_en(o_comparison_valid_en),
		//analog componenets control word
		.o_reciever_ref_volatge(o_reciever_ref_volatge),
		//finishing ack 
		.o_test_ack_rx(o_test_ack_rx)

);
/*------------------------------------------------------------------------------
--negdeg detector   
------------------------------------------------------------------------------*/
nedege_detector nedege_detector_inst(
	.clk(clk),    // Clock
	.rst_n(rst_n),  // Asynchronous reset active low
	.i_busy(i_busy),
	.o_busy_negedge_detected(o_busy_negedge_detected)
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
endmodule : tx_initiated_point_test_wrapper
