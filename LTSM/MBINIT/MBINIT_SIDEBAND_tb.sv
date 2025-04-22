module MBINIT_SIDEBAND_tb;

// Clock and reset signals
bit CLK;
bit rst_n;

// Input signals for both instances
logic i_MBINIT_Start_en;

// Output signals from instance 1 to instance 2
logic Finish_MBINIT_1;

// Output signals from instance 2 to instance 1
logic Finish_MBINIT_2;

logic [3:0]  rx_msg_no_inst1, rx_msg_no_inst2;
bit   [15:0] rx_data_bus_inst1, rx_data_bus_inst2;
logic [2:0]  rx_msg_info_inst1, rx_msg_info_inst2;
logic rx_busy_inst1, rx_busy_inst2;
logic CLK_Track_done_inst1, CLK_Track_done_inst2;
logic VAL_Pattern_done_inst1, VAL_Pattern_done_inst2;
logic REVERSAL_done_inst1, REVERSAL_done_inst2;
logic [1:0] LaneID_Pattern_done_inst1, LaneID_Pattern_done_inst2;
logic Transmitter_initiated_Data_to_CLK_done_inst1, Transmitter_initiated_Data_to_CLK_done_inst2;

// Internal signals for FSM monitoring
logic [2:0] i_logged_clk_result_inst1, i_logged_clk_result_inst2;
logic i_logged_val_result_inst1, i_logged_val_result_inst2;
logic [15:0] i_logged_lane_id_result_inst1, i_logged_lane_id_result_inst2;
logic [15:0] i_Transmitter_initiated_Data_to_CLK_Result_inst1, i_Transmitter_initiated_Data_to_CLK_Result_inst2;

logic [3:0] tx_sub_state_1, tx_sub_state_2;
logic [3:0] tx_msg_no_1, tx_msg_no_2;
bit   [15:0] tx_data_bus_1, tx_data_bus_2;
logic [2:0] tx_msg_info_1, tx_msg_info_2;
logic tx_msg_valid_1, tx_msg_valid_2;
logic tx_data_valid_1, tx_data_valid_2;

// Additional signals for MBINIT instances
logic mbinit_inst1_o_MBINIT_REPAIRCLK_Pattern_En;
logic mbinit_inst1_o_MBINIT_REPAIRVAL_Pattern_En;
logic [1:0]mbinit_inst1_o_MBINIT_REVERSALMB_LaneID_Pattern_En;
logic mbinit_inst1_o_MBINIT_REVERSALMB_ApplyReversal_En;
logic [1:0]  mbinit_inst1_o_Clear_Pattern_Comparator;
logic [1:0] mbinit_inst1_o_Functional_Lanes_out_tx;
logic [1:0] mbinit_inst1_o_Functional_Lanes_out_rx;
logic mbinit_inst1_o_Transmitter_initiated_Data_to_CLK_en;
logic  mbinit_inst1_o_perlane_Transmitter_initiated_Data_to_CLK;
logic  mbinit_inst1_o_mainband_Transmitter_initiated_Data_to_CLK;
logic [2:0] mbinit_inst1_o_Final_MaxDataRate;
bit mbinit_inst1_o_train_error_req;

logic mbinit_inst2_o_MBINIT_REPAIRCLK_Pattern_En;
logic mbinit_inst2_o_MBINIT_REPAIRVAL_Pattern_En;
logic [1:0]mbinit_inst2_o_MBINIT_REVERSALMB_LaneID_Pattern_En;
logic mbinit_inst2_o_MBINIT_REVERSALMB_ApplyReversal_En;
logic [1:0] mbinit_inst2_o_Clear_Pattern_Comparator;
logic [1:0] mbinit_inst2_o_Functional_Lanes_out_tx;
logic [1:0] mbinit_inst2_o_Functional_Lanes_out_rx;
logic mbinit_inst2_o_Transmitter_initiated_Data_to_CLK_en;
logic mbinit_inst2_o_perlane_Transmitter_initiated_Data_to_CLK;
logic mbinit_inst2_o_mainband_Transmitter_initiated_Data_to_CLK;
logic [2:0] mbinit_inst2_o_Final_MaxDataRate;
bit mbinit_inst2_o_train_error_req;

    /*------------------------------------------------------------------------------
    --enums typedef for the fsm mbinit  
    ------------------------------------------------------------------------------*/
    typedef enum logic [2:0] {
        IDLE_TX        = 3'b000,
        PARAM          = 3'b001,
        CAL            = 3'b010,
        REPAIRCLK      = 3'b011,
        REPAIRVAL      = 3'b100,
        REVERSALMB     = 3'b101,
        REPAIRMB       = 3'b110,
        DONE           = 3'b111
    } e_mbinit_states;
    /*------------------------------------------------------------------------------
    --enums typedef for the PARAM  
    ------------------------------------------------------------------------------*/
    typedef enum {
        IDLE_TX_PARAM,
        PARAM_REQ,
        PARAM_HANDLE_VALID,
        PARAM_CHECK_RESP,
        // PARAM_DONE_CHECK,
        PARAM_DONE_TX
    } e_tx_param;
    typedef enum {
        IDLE_RX_PARAM,
        PARAM_CHECK_REQ,
        PARAM_CHECK_PARAMTERS,
        PARAM_CHECK_BUSY,
        PARAM_RESP,
        PARAM_DONE_RX
    } e_rx_param;
    /*------------------------------------------------------------------------------
    --enums typedef for the CAL 
    ------------------------------------------------------------------------------*/
    typedef enum {
        IDLE_TX_CAL,
        MBINIT_CAL_REQ,
        MBINIT_HANDLE_VALID,
        MBINIT_CAL_Module_DONE
    } e_tx_cal;

    typedef enum {
        IDLE_RX_CAL,
        MBINIT_CAL_Check_Req,
        MBINIT_CAL_resp,
        MBINIT_HANDLE_SENDEING,
        MBINIT_CAL_ModulePartner_DONE
    } e_rx_cal;

    /*------------------------------------------------------------------------------
    --enums typedef for the REPAIR_CLK 
    ------------------------------------------------------------------------------*/
    typedef enum {
        IDLE_tx_CLK ,
        REPAIRCLK_INIT_REQ ,
        CLKPATTERN ,
        REPAIRCLK_RESULT_REQ ,
        REPAIRCLK_CHECK_RESULT ,
        REPAIRCLK_DONE_REQ ,
        REPAIRCLK_DONE_TX ,
        REPAIRCLK_HANDLE_VALID ,
        REPAIRCLK_CHECK_BUSY_RESULT_TX ,
        REPAIRCLK_CHECK_BUSY_DONE_TX
    } e_tx_clk;

    typedef enum {
        IDLE_rx_CLK ,
        REPAIRCLK_CHECK_INIT_REQ ,
        REPAIRCLK_INIT_RESP ,
        // RAPAIRCLK_GET_COMPARE ,
        REPAIRCLK_RESULT_RESP ,
        REPAIRCLK_DONE_RESP ,
        REPAIRCLK_DONE_RX ,
        REPAIRCLK_HANDLE_VALID_RX ,
        REPAIRCLK_CHECK_BUSY_INIT ,
        REPAIRCLK_CHECK_BUSY_RESULT_RX ,
        REPAIRCLK_CHECK_BUSY_DONE_RX 
    } e_rx_clk;

    /*------------------------------------------------------------------------------
    --enums typedef for the REPAIR_CLK 
    ------------------------------------------------------------------------------*/

    typedef enum {
        IDLE_tx_VAL                         ,
        REPAIRVAL_INIT_REQ                  ,
        CLKPATTERN_VAL                      ,
        REPAIRVAL_RESULT_REQ                ,
        REPAIRVAL_CHECK_RESULT              ,
        REPAIRVAL_DONE_REQ                  ,
        REPAIRVAL_DONE_TX                   ,
        REPAIRVAL_HANDLE_VALID              ,
        REPAIRVAL_CHECK_BUSY_RESULT_TX      ,
        REPAIRVAL_CHECK_BUSY_DONE_TX       
    } e_tx_val;
    typedef enum {
        IDLE_rx_VAL ,
        REPAIRVAL_CHECK_INIT_REQ ,
        REPAIRVAL_INIT_RESP ,
        // RAPAIRCLK_GET_COMPARE ,
        REPAIRVAL_RESULT_RESP ,
        REPAIRVAL_DONE_RESP ,
        REPAIRVAL_DONE_RX ,
        REPAIRVAL_HANDLE_VALID_RX ,
        REPAIRVAL_CHECK_BUSY_INIT ,
        REPAIRVAL_CHECK_BUSY_RESULT_RX ,
        REPAIRVAL_CHECK_BUSY_DONE_RX 
    } e_rx_val;

    /*------------------------------------------------------------------------------
    --enums typedef for the REVERSAL
    ------------------------------------------------------------------------------*/

    typedef enum {
        IDLE_tx_REVERSAL,
        REVERSALMB_INIT_REQ,
        REVERSALMB_CLEAR_ERROR_REQ,
        REVERSALMB_LANEID_PATTER,
        REVERSALMB_RESULT_REQ,
        REVERSALMB_CHECK_RESULT,
        REVERSALMB_APPLY_REVERSAL,
        REVERSALMB_DONE_REQ,
        REVERSALMB_DONE_TX,
        REVERSALMB_HANDLE_VALID_TX,
        REVERSALMB_CHECK_BUSY_CLEAR_TX,
        REVERSALMB_CHECK_BUSY_RESULT_TX,
        REVERSALMB_CHECK_BUSY_DONE_TX
    } e_tx_reversal;
    typedef enum {
        IDLE_rx_REVERSAL,
        REVERSALMB_CHECK_INIT_REQ,
        REVERSALMB_CHECK_BUSY_INIT_RESP,
        REVERSALMB_INIT_RESP,
        REVERSALMB_HANDLE_VALID_RX,
        REVERSALMB_CHECK_BUSY_CLEAR_RX,
        REVERSALMB_CLEAR_ERROR_RESP,
        REVERSALMB_CHECK_BUSY_RESULT_RX,
        REVERSALMB_RESULT_RESP,
        REVERSALMB_CHECK_BUSY_DONE_RX,
        REVERSALMB_DONE_RESP,
        REVERSALMB_DONE_RX
    } e_rx_reversal;

    /*------------------------------------------------------------------------------
    --enums typedef for the REPAIR_MB
    ------------------------------------------------------------------------------*/
    typedef enum {
        IDLE_tx_REPAIR_MB ,
        REPAIRMB_START_REQ,
        REPAIRMB_HANDLE_VALID_TX,
        REPAIRMB_INITIATED_DATA_CLOCK,
        REPAIRMB_SETUP_FUNCTIONAL_LANES,
        REPAIRMB_CHECK_BUSY_DEGRADE,
        REPAIRMB_DEGRADE_REQ,
        REPAIRMB_CHECK_BUSY_END_REQ,
        REPAIRMB_END_REQ,
        REPAIRMB_DONE_TX
    } e_tx_repairmb;
    typedef enum {
        IDLE_rx_REPAIR_MB ,
        REPAIRMB_CHECK_REQ,
        REPAIRMB_CHECK_BUSY_START,
        REPAIRMB_START_RESP,
        REPAIRMB_HANDLE_VALID_RX,
        REPAIRMB_CHECK_WIDTH_DEGRADE,
        REPAIRMB_APPLY_REAPEAT,
        REPAIRMB_CHECK_BUSY_DEGRADE_RESP,
        REPAIRMB_DEGRADE_RESP,
        REPAIRMB_CHECK_BUSY_END_RESP,
        REPAIRMB_END_RESP,
        REPAIRMB_DONE_RX
    } e_rx_repairmb;


    /* ----------------------------------------------------------------
                                     for the sideband message 
    -------------------------------------------------------------------------------*/
    typedef enum {
        MBINIT_PARAM_configuration_req=1,
        MBINIT_PARAM_configuration_resp=2
    }sideband_message_param;

    typedef enum {
        MBINIT_CAL_Done_req=1,
        MBINIT_CAL_Done_resp=2
    } sideband_message_cal;

    typedef enum {
        MBINI_REPAIRCLK_init_req     = 1,
        MBINIT_REPAIRCLK_init_resp   ,
        MBINIT_REPAIRCLK_result_req  ,
        MBINIT_REPAIRCLK_result_resp ,
        MBINIT_REPAIRCLK_done_req   ,
        MBINIT_REPAIRCLK_done_resp   
    } sideband_message_clk;

    typedef enum {
        MBINI_REPAIRVAL_init_req     = 1,
        MBINIT_REPAIRVAL_init_resp   ,
        MBINIT_REPAIRVAL_result_req  ,
        MBINIT_REPAIRVAL_result_resp ,
        MBINIT_REPAIRVAL_done_req   ,
        MBINIT_REPAIRVAL_done_resp   
    } sideband_message_val;

    typedef enum {
        MBINI_REVERSALMB_init_req =1,
        MBINIT_REVERSALMB_init_resp,
        MBINIT_REVERSALMB_clear_error_req,
        MBINIT_REVERSALMB_clear_error_resp,
        MBINIT_REVERSALMB_result_req,
        MBINIT_REVERSALMB_result_resp,
        MBINIT_REVERSALMB_done_req,
        MBINIT_REVERSALMB_done_resp
    } sideband_message_reversal;

    typedef enum {
        MBINIT_REPAIRMB_start_req=1,
        MBINIT_REPAIRMB_start_resp,
        MBINIT_REPAIRMB_apply_degrade_req,
        MBINIT_REPAIRMB_apply_degrade_resp,
        MBINIT_REPAIRMB_end_req,
        MBINIT_REPAIRMB_end_resp
    } sideband_message_repairmb;


	/*------------------------------------------------------------------------------
	--  for states
	------------------------------------------------------------------------------*/
	e_mbinit_states mbinit_inst1_cs,mbinit_inst1_ns;
	e_mbinit_states mbinit_inst2_cs,mbinit_inst2_ns;
    // param
    e_tx_param      tx_param_cs_inst1,tx_param_ns_inst1;
	e_rx_param      rx_param_cs_inst1,rx_param_ns_inst1;
    e_tx_param      tx_param_cs_inst2,tx_param_ns_inst2;
	e_rx_param      rx_param_cs_inst2,rx_param_ns_inst2;

    // cal
    e_tx_cal      tx_cal_cs_inst1,tx_cal_ns_inst1;
	e_rx_cal      rx_cal_cs_inst1,rx_cal_ns_inst1;
    e_tx_cal      tx_cal_cs_inst2,tx_cal_ns_inst2;
	e_rx_cal      rx_cal_cs_inst2,rx_cal_ns_inst2;

    //clk
    e_tx_clk      tx_clk_cs_inst1,tx_clk_ns_inst1;
	e_rx_clk      rx_clk_cs_inst1,rx_clk_ns_inst1;
    e_tx_clk      tx_clk_cs_inst2,tx_clk_ns_inst2;
	e_rx_clk      rx_clk_cs_inst2,rx_clk_ns_inst2;

    // val
    e_tx_val      tx_val_cs_inst1,tx_val_ns_inst1;
	e_rx_val      rx_val_cs_inst1,rx_val_ns_inst1;
    e_tx_val      tx_val_cs_inst2,tx_val_ns_inst2;
	e_rx_val      rx_val_cs_inst2,rx_val_ns_inst2;

    // reversal
    e_tx_reversal      tx_reversal_cs_inst1,tx_reversal_ns_inst1;
	e_rx_reversal      rx_reversal_cs_inst1,rx_reversal_ns_inst1;
    e_tx_reversal      tx_reversal_cs_inst2,tx_reversal_ns_inst2;
	e_rx_reversal      rx_reversal_cs_inst2,rx_reversal_ns_inst2;

    // repairemb
    e_tx_repairmb      tx_repairmb_cs_inst1,tx_repairmb_ns_inst1;
	e_rx_repairmb      rx_repairmb_cs_inst1,rx_repairmb_ns_inst1;
    e_tx_repairmb      tx_repairmb_cs_inst2,tx_repairmb_ns_inst2;
	e_rx_repairmb      rx_repairmb_cs_inst2,rx_repairmb_ns_inst2;

	/*------------------------------------------------------------------------------
	--  for sideband_messages
	------------------------------------------------------------------------------*/

    // param
    sideband_message_param  tx_message_param_inst1,rx_message_param_inst1,tx_message_param_inst2,rx_message_param_inst2;
    // cal
    sideband_message_cal  tx_message_cal_inst1,rx_message_cal_inst1,tx_message_cal_inst2,rx_message_cal_inst2;
    //clk
    sideband_message_clk  tx_message_clk_inst1,rx_message_clk_inst1,tx_message_clk_inst2,rx_message_clk_inst2;
    // val
    sideband_message_val  tx_message_val_inst1,rx_message_val_inst1,tx_message_val_inst2,rx_message_val_inst2;
    // reversal
    sideband_message_reversal  tx_message_reversal_inst1,rx_message_reversal_inst1,tx_message_reversal_inst2,rx_message_reversal_inst2;
    // repairemb
    sideband_message_repairmb  tx_message_repairmb_inst1,rx_message_repairmb_inst1,tx_message_repairmb_inst2,rx_message_repairmb_inst2;
     /*------------------------------------------------------------------------------
	--  updating states 
	------------------------------------------------------------------------------*/
	always @(*) begin
		//MBINIT FSM
        mbinit_inst1_cs=e_mbinit_states'(mbinit_inst1.mbinit_fsm_inst.CS);
		mbinit_inst1_ns=e_mbinit_states'(mbinit_inst1.mbinit_fsm_inst.NS);
		mbinit_inst2_cs=e_mbinit_states'(mbinit_inst2.mbinit_fsm_inst.CS);
		mbinit_inst2_ns=e_mbinit_states'(mbinit_inst2.mbinit_fsm_inst.NS);
        // PARAM_FSM
        tx_param_cs_inst1=e_tx_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_Module.CS);
        tx_param_ns_inst1=e_tx_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_Module.NS);
        tx_param_cs_inst2=e_tx_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_Module.CS);
        tx_param_ns_inst2=e_tx_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_Module.NS);
        rx_param_cs_inst1=e_rx_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_ModulePartner.CS);
        rx_param_ns_inst1=e_rx_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_ModulePartner.NS);
        rx_param_cs_inst2=e_rx_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_ModulePartner.CS);
        rx_param_ns_inst2=e_rx_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_ModulePartner.NS);
        // CAL_FSM   
        tx_cal_cs_inst1=e_tx_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_inst.CS);
        tx_cal_ns_inst1=e_tx_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_inst.NS);
        tx_cal_cs_inst2=e_tx_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_inst.CS);
        tx_cal_ns_inst2=e_tx_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_inst.NS);
        rx_cal_cs_inst1=e_rx_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_partner_inst.CS);
        rx_cal_ns_inst1=e_rx_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_partner_inst.NS);
        rx_cal_cs_inst2=e_rx_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_partner_inst.CS);
        rx_cal_ns_inst2=e_rx_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_partner_inst.NS);
        //clk_FSM
        tx_clk_cs_inst1=e_tx_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u1.CS);
        tx_clk_ns_inst1=e_tx_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u1.NS);
        tx_clk_cs_inst2=e_tx_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u1.CS);
        tx_clk_ns_inst2=e_tx_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u1.NS);
        rx_clk_cs_inst1=e_rx_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u2.CS);
        rx_clk_ns_inst1=e_rx_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u2.NS);
        rx_clk_cs_inst2=e_rx_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u2.CS);
        rx_clk_ns_inst2=e_rx_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u2.NS);
        //val_FSM
        tx_val_cs_inst1=e_tx_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u1.CS);
        tx_val_ns_inst1=e_tx_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u1.NS);
        tx_val_cs_inst2=e_tx_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u1.CS);
        tx_val_ns_inst2=e_tx_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u1.NS);
        rx_val_cs_inst1=e_rx_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u2.CS);
        rx_val_ns_inst1=e_rx_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u2.NS);
        rx_val_cs_inst2=e_rx_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u2.CS);
        rx_val_ns_inst2=e_rx_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u2.NS);

        //reversal_FSM
        tx_reversal_cs_inst1=e_tx_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u1.CS);
        tx_reversal_ns_inst1=e_tx_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u1.NS);
        tx_reversal_cs_inst2=e_tx_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u1.CS);
        tx_reversal_ns_inst2=e_tx_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u1.NS);
        rx_reversal_cs_inst1=e_rx_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u2.CS);
        rx_reversal_ns_inst1=e_rx_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u2.NS);
        rx_reversal_cs_inst2=e_rx_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u2.CS);
        rx_reversal_ns_inst2=e_rx_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u2.NS);
        
        // repairemb_FSM
        tx_repairmb_cs_inst1=e_tx_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.CS);
        tx_repairmb_ns_inst1=e_tx_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.NS);
        tx_repairmb_cs_inst2=e_tx_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.CS);
        tx_repairmb_ns_inst2=e_tx_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.NS);
        rx_repairmb_cs_inst1=e_rx_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.CS);
        rx_repairmb_ns_inst1=e_rx_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.NS);
        rx_repairmb_cs_inst2=e_rx_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.CS);
        rx_repairmb_ns_inst2=e_rx_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.NS);

	/*------------------------------------------------------------------------------
	--  for sideband_messages
	------------------------------------------------------------------------------*/

        // PARAM
        tx_message_param_inst1=sideband_message_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_Module.o_TX_SbMessage);
        rx_message_param_inst1=sideband_message_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_ModulePartner.i_RX_SbMessage);
        tx_message_param_inst2=sideband_message_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_Module.o_TX_SbMessage);
        rx_message_param_inst2=sideband_message_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_ModulePartner.i_RX_SbMessage);
        // CAL   
        tx_message_cal_inst1=sideband_message_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_inst.o_TX_SbMessage);
        rx_message_cal_inst1=sideband_message_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_partner_inst.i_RX_SbMessage);
        tx_message_cal_inst2=sideband_message_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_inst.o_TX_SbMessage);
        rx_message_cal_inst2=sideband_message_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_partner_inst.i_RX_SbMessage);
        //clk
        tx_message_clk_inst1=sideband_message_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u1.o_TX_SbMessage);
        rx_message_clk_inst1=sideband_message_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u2.i_RX_SbMessage);
        tx_message_clk_inst2=sideband_message_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u1.o_TX_SbMessage);
        rx_message_clk_inst2=sideband_message_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u2.i_RX_SbMessage);
        //val
        tx_message_val_inst1=sideband_message_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u1.o_TX_SbMessage);
        rx_message_val_inst1=sideband_message_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u2.i_Rx_SbMessage);
        tx_message_val_inst2=sideband_message_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u1.o_TX_SbMessage);
        rx_message_val_inst2=sideband_message_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u2.i_Rx_SbMessage);

        //reversal

        tx_message_reversal_inst1=sideband_message_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u1.o_TX_SbMessage);
        rx_message_reversal_inst1=sideband_message_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u2.i_Rx_SbMessage);
        tx_message_reversal_inst2=sideband_message_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u1.o_TX_SbMessage);
        rx_message_reversal_inst2=sideband_message_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u2.i_Rx_SbMessage);
        
        // repairemb
        
        tx_message_repairmb_inst1=sideband_message_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.o_TX_SbMessage);
        rx_message_repairmb_inst1=sideband_message_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.i_RX_SbMessage);
        tx_message_repairmb_inst2=sideband_message_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.o_TX_SbMessage);
        rx_message_repairmb_inst2=sideband_message_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.i_RX_SbMessage);
	end


    // Clock generation
    always #5 CLK = ~CLK;  // 100MHz Clock (10ns period)
    /*------------------------------------------------------
        modiling the pattern_clk delay for 8 clock cycle
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  repair_clk_pattern_done_inst1 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_MBINIT_REPAIRCLK_Pattern_En),
        .out_signal(CLK_Track_done_inst1)
    );

    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  repair_clk_pattern_done_inst2 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_MBINIT_REPAIRCLK_Pattern_En),
        .out_signal(CLK_Track_done_inst2)
    );

    /*------------------------------------------------------
        modiling the pattern_val delay for 8 clock cycle
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  repair_val_pattern_done_inst1 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_MBINIT_REPAIRVAL_Pattern_En),
        .out_signal(VAL_Pattern_done_inst1)
    );
    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  repair_val_pattern_done_inst2 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_MBINIT_REPAIRVAL_Pattern_En),
        .out_signal(VAL_Pattern_done_inst2)
    );
    /*------------------------------------------------------
        modiling the reversal apply delay for 8 clock cycle
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  reversal_done_inst1 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_MBINIT_REVERSALMB_ApplyReversal_En),
        .out_signal(REVERSAL_done_inst1)
    );

    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  reversal_done_inst2 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst2.o_MBINIT_REVERSALMB_ApplyReversal_En),
        .out_signal(REVERSAL_done_inst2)
    );

    /*------------------------------------------------------
        modiling the pattern_perlanid_delay for 8 clock cycle
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(2)
    )  pattern_done_inst1 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .out_signal(LaneID_Pattern_done_inst1)
    );

    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(2)
    )  pattern_done_inst2 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst2.o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .out_signal(LaneID_Pattern_done_inst2)
    );


    /*------------------------------------------------------
        modiling the initiated_dat_clk for 8 clock cycle
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  initiated_data_clk_inst1 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_Transmitter_initiated_Data_to_CLK_en),
        .out_signal(Transmitter_initiated_Data_to_CLK_done_inst1)
    );

    signal_delay #(
        .DELAY_CYCLES(8),
        .SIGNAL_WIDTH(1)
    )  initiated_data_clk_inst2 (
        .clk(CLK),
        .rst_n(rst_n),
        .in_signal(mbinit_inst2.o_Transmitter_initiated_Data_to_CLK_en),
        .out_signal(Transmitter_initiated_Data_to_CLK_done_inst2)
    );


    MBINIT mbinit_inst1 (
        .CLK(CLK), .rst_n(rst_n), .i_MBINIT_Start_en(i_MBINIT_Start_en),
        .i_rx_msg_no(rx_msg_no_inst1), .i_rx_data_bus(rx_data_bus_inst1), .i_rx_msg_info(rx_msg_info_inst1),
        .i_rx_busy(rx_busy_inst1), .i_CLK_Track_done(CLK_Track_done_inst1), .i_VAL_Pattern_done(VAL_Pattern_done_inst1),
        .i_LaneID_Pattern_done(LaneID_Pattern_done_inst1[0]), .i_logged_clk_result(i_logged_clk_result_inst1),
        .i_logged_val_result(i_logged_val_result_inst1), .i_REVERSAL_done(REVERSAL_done_inst1), .i_logged_lane_id_result(i_logged_lane_id_result_inst1),
        .i_Transmitter_initiated_Data_to_CLK_done(Transmitter_initiated_Data_to_CLK_done_inst1),
        .i_Transmitter_initiated_Data_to_CLK_Result(i_Transmitter_initiated_Data_to_CLK_Result_inst1),
        .o_tx_sub_state(tx_sub_state_1), .o_tx_msg_no(tx_msg_no_1), .o_tx_data_bus(tx_data_bus_1),
        .o_tx_msg_info(tx_msg_info_1), .o_tx_msg_valid(tx_msg_valid_1), .o_tx_data_valid(tx_data_valid_1),
        .o_MBINIT_REPAIRCLK_Pattern_En(mbinit_inst1_o_MBINIT_REPAIRCLK_Pattern_En), .o_MBINIT_REPAIRVAL_Pattern_En(mbinit_inst1_o_MBINIT_REPAIRVAL_Pattern_En), 
        .o_MBINIT_REVERSALMB_LaneID_Pattern_En(mbinit_inst1_o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .o_MBINIT_REVERSALMB_ApplyReversal_En(mbinit_inst1_o_MBINIT_REVERSALMB_ApplyReversal_En), .o_Clear_Pattern_Comparator(mbinit_inst1_o_Clear_Pattern_Comparator), 
        .o_Functional_Lanes_out_tx(mbinit_inst1_o_Functional_Lanes_out_tx),
        .o_Functional_Lanes_out_rx(mbinit_inst1_o_Functional_Lanes_out_rx), .o_Transmitter_initiated_Data_to_CLK_en(mbinit_inst1_o_Transmitter_initiated_Data_to_CLK_en), 
        .o_perlane_Transmitter_initiated_Data_to_CLK(mbinit_inst1_o_perlane_Transmitter_initiated_Data_to_CLK),
        .o_mainband_Transmitter_initiated_Data_to_CLK(mbinit_inst1_o_mainband_Transmitter_initiated_Data_to_CLK), .o_Final_MaxDataRate(mbinit_inst1_o_Final_MaxDataRate), 
        .o_train_error_req(mbinit_inst1_o_train_error_req), .o_Finish_MBINIT(Finish_MBINIT_1)
    );

    MBINIT mbinit_inst2 (
        .CLK(CLK), .rst_n(rst_n), .i_MBINIT_Start_en(i_MBINIT_Start_en), // Trigger based on MBINIT completion
        .i_rx_msg_no(rx_msg_no_inst2), .i_rx_data_bus(rx_data_bus_inst2), .i_rx_msg_info(rx_msg_info_inst2),
        .i_rx_busy(rx_busy_inst2), .i_CLK_Track_done(CLK_Track_done_inst2), .i_VAL_Pattern_done(VAL_Pattern_done_inst2),
        .i_LaneID_Pattern_done(LaneID_Pattern_done_inst2[0]), .i_logged_clk_result(i_logged_clk_result_inst2),
        .i_logged_val_result(i_logged_val_result_inst2), .i_REVERSAL_done(REVERSAL_done_inst2), .i_logged_lane_id_result(i_logged_lane_id_result_inst2),
        .i_Transmitter_initiated_Data_to_CLK_done(Transmitter_initiated_Data_to_CLK_done_inst2),
        .i_Transmitter_initiated_Data_to_CLK_Result(i_Transmitter_initiated_Data_to_CLK_Result_inst2),
        .o_tx_sub_state(tx_sub_state_2), .o_tx_msg_no(tx_msg_no_2), .o_tx_data_bus(tx_data_bus_2),
        .o_tx_msg_info(tx_msg_info_2), .o_tx_msg_valid(tx_msg_valid_2), .o_tx_data_valid(tx_data_valid_2),
        .o_MBINIT_REPAIRCLK_Pattern_En(mbinit_inst2_o_MBINIT_REPAIRCLK_Pattern_En), .o_MBINIT_REPAIRVAL_Pattern_En(mbinit_inst2_o_MBINIT_REPAIRVAL_Pattern_En), 
        .o_MBINIT_REVERSALMB_LaneID_Pattern_En(mbinit_inst2_o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .o_MBINIT_REVERSALMB_ApplyReversal_En(mbinit_inst2_o_MBINIT_REVERSALMB_ApplyReversal_En), .o_Clear_Pattern_Comparator(mbinit_inst2_o_Clear_Pattern_Comparator), 
        .o_Functional_Lanes_out_tx(mbinit_inst2_o_Functional_Lanes_out_tx),
        .o_Functional_Lanes_out_rx(mbinit_inst2_o_Functional_Lanes_out_rx), .o_Transmitter_initiated_Data_to_CLK_en(mbinit_inst2_o_Transmitter_initiated_Data_to_CLK_en), 
        .o_perlane_Transmitter_initiated_Data_to_CLK(mbinit_inst2_o_perlane_Transmitter_initiated_Data_to_CLK),
        .o_mainband_Transmitter_initiated_Data_to_CLK(mbinit_inst2_o_mainband_Transmitter_initiated_Data_to_CLK), .o_Final_MaxDataRate(mbinit_inst2_o_Final_MaxDataRate), 
        .o_train_error_req(mbinit_inst2_o_train_error_req), .o_Finish_MBINIT(Finish_MBINIT_2)
    );

    // Testbench Logic
initial begin
    // Initialize Signals
    // Reset sequence
    i_MBINIT_Start_en=0;
    #20 rst_n = 1;
    #20 rst_n = 0;
    #20 rst_n = 1;
    i_MBINIT_Start_en=1;
    i_logged_clk_result_inst1=3'b111;
    i_logged_clk_result_inst2=3'b111;
    i_logged_val_result_inst1=1'b1;
    i_logged_val_result_inst2=1'b1;
    i_logged_lane_id_result_inst1='1;
    i_logged_lane_id_result_inst2='1;
    i_Transmitter_initiated_Data_to_CLK_Result_inst1=16'b00011101_11111111;
    i_Transmitter_initiated_Data_to_CLK_Result_inst2=16'b00011101_11111111;
    #3650;
    i_MBINIT_Start_en=0;

    $stop;
end



    // // Monitor FSM state and set done_result
    // always @(posedge CLK or negedge rst_n ) begin
    //     case (mbinit_inst1_cs)
    //         REPAIRCLK: begin
    //             i_logged_clk_result_inst1=3'b111;
    //         end
    //         REPAIRVAL: begin
    //             i_logged_val_result_inst1=1'b1;
    //         end
    //         REVERSALMB: begin
    //             i_logged_lane_id_result_inst1='1;
    //         end
    //         REPAIRMB: begin
    //             i_Transmitter_initiated_Data_to_CLK_Result_inst1=16'b00011101_11111111;
    //         end
    //     endcase
    // end

    // // Monitor FSM state and set done_result
    // always @(posedge CLK or negedge rst_n ) begin
    //     case (mbinit_inst2_cs)
    //         REPAIRCLK: begin
    //             i_logged_clk_result_inst2=3'b111;
    //         end
    //         REPAIRVAL: begin
    //             i_logged_val_result_inst2=1'b1;
    //         end
    //         REVERSALMB: begin
    //             i_logged_lane_id_result_inst2='1;
    //         end
    //         REPAIRMB: begin
    //             i_Transmitter_initiated_Data_to_CLK_Result_inst2=16'b00011101_11111111;
    //         end
    //     endcase
    // end
    // DUT Instantiations (Back-to-Back Connection)
endmodule
