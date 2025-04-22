`timescale 1ns/1ps

typedef enum logic [2:0] {RESET, SBINIT, MBINIT, MBTRAIN, LINKINIT, ACTIVE, PHYRETRAIN, TRAINERROR} e_states;
typedef enum logic [3:0] {PARAM, CAL, REPAIRCLK, REPAIRVAL, REVERSALMB, REPAIRMB} e_sub_states_MBINIT;
typedef enum logic [3:0] {VALREF, DATAVREF, SPEEDIDLE, TXSELFCAL, RXCLKCAL, VALTRAINCENTER, VALTRAINVREF, DATATRAINCENTER1, DATATRAINVREF, RXDESKEW, DATATRAINCENTER2, LINKSPEED, REPAIR} e_sub_states_MBTRAIN;

module SB_DATA_ENCODER_TB ();
	// Inputs
    bit i_clk;
    logic i_rst_n;
    logic i_data_valid;
    logic i_msg_valid;
    e_states i_state;
    e_sub_states_MBINIT i_sub_state;
    logic [3:0] i_msg_no;
    logic [15:0] i_data_bus;

    // Outputs
    logic o_d_valid;
    logic [63:0] o_data_encoded;

    // Instantiate the Design
    SB_DATA_ENCODER dut (.*);

    // Clock generation
    always #5 i_clk = ~i_clk; // 10ns clock period

    initial begin
    	// Initialize inputs
    	Initialize();

    	// Reset
    	Reset();

    	repeat(100) begin
    		@(negedge i_clk);
    		Test_case_NOP();
    	end

    	repeat(100) begin
    		@(negedge i_clk);
    		Test_case_message_without_data();
    	end

    	repeat(100) begin
    		@(negedge i_clk);
    		Test_case_message_with_data();
    	end

    	$stop;

    end

    task Initialize();
	    i_data_valid = 0;
	    i_msg_valid = 0;
	    i_state = RESET;
	    i_sub_state = PARAM;
	    i_msg_no = 0;
	    i_data_bus = 0;
    endtask : Initialize

    task Reset();
    	i_rst_n = 0;
        repeat(5) @(negedge i_clk);
        i_rst_n = 1;
    endtask : Reset

    task Test_case_NOP();
    	i_msg_valid = 0;
    	i_data_valid = $random();
	    i_state = e_states'($random());
	    i_sub_state = e_sub_states_MBINIT'($random());
	    i_msg_no = $random();
	    i_data_bus = $random();
    endtask : Test_case_NOP

    task Test_case_message_without_data();
    	i_msg_valid = 1;
    	i_data_valid = 0;
	    i_state = e_states'($random());
	    i_sub_state = e_sub_states_MBINIT'($random());
	    i_msg_no = $random();
	    i_data_bus = $random();
    endtask : Test_case_message_without_data

    task Test_case_message_with_data();
    	i_msg_valid = 1;
    	i_data_valid = 1;
	    i_state = MBINIT;
	    i_sub_state = PARAM;
	    i_msg_no = $random();
	    i_data_bus = $random();
    endtask : Test_case_message_with_data

endmodule : SB_DATA_ENCODER_TB
