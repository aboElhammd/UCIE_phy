class MB_Per_Lane_ID_Pattern_sequence extends  uvm_sequence #(MB_sequence_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	MB_sequence_item Per_Lane_ID_Pattern_trans;
	

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(MB_Per_Lane_ID_Pattern_sequence)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_Per_Lane_ID_Pattern_sequence");
		super.new(name);
	endfunction : new


	// Pre body
	task pre_body();
		Per_Lane_ID_Pattern_trans = MB_sequence_item::type_id::create("Per_Lane_ID_Pattern_trans");
	endtask : pre_body

	// body
	task body();
		Per_Lane_ID_Pattern_trans = MB_sequence_item::type_id::create("Per_Lane_ID_Pattern_trans");
		`uvm_info("MB_Per_Lane_ID_Pattern_sequence" ,
			"
			*************************************************************MB_Per_Lane_ID_Pattern_sequence has started**************************************************
			", UVM_MEDIUM);
		for (int i = 0; i < 64; i++) begin
			start_item(Per_Lane_ID_Pattern_trans);
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_0 	 = {2{PerLane_ID_Gen(0)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_1 	 = {2{PerLane_ID_Gen(1)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_2 	 = {2{PerLane_ID_Gen(2)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_3 	 = {2{PerLane_ID_Gen(3)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_4 	 = {2{PerLane_ID_Gen(4)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_5 	 = {2{PerLane_ID_Gen(5)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_6 	 = {2{PerLane_ID_Gen(6)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_7 	 = {2{PerLane_ID_Gen(7)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_8 	 = {2{PerLane_ID_Gen(8)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_9 	 = {2{PerLane_ID_Gen(9)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_10  = {2{PerLane_ID_Gen(10)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_11  = {2{PerLane_ID_Gen(11)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_12  = {2{PerLane_ID_Gen(12)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_13  = {2{PerLane_ID_Gen(13)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_14  = {2{PerLane_ID_Gen(14)}};
			Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_15  = {2{PerLane_ID_Gen(15)}};
			Per_Lane_ID_Pattern_trans.i_RVLD_L 			 = {4{8'b11110000}};
			Per_Lane_ID_Pattern_trans.seq_type 			 = 4'b0100;

			if (i == 127)
				Per_Lane_ID_Pattern_trans.last_seq = 1;
			else 
				Per_Lane_ID_Pattern_trans.last_seq = 0;

			// `uvm_info( "MB_Per_Lane_ID_Pattern_sequence" ,
			// 			$sformatf("seq no. %0d where i_lfsr_rx_lane_0 = %0b, i_lfsr_rx_lane_8 = %0b, i_lfsr_rx_lane_15 = %0b", i,
			// 						Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_0, Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_8, Per_Lane_ID_Pattern_trans.i_lfsr_rx_lane_15)  ,UVM_MEDIUM);
			finish_item(Per_Lane_ID_Pattern_trans);
		end
		`uvm_info("MB_Per_Lane_ID_Pattern_sequence" ,
			"
			*************************************************************MB_Per_Lane_ID_Pattern_sequence has Ended**************************************************
			", UVM_MEDIUM);
	endtask : body

	// Per-Lane ID Generator 
	function logic [15:0] PerLane_ID_Gen(input [7:0] Lane_no);
		PerLane_ID_Gen = {4'b1010, Lane_no, 4'b1010};
	endfunction : PerLane_ID_Gen

endclass : MB_Per_Lane_ID_Pattern_sequence


class MB_LFSR_Pattern_sequence extends  uvm_sequence #(MB_sequence_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	MB_sequence_item LFSR_Pattern_trans;
	
	// PRBS Pattern Storage
	reg [31:0] prbs_mem_0 [0:26244]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_1 [0:26244]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_2 [0:26244]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_3 [0:26244]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_4 [0:26244]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_5 [0:26244]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_6 [0:26244]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_7 [0:26244]; // 8 lanes x 262144 words

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(MB_LFSR_Pattern_sequence)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_LFSR_Pattern_sequence");
		super.new(name);
	endfunction : new


	// Pre body
	task pre_body();
		LFSR_Pattern_trans = MB_sequence_item::type_id::create("LFSR_Pattern_trans");
	endtask : pre_body

	// body
	task body();
		LFSR_Pattern_trans = MB_sequence_item::type_id::create("LFSR_Pattern_trans");
		// Load GM Patterns
		load_patterns();
		`uvm_info("MB_LFSR_Pattern_sequence" ,
			"
			*************************************************************MB_LFSR_Pattern_sequence has started**************************************************
			", UVM_MEDIUM);

		for (int i = 0; i < 128; i++) begin
			start_item(LFSR_Pattern_trans);
			LFSR_Pattern_trans.i_lfsr_rx_lane_0 	= prbs_mem_0 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_1 	= prbs_mem_1 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_2 	= prbs_mem_2 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_3 	= prbs_mem_3 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_4 	= prbs_mem_4 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_5 	= prbs_mem_5 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_6 	= prbs_mem_6 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_7 	= prbs_mem_7 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_8 	= prbs_mem_0 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_9   	= prbs_mem_1 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_10  	= prbs_mem_2 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_11  	= prbs_mem_3 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_12  	= prbs_mem_4 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_13  	= prbs_mem_5 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_14  	= prbs_mem_6 [i];
			LFSR_Pattern_trans.i_lfsr_rx_lane_15  	= prbs_mem_7 [i];
			LFSR_Pattern_trans.i_RVLD_L 			= {4{8'b11110000}};
			LFSR_Pattern_trans.seq_type 			= 4'b1000;

			if (i == 127)
				LFSR_Pattern_trans.last_seq = 1;
			else 
				LFSR_Pattern_trans.last_seq = 0;
			finish_item(LFSR_Pattern_trans);
		end

		`uvm_info("MB_LFSR_Pattern_sequence" ,
			"
			*************************************************************MB_LFSR_Pattern_sequence has Ended**************************************************
			", UVM_MEDIUM);
	endtask : body

	task load_patterns();
		//for (int lane = 0; lane < 8; lane++) begin
		   // string filename;
		   // $sformat(filename, "PRBS_GM_Lane_%0d.txt", lane);
		    $readmemh("PRBS_GM_Lane_0.txt", prbs_mem_0);
		    $readmemh("PRBS_GM_Lane_1.txt", prbs_mem_1);
		    $readmemh("PRBS_GM_Lane_2.txt", prbs_mem_2);
		    $readmemh("PRBS_GM_Lane_3.txt", prbs_mem_3);
		    $readmemh("PRBS_GM_Lane_4.txt", prbs_mem_4);
		    $readmemh("PRBS_GM_Lane_5.txt", prbs_mem_5);
		    $readmemh("PRBS_GM_Lane_6.txt", prbs_mem_6);
		    $readmemh("PRBS_GM_Lane_7.txt", prbs_mem_7);

		    // $display("************************************************************************************************************");
		    // $display("************************************************************************************************************");
		    // $display("************************************************************************************************************");
		    // $display("************************************************************************************************************");
		    // $display("is read and first elemnt is %0h", prbs_mem_0 [0]);
		    // $display("************************************************************************************************************");
		    // $display("************************************************************************************************************");
		    // $display("************************************************************************************************************");
		    // $display("************************************************************************************************************");
		//end
	endtask

endclass : MB_LFSR_Pattern_sequence


class MB_VALTRAIN_Pattern_sequence extends  uvm_sequence #(MB_sequence_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	MB_sequence_item VALTRAIN_Pattern_trans;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(MB_VALTRAIN_Pattern_sequence)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_VALTRAIN_Pattern_sequence");
		super.new(name);
	endfunction : new


	// Pre body
	task pre_body();
		VALTRAIN_Pattern_trans = MB_sequence_item::type_id::create("VALTRAIN_Pattern_trans");
	endtask : pre_body

	// body
	task body();
		`uvm_info("MB_VALTRAIN_Pattern_sequence" ,
			"
			*************************************************************MB_VALTRAIN_Pattern_sequence has started**************************************************
			", UVM_MEDIUM);
		VALTRAIN_Pattern_trans = MB_sequence_item::type_id::create("VALTRAIN_Pattern_trans");
		for (int i = 0; i < 32; i++) begin
			start_item(VALTRAIN_Pattern_trans);
			  VALTRAIN_Pattern_trans.i_RVLD_L = {4{8'b11110000}};
			  VALTRAIN_Pattern_trans.seq_type = 4'b0010;

			if (i == 31) 
				VALTRAIN_Pattern_trans.last_seq = 1;
			else 
				VALTRAIN_Pattern_trans.last_seq = 0;
			finish_item(VALTRAIN_Pattern_trans);
			`uvm_info("MB_VALTRAIN_Pattern_sequence" ,
			"
			*************************************************************MB_VALTRAIN_Pattern_sequence has Ended**************************************************
			", UVM_MEDIUM);
		end
	endtask : body

endclass : MB_VALTRAIN_Pattern_sequence


class MB_CLK_Pattern_sequence extends  uvm_sequence #(MB_sequence_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	MB_sequence_item CLK_Pattern_trans;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(MB_CLK_Pattern_sequence)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_CLK_Pattern_sequence");
		super.new(name);
	endfunction : new


	// Pre body
	task pre_body();
		CLK_Pattern_trans = MB_sequence_item::type_id::create("CLK_Pattern_trans");
	endtask : pre_body

	// body
	task body();
		CLK_Pattern_trans = MB_sequence_item::type_id::create("CLK_Pattern_trans");
		CLK_Pattern_trans.i_CKP 	= 1;
		`uvm_info("MB_CLK_Pattern_sequence" ,
			"
			*************************************************************MB_CLK_Pattern_sequence has Started**************************************************
			", UVM_MEDIUM);
		for (int i = 0; i < 128; i++) begin
			
			CLK_Pattern_trans.seq_type  = 4'b0001;

			for (int j = 0; j < 32; j++) begin
				start_item(CLK_Pattern_trans);
				CLK_Pattern_trans.i_CKP 	= ~CLK_Pattern_trans.i_CKP;
				CLK_Pattern_trans.i_CKN 	= ~CLK_Pattern_trans.i_CKP;
				CLK_Pattern_trans.i_TRACK 	= ~CLK_Pattern_trans.i_TRACK;
				finish_item(CLK_Pattern_trans);
				//`uvm_info( "CLK Pattern sequence Toggling part" ,$sformatf("seq no. %0d where i_CKP = %0d, i_CKN = %0d, i_TRACK = %0d", j, CLK_Pattern_trans.i_CKP, CLK_Pattern_trans.i_CKN, CLK_Pattern_trans.i_TRACK)  ,UVM_MEDIUM);
			end

			for (int j = 0; j < 16; j++) begin
				start_item(CLK_Pattern_trans);
				CLK_Pattern_trans.i_CKP 	= 0;
				CLK_Pattern_trans.i_CKN 	= 0;
				CLK_Pattern_trans.i_TRACK 	= 0;
				finish_item(CLK_Pattern_trans);
			end

			if (i == 127) 
				CLK_Pattern_trans.last_seq = 1;
			else 
				CLK_Pattern_trans.last_seq = 0;
		end
		`uvm_info("MB_CLK_Pattern_sequence" ,
			"
			*************************************************************MB_CLK_Pattern_sequence has Ended**************************************************
			", UVM_MEDIUM);
	endtask : body

endclass : MB_CLK_Pattern_sequence



/*------------------------------------------------------------------------------
--  
------------------------------------------------------------------------------*/
	// class MB_CLK_Pattern_sequence extends  uvm_sequence #(MB_sequence_item);

	// /*-------------------------------------------------------------------------------
	// -- Interface, port, fields
	// -------------------------------------------------------------------------------*/
	// 	MB_sequence_item CLK_Pattern_trans;

	// /*-------------------------------------------------------------------------------
	// -- UVM Factory register
	// -------------------------------------------------------------------------------*/
	// 	// Provide implementations of virtual methods such as get_type_name and create
	// 	`uvm_object_utils(MB_CLK_Pattern_sequence)

	// /*-------------------------------------------------------------------------------
	// -- Functions
	// -------------------------------------------------------------------------------*/
	// 	// Constructor
	// 	function new(string name = "MB_CLK_Pattern_sequence");
	// 		super.new(name);
	// 	endfunction : new


	// 	// Pre body
	// 	task pre_body();
	// 		CLK_Pattern_trans = MB_sequence_item::type_id::create("CLK_Pattern_trans");
	// 	endtask : pre_body

	// 	// body
	// 	task body();
	// 		CLK_Pattern_trans = MB_sequence_item::type_id::create("CLK_Pattern_trans");
	// 		CLK_Pattern_trans.i_CKP 	= 1;
	// 		`uvm_info("MB_CLK_Pattern_sequence" ,
	// 			"
	// 			*************************************************************MB_CLK_Pattern_sequence has Started**************************************************
	// 			", UVM_MEDIUM);
	// 		for (int i = 0; i < 128; i++) begin

	// 			CLK_Pattern_trans.seq_type  = 4'b0001;
	// 			if (i < 64) begin
	// 				for (int j = 0; j < 31; j++) begin
	// 				start_item(CLK_Pattern_trans);
	// 				CLK_Pattern_trans.i_CKP 	= ~CLK_Pattern_trans.i_CKP;
	// 				CLK_Pattern_trans.i_CKN 	= ~CLK_Pattern_trans.i_CKP;
	// 				CLK_Pattern_trans.i_TRACK 	= ~CLK_Pattern_trans.i_TRACK;
	// 				finish_item(CLK_Pattern_trans);
	// 				//`uvm_info( "CLK Pattern sequence Toggling part" ,$sformatf("seq no. %0d where i_CKP = %0d, i_CKN = %0d, i_TRACK = %0d", j, CLK_Pattern_trans.i_CKP, CLK_Pattern_trans.i_CKN, CLK_Pattern_trans.i_TRACK)  ,UVM_MEDIUM);
	// 				end

	// 				for (int j = 0; j < 16; j++) begin
	// 					start_item(CLK_Pattern_trans);
	// 					CLK_Pattern_trans.i_CKP 	= 0;
	// 					CLK_Pattern_trans.i_CKN 	= 0;
	// 					CLK_Pattern_trans.i_TRACK 	= 0;
	// 					finish_item(CLK_Pattern_trans);
	// 				end
	// 			end

	// 			else begin
	// 				for (int j = 0; j < 32; j++) begin
	// 				start_item(CLK_Pattern_trans);
	// 				CLK_Pattern_trans.i_CKP 	= ~CLK_Pattern_trans.i_CKP;
	// 				CLK_Pattern_trans.i_CKN 	= ~CLK_Pattern_trans.i_CKP;
	// 				CLK_Pattern_trans.i_TRACK 	= ~CLK_Pattern_trans.i_TRACK;
	// 				finish_item(CLK_Pattern_trans);
	// 				//`uvm_info( "CLK Pattern sequence Toggling part" ,$sformatf("seq no. %0d where i_CKP = %0d, i_CKN = %0d, i_TRACK = %0d", j, CLK_Pattern_trans.i_CKP, CLK_Pattern_trans.i_CKN, CLK_Pattern_trans.i_TRACK)  ,UVM_MEDIUM);
	// 				end

	// 				for (int j = 0; j < 16; j++) begin
	// 					start_item(CLK_Pattern_trans);
	// 					CLK_Pattern_trans.i_CKP 	= 0;
	// 					CLK_Pattern_trans.i_CKN 	= 0;
	// 					CLK_Pattern_trans.i_TRACK 	= 0;
	// 					finish_item(CLK_Pattern_trans);
	// 				end
	// 			end

	// 		end
	// 		`uvm_info("MB_CLK_Pattern_sequence" ,
	// 			"
	// 			*************************************************************MB_CLK_Pattern_sequence has Ended**************************************************
	// 			", UVM_MEDIUM);
	// 	endtask : body

	// endclass : MB_CLK_Pattern_sequence




