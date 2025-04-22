module TB_SBINIT_WRAPPER;

    ///////////////////////////////////
    /////////// PARAMETERS ////////////
    ///////////////////////////////////
    localparam SB_MSG_WIDTH = 4;
    localparam SBINIT_Out_of_Reset_msg 	= 1;
    localparam SBINIT_done_req_msg		= 2;
    localparam SBINIT_done_resp_msg		= 3;

    typedef enum {IDLE_tx, START_SB_PATTERN, SBINIT_OUT_OF_RESET, SBINIT_DONE_REQ, SBINIT_END_tx} states_tx;
    typedef enum {IDLE_rx, WAIT_FOR_DONE_REQ, SBINIT_DONE_RESP, SBINIT_END_rx} states_rx;
    typedef enum {SB_OUT_OF_RESET = 1 , DONE_REQ = 2 , DONE_RESP = 3} sideband_messages;

    states_tx CS_tx, NS_tx, CS_tx_partner, NS_tx_partner;
    states_rx CS_rx, NS_rx, CS_rx_partner, NS_rx_partner;
    sideband_messages i_decoded_sideband_msg_mod, o_encoded_sideband_msg_mod;
    sideband_messages i_decoded_sideband_msg_partner, o_encoded_sideband_msg_partner;

    // ///////////////////////////////////
    // //////// PORTS DECLARATON /////////
    // ///////////////////////////////////

    // // Inputs
    // reg i_clk;
    // reg i_rst_n;
    // reg i_SBINIT_en;
    // reg i_start_pattern_done;
    // reg i_SB_Busy;
    // reg [SB_MSG_WIDTH-1:0] i_decoded_SB_msg;
  
    // // Outputs
    // wire o_start_pattern_req;
    // wire [SB_MSG_WIDTH-1:0] o_encoded_SB_msg;
    // wire o_SBINIT_end;
    
    // ///////////////////////////////////
    // /////// INSTANTIATE THE DUT ///////
    // ///////////////////////////////////

    // SBINIT_WRAPPER #( 
    //     .SB_MSG_WIDTH(SB_MSG_WIDTH)
    // ) dut (
    //     .i_clk                  (i_clk),
    //     .i_rst_n                (i_rst_n),
    //     .i_SBINIT_en            (i_SBINIT_en),
    //     .i_start_pattern_done   (i_start_pattern_done),
    //     .i_SB_Busy              (i_SB_Busy),
    //     .i_decoded_SB_msg       (i_decoded_SB_msg),
    //     .o_start_pattern_req    (o_start_pattern_req),
    //     .o_encoded_SB_msg       (o_encoded_SB_msg),
    //     .o_SBINIT_end           (o_SBINIT_end)
    // );

    // ///////////////////////////////////
    // //////// CLOCK GENERATION /////////
    // ///////////////////////////////////

    // initial begin
    //     i_clk = 0;
    //     forever #5 i_clk = ~i_clk;
    // end

    // ///////////////////////////////////
    // ///////// INITIAL BLOCK ///////////
    // ///////////////////////////////////

    // initial begin
    //     i_rst_n = 1;
    //     i_SBINIT_en = 0;
    //     i_start_pattern_done = 0;
    //     i_SB_Busy = 0;
    //     i_decoded_SB_msg = 0;
    //     #10;
    //     RESET_DUT();
    //     SCENARIO ("TEST_CASE_1");
    //     DELAY (10);
    //     SCENARIO ("TEST_CASE_2");
    //     DELAY (10);
    //    // SCENARIO ("CORNER_CASE");
    //     #100;
    //     $stop;
    // end

    // ///////////////////////////////////
    // ////////////// TASKS //////////////
    // ///////////////////////////////////   

    // /**********************************
    // * delay task 
    // **********************************/
    // task DELAY (input integer delay);
    //    repeat (delay) @(posedge i_clk);
    // endtask

    // /**********************************
    // * Reset task 
    // **********************************/
    // task RESET_DUT;
    //     begin
    //         i_rst_n = 0;
    //         #10;
    //         i_rst_n = 1;
    //     end
    // endtask

    // /**********************************
    // * SB is BUSY task  
    // **********************************/ 
    // always @ (posedge dut.U_TX_SBINIT.o_valid_tx or posedge dut.U_RX_SBINIT.o_valid_rx) begin
    //     DELAY (1);
    //     i_SB_Busy = 1;
    //     DELAY (3);
    //     i_SB_Busy = 0; 
    // end
    // // task SB_BUSY;
    // //     DELAY (1);
    // //     i_SB_Busy = 1;
    // //     DELAY (5);
    // //     i_SB_Busy = 0;
    // //     DELAY (1);
    // // endtask

    // /**********************************
    // * pattern req/ack task  
    // **********************************/
    // task PATTERN_GENERATION;
    //    DELAY (10); // modeling the processing time of the pattern generator 
    //    i_start_pattern_done = 1;
    //    DELAY (1);
    //    i_start_pattern_done = 0;
    // endtask 

    // /**********************************
    // * SB OUT OF RESET task 
    // **********************************/
    // task SB_OUT_OF_RESET;
    //    //SB_BUSY(); 
    //    DELAY (10); // modeling the time of receiving the {SB OUT OF RESET} from partner 
    //    i_decoded_SB_msg = SBINIT_Out_of_Reset_msg;
    // endtask

    // /**********************************
    // * Sending SB messages task
    // **********************************/
    // task SB_MSG (input string casee);
    //     if (casee == "TEST_CASE_1") begin // module --> req , partner --> req , module --> resp , partner --> resp
    //         DELAY (1);
    //         //SB_BUSY(); // module req 
    //         DELAY (5); 
    //         i_decoded_SB_msg = SBINIT_done_req_msg; // partner req
    //         DELAY (1);
    //         //SB_BUSY(); // module resp
    //         DELAY (5); 
    //         i_decoded_SB_msg = SBINIT_done_resp_msg; // partner resp
    //     end
    //     else if (casee == "TEST_CASE_2") begin // module --> req , partner --> resp , partner --> req , module --> resp , 
    //         DELAY (1);
    //         //SB_BUSY(); // module req
    //         DELAY (5);
    //         i_decoded_SB_msg = SBINIT_done_resp_msg; // partner resp
    //         DELAY (5);
    //         i_decoded_SB_msg = SBINIT_done_req_msg; // partner req
    //         DELAY (1);
    //         //SB_BUSY(); // module resp
    //     end
    //     else if (casee == "CORNER_CASE") begin // partner --> req , module --> req , module --> resp , partner --> resp
    //         DELAY (1);
    //         i_decoded_SB_msg = SBINIT_done_req_msg; // partner req
    //         //SB_BUSY(); // module req,resp --> resp should be sent first 
    //         DELAY (10);
    //         i_decoded_SB_msg = SBINIT_done_resp_msg; // partner resp
    //     end
    // endtask

    // task SCENARIO (input string casee);
    //     i_SBINIT_en = 1;
    //     PATTERN_GENERATION();
    //     SB_OUT_OF_RESET();
    //     SB_MSG (casee);
    //     #150;
    //     i_decoded_SB_msg = 0;
    //     i_SBINIT_en = 0;
    // endtask

    ///////////////////////////////////
    /////// FOR DEBUGGING ONLY ////////
    ///////////////////////////////////

    always @ (*) begin
        CS_tx = states_tx'(dut.U_TX_SBINIT.CS);
        NS_tx = states_tx'(dut.U_TX_SBINIT.NS);
        CS_rx = states_rx'(dut.U_RX_SBINIT.CS);
        NS_rx = states_rx'(dut.U_RX_SBINIT.NS);
        CS_tx_partner = states_tx'(dut_partner.U_TX_SBINIT.CS);
        NS_tx_partner = states_tx'(dut_partner.U_TX_SBINIT.NS);
        CS_rx_partner = states_rx'(dut_partner.U_RX_SBINIT.CS);
        NS_rx_partner = states_rx'(dut_partner.U_RX_SBINIT.NS);
        i_decoded_sideband_msg_mod = sideband_messages'(dut.i_decoded_SB_msg);
        o_encoded_sideband_msg_mod = sideband_messages'(dut.o_encoded_SB_msg);
        i_decoded_sideband_msg_partner = sideband_messages'(dut_partner.i_decoded_SB_msg);
        o_encoded_sideband_msg_partner = sideband_messages'(dut_partner.o_encoded_SB_msg);
    end

    /******************************************************************
    * Back to Back connection
    *******************************************************************/
   
   /*********************
   * Module
   *********************/
    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_SBINIT_en;
    reg i_start_pattern_done;
    reg i_SB_Busy;
  
    // Outputs
    wire o_start_pattern_req;
    wire o_SBINIT_end;   
   
   
   /*********************
   * Module partner
   *********************/
    // Inputs
    reg i_SBINIT_en_partner;
    reg i_start_pattern_done_partner;
    reg i_SB_Busy_partner;
    reg [SB_MSG_WIDTH-1:0] module_decoded_partner_encoded;
  
    // Outputs
    wire o_start_pattern_req_partner;
    reg [SB_MSG_WIDTH-1:0] module_encoded_partner_decoded;
    wire o_SBINIT_end_partner;

    wire [SB_MSG_WIDTH-1:0] module_encoded_sideband_msg;
    wire [SB_MSG_WIDTH-1:0] partner_encoded_sideband_msg;
    
    ///////////////////////////////////
    /////// INSTANTIATE THE DUT ///////
    ///////////////////////////////////

   /*********************
   * Module
   *********************/
    SBINIT_WRAPPER #( 
        .SB_MSG_WIDTH(SB_MSG_WIDTH)
    ) dut (
        .i_clk                  (i_clk),
        .i_rst_n                (i_rst_n),
        .i_SBINIT_en            (i_SBINIT_en),
        .i_start_pattern_done   (i_start_pattern_done),
        .i_SB_Busy              (i_SB_Busy),
        .i_decoded_SB_msg       (module_decoded_partner_encoded),
        .o_start_pattern_req    (o_start_pattern_req),
        .o_encoded_SB_msg       (module_encoded_sideband_msg),
        .o_SBINIT_end           (o_SBINIT_end)
    );

   /*********************
   * Module partner
   *********************/
    SBINIT_WRAPPER #( 
        .SB_MSG_WIDTH(SB_MSG_WIDTH)
    ) dut_partner (
        .i_clk                  (i_clk),
        .i_rst_n                (i_rst_n),
        .i_SBINIT_en            (i_SBINIT_en_partner),
        .i_start_pattern_done   (i_start_pattern_done_partner),
        .i_SB_Busy              (i_SB_Busy_partner),
        .i_decoded_SB_msg       (module_encoded_partner_decoded),
        .o_start_pattern_req    (o_start_pattern_req_partner),
        .o_encoded_SB_msg       (partner_encoded_sideband_msg),
        .o_SBINIT_end           (o_SBINIT_end_partner)
    );

    always begin
        module_decoded_partner_encoded = #30 dut_partner.o_encoded_SB_msg;
    end
    always begin
        module_encoded_partner_decoded = #40 dut.o_encoded_SB_msg;
    end

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
        i_SBINIT_en = 0;
        i_SBINIT_en_partner = 0;
        i_start_pattern_done = 0;
        i_start_pattern_done_partner = 0;
        i_SB_Busy = 0;
        i_SB_Busy_partner = 0;
        #10;
        RESET_DUT();
        SCENARIO ("MODULE_FIRST");
        DELAY (10);
        SCENARIO ("PARTNER_FIRST");
        DELAY (10);
        SCENARIO ("BOTH_WITH_EACH_OTHER");
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
    * SB is BUSY task  
    **********************************/ 
    always @ (posedge dut.U_TX_SBINIT.o_valid_tx or posedge dut.U_RX_SBINIT.o_valid_rx) begin
        DELAY (1);
        i_SB_Busy = 1;
        DELAY (3);
        i_SB_Busy = 0; 
    end

    always @ (posedge dut_partner.U_TX_SBINIT.o_valid_tx or posedge dut_partner.U_RX_SBINIT.o_valid_rx) begin
        DELAY (1);
        i_SB_Busy_partner = 1;
        DELAY (3);
        i_SB_Busy_partner = 0; 
    end

    /**********************************
    * pattern req/ack task  
    **********************************/
    task PATTERN_GENERATION (input string casee);
    if (casee == "MODULE_FIRST") begin
       DELAY (10); // modeling the processing time of the pattern generator 
       i_start_pattern_done = 1;
       DELAY(1);
       i_start_pattern_done = 0;
       DELAY(2);
       i_start_pattern_done_partner = 1;
       DELAY (1);
       i_start_pattern_done_partner = 0;
    end else if (casee == "PARTNER_FIRST") begin
       DELAY (10); // modeling the processing time of the pattern generator 
       i_start_pattern_done_partner = 1;
       DELAY(1);
       i_start_pattern_done_partner = 0;
       DELAY(2);
       i_start_pattern_done = 1;
       DELAY (1);
       i_start_pattern_done = 0;      
    end else if (casee == "BOTH_WITH_EACH_OTHER") begin
       DELAY (10); // modeling the processing time of the pattern generator 
       i_start_pattern_done = 1;
       i_start_pattern_done_partner = 1;
       DELAY(1);
       i_start_pattern_done = 0; 
       i_start_pattern_done_partner = 0;
    end
    endtask 


    task SCENARIO (input string casee);
        i_SBINIT_en = 1;
        i_SBINIT_en_partner = 1;
        PATTERN_GENERATION(casee);
        #150;
        i_SBINIT_en = 0;
        i_SBINIT_en_partner = 0;
    endtask


endmodule 