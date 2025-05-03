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
//reg  [15:0] rdi_msg_info;


wire [2:0] 	scrid, dstid;

//reg  [3:0]	i_msg_no_reg;
//reg  [3:0] 	state_reg;
//reg  [3:0] 	sub_state_reg;
//reg  [7:0] 	msg_sub_code_reg;
//reg 		msg_sub_code_saved_before_tests; // flag to save the last MSgSubCode before enter to tests to keep count from this point not from zero
//reg 	  	i_tx_point_sweep_test_en_reg;
reg 		header_members_valid;

//reg  [1:0] 	req_req_cntr; //To count and help to resolve req req case
//reg  [7:0] 	first_req_msgsubcode_req_req_case;
//reg  [7:0] 	second_req_msgsubcode_req_req_case;
//reg 		rsp_rsp_case;
//reg 		rsp_before_req_case;




/*------------------------------------------------------------------------------
-- Conditions
------------------------------------------------------------------------------*/
assign LTSM_MSG_VALID 								= i_msg_valid && !i_rdi_msg; //There is an avalible msg to be sent from LTSM and it's not an RDI Message
assign SB_OUT_OF_RESET_MSG 							= i_state == SBINIT && i_msg_no == 3;
assign REQ 											= i_msg_no[0];
assign RX_INIT_D_TO_C_SWEEP_DONE_WITH_RESULTS_MSG 	= i_msg_no == 9;
//assign LAST_SENT_MSG_WAS_APPLY_DEGRADE_REQ 			= i_state == MBINIT && i_msg_no == 5 && msg_sub_code_reg == 8'h14;
//assign STATE_TRANSITIONED 							= i_state != state_reg;
//assign SUB_STATE_TRANSITIONED 						= i_sub_state == sub_state_reg;
//assign RESET_MSG_SUBCODE_COUNTER 					= SB_OUT_OF_RESET_MSG ||  (STATE_TRANSITIONED && i_state != PHYRETRAIN && i_state != MBTRAIN);
//assign INCREMENT_MSG_SUBCODE_COUNTER 				= REQ && i_state != TRAINERROR;
assign TX_OR_RX_INT_D_TO_C_RESULTS_RESP  			= i_tx_point_sweep_test_en && (i_tx_point_sweep_test == TX_INIT_POINT_TEST || i_tx_point_sweep_test == RX_INIT_SWEEP_TEST) && i_msg_no == 6;
//assign REQ_REQ_CNTR_INCR 							= REQ && i_state != SBINIT && SUB_STATE_TRANSITIONED && !LAST_SENT_MSG_WAS_APPLY_DEGRADE_REQ;



/*------------------------------------------------------------------------------
-- Source and Distenation Encoding   
------------------------------------------------------------------------------*/
assign scrid = 3'b010;
assign dstid = 3'b110;



/*------------------------------------------------------------------------------
-- Meassage Code Encoding   
------------------------------------------------------------------------------*/
always @(*) begin
	if (LTSM_MSG_VALID) begin
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
always @(*) begin
	if (LTSM_MSG_VALID) begin
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
always @(*) begin
  msg_sub_code = 8'h00;  // Default
  if(i_msg_valid) begin
    if(i_tx_point_sweep_test_en) begin
      // Handle Point/Sweep Test Messages
      case(i_tx_point_sweep_test)
        TX_INIT_POINT_TEST: begin
          case(i_msg_no)
            1, 2: msg_sub_code = 8'h01;  // Start Tx Init D to C point test Req / Resp
            3, 4: msg_sub_code = 8'h02;  // Clear Error Req / Resp
            5, 6: msg_sub_code = 8'h03;  // Results Req / Resp
            7, 8: msg_sub_code = 8'h04;  // End Tx Init D to C point test req / Resp
          endcase
        end
        
        TX_INIT_SWEEP_TEST: begin
          case(i_msg_no)
            1, 2: msg_sub_code = 8'h05;  // Start Tx Init D to C eye sweep Req / Resp
            3, 4: msg_sub_code = 8'h02;  // Clear Error Req / Resp
            5, 6: msg_sub_code = 8'h06;  // End Tx Init D to C eye sweep Req / Resp
          endcase
        end
        
        RX_INIT_POINT_TEST: begin
          case(i_msg_no)
            1, 2: msg_sub_code = 8'h07;  // Start Rx Init D to C point test Req / Resp
            3, 4: msg_sub_code = 8'h02;  // Clear Error Req / Resp
            5, 6: msg_sub_code = 8'h08;  // End Rx Init D to C point test Req / Resp
            7, 8: msg_sub_code = 8'h09;  // End Rx Init D to C point test Req / Resp
          endcase
        end
        
        RX_INIT_SWEEP_TEST: begin
          case(i_msg_no)
            1, 2: msg_sub_code = 8'h0A;  // Start Rx Init D to C eye sweep Req / Resp
            3, 4: msg_sub_code = 8'h02;  // Clear Error Req / Resp
            5, 6: msg_sub_code = 8'h0B;  // Results Req / Resp
            7, 8: msg_sub_code = 8'h0D;  // End Rx Init D to C eye sweep Req / Resp
            9 	: msg_sub_code = 8'h0C;  // Done Rx Init D to C eye sweep Resp with result
          endcase
        end
      endcase
    end
    else begin
      // Handle Normal Messages
      case(i_state)
        SBINIT: begin
          case(i_msg_no)
            1, 2: msg_sub_code = 8'h01;  // SBINIT done Req / Resp
            3 	: msg_sub_code = 8'h00;  // SBINIT out of Reset
          endcase
        end
        
        MBINIT: begin
          	case(i_sub_state)
	            PARAM: begin
	                msg_sub_code = 8'h00;  // PARAM config Req / Resp
	            end
	            CAL: begin
	                msg_sub_code = 8'h02;  // CAL Done Req / Resp
	            end
	            REPAIRCLK: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h03;  // REPAIRCLK init Req / Resp
	                3, 4: msg_sub_code = 8'h04;  // REPAIRCLK result Req / Resp
	                5, 6: msg_sub_code = 8'h08;  // REPAIRCLK done Req / Resp
	              endcase
	            end
	            REPAIRVAL: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h09;  // REPAIRVAL init Req / Resp
	                3, 4: msg_sub_code = 8'h0A;  // REPAIRVAL result Req / Resp
	                5, 6: msg_sub_code = 8'h0C;  // REPAIRVAL done Req / Resp
	              endcase
	            end
	            REVERSALMB: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h0D;  // REVERSALMB init Req / Resp
	                3, 4: msg_sub_code = 8'h0E;  // REVERSALMB clear error Req / Resp
	                5, 6: msg_sub_code = 8'h0F;  // REVERSALMB result Req / Resp
	                7, 8: msg_sub_code = 8'h10;  // REVERSALMB done Req / Resp
	              endcase
	            end
	            REPAIRMB: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h11;  // REPAIRMB start Req / Resp
	                3, 4: msg_sub_code = 8'h13;  // REPAIRMB end Req / Resp
	                5, 6: msg_sub_code = 8'h14;  // REPAIRMB apply degrade Req / Resp
	              endcase
	            end
          	endcase
        end
        
        MBTRAIN: begin
          	case(i_sub_state)
	            VALREF: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h00;  // VALVREF start Req / Resp
	                3, 4: msg_sub_code = 8'h01;  // VALVREF end Req / Resp
	              endcase
	            end
	            DATAVREF: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h02;  // DATAVREF start Req / Resp
	                3, 4: msg_sub_code = 8'h03;  // DATAVREF end Req / Resp
	              endcase
	            end
	            SPEEDIDLE: begin
	              msg_sub_code = 8'h04;  // SPEEDIDLE Done Req / Resp
	            end
	            TXSELFCAL: begin
	                msg_sub_code = 8'h05;  // TXSELFCAL Done Req / Resp
	            end
	            RXCLKCAL: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h06;  // DATAVREF start Req / Resp
	                3, 4: msg_sub_code = 8'h07;  // DATAVREF done Req / Resp
	              endcase
	            end
	            VALTRAINCENTER: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h08;  // VALTRAINCENTER start Req / Resp
	                3, 4: msg_sub_code = 8'h09;  // VALTRAINCENTER done Req / Resp
	              endcase
	            end
	            VALTRAINVREF: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h0A;  // VALTRAINVREF start Req / Resp
	                3, 4: msg_sub_code = 8'h0B;  // VALTRAINVREF done Req / Resp
	              endcase
	            end
	            DATATRAINCENTER1: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h0C;  // DATATRAINCENTER1 start Req / Resp
	                3, 4: msg_sub_code = 8'h0D;  // DATATRAINCENTER1 end Req / Resp
	              endcase
	            end
	            DATATRAINVREF: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h0E;  // DATATRAINCENTER1 start Req / Resp
	                3, 4: msg_sub_code = 8'h10;  // DATATRAINCENTER1 end Req / Resp
	              endcase
	            end
	            RXDESKEW: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h11;  // RXDESKEW start Req / Resp
	                3, 4: msg_sub_code = 8'h12;  // RXDESKEW end Req / Resp
	              endcase
	            end
	            DATATRAINCENTER2: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h13;  // DATATRAINCENTER2 start Req / Resp
	                3, 4: msg_sub_code = 8'h14;  // DATATRAINCENTER2 end Req / Resp
	              endcase
	            end
	            LINKSPEED: begin
	              case(i_msg_no)
	                1, 2  : msg_sub_code = 8'h15;  // LINKSPEED start Req / Resp
	                3, 4  : msg_sub_code = 8'h16;  // LINKSPEED error Req / Resp
	                5, 6  : msg_sub_code = 8'h17;  // LINKSPEED speed degrade Req / Resp
	                7, 8  : msg_sub_code = 8'h18;  // LINKSPEED error Req / Resp
	                9, 10 : msg_sub_code = 8'h19;  // LINKSPEED done Req / Resp
	                11, 12: msg_sub_code = 8'h19;  // LINKSPEED exit to phy retrain Req / Resp
	              endcase
	            end
	            REPAIR: begin
	              case(i_msg_no)
	                1, 2: msg_sub_code = 8'h1B;  // REPAIR Init Req / Resp
	                3, 4: msg_sub_code = 8'h1C;  // REPAIR Apply repair Req / Resp
	                5, 6: msg_sub_code = 8'h1D;  // REPAIR End Req / Resp
	                7, 8: msg_sub_code = 8'h1E;  // REPAIR Apply degrade Req / Resp
	              endcase
	            end
           	endcase
        end
        
        
        TRAINERROR_HS: begin
          msg_sub_code = 8'h00;  // TRAINERROR Entry Req / Resp
        end
        
        PHYRETRAIN: begin
          msg_sub_code = 8'h01;  // PHYRETRAIN.retrain start Req / Resp
        end
      endcase
    end
  end
end


/*------------------------------------------------------------------------------
-- Message Info Encoding  
------------------------------------------------------------------------------*/
always @(*) begin
	if(LTSM_MSG_VALID) begin
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
/*always @(posedge i_clk or negedge i_rst_n) begin
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
end*/


/*------------------------------------------------------------------------------
-- Previous State / SubState / Test  
------------------------------------------------------------------------------*/
/*always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		i_msg_no_reg 					<= 0;
		state_reg 						<= 0;
		sub_state_reg 					<= 0;
		i_tx_point_sweep_test_en_reg	<= 0;
	end
	else if(i_msg_valid) begin
		i_msg_no_reg 					<= i_msg_no;
		state_reg 						<= i_state;
		sub_state_reg 					<= i_sub_state;
		i_tx_point_sweep_test_en_reg 	<= i_tx_point_sweep_test_en;
	end
end*/

/*------------------------------------------------------------------------------
-- Internal flag to tell that all header Are updated and can use them  
------------------------------------------------------------------------------*/
/*always @(posedge i_clk or negedge i_rst_n) begin
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
end*/


/*------------------------------------------------------------------------------
-- Outputs  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if (~i_rst_n) begin
		o_header 			<= 0;
		o_header_valid 		<= 0;
	end
	else if (i_msg_valid) begin
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
		o_header_valid 			<= 0;
	end
end


/*------------------------------------------------------------------------------
-- RDI MsgInfo  
------------------------------------------------------------------------------*/
/*always @(posedge i_clk or negedge i_rst_n) begin
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
end*/



endmodule : SB_HEADER_ENCODER