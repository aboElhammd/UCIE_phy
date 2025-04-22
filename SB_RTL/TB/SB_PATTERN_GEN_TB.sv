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

    integer count;

    // Instantiate the Design
    SB_PATTERN_GEN dut(.*);

    // Clock Generation
    always #5 i_clk = ~i_clk; // 10ns clock period

    initial begin
	    // Initialize inputs
	    i_start_pattern_req = 0;
	    i_rx_sb_pattern_samp_done = 0;

	    // Reset 
	    i_rst_n = 0;
	    repeat(5) @(negedge i_clk);
	    i_rst_n = 1;  
	    
	    repeat(10000)begin
	    	i_start_pattern_req = $random();
	    	i_rx_sb_pattern_samp_done = ~ i_start_pattern_req;
	    	@(negedge i_clk);
	    	//check();
	        $display("Time: %0t | Pattern Req: %b | RX Sample Done: %h | Pattern Done to LTSM: %b | Pattern : %h | Time Out: %h ",
	                 $time, i_start_pattern_req, i_rx_sb_pattern_samp_done, o_start_pattern_done, o_pattern, o_pattern_time_out);
	    end 
	    $stop; 
    end
/*
    task check();
    	
    endtask : check
*/
endmodule : SB_PATTERN_GEN_TB