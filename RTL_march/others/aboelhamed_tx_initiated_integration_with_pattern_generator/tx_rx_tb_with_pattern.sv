module tx_rx_tb_with_pattern ();
/*------------------------------------------------------------------------------
	--enums typedef   
	------------------------------------------------------------------------------*/
	typedef enum logic [2:0] {START_REQ, LFSR_CLEAR_REQ,
	SEND_PATTERN, RESULT_REQ, END_REQ,
	IDLE_TX, TEST_FINISHED}e_tx_states;
	typedef enum logic [2:0] {IDLE,WAIT_FOR_TEST_REQ,WAIT_FOR_LFSR_CLEAR_REQ, CLEAR_LFSR, COMPARE_RESULT, 
	WAIT_FOR_RESULT_REQ, WAIT_FOR_END_REQ,END_RESP} e_rx_states;
	/*------------------------------------------------------------------------------
	--  
	------------------------------------------------------------------------------*/
	e_tx_states tx_cs,tx_ns;
	e_rx_states rx_cs,rx_ns;
		/*------------------------------------------------------------------------------
	--pattern compartor signals   
	------------------------------------------------------------------------------*/
	logic o_generated_0,      o_generated_1,      o_generated_2,      o_generated_3;
    logic o_generated_4,      o_generated_5,      o_generated_6,      o_generated_7;
    logic o_generated_8,      o_generated_9,      o_generated_10,     o_generated_11;
    logic o_generated_12,     o_generated_13,     o_generated_14,     o_generated_15;
	logic [11:0] Max_error_Threshold_per_lane;  // Per-lane comparison threshold (12-bit)
    logic [15:0] Max_error_Threshold_aggregate; // Aggregate error threshold (16-bit)
    // Error outputs
    logic [15:0] per_lane_error;   // Per-lane error bits (if each bit indicates this lane is faulty)
    logic [15:0] error_counter;    // Aggregate error counter
    logic done_result;             // Done signal (1 when test completes)
	
	/*------------------------------------------------------------------------------
	-- tx signals  
	------------------------------------------------------------------------------*/
	logic clk,rst_n;
	//enable and test parameters     
	logic i_en;  // both 
	logic i_mainband_or_valtrain_test; //0 means mainbadn 1 means valpattern
	logic i_pattern_finished; // signal handler
	logic i_lfsr_or_perlane;
	//talking with sideband  
	logic [3:0]i_decoded_sideband_message_tx; //connected to TX
	logic [15:0]i_data_bits_tx ; // Sideband
	//handling muxing priorties 
	wor logic i_busy;logic i_rx_valid=0; // i_rx_valid connected to rx
	logic [3:0]o_encoded_sideband_message_tx; //connected to rx
	logic o_valid_tx; //
	logic o_val_pattern_en;
	logic [1:0]o_mainband_pattern_generator_cw;
	logic [3:0]o_pi_step; //connected to phase interpolator 
	logic o_test_finish_ack_tx; //connected back to fsm itself 
	logic i_busy_tx,i_busy_rx;
	logic o_sb_data_pattern,o_sb_burst_count,o_sb_comparison_mode,o_clear_lfsr;
	logic i_tx_valid;
	logic o_busy_negedge_detected;
	/*------------------------------------------------------------------------------
	--rx_signals   
	------------------------------------------------------------------------------*/
	logic i_comparison_ack ; // comparison ack is connected to signal handler 
	logic [3:0] i_decoded_sideband_message; // TX
	logic [15:0] i_comparison_results;  //not connected to tx
	logic [3:0] i_reciever_ref_voltage; //not connected to tx 
	//outputs 
	logic [3:0] o_encoded_sideband_message_rx ; //TX
	logic [15:0] o_sideband_data; // not connected to tx
	logic o_lfsr_clear,o_valid,o_comparison_mainband_en,o_comparison_valid_en; //valid and comparison main band enable connected to signal handler 
	logic [3:0]o_reciever_ref_volatge;
	//last edit 
	logic i_valid_tx;
	logic [1:0]o_mainband_pattern_compartor_cw;

	/*------------------------------------------------------------------------------
	--tx instantiantoions  
	------------------------------------------------------------------------------*/
	tx_initiated_point_test_tx DUT_tx(.*, .i_decoded_sideband_message(o_encoded_sideband_message_rx) , .i_data_bits(i_data_bits_tx),
	.o_encoded_sideband_message(o_encoded_sideband_message_tx) , .o_valid(o_valid_tx) , .o_test_finish_ack(o_test_finish_ack_tx) , .i_busy_negedge_detected(o_busy_negedge_detected_tx) );
	/*------------------------------------------------------------------------------
	--rx instantiations   
	------------------------------------------------------------------------------*/
	tx_initiated_point_test_rx DUT_rx( .* , .i_decoded_sideband_message(o_encoded_sideband_message_tx) , .o_encoded_sideband_message(o_encoded_sideband_message_rx)
		                              , .o_valid(o_valid_rx) , .i_busy_negedge_detected(o_busy_negedge_detected_rx) , .i_comparison_results(per_lane_error) );
	/*------------------------------------------------------------------------------
	--  updating states 
	------------------------------------------------------------------------------*/
	always @(*) begin
		tx_cs=e_tx_states'(DUT_tx.cs);
		rx_cs=e_rx_states'(DUT_rx.cs);
		tx_ns=e_tx_states'(DUT_tx.ns);
		rx_ns=e_rx_states'(DUT_rx.ns);
	end
	/*------------------------------------------------------------------------------
	-- handling signals that needs ack 
	------------------------------------------------------------------------------*/
	nedege_detector DUT (
	 .* ,  // Asynchronous reset active low
	 .i_busy(i_busy_tx),
      .o_busy_negedge_detected(o_busy_negedge_detected_tx)
	);
	nedege_detector DUT_2 (
	 .* ,  // Asynchronous reset active low
	 .i_busy(i_busy_rx),
      .o_busy_negedge_detected(o_busy_negedge_detected_rx)
	);
	//assign i_busy= i_busy_tx + i_busy_rx ;
	signals_handler sh_inst_1(
	.clk(clk), .rst_n(rst_n),
	.valid(o_valid_tx),
	.busy(i_busy_tx),
	.o_encoded_sideband_message(o_encoded_sideband_message_tx)
	// .req_1(o_mainband_pattern_generator_cw[1]),
	// .ack_1(i_pattern_finished)
	);
	signals_handler sh_inst_2(
	.clk(clk),.rst_n(rst_n),
	.valid(o_valid_rx),
	.busy(i_busy_rx),
	.o_encoded_sideband_message(o_encoded_sideband_message_rx)
	// .req_1(o_mainband_pattern_compartor_cw[1]),
	// .ack_1(i_comparison_ack)
	 );
	/*------------------------------------------------------------------------------
	--clock generation   
	------------------------------------------------------------------------------*/
	initial begin
		clk=0;
		forever begin
			#2clk=~clk;
		end
	end
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////PATTERN GENERATION AND DETECTION ////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/*------------------------------------------------------------------------------
	--PATTERN GENERATOR SIGNALS DECLARATION   
	------------------------------------------------------------------------------*/
    //inputs
    logic serial_lane_0,   serial_lane_1, serial_lane_2,     serial_lane_3;
    logic serial_lane_4,   serial_lane_5,   serial_lane_6,   serial_lane_7;
    logic serial_lane_8,   serial_lane_9,   serial_lane_10,  serial_lane_11;
    logic serial_lane_12,  serial_lane_13,  serial_lane_14,  serial_lane_15;
    //outputs
	logic out_data_lane_0,   out_data_lane_1,   out_data_lane_2,   out_data_lane_3;
    logic out_data_lane_4,   out_data_lane_5,   out_data_lane_6,   out_data_lane_7;
    logic out_data_lane_8,   out_data_lane_9,   out_data_lane_10,  out_data_lane_11;
    logic out_data_lane_12,  out_data_lane_13,  out_data_lane_14,  out_data_lane_15;
    logic done, valid_pattern;                       // Signal to indicate completion of operation
	/*------------------------------------------------------------------------------
	--PATTERN GENERATOR INSTANTIATION   
	------------------------------------------------------------------------------*/
	LFSR_Transmitter pattern_generator(
  	.* , .i_state(o_mainband_pattern_generator_cw),            // State input (IDLE, SCRAMBLE, PATTERN_LFSR, PER_LANE_IDE)
     .enable_scrambeling_pattern(1'b0), 
     .done(i_pattern_finished)                       // Signal to indicate completion of operation
	);
	/*------------------------------------------------------------------------------
	--pattern detector signals   
	------------------------------------------------------------------------------*/
	logic o_pattern_0, o_pattern_1, o_pattern_2, o_pattern_3, o_pattern_4, o_pattern_5;
    logic o_pattern_6, o_pattern_7, o_pattern_8, o_pattern_9, o_pattern_10, o_pattern_11;
    logic o_pattern_12, o_pattern_13, o_pattern_14, o_pattern_15;

    logic out_local_pattern_0,out_local_pattern_1,out_local_pattern_2,out_local_pattern_3,out_local_pattern_4;
    logic out_local_pattern_5,out_local_pattern_6,out_local_pattern_7,out_local_pattern_8,out_local_pattern_9;
    logic out_local_pattern_10,out_local_pattern_11,out_local_pattern_12,out_local_pattern_13,out_local_pattern_14;
    logic out_local_pattern_15;
	/*------------------------------------------------------------------------------
	--pattern detector instantiation   
	------------------------------------------------------------------------------*/
	pattern_detector pattern_detector_inst(
    .i_clk(clk),
    .i_rst_n(rst_n),
    .i_state(o_mainband_pattern_compartor_cw),
    .locally_generated_patterns(1'b0), // Enable scrambling pattern
    .enable_buffer(valid_pattern),                   // Enable for Data Come from buffer
    // Input from Rx data
     .i_pattern_0(out_data_lane_0), .i_pattern_1(out_data_lane_1), .i_pattern_2(out_data_lane_2), .i_pattern_3(out_data_lane_3), .i_pattern_4(out_data_lane_4), .i_pattern_5(out_data_lane_0),
     .i_pattern_6(out_data_lane_6), .i_pattern_7(out_data_lane_7), .i_pattern_8(out_data_lane_8), .i_pattern_9(out_data_lane_9), .i_pattern_10(out_data_lane_10), .i_pattern_11(out_data_lane_0),
     .i_pattern_12(out_data_lane_12), .i_pattern_13(out_data_lane_13), .i_pattern_14(out_data_lane_14), .i_pattern_15(out_data_lane_15),
    // Output of pattern bypass
    .*,
    // Output from locally generated parameter
   	.done(i_comparison_ack)
	);

	/*------------------------------------------------------------------------------
	--pattern compartor instantiation   
	------------------------------------------------------------------------------*/
	pattern_comparison pattern_comparison_inst(
     .clk(clk),                  // Clock signal
     .rst_n(rst_n),                // Asynchronous active-low reset
     .Type_comp(o_mainband_pattern_compartor_cw[0]),            // 1 = Per-lane mode, 0 = Aggregate mode
     .i_state(o_mainband_pattern_compartor_cw),        // State input
     .enable_buffer(valid_pattern),        // Enable

    // Locally generated patterns (16 lanes)
	.*
    // Received patterns (16 lanes)
    // Error threshold inputs
);
	/*------------------------------------------------------------------------------
	--stimulus generation block  
	------------------------------------------------------------------------------*/
	initial begin
		rst_n=0;
		i_en=0;
		i_tx_valid=0;
		Max_error_Threshold_per_lane=2;  // Per-lane comparison threshold (12-bit)
    	Max_error_Threshold_aggregate=2;
		#20;
		rst_n=1;
		i_lfsr_or_perlane=1;
		i_mainband_or_valtrain_test=0;
		i_en=1;
	//	i_comparison_results=16'b1111_1111_1111_1111;
		i_reciever_ref_voltage=4'b1000;
		#20000;
		i_en=0;
		#50	i_en=1;	$stop();
	end

endmodule : tx_rx_tb_with_pattern
