class linkspeed_done_vs_speed_degrade_test extends  uvm_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	PHY_env env;
	virtual interface sideband_interface 	SB_vif_test;
	virtual interface MB_interface 			MB_vif_test;


	/////////////////////////////////////////
	////////// SIDEBAND SEQUENCES //////////
	/////////////////////////////////////// 

	//////////////////////// SBINIT ////////////////////////
	sideband_sequence 	sequence_1;

	//////////////////////// MBINIT ////////////////////////
	mbinit_param  		mbinit_param_seq;
	mbinit_cal 			mbinit_cal_seq;

	//////////////////////// MBTRAIN ////////////////////////
	mbtrain_speed_idle_hs 	mbtrain_speed_idle_seq;
	mbtrain_tx_self_cal_hs 	mbtrain_tx_self_cal_seq;
	mbtrain_rx_clk_cal 		mbtrain_rx_clk_cal_seq;


	/////////////////////////////////////////
	//////////     VSEQUENCES     //////////
	/////////////////////////////////////// 

	//////////////////////// MBINIT ////////////////////////
	MBINT_REPAIR_CLK_Vsequence 														MBINT_REPAIR_CLK_Vseq;
	MBINT_REPAIR_VAL_Vsequence 														MBINT_REPAIR_VAL_Vseq;
	MBINT_REVERSAL_MB_Vsequence 													MBINT_REVERSAL_MB_Vseq;
	MBINT_REPAIR_MB_Vsequence 			#(.lanes_result(16'hffff))					MBINT_REPAIR_MB_Vseq;

	//////////////////////// MBTRAIN ////////////////////////
	MBTRAIN_VALVREF_Vsequence 														MBTRAIN_VALVREF_Vseq;
	MBTRAIN_DATAVREF_Vsequence 														MBTRAIN_DATAVREF_Vseq;
	MBTRAIN_VALTRAINCENTER_Vsequence 	#(.lanes_result(16'hffff))					MBTRAIN_VALTRAINCENTER_Vseq;
	MBTRAIN_VALTRAINVREF_Vsequence 													MBTRAIN_VALTRAINVREF_Vseq;
	MBTRAIN_DATATRAINCENTER1_Vsequence 	#(.lanes_result(16'hffff))					MBTRAIN_DATATRAINCENTER1_Vseq;
	MBTRAIN_DATATRAINVREF_Vsequence													MBTRAIN_DATATRAINVREF_Vseq;
	MBTRAIN_RXDESKEW_Vsequence 														MBTRAIN_RXDESKEW_Vseq;
	MBTRAIN_DATATRAINCENTER2_Vsequence 	#(.lanes_result(16'hffff))					MBTRAIN_DATATRAINCENTER2_Vseq;
	MBTRAIN_LINKSPEED_Vsequence 		#(.lanes_result(16'hffff), .TEST_TYPE(0))	MBTRAIN_LINKSPEED_Vseq;
	MBTRAIN_LINKSPEED_Vsequence 		#(.lanes_result(16'hffff), .TEST_TYPE(6))	MBTRAIN_LINKSPEED_bad_Vseq;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	`uvm_component_utils(linkspeed_done_vs_speed_degrade_test)

/*------------------------------------------------------------------------------
--new  
------------------------------------------------------------------------------*/
	function  new(string name="linkspeed_done_vs_speed_degrade_test",uvm_component parent=null);
			super.new(name,parent);
	endfunction : new

/*------------------------------------------------------------------------------
--build phase   
------------------------------------------------------------------------------*/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		$display("inside test in build phase ");
		// Getting Vifs
		if (!uvm_config_db#(virtual MB_interface)::get(this, "", "my_MB_vif", MB_vif_test) ) begin
			`uvm_fatal(get_full_name , "error");
		end
		if (!uvm_config_db#(virtual sideband_interface)::get(this, "", "my_SB_vif", SB_vif_test) ) begin
			`uvm_fatal(get_full_name , "error");
		end

		// Setting Vifs
		uvm_config_db#(virtual MB_interface)::set(this, "env", "my_MB_vif",MB_vif_test);
		uvm_config_db#(virtual sideband_interface)::set(this, "env", "my_SB_vif",SB_vif_test);
		
		env 			 				= PHY_env::type_id::create("env",this);

		//////////////////////// SBINIT ////////////////////////
		sequence_1 						= sideband_sequence::type_id::create("sequence_1");

		//////////////////////// MBINIT ////////////////////////
		//param substate 
		mbinit_param_seq 				= mbinit_param::type_id::create("mbinit_param_seq");
		//cal substate 
		mbinit_cal_seq 	 				= mbinit_cal::type_id::create("mbinit_cal_seq");

		MBINT_REPAIR_CLK_Vseq 			= MBINT_REPAIR_CLK_Vsequence::type_id::create("MBINT_REPAIR_CLK_Vseq");
		MBINT_REPAIR_VAL_Vseq 			= MBINT_REPAIR_VAL_Vsequence::type_id::create("MBINT_REPAIR_VAL_Vseq");
		MBINT_REVERSAL_MB_Vseq 			= MBINT_REVERSAL_MB_Vsequence::type_id::create("MBINT_REVERSAL_MB_Vseq");
		MBINT_REPAIR_MB_Vseq 			= MBINT_REPAIR_MB_Vsequence #(.lanes_result(16'hffff))::type_id::create("MBINT_REPAIR_MB_Vseq");

		//////////////////////// MBTRAIN ////////////////////////
		//speed idle 
		mbtrain_speed_idle_seq 			= mbtrain_speed_idle_hs::type_id::create("mbtrain_speed_idle_seq");
		//tx self cal
		mbtrain_tx_self_cal_seq 		= mbtrain_tx_self_cal_hs::type_id::create("mbtrain_tx_self_cal_seq");
		//rx clk cal
		mbtrain_rx_clk_cal_seq 			= mbtrain_rx_clk_cal::type_id::create("mbtrain_rx_clk_cal_seq");

		
		MBTRAIN_VALVREF_Vseq 			= MBTRAIN_VALVREF_Vsequence::type_id::create("MBTRAIN_VALVREF_Vseq");
		MBTRAIN_DATAVREF_Vseq 			= MBTRAIN_DATAVREF_Vsequence::type_id::create("MBTRAIN_DATAVREF_Vseq");
		MBTRAIN_VALTRAINCENTER_Vseq 	= MBTRAIN_VALTRAINCENTER_Vsequence #(.lanes_result(16'hffff))::type_id::create("MBTRAIN_VALTRAINCENTER_Vseq");
		MBTRAIN_VALTRAINVREF_Vseq 		= MBTRAIN_VALTRAINVREF_Vsequence::type_id::create("MBTRAIN_VALTRAINVREF_Vseq");
		MBTRAIN_DATATRAINCENTER1_Vseq 	= MBTRAIN_DATATRAINCENTER1_Vsequence #(.lanes_result(16'hffff))::type_id::create("MBTRAIN_DATATRAINCENTER1_Vseq");
		MBTRAIN_DATATRAINVREF_Vseq 		= MBTRAIN_DATATRAINVREF_Vsequence::type_id::create("MBTRAIN_DATATRAINVREF_Vseq");
		MBTRAIN_RXDESKEW_Vseq 			= MBTRAIN_RXDESKEW_Vsequence::type_id::create("MBTRAIN_RXDESKEW_Vseq");
		MBTRAIN_DATATRAINCENTER2_Vseq 	= MBTRAIN_DATATRAINCENTER2_Vsequence #(.lanes_result(16'hffff))::type_id::create("MBTRAIN_DATATRAINCENTER2_Vseq");
		MBTRAIN_LINKSPEED_Vseq 			= MBTRAIN_LINKSPEED_Vsequence #(.lanes_result(16'hffff), .TEST_TYPE(0))::type_id::create("MBTRAIN_LINKSPEED_Vseq");
		MBTRAIN_LINKSPEED_bad_Vseq 		= MBTRAIN_LINKSPEED_Vsequence #(.lanes_result(16'hffff), .TEST_TYPE(6))::type_id::create("MBTRAIN_LINKSPEED_bad_Vseq");

		
	endfunction : build_phase

/*------------------------------------------------------------------------------
--connect phase   
------------------------------------------------------------------------------*/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("inside test in connect_phase ");
	endfunction : connect_phase
/*------------------------------------------------------------------------------
--run phase   
------------------------------------------------------------------------------*/
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("inside test in run phase");
		phase.raise_objection(this);
		#50
		////////////////////////////////////////////////// SBINIT //////////////////////////////////////////////////////////////////

		sequence_1.start(env.SB_agt.sequencer);

		//////////////////////////////////////////////////  MBINT ///////////////////////////////////////////////////////////////////

		mbinit_param_seq.start(env.SB_agt.sequencer);
		
		mbinit_cal_seq.start(env.SB_agt.sequencer);

		MBINT_REPAIR_CLK_Vseq.start(env.V_sqr);

		MBINT_REPAIR_VAL_Vseq.start(env.V_sqr);

		MBINT_REVERSAL_MB_Vseq.start(env.V_sqr);

		MBINT_REPAIR_MB_Vseq.start(env.V_sqr);


		////////////////////////////////////////////////// MBTRAIN //////////////////////////////////////////////////////////////////

		MBTRAIN_VALVREF_Vseq.start(env.V_sqr);

		MBTRAIN_DATAVREF_Vseq.start(env.V_sqr);

		mbtrain_speed_idle_seq.start(env.SB_agt.sequencer);
		
		mbtrain_tx_self_cal_seq.start(env.SB_agt.sequencer);
		
		mbtrain_rx_clk_cal_seq.start(env.SB_agt.sequencer);

		MBTRAIN_VALTRAINCENTER_Vseq.start(env.V_sqr);

		MBTRAIN_VALTRAINVREF_Vseq.start(env.V_sqr);

		MBTRAIN_DATATRAINCENTER1_Vseq.start(env.V_sqr);

		MBTRAIN_DATATRAINVREF_Vseq.start(env.V_sqr);

		MBTRAIN_RXDESKEW_Vseq.start(env.V_sqr);

		MBTRAIN_DATATRAINCENTER2_Vseq.start(env.V_sqr);

		MBTRAIN_LINKSPEED_bad_Vseq.start(env.V_sqr);

		////////////////////////////////////////////////// MBTRAIN //////////////////////////////////////////////////////////////////

		mbtrain_speed_idle_seq.start(env.SB_agt.sequencer);
		
		mbtrain_tx_self_cal_seq.start(env.SB_agt.sequencer);
		
		mbtrain_rx_clk_cal_seq.start(env.SB_agt.sequencer);

		MBTRAIN_VALTRAINCENTER_Vseq.start(env.V_sqr);

		MBTRAIN_VALTRAINVREF_Vseq.start(env.V_sqr);

		MBTRAIN_DATATRAINCENTER1_Vseq.start(env.V_sqr);

		MBTRAIN_DATATRAINVREF_Vseq.start(env.V_sqr);

		MBTRAIN_RXDESKEW_Vseq.start(env.V_sqr);

		MBTRAIN_DATATRAINCENTER2_Vseq.start(env.V_sqr);

		MBTRAIN_LINKSPEED_Vseq.start(env.V_sqr);
		
		#100000;
		phase.drop_objection(this);
	endtask : run_phase
endclass : linkspeed_done_vs_speed_degrade_test
