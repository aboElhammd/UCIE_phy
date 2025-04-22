class packet_rand;
	rand logic i_rst_n;
    rand logic i_start_pattern_req;
    rand logic i_rx_sb_pattern_samp_done;
    rand logic i_rx_sb_rsp_delivered;
    rand logic i_packet_valid;
    rand logic i_ser_done;
    rand logic i_timeout_ctr_start;
    rand logic [63:0] i_framed_packet_phase;

    //bit rx_state;
    rand int N_cycles; // dh rkm hrandom feh 3dd cycles bt3br 3n el time ely el rx hystnah 3o2bal ma y detect pattern galo mn el partner b3d ma b3t ana ka tx el pattern 
    int cycle_count; // dh counter h3d feh 3dd N_cycles
    int req_count; // dh counter y handle en ygely start pattern request every 800 count (8ms)

    constraint pattern_test_from_LTSM { 
    	i_rst_n == 1;
    	i_start_pattern_req dist {1 := 3, 0 := 7};
    	i_timeout_ctr_start == 0;
    	i_packet_valid == 0;
    	i_ser_done == 1;
    }

    constraint rx_detect_delay {
        // Keep i_rx_sb_pattern_samp_done low for N cycles
        if (cycle_count == N_cycles) {
            i_rx_sb_pattern_samp_done == 1;
        	i_rx_sb_rsp_delivered == 1;
        }
        // Set i_rx_sb_pattern_samp_done high after N cycles
        else {
            i_rx_sb_pattern_samp_done == 0;
        	i_rx_sb_rsp_delivered == 0;
        }
    }

    constraint start_pattern_delay {
        
        if (req_count == 800) {
            i_start_pattern_req == 1;
        }
        
        else {
            i_start_pattern_req == 0;
        }
    }

    constraint N_cycles_range {
        N_cycles inside {[50:100]}; 
    } 

endclass : packet_rand

module SB_PACKET_ENCODER_WRAPPER_TB;
    // Inputs
    bit i_clk;
    logic i_rst_n;
    logic i_start_pattern_req;
    logic i_rx_sb_pattern_samp_done;
    logic i_rx_sb_rsp_delivered;
    logic i_packet_valid;
    logic i_ser_done;
    logic i_timeout_ctr_start;
    logic [63:0] i_framed_packet_phase;

    // Outputs
    logic o_start_pattern_done;
    logic [63:0] o_final_packet;
    logic o_time_out;

    // Internal
    packet_rand pkt;
    //int cycle_count ; // dh counter h3d feh 3dd N_cycles
    bit rx_state;

    // Instantiate the Design
    SB_PACKET_ENCODER_WRAPPER dut (.*);

    // Clock generation
    always #5 i_clk = ~i_clk; // 10ns clock period	

    initial begin
    	// Initialize inputs
	    i_start_pattern_req = 0;
	    i_rx_sb_pattern_samp_done = 0;
	    i_rx_sb_rsp_delivered = 0;
	    i_packet_valid = 0;
	    i_ser_done = 0;
	    i_timeout_ctr_start = 0;
	    i_framed_packet_phase = 0;

	    // Reset
        i_rst_n = 0;
        repeat(5) @(negedge i_clk);
        i_rst_n = 1;

        pkt = new();

        // Pattern Test initiated from LTSM without occuring time_out
        $display("---------------------------- In SBINIT State -------------------------------");
	    $display("---------------------- LTSM request to send Pattern ------------------------");

        repeat(10000) begin
        	assert(pkt.randomize());

    		Assign_random();
    		if (i_rx_sb_pattern_samp_done) begin
        		@(negedge i_clk);
        		i_rx_sb_pattern_samp_done = 0;
        		i_rx_sb_rsp_delivered = 0;
        	end
    		delay_model_for_rx_to_detect_pattern(pkt.N_cycles);

		    @(negedge i_clk);
		    
        end

        $stop;
    end

    task Assign_random();
    	i_rst_n = pkt.i_rst_n;
	    i_start_pattern_req = pkt.i_start_pattern_req;
	    i_rx_sb_pattern_samp_done = pkt.i_rx_sb_pattern_samp_done;
	    i_rx_sb_rsp_delivered = pkt.i_rx_sb_rsp_delivered;
	    i_packet_valid = pkt.i_packet_valid;
	    i_ser_done = pkt.i_ser_done;
	    i_timeout_ctr_start = pkt.i_timeout_ctr_start;
	    i_framed_packet_phase = pkt.i_framed_packet_phase;	
    endtask : Assign_random

    // Task to model the delay for RX to detect the pattern
    task delay_model_for_rx_to_detect_pattern(int cycles);
    	pkt.cycle_count = 0;
        forever begin
            @(posedge i_clk);
            if (!i_rst_n) begin
                pkt.cycle_count = 0; 
                pkt.req_count = 0;
            end
            else begin
            	if (pkt.req_count < 800) begin
                    pkt.req_count = pkt.req_count + 1; 
                end
                if (pkt.cycle_count < cycles) begin
                    pkt.cycle_count = pkt.cycle_count + 1; 
                end
                else begin
                	break;
                end
            end
        end
    endtask : delay_model_for_rx_to_detect_pattern

endmodule : SB_PACKET_ENCODER_WRAPPER_TB

