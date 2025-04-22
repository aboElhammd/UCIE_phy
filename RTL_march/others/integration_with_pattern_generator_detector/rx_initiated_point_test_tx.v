module rx_initiated_point_test_tx #(
	parameter SB_MSG_WIDTH = 4
) (
    /***************************************************************
    * INPUTS
    ***************************************************************/
	input										i_clk,
	input  										i_rst_n,
    // wrapper related signals
	input   									i_falling_edge_busy,	// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
    input 										i_rx_valid,				// 34an 23rf lw el rx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
    // LTSM related signals            
    input                                       i_rx_d2c_pt_en,         // eli gyaly mn el LTSM 34an abd2 asasn di el enable bta3t this module                           
	input                                       i_datavref_or_valvref,  // (0h: datavref , 1h: valvref)
    // Pattern Generator related signals
    input                                       i_pattern_finished,     // gyaly mn el pattern generator 34an y2olli eni khalast el pattern
    // Sideband related signals
    input			[SB_MSG_WIDTH-1:0]			i_decoded_SB_msg, 		// gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha	
    /***************************************************************
    * OUTPUTS
    ***************************************************************/
    // Sideband related signals    
    output 	reg		[SB_MSG_WIDTH-1:0]			o_encoded_SB_msg_tx, 	// sent to SB 34an 22olo haystkhdm anhy encoding  
	output  reg                                 o_sb_data_pattern,      // sent to SB 34an el data field (0h: LFSR, 1h: Per Lane ID)
    output  reg                                 o_sb_burst_count,       // sent to SB 34an el data field (0h: 1k, 1h: 4k)
    output  reg                                 o_sb_comparison_mode,   // sent to SB 34an el data field (0h: perlane, 1h:aggregate)
    output  reg     [1:0]                       o_clock_phase,          // sent to SB 34an el data field (0h: eye center, 1h: left edge, 2h: right edge)
    // LTSM related signals 
	output	reg									o_rx_d2c_pt_done_tx, 		// ack to let know the master state that this block has finished
    // wrapper related signals
	output  reg 								o_valid_tx,				// sent to Wrapper 34an 22olo eni 3ndi data valid 3ayz ab3tha 
    // Pattern Generator related signals
    output  reg                                 o_val_pattern_en,       //  if (i_datavref_or_valvref == 1)? 1 : 0
    output  reg     [1:0]                       o_mainband_pattern_generator_cw // 00: IDLE, 01: CLEAR_LFSR, 10: LFSR, 11: NOP (No per lane ID in this test)
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

reg [2:0] CS, NS; // Current State, Next State	

/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam IDLE 						= 0;
localparam START_REQ         			= 1;
localparam LFSR_CLEAR_REQ    			= 2;
localparam SEND_PATTERN 				= 3;
localparam COUNT_DONE   				= 4;
localparam END_REQ                      = 5;
localparam TEST_FINISHED                = 6;

/////////////////////////////////////////
///////////// SB messages ///////////////
/////////////////////////////////////////

localparam START_RX_D2C_PT_REQ  	= 1; // D2C: stands for data to clock, PT: stands for Point Test
localparam START_RX_D2C_PT_RESP		= 2;
localparam LFSR_CLR_ERROR_REQ		= 3;
localparam LFSR_CLR_ERROR_RESP      = 4;
localparam COUNT_DONE_REQ           = 5;
localparam COUNT_DONE_RESP          = 6;
localparam END_RX_D2C_PT_REQ        = 7;
localparam END_RX_D2C_PT_RESP       = 8;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

wire send_start_req                          = (CS == IDLE && NS == START_REQ);
wire send_lfsr_clear_req_and_reset_generator = (CS == START_REQ && NS == LFSR_CLEAR_REQ);
wire send_pattern                            = (CS == LFSR_CLEAR_REQ && NS == SEND_PATTERN);
wire send_count_done                         = (CS == SEND_PATTERN &&NS == COUNT_DONE);
wire send_end_req                            = (CS == COUNT_DONE && NS == END_REQ);
wire finish_test                             = (CS == END_REQ && NS == TEST_FINISHED);

/////////////////////////////////
//////// State Memory ///////////
/////////////////////////////////

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        CS <= IDLE;
    end
    else begin
        CS <= NS;
    end
end

/////////////////////////////////
/////// Next State Logic ////////
/////////////////////////////////

always @ (*) begin
	case (CS) 
/*-----------------------------------------------------------------------------
* IDLE
*-----------------------------------------------------------------------------*/
		IDLE: begin
			NS = (i_rx_d2c_pt_en)? START_REQ : IDLE;
		end
/*-----------------------------------------------------------------------------
* START_REQ
------------------------------------------------------------------------------*/
        START_REQ: begin
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == START_RX_D2C_PT_RESP) begin
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
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == LFSR_CLR_ERROR_RESP) begin
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
            if (i_rx_d2c_pt_en) begin
                if (i_pattern_finished) begin
                    NS = COUNT_DONE;
                end else begin
                    NS = SEND_PATTERN;
                end
            end else begin
                NS = IDLE;
            end
        end
/*-----------------------------------------------------------------------------
* COUNT_DONE
------------------------------------------------------------------------------*/
        COUNT_DONE: begin
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == COUNT_DONE_RESP) begin
                    NS = END_REQ;
                end else begin
                    NS = COUNT_DONE;
                end
            end else begin
                NS = IDLE;
            end
        end
/*-----------------------------------------------------------------------------
* END_REQ
------------------------------------------------------------------------------*/
        END_REQ: begin
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == END_RX_D2C_PT_RESP) begin
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
            if (!i_rx_d2c_pt_en) begin
                NS = IDLE;
            end else begin
                NS = TEST_FINISHED;
            end
        end
    endcase 
end 

/////////////////////////////////
///////// Output Logic //////////
/////////////////////////////////

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        o_mainband_pattern_generator_cw  <= 0;
        o_val_pattern_en                 <= 0;
        o_rx_d2c_pt_done_tx              <= 0;
        o_encoded_SB_msg_tx              <= 0;
        o_sb_data_pattern                <= 0;
        o_sb_burst_count                 <= 0;
        o_sb_comparison_mode             <= 0;
    end else begin
        if (CS == IDLE) begin
            o_mainband_pattern_generator_cw  <= 0;
            o_val_pattern_en                 <= 0;
            o_rx_d2c_pt_done_tx              <= 0;
            o_encoded_SB_msg_tx              <= 0;
            o_sb_data_pattern                <= 0;
            o_sb_burst_count                 <= 0;
            o_sb_comparison_mode             <= 0;
        end 

        if (send_start_req) begin
            o_encoded_SB_msg_tx     <= START_RX_D2C_PT_REQ;
            o_sb_data_pattern       <= 0; // LFSR no per lane ID in RX initiated data 2 clock point test
            o_sb_comparison_mode    <= 0; // per lane
            o_clock_phase           <= 0; // eye center
            o_sb_burst_count        <= (i_datavref_or_valvref == 0)? 1 : 0; // data --> 4k , valid --> 1k (128 iteration x 8 bits)
        end

        if (send_lfsr_clear_req_and_reset_generator) begin
            o_encoded_SB_msg_tx     <= LFSR_CLR_ERROR_REQ;
            o_mainband_pattern_generator_cw <= 2'b01; // CLEAR_LFSR     
        end

        if (send_pattern) begin
            if (i_datavref_or_valvref == 0) begin
                o_mainband_pattern_generator_cw <= 2'b10; // LFSR pattern
            end else begin
                o_val_pattern_en <= 1;
            end
        end 

        if (send_count_done) begin
            o_encoded_SB_msg_tx  <= COUNT_DONE_REQ;
            o_mainband_pattern_generator_cw <= 2'b00;
            o_val_pattern_en     <= 0; // 34an el valid tnzl b3d ma ygele el i_pattern_finished, l2n dh el input eli hay trigger el if condition di 
        end

        if (send_end_req) begin
            o_encoded_SB_msg_tx  <= END_RX_D2C_PT_REQ;
        end

        if (finish_test) begin
            o_rx_d2c_pt_done_tx <= 1;
        end
    end
end

/////////////////////////////////
////////// Valid Logic //////////
/////////////////////////////////

always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		o_valid_tx <= 0;
	end else begin
		if (send_start_req || send_lfsr_clear_req_and_reset_generator || send_count_done || send_end_req) begin
			o_valid_tx <= 1;
		end
		else if (i_falling_edge_busy && !i_rx_valid) begin
			o_valid_tx <= 0;
		end 
	end
end

endmodule

