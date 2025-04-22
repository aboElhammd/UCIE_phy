module tb_rx_initiated_point_test_wrapper;

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
                    WAIT_FOR_RX_TO_RESP      = 1,
                    START_REQ         		 = 2,
                    LFSR_CLEAR_REQ    		 = 3,
                    SEND_PATTERN 			 = 4,
                    COUNT_DONE   			 = 5,
                    END_REQ                  = 6,
                    TEST_FINISHED_TX         = 7
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
    logic [15:0] o_comparison_result_mod;
    logic   o_tx_data_valid_mod;
    logic   o_tx_msg_valid_mod;
    logic [15:0] o_tx_data_bus_mod;
   
   
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
    logic [15:0] o_comparison_result_partner;
    logic   o_tx_data_valid_partner;
    logic   o_tx_msg_valid_partner;
    logic [15:0] o_tx_data_bus_partner;

    wire [SB_MSG_WIDTH-1:0] module_encoded_sideband_msg;
    wire [SB_MSG_WIDTH-1:0] partner_encoded_sideband_msg;

    
    ///////////////////////////////////
    /////// INSTANTIATE THE DUT ///////
    ///////////////////////////////////

   /*********************
   * Module
   *********************/
    rx_initiated_point_test_wrapper MODULE_inst(
        .i_clk                              (i_clk),
        .i_rst_n                            (i_rst_n),
        .i_rx_d2c_pt_en                     (i_rx_d2c_pt_en_mod),
        .i_datavref_or_valvref              (i_datavref_or_valvref),
        .i_pattern_finished                 (i_pattern_finished_mod),
        .i_comparison_results               (i_comparison_results_mod),
        .i_SB_Busy                          (i_SB_Busy_mod),
        .i_decoded_SB_msg                   (module_decoded_partner_encoded),
        .o_encoded_SB_msg                   (module_encoded_sideband_msg),
        .o_tx_data_bus                      (o_tx_data_bus_mod),
        .o_tx_data_valid                    (o_tx_data_valid_mod),
        .o_tx_msg_valid                     (o_tx_msg_valid_mod),
        .o_comparison_result                (o_comparison_result_mod),
        .o_rx_d2c_pt_done                   (o_rx_d2c_pt_done_mod),
        .o_val_pattern_en                   (o_val_pattern_en_mod),
        .o_mainband_pattern_generator_cw    (o_mainband_pattern_generator_cw_mod),
        .o_mainband_pattern_comparator_cw   (o_mainband_pattern_comparator_cw_mod),
        .o_comparison_valid_en              (o_comparison_valid_en_mod)
    );
                          
   /*********************
   * Module partner
   *********************/
    rx_initiated_point_test_wrapper PARTNER_inst(
        .i_clk                              (i_clk),
        .i_rst_n                            (i_rst_n),
        .i_rx_d2c_pt_en                     (i_rx_d2c_pt_en_partner),
        .i_datavref_or_valvref              (i_datavref_or_valvref),
        .i_pattern_finished                 (i_pattern_finished_partner),
        .i_comparison_results               (i_comparison_results_partner),
        .i_SB_Busy                          (i_SB_Busy_partner),
        .i_decoded_SB_msg                   (module_encoded_partner_decoded),
        .o_encoded_SB_msg                   (partner_encoded_sideband_msg),
        .o_tx_data_bus                      (o_tx_data_bus_partner),
        .o_tx_data_valid                    (o_tx_data_valid_partner),
        .o_tx_msg_valid                     (o_tx_msg_valid_partner),
        .o_comparison_result                (o_comparison_result_partner),
        .o_rx_d2c_pt_done                   (o_rx_d2c_pt_done_partner),
        .o_val_pattern_en                   (o_val_pattern_en_partner),
        .o_mainband_pattern_generator_cw    (o_mainband_pattern_generator_cw_partner),
        .o_mainband_pattern_comparator_cw   (o_mainband_pattern_comparator_cw_partner),
        .o_comparison_valid_en              (o_comparison_valid_en_partner)
    );

    /**************************
    * modeling transfer delay 
    **************************/
    localparam DELAY_CYCLES = 6; //------------------> EDIT THIS ONLY 
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
        i_pattern_finished_mod      = 0;
        i_comparison_results_mod    = 0;
        i_rx_d2c_pt_en_partner      = 0;
        i_SB_Busy_partner           = 0;
        i_pattern_finished_partner  = 0;
        i_comparison_results_partner= 0;
        RESET_DUT();
        SCENARIO ("MODULE_FIRST_LFSR");
        DELAY (10);
        //SCENARIO ("MODULE_FIRST_VAL");
        DELAY (10);
        SCENARIO ("PARTNER_FIRST_LFSR");
        DELAY (10);
        //SCENARIO ("PARTNER_FIRST_VAL");
        DELAY (10);
        //SCENARIO ("BOTH_WITH_EACH_OTHER_LFSR");
        DELAY (10);
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
    localparam BUSY_DELAY = 4;
    //logic tx_rx_same_time_mod = MODULE_inst.TX_inst.o_valid_tx 
    always @ (MODULE_inst.o_encoded_SB_msg) begin
        if (MODULE_inst.o_encoded_SB_msg != 0) begin
            DELAY (1);
            i_SB_Busy_mod = 1;
            DELAY (BUSY_DELAY);
            i_SB_Busy_mod = 0; 
        end 
    end

    always @ (PARTNER_inst.o_encoded_SB_msg) begin
        if (PARTNER_inst.o_encoded_SB_msg != 0) begin
            DELAY (1);
            i_SB_Busy_partner = 1;
            DELAY (BUSY_DELAY);
            i_SB_Busy_partner = 0; 
        end 
    end

    /**********************************************************
    * input pattern finsih from pattern generator modeling   
    **********************************************************/
    always @(posedge MODULE_inst.o_val_pattern_en or MODULE_inst.o_mainband_pattern_generator_cw) begin
        if (MODULE_inst.o_val_pattern_en == 1'b1 || MODULE_inst.o_mainband_pattern_generator_cw == 2'b10) begin
            DELAY (10); // modelling pattern generation processing time 
            i_pattern_finished_mod = 1;
            i_comparison_results_mod = $random;
            DELAY (1);
            i_pattern_finished_mod = 0;
        end 
    end

    always @(posedge PARTNER_inst.o_val_pattern_en or PARTNER_inst.o_mainband_pattern_generator_cw) begin
        if (PARTNER_inst.o_val_pattern_en == 1'b1 || PARTNER_inst.o_mainband_pattern_generator_cw == 2'b10) begin 
            DELAY (10); // modelling pattern generation processing time 
            i_pattern_finished_partner = 1;
            i_comparison_results_partner = $random;
            DELAY (1);
            i_pattern_finished_partner = 0;
        end 
    end

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
            DELAY (10);
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