class MB_agent extends  uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	MB_driver drv;
	MB_monitor mon;
	MB_sequencer sqr;
	//MB_CFG agt_cfg;
	virtual interface MB_interface MB_vif;

	uvm_analysis_port #(MB_sequence_item) agt_ap;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(MB_agent)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new


	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(virtual MB_interface)::get(this, "", "my_MB_vif", MB_vif))
			`uvm_error("build_phase", "agent - Unable to get MB vif from uvm_config_db");

		//uvm_config_db#(virtual MB_interface)::set(this, "*", "my_MB_vif", MB_vif);

		drv = MB_driver::type_id::create("drv", this);
		sqr = MB_sequencer::type_id::create("sqr", this);
		mon = MB_monitor::type_id::create("mon", this);
		agt_ap = new("agt_ap", this);
	endfunction : build_phase


	// Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		drv.drv_vif = MB_vif;
		mon.mon_vif = MB_vif;
		
		drv.seq_item_port.connect(sqr.seq_item_export);
		mon.mon_ap.connect(agt_ap);
	endfunction : connect_phase

endclass : MB_agent


