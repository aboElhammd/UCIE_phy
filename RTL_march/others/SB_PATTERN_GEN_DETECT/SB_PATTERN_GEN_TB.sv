module SB_PATTERN_GEN_TB;
	// Inputs
    bit i_clk;
    logic i_rst_n;
    logic i_start_pattern_req;
    logic i_rx_sb_pattern_samp_done;
    logic i_ser_done;

    // Outputs
    logic o_start_pattern_done;
    logic [63:0] o_pattern;
    logic o_pattern_time_out;
    logic o_pattern_valid;

    //integer count;

    // Instantiate the Design
    SB_PATTERN_GEN dut(.*);

    // Clock Generation
    always #5 i_clk = ~i_clk; // 10ns clock period

    initial begin
	    // Initialize inputs
	    init();

	    // Reset 
	    rst(); 


	    //Time Out test case
	    //timeout_test_case();
	    
	    //Normal test case
	    normal_test_case();


	    $stop; 
    end


    task init();
		i_start_pattern_req			= 0;
	    i_rx_sb_pattern_samp_done 	= 0;
	    i_ser_done 					= 0;
	endtask


    task rst();
			i_rst_n = 0;
			repeat (10) @(negedge i_clk);
			i_rst_n = 1;
	endtask : rst


	task timeout_test_case();
		i_start_pattern_req = 1;
		i_ser_done 			= 1;
		@(negedge i_clk);
		i_start_pattern_req = 0;
		for (int i = 0; i < 1000; i++) begin
			i_ser_done = $random();
			@(negedge i_clk);
			if (!i_ser_done && o_pattern_valid) begin
				$display("t: ERROR",$time());
			end
		end
	endtask : timeout_test_case

	task normal_test_case();
		i_start_pattern_req = 1;
		i_ser_done 			= 1;
		@(negedge i_clk);
		i_start_pattern_req = 0;
		for (int i = 0; i < 1000; i++) begin
			//i_ser_done = $random();
			@(negedge i_clk);
			if (i == 10) begin
				i_rx_sb_pattern_samp_done = 1;
			end
			if (i == 11) begin
				i_rx_sb_pattern_samp_done = 0;
			end
			if (i == 14) begin
				if (!o_start_pattern_done) begin
					$display("t: ERROR",$time());
				end
			end
			if (!i_ser_done && o_pattern_valid) begin
				$display("t: ERROR",$time());
			end
		end
	endtask : normal_test_case


endmodule : SB_PATTERN_GEN_TB