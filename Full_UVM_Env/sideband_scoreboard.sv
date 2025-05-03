class sideband_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(sideband_scoreboard)
	uvm_analysis_imp #(sideband_sequence_item, sideband_scoreboard) my_analysis_imp;
	sideband_sequence_item seq_item_1;
	/*------------------------------------------------------------------------------
	--new  
	------------------------------------------------------------------------------*/
	function  new(string name="sideband_scoreboard",uvm_component parent=null);
			super.new(name,parent);
	endfunction : new
	/*------------------------------------------------------------------------------
	--build phase   
	------------------------------------------------------------------------------*/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		my_analysis_imp=new("my_analysis_imp" ,this);
	endfunction : build_phase
	/*------------------------------------------------------------------------------
	--overriding the write function  
	------------------------------------------------------------------------------*/
	virtual task write(sideband_sequence_item seq_item);
		$display("write function that is overriden in scoreboard has been called");
	endtask : write
endclass : sideband_scoreboard
