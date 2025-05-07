module mbtrain_wrapper (
	//inputs 
		//main control signals 
			input        clk,    // Clock
			input        i_en, // Clock Enable
			input        rst_n,  // Asynchronous reset active low
		//communicating with sideband 
			input [3:0]  i_sideband_message ,
			input [15:0] i_sideband_data , 
			input        i_busy,
			input 		 i_falling_edge_busy,
			input 		 i_sideband_valid,
			input [2:0]  i_sideband_data_lanes_encoding ,
		//talking with point test block 
		  	input        i_tx_point_test_ack  , i_rx_point_test_ack  ,
		    input [15:0] i_tx_lanes_result    , i_rx_lanes_result,
			input        i_tx_valid_result, ////////////////////////////// NEW: for calibration algorithm ////////////////////////////////
	    //still doesn't have a source 
		    input        i_valid_framing_error,
		// communicating with ltsm (new)
			input [1:0]  i_phyretrain_resolved_state,
			input 	     i_coming_from_L1,
		//inputs from mbinit (new)
			input [2:0] i_highest_common_speed,
			input       i_first_8_tx_lanes_are_functional_mbinit , i_second_8_tx_lanes_are_functional_mbinit,
	    	input		i_first_8_rx_lanes_are_functional_mbinit , i_second_8_rx_lanes_are_functional_mbinit,
	    	input [3:0] i_reciever_ref_voltage ,

	//output
		//communicating with sideband 
			output  [3:0] o_sideband_substate,
			output  [3:0] o_sideband_message ,
			output  [2:0] o_sideband_data_lanes_encoding ,
			output  	  o_timeout_disable, o_valid ,
		//analog component control word 
			output  [3:0] o_reciever_ref_voltage ,o_pi_step,
		//communicating with point test 
			output 		  o_tx_mainband_or_valtrain_test , o_tx_lfsr_or_perlane,
			output 		  o_rx_mainband_or_valtrain_test ,
			output        o_tx_pt_en , o_rx_pt_en ,
			output  	  o_tx_eye_width_sweep_en , o_rx_eye_width_sweep_en ,
		//comunicating with phy retrain 
			output [1:0] o_phyretrain_error_encoding,
		// finishing ack
			output  o_mbtrain_ack,
		//communicating with pattern generators and detectors (new) 
			output	o_first_8_tx_lanes_are_functional , o_second_8_tx_lanes_are_functional,
		    output 	o_first_8_rx_lanes_are_functional , o_second_8_rx_lanes_are_functional ,
	    //phy_retrain_enable (new)
			output  o_phyretrain_en ,
		//communicating with pll
			output  [2:0] o_curret_operating_speed 

	);
/*------------------------------------------------------------------------------
--selfcal signals  
------------------------------------------------------------------------------*/
	//inputs 
	wire i_en_selfcal;
	//outputs //done
		//communicating with sideband //done
			wire  [3:0] o_sideband_message_selfcal ;
			wire  o_valid_selfcal; //done
		// finishing ack
			wire  o_test_ack_selfcal;//done
/*------------------------------------------------------------------------------
--vref_cal signals  
------------------------------------------------------------------------------*/
	//inputs 
		wire i_en_vref_cal;
	//outputs //done
		//communicating with sideband //done
			wire  [3:0] o_sideband_message_vref_cal ;
			wire  o_valid_vref_cal; //done
		// finishing ack
			wire  o_test_ack_vref_cal;//done 
		//point test control signals 
			wire o_pt_en_vref_cal; //done
/*------------------------------------------------------------------------------
--train center cal  signals  
------------------------------------------------------------------------------*/
	//inputs 
		wire i_en_train_center_cal;
	//outputs //done
		//communicating with sideband //done
			wire  [3:0] o_sideband_message_train_center_cal ;
			wire  o_valid_train_center_cal; //done
		// finishing ack
			wire  o_test_ack_train_center_cal;//done 
		//point test control signals 
			wire o_pt_en_train_center_cal; //done
			wire o_tx_mainband_or_valtrain_test_train_center_cal; //done
/*------------------------------------------------------------------------------
--RX cal  signals  
------------------------------------------------------------------------------*/
	//inputs 
		wire i_en_rx_cal;
	//outputs //done
		//communicating with sideband //done
			wire  [3:0] o_sideband_message_rx_cal ;
			wire  o_valid_rx_cal; //done
		// finishing ack
			wire  o_test_ack_rx_cal;//done 
/*------------------------------------------------------------------------------
--repair signals  
------------------------------------------------------------------------------*/
	//inputs 
	wire i_en_repair;
	//outputs //done
		//communicating with sideband //done
			wire  [3:0] o_sideband_message_repair ;
			wire  o_valid_repair; //done
		// finishing ack
			wire  o_test_ack_repair;//done
		//remote partner results 
			wire o_remote_partner_first_8_lanes_result_repair , o_remote_partner_second_8_lanes_result_repair; //done
/*------------------------------------------------------------------------------
--linksped signals  
------------------------------------------------------------------------------*/
	//inputs 
	wire i_en_linkspeed; //done 
	//outputs //done
		//communicating with sideband //done
			wire  [3:0] o_sideband_message_linkspeed ;
			wire  o_valid_linkspeed;    //done
		// finishing ack
			wire  o_test_ack_linkspeed; //done
		//next state flags
			wire	o_phy_retrain_req_was_sent_or_received,o_error_req_was_sent_or_received,      //done
		        	o_speed_degrade_req_was_sent_or_received, o_repair_req_was_sent_or_received ; //done
		//talking with mbtrain controller new
			wire	o_local_first_8_lanes_are_functional_linkspeed ,o_local_second_8_lanes_are_functional_linkspeed; //done
		//point test control signals 
			wire o_pt_en_linkspeed; //done
			wire o_tx_mainband_or_valtrain_test_linkspeed; //done
/*------------------------------------------------------------------------------
--mbtrain controller signals   
------------------------------------------------------------------------------*/
	//inputs 
	    //enable for each substate 
	    wire  i_valvref_ack             ,i_data_vref_ack        , i_speed_idle_ack             , i_tx_self_cal_ack   ;
		wire  i_rx_clk_cal_ack          ,i_val_train_center_ack , i_val_train_vref_ack         , i_data_train_center_1_ack   ;
		wire  i_data_train_vref_ack     ,i_rx_deskew_ack        , i_data_train_center_2_ack    , i_link_speed_ack ,i_repair_ack ;
    //outputs 
	    //enable for each substate 
	    wire   o_valvref_en            ,o_data_vref_en        , o_speed_idle_en             , o_tx_self_cal_en   ;
		wire   o_rx_clk_cal_en         ,o_val_train_center_en , o_val_train_vref_en         , o_data_train_center_1_en   ;
		wire   o_data_train_vref_en    ,o_rx_deskew_en        , o_data_train_center_2_en    , o_link_speed_en ,o_repair_en; 
		//mux select 
		wire [2:0] o_mux_sel;
		// communicating with linkspeed
		wire o_comming_from_repair;
		wire o_mainband_or_valtrain_test_controller; //need to be used in controller **********************************************
/*------------------------------------------------------------------------------
--assign statements   
------------------------------------------------------------------------------*/
//point teset enables 
	assign o_rx_pt_en   =o_pt_en_vref_cal ;
	assign o_tx_pt_en   =o_pt_en_linkspeed || o_pt_en_train_center_cal;
	// assign o_tx_mainband_or_valtrain_test = o_tx_mainband_or_valtrain_test_linkspeed || o_tx_mainband_or_valtrain_test_train_center_cal ;
	assign o_tx_mainband_or_valtrain_test = o_mainband_or_valtrain_test_controller;
// self cal enable 
	assign i_en_selfcal = o_speed_idle_en || o_tx_self_cal_en;
//vref cal enable 
	assign i_en_vref_cal=o_val_train_vref_en               || o_data_train_vref_en  ||
	                     o_valvref_en                      || o_data_vref_en;
//train center enable 
	assign i_en_train_center_cal=  o_val_train_center_en || o_data_train_center_1_en || o_data_train_center_2_en ;
// rx cal enable 
	assign i_en_rx_cal=o_rx_deskew_en  ||o_rx_clk_cal_en;
//valid 
	assign o_valid      =o_valid_repair       ||   o_valid_selfcal           ||        o_valid_linkspeed    ||
	 					 o_valid_vref_cal     || o_valid_train_center_cal    ||        o_valid_rx_cal;
/*------------------------------------------------------------------------------
--selfcal wrapper  
------------------------------------------------------------------------------*/
selfcal_wrapper selfcal_wrapper_inst( //done
	//inputs //done
		//main signals //done
			.clk(clk),    // Clock
			.rst_n(rst_n),  // Asynchronous reset active low
			.i_en(i_en_selfcal), 
		//communcating with sideband 
			.i_decoded_sideband_message(i_sideband_message) ,
			.i_busy(i_busy),
			.i_falling_edge_busy(i_falling_edge_busy),
			.i_sideband_valid          (i_sideband_valid),
	//outputs //done
		//communicating with sideband //done
			.o_sideband_message(o_sideband_message_selfcal) ,
			.o_valid(o_valid_selfcal),
		// finishing ack
			.o_test_ack(o_test_ack_selfcal)

);
/*------------------------------------------------------------------------------
--vrefcal wrapper   
------------------------------------------------------------------------------*/
vref_cal_wrapper vref_cal_wrapper_inst( //done
	//inputs //done
		//main control signlas //done
			.clk(clk),    // Clock
			.rst_n(rst_n),  // Asynchronous reset active low
			.i_en(i_en_vref_cal), 
		//communicating with sideband 
			.i_decoded_sideband_message(i_sideband_message) ,
			.i_busy(i_busy), 
			.i_falling_edge_busy(i_falling_edge_busy),
			.i_sideband_valid           (i_sideband_valid),
		//communicating with mbtrain 
			.i_mainband_or_valtrain_test(o_mainband_or_valtrain_test_controller), //0 means mainbadnd 1 means valpattern
		//communicating with point test
			.i_rx_lanes_result          (i_rx_lanes_result),
			.i_test_ack                 (i_rx_point_test_ack),
	//outputs //done
		//communicating with sideband //done
			.o_sideband_message(o_sideband_message_vref_cal) ,
			.o_valid(o_valid_vref_cal),
		//communicating with point test or eye width sweep blocks 
			.o_mainband_or_valtrain_test(o_rx_mainband_or_valtrain_test) ,
			.o_test_ack(o_test_ack_vref_cal),
			.o_pt_en(o_pt_en_vref_cal) , .o_eye_width_sweep_en(o_rx_eye_width_sweep_en),
		//analog component control word //done
			.o_reciever_ref_voltage(o_reciever_ref_voltage) 

);
/*------------------------------------------------------------------------------
--train center cal   
------------------------------------------------------------------------------*/
train_center_cal_wrapper train_center_cal_wrapper_inst( //done
	//inputs //done
		//main control signlas //done
			.clk(clk),    // Clock
			.rst_n(rst_n),  // Asynchronous reset active low
			.i_en(i_en_train_center_cal), 
		//communicating with sideband 
			.i_decoded_sideband_message(i_sideband_message) ,
			.i_busy(i_busy), 
			.i_falling_edge_busy(i_falling_edge_busy),
			.i_sideband_valid           (i_sideband_valid),
		//communicating with mbtrain 
			.i_mainband_or_valtrain_test(o_mainband_or_valtrain_test_controller), //0 means mainbadnd 1 means valpattern
		//communicating with point test
			.i_tx_lanes_result          (i_tx_lanes_result),
			.i_test_ack                 (i_tx_point_test_ack),
	//outputs //done
		//communicating with sideband //done
			.o_sideband_message(o_sideband_message_train_center_cal) ,
			.o_valid(o_valid_train_center_cal),
		//communicating with point test or eye width sweep blocks 
			.o_mainband_or_valtrain_test(o_tx_mainband_or_valtrain_test_train_center_cal) ,
			.o_test_ack(o_test_ack_train_center_cal),
			.o_pt_en(o_pt_en_train_center_cal) , .o_eye_width_sweep_en(o_tx_eye_width_sweep_en),
		//analog component control word //done
			.o_pi_step(o_pi_step) 
);
/*------------------------------------------------------------------------------
--rx cal   
------------------------------------------------------------------------------*/
rx_cal_wrapper rx_cal_wrapper_inst( //done
	//inputs //done
		//main control signlas //done
			.clk(clk),    // Clock
			.rst_n(rst_n),  // Asynchronous reset active low
			.i_en(i_en_rx_cal), 
		//communicating with sideband 
			.i_decoded_sideband_message(i_sideband_message) ,
			.i_busy(i_busy), 
			.i_falling_edge_busy(i_falling_edge_busy),
			.i_sideband_valid           (i_sideband_valid),
	//outputs //done
		//communicating with sideband //done
			.o_sideband_message(o_sideband_message_rx_cal) ,
			.o_valid(o_valid_rx_cal),
		//finishing ack  
			.o_test_ack(o_test_ack_rx_cal)
);
/*------------------------------------------------------------------------------
--repair wrapper  
------------------------------------------------------------------------------*/
 repair_wrapper repair_wrapper_inst( //done
	//inputs //done 
		//main signals //done
			.clk(clk),    // Clock
			.rst_n(rst_n),  // Asynchronous reset active low
			.i_en(o_repair_en), 
		//communicating with sideband 
		    .i_sideband_message(i_sideband_message),
			.i_sideband_valid(i_sideband_valid),
		    .i_busy(i_busy),
			.i_falling_edge_busy(i_falling_edge_busy),
			.i_sideband_data_lanes_encoding(i_sideband_data_lanes_encoding),
		//communicating with linkspeed 
			.i_first_8_lanes_are_functional(o_local_first_8_lanes_are_functional_linkspeed) ,
			.i_second_8_lanes_are_functional(o_local_first_8_lanes_are_functional_linkspeed),
	//outputs //done
		//communicating with sideband 
			 .o_valid(o_valid_repair),
			.o_sideband_data_lanes_encoding(o_sideband_data_lanes_encoding) ,
			.o_sideband_message(o_sideband_message_repair),
		//returning results back to mbtrain
			.o_remote_partner_first_8_lanes_result(o_remote_partner_first_8_lanes_result_repair) ,
			.o_remote_partner_second_8_lanes_result(o_remote_partner_second_8_lanes_result_repair),
		//finishing ack 
			.o_test_ack(o_test_ack_repair) 

);
/*------------------------------------------------------------------------------
--linkspeed wrapper   
------------------------------------------------------------------------------*/
linkspeed_wrapper linkspeed_wrapper_inst(
	//inputs //done
	    //main control signals //done 
			.clk(clk),    // Clock
			.rst_n(rst_n),  // Asynchronous reset active low
			.i_en(o_link_speed_en), 
		// talkinh with sideband 
		    .i_sideband_message(i_sideband_message),
		    .i_busy(i_busy),
			.i_falling_edge_busy(i_falling_edge_busy),
			.i_sideband_valid(i_sideband_valid),
	    //talking with point test block 
		  	.i_point_test_ack(i_tx_point_test_ack) ,  
		    .i_lanes_result(i_tx_lanes_result), 
	    //still doesn't have a source 
		    .i_valid_framing_error(i_valid_framing_error),
		//communicating with mbtrain controller 
		     .i_first_8_tx_lanes_are_functional(o_first_8_tx_lanes_are_functional) ,
		     .i_second_8_tx_lanes_are_functional(o_second_8_tx_lanes_are_functional),
		     .i_comming_from_repair(o_comming_from_repair),
    //outputs
	    //talking with sideband 
	   		.o_timeout_disable(o_timeout_disable), .o_valid(o_valid_linkspeed) ,
	   		.o_sideband_message(o_sideband_message_linkspeed)  ,
	    //talking with MBTRAIN fsm
			.o_link_speeed_ack(o_test_ack_linkspeed) ,
		//next state flags
			.o_phy_retrain_req_was_sent_or_received(o_phy_retrain_req_was_sent_or_received),
			.o_error_req_was_sent_or_received(o_error_req_was_sent_or_received), 
		    .o_speed_degrade_req_was_sent_or_received(o_speed_degrade_req_was_sent_or_received),
		    .o_repair_req_was_sent_or_received(o_repair_req_was_sent_or_received),
		//talking with phyretrain
			.o_phyretrain_error_encoding(o_phyretrain_error_encoding) ,
		//talking with mbtrain controller new
			.o_local_first_8_lanes_are_functional(o_local_first_8_lanes_are_functional_linkspeed) ,
			.o_local_second_8_lanes_are_functional(o_local_second_8_lanes_are_functional_linkspeed),
		// talking with point test 
		 	.o_point_test_en(o_pt_en_linkspeed)	 , .o_tx_lfsr_or_perlane(o_tx_lfsr_or_perlane) ,
		 	.o_tx_mainband_or_valtrain_test(o_tx_mainband_or_valtrain_test_linkspeed) 
);
/*------------------------------------------------------------------------------
-- mbtrain controller  
------------------------------------------------------------------------------*/
mbtrain_controller mbtrain_controller_inst(
    //inputs
    	//main control signals 
	    	.clk(clk),
	    	.rst_n(rst_n),
	    	.i_en(i_en), 
	    //input signal from phyretrain after resolving 
		    .i_phyretrain_resolved_state(i_phyretrain_resolved_state), 
			.i_coming_from_L1(i_coming_from_L1),
	    //input signal from mbinit 
		    .i_highest_common_speed(i_highest_common_speed),
		    .i_first_8_tx_lanes_are_functional_mbinit(i_first_8_tx_lanes_are_functional_mbinit)  ,
		    .i_second_8_tx_lanes_are_functional_mbinit(i_second_8_tx_lanes_are_functional_mbinit),
		    .i_first_8_rx_lanes_are_functional_mbinit(i_first_8_rx_lanes_are_functional_mbinit)  ,
		    .i_second_8_rx_lanes_are_functional_mbinit(i_second_8_rx_lanes_are_functional_mbinit),
	    //talking with linkspeed and repair 
		    .i_first_8_tx_lanes_are_functional_linkspeed(o_local_first_8_lanes_are_functional_linkspeed) ,
		    .i_second_8_tx_lanes_are_functional_linkspeed(o_local_second_8_lanes_are_functional_linkspeed),
		    .i_first_8_rx_lanes_are_functional_repair(o_remote_partner_first_8_lanes_result_repair) , 
		    .i_second_8_rx_lanes_are_functional_repair(o_remote_partner_second_8_lanes_result_repair),
	    //next state flags
			.i_phy_retrain_req_was_sent_or_received(o_phy_retrain_req_was_sent_or_received),   
			.i_error_req_was_sent_or_received(o_error_req_was_sent_or_received), 
			.i_speed_degrade_req_was_sent_or_received(o_speed_degrade_req_was_sent_or_received),
			.i_repair_req_was_sent_or_received(o_repair_req_was_sent_or_received),
	    //enable for each substate 
	    	.i_valvref_ack(o_test_ack_vref_cal)                            , .i_data_vref_ack(o_test_ack_vref_cal)        ,
	    	.i_speed_idle_ack(o_test_ack_selfcal)                      , .i_tx_self_cal_ack(o_test_ack_selfcal)   ,
			.i_rx_clk_cal_ack(o_test_ack_rx_cal)                      , .i_val_train_center_ack(o_test_ack_train_center_cal) ,
			.i_val_train_vref_ack (o_test_ack_vref_cal)             , .i_data_train_center_1_ack(o_test_ack_train_center_cal)   ,
			.i_data_train_vref_ack(o_test_ack_vref_cal)            , .i_rx_deskew_ack(o_test_ack_rx_cal)        ,
			.i_data_train_center_2_ack(o_test_ack_train_center_cal)    , .i_link_speed_ack (o_test_ack_linkspeed),
			.i_repair_ack(o_test_ack_repair) ,
    //outputs 
	    //enable for each substate 
	    	.o_valvref_en(o_valvref_en)                            ,.o_data_vref_en(o_data_vref_en)                           ,          
	    	.o_speed_idle_en(o_speed_idle_en)                      ,.o_tx_self_cal_en(o_tx_self_cal_en)                       ,
			.o_rx_clk_cal_en(o_rx_clk_cal_en)                      ,.o_val_train_center_en(o_val_train_center_en)             ,
			.o_val_train_vref_en(o_val_train_vref_en)              ,.o_data_train_center_1_en(o_data_train_center_1_en)       ,
			.o_data_train_vref_en(o_data_train_vref_en)            ,.o_rx_deskew_en(o_rx_deskew_en)                           ,            
			.o_data_train_center_2_en (o_data_train_center_2_en)   ,.o_link_speed_en(o_link_speed_en)                         ,
			.o_repair_en(o_repair_en), 
		//deciding which test will be done
			.o_mainband_or_valtrain_test                (o_mainband_or_valtrain_test_controller),
		//phy_retrain_enable
			.o_phyretrain_en(o_phyretrain_en) ,
		//communicating with sideband 
			.o_sideband_substate(o_sideband_substate) ,
		//communicating with pattern generators and detectors 
			.o_first_8_tx_lanes_are_functional(o_first_8_tx_lanes_are_functional) , .o_second_8_tx_lanes_are_functional(o_second_8_tx_lanes_are_functional),
	  		.o_first_8_rx_lanes_are_functional(o_first_8_rx_lanes_are_functional) , .o_second_8_rx_lanes_are_functional(o_second_8_rx_lanes_are_functional),
	    //finishing ack
	    	.o_mbtrain_ack(o_mbtrain_ack),
	   	//mux sele
	    	.o_mux_sel(o_mux_sel), //00 vref cal 01 selfcal 10 linkspeed 11 repair
	    //communicating with linkspeed to tell it that a repair was done 
	        .o_comming_from_repair(o_comming_from_repair),   
	    //communicating with pll
	    	.o_curret_operating_speed                   (o_curret_operating_speed)
);
/*------------------------------------------------------------------------------
--mux instantiations   
------------------------------------------------------------------------------*/
mux_6_to_1 mux_inst(
 	.sel_0(o_mux_sel[0]), .sel_1(o_mux_sel[1]), .sel_2(o_mux_sel[2]),
	.in_1(o_sideband_message_vref_cal)  , .in_2(o_sideband_message_selfcal) ,
	.in_3(o_sideband_message_linkspeed) , .in_4(o_sideband_message_repair),
	.in_5(o_sideband_message_train_center_cal), .in_6(o_sideband_message_rx_cal) ,
	.out(o_sideband_message)
);
endmodule 
