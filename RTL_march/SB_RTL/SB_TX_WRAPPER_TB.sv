`timescale 1ns/1ps

typedef enum logic [2:0] {RESET, SBINIT, MBINIT, MBTRAIN, LINKINIT, ACTIVE, PHYRETRAIN, TRAINERROR} e_states;
typedef enum logic [3:0] {PARAM, CAL, REPAIRCLK, REPAIRVAL, REVERSALMB, REPAIRMB} e_sub_states_MBINIT;
typedef enum logic [3:0] {VALREF, DATAVREF, SPEEDIDLE, TXSELFCAL, RXCLKCAL, VALTRAINCENTER, VALTRAINVREF, DATATRAINCENTER1, DATATRAINVREF, RXDESKEW, DATATRAINCENTER2, LINKSPEED, REPAIR} e_sub_states_MBTRAIN;


/*******************************************************************************
    ********************************** SBINIT **************************************
    *******************************************************************************/
    /*---------------------------------
    * SBINIT
    ---------------------------------*/
    typedef enum {  
        SBINIT_OUT_OF_RESET_MSG 	= 3,
        SBINIT_DONE_REQ_MSG		    = 1,
        SBINIT_DONE_RESP_MSG		= 2
    } sideband_messages_sbinit;

    /*******************************************************************************
    ********************************** MBINIT **************************************
    *******************************************************************************/
    /*---------------------------------
    * MBINIT.PARAM
    ---------------------------------*/
    typedef enum {
        PARAM_CONFIG_REQ = 1,
        PARAM_CONFIG_RESP,
        PARAM_SBFE_REQ,
        PARAM_SBFE_RESP
    } sideband_messages_mbinit_param;

    /*---------------------------------
    * MBINIT.CAL
    ---------------------------------*/
    typedef enum {
        CAL_DONE_REQ = 1,
        CAL_DONE_RESP
    } sideband_messages_mbinit_cal;

    /*---------------------------------
    * MBINIT.REPAIRCLK
    ---------------------------------*/
    typedef enum {
        REPAIRCLK_INIT_REQ = 1,
        REPAIRCLK_INIT_RESP,
        REPAIRCLK_RESULT_REQ,
        REPAIRCLK_RESULT_RESP,
        REPAIRCLK_APPLY_REPAIR_REQ,
        REPAIRCLK_APPLY_REPAIR_RESP,
        REPAIRCLK_CHECK_REPAIR_INIT_REQ,
        REPAIRCLK_CHECK_REPAIR_INIT_RESP,
        REPAIRCLK_CHECK_RESULTS_REQ,
        REPAIRCLK_CHECK_RESULTS_RESP,
        REPAIRCLK_DONE_REQ,
        REPAIRCLK_DONE_RESP
    } sideband_messages_mbinit_repairclk;

    /*---------------------------------
    * MBINIT.REPAIRVAL
    ---------------------------------*/
    typedef enum {
        REPAIRVAL_INIT_REQ = 1,
        REPAIRVAL_INIT_RESP,
        REPAIRVAL_RESULT_REQ,
        REPAIRVAL_RESULT_RESP,
        REPAIRVAL_APPLY_REPAIR_REQ,
        REPAIRVAL_APPLY_REPAIR_RESP,
        REPAIRVAL_DONE_REQ,
        REPAIRVAL_DONE_RESP
    } sideband_messages_mbinit_repairval;

    /*---------------------------------
    * MBINIT.REVERSALMB
    ---------------------------------*/
    typedef enum {
        REVERSALMB_INIT_REQ = 1,
        REVERSALMB_INIT_RESP,
        REVERSALMB_CLEAR_ERROR_REQ,
        REVERSALMB_CLEAR_ERROR_RESP,
        REVERSALMB_RESULT_REQ,
        REVERSALMB_RESULT_RESP,
        REVERSALMB_DONE_REQ,
        REVERSALMB_DONE_RESP
    } sideband_messages_mbinit_reversalmb;

    /*---------------------------------
    * MBINIT.REPAIRMB
    ---------------------------------*/
    typedef enum {
        REPAIRMB_START_REQ = 1,
        REPAIRMB_START_RESP,
        REPAIRMB_APPLY_REPAIR_REQ,
        REPAIRMB_APPLY_REPAIR_RESP,
        REPAIRMB_END_REQ,
        REPAIRMB_END_RESP,
        REPAIRMB_APPLY_DEGRADE_REQ,
        REPAIRMB_APPLY_DEGRADE_RESP
    } sideband_messages_mbinit_repairmb;

    typedef struct packed {
	    sideband_messages_sbinit sbinit_msg;
	    sideband_messages_mbinit_param mbinit_msg;
	} message_union_t;


module SB_TX_WRAPPER_TB ();
	// Inputs
    bit i_clk;
    logic i_rst_n;
    logic i_start_pattern_req;
    logic i_rdi_msg;
    logic i_data_valid;
    logic i_msg_valid;
    logic i_tx_point_sweep_test_en;
	logic [1:0] i_tx_point_sweep_test;
	logic [1:0] i_rdi_msg_code;
	logic [3:0] i_rdi_msg_sub_code;
	logic [1:0] i_rdi_msg_info;
    e_states i_state;
    e_sub_states_MBINIT i_sub_state;
    logic [3:0] i_msg_no;
    logic [2:0] i_msg_info;
    logic [15:0] i_data_bus;
    logic i_rx_sb_pattern_samp_done;
	logic i_rx_sb_rsp_delivered;
	logic i_ser_done;
	logic i_stop_cnt;

    // Outputs
    logic o_start_pattern_done;
	logic o_time_out;
	logic [63:0] o_tx_data_out; 
	logic o_busy;

	message_union_t msg_union;

    // Instantiate the Design
    SB_TX_WRAPPER dut (.*);

    // Clock generation
    always #5 i_clk = ~i_clk; // 10ns clock period

    initial begin
    	// Initialize inputs
    	Initialize();

    	// Reset
    	Reset();

    	// case that LTSM initiate to transfer pattern and time out occur 
    	send_pattern_time_out_occurr();

    	// case that LTSM initiate to transfer pattern and sampled done 
    	send_pattern_sampled_done();

    	// case in SBINIT state after pattern generated
    	simulation();

    	$stop;

    end

    task Initialize();
    	i_start_pattern_req = 0;
	    i_tx_point_sweep_test_en = 0;
	    i_rdi_msg = 0;
	    i_data_valid = 0;
	    i_msg_valid = 0;
	    i_state = RESET;
	    i_sub_state = PARAM;
	    i_msg_no = 0;
	    i_msg_info = 0;
	    i_data_bus = 0;
	    i_rx_sb_pattern_samp_done = 0;
		i_rx_sb_rsp_delivered = 0;
		i_ser_done = 0;
    endtask : Initialize

    task Reset();
    	i_rst_n = 0;
        repeat(5) @(negedge i_clk);
        i_rst_n = 1;
    endtask : Reset

    task send_pattern_time_out_occurr();
	    i_tx_point_sweep_test_en = 0;
	    i_rdi_msg = 0;
	    i_data_valid = 0;
	    i_msg_valid = 0;
	    i_state = SBINIT;
		i_rx_sb_pattern_samp_done = 0;
		i_ser_done = 1;
		i_start_pattern_req = 1;
    	@(negedge i_clk);
    	i_start_pattern_req = 0;
		for (int i = 0; i < 1000; i++) begin
	    	@(negedge i_clk);
		end
    endtask : send_pattern_time_out_occurr

    task send_pattern_sampled_done();
	    i_tx_point_sweep_test_en = 0;
	    i_rdi_msg = 0;
	    i_data_valid = 0;
	    i_msg_valid = 0;
	    i_state = SBINIT;
		i_rx_sb_pattern_samp_done = 0;
		i_ser_done = 1;
		i_start_pattern_req = 1;
    	@(negedge i_clk);
    	i_start_pattern_req = 0;
		for (int i = 0; i < 1000; i++) begin
			@(negedge i_clk);
	    	if (i == 100) begin
	    		i_rx_sb_pattern_samp_done = 1;
	    	end
	    	else if (i == 101) begin
	    		i_rx_sb_pattern_samp_done = 0;
	    	end
		end
    endtask : send_pattern_sampled_done



    task simulation();
    	for (int i = 1; i < 8; i++) begin
    		i_state = e_states'(i); // enter state
    		if (i_state == SBINIT) begin
    			i_msg_valid = 1;
    			i_msg_no = 3;
    			msg_union.sbinit_msg = sideband_messages_sbinit'(i_msg_no);
    			@(negedge i_clk);
    			//i_msg_valid = 0;
    			repeat (7) @(negedge i_clk);
    			i_msg_valid = 1;
    			i_msg_no = 1;
    			msg_union.sbinit_msg = sideband_messages_sbinit'(i_msg_no);
    			@(negedge i_clk);
    			//i_msg_valid = 0;
    			repeat (7) @(negedge i_clk);
    			i_msg_valid = 1;
    			i_msg_no = 2;
    			msg_union.sbinit_msg = sideband_messages_sbinit'(i_msg_no);
    			@(negedge i_clk);
    			//i_msg_valid = 0;
    			repeat (7) @(negedge i_clk);
    		end
    		else if (i_state == MBINIT) begin
    			for (int j = 0; j < 6; j++) begin
    				i_sub_state = e_sub_states_MBINIT'(j); // enter sub state
    				case (i_sub_state)
    				PARAM: begin
    					i_msg_valid = 1;
    					i_data_valid = 1;
    					i_data_bus = $random();
		    			i_msg_no = 1;
		    			msg_union.mbinit_msg = sideband_messages_mbinit_param'(i_msg_no);
		    			msg_union.sbinit_msg = sideband_messages_sbinit'(0);
		    			repeat (7) @(negedge i_clk);
		    			i_msg_valid = 0;
		    			i_data_valid = 0;
		    			@(negedge i_clk);
		    			i_msg_valid = 1;
    					i_data_valid = 1;
    					i_data_bus = $random();
		    			i_msg_no = 2;
		    			repeat (7) @(negedge i_clk);
		    			i_msg_valid = 0;
		    			i_data_valid = 0;
		    			@(negedge i_clk);
    				end 
    				CAL : begin
    					i_msg_valid = 1;
		    			i_msg_no = 1;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (7) @(negedge i_clk);
		    			i_msg_valid = 1;
		    			i_msg_no = 2;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (7) @(negedge i_clk);
    				end 
    				REPAIRCLK : begin
    					i_msg_valid = 1;
		    			i_msg_no = 1;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (7) @(negedge i_clk);
		    			i_msg_valid = 1;
		    			i_msg_no = 2;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (5) @(negedge i_clk);
		    			i_msg_valid = 1;
		    			i_msg_no = 3;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (7) @(negedge i_clk);
		    			i_msg_valid = 1;
		    			i_msg_no = 4;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (7) @(negedge i_clk);
		    			i_msg_valid = 1;
		    			i_msg_no = 5;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (7) @(negedge i_clk);
		    			i_msg_valid = 1;
		    			i_msg_no = 6;
		    			@(negedge i_clk);
		    			i_msg_valid = 0;
		    			repeat (7) @(negedge i_clk);
    				end 
    			endcase
    			end
    			
    		end
    	end
    endtask : simulation

endmodule : SB_TX_WRAPPER_TB

