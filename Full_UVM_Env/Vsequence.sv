class MBINT_REPAIR_CLK_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbinit_repair_clk_init_hs 			mbinit_repair_clk_init_seq; 
		mbinit_repair_clk_result_done_hs 	mbinit_repair_clk_result_done_seq; 
		MB_CLK_Pattern_sequence 			MB_CLK_Pattern_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBINT_REPAIR_CLK_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBINT_REPAIR_CLK_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 
		    super.body(); 

		    `uvm_info("MBINT_REPAIR_CLK_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbinit_repair_clk_init_seq,  SB_sqr) 
		    `uvm_do_on(MB_CLK_Pattern_seq, MB_sqr) 
		    `uvm_do_on(mbinit_repair_clk_result_done_seq, SB_sqr) 
		    `uvm_info("MBINT_REPAIR_CLK_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBINT_REPAIR_CLK_Vsequence


class MBINT_REPAIR_VAL_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbinit_repair_val_init_hs  			mbinit_repair_val_init_seq;
	  	mbinit_repair_val_result_done_hs 	mbinit_repair_val_result_done_seq; 
	    MB_VALTRAIN_Pattern_sequence 		MB_VALTRAIN_Pattern_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBINT_REPAIR_VAL_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBINT_REPAIR_VAL_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 

		    `uvm_info("MBINT_REPAIR_VAL_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbinit_repair_val_init_seq,  SB_sqr) 
		    `uvm_do_on(MB_VALTRAIN_Pattern_seq, MB_sqr) 
		    `uvm_do_on(mbinit_repair_val_result_done_seq, SB_sqr) 
		    `uvm_info("MBINT_REPAIR_VAL_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBINT_REPAIR_VAL_Vsequence


class MBINT_REVERSAL_MB_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbinit_reversal_mb 					mbinit_reversal_mb_seq;
		mbinit_reversal_mb_result_hs 		mbinit_reversal_mb_result_seq;
		mbinit_reversal_mb_done_hs 			mbinit_reversal_mb_done_seq; 
	    MB_Per_Lane_ID_Pattern_sequence 	MB_Per_Lane_ID_Pattern_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBINT_REVERSAL_MB_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBINT_REVERSAL_MB_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBINT_REVERSAL_MB_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbinit_reversal_mb_seq,  SB_sqr) 
		    `uvm_do_on(MB_Per_Lane_ID_Pattern_seq, MB_sqr) 
		    `uvm_do_on(mbinit_reversal_mb_result_seq, SB_sqr) 
		    `uvm_do_on(mbinit_reversal_mb_done_seq, SB_sqr) 
		    `uvm_info("MBINT_REVERSAL_MB_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBINT_REVERSAL_MB_Vsequence

class MBINT_REPAIR_MB_Vsequence #(parameter lanes_result = 16'hffff) extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		// point test sequences 
		tx_initiated_point_test_init_handshake_per_lane 									tx_pt_init_seq;
		LFSR_CLEAR_handshake						 										lfsr_clear_error_req_seq;
		tx_initiated_point_test_result_and_done_handshakes #(.lanes_result(lanes_result)) 	tx_pt_result_done_hs;
		// mbinit repair main band sequences 
		mbinit_repair_mb_init_hs  															mbinit_repair_mb_init_seq;
		mbinit_repair_mb_done_hs 															mbinit_repair_mb_done_seq;
		// Per-Lane ID sequence
		MB_Per_Lane_ID_Pattern_sequence 													MB_Per_Lane_ID_Pattern_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_param_utils(MBINT_REPAIR_MB_Vsequence #(lanes_result))

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBINT_REPAIR_MB_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBINT_REPAIR_MB_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbinit_repair_mb_init_seq,  SB_sqr)
		    `uvm_do_on(tx_pt_init_seq, SB_sqr)
		    `uvm_do_on(lfsr_clear_error_req_seq, SB_sqr)
		    `uvm_do_on(MB_Per_Lane_ID_Pattern_seq, MB_sqr) 
		     `uvm_do_on(tx_pt_result_done_hs, SB_sqr)
		    `uvm_do_on(mbinit_repair_mb_done_seq, SB_sqr)
		    `uvm_info("MBINT_REPAIR_MB_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBINT_REPAIR_MB_Vsequence


class MBTRAIN_VALVREF_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_valvref_init_hs  		mbtrain_valvref_init_seq;
		mbtrain_valvref_done_hs		 	mbtrain_valvref_done_seq;
		MB_VALTRAIN_Pattern_sequence 	MB_VALTRAIN_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		rx_initiated_point_test_init_handshake_val_pattern 	rx_initiated_point_test_init_handshake_val_pattern_seq;
		LFSR_CLEAR_handshake 								lfsr_clear_error_req_seq;
		rx_initiated_point_test_result_and_done_handshakes 	rx_initiated_point_test_result_and_done_handshakes_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBTRAIN_VALVREF_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_VALVREF_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_VALVREF_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_valvref_init_seq,  SB_sqr)
		    `uvm_do_on(rx_initiated_point_test_init_handshake_val_pattern_seq,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_VALTRAIN_Pattern_seq, MB_sqr) 
		    `uvm_do_on(rx_initiated_point_test_result_and_done_handshakes_seq,  SB_sqr)
		    `uvm_do_on(mbtrain_valvref_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_VALVREF_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_VALVREF_Vsequence


class MBTRAIN_DATAVREF_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_datavref_init_hs 		mbtrain_datavref_init_seq;
		mbtrain_datavref_done_hs 		mbtrain_datavref_done_seq;
		MB_LFSR_Pattern_sequence 		MB_LFSR_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		rx_initiated_point_test_init_handshake_val_pattern 	rx_initiated_point_test_init_handshake_val_pattern_seq;
		LFSR_CLEAR_handshake 								lfsr_clear_error_req_seq;
		rx_initiated_point_test_result_and_done_handshakes 	rx_initiated_point_test_result_and_done_handshakes_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBTRAIN_DATAVREF_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_DATAVREF_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_DATAVREF_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_datavref_init_seq,  SB_sqr)
		    `uvm_do_on(rx_initiated_point_test_init_handshake_val_pattern_seq,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_LFSR_Pattern_seq, MB_sqr) 
		    // repeat(2048) 
			// #250;
		    `uvm_do_on(rx_initiated_point_test_result_and_done_handshakes_seq,  SB_sqr)
		    `uvm_do_on(mbtrain_datavref_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_DATAVREF_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_DATAVREF_Vsequence


class MBTRAIN_VALTRAINCENTER_Vsequence #(parameter lanes_result = 16'hffff) extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_val_center_init_hs 		mbtrain_val_center_init_seq;
		mbtrain_val_center_done_hs 		mbtrain_val_center_done_seq;
		MB_VALTRAIN_Pattern_sequence 	MB_VALTRAIN_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		tx_initiated_point_test_init_handshake_val_pattern 								tx_pt_init_seq_val;	
		LFSR_CLEAR_handshake 							   							  	lfsr_clear_error_req_seq;
		tx_initiated_point_test_result_and_done_handshakes #(.lanes_result(lanes_result)) 	tx_pt_result_done_hs;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_param_utils(MBTRAIN_VALTRAINCENTER_Vsequence #(lanes_result))

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_VALTRAINCENTER_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_VALTRAINCENTER_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_val_center_init_seq,  SB_sqr)
		    `uvm_do_on(tx_pt_init_seq_val,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_VALTRAIN_Pattern_seq, MB_sqr) 
		    `uvm_do_on(tx_pt_result_done_hs,  SB_sqr)
		    `uvm_do_on(mbtrain_val_center_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_VALTRAINCENTER_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

	endclass : MBTRAIN_VALTRAINCENTER_Vsequence


class MBTRAIN_VALTRAINVREF_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_valtrain_vref_init_hs 	mbtrain_valtrain_vref_init_seq;
		mbtrain_valtrain_vref_done_hs 	mbtrain_valtrain_vref_done_seq;
		MB_VALTRAIN_Pattern_sequence 	MB_VALTRAIN_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		rx_initiated_point_test_init_handshake_val_pattern 	rx_initiated_point_test_init_handshake_val_pattern_seq;
		LFSR_CLEAR_handshake 								lfsr_clear_error_req_seq;
		rx_initiated_point_test_result_and_done_handshakes 	rx_initiated_point_test_result_and_done_handshakes_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBTRAIN_VALTRAINVREF_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_VALTRAINVREF_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_VALTRAINVREF_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_valtrain_vref_init_seq,  SB_sqr)
		    `uvm_do_on(rx_initiated_point_test_init_handshake_val_pattern_seq,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_VALTRAIN_Pattern_seq, MB_sqr) 
		    `uvm_do_on(rx_initiated_point_test_result_and_done_handshakes_seq,  SB_sqr)
		    `uvm_do_on(mbtrain_valtrain_vref_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_VALTRAINVREF_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_VALTRAINVREF_Vsequence


class MBTRAIN_DATATRAINCENTER1_Vsequence #(parameter lanes_result = 16'hffff) extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_datatrain_center_1_init_hs 	mbtrain_datatrain_center_1_init_seq;
		mbtrain_datatrain_center_1_done_hs 	mbtrain_datatrain_center_1_done_seq;
		MB_LFSR_Pattern_sequence 			MB_LFSR_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		tx_initiated_point_test_init_handshake_LFSR_pattern 								tx_pt_init_seq_lfsr;
		LFSR_CLEAR_handshake 																lfsr_clear_error_req_seq;
		tx_initiated_point_test_result_and_done_handshakes #(.lanes_result(lanes_result))  	tx_pt_result_done_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_param_utils(MBTRAIN_DATATRAINCENTER1_Vsequence #(lanes_result))

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_DATATRAINCENTER1_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_DATATRAINCENTER1_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_datatrain_center_1_init_seq,  SB_sqr)
		    `uvm_do_on(tx_pt_init_seq_lfsr,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_LFSR_Pattern_seq, MB_sqr) 
		    // repeat(2048) 
			// #250;
		    `uvm_do_on(tx_pt_result_done_seq,  SB_sqr)
		    `uvm_do_on(mbtrain_datatrain_center_1_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_DATATRAINCENTER1_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_DATATRAINCENTER1_Vsequence


class MBTRAIN_DATATRAINVREF_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_datatrain_vref_init_hs 		mbtrain_datatrain_vref_init_seq;
		mbtrain_datatrain_vref_done_hs 		mbtrain_datatrain_vref_done_seq;
		MB_LFSR_Pattern_sequence 			MB_LFSR_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		rx_initiated_point_test_init_handshake_LFSR_pattern rx_initiated_point_test_init_handshake_LFSR_pattern_seq;
		LFSR_CLEAR_handshake 								lfsr_clear_error_req_seq;
		rx_initiated_point_test_result_and_done_handshakes 	rx_initiated_point_test_result_and_done_handshakes_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBTRAIN_DATATRAINVREF_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_DATATRAINVREF_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_DATATRAINVREF_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_datatrain_vref_init_seq,  SB_sqr)
		    `uvm_do_on(rx_initiated_point_test_init_handshake_LFSR_pattern_seq,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_LFSR_Pattern_seq, MB_sqr) 
		    // repeat(2048) 
			// #250;
		    `uvm_do_on(rx_initiated_point_test_result_and_done_handshakes_seq,  SB_sqr)
		    `uvm_do_on(mbtrain_datatrain_vref_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_DATATRAINVREF_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_DATATRAINVREF_Vsequence


class MBTRAIN_RXDESKEW_Vsequence extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_rx_deskew_init_hs mbtrain_rx_deskew_init_seq;
		mbtrain_rx_deskew_done_hs mbtrain_rx_deskew_done_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(MBTRAIN_RXDESKEW_Vsequence)

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_RXDESKEW_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_RXDESKEW_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_rx_deskew_init_seq,  SB_sqr)
		    `uvm_do_on(mbtrain_rx_deskew_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_RXDESKEW_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_RXDESKEW_Vsequence


class MBTRAIN_DATATRAINCENTER2_Vsequence #(parameter lanes_result = 16'hffff) extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_datatrain_center_1_init_hs 	mbtrain_datatrain_center_2_init_seq;
		mbtrain_datatrain_center_1_done_hs 	mbtrain_datatrain_center_2_done_seq;
		MB_LFSR_Pattern_sequence 			MB_LFSR_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		tx_initiated_point_test_init_handshake_LFSR_pattern 								tx_pt_init_seq_lfsr;
		LFSR_CLEAR_handshake 																lfsr_clear_error_req_seq;
		tx_initiated_point_test_result_and_done_handshakes #(.lanes_result(lanes_result)) 	tx_pt_result_done_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_param_utils(MBTRAIN_DATATRAINCENTER2_Vsequence #(lanes_result))

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_DATATRAINCENTER2_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_DATATRAINCENTER2_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_datatrain_center_2_init_seq,  SB_sqr)
		    `uvm_do_on(tx_pt_init_seq_lfsr,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_LFSR_Pattern_seq, MB_sqr) 
		    // repeat(2048) 
			// #250;
		    `uvm_do_on(tx_pt_result_done_seq,  SB_sqr)
		    `uvm_do_on(mbtrain_datatrain_center_2_done_seq, SB_sqr)
		    `uvm_info("MBTRAIN_DATATRAINCENTER2_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_DATATRAINCENTER2_Vsequence


class MBTRAIN_LINKSPEED_Vsequence #(parameter lanes_result = 16'hffff, parameter TEST_TYPE = 0) extends  vseq_base;

	/*-------------------------------------------------------------------------------
	-- Interface, port, fields
	-------------------------------------------------------------------------------*/
		mbtrain_linkspeed_init_hs 						mbtrain_linkspeed_init_seq;
		mbtrain_linkspeed_done_packet_lp 				mbtrain_linkspeed_done_packet_lp_seq;
		mbtrain_linkspeed_error_resp  					mbtrain_linkspeed_error_resp_seq;
		mbtrain_linkspeed_exit_to_speed_degrade_resp 	mbtrain_linkspeed_exit_to_speed_degrade_resp_seq;
		mbtrain_linkspeed_done_hs 						mbtrain_linkspeed_done_seq;
		mbtrain_linkspeed_exit_to_phyretrain_packets_hp mbtrain_linkspeed_exit_to_phyretrain_packets_hp_seq;
		phyretrain_hs  									phyretrain_hs_seq;
		mbtrain_linkspeed_error_hs 						mbtrain_linkspeed_error_hs_seq;
		mbtrain_linkspeed_exit_to_repair_packet_lp 		mbtrain_linkspeed_exit_to_repair_packet_lp_seq;
		MB_LFSR_Pattern_sequence 						MB_LFSR_Pattern_seq;
		///////////////////////////////point test ///////////////////////////////////
		tx_initiated_point_test_init_handshake_LFSR_pattern 								tx_pt_init_seq_lfsr;
		LFSR_CLEAR_handshake 																lfsr_clear_error_req_seq;
		tx_initiated_point_test_result_and_done_handshakes #(.lanes_result(lanes_result))  	tx_pt_result_done_seq;

	/*-------------------------------------------------------------------------------
	-- UVM Factory register
	-------------------------------------------------------------------------------*/
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_param_utils(MBTRAIN_LINKSPEED_Vsequence #(lanes_result, TEST_TYPE))

	/*-------------------------------------------------------------------------------
	-- Functions
	-------------------------------------------------------------------------------*/
		// Constructor
		function new(string name = "MBTRAIN_LINKSPEED_Vsequence");
			super.new(name);
		endfunction : new

		 virtual task body(); 	    
		    super.body(); 
		    
		    `uvm_info("MBTRAIN_LINKSPEED_Vsequence", "Executing sequence", UVM_HIGH) 
		    `uvm_do_on(mbtrain_linkspeed_init_seq,  SB_sqr)
		    `uvm_do_on(tx_pt_init_seq_lfsr,  SB_sqr) 
		    `uvm_do_on(lfsr_clear_error_req_seq,  SB_sqr)
		    `uvm_do_on(MB_LFSR_Pattern_seq, MB_sqr) 
		    // repeat(2048) 
			// #250;
		    `uvm_do_on(tx_pt_result_done_seq,  SB_sqr)

		    if (TEST_TYPE == 0) // Basic Scenario
		    	`uvm_do_on(mbtrain_linkspeed_done_seq, SB_sqr)

		    else if (TEST_TYPE == 1) begin // linkspeed_speed_degrade_vs_done_test
		    	`uvm_do_on(mbtrain_linkspeed_done_packet_lp_seq, SB_sqr)
		    	`uvm_do_on(mbtrain_linkspeed_error_resp_seq, SB_sqr)
		    	`uvm_do_on(mbtrain_linkspeed_exit_to_speed_degrade_resp_seq, SB_sqr)
		    end	
		    else if (TEST_TYPE == 2) begin // linkspeed_speed_degrade_vs_phyretrain_test
		    	`uvm_do_on(mbtrain_linkspeed_exit_to_phyretrain_packets_hp_seq, SB_sqr)
		    	`uvm_do_on(phyretrain_hs_seq, SB_sqr)
		    end	
		    else if (TEST_TYPE == 3) begin // linkspeed_speed_degrade_vs_repair_test
		    	`uvm_do_on(mbtrain_linkspeed_error_hs_seq, SB_sqr)
		    	`uvm_do_on(mbtrain_linkspeed_exit_to_repair_packet_lp_seq, SB_sqr)
		    	`uvm_do_on(mbtrain_linkspeed_exit_to_speed_degrade_resp_seq, SB_sqr)
		    end	
		    `uvm_info("MBTRAIN_LINKSPEED_Vsequence", "Sequence complete", UVM_HIGH)
	  endtask 

endclass : MBTRAIN_LINKSPEED_Vsequence


