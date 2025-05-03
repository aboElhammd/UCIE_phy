class PHY_env extends  uvm_env;
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	// SB
	sideband_agent SB_agt;
	sideband_scoreboard scoreboard;
	sideband_subscriber subscriber;
	virtual interface sideband_interface SB_vif_env;

	// MB
	MB_agent MB_agt;
	virtual interface MB_interface MB_vif_env;

	//Vsqr
	vsequencer V_sqr;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	`uvm_component_utils(PHY_env)
	
/*------------------------------------------------------------------------------
--new  
------------------------------------------------------------------------------*/
	function  new(string name="PHY_env",uvm_component parent=null);
			super.new(name,parent);
	endfunction : new

/*------------------------------------------------------------------------------
--build phase   
------------------------------------------------------------------------------*/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		$display("inside env in build phase ");
		
		// Getting Vifs
		if ( !uvm_config_db#(virtual MB_interface)::get(this, "", "my_MB_vif",MB_vif_env) ) begin
			`uvm_fatal(get_full_name , "error");
		end
		if ( !uvm_config_db#(virtual sideband_interface)::get(this, "", "my_SB_vif",SB_vif_env) ) begin
			`uvm_fatal(get_full_name , "error");
		end
		
		// Setting Vifs
		uvm_config_db#(virtual MB_interface)::set(this, "MB_agt", "my_MB_vif", MB_vif_env);
		uvm_config_db#(virtual sideband_interface)::set(this, "SB_agt", "my_SB_vif", SB_vif_env);
		
		// Building Agents and Subscribers
		MB_agt 		= MB_agent::type_id::create("MB_agt",this);
		SB_agt 		= sideband_agent::type_id::create("SB_agt",this);
		scoreboard 	= sideband_scoreboard::type_id::create("scoreboard",this);
		subscriber 	= sideband_subscriber::type_id::create("subscriber",this);
		V_sqr 		= vsequencer::type_id::create("v_sqr", this);
	endfunction : build_phase

/*------------------------------------------------------------------------------
--connect phase   
------------------------------------------------------------------------------*/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		SB_agt.my_analysis_port_agt.connect(scoreboard.my_analysis_imp);
		SB_agt.my_analysis_port_agt.connect(subscriber.analysis_export);

		// Setting SQRs handels to Vsqr
		uvm_config_db#(MB_sequencer)::set(this, "v_sqr", "MB_sqr", MB_agt.sqr);
		uvm_config_db#(sideband_sequencer)::set(this, "v_sqr", "SB_sqr", SB_agt.sequencer);
	endfunction : connect_phase

endclass : PHY_env
