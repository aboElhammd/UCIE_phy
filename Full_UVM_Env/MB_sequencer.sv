class MB_sequencer extends  uvm_sequencer #(MB_sequence_item);

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(MB_sequencer)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_sequencer", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

endclass : MB_sequencer

