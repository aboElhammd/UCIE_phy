`timescale 1ns/1ps

module SB_RX_WRAPPER_TB;

    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_de_ser_done;
    reg [63:0] i_deser_data;
    reg [2:0] i_state;

    // Outputs
    wire o_rx_sb_start_pattern;
    wire o_rx_sb_pattern_samp_done;
    wire o_rdi_msg;
    wire o_msg_valid;
    wire o_parity_error;
    wire o_rx_rsp_delivered;
    wire o_adapter_enable;
    wire o_tx_point_sweep_test_en;
    wire [1:0] o_tx_point_sweep_test;
    wire [3:0] o_msg_no;
    wire [2:0] o_msg_info;
    wire [15:0] o_data;
    wire [1:0] o_rdi_msg_code;
    wire [3:0] o_rdi_msg_sub_code;
    wire [1:0] o_rdi_msg_info;

    // Instantiate the Unit Under Test (UUT)
    SB_RX_WRAPPER dut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_de_ser_done(i_de_ser_done),
        .i_deser_data(i_deser_data),
        .i_state(i_state),
        .o_rx_sb_start_pattern(o_rx_sb_start_pattern),
        .o_rx_sb_pattern_samp_done(o_rx_sb_pattern_samp_done),
        .o_rdi_msg(o_rdi_msg),
        .o_msg_valid(o_msg_valid),
        .o_parity_error(o_parity_error),
        .o_rx_rsp_delivered(o_rx_rsp_delivered),
        .o_adapter_enable(o_adapter_enable),
        .o_tx_point_sweep_test_en(o_tx_point_sweep_test_en),
        .o_tx_point_sweep_test(o_tx_point_sweep_test),
        .o_msg_no(o_msg_no),
        .o_msg_info(o_msg_info),
        .o_data(o_data),
        .o_rdi_msg_code(o_rdi_msg_code),
        .o_rdi_msg_sub_code(o_rdi_msg_sub_code),
        .o_rdi_msg_info(o_rdi_msg_info)
    );

    // Clock generation
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        i_rst_n = 0;
        i_de_ser_done = 0;
        i_deser_data = 64'h0;
        i_state = 3'b001; 

        // Apply reset
        #20;
        i_rst_n = 1;

        // Test case 1: Pattern detection
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'hAAAAAAAAAAAAAAAA; // Example pattern
        #10;
        i_de_ser_done = 0;

        // Wait for pattern detection
        #50;

        // Test case 2: Header decode witout data
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'h0; 
        i_deser_data[4:0] = 5'b10010; // message without data
        // MBINIT.CAL
        i_deser_data[21:14] = 8'hA5;
		i_deser_data[39:32] = 8'h02;
		i_deser_data[58:56] = 3'b110;
		i_deser_data[62] = 1; // parity correct
        #10;
        i_de_ser_done = 0;

        // Wait for header decode
        #50;


        // Test case 3: Header decode witout data but with info
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'h0; 
        i_deser_data[4:0] = 5'b11011; // message with data
        
        i_deser_data[21:14] = 8'hA5;
		i_deser_data[39:32] = 8'h00;
		i_deser_data[58:56] = 3'b110; // dstid

		i_deser_data[62] = 0; // parity correct
		i_deser_data[63] = 0; 
        #10;
        i_de_ser_done = 0;

        // Wait 
        #50;

        // -----------------
        i_de_ser_done = 1;
        i_deser_data[10:0] = 11'b10101010101;

        #10;
        i_de_ser_done = 0;

         // Wait 
        #50;

        // Test case 3: Header decode with data 
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'h0; 
        i_deser_data[4:0] = 5'b10010; // message without data
        
        i_deser_data[21:14] = 8'hAA;
		i_deser_data[39:32] = 8'h04;
		i_deser_data[58:56] = 3'b110;
		i_deser_data [55:40] = 16'hFFFF;

		i_deser_data[62] = 1; // parity correct
        #10;
        i_de_ser_done = 0;

        // Wait for header decode
        #50;


/*
        // Test case 3: Data decode
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'hA5000000000000FF; // Example data
        #10;
        i_de_ser_done = 0;

        // Wait for data decode
        #50;

        // Test case 4: RDI decode
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'h00000000000000FF; // Example RDI
        #10;
        i_de_ser_done = 0;

        // Wait for RDI decode
        #50;

        // Test case 5: Parity error
        #10;
        i_de_ser_done = 1;
        i_deser_data = 64'hFFFFFFFFFFFFFFFF; // Example data with parity error
        #10;
        i_de_ser_done = 0;

        // Wait for parity error detection
        #50;
*/
        // End simulation
        $stop;
    end

endmodule
