module TX_PHYRETRAIN #(
    parameter SB_MSG_WIDTH = 4
) (
    /*************************************************************************
    * INPUTS
    *************************************************************************/
    input                                        i_clk,
    input                                        i_rst_n,
    // LTSM related signals
    input                                        i_phyretrain_en,           // eli gyaly mn module el LTSM 34an abd2 asasn di el enable bta3t this module
    input                                        i_enter_from_active_or_mbtrain, // 0h: entered from ACTIVE state , 1h: entered from MBTRAIN.LINKSPEED state
    input       [1:0]                            i_linkspeed_lanes_status,   // from linkspeed  0h: IDLE , 1h: No Lane errors, 2h: Lane errors & faulty Lanes are repairable, 3h: Lane errors & faulty Lanes cannot be repaired
    // Wrapper related signals
	input   									 i_falling_edge_busy,		// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
	input 										 i_rx_valid,				// 34an 23rf lw el rx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
    // Sideband related signals
    input       [SB_MSG_WIDTH-1:0]               i_decoded_SB_msg,          // gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 
    input                                        i_rx_msg_valid,
    /*************************************************************************
    * OUTPUTS
    *************************************************************************/
    // Sideband related signals
    output reg  [SB_MSG_WIDTH-1:0]               o_encoded_SB_msg_tx,       // sent to SB 34an 22olo haystkhdm anhy encoding
    output reg  [2:0]                            o_msg_info,                // sent to SB to indicate the req encoding (3'b001: TXSELFCAL, 3'b010: SPEEDIDLE, 3'b100: REPAIR) 
    // LTSM related signals
    output reg                                   o_phyretrain_end_tx,      // sent to LTSM 34an ykhush el PHYRETRAIN w 22olo eni khalst
    // Wrapper related signals
    output reg                                   o_valid_tx                // sent to Wrapper 34an 22olo eni 3ndi data valid 3ayz ab3tha
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

reg [2:0] CS, NS; // Current State, Next State	

// dool el conditions eli batl3 el outputs based 3alehum
wire send_phyretrain_entry_req, send_phyretrain_end;

/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam [2:0] IDLE 						    = 0;
localparam [2:0] WAIT_FOR_RX_TO_RESP          	= 1;
localparam [2:0] SEND_PHYRETRAIN_REQ 		 	= 2;
localparam [2:0] TEST_FINISHED					= 3;

/////////////////////////////////////////
///////////// SB messages ///////////////
/////////////////////////////////////////

localparam PHYRETRAIN_START_REQ 	= 1;
localparam PHYRETRAIN_START_RESP	= 2;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

assign send_phyretrain_entry_req  = (CS == IDLE && NS == SEND_PHYRETRAIN_REQ || (CS == WAIT_FOR_RX_TO_RESP && NS == SEND_PHYRETRAIN_REQ));
assign send_phyretrain_end        = (CS == SEND_PHYRETRAIN_REQ  && NS == TEST_FINISHED);

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
			if (i_phyretrain_en && i_decoded_SB_msg != PHYRETRAIN_START_REQ) begin 
				NS = SEND_PHYRETRAIN_REQ; 
			end else if (i_phyretrain_en && i_decoded_SB_msg == PHYRETRAIN_START_REQ && i_rx_msg_valid)  begin 
				NS = WAIT_FOR_RX_TO_RESP;
			end else begin
				NS = IDLE;
			end 
		end
/*-----------------------------------------------------------------------------
* WAIT_FOR_RX_TO_RESP
*-----------------------------------------------------------------------------*/
		WAIT_FOR_RX_TO_RESP: begin
            if (i_phyretrain_en) begin
                if (i_falling_edge_busy && i_rx_valid) begin
                    NS = SEND_PHYRETRAIN_REQ;
                end else begin
                    NS = WAIT_FOR_RX_TO_RESP;
                end
            end else begin
                NS = IDLE;
            end			
		end
/*-----------------------------------------------------------------------------
* SEND_PHYRETRAIN_REQ
*-----------------------------------------------------------------------------*/
        SEND_PHYRETRAIN_REQ: begin
			if (i_phyretrain_en) begin
				if (i_decoded_SB_msg == PHYRETRAIN_START_RESP && i_rx_msg_valid) begin 
					NS = TEST_FINISHED;
				end 
				else begin
					NS = SEND_PHYRETRAIN_REQ 		;
				end
			end else begin
				NS = IDLE;
			end
        end
/*-----------------------------------------------------------------------------
* TEST_FINISHED
*-----------------------------------------------------------------------------*/
        TEST_FINISHED: begin
			if (!i_phyretrain_en) begin
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
		o_phyretrain_end_tx  <= 0;
        o_msg_info           <= 0;
	end
	else begin
		if (CS == IDLE) begin
			o_encoded_SB_msg_tx  <= 0; 
			o_phyretrain_end_tx  <= 0;
		end

		if (send_phyretrain_entry_req) begin
			o_encoded_SB_msg_tx  <= PHYRETRAIN_START_REQ; 
            if (i_enter_from_active_or_mbtrain == 0) begin // 0h: entered from ACTIVE, 1h: entered from MBTRAIN.LINKSPEED
                o_msg_info <= 3'b001; // TXSELFCAL
            end else begin
                if (i_linkspeed_lanes_status == 2'b01) begin // No lane errors
                    o_msg_info <= 3'b001; // TXSELFCAL
                end else if (i_linkspeed_lanes_status == 2'b10) begin // faulty lanes can be repaired
                    o_msg_info <= 3'b100; // REPAIR
                end else if (i_linkspeed_lanes_status == 2'b11) begin // faulty lanes can't be repaired
                    o_msg_info <= 3'b010; // SPEEDIDLE
                end
            end
		end

		if (send_phyretrain_end) begin
			o_phyretrain_end_tx  <= 1; 
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
        if (send_phyretrain_entry_req) begin
            o_valid_tx <= 1;
        end
        else if (i_falling_edge_busy && !i_rx_valid) begin
            o_valid_tx <= 0;
        end  
	end
end


endmodule 