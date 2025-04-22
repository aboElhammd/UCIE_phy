module SB_HEADER_ENCODER_TB ();

	logic 				i_clk;
	logic 				i_rst_n;
	logic				i_msg_valid;
	logic 				i_data_valid;
	logic		[2:0]	i_state;
	logic 		[3:0]	i_sub_state;
	logic 		[3:0]	i_msg_no;
	logic 		[2:0]	i_msg_info;
	logic 				i_tx_point_sweep_test_en;
	logic 		[1:0]  	i_tx_point_sweep_test;
	logic 				i_rdi_msg;
	logic 		[1:0]	i_rdi_msg_code;
	logic 		[3:0] 	i_rdi_msg_sub_code;
	logic 		[1:0] 	i_rdi_msg_info;
	logic		[61:0]	o_rdi_header;
	logic				o_rdi_header_valid;	
	logic		[61:0]	o_header;
	logic				o_header_valid;



	typedef enum {RESET, SBINIT, MBINIT, MBTRAIN, LINKINIT, ACTIVE, PHYRETRAIN, TRAINERROR} state_e;
	
	typedef enum {PARAM, CAL, REPAIRCLK, REPAIRVAL, REVERSALMB, REPAIRMB} MBINIT_SubState_e;
	
	typedef enum {VALREF, DATAVREF, SPEEDIDLE, TXSELFCAL, RXCLKCAL, VALTRAINCENTER, VALTRAINVREF, DATATRAINCENTER1, DATATRAINVREF,RXDESKEW, DATATRAINCENTER2, LINKSPEED, REPAIR} MBTRAIN_SubState_e;
	
	typedef enum {	SBINIT_DONE_REQ 	= 1,
					SBINIT_DONE_RESP,
					SBINIT_OUT_OF_RESET} SBINIT_MSG_e;

	typedef enum {	MBINIT_PARAM_CONFIGURATION_REQ = 1, 
					MBINIT_PARAM_CONFIGURATION_RESP} MBINIT_PARAM_MSG_e;
	
	typedef enum {	MBINIT_CAL_DONE_REQ = 1, 
					MBINIT_CAL_DONE_RESP} MBINIT_CAL_MSG_e;
	
	typedef enum logic 	[3:0]	 {	MBINIT_REPAIRCLK_INIT_REQ = 1, 
				  					MBINIT_REPAIRCLK_INIT_RESP,
				  					MBINIT_REPAIRCLK_RESULT_REQ,
	 			  					MBINIT_REPAIRCLK_RESULT_RESP,
	 			  					MBINIT_REPAIRCLK_DONE_REQ,
	 			  					MBINIT_REPAIRCLK_DONE_RESP} MBINIT_REPAIRCLK_MSG_e;

	typedef enum logic 	[3:0]	 {	MBINIT_REPAIRVAL_INIT_REQ = 1,
				  					MBINIT_REPAIRVAL_INIT_RESP,
				  					MBINIT_REPAIRVAL_RESULT_REQ,
				  					MBINIT_REPAIRVAL_RESULT_RESP,
				  					MBINIT_REPAIRVAL_DONE_REQ,
				  					MBINIT_REPAIRVAL_DONE_RESP} MBINIT_REPAIRVAL_MSG_e;

	typedef enum logic 	[3:0]	 {	MBINIT_REVERSALMB_INIT_REQ = 1,	
									MBINIT_REVERSALMB_INIT_RESP, 	
									MBINIT_REVERSALMB_CLEAR_ERROR_REQ,
									MBINIT_REVERSALMB_CLEAR_ERROR_RESP,
									MBINIT_REVERSALMB_RESULT_REQ ,
									MBINIT_REVERSALMB_RESULT_RESP, 
									MBINIT_REVERSALMB_DONE_REQ ,	
									MBINIT_REVERSALMB_DONE_RESP} MBINIT_REVERSALMB_MSG_e;

	typedef enum logic 	[3:0]	 {	MBINIT_REPAIRMB_START_REQ = 1, 	
									MBINIT_REPAIRMB_START_RESP, 	
									MBINIT_REPAIRMB_END_REQ, 		
									MBINIT_REPAIRMB_END_RESP, 	
									MBINIT_REPAIRMB_APPLY_DEGRADE_REQ,
									MBINIT_REPAIRMB_APPLY_DEGRADE_RESP} MBINIT_REPAIRMB_MSG_e;
	
	typedef enum logic 	[3:0]	 {	MBTRAIN_VALVREF_START_REQ = 1, 	
									MBTRAIN_VALVREF_START_RESP, 	
									MBTRAIN_VALVREF_END_REQ, 		
									MBTRAIN_VALVREF_END_RESP} MBTRAIN_VALVREF_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_DATAVREF_START_REQ = 1, 	
									MBTRAIN_DATAVREF_START_RESP, 	
									MBTRAIN_DATAVREF_END_REQ, 		
									MBTRAIN_DATAVREF_END_RESP} MBTRAIN_DATAVREF_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_SPEEDIDLE_DONE_REQ = 1, 	
									MBTRAIN_SPEEDIDLE_DONE_RESP} MBTRAIN_SPEEDIDLE_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_TXSELFCAL_DONE_REQ = 1, 	
									MBTRAIN_TXSELFCAL_DONE_RESP} MBTRAIN_TXSELFCAL_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_RXCLKCAL_START_REQ = 1, 	
									MBTRAIN_RXCLKCAL_START_RESP, 		
									MBTRAIN_RXCLKCAL_DONE_REQ, 		
									MBTRAIN_RXCLKCAL_DONE_RESP} MBTRAIN_RXCLKCAL_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_VALTRAINCENTER_START_REQ = 1, 	
									MBTRAIN_VALTRAINCENTER_START_RESP, 		
									MBTRAIN_VALTRAINCENTER_DONE_REQ, 		
									MBTRAIN_VALTRAINCENTER_DONE_RESP} MBTRAIN_VALTRAINCENTER_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_VALTRAINVREF_START_REQ = 1, 	
									MBTRAIN_VALTRAINVREF_START_RESP, 		
									MBTRAIN_VALTRAINVREF_DONE_REQ, 		
									MBTRAIN_VALTRAINVREF_DONE_RESP} MBTRAIN_VALTRAINVREF_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_DATATRAINCENTER1_START_REQ = 1, 	
									MBTRAIN_DATATRAINCENTER1_START_RESP, 	
									MBTRAIN_DATATRAINCENTER1_END_REQ, 		
									MBTRAIN_DATATRAINCENTER1_END_RESP} MBTRAIN_DATATRAINCENTER1_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_DATATRAINVREF_START_REQ = 1, 	
									MBTRAIN_DATATRAINVREF_START_RESP, 	
									MBTRAIN_DATATRAINVREF_END_REQ, 		
									MBTRAIN_DATATRAINVREF_END_RESP} MBTRAIN_DATATRAINVREF_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_RXDESKEW_START_REQ = 1, 	
									MBTRAIN_RXDESKEW_START_RESP, 	
									MBTRAIN_RXDESKEW_END_REQ, 		
									MBTRAIN_RXDESKEW_END_RESP} MBTRAIN_RXDESKEW_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_DATATRAINCENTER2_START_REQ = 1, 	
									MBTRAIN_DATATRAINCENTER2_START_RESP, 	
									MBTRAIN_DATATRAINCENTER2_END_REQ, 		
									MBTRAIN_DATATRAINCENTER2_END_RESP} MBTRAIN_DATATRAINCENTER2_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_LINKSPEED_START_REQ = 1, 	
									MBTRAIN_LINKSPEED_START_RESP, 	
									MBTRAIN_LINKSPEED_ERROR_REQ, 		
									MBTRAIN_LINKSPEED_ERROR_RESP,
									MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_REQ, 		
									MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_RESP,
									MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEDRADE_REQ, 		
									MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEDRADE_RESP,
									MBTRAIN_LINKSPEED_DONE_REQ, 		
									MBTRAIN_LINKSPEED_DONE_RESP} MBTRAIN_LINKSPEED_MSG_e;
									//MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ, 		
									//MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP} MBTRAIN_LINKSPEED_MSG_e;

	typedef enum logic 	[3:0]	 {	MBTRAIN_REPAIR_INIT_REQ = 1, 	
									MBTRAIN_REPAIR_INIT_RESP, 	
									MBTRAIN_REPAIR_APPLY_REPAIR_REQ, 		
									MBTRAIN_REPAIR_APPLY_REPAIR_RESP,
									MBTRAIN_REPAIR_END_REQ, 	
									MBTRAIN_REPAIR_END_RESP,
									MBTRAIN_REPAIR_APPLY_DEGRADE_REQ,
									MBTRAIN_REPAIR_APPLY_DEGRADE_RESP} MBTRAIN_REPAIR_MSG_e;

	typedef enum logic 	[3:0]	 {	PHYRETRAIN_RETRAIN_START_REQ = 1, 	
									PHYRETRAIN_RETRAIN_START_RESP} PHYRETRAIN_MSG_e;	

		
	state_e 						GenStates;
	state_e 						GenStates_DRV;	
	MBINIT_SubState_e 				MBINIT_SubStates;
	MBINIT_SubState_e 				MBINIT_SubStates_DRV;
	MBTRAIN_SubState_e 				MBTRAIN_SubStates;
	MBTRAIN_SubState_e 				MBTRAIN_SubStates_DRV;


	SBINIT_MSG_e 					SBINIT_MSGs;

	MBINIT_PARAM_MSG_e 		 		MBINIT_PARAM_MSGs;
	MBINIT_CAL_MSG_e   				MBINIT_CAL_MSGs;
	MBINIT_REPAIRCLK_MSG_e  		MBINIT_REPAIRCLK_MSGs;
	MBINIT_REPAIRVAL_MSG_e  		MBINIT_REPAIRVAL_MSGs;
	MBINIT_REVERSALMB_MSG_e 		MBINIT_REVERSALMB_MSGs;
	MBINIT_REPAIRMB_MSG_e 			MBINIT_REPAIRMB_MSGs;

	MBTRAIN_VALVREF_MSG_e 			MBTRAIN_VALVREF_MSGs;
	MBTRAIN_DATAVREF_MSG_e 			MBTRAIN_DATAVREF_MSGs;
	MBTRAIN_SPEEDIDLE_MSG_e 		MBTRAIN_SPEEDIDLE_MSGs;
	MBTRAIN_TXSELFCAL_MSG_e 		MBTRAIN_TXSELFCAL_MSGs;
	MBTRAIN_RXCLKCAL_MSG_e 			MBTRAIN_RXCLKCAL_MSGs;
	MBTRAIN_VALTRAINCENTER_MSG_e 	MBTRAIN_VALTRAINCENTER_MSGs;
	MBTRAIN_VALTRAINVREF_MSG_e 		MBTRAIN_VALTRAINVREF_MSGs;
	MBTRAIN_DATATRAINCENTER1_MSG_e 	MBTRAIN_DATATRAINCENTER1_MSGs;
	MBTRAIN_DATATRAINVREF_MSG_e 	MBTRAIN_DATATRAINVREF_MSGs;
	MBTRAIN_RXDESKEW_MSG_e 			MBTRAIN_RXDESKEW_MSGs;
	MBTRAIN_DATATRAINCENTER2_MSG_e 	MBTRAIN_DATATRAINCENTER2_MSGs;
	MBTRAIN_LINKSPEED_MSG_e 		MBTRAIN_LINKSPEED_MSGs;
	MBTRAIN_REPAIR_MSG_e 			MBTRAIN_REPAIR_MSGs;

	PHYRETRAIN_MSG_e 				PHYRETRAIN_MSGs;



	reg [7:0] GM_msg_code;
	reg [7:0] GM_msg_sub_code;

	int err_cnt = 0;
	int crrct_cnt = 0;

	assign GenStates 			= state_e '(i_state);
	assign MBINIT_SubStates 	= MBINIT_SubState_e '(i_sub_state);
	assign MBTRAIN_SubStates 	= MBTRAIN_SubState_e '(i_sub_state);




	SB_HEADER_ENCODER inst_SB_HEADER_ENCODER
		(
			.i_clk                  (i_clk),
			.i_rst_n                (i_rst_n),
			.i_msg_valid            (i_msg_valid),
			.i_data_valid           (i_data_valid),
			.i_state                (i_state),
			.i_sub_state            (i_sub_state),
			.i_msg_no               (i_msg_no),
			.i_msg_info             (i_msg_info),
			.i_tx_point_sweep_test_en (i_tx_point_sweep_test_en),
			.i_tx_point_sweep_test   (i_tx_point_sweep_test),
			.i_rdi_msg              (i_rdi_msg),
			.i_rdi_msg_code         (i_rdi_msg_code),
			.i_rdi_msg_sub_code     (i_rdi_msg_sub_code),
			.i_rdi_msg_info         (i_rdi_msg_info),
			.o_rdi_header           (o_rdi_header),
			.o_rdi_header_valid     (o_rdi_header_valid),
			.o_header               (o_header),
			.o_header_valid         (o_header_valid)
		);


	initial begin
		i_clk = 0;
		forever begin
			#1 i_clk = ~i_clk;
		end
	end

	initial begin
		// Initialize logics
	    init();

	   	// Reset 
	   	rst();


	   	MsgSubCode_test();

	   	$display("ERROR COUNT %0d",err_cnt);
	   	$display("CORRECT COUNT %0d",crrct_cnt);


	   	$stop();



	end


	task init();
		i_msg_valid 				= 0;
		i_data_valid				= 0;
		i_state 					= 0;
		i_sub_state					= 0;
		i_msg_no					= 0;
		i_msg_info 					= 0;
		i_tx_point_sweep_test_en	= 0;
		i_tx_point_sweep_test  		= 0;
		i_rdi_msg					= 0;
		i_rdi_msg_code				= 0;
		i_rdi_msg_sub_code			= 0;
		i_rdi_msg_info				= 0;

	endtask

	task rst();
		i_rst_n = 0;
		repeat (10) @(negedge i_clk);
		i_rst_n = 1;
	endtask : rst

		task MsgSubCode_test();
			GenStates_DRV = GenStates_DRV.first();
			for (int i = 0; i < GenStates_DRV.num(); i++) begin
				i_state = GenStates_DRV;
				$display("////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
				$display("/////////////////////////////////////////////// %s  ", GenStates_DRV, "/////////////////////////////////////////////");
				$display("////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
				case (GenStates_DRV)
					SBINIT 		: begin
						SBINIT_MSGs = SBINIT_MSGs.first();
				 		for (int i = 0; i < SBINIT_MSGs.num(); i++) begin
	   	 					i_msg_no = SBINIT_MSGs;
	    					$display("i_msg_no: %s", SBINIT_MSGs);
	    					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    			MsgCode_MsgSubCode_Check();
	    					if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    $display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    err_cnt ++;
							end
							else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							 	$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							 	err_cnt ++;
							end
			    			else begin
			    				crrct_cnt ++;
			    			end
	    					@(negedge i_clk);
	    					SBINIT_MSGs = SBINIT_MSGs.next();							
				 		end
					end

					MBINIT 		: begin
						MBINIT_SubStates_DRV 		= MBINIT_SubStates_DRV.first();
						for (int i = 0; i < MBINIT_SubStates_DRV.num(); i++) begin
							$display("///////////////////////////////////////////////////////////////////////////////");
							$display("/////////////////////// %s ", MBINIT_SubStates_DRV, "//////////////////////////");
							$display("///////////////////////////////////////////////////////////////////////////////");
						 	i_sub_state = MBINIT_SubStates_DRV;
						 	case (MBINIT_SubStates_DRV)
						 		PARAM: 
						 			begin
						 				MBINIT_PARAM_MSGs = MBINIT_PARAM_MSGs.first();
						 				for (int i = 0; i < MBINIT_PARAM_MSGs.num(); i++) begin
			   	 							i_msg_no = MBINIT_PARAM_MSGs;
			    							$display("i_msg_no: %s", MBINIT_PARAM_MSGs);
			    							MsgCode_MsgSubCode_Check();
			    							i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
			    							@(negedge i_clk);
			    							MBINIT_PARAM_MSGs = MBINIT_PARAM_MSGs.next();							
						 				end
						 			end
								
								CAL: 
						 			begin
						 				MBINIT_CAL_MSGs = MBINIT_CAL_MSGs.first();
						 				for (int i = 0; i < MBINIT_CAL_MSGs.num(); i++) begin
						 					i_msg_no = MBINIT_CAL_MSGs;
						 					$display("i_msg_no: %s", MBINIT_CAL_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
						 					if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBINIT_CAL_MSGs = MBINIT_CAL_MSGs.next();
						 				end
						 		end

						 		REPAIRCLK: 
						 			begin
						 				MBINIT_REPAIRCLK_MSGs = MBINIT_REPAIRCLK_MSGs.first();
						 				for (int i = 0; i < MBINIT_REPAIRCLK_MSGs.num(); i++) begin
						 					i_msg_no = MBINIT_REPAIRCLK_MSGs;
						 					$display("i_msg_no: %s", MBINIT_REPAIRCLK_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
						 					if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBINIT_REPAIRCLK_MSGs = MBINIT_REPAIRCLK_MSGs.next();
						 				end
						 			end
								
								REPAIRVAL: 
						 			begin
						 				MBINIT_REPAIRVAL_MSGs = MBINIT_REPAIRVAL_MSGs.first();
						 				for (int i = 0; i < MBINIT_REPAIRVAL_MSGs.num(); i++) begin
						 					i_msg_no = MBINIT_REPAIRVAL_MSGs;
						 					$display("i_msg_no: %s", MBINIT_REPAIRVAL_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
						 					if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBINIT_REPAIRVAL_MSGs = MBINIT_REPAIRVAL_MSGs.next();
						 				end
						 		end

						 		REVERSALMB: 
						 			begin
						 				MBINIT_REVERSALMB_MSGs = MBINIT_REVERSALMB_MSGs.first();
						 				for (int i = 0; i < MBINIT_REVERSALMB_MSGs.num(); i++) begin
						 					i_msg_no = MBINIT_REVERSALMB_MSGs;
						 					$display("i_msg_no: %s", MBINIT_REVERSALMB_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
						 					if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBINIT_REVERSALMB_MSGs = MBINIT_REVERSALMB_MSGs.next();
						 				end
						 			end
								
								REPAIRMB: 
						 			begin
						 				MBINIT_REPAIRMB_MSGs = MBINIT_REPAIRMB_MSGs.first();
						 				for (int i = 0; i < MBINIT_REPAIRMB_MSGs.num(); i++) begin
						 					i_msg_no = MBINIT_REPAIRMB_MSGs;
						 					$display("i_msg_no: %s", MBINIT_REPAIRMB_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
						 					if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBINIT_REPAIRMB_MSGs = MBINIT_REPAIRMB_MSGs.next();
						 				end
						 		end
						 	endcase
						 	MBINIT_SubStates_DRV = MBINIT_SubStates_DRV.next();
						end 
					end

					MBTRAIN 	: begin
						MBTRAIN_SubStates_DRV 		= MBTRAIN_SubStates_DRV.first();
						for (int i = 0; i < MBTRAIN_SubStates_DRV.num(); i++) begin
							$display("////////////////////////////////////////////////////////////////////////////////");
							$display("/////////////////////// %s ", MBTRAIN_SubStates_DRV, "//////////////////////////");
							$display("////////////////////////////////////////////////////////////////////////////////");
						 	i_sub_state = MBTRAIN_SubStates_DRV;
						 	case (MBTRAIN_SubStates_DRV)
						 		VALREF 			: 
						 			begin
						 				MBTRAIN_VALVREF_MSGs = MBTRAIN_VALVREF_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_VALVREF_MSGs.num(); i++) begin
			   	 							i_msg_no = MBTRAIN_VALVREF_MSGs;
			    							$display("i_msg_no: %s", MBTRAIN_VALVREF_MSGs);
			    							MsgCode_MsgSubCode_Check();
			    							i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
			    							@(negedge i_clk);
			    							MBTRAIN_VALVREF_MSGs = MBTRAIN_VALVREF_MSGs.next();						
						 				end
						 			end
								
								DATAVREF 		: 
						 			begin
						 				MBTRAIN_DATAVREF_MSGs = MBTRAIN_DATAVREF_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_DATAVREF_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_DATAVREF_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_DATAVREF_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_DATAVREF_MSGs = MBTRAIN_DATAVREF_MSGs.next();
						 				end
						 		end

						 		SPEEDIDLE 		: 
						 			begin
						 				MBTRAIN_SPEEDIDLE_MSGs = MBTRAIN_SPEEDIDLE_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_SPEEDIDLE_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_SPEEDIDLE_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_SPEEDIDLE_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_SPEEDIDLE_MSGs = MBTRAIN_SPEEDIDLE_MSGs.next();
						 				end
						 			end
								
								TXSELFCAL 		: 
						 			begin
						 				MBTRAIN_TXSELFCAL_MSGs = MBTRAIN_TXSELFCAL_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_TXSELFCAL_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_TXSELFCAL_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_TXSELFCAL_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_TXSELFCAL_MSGs = MBTRAIN_TXSELFCAL_MSGs.next();
						 				end
						 		end

						 		RXCLKCAL 		: 
						 			begin
						 				MBTRAIN_RXCLKCAL_MSGs = MBTRAIN_RXCLKCAL_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_RXCLKCAL_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_RXCLKCAL_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_RXCLKCAL_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
			    							end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_RXCLKCAL_MSGs = MBTRAIN_RXCLKCAL_MSGs.next();
						 				end
						 			end
								
								VALTRAINCENTER 	: 
						 			begin
						 				MBTRAIN_VALTRAINCENTER_MSGs = MBTRAIN_VALTRAINCENTER_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_VALTRAINCENTER_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_VALTRAINCENTER_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_VALTRAINCENTER_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_VALTRAINCENTER_MSGs = MBTRAIN_VALTRAINCENTER_MSGs.next();
						 				end
						 		end

						 		VALTRAINVREF 	: 
						 			begin
						 				MBTRAIN_VALTRAINVREF_MSGs = MBTRAIN_VALTRAINVREF_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_VALTRAINVREF_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_VALTRAINVREF_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_VALTRAINVREF_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_VALTRAINVREF_MSGs = MBTRAIN_VALTRAINVREF_MSGs.next();
						 				end
						 		end

						 		DATATRAINCENTER1 : 
						 			begin
						 				MBTRAIN_DATATRAINCENTER1_MSGs = MBTRAIN_DATATRAINCENTER1_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_DATATRAINCENTER1_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_DATATRAINCENTER1_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_DATATRAINCENTER1_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_DATATRAINCENTER1_MSGs = MBTRAIN_DATATRAINCENTER1_MSGs.next();
						 				end
						 		end

						 		DATATRAINVREF 	: 
						 			begin
						 				MBTRAIN_DATATRAINVREF_MSGs = MBTRAIN_DATATRAINVREF_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_DATATRAINVREF_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_DATATRAINVREF_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_DATATRAINVREF_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_DATATRAINVREF_MSGs = MBTRAIN_DATATRAINVREF_MSGs.next();
						 				end
						 		end

						 		RXDESKEW 		: 
						 			begin
						 				MBTRAIN_RXDESKEW_MSGs = MBTRAIN_RXDESKEW_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_RXDESKEW_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_RXDESKEW_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_RXDESKEW_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_RXDESKEW_MSGs = MBTRAIN_RXDESKEW_MSGs.next();
						 				end
						 		end

						 		DATATRAINCENTER2 : 
						 			begin
						 				MBTRAIN_DATATRAINCENTER2_MSGs = MBTRAIN_DATATRAINCENTER2_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_DATATRAINCENTER2_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_DATATRAINCENTER2_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_DATATRAINCENTER2_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_DATATRAINCENTER2_MSGs = MBTRAIN_DATATRAINCENTER2_MSGs.next();
						 				end
						 		end

						 		LINKSPEED 		: 
						 			begin
						 				MBTRAIN_LINKSPEED_MSGs = MBTRAIN_LINKSPEED_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_LINKSPEED_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_LINKSPEED_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_LINKSPEED_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
							    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
							    				err_cnt ++;
							    			end
							    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
							    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
							    				err_cnt ++;
							    			end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_LINKSPEED_MSGs = MBTRAIN_LINKSPEED_MSGs.next();
						 				end
						 		end

						 		REPAIR 			: 
						 			begin
						 				MBTRAIN_REPAIR_MSGs = MBTRAIN_REPAIR_MSGs.first();
						 				for (int i = 0; i < MBTRAIN_REPAIR_MSGs.num(); i++) begin
						 					i_msg_no = MBTRAIN_REPAIR_MSGs;
						 					$display("i_msg_no: %s", MBTRAIN_REPAIR_MSGs);
						 					MsgCode_MsgSubCode_Check();
						 					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    							if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
			    								$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
			    								err_cnt ++;
			    							end
			    							else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
			    							$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
			    							err_cnt ++;
			    							end
			    							else begin
			    								crrct_cnt ++;
			    							end
						 					@(negedge i_clk);
						 					MBTRAIN_REPAIR_MSGs = MBTRAIN_REPAIR_MSGs.next();
						 				end
						 		end
						 	endcase
						 	MBTRAIN_SubStates_DRV = MBTRAIN_SubStates_DRV.next();
						end 
					end

					PHYRETRAIN 	: begin
						PHYRETRAIN_MSGs = PHYRETRAIN_MSGs.first();
				 		for (int i = 0; i < PHYRETRAIN_MSGs.num(); i++) begin
	   	 					i_msg_no = PHYRETRAIN_MSGs;
	    					$display("i_msg_no: %s", PHYRETRAIN_MSGs);
	    					MsgCode_MsgSubCode_Check();
	    					i_msg_valid = 1; @(negedge i_clk); i_msg_valid = 0;
			    			if (inst_SB_HEADER_ENCODER.msg_code != GM_msg_code) begin
			    				$display("%0t: ERROR at MsgCode As MsgCode = %h while GM_MsgCode = %h",$time(), inst_SB_HEADER_ENCODER.msg_code, GM_msg_code);
			    				err_cnt ++;
			    			end
			    			else if (inst_SB_HEADER_ENCODER.msg_sub_code != GM_msg_sub_code) begin
			    				$display("%0t: ERROR at MsgSubCode As MsgSubCode = %h while GM_MsgSubCode = %h",$time(),inst_SB_HEADER_ENCODER.msg_sub_code, GM_msg_sub_code);
			    				err_cnt ++;
			    			end
			    				else begin
			    					crrct_cnt ++;
			    				end
	    					@(negedge i_clk);
	    					PHYRETRAIN_MSGs = PHYRETRAIN_MSGs.next();						
				 		end
					end
				endcase
				GenStates_DRV = GenStates_DRV.next();
			end
		endtask : MsgSubCode_test


		task MsgCode_MsgSubCode_Check();
			case (GenStates_DRV) 
				SBINIT 	: begin
					case (SBINIT_MSGs)
						SBINIT_OUT_OF_RESET: begin
							GM_msg_code 	= 8'h91;
							GM_msg_sub_code = 8'h00;
						end
						SBINIT_OUT_OF_RESET: begin
							GM_msg_code 	= 8'h95;
							GM_msg_sub_code = 8'h01;
						end
						SBINIT_OUT_OF_RESET: begin
							GM_msg_code 	= 8'h9A;
							GM_msg_sub_code = 8'h01;
						end	
					endcase
				end

				MBINIT 	: begin
					case (MBINIT_SubStates_DRV)
						PARAM 		: begin
							GM_msg_sub_code = 8'h00;
							case (MBINIT_PARAM_MSGs) 
					 			MBINIT_PARAM_CONFIGURATION_REQ	: GM_msg_code = 8'hA5;
					 			MBINIT_PARAM_CONFIGURATION_RESP	: GM_msg_code = 8'hAA;					 	
							endcase
						end
						CAL 		: begin
							GM_msg_sub_code = 8'h02;
							case (MBINIT_CAL_MSGs) 
					 			MBINIT_CAL_DONE_REQ		: GM_msg_code = 8'hA5;
					 			MBINIT_CAL_DONE_RESP	: GM_msg_code = 8'hAA;					 	
							endcase
						end
						REPAIRCLK 	: begin
							case (MBINIT_REPAIRCLK_MSGs) 
					 			MBINIT_REPAIRCLK_INIT_REQ		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h03;
					 			end
					 			MBINIT_REPAIRCLK_INIT_RESP		: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h03;
					 			end
					 			MBINIT_REPAIRCLK_RESULT_REQ		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h04;
					 			end
					 			MBINIT_REPAIRCLK_RESULT_RESP	: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h04;
					 			end
					 			MBINIT_REPAIRCLK_DONE_REQ		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h08;
					 			end
					 			MBINIT_REPAIRCLK_DONE_RESP		: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h08;
					 			end						 	
							endcase
						end
						REPAIRVAL 	: begin
							case (MBINIT_REPAIRVAL_MSGs) 
					 			MBINIT_REPAIRVAL_INIT_REQ		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h09;
					 			end
					 			MBINIT_REPAIRVAL_INIT_RESP		: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h09;
					 			end 
					 			MBINIT_REPAIRVAL_RESULT_REQ		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h0A;
					 			end
					 			MBINIT_REPAIRVAL_RESULT_RESP	: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h0A;
					 			end
					 			MBINIT_REPAIRVAL_DONE_REQ		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h0C;
					 			end
					 			MBINIT_REPAIRVAL_DONE_RESP		: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h0C;
					 			end						 	
							endcase
						end
						REVERSALMB 	: begin
							case (MBINIT_REVERSALMB_MSGs) 
					 			MBINIT_REVERSALMB_INIT_REQ			: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h0D;
					 			end
					 			MBINIT_REVERSALMB_INIT_RESP			: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h0D;
					 			end
					 			MBINIT_REVERSALMB_CLEAR_ERROR_REQ	: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h0E;
					 			end
					 			MBINIT_REVERSALMB_CLEAR_ERROR_RESP	: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h0E;
					 			end
					 			MBINIT_REVERSALMB_RESULT_REQ 		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h0F;
					 			end
					 			MBINIT_REVERSALMB_RESULT_RESP		: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h0F;
					 			end
					 			MBINIT_REVERSALMB_DONE_REQ 		: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h10;
					 			end
					 			MBINIT_REVERSALMB_DONE_RESP		: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h10;
					 			end						 	
							endcase
						end
						REPAIRMB 	: begin
							case (MBINIT_REPAIRMB_MSGs) 
					 			MBINIT_REPAIRMB_START_REQ			: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h11;
					 			end
					 			MBINIT_REPAIRMB_START_RESP			: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h11;
					 			end
					 			MBINIT_REPAIRMB_END_REQ				: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h13;
					 			end
					 			MBINIT_REPAIRMB_END_RESP			: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h13;
					 			end
					 			MBINIT_REPAIRMB_APPLY_DEGRADE_REQ	: begin
					 				GM_msg_code 	<= 8'hA5;
					 				GM_msg_sub_code <= 8'h14;
					 			end
					 			MBINIT_REPAIRMB_APPLY_DEGRADE_RESP	: begin
					 				GM_msg_code 	<= 8'hAA;
					 				GM_msg_sub_code <= 8'h14;
					 			end						 	
							endcase
						end
					endcase
				end

				MBTRAIN 	: begin
					case (MBTRAIN_SubStates_DRV)
						VALREF 	: begin
						 	case (MBTRAIN_VALVREF_MSGs) 
					 			MBTRAIN_VALVREF_START_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h00;
					 			end
					 			MBTRAIN_VALVREF_START_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h00;
					 			end 
					 			MBTRAIN_VALVREF_END_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h01;
					 			end
					 			MBTRAIN_VALVREF_END_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h01;
					 			end					 	
							endcase
						end
								
						DATAVREF 		 : begin
						 	case (MBTRAIN_DATAVREF_MSGs) 
					 			MBTRAIN_DATAVREF_START_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h02;
					 			end
					 			MBTRAIN_DATAVREF_START_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h02;
					 			end 
					 			MBTRAIN_DATAVREF_END_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h03;
					 			end
					 			MBTRAIN_DATAVREF_END_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h03;
					 			end					 	
							endcase
						end

						SPEEDIDLE 		 : begin
						 	case (MBTRAIN_SPEEDIDLE_MSGs) 
					 			MBTRAIN_TXSELFCAL_DONE_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h04;
					 			end
					 			MBTRAIN_TXSELFCAL_DONE_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h04;
					 			end 					 	
							endcase	
						end
								
						TXSELFCAL 		 : begin
						 	case (MBTRAIN_TXSELFCAL_MSGs) 
					 			MBTRAIN_SPEEDIDLE_DONE_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h05;
					 			end
					 			MBTRAIN_SPEEDIDLE_DONE_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h05;
					 			end 					 	
							endcase			
						end

						RXCLKCAL 		 : begin
						 	case (MBTRAIN_RXCLKCAL_MSGs) 
					 			MBTRAIN_RXCLKCAL_START_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h06;
					 			end
					 			MBTRAIN_RXCLKCAL_START_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h06;
					 			end 
					 			MBTRAIN_RXCLKCAL_DONE_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h07;
					 			end
					 			MBTRAIN_RXCLKCAL_DONE_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h07;
					 			end					 	
							endcase	
						end
								
						VALTRAINCENTER 	 : begin
						 	case (MBTRAIN_VALTRAINCENTER_MSGs) 
					 			MBTRAIN_VALTRAINCENTER_START_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h08;
					 			end
					 			MBTRAIN_VALTRAINCENTER_START_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h08;
					 			end 
					 			MBTRAIN_VALTRAINCENTER_DONE_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h09;
					 			end
					 			MBTRAIN_VALTRAINCENTER_DONE_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h09;
					 			end					 	
							endcase			
						end

						VALTRAINVREF 	 : begin
						 	case (MBTRAIN_VALTRAINVREF_MSGs) 
					 			MBTRAIN_VALTRAINVREF_START_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h0A;
					 			end
					 			MBTRAIN_VALTRAINVREF_START_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h0A;
					 			end 
					 			MBTRAIN_VALTRAINVREF_DONE_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h0B;
					 			end
					 			MBTRAIN_VALTRAINVREF_DONE_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h0B;
					 			end					 	
							endcase		
						end

						DATATRAINCENTER1 : begin
						 	case (MBTRAIN_DATATRAINCENTER1_MSGs) 
					 			MBTRAIN_DATATRAINCENTER1_START_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h0C;
					 			end
					 			MBTRAIN_DATATRAINCENTER1_START_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h0C;
					 			end 
					 			MBTRAIN_DATATRAINCENTER1_END_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h0D;
					 			end
					 			MBTRAIN_DATATRAINCENTER1_END_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h0D;
					 			end					 	
							endcase	
						end

						DATATRAINVREF 	 : begin
						 	case (MBTRAIN_DATATRAINVREF_MSGs) 
					 			MBTRAIN_DATATRAINVREF_START_REQ		: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h0E;
					 			end
					 			MBTRAIN_DATATRAINVREF_START_RESP 	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h0E;
					 			end 
					 			MBTRAIN_DATATRAINVREF_END_REQ 		: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h10;
					 			end
					 			MBTRAIN_DATATRAINVREF_END_RESP		: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h10;
					 			end					 	
							endcase	
						end

						RXDESKEW 		 : begin
						 	case (MBTRAIN_RXDESKEW_MSGs) 
					 			MBTRAIN_RXDESKEW_START_REQ		: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h11;
					 			end
					 			MBTRAIN_RXDESKEW_START_RESP 	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h11;
					 			end 
					 			MBTRAIN_RXDESKEW_END_REQ 		: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h12;
					 			end
					 			MBTRAIN_RXDESKEW_END_RESP		: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h12;
					 			end					 	
							endcase	
						end

						DATATRAINCENTER2 : begin
						 	case (MBTRAIN_DATATRAINCENTER2_MSGs) 
					 			MBTRAIN_DATATRAINCENTER2_START_REQ	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h13;
					 			end
					 			MBTRAIN_DATATRAINCENTER2_START_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h13;
					 			end 
					 			MBTRAIN_DATATRAINCENTER2_END_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h14;
					 			end
					 			MBTRAIN_DATATRAINCENTER2_END_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h14;
					 			end					 	
							endcase
						end

						LINKSPEED 		 : begin
						 	case (MBTRAIN_LINKSPEED_MSGs) 
					 			MBTRAIN_LINKSPEED_START_REQ					: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h15;
					 			end
					 			MBTRAIN_LINKSPEED_START_RESP				: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h15;
					 			end 
					 			MBTRAIN_LINKSPEED_ERROR_REQ 				: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h16;
					 			end
					 			MBTRAIN_LINKSPEED_ERROR_RESP				: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h16;
					 			end	
					 			MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_REQ		: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h17;
					 			end
					 			MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_RESP		: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h17;
					 			end 
					 			MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEDRADE_REQ : begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h18;
					 			end
					 			MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEDRADE_RESP: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h18;
					 			end
					 			MBTRAIN_LINKSPEED_DONE_REQ 					: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h19;
					 			end
					 			MBTRAIN_LINKSPEED_DONE_RESP					: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h19;
					 			end
					 			/*MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h1F;
					 			end
					 			MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h1F;
					 			end*/					 	
							endcase	
						end

						REPAIR 			: begin
						 	case (MBTRAIN_REPAIR_MSGs) 
					 			MBTRAIN_REPAIR_INIT_REQ				: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h1B;
					 			end
					 			MBTRAIN_REPAIR_INIT_RESP			: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h1B;
					 			end 
					 			MBTRAIN_REPAIR_APPLY_REPAIR_REQ		: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h1C;
					 			end
					 			MBTRAIN_REPAIR_APPLY_REPAIR_RESP	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h1C;
					 			end	
					 			MBTRAIN_REPAIR_END_REQ				: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h1D;
					 			end
					 			MBTRAIN_REPAIR_END_RESP				: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h1D;
					 			end 
					 			MBTRAIN_REPAIR_APPLY_DEGRADE_REQ 	: begin
					 				GM_msg_code 	<= 8'hB5;
					 				GM_msg_sub_code <= 8'h1E;
					 			end
					 			MBTRAIN_REPAIR_APPLY_DEGRADE_RESP 	: begin
					 				GM_msg_code 	<= 8'hBA;
					 				GM_msg_sub_code <= 8'h1E;
					 			end					 	
							endcase				
						end
					endcase
				end

				PHYRETRAIN 	: begin
					case (PHYRETRAIN_MSGs)
						PHYRETRAIN_RETRAIN_START_REQ	: begin
							GM_msg_code 	= 8'hC5;
							GM_msg_sub_code = 8'h01;
						end
						PHYRETRAIN_RETRAIN_START_RESP 	: begin
							GM_msg_code 	= 8'hCA;
							GM_msg_sub_code = 8'h01;
						end
					endcase
				end
			endcase
		endtask : MsgCode_MsgSubCode_Check


endmodule : SB_HEADER_ENCODER_TB