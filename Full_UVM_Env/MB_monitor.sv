class MB_monitor extends uvm_monitor;

    /*-------------------------------------------------------------------------------
    -- Interface, port, fields
    -------------------------------------------------------------------------------*/
    virtual MB_interface mon_vif;
    MB_sequence_item mon_seq_item;
    uvm_analysis_port #(MB_sequence_item) mon_ap;
    int file; // File descriptor

    integer next_PRBS_Pattern = 0;
    integer cntr = 1;
    
    localparam SER_WIDTH = 32;
    logic [SER_WIDTH-1:0] Data_per_lane_ID[16];
    logic [3:0] seq_type;

    // PRBS Pattern Storage
	reg [31:0] prbs_mem_0 [0:262144]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_1 [0:262144]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_2 [0:262144]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_3 [0:262144]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_4 [0:262144]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_5 [0:262144]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_6 [0:262144]; // 8 lanes x 262144 words
	reg [31:0] prbs_mem_7 [0:262144]; // 8 lanes x 262144 words

    /*-------------------------------------------------------------------------------
    -- UVM Factory register
    -------------------------------------------------------------------------------*/
    `uvm_component_utils(MB_monitor)

    /*-------------------------------------------------------------------------------
    -- Functions
    -------------------------------------------------------------------------------*/
    // Constructor
    function new(string name = "MB_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    // Initialize Data_per_lane_ID array
    function void init_data_per_lane_id();
        for (int i = 0; i < 16; i++) begin
            Data_per_lane_ID[i] = {4'b1010, 8'(i), 4'b1010, 4'b1010, 8'(i), 4'b1010};
        end
    endfunction : init_data_per_lane_id

    // Initialize PRBS Pattern Storage
    task load_patterns();
	    $readmemh("PRBS_GM_Lane_0.txt", prbs_mem_0);
	    $readmemh("PRBS_GM_Lane_1.txt", prbs_mem_1);
	    $readmemh("PRBS_GM_Lane_2.txt", prbs_mem_2);
	    $readmemh("PRBS_GM_Lane_3.txt", prbs_mem_3);
	    $readmemh("PRBS_GM_Lane_4.txt", prbs_mem_4);
	    $readmemh("PRBS_GM_Lane_5.txt", prbs_mem_5);
	    $readmemh("PRBS_GM_Lane_6.txt", prbs_mem_6);
	    $readmemh("PRBS_GM_Lane_7.txt", prbs_mem_7);
	endtask

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
        file = $fopen("mon_data.txt", "w");
        if (!file) begin
            `uvm_error("MB_MONITOR", "Failed to open mon_data.txt for writing")
        end
        load_patterns();
        init_data_per_lane_id();
    endfunction : build_phase

    // Run Phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        mon_seq_item = MB_sequence_item::type_id::create("mon_seq_item", this);
        forever begin
            @(posedge mon_vif.i_clk);
            // Clock operation
            mon_seq_item.o_CKP 				= mon_vif.o_CKP;
            mon_seq_item.o_CKN 				= mon_vif.o_CKN;
            mon_seq_item.o_TRACK 			= mon_vif.o_TRACK;
            // Valid lane
            mon_seq_item.o_TVLD_L 			= mon_vif.o_TVLD_L;
            // Data lanes
            mon_seq_item.o_lfsr_tx_lane_0  	= mon_vif.o_lfsr_tx_lane_0;
            mon_seq_item.o_lfsr_tx_lane_1  	= mon_vif.o_lfsr_tx_lane_1;
            mon_seq_item.o_lfsr_tx_lane_2  	= mon_vif.o_lfsr_tx_lane_2;
            mon_seq_item.o_lfsr_tx_lane_3  	= mon_vif.o_lfsr_tx_lane_3;
            mon_seq_item.o_lfsr_tx_lane_4  	= mon_vif.o_lfsr_tx_lane_4;
            mon_seq_item.o_lfsr_tx_lane_5  	= mon_vif.o_lfsr_tx_lane_5;
            mon_seq_item.o_lfsr_tx_lane_6  	= mon_vif.o_lfsr_tx_lane_6;
            mon_seq_item.o_lfsr_tx_lane_7  	= mon_vif.o_lfsr_tx_lane_7;
            mon_seq_item.o_lfsr_tx_lane_8  	= mon_vif.o_lfsr_tx_lane_8;
            mon_seq_item.o_lfsr_tx_lane_9  	= mon_vif.o_lfsr_tx_lane_9;
            mon_seq_item.o_lfsr_tx_lane_10 	= mon_vif.o_lfsr_tx_lane_10;
            mon_seq_item.o_lfsr_tx_lane_11 	= mon_vif.o_lfsr_tx_lane_11;
            mon_seq_item.o_lfsr_tx_lane_12 	= mon_vif.o_lfsr_tx_lane_12;
            mon_seq_item.o_lfsr_tx_lane_13 	= mon_vif.o_lfsr_tx_lane_13;
            mon_seq_item.o_lfsr_tx_lane_14 	= mon_vif.o_lfsr_tx_lane_14;
            mon_seq_item.o_lfsr_tx_lane_15 	= mon_vif.o_lfsr_tx_lane_15;
            
            mon_seq_item.seq_type = mon_vif.seq_type;

            mon_ap.write(mon_seq_item);

            

            //@(mon_vif.o_serliazer_data_en);
            case (mon_seq_item.seq_type)
                4'b1000: begin
                    seq_type = 4'b1000;
                    check_LFSR_pattern(mon_seq_item);
                    repeat(31) @(posedge mon_vif.i_clk);
                end
                4'b0100: begin
           		    seq_type = 4'b0100;
                    check_per_lane_id_pattern(mon_seq_item);
                    repeat(31) @(posedge mon_vif.i_clk);
                end
                4'b0010: begin
                    seq_type = 4'b0010;
                    check_valid_pattern(mon_seq_item);
                    repeat(31) @(posedge mon_vif.i_clk);
                end
                4'b0001: begin
                    //cntr ++;
                    seq_type = 4'b0001;
                    check_clock_pattern(mon_seq_item);
                end
                4'b0000: begin
                	case (seq_type)
		                4'b1000: begin
		                	if (mon_vif.o_serliazer_data_en) begin
		                		check_LFSR_pattern(mon_seq_item);
		                    	repeat(31) @(posedge mon_vif.i_clk);
		                	end
		                	else if (cntr != 1) begin
		                		$display("***************************************************************************");
		                    	$display("///////////////////////////////////////////////////////////////////////////");
		                    	`uvm_info("MB_MONITOR", $sformatf("LFSR Pattern no. %0d patterns", cntr), UVM_MEDIUM)
		                    	$display("///////////////////////////////////////////////////////////////////////////");
		                    	$display("***************************************************************************");
		                    	if (cntr != 128)
		                    		`uvm_error("MB_MONITOR", $sformatf("LFSR Pattern is %0d less than 128", cntr))
                				seq_type = 4'b0000;
		                	end                    
		                end
		                4'b0100: begin
		                	if (mon_vif.o_serliazer_data_en) begin
		                		check_per_lane_id_pattern(mon_seq_item);
		                    	repeat(31) @(posedge mon_vif.i_clk);
		                	end
		                	else if (cntr != 1) begin
		                		$display("***************************************************************************");
		                    	$display("///////////////////////////////////////////////////////////////////////////");
		                    	`uvm_info("MB_MONITOR", $sformatf("Per-Lane Pattern no. %0d patterns", cntr), UVM_MEDIUM)
		                    	$display("///////////////////////////////////////////////////////////////////////////");
		                    	$display("***************************************************************************");
		                    	if (cntr != 64)
		                    		`uvm_error("MB_MONITOR", $sformatf("Per-Lane ID Pattern is %0d less than 64", cntr))
                				seq_type = 4'b0000;
		                	end 
		                end
		                4'b0010: begin	
		                	if (mon_vif.o_serliazer_valid_en) begin
			                    check_valid_pattern(mon_seq_item);
			                    repeat(31) @(posedge mon_vif.i_clk);
			                end
			                else if (cntr != 1) begin
			                	$display("***************************************************************************");
		                    	$display("///////////////////////////////////////////////////////////////////////////");
		                    	`uvm_info("MB_MONITOR", $sformatf("VALTRAIN Pattern no. %0d patterns", cntr), UVM_MEDIUM)
		                    	$display("///////////////////////////////////////////////////////////////////////////");
		                    	$display("***************************************************************************");
		                    	if (cntr != 32)
		                    		`uvm_error("MB_MONITOR", $sformatf("VALTRAIN Pattern is %0d less than 32", cntr))
                				seq_type = 4'b0000;
		                	end 
		                end
		                4'b0001: begin
                			seq_type = 4'b0000;
	                	end
	                	4'b0000: begin
		                	next_PRBS_Pattern = 0;
                			cntr = 1;
	                	end
	                endcase
                end
            endcase
        end
    endtask : run_phase


    // Check LFSR pattern for all 16 lanes
    task check_LFSR_pattern(MB_sequence_item mon_seq_item);

    	logic [SER_WIDTH-1:0] lane_data;
        logic [SER_WIDTH-1:0] lane_data_GM;

        if (mon_vif.o_serliazer_data_en) begin
            for (int i = 0; i < 16; i++) begin
                case (i)
                    0:  begin 
                    	lane_data 		= mon_seq_item.o_lfsr_tx_lane_0;
                    	lane_data_GM 	= prbs_mem_0 [next_PRBS_Pattern];
                    end
                    1:  begin 
                    	lane_data 		= mon_seq_item.o_lfsr_tx_lane_1;
                    	lane_data_GM 	= prbs_mem_1 [next_PRBS_Pattern];
                    end
                    2:  begin 
                    	lane_data 	 	= mon_seq_item.o_lfsr_tx_lane_2;
                    	lane_data_GM 	= prbs_mem_2 [next_PRBS_Pattern];
                    end
                    3:  begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_3;
                    	lane_data_GM 	= prbs_mem_3 [next_PRBS_Pattern];
                    end
                    4:  begin 
                    	lane_data 	 	= mon_seq_item.o_lfsr_tx_lane_4;
                    	lane_data_GM 	= prbs_mem_4 [next_PRBS_Pattern];
                    end
                    5:  begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_5;
                    	lane_data_GM 	= prbs_mem_5 [next_PRBS_Pattern];
                    end
                    6:  begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_6;
                    	lane_data_GM 	= prbs_mem_6 [next_PRBS_Pattern];
                    end
                    7:  begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_7;
                    	lane_data_GM 	= prbs_mem_7 [next_PRBS_Pattern];
                    end
                    8:  begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_8;
                    	lane_data_GM 	= prbs_mem_0 [next_PRBS_Pattern];
                    end
                    9:  begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_9;
                    	lane_data_GM 	= prbs_mem_1 [next_PRBS_Pattern];
                    end
                    10: begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_10;
                    	lane_data_GM 	= prbs_mem_2 [next_PRBS_Pattern];
                    end
                    11: begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_11;
                    	lane_data_GM 	= prbs_mem_3 [next_PRBS_Pattern];
                    end
                    12: begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_12;
                    	lane_data_GM 	= prbs_mem_4 [next_PRBS_Pattern];
                    end
                    13: begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_13;
                    	lane_data_GM 	= prbs_mem_5 [next_PRBS_Pattern];
                    end
                    14: begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_14;
                    	lane_data_GM 	= prbs_mem_6 [next_PRBS_Pattern];
                    end
                    15: begin 
                    	lane_data   	= mon_seq_item.o_lfsr_tx_lane_15;
                    	lane_data_GM 	= prbs_mem_7 [next_PRBS_Pattern];
                    end
                endcase

                if (lane_data == lane_data_GM) begin
                    // `uvm_info("MB_MONITOR", $sformatf("Data o_lfsr_tx_lane_%0d is correct: %0h,  next_PRBS_Pattern %0d", i, lane_data, next_PRBS_Pattern), UVM_MEDIUM)
                end else begin
                    `uvm_error("MB_MONITOR", $sformatf("Data o_lfsr_tx_lane_%0d is incorrect: expected %0h, got %0h,  next_PRBS_Pattern %0d", 
                                                       i, lane_data_GM, lane_data, next_PRBS_Pattern))
                end
            end
        	next_PRBS_Pattern ++;
        	cntr ++;
        end
    endtask : check_LFSR_pattern



    // Check per-lane ID pattern for all 16 lanes
    task check_per_lane_id_pattern(MB_sequence_item mon_seq_item);

        if (mon_vif.o_serliazer_data_en) begin
            for (int i = 0; i < 16; i++) begin
                logic [SER_WIDTH-1:0] lane_data;
                case (i)
                    0:  lane_data = mon_seq_item.o_lfsr_tx_lane_0;
                    1:  lane_data = mon_seq_item.o_lfsr_tx_lane_1;
                    2:  lane_data = mon_seq_item.o_lfsr_tx_lane_2;
                    3:  lane_data = mon_seq_item.o_lfsr_tx_lane_3;
                    4:  lane_data = mon_seq_item.o_lfsr_tx_lane_4;
                    5:  lane_data = mon_seq_item.o_lfsr_tx_lane_5;
                    6:  lane_data = mon_seq_item.o_lfsr_tx_lane_6;
                    7:  lane_data = mon_seq_item.o_lfsr_tx_lane_7;
                    8:  lane_data = mon_seq_item.o_lfsr_tx_lane_8;
                    9:  lane_data = mon_seq_item.o_lfsr_tx_lane_9;
                    10: lane_data = mon_seq_item.o_lfsr_tx_lane_10;
                    11: lane_data = mon_seq_item.o_lfsr_tx_lane_11;
                    12: lane_data = mon_seq_item.o_lfsr_tx_lane_12;
                    13: lane_data = mon_seq_item.o_lfsr_tx_lane_13;
                    14: lane_data = mon_seq_item.o_lfsr_tx_lane_14;
                    15: lane_data = mon_seq_item.o_lfsr_tx_lane_15;
                endcase

                if (lane_data == Data_per_lane_ID[i]) begin
                    // `uvm_info("MB_MONITOR", $sformatf("Data o_lfsr_tx_lane_%0d is correct: %0h", i, lane_data), UVM_MEDIUM)
                end else begin
                    `uvm_error("MB_MONITOR", $sformatf("Data o_lfsr_tx_lane_%0d is incorrect: expected %0h, got %0h", 
                                                       i, Data_per_lane_ID[i], lane_data))
                end
            end
            cntr ++;
        end
    endtask : check_per_lane_id_pattern

    task check_valid_pattern(MB_sequence_item mon_seq_item);

        if (mon_vif.o_serliazer_valid_en) begin
            logic [SER_WIDTH-1:0] valid_pattern = 32'hf0f0f0f0;
            if (mon_seq_item.o_TVLD_L == valid_pattern) begin
                //`uvm_info("MB_MONITOR", $sformatf("Data o_TVLD_L is correct: %0h", mon_seq_item.o_TVLD_L), UVM_MEDIUM)
            end else begin
                `uvm_error("MB_MONITOR", $sformatf("Data o_TVLD_L is incorrect: expected %0h, got %0h", valid_pattern, mon_seq_item.o_TVLD_L))
                // valid_pattern_Error_count ++;
            end
            cntr ++;
        end
    endtask : check_valid_pattern

    // Check clock pattern for o_CKP, o_CKN, o_TRACK for exactly 128 blocks
    task check_clock_pattern(MB_sequence_item mon_seq_item);
        static int cycle_count 			= 0;
        static int block_count 			= 0;
        static logic expected_CKP 		= 1; // Initial value from MB_CLK_Pattern_sequence
        static logic expected_CKN 		= 0; // Initial value (inverse of CKP)
        static logic expected_TRACK 	= 1; // Initial value
        static bit clock_check_enabled 	= 0; // Flag to enable checking after first o_CKP == 1
        static bit first_ckp_detected 	= 0; // Flag to track first o_CKP == 1
        static bit check_completed 		= 0; // Flag to ensure checking stops after 128 blocks
    
        if (mon_seq_item.seq_type == 4'b0001 && !check_completed) begin
            // Detect first o_CKP == 1 to start checking
            if (!first_ckp_detected && mon_seq_item.o_CKP == 1) begin
                first_ckp_detected = 1;
                clock_check_enabled = 1;
                `uvm_info("MB_MONITOR", $sformatf("First o_CKP == 1 detected, starting clock pattern check"), UVM_MEDIUM)
            end
    
            // Perform checking only if enabled
            if (clock_check_enabled) begin
                // Check if in toggling phase (first 32 cycles) or idle phase (next 16 cycles)
                if (cycle_count < 32) begin
                    // Verify toggling behavior
                    if (mon_seq_item.o_CKP != expected_CKP) begin
                        `uvm_error("MB_MONITOR", $sformatf("o_CKP incorrect at block %0d, cycle %0d: expected %0b, got %0b", 
                                                           block_count, cycle_count, expected_CKP, mon_seq_item.o_CKP))
                    end
                    if (mon_seq_item.o_CKN != expected_CKN) begin
                        `uvm_error("MB_MONITOR", $sformatf("o_CKN incorrect at block %0d, cycle %0d: expected %0b, got %0b", 
                                                           block_count, cycle_count, expected_CKN, mon_seq_item.o_CKN))
                    end
                    if (mon_seq_item.o_TRACK != expected_TRACK) begin
                        `uvm_error("MB_MONITOR", $sformatf("o_TRACK incorrect at block %0d, cycle %0d: expected %0b, got %0b", 
                                                           block_count, cycle_count, expected_TRACK, mon_seq_item.o_TRACK))
                    end
                    // Update expected values for next cycle (toggle)
                    expected_CKP = ~expected_CKP;
                    expected_CKN = ~expected_CKP;
                    expected_TRACK = ~expected_TRACK;
                end else if (cycle_count < 48) begin
                    // Verify idle phase (all 0)
                    if (mon_seq_item.o_CKP != 0) begin
                        `uvm_error("MB_MONITOR", $sformatf("o_CKP incorrect at block %0d, cycle %0d: expected 0, got %0b", 
                                                           block_count, cycle_count, mon_seq_item.o_CKP))
                    end
                    if (mon_seq_item.o_CKN != 0) begin
                        `uvm_error("MB_MONITOR", $sformatf("o_CKN incorrect at block %0d, cycle %0d: expected 0, got %0b", 
                                                           block_count, cycle_count, mon_seq_item.o_CKN))
                    end
                    if (mon_seq_item.o_TRACK != 0) begin
                        `uvm_error("MB_MONITOR", $sformatf("o_TRACK incorrect at block %0d, cycle %0d: expected 0, got %0b", 
                                                           block_count, cycle_count, mon_seq_item.o_TRACK))
                    end
                end
    
                // Update cycle count
                cycle_count++;
                if (cycle_count == 48) begin
                    // Reset for next block
                    cycle_count = 0;
                    block_count++;
                    expected_CKP = 1; // Reset to initial value for next block
                    expected_CKN = 0;
                    expected_TRACK = 1;
    
                    // Stop checking after exactly 128 blocks
                    if (block_count == 127) begin
                        clock_check_enabled = 0;
                        first_ckp_detected = 0; // Reset for potential future use
                        check_completed = 1; // Ensure no further checking
                        `uvm_info("MB_MONITOR", $sformatf("Completed exactly 128 blocks for CLK pattern sequence"), UVM_MEDIUM)
                    end
                end
            end
        end
    endtask : check_clock_pattern

    // Final Phase
    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        $fclose(file);
    endfunction : final_phase

endclass : MB_monitor