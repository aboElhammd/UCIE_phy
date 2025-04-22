module TB_TRAINERROR_HS_WRAPPER;

    ///////////////////////////////////
    /////////// PARAMETERS ////////////
    ///////////////////////////////////
    localparam SB_MSG_WIDTH = 4;
    localparam TRAINERROR_entry_req_msg 	= 14;
    localparam TRAINERROR_entry_resp_msg	= 15;

    string CS_tx, NS_tx, CS_rx, NS_rx;

    ///////////////////////////////////
    //////// PORTS DECLARATON /////////
    ///////////////////////////////////

    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_trainerror_en;
    reg i_SB_Busy;
    reg [SB_MSG_WIDTH-1:0] i_decoded_SB_msg;
  
    // Outputs
    wire [SB_MSG_WIDTH-1:0] o_encoded_SB_msg;
    wire o_TRAINERROR_HS_end;
    wire o_tx_msg_valid;
 
    ///////////////////////////////////
    /////// INSTANTIATE THE DUT ///////
    ///////////////////////////////////

    TRAINERROR_HS_WRAPPER #( 
        .SB_MSG_WIDTH(SB_MSG_WIDTH)
    ) dut (
        .i_clk                  (i_clk),
        .i_rst_n                (i_rst_n),
        .i_trainerror_en        (i_trainerror_en),
        .i_SB_Busy              (i_SB_Busy),
        .i_decoded_SB_msg       (i_decoded_SB_msg),
        .o_encoded_SB_msg       (o_encoded_SB_msg),
        .o_TRAINERROR_HS_end    (o_TRAINERROR_HS_end),
        .o_tx_msg_valid         (o_tx_msg_valid)
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
        case (dut.U_TX_TRAINERROR_HS.CS)
            0: CS_tx = "IDLE_state";
            1: CS_tx = "TRAINERROR_entry_req_state";
            2: CS_tx = "TRAINERROR_END_state";
            default: CS_tx = "UNKNOWN";
        endcase
    end

    always @(*) begin
        case (dut.U_TX_TRAINERROR_HS.NS)
            0: NS_tx = "IDLE_state";
            1: NS_tx = "TRAINERROR_entry_req_state";
            2: NS_tx = "TRAINERROR_END_state";
            default: NS_tx = "UNKNOWN";
        endcase
    end

        always @(*) begin
        case (dut.U_RX_TRAINERROR_HS.CS)
            0: CS_rx = "IDLE_state";
            1: CS_rx = "TRAINERROR_entry_req_state";
            2: CS_rx = "TRAINERROR_entry_resp_state";
            3: CS_rx = "TRAINERROR_END_state";
            default: CS_rx = "UNKNOWN";
        endcase
    end

        always @(*) begin
        case (dut.U_RX_TRAINERROR_HS.NS)
            0: NS_rx = "IDLE_state";
            1: NS_rx = "TRAINERROR_entry_req_state";
            2: NS_rx = "TRAINERROR_entry_resp_state";
            3: NS_rx = "TRAINERROR_END_state";
            default: NS_rx = "UNKNOWN";
        endcase
    end

    ///////////////////////////////////
    ////////////// TASKS //////////////
    ///////////////////////////////////   

    //delay task 
    task DELAY (input integer delay);
       repeat (delay) @(posedge i_clk);
    endtask

    // Reset task
    task RESET_DUT;
        begin
            i_rst_n = 0;
            #10;
            i_rst_n = 1;
        end
    endtask

    // SB is BUSY task 
    task SB_BUSY;
        DELAY (1);
        i_SB_Busy = 1;
        DELAY (5);
        i_SB_Busy = 0;
        DELAY (1);
    endtask


    // SB messages task
    task SB_MSG (input string casee);
        if (casee == "TEST_CASE_1") begin // module --> req , partner --> req , module --> resp , partner --> resp
            DELAY (1);
            SB_BUSY(); // module req 
            DELAY (5); 
            i_decoded_SB_msg = TRAINERROR_entry_req_msg; // partner req
            DELAY (1);
            SB_BUSY(); // module resp
            DELAY (5); 
            i_decoded_SB_msg = TRAINERROR_entry_resp_msg; // partner resp
        end
        else if (casee == "TEST_CASE_2") begin // module --> req , partner --> resp , partner --> req , module --> resp , 
            DELAY (1);
            SB_BUSY(); // module req
            DELAY (5);
            i_decoded_SB_msg = TRAINERROR_entry_resp_msg; // partner resp
            DELAY (5);
            i_decoded_SB_msg = TRAINERROR_entry_req_msg; // partner req
            DELAY (1);
            SB_BUSY(); // module resp
        end
        else if (casee == "CORNER_CASE") begin // partner --> req , module --> req , module --> resp , partner --> resp
            i_decoded_SB_msg = TRAINERROR_entry_req_msg; // partner req
            DELAY (3);
            SB_BUSY(); // module req,resp --> resp should be sent first 
            DELAY (10);
            i_decoded_SB_msg = TRAINERROR_entry_resp_msg; // partner resp
        end
    endtask

    task SCENARIO (input string casee);
        if (casee != "CORNER_CASE") begin
            i_trainerror_en = 1;
            DELAY (1);
            SB_MSG (casee);
            #20;
            i_decoded_SB_msg = 0;
            i_trainerror_en = 0;
        end else begin
            i_trainerror_en  = 1;
            SB_MSG (casee);
            #20;
            i_decoded_SB_msg = 0;
            i_trainerror_en = 0;
        end
    endtask

    initial begin
        i_rst_n = 1;
        i_trainerror_en = 0;
        i_SB_Busy = 0;
        i_decoded_SB_msg = 0;
        #10;
        RESET_DUT();
        SCENARIO ("TEST_CASE_1");
        DELAY (10);
        SCENARIO ("TEST_CASE_2");
        DELAY (10);
        SCENARIO ("CORNER_CASE");

        #100;
        $stop;
    end
endmodule 