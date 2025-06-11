module REVERSALMB_Module (   
/*************************************************************************
 * INPUTS
*************************************************************************/
// clock and reset
    input               i_clk,
    input               i_rst_n,

// LTSM related signals
    input               i_REVERSAL_EN, // from MBINIT.v
    input               i_ltsm_in_reset,

// sideband related signals
    input               i_rx_msg_valid,
    input [3:0]         i_decoded_SB_msg,
    input [15:0]        i_rx_data_bus, //from rx_sb when it responed with resp on result on i_Rx_SbMessage
    input               i_falling_edge_busy, 
    
// wrapper signals
    input               i_rx_wrapper_valid,

// MB generator related signal
    input               i_pattern_finished,

/*************************************************************************
 * OUTPUTS
*************************************************************************/
// sideband related signals
    output reg [3:0]    o_encoded_SB_msg_tx,
    output reg          o_valid_tx,
    output reg          o_reversalmb_stop_timeout_counter,

// LTSM related signals
    output reg          o_tx_reversalmb_done,
    output reg          o_train_error_req_reversalmb,

// MB generator related signal
    output reg [1:0]    o_mainband_pattern_generator_cw,
    output reg          o_ApplyReversal_En,

// wrapper signals 
    output reg          o_current_die_repeating_reversalmb

);


/*******************************************************************************
 * Sideband messages
*******************************************************************************/
    localparam MBINIT_REVERSALMB_init_req           = 4'b0001;
    localparam MBINIT_REVERSALMB_init_resp          = 4'b0010;
    localparam MBINIT_REVERSALMB_clear_error_req    = 4'b0011;
    localparam MBINIT_REVERSALMB_clear_error_resp   = 4'b0100;
    localparam MBINIT_REVERSALMB_result_req         = 4'b0101;
    localparam MBINIT_REVERSALMB_result_resp        = 4'b0110;
    localparam MBINIT_REVERSALMB_done_req           = 4'b0111;
    localparam MBINIT_REVERSALMB_done_resp          = 4'b1000;

/*******************************************************************************
 * State machine states
*******************************************************************************/
    localparam [3:0] IDLE 						= 0;
    localparam [3:0] WAIT_FOR_RX_TO_RESP        = 1;
    localparam [3:0] START_REQ         			= 2;
    localparam [3:0] LFSR_CLEAR_REQ    			= 3;
    localparam [3:0] SEND_PATTERN 				= 4;
    localparam [3:0] RESULT_REQ   				= 5;
    localparam [3:0] RESLOVING                  = 6;
    localparam [3:0] END_REQ                    = 7;
    localparam [3:0] TEST_FINISHED              = 8;

/*******************************************************************************
 * Internal signals
*******************************************************************************/
    integer i; // unused registers will be removed by default by synthesis tool
    reg [3:0] CS, NS;
    reg repeat_reversal_mb;
    reg possibility_for_trainerror;
    reg [4:0] sum;

/*******************************************************************************
 * Assign/wire statments
*******************************************************************************/
    wire send_start_req                          = ((CS == IDLE && NS == START_REQ) || (CS == WAIT_FOR_RX_TO_RESP && NS == START_REQ));
    /* -------------------------------------------------------------------------------------------------------------------------- */
    wire send_lfsr_clear_req_and_reset_generator = ((CS == START_REQ && NS == LFSR_CLEAR_REQ)           || // normal flow
                                                    (CS == WAIT_FOR_RX_TO_RESP && NS == LFSR_CLEAR_REQ) || // partner req reversal
                                                    (CS == RESLOVING && NS == LFSR_CLEAR_REQ));            // we req reversal
    /* -------------------------------------------------------------------------------------------------------------------------- */
    wire send_pattern                            = (CS == LFSR_CLEAR_REQ && NS == SEND_PATTERN);
    /* -------------------------------------------------------------------------------------------------------------------------- */
    wire send_result_req                         = (CS == SEND_PATTERN && NS == RESULT_REQ);
    /* -------------------------------------------------------------------------------------------------------------------------- */
    wire send_end_req                            = (CS == RESLOVING && NS == END_REQ);
    /* -------------------------------------------------------------------------------------------------------------------------- */
    wire finish_test                             = (CS == END_REQ && NS == TEST_FINISHED);
    /* -------------------------------------------------------------------------------------------------------------------------- */

/*******************************************************************************
 * State Memory
*******************************************************************************/
    always @ (posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            CS <= IDLE;
        end else begin
            CS <= NS;
        end
    end

/*******************************************************************************
 * Next state logic
*******************************************************************************/
    always @ (*) begin
        case (CS) 
    /*-----------------------------------------------------------------------------
    * IDLE
    *-----------------------------------------------------------------------------*/
            IDLE: begin
                if (i_REVERSAL_EN && i_decoded_SB_msg != MBINIT_REVERSALMB_init_req) begin
                    NS = START_REQ;
                end else if (i_REVERSAL_EN && i_decoded_SB_msg == MBINIT_REVERSALMB_init_req && i_rx_msg_valid) begin
                    NS = WAIT_FOR_RX_TO_RESP;
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * WAIT_FOR_RX_TO_RESP
    ------------------------------------------------------------------------------*/
            WAIT_FOR_RX_TO_RESP: begin
                if (i_REVERSAL_EN) begin
                    if (i_falling_edge_busy && i_rx_wrapper_valid) begin
                        if (repeat_reversal_mb) begin
                            NS = LFSR_CLEAR_REQ;
                        end else begin
                            NS = START_REQ;
                        end
                    end else begin
                        NS = WAIT_FOR_RX_TO_RESP;
                    end
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * START_REQ
    ------------------------------------------------------------------------------*/
            START_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_decoded_SB_msg == MBINIT_REVERSALMB_init_resp && i_rx_msg_valid) begin
                        NS = LFSR_CLEAR_REQ;
                    end else begin
                        NS = START_REQ;
                    end
                end else begin
                    NS = IDLE;
                end
            end 
    /*-----------------------------------------------------------------------------
    * LFSR_CLEAR_REQ
    ------------------------------------------------------------------------------*/
            LFSR_CLEAR_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_decoded_SB_msg == MBINIT_REVERSALMB_clear_error_resp && i_rx_msg_valid) begin
                        NS = SEND_PATTERN;
                    end else begin
                        NS = LFSR_CLEAR_REQ;
                    end
                end else begin
                    NS = IDLE;
                end
            end 
    /*-----------------------------------------------------------------------------
    * SEND_PATTERN
    ------------------------------------------------------------------------------*/
            SEND_PATTERN: begin
                if (i_REVERSAL_EN) begin
                    if (i_pattern_finished) begin
                        NS = RESULT_REQ;
                    end else begin
                        NS = SEND_PATTERN;
                    end
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * RESULT_REQ
    ------------------------------------------------------------------------------*/
            RESULT_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_decoded_SB_msg == MBINIT_REVERSALMB_result_resp && i_rx_msg_valid) begin
                        NS = RESLOVING;
                    end else begin
                        NS = RESULT_REQ;
                    end
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * RESLOVING
    ------------------------------------------------------------------------------*/
            RESLOVING: begin
                if (i_REVERSAL_EN) begin
                    sum = 0;
                    for (i = 0 ; i <= 15 ; i = i+1) begin
                        sum = sum + i_rx_data_bus [i];
                    end
                    if (sum <= 8) begin
                        if (possibility_for_trainerror) begin
                            NS = RESLOVING; // khalik fi nafs el state w khalas l7d ma el LTSM t2fl el enable 3ala el block w t3ml trainerror handshake
                        end else begin
                            NS = LFSR_CLEAR_REQ; // lw awel mara nkhush hena e3ml reversal w repeat first
                        end
                    end else begin // lw get hena yb2a msh 3ayz te3ml reversal asasn
                        NS = END_REQ;
                    end
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * END_REQ
    ------------------------------------------------------------------------------*/
            END_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_decoded_SB_msg == MBINIT_REVERSALMB_clear_error_req && i_rx_msg_valid) begin
                        NS = WAIT_FOR_RX_TO_RESP;
                    end else if (i_decoded_SB_msg == MBINIT_REVERSALMB_done_resp && i_rx_msg_valid) begin
                        NS = TEST_FINISHED;
                    end else begin
                        NS = END_REQ;
                    end
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * TEST_FINISHED
    ------------------------------------------------------------------------------*/
            TEST_FINISHED: begin
                if (!i_REVERSAL_EN) begin
                    NS = IDLE;
                end else begin
                    NS = TEST_FINISHED;
                end
            end
            default: NS = IDLE;
        endcase 
    end 

/*******************************************************************************
 * Output Logic
*******************************************************************************/
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            o_mainband_pattern_generator_cw   <= 0;
            repeat_reversal_mb                <= 0;
            o_reversalmb_stop_timeout_counter <= 0;
            o_encoded_SB_msg_tx               <= 0;  
            possibility_for_trainerror        <= 0;
            o_train_error_req_reversalmb      <= 0;
            o_ApplyReversal_En                <= 0;
            o_tx_reversalmb_done              <= 0;
            o_current_die_repeating_reversalmb <= 0;
        end else begin
            /*=========================================================================================
            * IDLE registers reseting 
            ==========================================================================================*/
            if (CS == IDLE) begin
                o_mainband_pattern_generator_cw <= 0;
                o_train_error_req_reversalmb    <= 0;
                possibility_for_trainerror      <= 0;
                o_encoded_SB_msg_tx             <= 0;
                repeat_reversal_mb              <= 0;
                o_tx_reversalmb_done            <= 0;
                o_current_die_repeating_reversalmb <= 0;
            end 
            /*=========================================================================================
             * registering clear_error_req if the partner wants to repeat test after applying reversal
            ==========================================================================================*/
                if ((i_decoded_SB_msg == MBINIT_REVERSALMB_clear_error_req && i_rx_msg_valid) && (CS == END_REQ)) begin
                    repeat_reversal_mb <= 1;
                    o_reversalmb_stop_timeout_counter <= 1; // stop sideband timeout counter on the done req message
                end else begin
                    o_reversalmb_stop_timeout_counter <=0; // pulse
                end

            /*=========================================================================================
             * see if we should req trainerror incase reversal is not working 
            ==========================================================================================*/
                if (CS == RESLOVING && NS == LFSR_CLEAR_REQ) begin
                    possibility_for_trainerror <= 1;
                    o_current_die_repeating_reversalmb <= 1;
                    o_ApplyReversal_En         <= 1;
                end else if (CS == RESLOVING && NS == RESLOVING) begin
                    o_train_error_req_reversalmb <= 1;
                    o_ApplyReversal_En           <= 0;
                end else if (CS == LFSR_CLEAR_REQ) begin
                    o_current_die_repeating_reversalmb <= 0;
                end
                if (i_ltsm_in_reset) begin
                    o_ApplyReversal_En <= 0;
                end
                // el sater eli foo2 dh 34an lw kona 3amleen reversal w khalna training w data transfer w 3ayzeen n initiate new training
                // lazm nbd2 mn el awel without reversal, w lw e3tmdt 3ala eni arg3 el idle fana kdh hanzl el reversal_en fi wst el current 
                // training w dh mynf34 ana lazm akml el training kolo reversed w dh l2n ashour mo3tmd 3ala enha level signal not a pulse
            
            /*=========================================================================================
             * Normal flow
            ==========================================================================================*/
            if (send_start_req) begin
                o_encoded_SB_msg_tx  <= MBINIT_REVERSALMB_init_req;
            end


            if (send_lfsr_clear_req_and_reset_generator) begin
                o_encoded_SB_msg_tx <= MBINIT_REVERSALMB_clear_error_req;
                o_mainband_pattern_generator_cw <= 2'b01; // CLEAR_LFSR     
            end

            if (send_pattern) begin
                o_mainband_pattern_generator_cw <= 2'b11; // perlane id pattern
            end 

            if (send_result_req) begin
                o_encoded_SB_msg_tx  <= MBINIT_REVERSALMB_result_req;
                o_mainband_pattern_generator_cw <= 2'b00;
            end

            if (send_end_req) begin
                o_encoded_SB_msg_tx  <= MBINIT_REVERSALMB_done_req;
            end

            if (finish_test) begin
                o_tx_reversalmb_done <= 1;
            end
        end
    end

/*******************************************************************************
 * Valid Logic
*******************************************************************************/
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            o_valid_tx <= 0;
        end else begin
            if (send_start_req || send_lfsr_clear_req_and_reset_generator || send_result_req || send_end_req) begin
                o_valid_tx <= 1;
            end
            else if (i_falling_edge_busy && !i_rx_wrapper_valid) begin
                o_valid_tx <= 0;
            end 
        end
    end

endmodule 