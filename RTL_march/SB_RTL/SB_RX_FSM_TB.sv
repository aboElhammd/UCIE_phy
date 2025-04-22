`timescale 1ns/1ps

module SB_RX_FSM_tb;

    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_de_ser_done;
    reg i_header_valid;
    reg i_rdi_valid;
    reg i_data_valid;
    reg [63:0] i_deser_data;
    reg i_state;

    // Outputs
    wire o_rx_sb_start_pattern;
    wire o_rx_sb_pattern_samp_done;
    wire o_rdi_msg;
    wire o_msg_valid;
    wire o_header_enable;
    wire o_rdi_enable;
    wire o_data_enable;
    wire o_parity_error;
    wire o_rx_rsp_delivered;
    wire o_adapter_enable;

    // Instantiate the Unit Under Test (UUT)
    SB_RX_FSM dut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_de_ser_done(i_de_ser_done),
        .i_header_valid(i_header_valid),
        .i_rdi_valid(i_rdi_valid),
        .i_data_valid(i_data_valid),
        .i_deser_data(i_deser_data),
        .i_state(i_state),
        .o_rx_sb_start_pattern(o_rx_sb_start_pattern),
        .o_rx_sb_pattern_samp_done(o_rx_sb_pattern_samp_done),
        .o_rdi_msg(o_rdi_msg),
        .o_msg_valid(o_msg_valid),
        .o_header_enable(o_header_enable),
        .o_rdi_enable(o_rdi_enable),
        .o_data_enable(o_data_enable),
        .o_parity_error(o_parity_error),
        .o_rx_rsp_delivered(o_rx_rsp_delivered),
        .o_adapter_enable(o_adapter_enable)
    );

    // Clock generation
    always #5 i_clk = ~i_clk; // 100 MHz clock (10 ns period)

    // Testbench logic
    initial begin
        // Initialize inputs
        i_clk = 0;
        i_rst_n = 0;
        i_de_ser_done = 0;
        i_header_valid = 0;
        i_rdi_valid = 0;
        i_data_valid = 0;
        i_deser_data = 64'h0;
        i_state = 0;

        // Apply reset
        #10;
        i_rst_n = 1; // Deassert reset
        #10;

        // Scenario 1: IDLE -> PATTERN_DETECT -> GENERAL_DECODE
        $display("Scenario 1: IDLE -> PATTERN_DETECT -> GENERAL_DECODE");
        i_de_ser_done = 1;
        i_deser_data = 64'hAAAAAAAAAAAAAAAA; // Correct pattern
        #10;
        i_de_ser_done = 0;
        i_state = 1;
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'hAAAAAAAAAAAAAAAA; // Correct pattern
        #10;
        i_de_ser_done = 0;
        #20;

        // Scenario 2: GENERAL_DECODE -> HEADER_DECODE
        $display("Scenario 2: GENERAL_DECODE -> HEADER_DECODE");
        i_deser_data = 64'h0000000000000000; // dstid[0] = 1, MsgCode = 0
        i_deser_data[56] = 1;
        i_deser_data[21:14] = 8'h95;  //sibinit done req
        i_deser_data[62] = 1;
        i_de_ser_done = 1;
        #10;
        i_de_ser_done = 0;
        i_header_valid = 1;
        #10;
        i_header_valid = 0;
        #10;

        // Scenario 3: GENERAL_DECODE -> HEADER_DECODE -> DATA_DECODE
        $display("Scenario 3: GENERAL_DECODE -> HEADER_DECODE -> DATA_DECODE");
        i_deser_data = 64'h0000000000000000; // dstid[0] = 0, MsgCode != 0
        i_deser_data[56] = 1;
        i_deser_data[21:14] = 8'h9A;  //sibinit done resp
        i_deser_data [4:0] = 5'b11011; // message with data
        i_deser_data [62] = 1;
        i_de_ser_done = 1;
        #10;
        i_de_ser_done = 0;
        i_header_valid = 1;
        #10;
        i_header_valid = 0;
        #120;
        i_de_ser_done = 1;
        #10;
        i_de_ser_done = 0;
        i_data_valid = 1;
        #10;
        i_data_valid = 0;
        #20;

        // Scenario 4: GENERAL_DECODE -> RDI_DECODE
        $display("Scenario 4: GENERAL_DECODE -> RDI_DECODE");
        i_deser_data = 64'h0000000000000000; // dstid[0] = 0, MsgCode != 0
        i_deser_data[56] = 1;
        i_deser_data[21:18] = 0;  // RDI message
        i_deser_data [62] = 1;
        i_de_ser_done = 1;
        #10;
        i_de_ser_done = 0;
        i_rdi_valid = 1;
        #10;
        i_rdi_valid = 0;
        #20;

		// Scenario 5: GENERAL_DECODE -> ADAPTER
        $display("Scenario 5: GENERAL_DECODE -> ADAPTER");
        i_deser_data = 64'h0000000000000000; // dstid[0] = 0, MsgCode != 0
        i_deser_data[56] = 0;
        i_deser_data[21:18] = 0;  // RDI message
        //i_deser_data [62] = 1;
        i_de_ser_done = 1;
        #10;
        i_de_ser_done = 0;
        #20;
        // End simulation
        $display("Simulation completed.");
        $stop;
    end

endmodule
