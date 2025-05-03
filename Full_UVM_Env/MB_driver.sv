class MB_driver extends  uvm_driver #(MB_sequence_item);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual MB_interface drv_vif;
	MB_sequence_item drv_seq_item;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(MB_driver)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// if (!uvm_config_db#(virtual MB_interface)::get(this, "", "my_MB_vif", drv_vif))
		// 	`uvm_error("build_phase", "DRIVER - Unable to get MB vif from uvm_config_db");
	endfunction : build_phase


	// Run Phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever begin 
			drv_seq_item = MB_sequence_item::type_id::create("drv_seq_item");
			seq_item_port.get_next_item(drv_seq_item);
			
			// clocks
			drv_vif.i_CKP 				<= drv_seq_item.i_CKP;
			drv_vif.i_CKN 	 			<= drv_seq_item.i_CKN;
			drv_vif.i_TRACK 			<= drv_seq_item.i_TRACK;


			// valid lane
			drv_vif.i_RVLD_L 			<= drv_seq_item.i_RVLD_L;

			// Main band data lanes
			drv_vif.i_lfsr_rx_lane_0 	<= drv_seq_item.i_lfsr_rx_lane_0;
			drv_vif.i_lfsr_rx_lane_1 	<= drv_seq_item.i_lfsr_rx_lane_1;
			drv_vif.i_lfsr_rx_lane_2 	<= drv_seq_item.i_lfsr_rx_lane_2;
			drv_vif.i_lfsr_rx_lane_3 	<= drv_seq_item.i_lfsr_rx_lane_3;
			drv_vif.i_lfsr_rx_lane_4 	<= drv_seq_item.i_lfsr_rx_lane_4;
			drv_vif.i_lfsr_rx_lane_5 	<= drv_seq_item.i_lfsr_rx_lane_5;
			drv_vif.i_lfsr_rx_lane_6 	<= drv_seq_item.i_lfsr_rx_lane_6;
			drv_vif.i_lfsr_rx_lane_7 	<= drv_seq_item.i_lfsr_rx_lane_7;
			drv_vif.i_lfsr_rx_lane_8 	<= drv_seq_item.i_lfsr_rx_lane_8;
			drv_vif.i_lfsr_rx_lane_9 	<= drv_seq_item.i_lfsr_rx_lane_9;
			drv_vif.i_lfsr_rx_lane_10 	<= drv_seq_item.i_lfsr_rx_lane_10;
			drv_vif.i_lfsr_rx_lane_11 	<= drv_seq_item.i_lfsr_rx_lane_11;
			drv_vif.i_lfsr_rx_lane_12 	<= drv_seq_item.i_lfsr_rx_lane_12;
			drv_vif.i_lfsr_rx_lane_13 	<= drv_seq_item.i_lfsr_rx_lane_13;
			drv_vif.i_lfsr_rx_lane_14 	<= drv_seq_item.i_lfsr_rx_lane_14;
			drv_vif.i_lfsr_rx_lane_15 	<= drv_seq_item.i_lfsr_rx_lane_15;

			// drv_vif.seq_type 			<= drv_seq_item.seq_type;
			
			deser_valid();
			seq_item_port.item_done();
		end
	endtask : run_phase

	task deser_valid();
		// In case of Data or PerLane ID pattern
		if (drv_seq_item.seq_type == 3'b1000 || drv_seq_item.seq_type == 3'b0100) begin
			drv_vif.i_deser_valid_val 	<= 1'b1;
			drv_vif.i_deser_valid_data 	<= 1'b1;
			drv_vif.seq_type 			<= drv_seq_item.seq_type;
			repeat(32) @(posedge drv_vif.i_clk);
			if (drv_seq_item.last_seq) begin
				drv_vif.i_deser_valid_val 	<= 1'b0;
				drv_vif.i_deser_valid_data 	<= 1'b0;
				drv_vif.seq_type 			<= 4'b0000;
			end
		end
		// In case of VALTRAIN pattern
		else if (drv_seq_item.seq_type == 3'b0010) begin
			//`uvm_info("BNB3T VALID SEQQQ", "VALIDD SEQQ", UVM_LOW);
			drv_vif.i_deser_valid_val 	<= 1'b1;
			drv_vif.i_deser_valid_data 	<= 1'b0;
			drv_vif.seq_type 			<= drv_seq_item.seq_type;
			repeat(32) @(posedge drv_vif.i_clk);
			if (drv_seq_item.last_seq) begin
				//`uvm_info("BNB3T VALID SEQQQ", "LAST SEQQQ", UVM_LOW);
				drv_vif.i_deser_valid_val 	<= 1'b0;
				drv_vif.seq_type 			<= 4'b0000;
			end
		end
		// In case of CLK pattern
		else if (drv_seq_item.seq_type == 3'b0001) begin
			drv_vif.i_deser_valid_val 	<= 1'b0;
			drv_vif.i_deser_valid_data 	<= 1'b0;
			drv_vif.seq_type 			<= drv_seq_item.seq_type;
			@(posedge drv_vif.i_clk);
			//`uvm_info( "Driver CLK Pattern" ,$sformatf("i_CKP = %0d, i_CKN = %0d, i_TRACK = %0d",drv_vif.i_CKP, drv_vif.i_CKN, drv_vif.i_TRACK)  ,UVM_MEDIUM);
		end
	endtask : deser_valid

endclass : MB_driver
