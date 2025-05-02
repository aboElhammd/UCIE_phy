module TX_TRAINERROR_HS #(
    parameter SB_MSG_WIDTH = 4
) (
    input                                        i_clk,
    input                                        i_rst_n,
    input                                        i_trainerror_en,           // eli gyaly mn module el LTSM 34an abd2 asasn di el enable bta3t this module
	input 									     i_rx_msg_valid,
	input   									 i_falling_edge_busy,		// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
	input 										 i_partner_req_trainerror,
	input 										 i_rx_valid,				// 34an 23rf lw el rx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
    input       [SB_MSG_WIDTH-1:0]               i_decoded_SB_msg,          // gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 
    output reg  [SB_MSG_WIDTH-1:0]               o_encoded_SB_msg_tx,       // sent to SB 34an 22olo haystkhdm anhy encoding
    output reg                                   o_trainerror_end_tx,      // sent to LTSM 34an ykhush el TRAINERROR w 22olo eni khalst
    output reg                                   o_valid_tx                 // sent to Wrapper 34an 22olo eni 3ndi data valid 3ayz ab3tha
);  

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

reg [2:0] CS, NS; // Current State, Next State	

// dool el conditions eli batl3 el outputs based 3alehum
wire send_trainerror_entry_req, send_trainerror_end;

/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam [2:0] IDLE 						    = 0;
localparam [2:0] WAIT_FOR_RX_TO_RESP          	= 1;
localparam [2:0] SEND_TRAINERROR_REQ 		 	= 2;
localparam [2:0] TEST_FINISHED					= 3;

/////////////////////////////////////////
///////////// SB messages ///////////////
/////////////////////////////////////////

localparam TRAINERROR_entry_req_msg 	= 15;
localparam TRAINERROR_entry_resp_msg	= 14;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

assign send_trainerror_entry_req  = (CS == IDLE && NS == SEND_TRAINERROR_REQ || (CS == WAIT_FOR_RX_TO_RESP && NS == SEND_TRAINERROR_REQ ));
assign send_trainerror_end        = (CS == SEND_TRAINERROR_REQ  && NS == TEST_FINISHED);

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
			if (i_trainerror_en && ~i_partner_req_trainerror) begin 
				NS = SEND_TRAINERROR_REQ; 
			end else if (i_trainerror_en && i_partner_req_trainerror)  begin 
				NS = WAIT_FOR_RX_TO_RESP;
			end else begin
				NS = IDLE;
			end 
		end
/*-----------------------------------------------------------------------------
* WAIT_FOR_RX_TO_RESP
*-----------------------------------------------------------------------------*/
		WAIT_FOR_RX_TO_RESP: begin
            if (i_trainerror_en) begin
                if (i_falling_edge_busy && i_rx_valid) begin
                    NS = SEND_TRAINERROR_REQ;
                end else begin
                    NS = WAIT_FOR_RX_TO_RESP;
                end
            end else begin
                NS = IDLE;
            end			
		end
/*-----------------------------------------------------------------------------
* SEND_TRAINERROR_REQ
*-----------------------------------------------------------------------------*/
        SEND_TRAINERROR_REQ : begin
			if (i_trainerror_en) begin
				if (i_decoded_SB_msg == TRAINERROR_entry_resp_msg && i_rx_msg_valid) begin 
					NS = TEST_FINISHED;
				end 
				else begin
					NS = SEND_TRAINERROR_REQ 		;
				end
			end else begin
				NS = IDLE;
			end
        end
/*-----------------------------------------------------------------------------
* TEST_FINISHED
*-----------------------------------------------------------------------------*/
        TEST_FINISHED: begin
			if (!i_trainerror_en) begin
				NS = IDLE;
			end else begin
				NS = TEST_FINISHED;
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
		o_encoded_SB_msg_tx  <= 0; 
		o_trainerror_end_tx <= 0;
	end
	else begin
		if (CS == IDLE) begin
			o_encoded_SB_msg_tx  <= 0; 
			o_trainerror_end_tx <= 0;
		end

		if (send_trainerror_entry_req) begin
			o_encoded_SB_msg_tx  <= TRAINERROR_entry_req_msg; 
		end

		if (send_trainerror_end) begin
			o_trainerror_end_tx  <= 1; 
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
		if (send_trainerror_entry_req) begin
			o_valid_tx <= 1;
		end
		else if (i_falling_edge_busy && !i_rx_valid) begin
			o_valid_tx <= 0;
		end 
	end
end

endmodule

