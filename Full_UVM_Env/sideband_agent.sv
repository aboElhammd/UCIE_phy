class sideband_agent extends  uvm_agent ;
	`uvm_component_utils(sideband_agent)
	sideband_driver driver;
	sideband_monitor monitor;
	sideband_sequencer sequencer ;
	virtual sideband_interface vif_agent;
	uvm_analysis_port #(sideband_sequence_item) my_analysis_port_agt;
	/*------------------------------------------------------------------------------
	--new  
	------------------------------------------------------------------------------*/
	function  new(string name="sideband_agent",uvm_component parent=null);
			super.new(name,parent);
	endfunction : new
	/*------------------------------------------------------------------------------
	--build phase   
	------------------------------------------------------------------------------*/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		$display("inside agent in build phase ");
		if (!uvm_config_db#(virtual sideband_interface)::get(this, "", "my_SB_vif",vif_agent )) begin
			`uvm_fatal(get_full_name,"ERROR")
		end
		uvm_config_db#(virtual sideband_interface)::set(this, "driver", "my_vif",vif_agent );
		uvm_config_db#(virtual sideband_interface)::set(this, "monitor", "my_vif",vif_agent);
	 	driver=sideband_driver::type_id::create("driver",this);
	 	monitor=sideband_monitor::type_id::create("monitor",this);
	 	sequencer=sideband_sequencer::type_id::create("sequencer",this);
	 	my_analysis_port_agt=new("my_analysis_port_agt",this);
	endfunction : build_phase
	/*------------------------------------------------------------------------------
	--connect phase   
	------------------------------------------------------------------------------*/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		monitor.my_analysis_port.connect(my_analysis_port_agt);
		driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction : connect_phase

endclass : sideband_agent
