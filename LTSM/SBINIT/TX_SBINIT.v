module TX_SBINIT #(
	parameter SB_MSG_WIDTH = 4
) (
	input										i_clk,
	input  										i_rst_n,
	input										i_SBINIT_en, 			// eli gyaly mn module el LTSM 34an abd2 asasn di el enable bta3t this module
	input										i_start_pattern_done, 	// gyaly mn el SB lma ykhls el 64UI pattern
	input  										i_rx_msg_valid,
	input 										i_sb_busy,
	input   									i_falling_edge_busy,	// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
	input 										i_rx_valid,				// 34an 23rf lw el rx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
	input			[SB_MSG_WIDTH-1:0]			i_decoded_SB_msg, 		// gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 
	output 	reg		[SB_MSG_WIDTH-1:0]			o_encoded_SB_msg_tx, 	// sent to SB 34an 22olo haystkhdm anhy encoding 
	output	reg									o_start_pattern_req, 	// sent to SB 34an ybd2 yb3t el pattern 
	output	reg									o_SBINIT_end_tx, 		// sent to LTSM 34an ykhush el MBINIT w 22olo eni khalst
	output  reg 								o_valid_tx 				// sent to Wrapper 34an 22olo eni 3ndi data valid 3ayz ab3tha  
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

reg [2:0] CS, NS; // Current State, Next State	

// dool el conditions eli batl3 el outputs based 3alehum
wire send_pattern_req, send_out_of_reset, send_done_req, send_sbinit_end; 	

/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam [2:0] IDLE 						= 0;
localparam [2:0] START_SB_PATTERN 			= 1;
localparam [2:0] SBINIT_OUT_OF_RESET 		= 2;
localparam [2:0] WAIT_FOR_SB_BUSY	 		= 3;
localparam [2:0] SBINIT_DONE_REQ			= 4;
localparam [2:0] SBINIT_END					= 5;

/////////////////////////////////////////
///////////// SB messages ///////////////
/////////////////////////////////////////

localparam SBINIT_Out_of_Reset_msg 	= 3;
localparam SBINIT_done_req_msg		= 1;
localparam SBINIT_done_resp_msg		= 2;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

//assign o_current_state = CS;
assign send_pattern_req  = (CS == IDLE && NS == START_SB_PATTERN);
assign send_out_of_reset = (CS == SBINIT_OUT_OF_RESET);
assign send_done_req	 = (CS == WAIT_FOR_SB_BUSY && NS == SBINIT_DONE_REQ);
assign send_sbinit_end	 = (CS == SBINIT_DONE_REQ && NS == SBINIT_END);

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
			NS = (i_SBINIT_en)? START_SB_PATTERN : IDLE;
		end
/*-----------------------------------------------------------------------------
* START_SB_PATTERN
*-----------------------------------------------------------------------------*/
		START_SB_PATTERN: begin
			if (i_SBINIT_en) begin
				if (i_start_pattern_done) begin 
					NS = SBINIT_OUT_OF_RESET;
				end 
				else begin
					NS = START_SB_PATTERN;
				end
			end else begin
				NS = IDLE;
			end
		end
/*-----------------------------------------------------------------------------
* SBINIT_OUT_OF_RESET
*-----------------------------------------------------------------------------*/
		SBINIT_OUT_OF_RESET: begin
			if (i_SBINIT_en) begin	
				if ((i_decoded_SB_msg == SBINIT_Out_of_Reset_msg && i_rx_msg_valid)) begin 
					NS = WAIT_FOR_SB_BUSY;
				end 
				else begin
					NS = SBINIT_OUT_OF_RESET;
				end
			end	else begin
				NS = IDLE;
			end	
		end
/*-----------------------------------------------------------------------------
* WAIT_FOR_SB_BUSY
*-----------------------------------------------------------------------------*/
		WAIT_FOR_SB_BUSY: begin
			if (~i_SBINIT_en) begin
				NS = IDLE;
			end else if (~i_sb_busy) begin
				NS = SBINIT_DONE_REQ;
			end else begin
				NS = WAIT_FOR_SB_BUSY;
			end
			
		end
/*-----------------------------------------------------------------------------
* SBINIT_DONE_REQ
*-----------------------------------------------------------------------------*/
		SBINIT_DONE_REQ: begin
			if (i_SBINIT_en) begin
				if (i_decoded_SB_msg == SBINIT_done_resp_msg && i_rx_msg_valid) begin 
					NS = SBINIT_END;
				end 
				else begin
					NS = SBINIT_DONE_REQ;
				end
			end else begin
				NS = IDLE;
			end
		end
/*-----------------------------------------------------------------------------
* SBINIT_END
*-----------------------------------------------------------------------------*/
		SBINIT_END: begin
			if (!i_SBINIT_en) begin
				NS = IDLE;
			end else begin
				NS = SBINIT_END;
			end
		end
		default: NS = IDLE;
    endcase
end


/////////////////////////////////
///////// Output Logic //////////
/////////////////////////////////

always @ (posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		o_encoded_SB_msg_tx <= 0; 
		o_start_pattern_req <= 0;
		o_SBINIT_end_tx     <= 0;
	end
	else begin
		if (CS == IDLE) begin
			o_encoded_SB_msg_tx <= 0; 
			o_start_pattern_req <= 0;
			o_SBINIT_end_tx     <= 0;
		end

		if (send_pattern_req) begin
			o_start_pattern_req <= 1;
		end else begin
			o_start_pattern_req <= 0;
		end

		if (send_out_of_reset) begin
			o_encoded_SB_msg_tx  <= SBINIT_Out_of_Reset_msg; 
		end

		if (send_done_req) begin
			o_encoded_SB_msg_tx  <= SBINIT_done_req_msg; 
		end

		if (send_sbinit_end) begin
			o_SBINIT_end_tx <= 1;
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
		if (send_out_of_reset || send_done_req) begin
			o_valid_tx <= 1;
		end
		else if (((i_falling_edge_busy && !i_rx_valid) && CS !=SBINIT_OUT_OF_RESET)) begin
			o_valid_tx <= 0;
		end 
	end
end

endmodule 