module SB_HEADER_ENCODER (
	input 				i_clk,
	input 				i_rst_n,
	input				i_msg_valid,
	input 				i_data_valid,
	input		[3:0]	i_state,
	input 		[3:0]	i_sub_state,
	input 		[3:0]	i_msg_no,
	input 		[2:0]	i_msg_info,
	// Poit/Sweep Tests Signals 
	input 				i_tx_point_sweep_test_en,
	input 		[1:0]  	i_tx_point_sweep_test,
	// RDI Signals 
	input 				i_rdi_msg,
	input 		[1:0]	i_rdi_msg_code,
	input 		[3:0] 	i_rdi_msg_sub_code,
	input 		[1:0] 	i_rdi_msg_info,
	//Outputs
	output	reg	[61:0]	o_header,
	output	reg			o_header_valid
);

/*------------------------------------------------------------------------------
--  LOCAL PARAMETERS
------------------------------------------------------------------------------*/
// States parameters
localparam RESET 	            	= 0;
localparam FINISH_RESET         	= 1;
localparam SBINIT 		 			= 2;
localparam MBINIT					= 3;
localparam MBTRAIN              	= 4;
localparam LINKINIT             	= 5;
localparam ACTIVE               	= 6;
localparam TRAINERROR_HS        	= 7;
localparam TRAINERROR           	= 8;
localparam LINKMGMT_RETRAIN     	= 9;
localparam PHYRETRAIN           	= 10;
localparam L1_L2                	= 11;

// Sub-States parameters of MBINIT
localparam PARAM 		 			= 0;
localparam CAL 			 			= 1;
localparam REPAIRCLK 		 		= 2;
localparam REPAIRVAL 		 		= 3;
localparam REVERSALMB 		 		= 4;
localparam REPAIRMB 			 	= 5;

// Sub-States parameters of MBTRIIN
localparam VALREF 		 			= 0;
localparam DATAVREF 	 			= 1;
localparam SPEEDIDLE  				= 2;
localparam TXSELFCAL 		 		= 3;
localparam RXCLKCAL 				= 4;
localparam VALTRAINCENTER 		 	= 5;
localparam VALTRAINVREF 			= 6;
localparam DATATRAINCENTER1 		= 7;
localparam DATATRAINVREF 			= 8;
localparam RXDESKEW 				= 9;
localparam DATATRAINCENTER2 		= 10;
localparam LINKSPEED 				= 11;
localparam REPAIR 					= 12;

//RDI MsgCode
localparam Nop  					= 0;
localparam Req  					= 1;
localparam Resp 					= 2;

//RDI SubMsgCode
localparam Crd 						= 0;
localparam Active	 				= 1;
localparam PMNAK 					= 2;
localparam L1 						= 3;
localparam L2 						= 4;
localparam LinkReset 				= 5;
localparam LinkError				= 6;
localparam Retrain 					= 7;
localparam Disable 					= 8;

//POINT/SWEEP Tests
localparam TX_INIT_POINT_TEST  		= 0;
localparam TX_INIT_SWEEP_TEST  		= 1;
localparam RX_INIT_POINT_TEST 		= 2;
localparam RX_INIT_SWEEP_TEST 		= 3;




/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
reg  [7:0] 	msg_code;
reg  [7:0] 	msg_sub_code;
reg  [4:0] 	opcode;
reg  [15:0] msg_info;
reg  [15:0] rdi_msg_info;

wire [2:0] 	scrid, dstid;

reg  [3:0] 	state_reg;
reg  [3:0] 	sub_state_reg;
reg  [7:0] 	msg_sub_code_reg;
reg 		msg_sub_code_saved_before_tests; // flag to save the last MSgSubCode before enter to tests to keep count from this point not from zero
reg 	  	i_tx_point_sweep_test_en_reg;
reg 		header_members_valid;

reg  [1:0] 	req_req_cntr; //To count and help to resolve req req case
reg  [7:0] 	first_req_msgsubcode_req_req_case;
reg  [7:0] 	second_req_msgsubcode_req_req_case;
reg 		rsp_rsp_case;




/*------------------------------------------------------------------------------
-- Conditions
------------------------------------------------------------------------------*/
assign LTSM_MSG_VALID 								= i_msg_valid && !i_rdi_msg; //There is an avalible msg to be sent from LTSM and it's not an RDI Message
assign SB_OUT_OF_RESET_MSG 							= i_state == SBINIT && i_msg_no == 3;
assign REQ 											= i_msg_no[0];
assign RX_INIT_D_TO_C_SWEEP_DONE_WITH_RESULTS_MSG 	= i_msg_no == 9;
assign LAST_SENT_MSG_WAS_APPLY_DEGRADE_REQ 			= i_state == MBINIT && i_msg_no == 5 && msg_sub_code_reg == 8'h14;
assign STATE_TRANSITIONED 							= i_state != state_reg;
assign SUB_STATE_TRANSITIONED 						= i_sub_state == sub_state_reg;
assign RESET_MSG_SUBCODE_COUNTER 					= SB_OUT_OF_RESET_MSG ||  (STATE_TRANSITIONED && i_state != PHYRETRAIN && i_state != MBTRAIN);
assign INCREMENT_MSG_SUBCODE_COUNTER 				= REQ && i_state != TRAINERROR;
assign TX_OR_RX_INT_D_TO_C_RESULTS_RESP  			= i_tx_point_sweep_test_en && (i_tx_point_sweep_test == TX_INIT_POINT_TEST || i_tx_point_sweep_test == RX_INIT_SWEEP_TEST) && i_msg_no == 6;
assign REQ_REQ_CNTR_INCR 							= REQ && i_state != SBINIT && SUB_STATE_TRANSITIONED && !LAST_SENT_MSG_WAS_APPLY_DEGRADE_REQ;



/*------------------------------------------------------------------------------
-- Source and Distenation Encoding   
------------------------------------------------------------------------------*/
assign scrid = 3'b010;
assign dstid = 3'b110;



/*------------------------------------------------------------------------------
-- Meassage Code Encoding   
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		msg_code <= 0;
	end 
	else if (LTSM_MSG_VALID) begin
		if (i_tx_point_sweep_test_en) begin
			msg_code [7:4] <= 4'h8;
			if (RX_INIT_D_TO_C_SWEEP_DONE_WITH_RESULTS_MSG) begin
				msg_code [3:0] <= 4'h1;
			end
			else begin
				if (REQ) begin
					msg_code [3:0] <= 4'h5;
				end
				else begin
					msg_code [3:0] <= 4'hA;
				end
			end
		end
		else begin
			case (i_state) 
				SBINIT			: msg_code [7:4] <= 4'h9;
				MBINIT			: msg_code [7:4] <= 4'hA;
				MBTRAIN 		: msg_code [7:4] <= 4'hB;
				TRAINERROR_HS 	: msg_code [7:4] <= 4'hE;
				PHYRETRAIN 		: msg_code [7:4] <= 4'hC;
		
				default : msg_code [7:4] <= 4'h0;
			endcase
			if (SB_OUT_OF_RESET_MSG) begin
				msg_code [3:0] <= 4'h1;
			end
			else if (REQ) begin
				msg_code [3:0] <= 4'h5;
			end
			else begin
				msg_code [3:0] <= 4'hA;
			end
		end	
	end	
end


/*------------------------------------------------------------------------------
-- Opcode Encoding  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		opcode <= 0;
	end 
	else if (LTSM_MSG_VALID) begin
		if (i_data_valid) begin
			opcode <= 5'b11011;	
		end
		else begin
			opcode <= 5'b10010;
		end
	end
end


/*------------------------------------------------------------------------------
-- Message Subcode Encoding  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		// Reset block
		msg_sub_code                      <= 0;
		msg_sub_code_reg                  <= 0;
		rsp_rsp_case                      <= 0;
		first_req_msgsubcode_req_req_case <= 0;
		second_req_msgsubcode_req_req_case<= 0;
		msg_sub_code_saved_before_tests   <= 0;
	end 
	else if (LTSM_MSG_VALID) begin
		if (i_tx_point_sweep_test_en) begin
			// Save msg_sub_code once before tests begin
			if (~msg_sub_code_saved_before_tests) begin
				msg_sub_code_reg             	<= msg_sub_code;
				msg_sub_code_saved_before_tests <= 1;
			end

			// Test mode: choose msg_sub_code based on i_tx_point_sweep_test type and i_msg_no
			case (i_tx_point_sweep_test)
				TX_INIT_POINT_TEST: begin
					if (i_msg_no == 1 || i_msg_no == 2)
						msg_sub_code <= 8'h01;
					else if (i_msg_no == 3 || i_msg_no == 4)
						msg_sub_code <= 8'h02;
					else if (i_msg_no == 5 || i_msg_no == 6)
						msg_sub_code <= 8'h03;
					else if (i_msg_no == 7 || i_msg_no == 8)
						msg_sub_code <= 8'h04;
				end

				TX_INIT_SWEEP_TEST: begin
					if (i_msg_no == 1 || i_msg_no == 2)
						msg_sub_code <= 8'h05;
					else if (i_msg_no == 3 || i_msg_no == 4)
						msg_sub_code <= 8'h02;
					else if (i_msg_no == 5 || i_msg_no == 6)
						msg_sub_code <= 8'h06;
				end

				RX_INIT_POINT_TEST: begin
					if (i_msg_no == 1 || i_msg_no == 2)
						msg_sub_code <= 8'h07;
					else if (i_msg_no == 3 || i_msg_no == 4)
						msg_sub_code <= 8'h02;
					else if (i_msg_no == 5 || i_msg_no == 6)
						msg_sub_code <= 8'h08;
					else if (i_msg_no == 7 || i_msg_no == 8)
						msg_sub_code <= 8'h09;
				end
				
				RX_INIT_SWEEP_TEST: begin
					if (i_msg_no == 1 || i_msg_no == 2)
						msg_sub_code <= 8'h0A;
					else if (i_msg_no == 3 || i_msg_no == 4)
						msg_sub_code <= 8'h02;
					else if (i_msg_no == 5 || i_msg_no == 6)
						msg_sub_code <= 8'h0B;
					else if (i_msg_no == 7 || i_msg_no == 8)
						msg_sub_code <= 8'h0D;
					else if (i_msg_no == 9)
						msg_sub_code <= 8'h0C;
				end
			endcase			
		end
		else begin
			msg_sub_code_saved_before_tests <= 0;
			// Normal operation (non-test mode)
			if (RESET_MSG_SUBCODE_COUNTER) begin
				msg_sub_code <= 0;
			end
			else if (STATE_TRANSITIONED && i_state == MBTRAIN) begin
				case (i_sub_state)
				    VALREF 		:   msg_sub_code <= 8'h00;
				    SPEEDIDLE	: 	msg_sub_code <= 8'h04;
				    TXSELFCAL	:  	msg_sub_code <= 8'h05;
				    REPAIR 		:   msg_sub_code <= 8'h1B;
				    default 	:	msg_sub_code <= 8'h00;
				endcase
			end
			else if (STATE_TRANSITIONED && i_state == PHYRETRAIN) begin
				msg_sub_code <= 8'h01;
			end
			else if (INCREMENT_MSG_SUBCODE_COUNTER) begin
				// Increment in test mode edge: restore saved code if required
				if (i_tx_point_sweep_test_en_reg && i_state == MBINIT) begin
					if (LAST_SENT_MSG_WAS_APPLY_DEGRADE_REQ) begin
						msg_sub_code <= msg_sub_code_reg;
					end
					else begin
						msg_sub_code <= msg_sub_code_reg + 3;
					end
				end else if (i_tx_point_sweep_test_en_reg && i_state == MBTRAIN && msg_sub_code_reg == 8'h0E) begin 
					msg_sub_code <= msg_sub_code_reg + 2;
				end else if (i_tx_point_sweep_test_en_reg && i_state == MBTRAIN && msg_sub_code_reg == 8'h15) begin
					msg_sub_code <= msg_sub_code_reg + 4;
				end else if (i_tx_point_sweep_test_en_reg) begin
					msg_sub_code <= msg_sub_code_reg + 1;
				end

				// Action based on current state
				else begin
					case (i_state)
						MBINIT: begin
							if (msg_sub_code == 8'h00)
								msg_sub_code <= 8'h02;
							else if (msg_sub_code == 8'h04)
								msg_sub_code <= 8'h08;
							else if (msg_sub_code == 8'h0A)
								msg_sub_code <= 8'h0C;
							else if (msg_sub_code == 8'h11) begin
								msg_sub_code     <= 8'h14;
								msg_sub_code_reg <= 8'h14;
							end
							else if (msg_sub_code == 8'h14) begin
								if (i_msg_no == 5)
									msg_sub_code <= 8'h14;
								else if (i_msg_no == 3)
									msg_sub_code <= 8'h13;
							end
							else if (msg_sub_code == 8'h0F) begin
								if (i_msg_no == 3)
									msg_sub_code <= 8'h0E;
								else
									msg_sub_code <= msg_sub_code + 1;
							end
							else if (msg_sub_code == 8'h10) begin
								if (i_msg_no == 5)
									msg_sub_code <= 8'h0F;
								else
									msg_sub_code <= msg_sub_code + 1;
							end
							else
								msg_sub_code <= msg_sub_code + 1;
						end

						MBTRAIN: begin
							if (msg_sub_code == 8'h19)
								msg_sub_code <= 8'h1B;
							else if (msg_sub_code == 8'h0E)
								msg_sub_code <= 8'h10;
							else if (msg_sub_code == 8'h15) begin
								if (i_msg_no == 3)
									msg_sub_code <= 8'h16;
								else if (i_msg_no == 9)
									msg_sub_code <= 8'h19;
								else if (i_msg_no == 11)
									msg_sub_code <= 8'h1F;
								else
									msg_sub_code <= msg_sub_code + 1;
							end
							else if (msg_sub_code == 8'h16) begin
								if (i_msg_no == 5)
									msg_sub_code <= 8'h17;
								else if (i_msg_no == 7)
									msg_sub_code <= 8'h18;
								else
									msg_sub_code <= msg_sub_code + 1;
							end
							else if (msg_sub_code == 8'h17)
								msg_sub_code <= 8'h1B;
							else if (msg_sub_code == 8'h18)
								msg_sub_code <= 8'h04;
							else if (msg_sub_code == 8'h1D)
								msg_sub_code <= 8'h05;
							else
								msg_sub_code <= msg_sub_code + 1;
						end

						PHYRETRAIN: begin
							msg_sub_code <= 8'h01;
						end

						default: begin
							msg_sub_code <= msg_sub_code + 1;
						end
					endcase
					first_req_msgsubcode_req_req_case <= msg_sub_code;
				end
			end  // end increment counter

			else if (~REQ && i_state == MBTRAIN && i_sub_state == LINKSPEED) begin
				case (i_msg_no)
					4:  msg_sub_code <= 8'h16;
					6:  msg_sub_code <= 8'h17;
					8:  msg_sub_code <= 8'h18;
					12: msg_sub_code <= 8'h1F;
				endcase
			end

			else if (~REQ && i_state == MBINIT && i_sub_state == REVERSALMB) begin
				case (i_msg_no)
					4: msg_sub_code <= 8'h0E;
					6: msg_sub_code <= 8'h0F;
					8: msg_sub_code <= 8'h10;
				endcase
			end

			else if (req_req_cntr == 2 && ~REQ) begin
				second_req_msgsubcode_req_req_case 	<= msg_sub_code;
				msg_sub_code                    	<= first_req_msgsubcode_req_req_case;
				rsp_rsp_case                    	<= 1;
			end

			else if (rsp_rsp_case && ~REQ) begin
				msg_sub_code <= second_req_msgsubcode_req_req_case;
				rsp_rsp_case <= 0;
			end

		end // end non-test mode
	end // end LTSM_MSG_VALID
end



/*------------------------------------------------------------------------------
-- Message Info Encoding  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		msg_info <= 0;
	end
	else if(LTSM_MSG_VALID) begin
		if (TX_OR_RX_INT_D_TO_C_RESULTS_RESP) begin
			msg_info <= {{10{1'b0}}, i_msg_info[1:0], {4{1'b0}}};
		end
		else begin
			msg_info <= {{13{1'b0}}, i_msg_info};
		end
	end
end


/*------------------------------------------------------------------------------
-- Req Req Counter  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		req_req_cntr 	<= 0;
	end
	else if (LTSM_MSG_VALID)  begin 
		if (REQ_REQ_CNTR_INCR) begin //As SB OUT OF REST MSG LSB is 1 and after it the PARAM sub state req MSG with LSB also 1 so the counter counts 2 in this case as it is a req req case so i added the (&& i_state == state_reg) cond to prevent this bug
			req_req_cntr 	<= req_req_cntr + 1; // if this counter = 2 this means this is a Req Req case
		end
		else begin
			req_req_cntr 	<= 0;
		end
	end
end


/*------------------------------------------------------------------------------
-- Previous State / SubState / Test  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		state_reg 						<= 0;
		sub_state_reg 					<= 0;
		i_tx_point_sweep_test_en_reg	<= 0;
	end
	else if(i_msg_valid) begin
		state_reg 						<= i_state;
		sub_state_reg 					<= i_sub_state;
		i_tx_point_sweep_test_en_reg 	<= i_tx_point_sweep_test_en;
	end
end

/*------------------------------------------------------------------------------
-- Internal flag to tell that all header Are updated and can use them  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		header_members_valid <= 0;
	end
	else if (i_msg_valid) begin
		header_members_valid <= 1;
	end
	else if (header_members_valid) begin
		header_members_valid <= 0;
	end
	else begin
		header_members_valid <= 0;
	end
end


/*------------------------------------------------------------------------------
-- Outputs  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		o_header 			<= 0;
		o_header_valid 		<= 0;
	end
	else if (header_members_valid) begin
		if (!i_rdi_msg) begin
			o_header [4:0] 		<= opcode;
			o_header [13:5] 	<= 0;
			o_header [21:14] 	<= msg_code;
			o_header [28:22] 	<= 0;
			o_header [31:29] 	<= scrid;
			o_header [39:32] 	<= msg_sub_code;
			o_header [55:40] 	<= msg_info;
			o_header [58:56] 	<= dstid;
			o_header [61:59] 	<= 0;
			o_header_valid 		<= 1;	
		end
		else begin
			o_header [4:0] 		<= 5'b10010;
			o_header [13:5] 	<= 0;
			o_header [16:14] 	<= i_rdi_msg_code;
			o_header [28:22] 	<= 0;
			o_header [31:29] 	<= scrid;
			o_header [35:32] 	<= i_rdi_msg_sub_code;
			o_header [55:40] 	<= rdi_msg_info;
			o_header [58:56] 	<= dstid;
			o_header [61:59] 	<= 0;
			o_header_valid 		<= 1;
		end
	end
	else begin
		o_header_valid 			<= 0;
	end
end


/*------------------------------------------------------------------------------
-- RDI MsgInfo  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		rdi_msg_info <= 0;
	end
	else if (~LTSM_MSG_VALID) begin
		case (i_rdi_msg_code) 
			Nop		://------------------------------------------------------------------------------
				begin
					case (i_rdi_msg_info)
						2'b00: rdi_msg_info <= 1;
						2'b01: rdi_msg_info <= 2;
						2'b10: rdi_msg_info <= 3;
						2'b11: rdi_msg_info <= 4;
					endcase
				end
			//------------------------------------------------------------------------------ 

			Resp	://------------------------------------------------------------------------------
				begin
					if (i_rdi_msg_info [0]) begin
						rdi_msg_info <= 16'hFFFF;
					end
					else begin
						rdi_msg_info <= 16'h0000;
					end
				end 
			//------------------------------------------------------------------------------ 

			default : rdi_msg_info <= 16'h0000;
		endcase
	end
end



endmodule : SB_HEADER_ENCODER