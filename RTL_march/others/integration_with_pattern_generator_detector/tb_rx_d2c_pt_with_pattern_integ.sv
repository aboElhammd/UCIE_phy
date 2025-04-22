module tb_rx_d2c_pt_with_pattern_integ;

    ///////////////////////////////////
    /////////// PARAMETERS ////////////
    ///////////////////////////////////
    localparam SB_MSG_WIDTH = 4;

    /*---------------------------------
    * Sideband messages
    ---------------------------------*/
    typedef enum {  START_RX_D2C_PT_REQ  	 = 1, 
                    START_RX_D2C_PT_RESP	 = 2,
                    LFSR_CLR_ERROR_REQ		 = 3,
                    LFSR_CLR_ERROR_RESP      = 4,
                    COUNT_DONE_REQ           = 5,
                    COUNT_DONE_RESP          = 6,
                    END_RX_D2C_PT_REQ        = 7,
                    END_RX_D2C_PT_RESP       = 8
    } sideband_messages;
    /*---------------------------------
    * TX FSM States
    ---------------------------------*/
    typedef enum {  IDLE_TX 				 = 0,
                    START_REQ         		 = 1,
                    LFSR_CLEAR_REQ    		 = 2,
                    SEND_PATTERN 			 = 3,
                    COUNT_DONE   			 = 4,
                    END_REQ                  = 5,
                    TEST_FINISHED_TX         = 6
    } states_tx;
    /*---------------------------------
    * RX FSM States
    ---------------------------------*/
    typedef enum {  IDLE_RX 			     = 0,
                    WAIT_FOR_START_REQ       = 1,
                    SEND_START_RESP        	 = 2,
                    WAIT_FOR_LFSR_CLEAR_REQ	 = 3,
                    SEND_LFSR_CLEAR_RESP	 = 4,
                    WAIT_FOR_COUNT_DONE_REQ  = 5,
                    SEND_COUNT_DONE_RESP     = 6,
                    WAIT_FOR_END_REQ         = 7,
                    SEND_END_RESP            = 8,
                    TEST_FINISHED_RX         = 9
    } states_rx;

    states_tx CS_tx, NS_tx, CS_tx_partner, NS_tx_partner;
    states_rx CS_rx, NS_rx, CS_rx_partner, NS_rx_partner;
    sideband_messages i_decoded_sideband_msg_mod, o_encoded_sideband_msg_mod;
    sideband_messages i_decoded_sideband_msg_partner, o_encoded_sideband_msg_partner;

    ///////////////////////////////////
    /////// FOR DEBUGGING ONLY ////////
    ///////////////////////////////////

    always @ (*) begin
        CS_tx = states_tx'(MODULE_inst.TX_inst.CS);
        NS_tx = states_tx'(MODULE_inst.TX_inst.NS);
        CS_rx = states_rx'(MODULE_inst.RX_inst.CS);
        NS_rx = states_rx'(MODULE_inst.RX_inst.NS);
        CS_tx_partner = states_tx'(PARTNER_inst.TX_inst.CS);
        NS_tx_partner = states_tx'(PARTNER_inst.TX_inst.NS);
        CS_rx_partner = states_rx'(PARTNER_inst.RX_inst.CS);
        NS_rx_partner = states_rx'(PARTNER_inst.RX_inst.NS);
        i_decoded_sideband_msg_mod = sideband_messages'(MODULE_inst.i_decoded_SB_msg);
        o_encoded_sideband_msg_mod = sideband_messages'(MODULE_inst.o_encoded_SB_msg);
        i_decoded_sideband_msg_partner = sideband_messages'(PARTNER_inst.i_decoded_SB_msg);
        o_encoded_sideband_msg_partner = sideband_messages'(PARTNER_inst.o_encoded_SB_msg);
    end

    ///////////////////////////////////
    /////// SIGNAL DECLARATION ////////
    ///////////////////////////////////

   /*********************
   * Module
   *********************/
    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_rx_d2c_pt_en_mod;
    reg i_SB_Busy_mod;
    reg i_datavref_or_valvref;
    reg i_pattern_finished_mod;
    reg [15:0]  i_comparison_results_mod;
  
    // Outputs
    wire o_sb_data_pattern_mod;
    wire o_sb_burst_count_mod;
    wire o_sb_comparison_mode_mod;
    wire [1:0]  o_clock_phase_mod;  
    wire o_rx_d2c_pt_done_mod;
    wire o_val_pattern_en_mod;
    wire [1:0]  o_mainband_pattern_generator_cw_mod; 
    wire [1:0]  o_mainband_pattern_comparator_cw_mod;
    wire o_comparison_valid_en_mod;
   
   
   /*********************
   * Module partner
   *********************/
    // Inputs
    reg i_rx_d2c_pt_en_partner;
    reg i_pattern_finished_partner;
    reg [15:0]  i_comparison_results_partner;
    reg i_SB_Busy_partner;
    wire [SB_MSG_WIDTH-1:0] module_decoded_partner_encoded;
  
    // Outputs
    wire [SB_MSG_WIDTH-1:0] module_encoded_partner_decoded;
    wire o_sb_data_pattern_partner;
    wire o_sb_burst_count_partner;
    wire o_sb_comparison_mode_partner;
    wire [1:0]  o_clock_phase_partner;
    wire o_rx_d2c_pt_done_partner;
    wire o_val_pattern_en_partner;
    wire [1:0]  o_mainband_pattern_generator_cw_partner; 
    wire [1:0]  o_mainband_pattern_comparator_cw_partner;
    wire o_comparison_valid_en_partner;

    wire [SB_MSG_WIDTH-1:0] module_encoded_sideband_msg;
    wire [SB_MSG_WIDTH-1:0] partner_encoded_sideband_msg;

    
    ///////////////////////////////////
    /////// INSTANTIATE THE DUT ///////
    ///////////////////////////////////
logic [15:0] per_lane_error;   // Per-lane error bits (if each bit indicates this lane is faulty)
   /*********************
   * Module
   *********************/
    rx_initiated_point_test_wrapper #(SB_MSG_WIDTH) MODULE_inst(
        .i_clk                              (i_clk),
        .i_rst_n                            (i_rst_n),
        .i_rx_d2c_pt_en                     (i_rx_d2c_pt_en_mod),
        .i_datavref_or_valvref              (i_datavref_or_valvref),
        .i_pattern_finished                 (i_pattern_finished_mod),
        .i_comparison_results               (per_lane_error),
        .i_SB_Busy                          (i_SB_Busy_mod),
        .i_decoded_SB_msg                   (module_decoded_partner_encoded),
        .o_encoded_SB_msg                   (module_encoded_sideband_msg),
        .o_sb_data_pattern                  (o_sb_data_pattern_mod),
        .o_sb_burst_count                   (o_sb_burst_count_mod),
        .o_sb_comparison_mode               (o_sb_comparison_mode_mod),
        .o_clock_phase                      (o_clock_phase_mod),
        .o_rx_d2c_pt_done                   (o_rx_d2c_pt_done_mod),
        .o_val_pattern_en                   (o_val_pattern_en_mod),
        .o_mainband_pattern_generator_cw    (o_mainband_pattern_generator_cw_mod),
        .o_mainband_pattern_comparator_cw   (o_mainband_pattern_comparator_cw_mod),
        .o_comparison_valid_en              (o_comparison_valid_en_mod)
    );
                          
   /*********************
   * Module partner
   *********************/
    rx_initiated_point_test_wrapper #(SB_MSG_WIDTH) PARTNER_inst(
        .i_clk                              (i_clk),
        .i_rst_n                            (i_rst_n),
        .i_rx_d2c_pt_en                     (i_rx_d2c_pt_en_partner),
        .i_datavref_or_valvref              (i_datavref_or_valvref),
        .i_pattern_finished                 (i_pattern_finished_partner),
        .i_comparison_results               (i_comparison_results_partner),
        .i_SB_Busy                          (i_SB_Busy_partner),
        .i_decoded_SB_msg                   (module_encoded_partner_decoded),
        .o_encoded_SB_msg                   (partner_encoded_sideband_msg),
        .o_sb_data_pattern                  (o_sb_data_pattern_partner),
        .o_sb_burst_count                   (o_sb_burst_count_partner),
        .o_sb_comparison_mode               (o_sb_comparison_mode_partner),
        .o_clock_phase                      (o_clock_phase_partner),
        .o_rx_d2c_pt_done                   (o_rx_d2c_pt_done_partner),
        .o_val_pattern_en                   (o_val_pattern_en_partner),
        .o_mainband_pattern_generator_cw    (o_mainband_pattern_generator_cw_partner),
        .o_mainband_pattern_comparator_cw   (o_mainband_pattern_comparator_cw_partner),
        .o_comparison_valid_en              (o_comparison_valid_en_partner)
    );

    /**************************
    * modeling transfer delay 
    **************************/
    localparam DELAY_CYCLES = 8; //------------------> EDIT THIS ONLY 
    localparam LAST_FF    = DELAY_CYCLES-1;
    logic [3:0] delay_reg_mod [DELAY_CYCLES-1:0];
    logic [3:0] delay_reg_partner [DELAY_CYCLES-1:0];

    always @ (posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            for (int i = 0; i < DELAY_CYCLES; i = i + 1) begin 
                delay_reg_mod[i]     <= 4'b0000; 
                delay_reg_partner[i] <= 4'b0000; 
            end
        end else begin
            for (int i = DELAY_CYCLES-1; i > 0; i = i - 1) begin
                delay_reg_mod[i]     <= delay_reg_mod[i-1]; 
                delay_reg_partner[i] <= delay_reg_partner[i-1];
            end 
            delay_reg_mod[0]     <= MODULE_inst.o_encoded_SB_msg; 
            delay_reg_partner[0] <= PARTNER_inst.o_encoded_SB_msg;
        end
    end

    assign module_encoded_partner_decoded = delay_reg_mod [LAST_FF];
    assign module_decoded_partner_encoded = delay_reg_partner [LAST_FF];

    ///////////////////////////////////
    //////// CLOCK GENERATION /////////
    ///////////////////////////////////

    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end 

    ///////////////////////////////////
    ///////// INITIAL BLOCK ///////////
    ///////////////////////////////////

    initial begin
        i_rst_n = 1;
        i_datavref_or_valvref       = 0; 
        i_rx_d2c_pt_en_mod          = 0;
        i_SB_Busy_mod               = 0;
        //i_pattern_finished_mod      = 0;
        //i_comparison_results_mod    = 0;
        i_rx_d2c_pt_en_partner      = 0;
        i_SB_Busy_partner           = 0;
        i_pattern_finished_partner  = 0;
        i_comparison_results_partner= 0;
        //Max_error_Threshold_per_lane= 2;  // Per-lane comparison threshold (12-bit)
    	//Max_error_Threshold_aggregate=2;
        #10;
        RESET_DUT();
        SCENARIO ("MODULE_FIRST_LFSR");
        DELAY (4200);
        //SCENARIO ("MODULE_FIRST_VAL");
        // DELAY (10);
        // SCENARIO ("PARTNER_FIRST_LFSR");
        // DELAY (10);
        // //SCENARIO ("PARTNER_FIRST_VAL");
        // DELAY (10);
        // SCENARIO ("BOTH_WITH_EACH_OTHER_LFSR");
        // DELAY (10);
        //SCENARIO ("BOTH_WITH_EACH_OTHER_VAL");
        #100;
        $stop;
    end

    ///////////////////////////////////
    ////////////// TASKS //////////////
    ///////////////////////////////////   

    /**********************************
    * delay task 
    **********************************/
    task DELAY (input integer delay);
       repeat (delay) @(posedge i_clk);
    endtask

    /**********************************
    * Reset task 
    **********************************/
    task RESET_DUT;
        begin
            i_rst_n = 0;
            #10;
            i_rst_n = 1;
        end
    endtask

    /**********************************
    * input sideband busy modeling
    **********************************/ 
    always @ (posedge MODULE_inst.TX_inst.o_valid_tx or posedge MODULE_inst.RX_inst.o_valid_rx) begin
        DELAY (1);
        i_SB_Busy_mod = 1;
        DELAY (3);
        i_SB_Busy_mod = 0; 
    end

    always @ (posedge PARTNER_inst.TX_inst.o_valid_tx or posedge PARTNER_inst.RX_inst.o_valid_rx) begin
        DELAY (1);
        i_SB_Busy_partner = 1;
        DELAY (3);
        i_SB_Busy_partner = 0; 
    end

    /**********************************************************
    * input pattern finsih from pattern generator actual   
    **********************************************************/
    logic done, valid_pattern;                       // Signal to indicate completion of operation

    always @ (o_mainband_pattern_comparator_cw_mod) begin
        if (o_mainband_pattern_comparator_cw_mod == 2'b10) begin
            valid_pattern = 1;
        end else if (o_mainband_pattern_comparator_cw_mod == 2'b00) begin
            valid_pattern = 0;
        end
    end

    always @ (posedge i_pattern_finished_mod) begin
        DELAY (2);
        i_pattern_finished_partner = 1;
        DELAY (1);
        i_pattern_finished_partner = 0;
    end
    /*---------------------------------------------------------
	--PATTERN GENERATOR SIGNALS DECLARATION   
	---------------------------------------------------------*/
    //inputs
    logic serial_lane_0,   serial_lane_1, serial_lane_2,     serial_lane_3;
    logic serial_lane_4,   serial_lane_5,   serial_lane_6,   serial_lane_7;
    logic serial_lane_8,   serial_lane_9,   serial_lane_10,  serial_lane_11;
    logic serial_lane_12,  serial_lane_13,  serial_lane_14,  serial_lane_15;
    //outputs
	logic out_data_lane_0,   out_data_lane_1,   out_data_lane_2,   out_data_lane_3;
    logic out_data_lane_4,   out_data_lane_5,   out_data_lane_6,   out_data_lane_7;
    logic out_data_lane_8,   out_data_lane_9,   out_data_lane_10,  out_data_lane_11;
    logic out_data_lane_12,  out_data_lane_13,  out_data_lane_14,  out_data_lane_15;
    
	/*---------------------------------------------------------
	--PATTERN GENERATOR INSTANTIATION   
	---------------------------------------------------------*/
	LFSR_Transmitter pattern_generator(
  	.* ,.clk                        (i_clk),
        .rst_n                      (i_rst_n),
        .i_state                    (o_mainband_pattern_generator_cw_mod),  // State input (IDLE, SCRAMBLE, PATTERN_LFSR, PER_LANE_IDE)
        .enable_scrambeling_pattern (1'b0), 
        .done                       (i_pattern_finished_mod)                // Signal to indicate completion of operation
	);
	/*---------------------------------------------------------
	--PATTERN DETECTOR SIGNALS   
	---------------------------------------------------------*/
	logic o_pattern_0, o_pattern_1, o_pattern_2, o_pattern_3, o_pattern_4, o_pattern_5;
    logic o_pattern_6, o_pattern_7, o_pattern_8, o_pattern_9, o_pattern_10, o_pattern_11;
    logic o_pattern_12, o_pattern_13, o_pattern_14, o_pattern_15;

    logic out_local_pattern_0,out_local_pattern_1,out_local_pattern_2,out_local_pattern_3,out_local_pattern_4;
    logic out_local_pattern_5,out_local_pattern_6,out_local_pattern_7,out_local_pattern_8,out_local_pattern_9;
    logic out_local_pattern_10,out_local_pattern_11,out_local_pattern_12,out_local_pattern_13,out_local_pattern_14;
    logic out_local_pattern_15;

	/*---------------------------------------------------------
	--PATTERN DETECTOR INSTANTIATION   
	---------------------------------------------------------*/
	pattern_detector pattern_detector_inst(
    .i_clk                      (i_clk),
    .i_rst_n                    (i_rst_n),
    .i_state                    (o_mainband_pattern_comparator_cw_mod),
    .locally_generated_patterns (1'b0), // Enable scrambling pattern
    .enable_buffer              (valid_pattern),  // Enable for Data Come from buffer
    // Input from Rx data
     .i_pattern_0(out_data_lane_0), .i_pattern_1(out_data_lane_1), .i_pattern_2(out_data_lane_2), .i_pattern_3(out_data_lane_3), .i_pattern_4(out_data_lane_4), .i_pattern_5(out_data_lane_0),
     .i_pattern_6(out_data_lane_6), .i_pattern_7(out_data_lane_7), .i_pattern_8(out_data_lane_8), .i_pattern_9(out_data_lane_9), .i_pattern_10(out_data_lane_10), .i_pattern_11(out_data_lane_0),
     .i_pattern_12(out_data_lane_12), .i_pattern_13(out_data_lane_13), .i_pattern_14(out_data_lane_14), .i_pattern_15(out_data_lane_15),
    // Output of pattern bypass
    .*,
    // Output from locally generated parameter
   	.done                       (i_comparison_ack)
	);

	/*------------------------------------------------------------------------------
	--PATTERN COMPARTOR SIGNALS   
	------------------------------------------------------------------------------*/
	logic o_generated_0,      o_generated_1,      o_generated_2,      o_generated_3;
    logic o_generated_4,      o_generated_5,      o_generated_6,      o_generated_7;
    logic o_generated_8,      o_generated_9,      o_generated_10,     o_generated_11;
    logic o_generated_12,     o_generated_13,     o_generated_14,     o_generated_15;
	logic [11:0] Max_error_Threshold_per_lane = 0;  // Per-lane comparison threshold (12-bit)
    logic [15:0] Max_error_Threshold_aggregate = 0; // Aggregate error threshold (16-bit)
    // Error outputs
    
    logic [15:0] error_counter;    // Aggregate error counter
    logic done_result;             // Done signal (1 when test completes)

	/*---------------------------------------------------------
	--PATTERN COMPARTOR INSTANTIATION   
	---------------------------------------------------------*/
	pattern_comparison pattern_comparison_inst(
     .clk           (i_clk),                  // Clock signal
     .rst_n         (i_rst_n),                // Asynchronous active-low reset
     .Type_comp     (1'b1),            // 1 = Per-lane mode, 0 = Aggregate mode
     .i_state       (o_mainband_pattern_comparator_cw_mod),        // State input
     .enable_buffer (valid_pattern),        // Enable

    // Locally generated patterns (16 lanes)
	.*
    // Received patterns (16 lanes)
    // Error threshold inputs
    );
    /**********************************************************
    * Deasserting Enable from blocks modeling   
    **********************************************************/
    always @ (posedge MODULE_inst.o_rx_d2c_pt_done) begin
        DELAY (1);
        i_rx_d2c_pt_en_mod = 0;
    end

    always @ (posedge PARTNER_inst.o_rx_d2c_pt_done) begin
        DELAY (1);
        i_rx_d2c_pt_en_partner = 0;
    end

    /**********************************************************
    * Scenario task    
    **********************************************************/    
    task SCENARIO (input string casee);
        if (casee == "MODULE_FIRST_LFSR") begin
            i_rx_d2c_pt_en_mod    = 1;
            i_datavref_or_valvref = 0;
            DELAY (2);
            i_rx_d2c_pt_en_partner = 1;
        end else if (casee == "MODULE_FIRST_VAL") begin
            i_rx_d2c_pt_en_mod    = 1;
            i_datavref_or_valvref = 1;
            DELAY (2);
            i_rx_d2c_pt_en_partner = 1;
        end else if (casee == "PARTNER_FIRST_LFSR") begin
            i_rx_d2c_pt_en_partner = 1;
            i_datavref_or_valvref  = 0;
            DELAY (2);
            i_rx_d2c_pt_en_mod = 1;
        end else if (casee == "PARTNER_FIRST_VAL") begin
            i_rx_d2c_pt_en_partner = 1;
            i_datavref_or_valvref  = 1;
            DELAY (2);
            i_rx_d2c_pt_en_mod = 1;
        end else if (casee == "BOTH_WITH_EACH_OTHER_LFSR") begin
            i_rx_d2c_pt_en_mod    = 1;
            i_datavref_or_valvref = 0;
            i_rx_d2c_pt_en_partner = 1;            
        end else if (casee == "BOTH_WITH_EACH_OTHER_VAL") begin
            i_rx_d2c_pt_en_mod    = 1;
            i_datavref_or_valvref = 0;
            i_rx_d2c_pt_en_partner = 1;  
        end 
        DELAY (100);
    endtask




endmodule 