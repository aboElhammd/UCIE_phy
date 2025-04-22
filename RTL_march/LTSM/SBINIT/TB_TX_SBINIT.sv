`timescale 1ns/1ps
module TB_TX_SBINIT;

    // Parameters
    localparam SB_MSG_WIDTH = 4;
    localparam SBINIT_Out_of_Reset_msg 	= 1;
    localparam SBINIT_done_req_msg		= 2;
    localparam SBINIT_done_resp_msg		= 3;

    typedef enum { IDLE_state, START_SB_PATTERN_state, SBINIT_OUT_OF_RESET_state, SBINIT_DONE_REQ_state, SBINIT_END_state} states_e;
    string CS_tb, NS_tb;

    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_SBINIT_en;
    reg i_start_pattern_done;
    reg [SB_MSG_WIDTH-1:0] i_decoded_SB_msg;
    reg i_SB_Busy;
    reg i_rx_valid;

    // Outputs
    wire o_start_pattern_req;
    wire [SB_MSG_WIDTH-1:0] o_encoded_SB_msg_tx;
    wire o_SBINIT_end;
    wire [2:0] o_current_state;
    wire o_valid_tx;

    // Instantiate the DUT
    TX_SBINIT #(
        .SB_MSG_WIDTH(SB_MSG_WIDTH)
    ) dut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_SBINIT_en(i_SBINIT_en),
        .i_start_pattern_done(i_start_pattern_done),
        .i_decoded_SB_msg(i_decoded_SB_msg),
        .i_SB_Busy(i_SB_Busy),
        .i_rx_valid(i_rx_valid),
        .o_valid_tx(o_valid_tx),
        .o_start_pattern_req(o_start_pattern_req),
        .o_encoded_SB_msg_tx(o_encoded_SB_msg_tx),
        .o_SBINIT_end_tx(o_SBINIT_end)
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
        case (dut.CS)
            0: CS_tb = "IDLE_state";
            1: CS_tb = "START_SB_PATTERN_state";
            2: CS_tb = "SBINIT_OUT_OF_RESET_state";
            3: CS_tb = "SBINIT_DONE_REQ_state";
            4: CS_tb = "SBINIT_END_state";
            default: CS_tb = "UNKNOWN";
        endcase
    end

    always @(*) begin
        case (dut.NS)
            0: NS_tb = "IDLE_state";
            1: NS_tb = "START_SB_PATTERN_state";
            2: NS_tb = "SBINIT_OUT_OF_RESET_state";
            3: NS_tb = "SBINIT_DONE_REQ_state";
            4: NS_tb = "SBINIT_END_state";
            default: NS_tb = "UNKNOWN";
        endcase
    end


    // Reset task
    task RESET_DUT;
        begin
            i_rst_n = 0;
            #10;
            i_rst_n = 1;
        end
    endtask

    // Deassert valid task
    task DEASSERT_VALID; 
        i_SB_Busy = 0;
        #20;
        i_SB_Busy = 1;
    endtask


    // Normal case task
    task NORMAL_CASE;
        begin
            i_SBINIT_en = 1;
            ////////// i_start_patter_done ///////////
            repeat (10) @(posedge i_clk);
            i_start_pattern_done = 1;
            @ (posedge i_clk);
            i_start_pattern_done = 0;
            repeat (10) @(posedge i_clk);
            ///////// i_decoded_SB_msg = SB OUT OF RESET ///////////
            DEASSERT_VALID();
            repeat (3) @(posedge i_clk);
            i_decoded_SB_msg = SBINIT_Out_of_Reset_msg;
            repeat (2) @(posedge i_clk);
            DEASSERT_VALID();
            repeat (10) @(posedge i_clk);
            ///////// i_decoded_SB_msg = SB DONE RESP ///////////
            DEASSERT_VALID();
            repeat (3) @(posedge i_clk);
            i_decoded_SB_msg = SBINIT_done_resp_msg;
            #20;
            i_SBINIT_en = 0;
            repeat (10) @(posedge i_clk);
            #10;
        end
    endtask

        
    task CORNER_CASE_1;
        begin
            i_SBINIT_en = 1;
            ////////// i_start_patter_done ///////////
            repeat (10) @(posedge i_clk);
            i_start_pattern_done = 1;
            @ (posedge i_clk);
            i_start_pattern_done = 0;
            repeat (10) @(posedge i_clk);
            ///////// i_decoded_SB_msg = SB OUT OF RESET ///////////
            DEASSERT_VALID();
            i_rx_valid = 1;
            repeat (3) @(posedge i_clk);
            i_rx_valid = 0;
            i_decoded_SB_msg = SBINIT_Out_of_Reset_msg;
            repeat (2) @(posedge i_clk);
            DEASSERT_VALID();
            repeat (10) @(posedge i_clk);
            ///////// i_decoded_SB_msg = SB DONE RESP ///////////
            DEASSERT_VALID();
            repeat (3) @(posedge i_clk);
            i_decoded_SB_msg = SBINIT_done_resp_msg;
            #20;
            i_SBINIT_en = 0;
            repeat (10) @(posedge i_clk);
            #10;
        end
    endtask

    // Test scenarios
    initial begin
        // Initialize inputs
        i_rst_n = 1;
        i_SBINIT_en = 0;
        i_start_pattern_done = 0;
        i_decoded_SB_msg = 0;
        i_SB_Busy = 0;
        i_rx_valid = 0;

        // Apply reset
        RESET_DUT();

        // Test case 1: Normal case 
        NORMAL_CASE();
        CORNER_CASE_1();


        // stop simulation
        $stop;
    end

endmodule