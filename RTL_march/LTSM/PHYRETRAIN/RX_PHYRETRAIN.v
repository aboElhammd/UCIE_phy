module RX_PHYRETRAIN #(
    parameter SB_MSG_WIDTH = 4
) (
    /*************************************************************************
    * INPUTS
    *************************************************************************/
    input                                        i_clk,
    input                                        i_rst_n,
    // LTSM related signals
    input                                        i_phyretrain_en,           // eli gyaly mn module el LTSM 34an abd2 asasn di el enable bta3t this module
    input                                        i_clear_resolved_state,    // to reset resolved state upon each new training so that MBTRAIN starts from first state as normal
    // Wrapper related signals
	input   									 i_falling_edge_busy,		// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
	input 										 i_tx_valid,				// 34an 23rf lw el rx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
    input       [2:0]                            i_local_retrain_encoding,  // gayly mn el phyretrain tx module (3'b001: TXSELFCAL, 3'b010: SPEEDIDLE, 3'b100: REPAIR)
    // Sideband related signals
    input                                        i_rx_msg_valid,
    input   									 i_SB_Busy,		 		    // gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
    input       [2:0]                            i_retrain_encoding_partner, // gayly mn SB, 3ubara 3n el encoding fi el partner req
    input       [SB_MSG_WIDTH-1:0]               i_decoded_SB_msg,          // gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 
    /*************************************************************************
    * OUTPUTS
    *************************************************************************/
    // Sideband related signals
    output reg  [SB_MSG_WIDTH-1:0]               o_encoded_SB_msg_rx,       // sent to SB 34an 22olo haystkhdm anhy encoding
    // LTSM related signals
    output reg                                   o_phyretrain_end_rx,      // sent to LTSM 34an ykhush el PHYRETRAIN w 22olo eni khalst
    output reg  [1:0]                            o_resolved_state,         // sent to LTSM 34an 22olo yru7 l anhy state after resolving (0h: IDLE, 1h:MBTRAIN.TXSELFCAL, 2h:MBTRAIN.REPAIR, 3h: MBTRAIN.SPEEDIDLE)
    // Wrapper related signals
    output reg                                   o_valid_rx                // sent to Wrapper 34an 22olo eni 3ndi data valid 3ayz ab3tha
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

reg [2:0] CS, NS; // Current State, Next State	

// dool el conditions eli batl3 el outputs based 3alehum
wire [2:0] send_phyretrain_entry_resp, send_phyretrain_end;
reg   save_resp_state;
reg   save_rx_valid; // register used to detect the falling edge of the vaild to be used as a condition for transitions in next state logic

/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam IDLE 						    = 0;
localparam WAIT_FOR_PHYRETRAIN_REQ          = 1;
localparam SEND_PHYRETRAIN_RESP 		 	= 2;
localparam TEST_FINISHED					= 3;

/////////////////////////////////////////
///////////// SB messages ///////////////
/////////////////////////////////////////

localparam PHYRETRAIN_START_REQ 	= 1;
localparam PHYRETRAIN_START_RESP	= 2;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

assign send_phyretrain_entry_resp  = (CS == WAIT_FOR_PHYRETRAIN_REQ && NS == SEND_PHYRETRAIN_RESP);
assign send_phyretrain_end         = (CS == SEND_PHYRETRAIN_RESP  && NS == TEST_FINISHED);
wire   falling_edge_valid          = (save_rx_valid != o_valid_rx) && !o_valid_rx;

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
			NS = (i_phyretrain_en)? WAIT_FOR_PHYRETRAIN_REQ : IDLE;
		end
/*-----------------------------------------------------------------------------
* WAIT_FOR_PHYRETRAIN_REQ
*-----------------------------------------------------------------------------*/
        WAIT_FOR_PHYRETRAIN_REQ: begin
            if (i_phyretrain_en) begin
                if (i_decoded_SB_msg == PHYRETRAIN_START_REQ && i_rx_msg_valid) begin
                    NS = SEND_PHYRETRAIN_RESP;
                end else begin
                    NS = WAIT_FOR_PHYRETRAIN_REQ;
                end
            end else begin
                NS = IDLE;
            end
        end
/*-----------------------------------------------------------------------------
* SEND_PHYRETRAIN_RESP
*-----------------------------------------------------------------------------*/
		SEND_PHYRETRAIN_RESP: begin
            if (i_phyretrain_en) begin
				if (falling_edge_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus 
					NS = TEST_FINISHED;
				end 
				else begin
					NS = SEND_PHYRETRAIN_RESP;
				end
            end else begin
                NS = IDLE;
            end
		end
/*-----------------------------------------------------------------------------
* TEST_FINISHED 
*-----------------------------------------------------------------------------*/
		TEST_FINISHED   : begin
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
        o_phyretrain_end_rx <= 0;
        o_encoded_SB_msg_rx <= 0;
        o_resolved_state    <= 0;
    end
    else begin
        if (CS == IDLE) begin
            o_phyretrain_end_rx <= 0;
            o_encoded_SB_msg_rx <= 0;
        end
        
        if (send_phyretrain_entry_resp) begin
            o_encoded_SB_msg_rx <= PHYRETRAIN_START_RESP;
            case ({i_local_retrain_encoding,i_retrain_encoding_partner})
                6'b001_001: o_resolved_state <= 2'h1; //TXSELFCAL
                6'b001_100: o_resolved_state <= 2'h2; //REPAIR
                6'b001_010: o_resolved_state <= 2'h3; //SPEEDIDLE
                6'b100_001: o_resolved_state <= 2'h2; //REPAIR
                6'b100_100: o_resolved_state <= 2'h2; //REPAIR
                6'b100_010: o_resolved_state <= 2'h3; //SPEEDIDLE
                6'b010_001: o_resolved_state <= 2'h3; //SPEEDIDLE
                6'b010_100: o_resolved_state <= 2'h3; //SPEEDIDLE
                6'b010_010: o_resolved_state <= 2'h3; //SPEEDIDLE
                default   : o_resolved_state <= 2'h0; //IDLE
            endcase
        end

        if (i_clear_resolved_state) begin
            o_resolved_state <= 0;
        end
        
        if (send_phyretrain_end) begin
            o_phyretrain_end_rx <= 1;
        end
    end
end

/////////////////////////////////
////////// Valid Logic //////////
/////////////////////////////////
always @(posedge i_clk or negedge i_rst_n ) begin
	if (!i_rst_n) begin
		o_valid_rx <= 0;
        save_rx_valid <= 0;
	end else begin
        save_rx_valid <= o_valid_rx;
        if (i_falling_edge_busy) begin 
            o_valid_rx <= 0;
        end
        else if ((send_phyretrain_entry_resp && !i_SB_Busy) || (save_resp_state && !i_tx_valid)) begin  
            o_valid_rx <= 1;
        end
	end
end

always @ (posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		save_resp_state <= 0;
	end else begin
		if (send_phyretrain_entry_resp && i_tx_valid) begin
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