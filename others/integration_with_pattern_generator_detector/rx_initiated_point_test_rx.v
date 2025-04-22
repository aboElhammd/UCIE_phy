module rx_initiated_point_test_rx #(
	parameter SB_MSG_WIDTH = 4   
)(
    /***************************************************************
    * INPUTS
    ***************************************************************/
	input										i_clk,
	input  										i_rst_n,
    // wrapper related signals
	input   									i_falling_edge_busy,	// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
    input 										i_tx_valid,				// 34an 23rf lw el tx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
    input   									i_SB_Busy,		 		// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
    // LTSM related signals            
    input                                       i_rx_d2c_pt_en,         // eli gyaly mn el LTSM 34an abd2 asasn di el enable bta3t this module                           
	input                                       i_datavref_or_valvref,  // (0h: datavref , 1h: valvref)
    // Sideband related signals
    input			[SB_MSG_WIDTH-1:0]			i_decoded_SB_msg, 		// gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha	
    /***************************************************************
    * OUTPUTS
    ***************************************************************/
    // Sideband related signals
    output 	reg		[SB_MSG_WIDTH-1:0]			o_encoded_SB_msg_rx, 	// sent to SB 34an 22olo haystkhdm anhy encoding 
    // LTSM related signals 
	output	reg									o_rx_d2c_pt_done_rx, 		// ack to let know the master state that this block has finished
    // wrapper related signals
	output  reg 								o_valid_rx,				// sent to Wrapper 34an 22olo eni 3ndi data valid 3ayz ab3tha 
    // Pattern Generator,comparator related signals
    output  reg                                 o_comparison_valid_en,   // bashaghl biha el local valid pattern generator lw e7na bn optimize el valid lane vref
    output  reg     [1:0]                       o_mainband_pattern_comparator_cw // 00: IDLE, 01: CLEAR_LFSR, 10: LFSR, 11: NOP (No per lane ID in this test)
);


/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

reg [3:0] CS, NS; // Current State, Next State	
reg       save_resp_state;

/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam IDLE 						= 0;
localparam WAIT_FOR_START_REQ           = 1;
localparam SEND_START_RESP        		= 2;
localparam WAIT_FOR_LFSR_CLEAR_REQ		= 3;
localparam SEND_LFSR_CLEAR_RESP			= 4;
localparam WAIT_FOR_COUNT_DONE_REQ      = 5;
localparam SEND_COUNT_DONE_RESP         = 6;
localparam WAIT_FOR_END_REQ             = 7;
localparam SEND_END_RESP                = 8;
localparam TEST_FINISHED                = 9;

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

wire send_start_resp      = (CS == WAIT_FOR_START_REQ && NS == SEND_START_RESP);
wire send_lfsr_clr_resp   = (CS == WAIT_FOR_LFSR_CLEAR_REQ && NS == SEND_LFSR_CLEAR_RESP);
wire send_count_done_resp = (CS == WAIT_FOR_COUNT_DONE_REQ && NS == SEND_COUNT_DONE_RESP);
wire send_end_resp        = (CS == WAIT_FOR_END_REQ && NS == SEND_END_RESP);
wire finish_test          = (CS == SEND_END_RESP && NS == TEST_FINISHED);
wire start_local_gen      = (CS == SEND_LFSR_CLEAR_RESP && NS == WAIT_FOR_COUNT_DONE_REQ);

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
			NS = (i_rx_d2c_pt_en)? WAIT_FOR_START_REQ : IDLE;
		end
/*-----------------------------------------------------------------------------
* WAIT_FOR_START_REQ
*-----------------------------------------------------------------------------*/
        WAIT_FOR_START_REQ: begin
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == START_RX_D2C_PT_REQ) begin
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
            if (i_rx_d2c_pt_en) begin
                if (i_falling_edge_busy && ! i_tx_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
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
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == LFSR_CLR_ERROR_REQ) begin
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
            if (i_rx_d2c_pt_en) begin
                if (i_falling_edge_busy && ! i_tx_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
                    NS = WAIT_FOR_COUNT_DONE_REQ;
                end else begin
                    NS = SEND_LFSR_CLEAR_RESP;
                end
            end else begin
                NS = IDLE;
            end  
        end
/*-----------------------------------------------------------------------------
* WAIT_FOR_COUNT_DONE_REQ
*-----------------------------------------------------------------------------*/
        WAIT_FOR_COUNT_DONE_REQ: begin
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == COUNT_DONE_REQ) begin
                    NS = SEND_COUNT_DONE_RESP;
                end else begin
                    NS = WAIT_FOR_COUNT_DONE_REQ;
                end
            end else begin
                NS = IDLE;
            end               
        end
/*-----------------------------------------------------------------------------
* SEND_COUNT_DONE_RESP
*-----------------------------------------------------------------------------*/
        SEND_COUNT_DONE_RESP: begin
            if (i_rx_d2c_pt_en) begin
                if (i_falling_edge_busy && ! i_tx_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
                    NS = WAIT_FOR_END_REQ;
                end else begin
                    NS = SEND_COUNT_DONE_RESP;
                end
            end else begin
                NS = IDLE;
            end             
        end
/*-----------------------------------------------------------------------------
* WAIT_FOR_END_REQ
*-----------------------------------------------------------------------------*/
        WAIT_FOR_END_REQ: begin
            if (i_rx_d2c_pt_en) begin
                if (i_decoded_SB_msg == END_RX_D2C_PT_REQ) begin
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
            if (i_rx_d2c_pt_en) begin
                if (i_falling_edge_busy && ! i_tx_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus
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
        o_encoded_SB_msg_rx                <= 0;
        o_mainband_pattern_comparator_cw   <= 0;
        o_comparison_valid_en              <= 0;
        o_rx_d2c_pt_done_rx                <= 0;
    end else begin
        if (CS == IDLE) begin
            o_encoded_SB_msg_rx                <= 0;
            o_mainband_pattern_comparator_cw   <= 0;   
            o_comparison_valid_en              <= 0; 
            o_rx_d2c_pt_done_rx                <= 0;        
        end
        
        if (send_start_resp) begin
            o_encoded_SB_msg_rx <= START_RX_D2C_PT_RESP;
        end

        if (send_lfsr_clr_resp) begin
            o_encoded_SB_msg_rx <= LFSR_CLR_ERROR_RESP;
            if (i_datavref_or_valvref == 0) begin // 0h: data, 1h:valid
                o_mainband_pattern_comparator_cw <= 2'b01; // CLEAR_LFSR
            end else begin
                o_comparison_valid_en <= 1;
            end
        end 

        if (start_local_gen && i_datavref_or_valvref == 0) begin
             o_mainband_pattern_comparator_cw <= 2'b10; // start local pattern generation and comparison
        end

        if (send_count_done_resp) begin
            o_encoded_SB_msg_rx <= COUNT_DONE_RESP;
            o_mainband_pattern_comparator_cw <= 2'b00;
            o_comparison_valid_en <= 0;
        end

        if (send_end_resp) begin
            o_encoded_SB_msg_rx <= END_RX_D2C_PT_RESP;
        end

        if (finish_test) begin
            o_rx_d2c_pt_done_rx <= 1;
        end
    end
end 

/////////////////////////////////
////////// Valid Logic //////////
/////////////////////////////////

wire valid_set_condition = (send_start_resp && !i_SB_Busy) || (send_lfsr_clr_resp && !i_SB_Busy) || (send_count_done_resp && !i_SB_Busy) || (send_end_resp && !i_SB_Busy);
// &&!i_SB_Busy 34an lw el tx kan byb3t marf34 el valid 34an maghyr4 eldata 3albus 

always @(posedge i_clk or negedge i_rst_n ) begin
	if (!i_rst_n) begin
		o_valid_rx <= 0;
	end else begin
		if (i_falling_edge_busy && ! i_tx_valid) begin //!i_tx_valid 34an afhm en el falling edge bta3t el busy dii bta3t el rx msh el tx w bltaly anzl el valid 
			o_valid_rx <= 0;
		end
		else if (valid_set_condition || (save_resp_state && !i_tx_valid)) begin 
			o_valid_rx <= 1;
		end
	end
end

always @ (posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		save_resp_state <= 0;
	end else begin
		if ((send_start_resp && i_SB_Busy) || (send_lfsr_clr_resp && i_SB_Busy) || (send_count_done_resp && i_SB_Busy) || (send_end_resp && i_SB_Busy)) begin
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