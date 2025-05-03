class sideband_subscriber extends  uvm_subscriber#(sideband_sequence_item);
	`uvm_component_utils(sideband_subscriber)
	/*------------------------------------------------------------------------------
	--new  
	------------------------------------------------------------------------------*/
	function  new(string name="sideband_subscriber",uvm_component parent=null);
			super.new(name,parent);
	endfunction : new
	/*------------------------------------------------------------------------------
	--build phase   
	------------------------------------------------------------------------------*/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase
	/*------------------------------------------------------------------------------
	--write function  
	------------------------------------------------------------------------------*/
	function void write(sideband_sequence_item t);
		$display("write function that is inside the subscriber has benn called ");
	endfunction : write
	/*------------------------------------------------------------------------------
	--run phase   
	------------------------------------------------------------------------------*/
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask : run_phase
endclass : sideband_subscriber
