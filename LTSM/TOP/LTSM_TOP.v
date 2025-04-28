module LTSM_TOP (
    /*************************************************************************
    * INPUTS
    *************************************************************************/
    input                                        i_clk,
    input                                        i_rst_n,
    // RDI related signals 
    input                                        i_start_training_RDI, /////////// the logic that set this flag is not impelmented yet !!! ////////////// 
    input                                        i_go_to_phyretrain_ACTIVE,  /////////// the logic that set this flag is not impelmented yet !!! ////////////// (from RDI logic when adapter wants to make retrain)
    input                                        i_lp_linkerror, // from adapter to phy to make the link go down (be in trainerror state)
    input                                        i_LINKINIT_DONE, /////////// the logic that set this flag is not impelmented yet !!! ////////////// 
    input                                        i_ACTIVE_DONE,   /////////// the logic that set this flag is not impelmented yet !!! ////////////// 
    // Sideband related signals
    input                                        i_SB_fifo_empty,      // from sideband to let us know that there is no more data to be transmitted
    input                                        i_start_pattern_done, // from SB means that the SBINIT pattern has sent and received successfully without timeout
    input                                        i_start_training_SB,  // from SB means that the remote partner starts sending SBINIT pattern to start communication
    input                                        i_time_out, //  from SB means that timeout occur and we must go to TRAINERROR
    input                                        i_busy,     // from SB means that it is processing on the data on the bus and this data should not be changed 
    input                                        i_rx_msg_valid,
    input       [3:0]                            i_decoded_SB_msg, // gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 
    input       [2:0]                            i_rx_msg_info,    // from SB containing SB message info
    input       [15:0]                           i_rx_data_bus,    // from SB containing SB message data
    // tx iniated data 2 clock point test related signals
    input                                        i_Transmitter_initiated_Data_to_CLK_done,   // from tx initiated after done test
    input       [15:0]                           i_Transmitter_initiated_Data_to_CLK_Result, // Results from tx initiated 
    input                                        i_Transmitter_initiated_Data_to_CLK_valid_result,
    input                                        i_Receiver_initiated_Data_to_CLK_done,      // from rx initiated after done test
    input       [15:0]                           i_Receiver_initiated_Data_to_CLK_Result,    // Results from rx initiated  
    // clock pattern generator related signals 
    input                                        i_CLK_Track_done,
    input       [2:0]                            i_logged_clk_result,   // i_Clock_track_result_logged from comparator after detection clk pattern
    // valid pattern generator related signals
    input                                        i_VAL_Pattern_done,
    input                                        i_logged_val_result,   // i_VAL_Result_logged from comparator after detection val pattern
    // data pattern generator related signals 
    input                                        i_pattern_generation_done, // means that patterns are succefully sent 
    // data pattern comparator related signals
    input       [15:0]                           i_comparsion_results, // 16 bit to indicate each lane status (per-lane)
    input                                        i_aggregate_error_found, // means that errors exceed thershold
    // DVSEC register related signals
    input                                        i_start_training_DVSEC, // bit [10] "start UCIe link training" of DVSEC register 
    // block mghool el hawya 
    input                                        i_valid_framing_error, /////////// the logic that set this flag is not impelmented yet !!! //////////////

    input                                        i_REVERSAL_done,
    /*************************************************************************
    * OUTPUTS
    *************************************************************************/
    output    reg   [3:0]                       o_reciever_ref_volatge,
    output                                      o_falling_edge_busy,
    // RDI related signals
    output    reg                               o_pl_trainerror,
    // Mapper / Demapper ... generator / comparator related signals (WIDTH DEGRADATION)
    output    reg   [1:0]                       o_functional_tx_lanes, // 0h: IDLE, 1h: work on least 8 lanes, 2h: work on Most 8 lanes, 3h: work on all 16 lanes
    output    reg   [1:0]                       o_functional_rx_lanes, // 0h: IDLE, 1h: work on least 8 lanes, 2h: work on Most 8 lanes, 3h: work on all 16 lanes
    output                                      o_mapper_demapper_en,
    // tx iniated data 2 clock point test related signals
    output    reg                               o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK, // (to be muxed) between MBINIT & MBTRAIN
    output    reg                               o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK,      // (to be muxed) between MBINIT & MBTRAIN
    output    reg                               o_Transmitter_initiated_Data_to_CLK_en,                   // (to be muxed) between MBINIT & MBTRAIN
    // rx iniated data 2 clock point test related signals
    output                                      o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK,
    output                                      o_MBTRAIN_Receiver_initiated_Data_to_CLK_en,
    // eye width sweep block related signals
    output                                      o_MBTRAIN_tx_eye_width_sweep_en,
    output                                      o_MBTRAIN_rx_eye_width_sweep_en,
    // clock pattern generator related signals 
    output                                      o_MBINIT_REPAIRCLK_Pattern_En,
    output                                      o_MBINIT_Final_ClockMode,
    output                                      o_MBINIT_Final_ClockPhase,
    output                                      o_MBINIT_clear_clk_detection,
    // valid pattern generator related signals 
    output                                      o_MBINIT_REPAIRVAL_Pattern_En,           // (to be muxed with rx D2C pt block "o_val_pattern_en" output)
    output                                      o_MBINIT_enable_cons, // for valid detection
    // data pattern generator related signals
    output      [1:0]                           o_MBINIT_mainband_pattern_generator_cw,  // (to be muxed with rx & tx D2C pt blocks)
    // data pattern comparator related signals
    output      [1:0]                           o_MBINIT_mainband_pattern_comparator_cw, // (to be muxed with rx & tx D2C pt blocks)
    // reversing lanes block related signals 
    output                                      o_MBINIT_REVERSALMB_ApplyReversal_En,
    // Sideband related signals
    output                                      o_start_pattern_req, // to SB to start SBINIT pattern generation
    output         [3:0]                        o_tx_state,          // LTSM state indication
    output   reg   [3:0]                        o_tx_sub_state,      // LTSM substates indication (muxed between MBINIT & MBTRAIN)
    output   reg   [3:0]                        o_encoded_SB_msg,    // sent to SB 34an 22olo haystkhdm anhy encoding (to be muxed)
    output   reg   [2:0]                        o_tx_msg_info,       // (to be muxed) 
    output         [15:0]                       o_tx_data_bus,     
    output   reg                                o_tx_msg_valid,      // (to be muxed)
    output                                      o_tx_data_valid,     // (to be muxed)
    output                                      o_tx_rdi_msg_en,
    output                                      o_MBTRAIN_timeout_disable,
    output          [2:0]                       o_curret_operating_speed 
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////

localparam SB_MSG_WIDTH = 4;
localparam COUNT_4ms    = 4;    // should be changed depending on the operating frequncey
localparam COUNT_8ms    = 200000;   // should be changed depending on the operating frequncey

reg [3:0]  CS, NS;        // Current State, Next State	
reg [18:0] reset_counter; // lesa mumken el width ytghyyr  
reg [18:0] timeout_counter; // lesa mumken el width ytghyyr  
reg  state_timeout; // this flag is set if we stayed in a state more than 8ms except in (reset,active,L1/L2,Trainerror)
reg  start_reset_counter; // when traning triggers occur, start counting
reg  clear_resolved_state; // to PHYRETRAIN so that it reset the o_resolved_state when the LTSM goes back to RESET state 
wire falling_edge_busy;
reg go_to_speedidle; // from LTSM to MBTRAIN.speedidle upon exit from L1 state

/**************************************************
* MBINIT Internal signals
**************************************************/
wire        go_to_trainerror_MBINIT;
wire [1:0]  MBINIT_tx_Functional_Lanes_out;
wire [1:0]  MBINIT_rx_Functional_Lanes_out;
wire        MBINIT_Transmitter_initiated_Data_to_CLK_en;
wire        MBINIT_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK;
wire        MBINIT_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK;
wire [3:0]  MBINIT_Vref; // will be driven in PARAM state after receiving partner TX voltage swing
wire [2:0]  MBINIT_highest_common_speed;
wire [1:0]  MBINIT_REVERSALMB_LaneID_Pattern_En;

/**************************************************
* MBTRAIN Internal signals
**************************************************/
wire        go_to_phyretrain_MBTRAIN; 
wire [1:0]  MBTRAIN_tx_Functional_Lanes_out;
wire [1:0]  MBTRAIN_rx_Functional_Lanes_out;
wire        MBTRAIN_Transmitter_initiated_Data_to_CLK_en;
wire        MBTRAIN_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK;
wire        MBTRAIN_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK;
wire [3:0]  MBTRAIN_Vref;

/**************************************************
* PHYRETRAIN Internal signals
**************************************************/
wire [1:0]  phyretrain_resolved_state;  // after phyretrain we transition to this resolved state 
wire [1:0]  linkspeed_lanes_status;     // shared between PHYRETRAIN and MBTRAIN.LINKSPEED
reg  enter_from_active_or_mbtrain;      // will be given to phyretrain to indicate either we entered from active state or MBTRAIN.LINKSPEED state
/*--------------------
* Blocks Enables
--------------------*/
reg     SBINIT_EN;
reg     MBINIT_EN;
reg     MBTRAIN_EN;
reg     TRAINERROR_EN;
reg     PHYRETRAIN_EN;
reg     LINKMGMT_RETRAIN_EN;
/*--------------------
* Blocks Enables ACKs
--------------------*/
wire     SBINIT_DONE;
wire     MBINIT_DONE;
wire     MBTRAIN_DONE;
wire     TRAINERROR_DONE;
wire     PHYRETRAIN_DONE;
wire     LINKMGMT_RETRAIN_DONE;

/********************************************
* SIGNALS FOR MUXING
********************************************/
/*--------------------
* SB msg number
--------------------*/
wire     [3:0]       encoded_SB_msg_SBINIT;
wire     [3:0]       encoded_SB_msg_MBINIT;
wire     [3:0]       encoded_SB_msg_MBTRAIN;
wire     [3:0]       encoded_SB_msg_TRAINERROR;
wire     [3:0]       encoded_SB_msg_PHYRETRAIN;

/*-------------------
* o_tx_msg_valid
*------------------*/
wire     msg_valid_SBINIT;
wire     msg_valid_MBINIT;
wire     msg_valid_MBTRAIN;
wire     msg_valid_TRAINERROR;
wire     msg_valid_PHYRETRAIN;

/*-------------------
* o_tx_msg_info
*------------------*/
wire     [2:0] msg_info_MBINIT;
wire     [2:0] msg_info_MBTRAIN;
wire     [2:0] msg_info_PHYRETRAIN;

/*-------------------
* o_tx_sub_state
*------------------*/
wire      [3:0]    sub_state_MBINIT;
wire      [3:0]    sub_state_MBTRAIN;

// registered verison from MBINIT & MBTRAIN substates used in monitoring state timeout
reg      [3:0]    reg_sub_state_MBINIT;
reg      [3:0]    reg_sub_state_MBTRAIN;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// INSTANTIATIONS ////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****************************************
* SBINIT
****************************************/
SBINIT_WRAPPER #(SB_MSG_WIDTH) SBINIT_inst (
    .i_clk                      (i_clk),
	.i_rst_n                    (i_rst_n),
	.i_SBINIT_en			    (SBINIT_EN),
	.i_start_pattern_done	    (i_start_pattern_done),
    .i_rx_msg_valid             (i_rx_msg_valid),
    .i_SB_Busy                  (i_busy),
    .i_falling_edge_busy        (falling_edge_busy),
	.i_decoded_SB_msg           (i_decoded_SB_msg),
	.o_start_pattern_req        (o_start_pattern_req),
	.o_encoded_SB_msg           (encoded_SB_msg_SBINIT),
    .o_tx_msg_valid             (msg_valid_SBINIT),
	.o_SBINIT_end       	    (SBINIT_DONE)
);

/****************************************
* MBINIT
****************************************/
MBINIT MBINIT_inst (
    .CLK                                          (i_clk),
    .rst_n                                        (i_rst_n),
    .i_MBINIT_Start_en                            (MBINIT_EN),
    .i_rx_msg_info                                (i_rx_msg_info),
    .i_rx_data_bus                                (i_rx_data_bus),
    .i_rx_msg_no                                  (i_decoded_SB_msg),
    .i_msg_valid                                  (i_rx_msg_valid),
    .i_REVERSAL_done                              (i_REVERSAL_done),
    .i_rx_busy                                    (i_busy),
    .i_falling_edge_busy                          (falling_edge_busy),
    .i_CLK_Track_done                             (i_CLK_Track_done),
    .i_VAL_Pattern_done                           (i_VAL_Pattern_done),
    .i_LaneID_Pattern_done                        (i_pattern_generation_done),
    .i_logged_clk_result                          (i_logged_clk_result),
    .i_logged_val_result                          (i_logged_val_result),
    .i_logged_lane_id_result                      (i_comparsion_results),
    .i_Transmitter_initiated_Data_to_CLK_done     (i_Transmitter_initiated_Data_to_CLK_done),
    .i_Transmitter_initiated_Data_to_CLK_Result   (i_Transmitter_initiated_Data_to_CLK_Result),
    .o_tx_sub_state                               (sub_state_MBINIT),
    .o_tx_msg_no                                  (encoded_SB_msg_MBINIT),
    .o_tx_data_bus                                (o_tx_data_bus),
    .o_tx_msg_info                                (msg_info_MBINIT),
    .o_tx_msg_valid                               (msg_valid_MBINIT),
    .o_tx_data_valid                              (o_tx_data_valid),
    .o_MBINIT_REPAIRCLK_Pattern_En                (o_MBINIT_REPAIRCLK_Pattern_En),
    .o_MBINIT_REPAIRVAL_Pattern_En                (o_MBINIT_REPAIRVAL_Pattern_En),
    .o_MBINIT_REVERSALMB_ApplyReversal_En         (o_MBINIT_REVERSALMB_ApplyReversal_En),
    .o_MBINIT_REVERSALMB_LaneID_Pattern_En        (o_MBINIT_mainband_pattern_generator_cw),
    .o_Clear_Pattern_Comparator                   (o_MBINIT_mainband_pattern_comparator_cw),
    .o_Functional_Lanes_out_tx                    (MBINIT_tx_Functional_Lanes_out),
    .o_Functional_Lanes_out_rx                    (MBINIT_rx_Functional_Lanes_out),
    .o_Transmitter_initiated_Data_to_CLK_en       (MBINIT_Transmitter_initiated_Data_to_CLK_en),
    .o_mainband_Transmitter_initiated_Data_to_CLK (MBINIT_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK), 
    .o_perlane_Transmitter_initiated_Data_to_CLK  (MBINIT_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK), 
    .o_Final_MaxDataRate                          (MBINIT_highest_common_speed),
    .o_Final_ClockMode                            (o_MBINIT_Final_ClockMode), 
    .o_Final_ClockPhase                           (o_MBINIT_Final_ClockPhase),
    .o_train_error_req                            (go_to_trainerror_MBINIT),
    .o_enable_cons                                (o_MBINIT_enable_cons), 
    .o_clear_clk_detection                        (o_MBINIT_clear_clk_detection),
    .o_Finish_MBINIT                              (MBINIT_DONE)
);
/****************************************
* MBTRAIN
****************************************/
mbtrain_wrapper MBTRAIN_inst (
    .clk                                        (i_clk),                      
    .rst_n                                      (i_rst_n),                    
    .i_en                                       (MBTRAIN_EN),                     
    .i_sideband_message                         (i_decoded_SB_msg),  
    .i_sideband_data                            (i_rx_data_bus),    
    .i_sideband_data_lanes_encoding             (i_rx_msg_info),          
    .i_busy                                     (i_busy),      
    .i_falling_edge_busy                        (falling_edge_busy),
    .i_sideband_valid                           (i_rx_msg_valid),
    .i_tx_point_test_ack                        (i_Transmitter_initiated_Data_to_CLK_done),  
    .i_rx_point_test_ack                        (i_Receiver_initiated_Data_to_CLK_done),    
    .i_tx_lanes_result                          (i_Transmitter_initiated_Data_to_CLK_Result), 
    .i_tx_valid_result                          (i_Transmitter_initiated_Data_to_CLK_valid_result),
    .i_rx_lanes_result                          (i_Receiver_initiated_Data_to_CLK_Result),  
    .i_valid_framing_error                      (i_valid_framing_error),   
    .i_phyretrain_resolved_state                (phyretrain_resolved_state),
    .i_coming_from_L1                           (go_to_speedidle),
    .i_highest_common_speed                     (MBINIT_highest_common_speed),
    .i_first_8_tx_lanes_are_functional_mbinit   (MBINIT_tx_Functional_Lanes_out[0]),
    .i_second_8_tx_lanes_are_functional_mbinit  (MBINIT_tx_Functional_Lanes_out[1]),
    .i_first_8_rx_lanes_are_functional_mbinit   (MBINIT_rx_Functional_Lanes_out[0]),
    .i_second_8_rx_lanes_are_functional_mbinit  (MBINIT_rx_Functional_Lanes_out[1]),
    .i_reciever_ref_voltage                     (o_reciever_ref_volatge),
    .o_sideband_substate                        (sub_state_MBTRAIN),     
    .o_sideband_message                         (encoded_SB_msg_MBTRAIN),       
    .o_sideband_data_lanes_encoding             (msg_info_MBTRAIN),              
    .o_timeout_disable                          (o_MBTRAIN_timeout_disable),        
    .o_valid                                    (msg_valid_MBTRAIN),                  
    .o_reciever_ref_voltage                     (MBTRAIN_Vref),   
    .o_tx_mainband_or_valtrain_test             (MBTRAIN_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK), 
    .o_rx_mainband_or_valtrain_test             (o_MBTRAIN_mainband_or_valtrain_Receiver_initiated_Data_to_CLK), 
    .o_tx_lfsr_or_perlane                       (MBTRAIN_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK),   
    .o_tx_pt_en                                 (MBTRAIN_Transmitter_initiated_Data_to_CLK_en),  
    .o_rx_pt_en                                 (o_MBTRAIN_Receiver_initiated_Data_to_CLK_en),        
    .o_tx_eye_width_sweep_en                    (o_MBTRAIN_tx_eye_width_sweep_en),   
    .o_rx_eye_width_sweep_en                    (o_MBTRAIN_rx_eye_width_sweep_en),   
    .o_phyretrain_error_encoding                (linkspeed_lanes_status), 
    .o_phyretrain_en                            (go_to_phyretrain_MBTRAIN),
    .o_first_8_tx_lanes_are_functional          (MBTRAIN_tx_Functional_Lanes_out[0]),
    .o_second_8_tx_lanes_are_functional         (MBTRAIN_tx_Functional_Lanes_out[1]),
    .o_first_8_rx_lanes_are_functional          (MBTRAIN_rx_Functional_Lanes_out[0]),
    .o_second_8_rx_lanes_are_functional         (MBTRAIN_rx_Functional_Lanes_out[1]),
    .o_curret_operating_speed                   (o_curret_operating_speed),
    .o_mbtrain_ack                              (MBTRAIN_DONE)             
);

/****************************************
* TRAINERROR
****************************************/
TRAINERROR_HS_WRAPPER #(SB_MSG_WIDTH) TRAINERROR_inst (
	.i_clk                      (i_clk),
	.i_rst_n                    (i_rst_n),
	.i_trainerror_en            (TRAINERROR_EN),
    .i_rx_msg_valid             (i_rx_msg_valid),
    .i_SB_Busy                  (i_busy),
    .i_falling_edge_busy        (falling_edge_busy),
	.i_decoded_SB_msg           (i_decoded_SB_msg),
	.o_encoded_SB_msg           (encoded_SB_msg_TRAINERROR),
    .o_tx_msg_valid             (msg_valid_TRAINERROR),
	.o_TRAINERROR_HS_end        (TRAINERROR_DONE)
);

/****************************************
* PHYRETRAIN
****************************************/
PHYRETRAIN_WRAPPER #(SB_MSG_WIDTH) PHYRETRAIN_inst (
	.i_clk                              (i_clk),
	.i_rst_n                            (i_rst_n),
	.i_phyretrain_en                    (PHYRETRAIN_EN),
    .i_enter_from_active_or_mbtrain     (enter_from_active_or_mbtrain),
    .i_linkspeed_lanes_status           (linkspeed_lanes_status),
    .i_clear_resolved_state             (clear_resolved_state),
    .i_SB_Busy                          (i_busy),
    .i_falling_edge_busy                (falling_edge_busy),
    .i_rx_msg_info                      (i_rx_msg_info),
    .i_decoded_SB_msg                   (i_decoded_SB_msg),
    .i_rx_msg_valid                     (i_rx_msg_valid),
    .o_encoded_SB_msg                   (encoded_SB_msg_PHYRETRAIN),
    .o_tx_msg_valid                     (msg_valid_PHYRETRAIN),
    .o_tx_msg_info                      (msg_info_PHYRETRAIN),
    .o_resolved_state                   (phyretrain_resolved_state),
	.o_PHYRETRAIN_end                   (PHYRETRAIN_DONE)
);

/****************************************
* NEGEDGE BUSY DETECTOR
****************************************/
nedege_detector negedge_busy_detect (
    .clk                        (i_clk),
    .rst_n                      (i_rst_n),
    .i_busy                     (i_busy),
    .o_busy_negedge_detected    (falling_edge_busy)
);


/////////////////////////////////////////
//////////// Machine STATES /////////////
/////////////////////////////////////////

localparam RESET 	            = 0;
localparam FINISH_RESET         = 1;
localparam SBINIT 		 		= 2;
localparam MBINIT				= 3;
localparam MBTRAIN              = 4;
localparam LINKINIT             = 5;
localparam ACTIVE               = 6;
localparam TRAINERROR_HS        = 7;
localparam TRAINERROR           = 8;
localparam LINKMGMT_RETRAIN     = 9;
localparam PHYRETRAIN           = 10;
localparam L1_L2                = 11;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////
assign o_tx_state = CS;
assign o_mapper_demapper_en = (CS == ACTIVE)? 1:0;
wire counter_reset_flag     = (reset_counter == COUNT_4ms+1)? 1:0;
wire trainerror_condition   = (i_time_out || i_decoded_SB_msg == 15 || i_start_training_DVSEC || state_timeout || i_lp_linkerror); // if (i_time_out) --> module iniates trainerror, if (i_decoded_SB_msg == 14) --> partner iniates trainerror, if bit [10] on DVSEC is set in any state rather than reset go to trainerror
wire reset_state_timeout_counter  = (CS == RESET || CS == FINISH_RESET || CS == ACTIVE || CS == L1_L2 || CS == TRAINERROR || CS == TRAINERROR_HS || CS != NS); // reset the counter if state is transitioning (CS!=NS) or if we are in the stated states dont count
assign o_falling_edge_busy = falling_edge_busy;

/////////////////////////////////
///// RESET COUNTER (4 ms) //////
/////////////////////////////////
always @ (posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        reset_counter <= 0;
    end else if (counter_reset_flag) begin
        reset_counter <= 0;
    end else if (start_reset_counter) begin // this condition is used to prevent the counter from counting in other states to save power, just count when training is triggered
        reset_counter <= reset_counter + 1;
    end 
end

////////////////////////////////////////
//// STATE TIMEOUT COUNTER (8 ms) //////
////////////////////////////////////////
always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        timeout_counter <= 0;
    end else if (reset_state_timeout_counter) begin 
        timeout_counter <= 0;
    end else if (CS == MBINIT) begin
        if (reg_sub_state_MBINIT == sub_state_MBINIT) begin
            timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 0;
        end
    end else if (CS == MBTRAIN) begin
        if (reg_sub_state_MBTRAIN == sub_state_MBTRAIN) begin
            timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 0;
        end        
    end
    else if (CS == NS) begin
        timeout_counter <= timeout_counter + 1;
    end
end

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        state_timeout   <= 0;
        reg_sub_state_MBINIT  <= 0;
        reg_sub_state_MBTRAIN <= 0;        
    end else begin
        reg_sub_state_MBINIT  <= sub_state_MBINIT;
        reg_sub_state_MBTRAIN <= sub_state_MBTRAIN;
        state_timeout <= (timeout_counter == COUNT_8ms)? 1:0;
    end 
end
/////////////////////////////////
//////// State Memory ///////////
/////////////////////////////////
always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        CS <= RESET;
    end
    else begin
        CS <= NS;
    end
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// NEXT STATE LOGIC //////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @ (*) begin
	case (CS) 
/*-----------------------------------------------------------------------------
* RESET
*-----------------------------------------------------------------------------*/
        RESET: begin
            if (i_start_training_RDI || i_start_training_SB || i_start_training_DVSEC) begin
                NS = FINISH_RESET;
            end else begin
                NS = RESET;
            end
        end
/*-----------------------------------------------------------------------------
* FINISH_RESET
*-----------------------------------------------------------------------------*/
        FINISH_RESET: begin
            if (reset_counter == COUNT_4ms) begin
                NS = SBINIT;
            end else begin
                NS = FINISH_RESET;
            end
        end
/*-----------------------------------------------------------------------------
* SBINIT
*-----------------------------------------------------------------------------*/
        SBINIT: begin
            if (trainerror_condition) begin 
                NS = TRAINERROR_HS;
            end else begin
                if (SBINIT_DONE) begin
                    NS = MBINIT;
                end else begin
                    NS = SBINIT;
                end   
            end   
        end 
/*-----------------------------------------------------------------------------
* MBINIT
*-----------------------------------------------------------------------------*/
        MBINIT: begin
            if (go_to_trainerror_MBINIT || trainerror_condition) begin 
                NS = TRAINERROR_HS;
            end else begin
                if (MBINIT_DONE) begin
                    NS = MBTRAIN;
                end else begin
                    NS = MBINIT;
                end
            end            
        end
/*-----------------------------------------------------------------------------
* MBTRAIN
*-----------------------------------------------------------------------------*/
        MBTRAIN: begin
            if (trainerror_condition) begin 
                NS = TRAINERROR_HS;
            end else begin
                if (go_to_phyretrain_MBTRAIN) begin
                    NS = PHYRETRAIN;
                end else if (MBTRAIN_DONE) begin
                    NS = LINKINIT;
                end else begin
                    NS = MBTRAIN;
                end
            end            
        end
/*-----------------------------------------------------------------------------
* LINKINIT
*-----------------------------------------------------------------------------*/
        LINKINIT: begin
            if (trainerror_condition) begin 
                NS = TRAINERROR_HS;
            end else if (i_LINKINIT_DONE) begin ///////// lesa msh 3arf el condition dh is set based 3ala eh bas ghalbn related bl RDI ????????? ////////////////
                NS = ACTIVE;
            end else begin
                NS = LINKINIT;
            end           
        end
/*-----------------------------------------------------------------------------
* ACTIVE
*-----------------------------------------------------------------------------*/
        ACTIVE: begin
            if (i_start_training_DVSEC) begin
                NS = TRAINERROR_HS;
            end else if (i_valid_framing_error || i_go_to_phyretrain_ACTIVE || i_decoded_SB_msg == 1) begin // (i_valid_framing_error) --> PHY iniated PHYRETRAIN ,(i_go_to_phyretrain_ACTIVE) --> Adapter iniated PHYRETRAIN
                NS = PHYRETRAIN; // should be LINKMGMT_RETRAIN                                     // (i_decoded_SB_msg == 1) --> linkmgmt.RDI.Retrain.Req .. Remote partner iniated retrain
            end else if (i_ACTIVE_DONE) begin ///////// lesa msh 3arf el condition dh is set based 3ala eh bas ghalbn related bl RDI ????????? ////////////////
                NS = RESET;
            end else begin
                NS = ACTIVE;
            end
        end
/*-----------------------------------------------------------------------------
* TRAINERROR_HS
*-----------------------------------------------------------------------------*/
        TRAINERROR_HS: begin
            if (i_time_out || TRAINERROR_DONE) begin // if timeout occurs during trainerror handshake we should go to trainerror state
                NS = TRAINERROR;
            end else begin
                NS = TRAINERROR_HS;
            end   
        end
/*-----------------------------------------------------------------------------
* TRAINERROR
*-----------------------------------------------------------------------------*/
        TRAINERROR: begin
            if (!i_lp_linkerror && i_SB_fifo_empty) begin // go to reset if 1- No SB packets to be transmitted 2- When lp_linkerror is low    
                NS = RESET;
            end else begin
                NS = TRAINERROR;
            end      
        end
/*-----------------------------------------------------------------------------
* LINKMGMT_RETRAIN
*-----------------------------------------------------------------------------*/
        LINKMGMT_RETRAIN: begin
            if (trainerror_condition) begin 
                NS = TRAINERROR_HS;
            end else begin
                if (LINKMGMT_RETRAIN_DONE) begin
                    NS = PHYRETRAIN;
                end else begin
                    NS = LINKMGMT_RETRAIN;
                end
            end              
        end
/*-----------------------------------------------------------------------------
* PHYRETRAIN
*-----------------------------------------------------------------------------*/
        PHYRETRAIN: begin
            if (trainerror_condition) begin 
                NS = TRAINERROR_HS;
            end else begin
                if (PHYRETRAIN_DONE) begin
                    NS = MBTRAIN;
                end else begin
                    NS = PHYRETRAIN;
                end
            end            
        end
/*-----------------------------------------------------------------------------
* L1/L2
*-----------------------------------------------------------------------------*/
        // L1_L2: begin
            
        // end
        default: NS = RESET;
    endcase
end 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////// OUTPUT LOGIC //////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @ (posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
        start_reset_counter <= 0;
        enter_from_active_or_mbtrain <= 0;
        SBINIT_EN       <= 0;
        MBINIT_EN       <= 0;
        MBTRAIN_EN      <= 0;
        TRAINERROR_EN   <= 0;
        PHYRETRAIN_EN   <= 0;
        o_pl_trainerror <= 0;
        go_to_speedidle <= 0;
        clear_resolved_state   <= 0;
    end else begin
        SBINIT_EN       <= 0;
        MBINIT_EN       <= 0;
        MBTRAIN_EN      <= 0;
        TRAINERROR_EN   <= 0;
        PHYRETRAIN_EN   <= 0;
        o_pl_trainerror <= 0;
        case (CS)
        /*-----------------------------------------------------------------------------
        * SBINIT
        *-----------------------------------------------------------------------------*/
            SBINIT: begin
                SBINIT_EN <= 1;
            end 
        /*-----------------------------------------------------------------------------
        * MBINIT
        *-----------------------------------------------------------------------------*/
            MBINIT: begin
                MBINIT_EN <= 1;
            end
        /*-----------------------------------------------------------------------------
        * MBTRAIN
        *-----------------------------------------------------------------------------*/
            MBTRAIN: begin
                MBTRAIN_EN <= 1;      
            end
        /*-----------------------------------------------------------------------------
        * LINKINIT
        *-----------------------------------------------------------------------------*/

        /*-----------------------------------------------------------------------------
        * ACTIVE
        *-----------------------------------------------------------------------------*/

        /*-----------------------------------------------------------------------------
        * TRAINERROR_HS
        *-----------------------------------------------------------------------------*/
            TRAINERROR_HS: begin
                TRAINERROR_EN <= 1;
                o_pl_trainerror <= 1;
            end
        /*-----------------------------------------------------------------------------
        * TRAINERROR
        *-----------------------------------------------------------------------------*/
            TRAINERROR: begin
                o_pl_trainerror <= 1;
            end
        /*-----------------------------------------------------------------------------
        * PHYRETRAIN
        *-----------------------------------------------------------------------------*/
            PHYRETRAIN: begin
                PHYRETRAIN_EN <= 1;         
            end
        /*-----------------------------------------------------------------------------
        * DEFAULT
        *-----------------------------------------------------------------------------*/        
            default: begin
                SBINIT_EN       <= 0;
                MBINIT_EN       <= 0;
                MBTRAIN_EN      <= 0;
                TRAINERROR_EN   <= 0;
                PHYRETRAIN_EN   <= 0;
                o_pl_trainerror <= 0;
            end
        endcase
        /*-----------------------------------------------------------------------
        * Reset counter related logic
        -----------------------------------------------------------------------*/
        if (i_start_training_RDI || i_start_training_SB || i_start_training_DVSEC)
            start_reset_counter <= 1;
        else if (reset_counter == COUNT_4ms+1) 
            start_reset_counter <= 0;
        
        /*-----------------------------------------------------------------------
        * PHYRETRAIN related logic
        -----------------------------------------------------------------------*/
        if (go_to_phyretrain_MBTRAIN) begin
            enter_from_active_or_mbtrain <= 1; // PHYRETRAIN entered from MBTRAIN.LINKSPEED
        end else if (CS == ACTIVE && NS == PHYRETRAIN) begin
            enter_from_active_or_mbtrain <= 0; // PHYRETRAIN entered from ACTIVE
        end
        clear_resolved_state <= (NS == RESET)? 1:0; // because this resolved state goes to MBTRAIN block to go to either TXSELFCAL , SPEEDIDLE , REPAIR or start
        // from first state VALVREF as normal so, resolved state register should be cleared each time traning starts from the begining
        /*-----------------------------------------------------------------------
        * L1 -> MBTRAIN.SPEEDIDLE related logic
        -----------------------------------------------------------------------*/
        if (CS == L1_L2 && NS == MBTRAIN) begin
            go_to_speedidle <= 1;
        end else if (MBTRAIN_DONE) begin
            go_to_speedidle <= 0;
        end
    end
end 

/*--------------------------------------------------------
 * Vref control word logic (same register for both states)
--------------------------------------------------------*/
always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        o_reciever_ref_volatge <= 0;
    end else begin
        if (CS == MBINIT) begin
            o_reciever_ref_volatge <= MBINIT_Vref;
        end else if (CS == MBTRAIN) begin
            o_reciever_ref_volatge <= MBTRAIN_Vref;
        end
    end
end

    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////// MUXING //////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*---------------------------------------
* encoded sideband message muxing
---------------------------------------*/
always @ (*) begin
    case (CS)
        SBINIT: begin
            o_encoded_SB_msg = encoded_SB_msg_SBINIT;
        end
        MBINIT: begin
            o_encoded_SB_msg = encoded_SB_msg_MBINIT;
        end
        MBTRAIN: begin
            o_encoded_SB_msg = encoded_SB_msg_MBTRAIN;
        end
        TRAINERROR_HS: begin
            o_encoded_SB_msg = encoded_SB_msg_TRAINERROR;
        end
        PHYRETRAIN: begin
            o_encoded_SB_msg = encoded_SB_msg_PHYRETRAIN;
        end
        default: o_encoded_SB_msg = 4'b0000;
    endcase
end

/*---------------------------------------
* sideband message info muxing
---------------------------------------*/
always @ (*) begin
    case (CS)
        MBINIT: begin
            o_tx_msg_info = msg_info_MBINIT;
        end
        MBTRAIN: begin
            o_tx_msg_info = msg_info_MBTRAIN;
        end
        PHYRETRAIN: begin
            o_tx_msg_info = msg_info_PHYRETRAIN;
        end
        default: o_tx_msg_info = 3'b000;
    endcase
end

/*---------------------------------------
* sideband message valid muxing
---------------------------------------*/
always @ (*) begin
    case (CS)
        SBINIT: begin
            o_tx_msg_valid = msg_valid_SBINIT;
        end
        MBINIT: begin
            o_tx_msg_valid = msg_valid_MBINIT;
        end
        MBTRAIN: begin
            o_tx_msg_valid = msg_valid_MBTRAIN;
        end
        TRAINERROR_HS: begin
            o_tx_msg_valid = msg_valid_TRAINERROR;
        end
        PHYRETRAIN: begin
            o_tx_msg_valid = msg_valid_PHYRETRAIN;
        end
        default: o_tx_msg_valid = 1'b0;
    endcase
end

/*---------------------------------------
* o_tx_sub_state muxing
---------------------------------------*/
always @ (*) begin
    case (CS)
        MBINIT: begin
            o_tx_sub_state = sub_state_MBINIT;
        end
        MBTRAIN: begin
            o_tx_sub_state = sub_state_MBTRAIN;
        end
        default: o_tx_sub_state = 0;
    endcase
end

/*---------------------------------------
* o_functional_tx_lanes and rx_lanes
---------------------------------------*/
always @ (*) begin
    case (CS)
        MBINIT: begin
            o_functional_tx_lanes = MBINIT_tx_Functional_Lanes_out;
        end
        MBTRAIN: begin
            o_functional_tx_lanes = MBTRAIN_tx_Functional_Lanes_out; 
        end
        default: o_functional_tx_lanes = 2'b11;
    endcase
end

always @ (*) begin
    case (CS)
        MBINIT: begin
            o_functional_rx_lanes = MBINIT_rx_Functional_Lanes_out;
        end
        MBTRAIN: begin
            o_functional_rx_lanes = MBTRAIN_rx_Functional_Lanes_out; 
        end
        default: o_functional_rx_lanes = 2'b11;
    endcase
end

/*---------------------------------------
* tx iniated D2C point test signals
---------------------------------------*/
always @ (*) begin
    case (CS)
        MBINIT: begin
            o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK = MBINIT_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK;
            o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK      = MBINIT_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK;
            o_Transmitter_initiated_Data_to_CLK_en                   = MBINIT_Transmitter_initiated_Data_to_CLK_en;
        end
        MBTRAIN: begin
            o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK = MBTRAIN_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK;
            o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK      = MBTRAIN_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK;
            o_Transmitter_initiated_Data_to_CLK_en                   = MBTRAIN_Transmitter_initiated_Data_to_CLK_en;
        end
        default: begin
            o_mainband_or_valtrain_Transmitter_initiated_Data_to_CLK = 0;
            o_lfsr_or_perlane_Transmitter_initiated_Data_to_CLK      = 0;
            o_Transmitter_initiated_Data_to_CLK_en                   = 0;          
        end
    endcase
end



endmodule 