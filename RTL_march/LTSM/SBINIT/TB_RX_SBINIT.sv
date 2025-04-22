module TB_RX_SBINIT;

    // Parameters
    localparam SB_MSG_WIDTH = 4;
    localparam SBINIT_done_req_msg		= 2;
    localparam SBINIT_done_resp_msg		= 3;

    typedef enum { IDLE_state, START_SB_PATTERN_state, SBINIT_OUT_OF_RESET_state, SBINIT_DONE_REQ_state, SBINIT_END_state} states_e;
    string CS_tb, NS_tb;

    // Inputs
    reg i_clk;
    reg i_rst_n;
    reg i_SBINIT_en;
    reg i_deassert_valid;
    reg [SB_MSG_WIDTH-1:0] i_decoded_SB_msg;

    // Outputs
    wire [SB_MSG_WIDTH-1:0] o_encoded_SB_msg_rx;
    wire o_SBINIT_end_rx;
    wire o_valid_rx;

    // Instantiate the DUT
    RX_SBINIT #(
        .SB_MSG_WIDTH(SB_MSG_WIDTH)
    ) dut (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_SBINIT_en(i_SBINIT_en),
        .i_decoded_SB_msg(i_decoded_SB_msg),
        .i_deassert_valid(i_deassert_valid),
        .o_valid_rx(o_valid_rx),
        .o_encoded_SB_msg_rx(o_encoded_SB_msg_rx),
        .o_SBINIT_end_rx(o_SBINIT_end_rx)
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
            1: CS_tb = "SBINIT_DONE_RESP_state";
            2: CS_tb = "SBINIT_END_state";
            default: CS_tb = "UNKNOWN";
        endcase
    end

        always @(*) begin
        case (dut.NS)
            0: NS_tb = "IDLE_state";
            1: NS_tb = "SBINIT_DONE_RESP_state";
            2: NS_tb = "SBINIT_END_state";
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
        i_deassert_valid = 1;
        #20;
        i_deassert_valid = 0;
    endtask

    // Normal case task
    task NORMAL_CASE;
        begin
            i_SBINIT_en = 1;
            repeat (10) @(posedge i_clk);
            ///////// i_decoded_SB_msg = SB DONE REQ ///////////
            i_decoded_SB_msg = SBINIT_done_req_msg;
            repeat (5) @(posedge i_clk);
            DEASSERT_VALID();
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
        i_decoded_SB_msg = 0;
        i_deassert_valid = 0;

        // Apply reset
        RESET_DUT();

        // Test case 1: Normal case 
        NORMAL_CASE();


        // stop simulation
        $stop;
    end



endmodule 