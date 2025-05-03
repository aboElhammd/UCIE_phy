class PHY_test extends  uvm_test;
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	PHY_env env;
	virtual interface sideband_interface SB_vif_test;
	virtual interface MB_interface MB_vif_test;

	/////////////////////////////////////////
	////////// SIDEBAND SEQUENCES //////////
	/////////////////////////////////////// 

	//////////////////////// SBINIT ////////////////////////
	sideband_sequence 		sequence_1;

	//////////////////////// MBINIT ////////////////////////
	mbinit_param  			mbinit_param_seq;
	mbinit_cal 				mbinit_cal_seq;

	//////////////////////// MBTRAIN ////////////////////////
	mbtrain_speed_idle_hs 	mbtrain_speed_idle_seq;
	mbtrain_tx_self_cal_hs 	mbtrain_tx_self_cal_seq;
	mbtrain_rx_clk_cal 		mbtrain_rx_clk_cal_seq;

	/////////////////////////////////////////
	//////////     VSEQUENCES     //////////
	/////////////////////////////////////// 

	//////////////////////// MBINIT ////////////////////////
	MBINT_REPAIR_CLK_Vsequence 	MBINT_REPAIR_CLK_Vseq;
	MBINT_REPAIR_VAL_Vsequence 	MBINT_REPAIR_VAL_Vseq;
	MBINT_REVERSAL_MB_Vsequence MBINT_REVERSAL_MB_Vseq;
	MBINT_REPAIR_MB_Vsequence 	MBINT_REPAIR_MB_Vseq;

	//////////////////////// MBTRAIN ////////////////////////
	MBTRAIN_VALVREF_Vsequence 			MBTRAIN_VALVREF_Vseq;
	MBTRAIN_DATAVREF_Vsequence 			MBTRAIN_DATAVREF_Vseq;
	MBTRAIN_VALTRAINCENTER_Vsequence 	MBTRAIN_VALTRAINCENTER_Vseq;
	MBTRAIN_VALTRAINVREF_Vsequence 		MBTRAIN_VALTRAINVREF_Vseq;
	MBTRAIN_DATATRAINCENTER1_Vsequence 	MBTRAIN_DATATRAINCENTER1_Vseq;
	MBTRAIN_DATATRAINVREF_Vsequence		MBTRAIN_DATATRAINVREF_Vseq;
	MBTRAIN_RXDESKEW_Vsequence 			MBTRAIN_RXDESKEW_Vseq;
	MBTRAIN_DATATRAINCENTER2_Vsequence	MBTRAIN_DATATRAINCENTER2_Vseq;
	MBTRAIN_LINKSPEED_Vsequence 		MBTRAIN_LINKSPEED_Vseq;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	`uvm_component_utils(PHY_test)
	
/*------------------------------------------------------------------------------
--new  
------------------------------------------------------------------------------*/
	function  new(string name="PHY_test",uvm_component parent=null);
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
		MBINT_REPAIR_MB_Vseq 			= MBINT_REPAIR_MB_Vsequence::type_id::create("MBINT_REPAIR_MB_Vseq");

		//////////////////////// MBTRAIN ////////////////////////
		//speed idle 
		mbtrain_speed_idle_seq 			= mbtrain_speed_idle_hs::type_id::create("mbtrain_speed_idle_seq");
		//tx self cal
		mbtrain_tx_self_cal_seq 		= mbtrain_tx_self_cal_hs::type_id::create("mbtrain_tx_self_cal_seq");
		//rx clk cal
		mbtrain_rx_clk_cal_seq 			= mbtrain_rx_clk_cal::type_id::create("mbtrain_rx_clk_cal_seq");

		
		MBTRAIN_VALVREF_Vseq 			= MBTRAIN_VALVREF_Vsequence::type_id::create("MBTRAIN_VALVREF_Vseq");
		MBTRAIN_DATAVREF_Vseq 			= MBTRAIN_DATAVREF_Vsequence::type_id::create("MBTRAIN_DATAVREF_Vseq");
		MBTRAIN_VALTRAINCENTER_Vseq 	= MBTRAIN_VALTRAINCENTER_Vsequence::type_id::create("MBTRAIN_VALTRAINCENTER_Vseq");
		MBTRAIN_VALTRAINVREF_Vseq 		= MBTRAIN_VALTRAINVREF_Vsequence::type_id::create("MBTRAIN_VALTRAINVREF_Vseq");
		MBTRAIN_DATATRAINCENTER1_Vseq 	= MBTRAIN_DATATRAINCENTER1_Vsequence::type_id::create("MBTRAIN_DATATRAINCENTER1_Vseq");
		MBTRAIN_DATATRAINVREF_Vseq 		= MBTRAIN_DATATRAINVREF_Vsequence::type_id::create("MBTRAIN_DATATRAINVREF_Vseq");
		MBTRAIN_RXDESKEW_Vseq 			= MBTRAIN_RXDESKEW_Vsequence::type_id::create("MBTRAIN_RXDESKEW_Vseq");
		MBTRAIN_DATATRAINCENTER2_Vseq 	= MBTRAIN_DATATRAINCENTER2_Vsequence::type_id::create("MBTRAIN_DATATRAINCENTER2_Vseq");
		MBTRAIN_LINKSPEED_Vseq 			= MBTRAIN_LINKSPEED_Vsequence::type_id::create("MBTRAIN_LINKSPEED_Vseq");
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

		MBTRAIN_LINKSPEED_Vseq.start(env.V_sqr);


		#1000000;
		phase.drop_objection(this);
	endtask : run_phase
endclass : PHY_test









// BULIDING
//repair clk
// mbinit_repair_clk_init_seq=mbinit_repair_clk_init_hs::type_id::create("mbinit_repair_clk_init_seq");
// mbinit_repair_clk_result_done_seq=mbinit_repair_clk_result_done_hs::type_id::create("mbinit_repair_clk_result_done_seq");	

// repair val sequences 
// mbinit_repair_val_init_seq =mbinit_repair_val_init_hs ::type_id::create("mbinit_repair_val_init_seq");
// mbinit_repair_val_result_done_seq =mbinit_repair_val_result_done_hs ::type_id::create("mbinit_repair_val_result_done_seq");

// reversal main band seqeuces 
// mbinit_reversal_mb_seq =mbinit_reversal_mb::type_id::create("mbinit_reversal_mb_seq");
// mbinit_reversal_mb_result_seq =mbinit_reversal_mb_result_hs::type_id::create("mbinit_reversal_mb_result_seq");
// mbinit_reversal_mb_done_seq =mbinit_reversal_mb_done_hs::type_id::create("mbinit_reversal_mb_done_seq");


// point test sequences 
// tx_pt_init_seq=tx_initiated_point_test_init_handshake_per_lane::type_id::create("tx_pt_init_seq");
// tx_lfsr_clear_error_req= tx_initiated_point_test_LFSR_CLEAR_handshake::type_id::create("tx_lfsr_clear_error_req");
// tx_pt_result_done_hs=tx_initiated_point_test_result_and_done_handshakes::type_id::create("tx_pt_result_done_hs");


// repair mb sequences
// mbinit_repair_mb_init_seq=mbinit_repair_mb_init_hs::type_id::create("mbinit_repair_mb_init_seq");
// mbinit_repair_mb_done_seq=mbinit_repair_mb_done_hs::type_id::create("mbinit_repair_mb_done_seq");
// sequence_2=my_sequence_2::type_id::create("sequence_2");

//RUNNING
//repair clock 
// mbinit_repair_clk_init_seq.start(env.SB_agt.sequencer);
// ////////////////////////send clock pattern///////////////////////////////////
// mbinit_repair_clk_result_done_seq.start(env.SB_agt.sequencer);

//mbinit repair val sequences 
//mbinit_repair_val_init_seq.start(env.SB_agt.sequencer);
/////////////////////////send valid pattern///////////////////////////
//mbinit_repair_val_result_done_seq.start(env.SB_agt.sequencer);

//mbinit reversal main band 
// mbinit_reversal_mb_seq.start(env.SB_agt.sequencer);
// ///////////////////////send perland pattenr/////////////////////////////////
// mbinit_reversal_mb_result_seq.start(env.SB_agt.sequencer);
// mbinit_reversal_mb_done_seq.start(env.SB_agt.sequencer);
