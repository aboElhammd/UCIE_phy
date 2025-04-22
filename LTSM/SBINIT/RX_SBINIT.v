module RX_SBINIT #(
	parameter SB_MSG_WIDTH = 4
) (
	input										i_clk,
	input  										i_rst_n,
	input										i_SBINIT_en, 			// eli gyaly mn module el LTSM 34an abd2 asasn di el enable bta3t this module 
   	input 										i_rx_msg_valid,
	input   									i_SB_Busy,		 		// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
    input 										i_falling_edge_busy,	// 34an 23rf lma yege el rising edge bta3 el busy bit
	input 										i_tx_valid,				// 34an 23rf lw el tx byb3t dlwi2ty wala laa 34an lw byb3t afdl ana a hold 3alvalue bta3tee
    input			[SB_MSG_WIDTH-1:0]			i_decoded_SB_msg, 		// gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 	
	output 	reg		[SB_MSG_WIDTH-1:0]			o_encoded_SB_msg_rx, 	// sent to SB 34an 22olo haystkhdm anhy encoding 	
	output	reg									o_SBINIT_end_rx, 		// sent to LTSM 34an ykhush el MBINIT w 22olo eni khalst
    output  reg    								o_valid_rx   			// sent to Wrapper 34an 22olo eni 3ndi data valid 3ayz ab3tha 
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

reg [2:0] CS, NS; // Current State, Next State	

// dool el conditions eli batl3 el outputs based 3alehum
wire send_sbinit_end, send_done_rsp; 
reg  save_resp_state; // el description bta3ha fi line 159
reg  save_rx_valid;   // register used to detect the falling edge of the vaild to be used as a condition for transitions in next state logic

/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam [2:0] IDLE 						= 0;
localparam [2:0] WAIT_FOR_DONE_REQ   		= 1;
localparam [2:0] SBINIT_DONE_RESP			= 2;
localparam [2:0] SBINIT_END					= 3;

/////////////////////////////////////////
///////////// SB messages ///////////////
/////////////////////////////////////////

localparam SBINIT_done_req_msg		= 1;
localparam SBINIT_done_resp_msg		= 2;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

assign send_sbinit_end	 = (CS == SBINIT_DONE_RESP  && NS == SBINIT_END);
assign send_done_rsp     = (CS == WAIT_FOR_DONE_REQ && NS == SBINIT_DONE_RESP); 
wire falling_edge_valid  = (save_rx_valid != o_valid_rx) && !o_valid_rx;

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
		/****************** IDLE ******************/
		IDLE: begin
			NS = (i_SBINIT_en)? WAIT_FOR_DONE_REQ : IDLE;
		end
        /***************** WAIT_FOR_DONE_REQ *****************/
        WAIT_FOR_DONE_REQ: begin
			if (i_SBINIT_en) begin 
				if (i_decoded_SB_msg == SBINIT_done_req_msg && i_rx_msg_valid) begin 
					NS = SBINIT_DONE_RESP;
				end 
				else begin
					NS = WAIT_FOR_DONE_REQ;
				end
			end else begin
				NS = IDLE;
			end	
        end
        /************ SBINIT_DONE_RESP ************/
		SBINIT_DONE_RESP: begin
			if (i_SBINIT_en) begin 
				if (falling_edge_valid) begin // m3anaha en el SB khalas khd el data mn 3al bus 
					NS = SBINIT_END;
				end 
				else begin
					NS = SBINIT_DONE_RESP;
				end
			end else begin
				NS = IDLE;
			end		
		end
        /***************** SBINIT_END ***************/
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
        o_SBINIT_end_rx     <= 0;
        o_encoded_SB_msg_rx <= 0;
    end
    else begin
        if (CS == IDLE) begin
            o_SBINIT_end_rx     <= 0;
            o_encoded_SB_msg_rx <= 0;
        end
        
        if (send_done_rsp) begin
            o_encoded_SB_msg_rx <= SBINIT_done_resp_msg;
        end
        
        if (send_sbinit_end) begin
            o_SBINIT_end_rx <= 1;
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
		else if ((send_done_rsp && !i_SB_Busy) || (save_resp_state && !i_tx_valid)) begin // &&!i_SB_Busy 34an lw el tx kan byb3t marf34 el valid 34an maghyr4 eldata 3albus 
			o_valid_rx <= 1;
		end
	end
end

always @ (posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		save_resp_state <= 0;
	end else begin
		if (send_done_rsp && i_SB_Busy) begin
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

