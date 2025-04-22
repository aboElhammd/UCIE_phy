/************************************************************************************
* any signal starts with " integ_ " : this is an integration signal between modules *
*************************************************************************************/

module TB_SBINIT_INTEGRATION;

    ///////////////////////////////////
    /////////// PARAMETERS ////////////
    ///////////////////////////////////
    localparam SB_MSG_WIDTH = 4;
    localparam SBINIT_Out_of_Reset_msg 	= 1;
    localparam SBINIT_done_req_msg		= 2;
    localparam SBINIT_done_resp_msg		= 3;

    string CS_tx, NS_tx, CS_rx, NS_rx;

    ///////////////////////////////////
    //////// PORTS DECLARATON /////////
    ///////////////////////////////////

    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_SBINIT_en;
    reg i_SB_Busy;
    reg [SB_MSG_WIDTH-1:0] i_decoded_SB_msg;
  
    // Outputs
    wire [SB_MSG_WIDTH-1:0] o_encoded_SB_msg;
    wire o_SBINIT_end;

    // Integration signals
    wire integ_start_pattern_done;
    wire integ_start_pattern_req;

    // signals for pattern generator
    reg         i_rx_sb_pattern_samp_done;
    reg         i_ser_done;
    wire        o_pattern_time_out;
    wire [63:0] o_pattern;
    wire        o_pattern_valid;

    ///////////////////////////////////
    /////// INSTANTIATE THE DUT ///////
    ///////////////////////////////////

    SBINIT_WRAPPER #( 
        .SB_MSG_WIDTH(SB_MSG_WIDTH)
    ) dut (
        .i_clk                  (i_clk),
        .i_rst_n                (i_rst_n),
        .i_SBINIT_en            (i_SBINIT_en),
        .i_start_pattern_done   (integ_start_pattern_done),
        .i_SB_Busy              (i_SB_Busy),
        .i_decoded_SB_msg       (i_decoded_SB_msg),
        .o_start_pattern_req    (integ_start_pattern_req),
        .o_encoded_SB_msg       (o_encoded_SB_msg),
        .o_SBINIT_end           (o_SBINIT_end)
    );

    SB_PATTERN_GEN sideband_pattern_gen_inst (
        .i_clk                      (i_clk),
        .i_rst_n                    (i_rst_n),
        .i_start_pattern_req        (integ_start_pattern_req),
        .i_rx_sb_pattern_samp_done  (i_rx_sb_pattern_samp_done),
        .i_ser_done                 (i_ser_done),
        .o_start_pattern_done       (integ_start_pattern_done),
        .o_pattern_time_out         (o_pattern_time_out),
        .o_pattern                  (o_pattern),
        .o_pattern_valid            (o_pattern_valid)
    );

    // Clock generation
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    ///////////////////////////////////
    /////// FOR DEBUGGING ONLY ////////
    ///////////////////////////////////

     always @(*) begin
        case (dut.U_TX_SBINIT.CS)
            0: CS_tx = "IDLE_state";
            1: CS_tx = "START_SB_PATTERN_state";
            2: CS_tx = "SBINIT_OUT_OF_RESET_state";
            3: CS_tx = "SBINIT_DONE_REQ_state";
            4: CS_tx = "SBINIT_END_state";
            default: CS_tx = "UNKNOWN";
        endcase
    end

    always @(*) begin
        case (dut.U_TX_SBINIT.NS)
            0: NS_tx = "IDLE_state";
            1: NS_tx = "START_SB_PATTERN_state";
            2: NS_tx = "SBINIT_OUT_OF_RESET_state";
            3: NS_tx = "SBINIT_DONE_REQ_state";
            4: NS_tx = "SBINIT_END_state";
            default: NS_tx = "UNKNOWN";
        endcase
    end

        always @(*) begin
        case (dut.U_RX_SBINIT.CS)
            0: CS_rx = "IDLE_state";
            1: CS_rx = "WAIT_FOR_DONE_REQ_state";
            2: CS_rx = "SBINIT_DONE_RESP_state";
            3: CS_rx = "SBINIT_END_state";
            default: CS_rx = "UNKNOWN";
        endcase
    end

        always @(*) begin
        case (dut.U_RX_SBINIT.NS)
            0: NS_rx = "IDLE_state";
            1: NS_rx = "WAIT_FOR_DONE_REQ_state";
            2: NS_rx = "SBINIT_DONE_RESP_state";
            3: NS_rx = "SBINIT_END_state";
            default: NS_rx = "UNKNOWN";
        endcase
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
        DELAY (8);
        i_SB_Busy = 0; 
    end
    // task SB_BUSY;
    //     DELAY (1);
    //     i_SB_Busy = 1;
    //     DELAY (5);
    //     i_SB_Busy = 0;
    //     DELAY (1);
    // endtask

    /**********************************
    * pattern req/ack task  
    **********************************/
    task PATTERN_GENERATION;
       i_ser_done = 1;
       DELAY (10); // modeling the processing time of the pattern generator 
       i_rx_sb_pattern_samp_done = 1;
       DELAY (1);
       i_rx_sb_pattern_samp_done = 0;
    endtask 

    /**********************************
    * SB OUT OF RESET task 
    **********************************/
    task SB_OUT_OF_RESET;
       //SB_BUSY(); 
       DELAY (10); // modeling the time of receiving the {SB OUT OF RESET} from partner 
       i_decoded_SB_msg = SBINIT_Out_of_Reset_msg;
    endtask

    /**********************************
    * Sending SB messages task
    **********************************/
    task SB_MSG (input string casee);
        if (casee == "TEST_CASE_1") begin // module --> req , partner --> req , module --> resp , partner --> resp
            DELAY (1);
         //   SB_BUSY(); // module req 
            DELAY (5); 
            i_decoded_SB_msg = SBINIT_done_req_msg; // partner req
            DELAY (1);
         //   SB_BUSY(); // module resp
            DELAY (5); 
            i_decoded_SB_msg = SBINIT_done_resp_msg; // partner resp
        end
        else if (casee == "TEST_CASE_2") begin // module --> req , partner --> resp , partner --> req , module --> resp , 
            DELAY (1);
         //   SB_BUSY(); // module req
            DELAY (5);
            i_decoded_SB_msg = SBINIT_done_resp_msg; // partner resp
            DELAY (5);
            i_decoded_SB_msg = SBINIT_done_req_msg; // partner req
            DELAY (1);
         //  SB_BUSY(); // module resp
        end
        else if (casee == "CORNER_CASE") begin // partner --> req , module --> req , module --> resp , partner --> resp
            DELAY (1);
            i_decoded_SB_msg = SBINIT_done_req_msg; // partner req
         //   SB_BUSY(); // module req,resp --> resp should be sent first 
            DELAY (10);
            i_decoded_SB_msg = SBINIT_done_resp_msg; // partner resp
        end
    endtask

    task SCENARIO (input string casee);
        i_SBINIT_en = 1;
        PATTERN_GENERATION();
        SB_OUT_OF_RESET();
        SB_MSG (casee);
        #150;
        i_decoded_SB_msg = 0;
        i_SBINIT_en = 0;
    endtask

    initial begin
        i_rst_n                   = 1;
        i_SBINIT_en               = 0;
        i_SB_Busy                 = 0;
        i_decoded_SB_msg          = 0;
        i_rx_sb_pattern_samp_done = 0;
        i_ser_done                = 0;  
        
        #10;
        RESET_DUT();
        SCENARIO ("TEST_CASE_1");
        DELAY (10);
        SCENARIO ("TEST_CASE_2");
        DELAY (10);
       // SCENARIO ("CORNER_CASE");

        #100;
        $stop;
    end


endmodule 