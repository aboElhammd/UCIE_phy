module repair_wrapper (
	//inputs 
		//main signals 
			input clk,    
			input i_en, 
			input rst_n, 
		//communicating with sideband 
		    input [3:0] i_sideband_message,
		    input i_busy,
			input i_falling_edge_busy,
			input [2:0]i_sideband_data_lanes_encoding,
			input i_sideband_valid,
		//
			input i_first_8_lanes_are_functional , i_second_8_lanes_are_functional,
	//outputs 
		//communicating with sideband 
			output   o_valid,
			output [2:0] o_sideband_data_lanes_encoding ,
			output [3:0] o_sideband_message,
		//returning results back to mbtrain
			output o_remote_partner_first_8_lanes_result , o_remote_partner_second_8_lanes_result,
		//finishing ack
			output o_test_ack 

);

/*------------------------------------------------------------------------------
--tx signals   
------------------------------------------------------------------------------*/
//outputs
    //communicating with sideband  
	    wire  [3:0] o_sideband_message_tx;
	    wire  o_valid_tx ;
	    wire o_test_ack_tx;
/*------------------------------------------------------------------------------
--rx signals   
------------------------------------------------------------------------------*/
    //outputs 
    	//communicating with sideband 
	    	wire [3:0] o_sideband_message_rx;
	    	wire o_valid_rx;
	    	wire o_test_ack_rx;
/*------------------------------------------------------------------------------
--assign statements   
------------------------------------------------------------------------------*/
	assign o_valid= o_valid_tx || o_valid_rx;
	assign o_test_ack=o_test_ack_rx&& o_test_ack_tx;
/*------------------------------------------------------------------------------
--tx instantiation  
------------------------------------------------------------------------------*/
repair_tx repair_tx_instance_1(
	//inputs 
		//main signals 
			.clk(clk),
			.rst_n(rst_n),
			.i_en(i_en),
	    //communicating with sideband 
			.i_sideband_message(i_sideband_message),
			.i_busy_negedge_detected(i_falling_edge_busy),
			.i_sideband_valid(i_sideband_valid),
	    //communicating with MBTRAIN
		    .i_first_8_lanes_are_functional(i_first_8_lanes_are_functional) ,
		    .i_second_8_lanes_are_functional(i_second_8_lanes_are_functional),
	    //communicating with rx 
		    .i_valid_rx(o_valid_rx),
    //outputs
	    //communicating with sideband  
		    .o_sideband_message(o_sideband_message_tx),
		    .o_valid_tx(o_valid_tx),
		   .o_sideband_data_lanes_encoding(o_sideband_data_lanes_encoding),
	    // communciating with mbtrain 
		    .o_test_ack(o_test_ack_tx)
);
/*------------------------------------------------------------------------------
--rx instantiations  
------------------------------------------------------------------------------*/
repair_rx repair_rx_instance_1(
	//inputs 
		//main control signals 
			.clk(clk),
			.rst_n(rst_n),
			.i_en(i_en),
	    ///communicating with side band 
		    .i_sideband_message(i_sideband_message),
		    .i_sideband_data_lanes_encoding(i_sideband_data_lanes_encoding),
		    .i_busy_negedge_detected(i_falling_edge_busy),
	    //communicating with tx
		    .i_valid_tx(o_valid_tx),
    //outputs 
	    //communicating with sideband 
		     .o_sideband_message(o_sideband_message_rx),
		     .o_valid_rx(o_valid_rx),
	    //communicating with mbtrain 
		    .o_test_ack(o_test_ack_rx),
	    //results from remote link partner given back to mbtrain  
		   .o_remote_partner_first_8_lanes_result(o_remote_partner_first_8_lanes_result) ,
		    .o_remote_partner_second_8_lanes_result(o_remote_partner_second_8_lanes_result) 
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
