module REVERSALMB_ModulePartner (
/*************************************************************************
 * INPUTS
*************************************************************************/
// clock and reset
    input                       i_clk,
    input                       i_rst_n,

// LTSM related signals
    input                       i_REVERSAL_EN, // from MBINIT.v
    input                       i_falling_edge_busy, 

// sideband related signals
    input                       i_rx_msg_valid,
    input       [3:0]           i_decoded_SB_msg,
    input       [15:0]          i_REVERSAL_Pattern_Result_logged_for_partner, 
    input   					i_SB_Busy, // gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid

// wrapper signals
    input 		        	    i_tx_wrapper_valid, // 34an 23rf lw el tx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
    input                       i_current_die_repeating_reversalmb,

/***************************************************************
* OUTPUTS
***************************************************************/
// Sideband related signals
    output reg     [3:0]		o_encoded_SB_msg_rx, 	// sent to SB 34an 22olo haystkhdm anhy encoding 
    output reg     [15:0]       o_tx_data_bus,
    output reg                  o_tx_data_valid,
    output reg                  o_valid_rx, // msg_valid

// LTSM related
    output reg                  o_rx_reversalmb_done,
   
// MB compartor related   
    output reg     [1:0]        o_mainband_pattern_comparator_cw

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
    localparam [3:0] WAIT_FOR_START_REQ         = 1;
    localparam [3:0] SEND_START_RESP        	= 2;
    localparam [3:0] WAIT_FOR_LFSR_CLEAR_REQ	= 3;
    localparam [3:0] SEND_LFSR_CLEAR_RESP		= 4;
    localparam [3:0] WAIT_FOR_RESULT_REQ        = 5;
    localparam [3:0] SEND_RESULT_RESP           = 6;
    localparam [3:0] WAIT_FOR_END_REQ           = 7;
    localparam [3:0] SEND_END_RESP              = 8;
    localparam [3:0] TEST_FINISHED              = 9;

/*******************************************************************************
 * Internal signals
*******************************************************************************/
    reg [3:0] CS, NS; // Current State, Next State	
    reg save_resp_state;
    reg save_rx_valid; // register used to detect the falling edge of the vaild to be used as a condition for transitions in next state logic

/*******************************************************************************
 * Assign/wire statments
*******************************************************************************/
    wire send_start_resp      = (CS == WAIT_FOR_START_REQ && NS == SEND_START_RESP);
    /* -------------------------------------------------------------------------------------- */
    wire send_lfsr_clr_resp   = ((CS == WAIT_FOR_LFSR_CLEAR_REQ && NS == SEND_LFSR_CLEAR_RESP) ||
                                 (CS == WAIT_FOR_END_REQ && NS == SEND_LFSR_CLEAR_RESP));
    /* -------------------------------------------------------------------------------------- */
    wire send_result_resp     = (CS == WAIT_FOR_RESULT_REQ && NS == SEND_RESULT_RESP);
    /* -------------------------------------------------------------------------------------- */
    wire send_end_resp        = (CS == WAIT_FOR_END_REQ && NS == SEND_END_RESP);
    /* -------------------------------------------------------------------------------------- */
    wire finish_test          = (CS == SEND_END_RESP && NS == TEST_FINISHED);
    /* -------------------------------------------------------------------------------------- */
    wire start_local_gen      = (CS == SEND_LFSR_CLEAR_RESP && NS == WAIT_FOR_RESULT_REQ);
    /* -------------------------------------------------------------------------------------- */
    wire falling_edge_valid   = (save_rx_valid != o_valid_rx) && !o_valid_rx;

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
                NS = (i_REVERSAL_EN)? WAIT_FOR_START_REQ : IDLE;
            end
    /*-----------------------------------------------------------------------------
    * WAIT_FOR_START_REQ
    *-----------------------------------------------------------------------------*/
            WAIT_FOR_START_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_decoded_SB_msg == MBINIT_REVERSALMB_init_req && i_rx_msg_valid) begin
                        NS = SEND_START_RESP;
                    end else begin
                        NS = WAIT_FOR_START_REQ;
                    end
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * SEND_START_RESP
    *-----------------------------------------------------------------------------*/
            SEND_START_RESP: begin
                if (i_REVERSAL_EN) begin
                    if (falling_edge_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
                        NS = WAIT_FOR_LFSR_CLEAR_REQ;
                    end else begin
                        NS = SEND_START_RESP;
                    end
                end else begin
                    NS = IDLE;
                end
            end
    /*-----------------------------------------------------------------------------
    * WAIT_FOR_LFSR_CLEAR_REQ
    *-----------------------------------------------------------------------------*/
            WAIT_FOR_LFSR_CLEAR_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_decoded_SB_msg == MBINIT_REVERSALMB_clear_error_req && i_rx_msg_valid) begin
                        NS = SEND_LFSR_CLEAR_RESP;
                    end else begin
                        NS = WAIT_FOR_LFSR_CLEAR_REQ;
                    end
                end else begin
                    NS = IDLE;
                end            
            end
    /*-----------------------------------------------------------------------------
    * SEND_LFSR_CLEAR_RESP
    *-----------------------------------------------------------------------------*/
            SEND_LFSR_CLEAR_RESP: begin
                if (i_REVERSAL_EN) begin
                    if (falling_edge_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
                        NS = WAIT_FOR_RESULT_REQ;
                    end else begin
                        NS = SEND_LFSR_CLEAR_RESP;
                    end
                end else begin
                    NS = IDLE;
                end  
            end
    /*-----------------------------------------------------------------------------
    * WAIT_FOR_RESULT_REQ
    *-----------------------------------------------------------------------------*/
            WAIT_FOR_RESULT_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_decoded_SB_msg == MBINIT_REVERSALMB_result_req && i_rx_msg_valid) begin
                        NS = SEND_RESULT_RESP;
                    end else begin
                        NS = WAIT_FOR_RESULT_REQ;
                    end
                end else begin
                    NS = IDLE;
                end               
            end
    /*-----------------------------------------------------------------------------
    * SEND_RESULT_RESP
    *-----------------------------------------------------------------------------*/
            SEND_RESULT_RESP: begin
                if (i_REVERSAL_EN) begin
                    if (falling_edge_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
                        NS = WAIT_FOR_END_REQ;
                    end else begin
                        NS = SEND_RESULT_RESP;
                    end
                end else begin
                    NS = IDLE;
                end             
            end
    /*-----------------------------------------------------------------------------
    * WAIT_FOR_END_REQ
    *-----------------------------------------------------------------------------*/
            WAIT_FOR_END_REQ: begin
                if (i_REVERSAL_EN) begin
                    if (i_current_die_repeating_reversalmb) begin // current die initiating repeating reversalmb
                        NS = WAIT_FOR_LFSR_CLEAR_REQ;
                    end else if (i_decoded_SB_msg == MBINIT_REVERSALMB_clear_error_req && i_rx_msg_valid) begin // remote die initiating repeating reversalmb
                        NS = SEND_LFSR_CLEAR_RESP;
                    end else if (i_decoded_SB_msg == MBINIT_REVERSALMB_done_req && i_rx_msg_valid) begin
                        NS = SEND_END_RESP;
                    end else begin
                        NS = WAIT_FOR_END_REQ;
                    end
                end else begin
                    NS = IDLE;
                end    
            end
    /*-----------------------------------------------------------------------------
    * SEND_END_RESP
    *-----------------------------------------------------------------------------*/
            SEND_END_RESP: begin
                if (i_REVERSAL_EN) begin
                    if (falling_edge_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
                        NS = TEST_FINISHED;
                    end else begin
                        NS = SEND_END_RESP;
                    end
                end else begin
                    NS = IDLE;
                end             
            end
    /*-----------------------------------------------------------------------------
    * TEST_FINISHED
    *-----------------------------------------------------------------------------*/
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
            o_encoded_SB_msg_rx                <= 0;
            o_mainband_pattern_comparator_cw   <= 0;
            o_rx_reversalmb_done               <= 0;
            o_tx_data_bus                      <= 0;
            o_tx_data_valid                    <= 0;
        end else begin
            /*=========================================================================================
            * IDLE registers reseting 
            ==========================================================================================*/
            if (CS == IDLE) begin
                o_encoded_SB_msg_rx                <= 0;
                o_mainband_pattern_comparator_cw   <= 0;   
                o_rx_reversalmb_done               <= 0;        
            end
            
            /*=========================================================================================
             * Normal flow
            ==========================================================================================*/
            if (send_start_resp) begin
                o_encoded_SB_msg_rx <= MBINIT_REVERSALMB_init_resp;
            end

            if (send_lfsr_clr_resp) begin
                o_encoded_SB_msg_rx <= MBINIT_REVERSALMB_clear_error_resp;
                o_mainband_pattern_comparator_cw <= 2'b01; // CLEAR_LFSR
            end 

            if (start_local_gen) begin
                o_mainband_pattern_comparator_cw <= 2'b11; // start local pattern generation and comparison
            end

            if (send_result_resp) begin
                o_encoded_SB_msg_rx <= MBINIT_REVERSALMB_result_resp;
                o_mainband_pattern_comparator_cw <= 2'b00;
                o_tx_data_bus <= i_REVERSAL_Pattern_Result_logged_for_partner;
                o_tx_data_valid <= 1;
            end else if (falling_edge_valid) begin
                o_tx_data_valid <= 0;
            end

            if (send_end_resp) begin
                o_encoded_SB_msg_rx <= SEND_END_RESP;
            end

            if (finish_test) begin
                o_rx_reversalmb_done <= 1;
            end
        end
    end 

/*******************************************************************************
 * Valid Logic
*******************************************************************************/
    wire valid_set_condition = (send_start_resp && !i_SB_Busy) || (send_lfsr_clr_resp && !i_SB_Busy) || (send_result_resp && !i_SB_Busy) || (send_end_resp && !i_SB_Busy);
    // &&!i_SB_Busy 34an lw el tx kan byb3t marf34 el valid 34an maghyr4 eldata 3albus 

    always @(posedge i_clk or negedge i_rst_n ) begin
        if (!i_rst_n) begin
            o_valid_rx <= 0;
            save_rx_valid <= 0;
        end else begin
            save_rx_valid <= o_valid_rx;
            if (i_falling_edge_busy) begin 
                o_valid_rx <= 0;
            end
            else if (valid_set_condition || (save_resp_state && !i_tx_wrapper_valid)) begin 
                o_valid_rx <= 1;
            end
        end
    end

    always @ (posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            save_resp_state <= 0;
        end else begin
            if ((send_start_resp && i_tx_wrapper_valid) || (send_lfsr_clr_resp && i_tx_wrapper_valid) || (send_result_resp && i_tx_wrapper_valid) || (send_end_resp && i_tx_wrapper_valid)) begin
                save_resp_state <= 1; 
                // el flag dh ana 3amlo 34an lw el tx byb3t fa bltaly ana mynf34 arf3 el valid bta3 el rx bas fi nafs el w2t me7tag a save eni kunt me7tag arf3 elvalid
                // mn gher el flag dh el condition eli kan bykhlene arf3 elvalid eli hwa dh lw7do (send_done_rsp && !i_SB_Busy) kan 1 clock cycle w bydee3 fa bltaly 
                // mkunt4 ba3rf arf3 elvalid lakn dlwi2ty ana ba save eni elmafrood arf3 el valid b3d ma el tx ykhls mn khelal el flag dh
            end else if (o_valid_rx) begin
                save_resp_state <= 0;
            end
        end 
    end 





endmodule
