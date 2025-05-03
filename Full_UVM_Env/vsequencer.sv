class vsequencer extends  uvm_sequencer;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	MB_sequencer 		MB_sqr;
	sideband_sequencer 	SB_sqr;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(vsequencer)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "vsequencer", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	// END Of Elaboration Phase
	function void end_of_elaboration_phase(uvm_phase phase); 
    	super.end_of_elaboration_phase(phase); 
    	if (!uvm_config_db#(MB_sequencer)::get(this, "", "MB_sqr", MB_sqr))  
      		`uvm_fatal(get_full_name(), "No MB_sqr specified for this instance"); 
    	if (!uvm_config_db#(sideband_sequencer)::get(this, "", "SB_sqr", SB_sqr))  
    	  	`uvm_fatal(get_full_name(), "No SB_sqr specified for this instance"); 
 	endfunction

endclass : vsequencer