module MBINIT (
    input               CLK,
    input               rst_n,
    input               i_MBINIT_Start_en,
    input [3:0]         i_rx_msg_no,     // i_RX_SbMessage
    input [15:0]        i_rx_data_bus,
    input [2:0]         i_rx_msg_info,
    input               i_rx_busy,
    input               i_falling_edge_busy,
    input               i_msg_valid,
    input               i_REVERSAL_done, // from the block which prepare the reversal 
    input               i_CLK_Track_done,
    input               i_VAL_Pattern_done,
    input               i_LaneID_Pattern_done,              //from REVERSALMB_Wrapper
    input   [2:0]       i_logged_clk_result,                // i_Clock_track_result_logged from comparator after detection clk pattern
    input               i_logged_val_result,                // i_VAL_Result_logged from comparator after detection val pattern
    input   [15:0]      i_logged_lane_id_result,            // i_REVERSAL_Result_logged from comparator after detection reversal pattern
    input               i_Transmitter_initiated_Data_to_CLK_done, // from tx initiated after done test
    input   [15:0]      i_Transmitter_initiated_Data_to_CLK_Result, // from tx initiated after done test
    output  [3:0]       o_tx_sub_state,                   // FSM state
    output  [3:0]       o_tx_msg_no,                     // o_TX_SbMessage
    output  [15:0]      o_tx_data_bus,                  // data field parameters (param) , 16 bits for results of the lanes (reversalmb)
    output  [2:0]       o_tx_msg_info,                 // repair clk(results for clkn ,clkp,track) , repair val ,repair mb (functional lanes)
    output              o_tx_msg_valid,               // valid msg_no
    output              o_tx_data_valid,
    output              o_MBINIT_REPAIRCLK_Pattern_En, // send to the CLK_PATTERN_GENERATOR to send clk pattern
    output              o_MBINIT_REPAIRVAL_Pattern_En , // send to the VAL_PATTERN_GENERATOR to send val pattern
    output  [1:0]       o_MBINIT_REVERSALMB_LaneID_Pattern_En, // send to the REVERSALMB to send lane id pattern
    output              o_MBINIT_REVERSALMB_ApplyReversal_En, // send to the REVERSALMB to apply reversal pattern
    output  [1:0]       o_Clear_Pattern_Comparator, // clear the comparator
    output  [1:0]       o_Functional_Lanes_out_tx, 
    output  [1:0]       o_Functional_Lanes_out_rx,
    output              o_Transmitter_initiated_Data_to_CLK_en,
    output              o_perlane_Transmitter_initiated_Data_to_CLK, // send to the point test
    output              o_mainband_Transmitter_initiated_Data_to_CLK, // send to the point test
    output [2:0]        o_Final_MaxDataRate, //For MBTRAIN 
    output              o_Final_ClockMode,
    output              o_Final_ClockPhase,
    output              o_train_error_req,
    output              o_enable_cons, //for ashour valid detection
    output              o_clear_clk_detection,// for clk_detection to clear its result for detect another one
    output              o_Finish_MBINIT
);

    wire o_tx_msg_valid_param;
    wire o_tx_msg_valid_CAL;
    wire o_tx_msg_valid_REPAIRCLK;
    wire o_tx_msg_valid_REPAIRVAL;
    wire o_tx_msg_valid_REVERSALMB;
    wire o_tx_msg_valid_REPAIRMB;
    wire o_train_error_req_reversalmb;

    wire [2:0] o_tx_msg_info_repairclk;
    wire  o_tx_msg_info_repairval;
    wire [2:0] o_tx_msg_info_repairmb;
    wire [2:0] o_msg_info_repairmb;


    wire MBINIT_PARAM_Module_end;
    wire MBINIT_CAL_Module_end;
    wire MBINIT_REPAIRCLK_Module_end;
    wire MBINIT_REPAIRVAL_Module_end;
    wire MBINIT_REVERSALMB_Module_end;
    wire MBINIT_REPAIRMB_Module_end;
    
    // REPAIRMB
    wire [1:0] Functional_Lanes_out_tx;
    wire [1:0] Functional_Lanes_out_rx;

    wire param_start;
    wire cal_start;
    wire repairclk_start;
    wire repairval_start;
    wire reversalmb_start;
    wire repairmb_start;

    wire [3:0]o_tx_msg_no_param;
    wire [3:0]o_tx_msg_no_cal;
    wire [3:0]o_tx_msg_no_repairclk;
    wire [3:0]o_tx_msg_no_repairval;
    wire [3:0]o_tx_msg_no_reversalmb;
    wire [3:0]o_tx_msg_no_repairmb;

    wire [9:0] o_tx_data_bus_param;
    wire [15:0] o_tx_data_bus_reversalmb;
    wire o_tx_data_valid_param;
    wire o_tx_data_valid_reversalmb;

    wire [2:0] i_MaxDataRate;
    wire [4:0] i_TX_VoltageSwing;
    wire i_RX_ClockMode,i_RX_PhaseClock;

    wire train_error_req_param;
    wire train_error_req_repairclk;
    wire train_error_req_repairval;
    wire train_error_req_repairmb;

    ////////////////////////////////////////////////
    // Instantiate MBINIT_FSM
    ////////////////////////////////////////////////
    MBINIT_FSM mbinit_fsm_inst (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_MBINIT_Start_en(i_MBINIT_Start_en),
        .i_PARAM_end(MBINIT_PARAM_Module_end),
        .i_CAL_end(MBINIT_CAL_Module_end),
        .i_REPAIRCLK_end(MBINIT_REPAIRCLK_Module_end),
        .i_REPAIRVAL_end(MBINIT_REPAIRVAL_Module_end),
        .i_REVERSALMB_end(MBINIT_REVERSALMB_Module_end),
        .i_REPAIRMB_end(MBINIT_REPAIRMB_Module_end),
        .o_PARAM_start(param_start),
        .o_CAL_start(cal_start),
        .o_REPAIRCLK_start(repairclk_start),
        .o_REPAIRVAL_start(repairval_start),
        .o_REVERSALMB_start(reversalmb_start),
        .o_REPAIRMB_start(repairmb_start),
        .o_Finish_MBINIT(o_Finish_MBINIT)
    );

    ////////////////////////////////////////////////
    // Instantiate PARAM_Wrapper
    ////////////////////////////////////////////////
    PARAM_Wrapper PARAM_Wrapper_inst (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_MBINIT_Start_en(param_start),
        .i_RX_SbMessage(i_rx_msg_no),
        // .i_Busy_SideBand(i_rx_busy),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_MaxDataRate(i_MaxDataRate),
        .i_TX_VoltageSwing(i_TX_VoltageSwing),
        .i_RX_ClockMode(i_RX_ClockMode),
        .i_RX_PhaseClock(i_RX_PhaseClock),
        .i_msg_valid(i_msg_valid),

        .o_MaxDataRate(o_tx_data_bus_param[2:0]),
        .o_TX_VoltageSwing(o_tx_data_bus_param[7:3]),
        .o_TX_ClockMode(o_tx_data_bus_param[8]),
        .o_TX_PhaseClock(o_tx_data_bus_param[9]),
        .o_MBINIT_PARAM_end(MBINIT_PARAM_Module_end),
        .o_ValidOutDatat_Module(o_tx_msg_valid_param), // valid msg_no
        .o_ValidDataFieldParameters(o_tx_data_valid_param),
        .o_train_error_req(train_error_req_param),
        .o_TX_SbMessage(o_tx_msg_no_param),
        .o_Final_MaxDataRate(o_Final_MaxDataRate),
        .o_Final_ClockMode(o_Final_ClockMode),
        .o_Final_ClockPhase(o_Final_ClockPhase)
    );

    ////////////////////////////////////////////////
    // Instantiate CAL_ModuleWrapper
    ////////////////////////////////////////////////
    CAL_ModuleWrapper CAL_ModuleWrapper_inst (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_MBINIT_PARAM_end(cal_start),
        .i_RX_SbMessage(i_rx_msg_no),
        .i_msg_valid(i_msg_valid),
        // .i_Busy_SideBand(i_rx_busy),
        .i_falling_edge_busy(i_falling_edge_busy),

        .o_TX_SbMessage(o_tx_msg_no_cal),
        .o_MBINIT_CAL_end(MBINIT_CAL_Module_end),
        .o_ValidOutDatatCAL(o_tx_msg_valid_CAL)
    );

    ////////////////////////////////////////////////
    // Instantiate REPAIRCLK_Wrapper
    ////////////////////////////////////////////////
    RepairCLK_Wrapper RepairCLK_Wrapper_inst (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_MBINIT_CAL_end(repairclk_start),
        .i_CLK_Track_done(i_CLK_Track_done),
        .i_Rx_SbMessage(i_rx_msg_no),
        .i_msg_valid(i_msg_valid),
        // .i_Busy_SideBand(i_rx_busy),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_Clock_track_result_logged_RXSB(i_rx_msg_info), //from sideband
        .i_Clock_track_result_logged_COMB(3'b111), //from comparator i_logged_clk_result
        .o_train_error_req(train_error_req_repairclk),
        .o_MBINIT_REPAIRCLK_Pattern_En(o_MBINIT_REPAIRCLK_Pattern_En),
        .o_MBINIT_REPAIRCLK_end(MBINIT_REPAIRCLK_Module_end),
        .o_Clock_track_result_logged(o_tx_msg_info_repairclk),
        .o_TX_SbMessage(o_tx_msg_no_repairclk),
        .o_clear_clk_detection(o_clear_clk_detection),
        .o_ValidOutDatatREPAIRCLK(o_tx_msg_valid_REPAIRCLK)
    );

    ////////////////////////////////////////////////
    // Instantiate REPAIRVAL_Wrapper
    ////////////////////////////////////////////////

    REPAIRVAL_Wrapper REPAIRVAL_Wrapper_inst (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_REPAIRCLK_end(repairval_start),
        .i_VAL_Pattern_done(i_VAL_Pattern_done),
        .i_Rx_SbMessage(i_rx_msg_no),
        .i_msg_valid(i_msg_valid),
        // .i_Busy_SideBand(i_rx_busy),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_VAL_Result_logged_RXSB(i_rx_msg_info[0]),
        .i_VAL_Result_logged_COMB(i_logged_val_result),
        .o_train_error_req(train_error_req_repairval),
        .o_MBINIT_REPAIRVAL_Pattern_En(o_MBINIT_REPAIRVAL_Pattern_En),
        .o_MBINIT_REPAIRVAL_end(MBINIT_REPAIRVAL_Module_end),
        .o_TX_SbMessage(o_tx_msg_no_repairval),
        .o_VAL_Result_logged(o_tx_msg_info_repairval),
        .o_ValidOutDatatREPAIRVAL(o_tx_msg_valid_REPAIRVAL),
        .o_enable_cons(o_enable_cons)
    );

    ////////////////////////////////////////////////
    // Instantiate REVERSALMB_Wrapper       
    ////////////////////////////////////////////////
    REVERSALMB_Wrapper REVERSALMB_Wrapper_inst (
        .CLK(CLK),
        .rst_n(rst_n),
        .i_REPAIRVAL_end(reversalmb_start),
        .i_Rx_SbMessage(i_rx_msg_no),   
        // .i_Busy_SideBand(i_rx_busy),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_REVERSAL_done(i_REVERSAL_done),
        .i_msg_valid(i_msg_valid),
        .i_LaneID_Pattern_done(i_LaneID_Pattern_done),
        .i_REVERSAL_Result_logged_RXSB(i_rx_data_bus),
        .i_REVERSAL_Result_logged_COMB(i_logged_lane_id_result),        
        .o_MBINIT_REVERSALMB_LaneID_Pattern_En(o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .o_MBINIT_REVERSALMB_ApplyReversal_En(o_MBINIT_REVERSALMB_ApplyReversal_En),
        .o_MBINIT_REVERSALMB_end(MBINIT_REVERSALMB_Module_end),
        .o_TX_SbMessage(o_tx_msg_no_reversalmb),
        .o_Clear_Pattern_Comparator(o_Clear_Pattern_Comparator),
        .o_REVERSAL_Pattern_Result_logged(o_tx_data_bus_reversalmb),
        .o_ValidOutDatatREVERSALMB(o_tx_msg_valid_REVERSALMB),
        .o_ValidDataFieldParameters(o_tx_data_valid_reversalmb),
        .o_train_error_req_reversalmb(o_train_error_req_reversalmb)
    );


    ////////////////////////////////////////////////
    // Instantiate REPAIRMB_Wrapper     
    ////////////////////////////////////////////////
    REPAIRMB_Wrapper REPAIRMB_Wrapper_inst (
        .CLK(CLK),
        .rst_n(rst_n),
        .MBINIT_REVERSALMB_end(repairmb_start),
        .i_RX_SbMessage(i_rx_msg_no),
        .i_msg_valid(i_msg_valid),
        // .i_Busy_SideBand(i_rx_busy),
        .i_falling_edge_busy(i_falling_edge_busy),
        .i_Transmitter_initiated_Data_to_CLK_done(i_Transmitter_initiated_Data_to_CLK_done),
        .i_Transmitter_initiated_Data_to_CLK_Result(i_Transmitter_initiated_Data_to_CLK_Result),
        .i_Functional_Lanes(i_rx_msg_info[1:0]),
        .o_TX_SbMessage(o_tx_msg_no_repairmb),
        .o_MBINIT_REPAIRMB_end(MBINIT_REPAIRMB_Module_end),
        .o_ValidOutDatat_REPAIRMB(o_tx_msg_valid_REPAIRMB),
        .o_Functional_Lanes_out_tx(Functional_Lanes_out_tx),
        .o_Functional_Lanes_out_rx(Functional_Lanes_out_rx),
        .o_Transmitter_initiated_Data_to_CLK_en(o_Transmitter_initiated_Data_to_CLK_en),
        .o_perlane_Transmitter_initiated_Data_to_CLK(o_perlane_Transmitter_initiated_Data_to_CLK),
        .o_mainband_Transmitter_initiated_Data_to_CLK(o_mainband_Transmitter_initiated_Data_to_CLK),
        .o_train_error(train_error_req_repairmb),
        .o_msg_info_repairmb(o_msg_info_repairmb)
    );

    assign i_MaxDataRate=i_rx_data_bus [2:0];
    assign i_TX_VoltageSwing = i_rx_data_bus[7:3];
    assign i_RX_ClockMode =i_rx_data_bus[8];
    assign i_RX_PhaseClock=i_rx_data_bus[9];


    assign o_tx_msg_no = (param_start) ? o_tx_msg_no_param :
                         (cal_start) ? o_tx_msg_no_cal :
                         (repairclk_start) ? o_tx_msg_no_repairclk :
                         (repairval_start) ? o_tx_msg_no_repairval :
                         (reversalmb_start) ? o_tx_msg_no_reversalmb :
                         (repairmb_start) ? o_tx_msg_no_repairmb : 4'b0000;

    assign o_tx_data_bus = (param_start) ? {{6{1'b0}},o_tx_data_bus_param[9:0]} :
                           (reversalmb_start) ? o_tx_data_bus_reversalmb : 16'b0;


    assign o_tx_msg_info = (param_start) ? 3'b000 :
                            (repairclk_start) ? o_tx_msg_info_repairclk :
                            (repairval_start) ? {2'b00 ,o_tx_msg_info_repairval} : o_msg_info_repairmb ;
   
    assign o_tx_msg_info_repairmb={1'b0,Functional_Lanes_out_tx};
    
    assign o_tx_sub_state = (param_start) ? 4'b0000 :
                            (cal_start) ? 4'b0001 :
                            (repairclk_start) ? 4'b0010 :
                            (repairval_start) ? 4'b0011 :
                            (reversalmb_start) ? 4'b0100 :
                            (repairmb_start) ? 4'b0101 : 4'b0000;

    assign o_Functional_Lanes_out_tx =Functional_Lanes_out_tx;

    assign o_Functional_Lanes_out_rx =Functional_Lanes_out_rx;

    assign o_tx_msg_valid = (o_tx_msg_valid_param || o_tx_msg_valid_CAL || o_tx_msg_valid_REPAIRCLK || o_tx_msg_valid_REPAIRVAL || o_tx_msg_valid_REVERSALMB || o_tx_msg_valid_REPAIRMB);//FOR 4 BITS MSG NO
    assign o_tx_data_valid = (o_tx_data_valid_param || o_tx_data_valid_reversalmb); //FOR 16 BITS DATA FIELD PARAMETERS
    assign o_train_error_req =(train_error_req_repairclk||train_error_req_repairmb||train_error_req_repairval || train_error_req_param||o_train_error_req_reversalmb); //

    // Registered outputs
    // // Combinational logic for output signals
    // wire [3:0] tx_msg_no_comb;
    // wire [15:0] tx_data_bus_comb;
    // wire [2:0] tx_msg_info_comb;
    // wire [3:0] tx_sub_state_comb;
    // wire tx_msg_valid_comb;
    // wire tx_data_valid_comb;
    // wire tx_msg_info_valid_comb;

    // assign tx_msg_no_comb = (param_start) ? o_tx_msg_no_param :
    //                         (cal_start) ? o_tx_msg_no_cal :
    //                         (repairclk_start) ? o_tx_msg_no_repairclk :
    //                         (repairval_start) ? o_tx_msg_no_repairval :
    //                         (reversalmb_start) ? o_tx_msg_no_reversalmb :
    //                         (repairmb_start) ? o_tx_msg_no_repairmb : 4'b0000;

    // assign tx_data_bus_comb = (param_start) ? o_tx_data_bus_param :
    //                           (reversalmb_start) ? o_tx_data_bus_reversalmb : 16'b0;

    // assign tx_msg_info_comb = (param_start) ? 3'b000 :
    //                           (repairclk_start) ? o_tx_msg_info_repairclk :
    //                           (repairval_start) ? o_tx_msg_info_repairval :
    //                           (repairmb_start) ? o_tx_msg_info_repairmb : 3'b000;

    // assign tx_sub_state_comb = (param_start) ? 4'b0001 :
    //                            (cal_start) ? 4'b0010 :
    //                            (repairclk_start) ? 4'b0011 :
    //                            (repairval_start) ? 4'b0100 :
    //                            (reversalmb_start) ? 4'b0101 :
    //                            (repairmb_start) ? 4'b0110 : 4'b0000;

    // assign tx_msg_valid_comb = (o_tx_msg_valid_param || o_tx_msg_valid_CAL || o_tx_msg_valid_REPAIRCLK || o_tx_msg_valid_REPAIRVAL || o_tx_msg_valid_REVERSALMB || o_tx_msg_valid_REPAIRMB);
    // assign tx_data_valid_comb = (o_tx_data_valid_param || o_tx_data_valid_reversalmb);
    // assign tx_msg_info_valid_comb = (o_tx_msg_info_valid_repairclk || o_tx_msg_info_valid_repairval || o_tx_msg_info_valid_repairmb);

    // // Registered outputs
    // always @(posedge CLK or negedge rst_n) begin
    //     if (!rst_n) begin
    //         o_tx_msg_no <= 4'b0000;
    //         o_tx_data_bus <= 16'b0;
    //         o_tx_msg_info <= 3'b000;
    //         o_tx_sub_state <= 4'b0000;
    //         o_tx_msg_valid <= 1'b0;
    //         o_tx_data_valid <= 1'b0;
    //         o_tx_msg_info_valid <= 1'b0;
    //     end else begin
    //         o_tx_msg_no <= tx_msg_no_comb;
    //         o_tx_data_bus <= tx_data_bus_comb;
    //         o_tx_msg_info <= tx_msg_info_comb;
    //         o_tx_sub_state <= tx_sub_state_comb;
    //         o_tx_msg_valid <= tx_msg_valid_comb;
    //         o_tx_data_valid <= tx_data_valid_comb;
    //         o_tx_msg_info_valid <= tx_msg_info_valid_comb;
    //     end
    // end





endmodule //MBINIT