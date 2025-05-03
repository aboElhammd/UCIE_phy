class vseq_base extends  uvm_sequence;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	MB_sequencer 		MB_sqr;
	sideband_sequencer 	SB_sqr;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(vseq_base)
	`uvm_declare_p_sequencer(vsequencer)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "vseq_base");
		super.new(name);
	endfunction : new

	// body
	virtual task body();
		MB_sqr = p_sequencer.MB_sqr;
		SB_sqr = p_sequencer.SB_sqr;
	endtask : body

endclass : vseq_base