module TB_PHYRETRAIN;

    ///////////////////////////////////
    /////////// PARAMETERS ////////////
    ///////////////////////////////////
    localparam SB_MSG_WIDTH = 4;

    /*---------------------------------
    * Sideband messages
    ---------------------------------*/
    typedef enum {  
                    PHYRETRAIN_START_REQ 	= 1,
                    PHYRETRAIN_START_RESP	= 2
    } sideband_messages;
    /*---------------------------------
    * TX FSM States
    ---------------------------------*/
    typedef enum {  
                    IDLE_TX 			    = 0,
                    WAIT_FOR_RX_TO_RESP     = 1,
                    SEND_PHYRETRAIN_REQ     = 2,
                    TEST_FINISHED_TX		= 3
    } states_tx;
    /*---------------------------------
    * RX FSM States
    ---------------------------------*/
    typedef enum {  
                    IDLE_RX 				 = 0,
                    WAIT_FOR_PHYRETRAIN_REQ  = 1,
                    SEND_PHYRETRAIN_RESP     = 2,
                    TEST_FINISHED_RX		 = 3
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
    reg i_enter_from_active_or_mbtrain;
    logic i_clear_resolved_state;
    reg i_phyretrain_en_mod;
    reg i_SB_Busy_mod;
    reg [1:0]   i_linkspeed_lanes_status_mod;
    reg [2:0]   i_rx_msg_info_mod;
    reg         i_rx_msg_valid_1;
  
    // Outputs
    wire o_tx_msg_valid_mod;
    wire [2:0] o_tx_msg_info_mod;
    wire o_PHYRETRAIN_end_mod;
    wire [1:0] o_resolved_state_mod;
 
   /*********************
   * Module partner
   *********************/
    // Inputs
    reg i_phyretrain_en_partner;
    reg i_SB_Busy_partner;
    reg [1:0]   i_linkspeed_lanes_status_partner;
    reg [2:0]   i_rx_msg_info_partner;
    wire [SB_MSG_WIDTH-1:0] module_decoded_partner_encoded;
    reg         i_rx_msg_valid_2;
  
    // Outputs
    wire o_tx_msg_valid_partner;
    wire [2:0] o_tx_msg_info_partner;
    wire [SB_MSG_WIDTH-1:0] module_encoded_partner_decoded;
    wire o_PHYRETRAIN_end_partner;
    wire [1:0] o_resolved_state_partner;
  

    wire [SB_MSG_WIDTH-1:0] module_encoded_sideband_msg;
    wire [SB_MSG_WIDTH-1:0] partner_encoded_sideband_msg;

    ///////////////////////////////////
    /////// INSTANTIATE THE DUT ///////
    ///////////////////////////////////

   /*********************
   * Module
   *********************/
    PHYRETRAIN_WRAPPER #(SB_MSG_WIDTH) MODULE_inst(
        .i_clk                              (i_clk),
        .i_rst_n                            (i_rst_n),
        .i_phyretrain_en                    (i_phyretrain_en_mod),
        .i_enter_from_active_or_mbtrain     (i_enter_from_active_or_mbtrain),
        .i_linkspeed_lanes_status           (i_linkspeed_lanes_status_mod),
        .i_clear_resolved_state             (i_clear_resolved_state),
        .i_rx_msg_info                      (i_rx_msg_info_mod),
        .i_rx_msg_valid                     (i_rx_msg_valid_1),
        .i_SB_Busy                          (i_SB_Busy_mod),
        .i_decoded_SB_msg                   (module_decoded_partner_encoded),
        .o_encoded_SB_msg                   (module_encoded_sideband_msg),
        .o_tx_msg_info                      (o_tx_msg_info_mod),
        .o_tx_msg_valid                     (o_tx_msg_valid_mod),                 
        .o_PHYRETRAIN_end                   (o_PHYRETRAIN_end_mod),
        .o_resolved_state                   (o_resolved_state_mod)
    );
                          
   /*********************
   * Module partner
   *********************/
    PHYRETRAIN_WRAPPER #(SB_MSG_WIDTH) PARTNER_inst(
        .i_clk                              (i_clk),
        .i_rst_n                            (i_rst_n),
        .i_phyretrain_en                    (i_phyretrain_en_partner),
        .i_enter_from_active_or_mbtrain     (i_enter_from_active_or_mbtrain),
        .i_linkspeed_lanes_status           (i_linkspeed_lanes_status_partner),
        .i_clear_resolved_state             (i_clear_resolved_state),
        .i_rx_msg_info                      (i_rx_msg_info_partner),
        .i_rx_msg_valid                     (i_rx_msg_valid_2),
        .i_SB_Busy                          (i_SB_Busy_partner),
        .i_decoded_SB_msg                   (module_encoded_partner_decoded),
        .o_encoded_SB_msg                   (partner_encoded_sideband_msg),
        .o_tx_msg_info                      (o_tx_msg_info_partner),
        .o_tx_msg_valid                     (o_tx_msg_valid_partner),                 
        .o_PHYRETRAIN_end                   (o_PHYRETRAIN_end_partner),
        .o_resolved_state                   (o_resolved_state_partner)
    );


    /**************************
    * modeling transfer delay 
    **************************/
    localparam DELAY_CYCLES = 6; //------------------> EDIT THIS ONLY 
    localparam LAST_FF      = DELAY_CYCLES-1;
    logic [3:0] delay_reg_mod     [DELAY_CYCLES-1:0];
    logic [3:0] delay_reg_partner [DELAY_CYCLES-1:0];

    always @ (posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            for (int i = 0; i < DELAY_CYCLES; i = i + 1) begin 
                delay_reg_mod    [i] <= 4'b0000; 
                delay_reg_partner[i] <= 4'b0000; 
            end
        end else begin
            for (int i = DELAY_CYCLES-1; i > 0; i = i - 1) begin
                delay_reg_mod    [i] <= delay_reg_mod[i-1]; 
                delay_reg_partner[i] <= delay_reg_partner[i-1];
            end 
            delay_reg_mod    [0] <= MODULE_inst.o_encoded_SB_msg; 
            delay_reg_partner[0] <= PARTNER_inst.o_encoded_SB_msg;
        end
    end

    assign module_encoded_partner_decoded = delay_reg_mod     [LAST_FF]; // i_decoded partner
    assign module_decoded_partner_encoded = delay_reg_partner [LAST_FF]; // i_decoded module 

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
        i_phyretrain_en_mod         = 0;
        i_SB_Busy_mod               = 0;
        i_phyretrain_en_partner     = 0;
        i_SB_Busy_partner           = 0;
        i_clear_resolved_state      = 0;
        for (int i = 0; i < 3; i++) begin
            i_enter_from_active_or_mbtrain = 0; // adapter initiated or phy initiated due to valid framing error in active state 
            i_linkspeed_lanes_status_mod = 2;
            i_linkspeed_lanes_status_partner = 3;
            #10;
            RESET_DUT();
            // SCENARIO ("MODULE_FIRST");
            // DELAY (10);
            SCENARIO ("PARTNER_FIRST");
            DELAY (10);
            // SCENARIO ("BOTH_WITH_EACH_OTHER");
            // #100;
            // i_enter_from_active_or_mbtrain = 1; // phy initiated from MBTRAIN.LINKSPEED
            // RESET_DUT();
            // SCENARIO ("MODULE_FIRST");
            // DELAY (10);
            // SCENARIO ("PARTNER_FIRST");
            // DELAY (10);
            // SCENARIO ("BOTH_WITH_EACH_OTHER");
            #100;
        end

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
    always @ (posedge MODULE_inst.TX_inst.o_valid_tx or posedge MODULE_inst.RX_inst.o_valid_rx) begin
        DELAY (1);
        i_SB_Busy_mod = 1;
        DELAY (BUSY_DELAY);
        i_SB_Busy_mod = 0; 
    end

    always @ (posedge PARTNER_inst.TX_inst.o_valid_tx or posedge PARTNER_inst.RX_inst.o_valid_rx) begin
        DELAY (1);
        i_SB_Busy_partner = 1;
        DELAY (BUSY_DELAY);
        i_SB_Busy_partner = 0; 
    end

    /**********************************************************
    * input rx msg info modeling   
    **********************************************************/
    always @ (posedge module_encoded_partner_decoded) begin
        i_rx_msg_info_partner = MODULE_inst.o_tx_msg_info;
    end

    always @ (posedge module_decoded_partner_encoded) begin
        i_rx_msg_info_mod = PARTNER_inst.o_tx_msg_info;
    end

    /*******************************************
    * i_rx_msg_valid
    *******************************************/
    // module
    always @ (MODULE_inst.i_decoded_SB_msg) begin
        if (MODULE_inst.i_decoded_SB_msg != 0) begin
            i_rx_msg_valid_1 = 1;
            DELAY (1);
            i_rx_msg_valid_1 = 0;
        end
    end

    // partner
    always @ (PARTNER_inst.i_decoded_SB_msg) begin
        if (PARTNER_inst.i_decoded_SB_msg != 0) begin
            i_rx_msg_valid_2 = 1;
            DELAY (1);
            i_rx_msg_valid_2 = 0;
        end
    end

    /**********************************************************
    * Deasserting Enable from blocks modeling   
    **********************************************************/
    always @ (posedge MODULE_inst.o_PHYRETRAIN_end) begin
        DELAY (1);
        i_phyretrain_en_mod = 0;
    end

    always @ (posedge PARTNER_inst.o_PHYRETRAIN_end) begin
        DELAY (1);
        i_phyretrain_en_partner = 0;
    end

    /**********************************************************
    * Scenario task    
    **********************************************************/    
    task SCENARIO (input string casee);
        if (casee == "MODULE_FIRST") begin
            i_phyretrain_en_mod    = 1;
            DELAY (2);
            i_phyretrain_en_partner = 1;
        end else if (casee == "PARTNER_FIRST") begin
            i_phyretrain_en_partner = 1;
            DELAY (8);
            i_phyretrain_en_mod = 1;
        end else if (casee == "BOTH_WITH_EACH_OTHER") begin
            i_phyretrain_en_mod     = 1;
            i_phyretrain_en_partner = 1;            
        end 
        DELAY (100);
        i_clear_resolved_state = 1;
        DELAY (2);
        i_clear_resolved_state = 0;
    endtask

endmodule 