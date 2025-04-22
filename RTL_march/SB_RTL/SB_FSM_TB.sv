`timescale 1ns/1ps

module SB_FSM_tb;

    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_start_pattern_req;
    reg i_pattern_done;
    reg i_msg_valid;
    reg i_d_valid;
    reg i_header_valid;
    reg i_time_out_enable;
    reg i_packet_valid;
    reg i_rx_sb_rsp_delivered;
    reg i_start_pattern_done;

    // Outputs
    wire o_pattern_enable;
    wire o_header_encoder_enable;
    wire o_data_encoder_enable;
    wire o_header_frame_enable;
    wire o_data_frame_enable;
    wire o_packet_enable;
    wire o_start_count;
    wire o_busy;
    wire o_start_pattern_done;

    // Instantiate the Unit Under Test (UUT)
    SB_FSM sb_fsm_dut (.*);

    // Clock generation
    always #5 i_clk = ~i_clk; // 10ns clock period

    // Testbench logic
    initial begin
        // Initialize inputs
        i_clk = 0;
        i_rst_n = 0;
        i_start_pattern_req = 0;
        i_pattern_done = 0;
        i_msg_valid = 0;
        i_d_valid = 0;
        i_header_valid = 0;
        i_time_out_enable = 0;
        i_packet_valid = 0;
        i_rx_sb_rsp_delivered = 0;
        i_start_pattern_done = 0;

        // Reset the system
        repeat(5) @(negedge i_clk);
        i_rst_n = 1;
        repeat(5) @(negedge i_clk);

        // Test case 1: IDLE -> PATTERN_GEN -> IDLE
        i_start_pattern_req = 1;
        @(negedge i_clk);
        i_start_pattern_req = 0;
        repeat(20) @(negedge i_clk);
        i_start_pattern_done = 1;
        @(negedge i_clk);
        i_start_pattern_done = 0;

        // Test case 2: IDLE -> LTSM_ENCODE -> DATA_FRAME -> HEADER_FRAME -> END_MESSAGE
        i_msg_valid = 1;
        @(negedge i_clk);
        i_d_valid = 1;
        @(negedge i_clk);
        i_d_valid = 0;
        i_header_valid = 1;
        @(negedge i_clk);
        i_header_valid = 0;
        i_packet_valid = 1;
        @(negedge i_clk);
        i_packet_valid = 0;

        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | State: %s | Outputs: o_pattern_enable=%b, o_header_encoder_enable=%b, o_data_encoder_enable=%b, o_header_frame_enable=%b, o_data_frame_enable=%b, o_packet_enable=%b, o_start_count=%b, o_busy=%b, o_start_pattern_done=%b",
                 $time, sb_fsm_dut.cs.name(), o_pattern_enable, o_header_encoder_enable, o_data_encoder_enable, o_header_frame_enable, o_data_frame_enable, o_packet_enable, o_start_count, o_busy, o_start_pattern_done);
    end

endmodule