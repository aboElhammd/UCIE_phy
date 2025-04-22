module wrapper_to_wrapper_tb;

// Clock and reset signals
logic CLK1,CLK2;
bit rst_n;

// Input signals for both instances
logic i_MBINIT_Start_en;

// Output signals from instance 1 to instance 2
logic Finish_MBINIT_1;

// Output signals from instance 2 to instance 1
logic Finish_MBINIT_2;

logic [3:0]  rx_msg_no_inst1, rx_msg_no_inst2;
logic i_msg_valid_2,i_msg_valid_1;
bit   [15:0] rx_data_bus_inst1, rx_data_bus_inst2;
logic [2:0]  rx_msg_info_inst1, rx_msg_info_inst2;
logic rx_busy_inst1, rx_busy_inst2;
logic CLK_Track_done_inst1, CLK_Track_done_inst2;
logic VAL_Pattern_done_inst1, VAL_Pattern_done_inst2;
logic REVERSAL_done_inst1, REVERSAL_done_inst2;
logic LaneID_Pattern_done_inst1, LaneID_Pattern_done_inst2;
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
logic [15:0] rx_data_final_bus_inst1;



// Internal signals
string i_rx_msg_no_string_1,i_rx_msg_no_string_2;
string o_tx_msg_no_string_1,o_tx_msg_no_string_2;

logic o_Final_ClockMode_2,o_Final_ClockMode_1;
logic o_Final_ClockPhase_2,o_Final_ClockPhase_1;

logic o_enable_cons_inst1,o_enable_cons_inst2;

logic o_clear_clk_detection_inst1,o_clear_clk_detection_inst2;
logic [1:0] i_state_tx_for_ashour_inst1,i_state_tx_for_ashour_inst2;
logic [1:0] i_state_rx_for_ashour_inst1,i_state_rx_for_ashour_inst2;

logic o_Lfsr_tx_done_inst1,o_Lfsr_tx_done_inst2;
logic [15:0] o_per_lane_error_inst1,o_per_lane_error_inst2;


    // Clock generation
    always #1 CLK1 = ~CLK1;  // 100MHz Clock (10ns period)
    always #1 CLK2 = ~CLK2;  // 100MHz Clock (10ns period)

    /*------------------------------------------------------
        the delayed tx_msg_no => represent the output from module 1 send to module 2 as input rx message
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(4)
    ) rx_message_no_inst2(
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_tx_msg_no),
        .out_signal(rx_msg_no_inst2)
    );

    /*------------------------------------------------------
        message_valid
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(4)
    ) rx_message_valid_inst2(
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.i_msg_valid),
        .out_signal(i_msg_valid_2)
    );

    /*------------------------------------------------------
        the delayed tx_msg_no => represent the output from module 2 send to module 1 as input rx message
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(4)
    )  rx_message_no_inst1 (
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst2.o_tx_msg_no),
        .out_signal(rx_msg_no_inst1)
    );

    /*------------------------------------------------------
        message_valid_to inst1
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(4)
    ) rx_message_valid_inst1(
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst2.i_msg_valid),
        .out_signal(i_msg_valid_1)
    );

    /*------------------------------------------------------
        the delayed tx_data_bus => represent the output data from module 1 send to module 2 as input rx data_bus come from side band
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(16)
    )  rx_data_inst2  (
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_tx_data_bus),
        .out_signal(rx_data_bus_inst2)
    );

    /*------------------------------------------------------
        the delayed tx_data_bus => represent the output data from module 1 send to module 2 as input rx data_bus come from side band
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(16)
    )  rx_data_inst1 (
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst2.o_tx_data_bus),
        .out_signal(rx_data_bus_inst1)
    );

    /*------------------------------------------------------
        the delayed tx_msg_info (repair_clk_result,repair_val_result,function_lanes from _repair_mb)=> represent the results from module 1 send to module 2 as input rx message
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(3)
    )  rx_message_info_inst2  (
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst1.o_tx_msg_info),
        .out_signal(rx_msg_info_inst2)
    );

    /*------------------------------------------------------
        the delayed tx_msg_info (repair_clk_result,repair_val_result,function_lanes from _repair_mb)=> represent the results from module 2 send to module 1 as input rx message
    -------------------------------------------------*/
    signal_delay #(
        .DELAY_CYCLES(6),
        .SIGNAL_WIDTH(3)
    )  rx_message_info_inst1  (
        .clk(CLK1),
        .rst_n(rst_n),
        .in_signal(mbinit_inst2.o_tx_msg_info),
        .out_signal(rx_msg_info_inst1)
    );

    /*------------------------------------------------------
        busy signal is go ti high for 6 clk cycle when valid go to high 
    -------------------------------------------------*/

    valid_busy_control busy_inst1 (
        .clk(CLK1),
        .rst_n(rst_n),
        .valid(mbinit_inst1.o_tx_msg_valid),
        .busy(rx_busy_inst1)
    );

    valid_busy_control busy_inst2 (
        .clk(CLK1),
        .rst_n(rst_n),
        .valid(mbinit_inst2.o_tx_msg_valid),
        .busy(rx_busy_inst2)
    );

    // /*------------------------------------------------------
    //     modiling the pattern_clk delay for 8 clock cycle
    // -------------------------------------------------*/
    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  repair_clk_pattern_done_inst1 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst1.o_MBINIT_REPAIRCLK_Pattern_En),
    //     .out_signal(CLK_Track_done_inst1)
    // );

    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  repair_clk_pattern_done_inst2 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst1.o_MBINIT_REPAIRCLK_Pattern_En),
    //     .out_signal(CLK_Track_done_inst2)
    // );

    // /*------------------------------------------------------
    //     modiling the pattern_val delay for 8 clock cycle
    // -------------------------------------------------*/
    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  repair_val_pattern_done_inst1 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst1.o_MBINIT_REPAIRVAL_Pattern_En),
    //     .out_signal(VAL_Pattern_done_inst1)
    // );
    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  repair_val_pattern_done_inst2 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst1.o_MBINIT_REPAIRVAL_Pattern_En),
    //     .out_signal(VAL_Pattern_done_inst2)
    // );

    // /*------------------------------------------------------
    //     modiling the reversal apply delay for 8 clock cycle
    // -------------------------------------------------*/
    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  reversal_done_inst1 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst1.o_MBINIT_REVERSALMB_ApplyReversal_En),
    //     .out_signal(REVERSAL_done_inst1)
    // );

    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  reversal_done_inst2 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst2.o_MBINIT_REVERSALMB_ApplyReversal_En),
    //     .out_signal(REVERSAL_done_inst2)
    // );

    // /*------------------------------------------------------
    //     modiling the pattern_perlanid_delay for 8 clock cycle
    // -------------------------------------------------*/
    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(2)
    // )  pattern_done_inst1 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst1.o_MBINIT_REVERSALMB_LaneID_Pattern_En),
    //     .out_signal(LaneID_Pattern_done_inst1)
    // );

    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(2)
    // )  pattern_done_inst2 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst2.o_MBINIT_REVERSALMB_LaneID_Pattern_En),
    //     .out_signal(LaneID_Pattern_done_inst2)
    // );


    // /*------------------------------------------------------
    //     modiling the initiated_dat_clk for 8 clock cycle
    // -------------------------------------------------*/
    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  initiated_data_clk_inst1 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst1.o_Transmitter_initiated_Data_to_CLK_en),
    //     .out_signal(Transmitter_initiated_Data_to_CLK_done_inst1)
    // );

    // signal_delay #(
    //     .DELAY_CYCLES(8),
    //     .SIGNAL_WIDTH(1)
    // )  initiated_data_clk_inst2 (
    //     .clk(CLK1),
    //     .rst_n(rst_n),
    //     .in_signal(mbinit_inst2.o_Transmitter_initiated_Data_to_CLK_en),
    //     .out_signal(Transmitter_initiated_Data_to_CLK_done_inst2)
    // );


    MBINIT mbinit_inst1 (
        .CLK(CLK1), 
        .rst_n(rst_n), 
        .i_MBINIT_Start_en(i_MBINIT_Start_en),
        .i_rx_msg_no(rx_msg_no_inst1), 
        .i_rx_data_bus(rx_data_final_bus_inst1), 
        .i_rx_msg_info(rx_msg_info_inst1),
        .i_rx_busy(rx_busy_inst1), 
        .i_msg_valid(mbinit_inst2.o_tx_msg_valid), 
        .i_CLK_Track_done(CLK_Track_done_inst1), 
        .i_VAL_Pattern_done(VAL_Pattern_done_inst1), 
        .i_LaneID_Pattern_done(LaneID_Pattern_done_inst1), 
        .i_logged_clk_result(i_logged_clk_result_inst1), 
        .i_logged_val_result(i_logged_val_result_inst1), 
        .i_REVERSAL_done(REVERSAL_done_inst1), 
        .i_logged_lane_id_result(i_logged_lane_id_result_inst1),
        .i_Transmitter_initiated_Data_to_CLK_done(Transmitter_initiated_Data_to_CLK_done_inst1),
        .i_Transmitter_initiated_Data_to_CLK_Result(i_Transmitter_initiated_Data_to_CLK_Result_inst1),
        .o_tx_sub_state(tx_sub_state_1), 
        .o_tx_msg_no(tx_msg_no_1), 
        .o_tx_data_bus(tx_data_bus_1),
        .o_tx_msg_info(tx_msg_info_1), 
        .o_tx_msg_valid(tx_msg_valid_1), 
        .o_tx_data_valid(tx_data_valid_1),
        .o_MBINIT_REPAIRCLK_Pattern_En(mbinit_inst1_o_MBINIT_REPAIRCLK_Pattern_En), 
        .o_MBINIT_REPAIRVAL_Pattern_En(mbinit_inst1_o_MBINIT_REPAIRVAL_Pattern_En), 
        .o_MBINIT_REVERSALMB_LaneID_Pattern_En(mbinit_inst1_o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .o_MBINIT_REVERSALMB_ApplyReversal_En(mbinit_inst1_o_MBINIT_REVERSALMB_ApplyReversal_En), 
        .o_Clear_Pattern_Comparator(mbinit_inst1_o_Clear_Pattern_Comparator), 
        .o_Functional_Lanes_out_tx(mbinit_inst1_o_Functional_Lanes_out_tx),
        .o_Functional_Lanes_out_rx(mbinit_inst1_o_Functional_Lanes_out_rx), 
        .o_Transmitter_initiated_Data_to_CLK_en(mbinit_inst1_o_Transmitter_initiated_Data_to_CLK_en), 
        .o_perlane_Transmitter_initiated_Data_to_CLK(mbinit_inst1_o_perlane_Transmitter_initiated_Data_to_CLK),
        .o_mainband_Transmitter_initiated_Data_to_CLK(mbinit_inst1_o_mainband_Transmitter_initiated_Data_to_CLK), 
        .o_Final_MaxDataRate(mbinit_inst1_o_Final_MaxDataRate), 
        .o_Final_ClockMode(o_Final_ClockMode_1), 
        .o_Final_ClockPhase(o_Final_ClockPhase_1), 
        .o_train_error_req(mbinit_inst1_o_train_error_req), 
        .o_enable_cons(o_enable_cons_inst1),
        .o_clear_clk_detection(o_clear_clk_detection_inst1),
        .o_Finish_MBINIT(Finish_MBINIT_1)
    );
    MBINIT mbinit_inst2 (
        .CLK(CLK1), 
        .rst_n(rst_n), 
        .i_MBINIT_Start_en(i_MBINIT_Start_en), 
        .i_rx_msg_no(rx_msg_no_inst2), 
        .i_rx_data_bus(rx_data_bus_inst2), 
        .i_rx_msg_info(rx_msg_info_inst2),
        .i_rx_busy(rx_busy_inst2), 
        .i_msg_valid(i_msg_valid_2), 
        .i_CLK_Track_done(CLK_Track_done_inst2), 
        .i_VAL_Pattern_done(VAL_Pattern_done_inst2),
        .i_LaneID_Pattern_done(LaneID_Pattern_done_inst2), 
        .i_logged_clk_result(i_logged_clk_result_inst2),
        .i_logged_val_result(i_logged_val_result_inst2), 
        .i_REVERSAL_done(REVERSAL_done_inst2), 
        .i_logged_lane_id_result(i_logged_lane_id_result_inst2),
        .i_Transmitter_initiated_Data_to_CLK_done(Transmitter_initiated_Data_to_CLK_done_inst2),
        .i_Transmitter_initiated_Data_to_CLK_Result(i_Transmitter_initiated_Data_to_CLK_Result_inst2),
        .o_tx_sub_state(tx_sub_state_2), 
        .o_tx_msg_no(tx_msg_no_2), 
        .o_tx_data_bus(tx_data_bus_2),
        .o_tx_msg_info(tx_msg_info_2), 
        .o_tx_msg_valid(tx_msg_valid_2), 
        .o_tx_data_valid(tx_data_valid_2),
        .o_MBINIT_REPAIRCLK_Pattern_En(mbinit_inst2_o_MBINIT_REPAIRCLK_Pattern_En), 
        .o_MBINIT_REPAIRVAL_Pattern_En(mbinit_inst2_o_MBINIT_REPAIRVAL_Pattern_En), 
        .o_MBINIT_REVERSALMB_LaneID_Pattern_En(mbinit_inst2_o_MBINIT_REVERSALMB_LaneID_Pattern_En),
        .o_MBINIT_REVERSALMB_ApplyReversal_En(mbinit_inst2_o_MBINIT_REVERSALMB_ApplyReversal_En), 
        .o_Clear_Pattern_Comparator(mbinit_inst2_o_Clear_Pattern_Comparator), 
        .o_Functional_Lanes_out_tx(mbinit_inst2_o_Functional_Lanes_out_tx),
        .o_Functional_Lanes_out_rx(mbinit_inst2_o_Functional_Lanes_out_rx), 
        .o_Transmitter_initiated_Data_to_CLK_en(mbinit_inst2_o_Transmitter_initiated_Data_to_CLK_en), 
        .o_perlane_Transmitter_initiated_Data_to_CLK(mbinit_inst2_o_perlane_Transmitter_initiated_Data_to_CLK),
        .o_mainband_Transmitter_initiated_Data_to_CLK(mbinit_inst2_o_mainband_Transmitter_initiated_Data_to_CLK), 
        .o_Final_MaxDataRate(mbinit_inst2_o_Final_MaxDataRate), 
        .o_Final_ClockMode(o_Final_ClockMode_2), 
        .o_Final_ClockPhase(o_Final_ClockPhase_2), 
        .o_train_error_req(mbinit_inst2_o_train_error_req), 
        .o_enable_cons(o_enable_cons_inst2),
        .o_clear_clk_detection(o_clear_clk_detection_inst2),
        .o_Finish_MBINIT(Finish_MBINIT_2)
    );


logic TVLD_L_inst1,TVLD_L_inst2;
logic enable_detector_inst1,enable_detector_inst2;
    // Instantiate Valtrain_Controller for instance 1
    Valtrain_Controller valtrain_controller_inst1 (
        .i_clk(CLK1),
        .i_rst_n(rst_n),
        .Valid_pattern_enable(mbinit_inst1_o_MBINIT_REPAIRVAL_Pattern_En),
        .valid_frame_enable(1'b0), // Example enable signal, adjust as needed
        .TVLD_L(TVLD_L_inst1),                // Leave unconnected or connect as needed
        .o_done(VAL_Pattern_done_inst1),                // Leave unconnected or connect as needed
        .enable_detector(enable_detector_inst1)        // Leave unconnected or connect as needed
    );

    // Instantiate Valtrain_Controller for instance 2
    Valtrain_Controller valtrain_controller_inst2 (
        .i_clk(CLK1),
        .i_rst_n(rst_n),
        .Valid_pattern_enable(mbinit_inst2_o_MBINIT_REPAIRVAL_Pattern_En),
        .valid_frame_enable(1'b0), // Example enable signal, adjust as needed
        .TVLD_L(TVLD_L_inst2),                // Leave unconnected or connect as needed
        .o_done(VAL_Pattern_done_inst2),                // Leave unconnected or connect as needed
        .enable_detector(enable_detector_inst2)        // Leave unconnected or connect as needed
    );

    // /* ----------------------------------------------------------------
    //                                  for the VAL DETECTION DETECTION 
    // -------------------------------------------------------------------------------*/

    // Instantiate Pattern_valid_detector for instance 1
    Pattern_valid_detector pattern_valid_detector_inst1 (
        .i_clk(CLK1),
        .i_rst_n(rst_n),
        .RVLD_L(TVLD_L_inst1),         // Connect appropriate signal
        .error_threshold(12'hFFF),         // Example threshold, adjust as needed
        .i_enable_cons(o_enable_cons_inst1),              // Example enable signal, adjust as needed
        .i_enable_128(1'b0),               // Example enable signal, adjust as needed
        .i_enable_detector(enable_detector_inst1), // Enable signal for detector
        .detection_result(i_logged_val_result_inst1),               // Leave unconnected or connect as needed
        .o_valid_frame_detect()            // Leave unconnected or connect as needed
    );

    // Instantiate Pattern_valid_detector for instance 2
    Pattern_valid_detector pattern_valid_detector_inst2 (
        .i_clk(CLK1),
        .i_rst_n(rst_n),
        .RVLD_L(TVLD_L_inst1),         // Connect appropriate signal
        .error_threshold(12'hFFF),         // Example threshold, adjust as needed
        .i_enable_cons(o_enable_cons_inst2),              // Example enable signal, adjust as needed
        .i_enable_128(1'b0),               // Example enable signal, adjust as needed
        .i_enable_detector(enable_detector_inst2), // Enable signal for detector
        .detection_result(i_logged_val_result_inst2),               // Leave unconnected or connect as needed
        .o_valid_frame_detect()            // Leave unconnected or connect as needed
    );

    // /* ----------------------------------------------------------------
    //                                  for the CLK PATTERN GENERATION 
    // -------------------------------------------------------------------------------*/
    bit CKP_1,CKP_2;
    bit CKN_1,CKN_2;
    bit Track_1,Track_2;
    wire enable_detector_CKP_1,enable_detector_CKP_2;
    wire enable_detector_CKN_1,enable_detector_CKN_2;
    wire enable_detector_Track_1,enable_detector_Track_2;

    UCIe_Clock_System_Wrapper uci_clk_system_wrapper_inst1 (
        .i_sys_clk(CLK1),
        .i_clk1(CLK1),
        .i_clk2(CLK2),
        .i_rst_n(rst_n),
        .i_valid(1'b0), // Example valid signal, adjust as needed
        .i_mode(o_Final_ClockMode_1), // Mode from instance 1
        .i_state_indicator(mbinit_inst1_o_MBINIT_REPAIRCLK_Pattern_En), // State indicator from instance 1
        .clear_out(o_clear_clk_detection_inst1),
        .o_CKP(CKP_1),
        .o_CKN(CKN_1),
        .o_Track(Track_1),
        .o_done(CLK_Track_done_inst1),
        .i_Clock_track_result_logged(i_logged_clk_result_inst1) // Clock track result logged for instance 1
    );

    UCIe_Clock_System_Wrapper uci_clk_system_wrapper_inst2 (
        .i_sys_clk(CLK1),
        .i_clk1(CLK1),
        .i_clk2(CLK2),
        .i_rst_n(rst_n),
        .i_valid(1'b0), // Example valid signal, adjust as needed
        .i_mode(o_Final_ClockMode_2), // Mode from instance 2
        .clear_out(o_clear_clk_detection_inst2),
        .i_state_indicator(mbinit_inst2_o_MBINIT_REPAIRCLK_Pattern_En), // State indicator from instance 2
        .o_CKP(CKP_2),
        .o_CKN(CKN_2),
        .o_Track(Track_2),
        .o_done(CLK_Track_done_inst2),
        .i_Clock_track_result_logged(i_logged_clk_result_inst2) // Clock track result logged for instance 2
    );

    // Instantiate LFSR_System_Wrapper for instance 1
    LFSR_System_Wrapper #(
        .WIDTH(32)
    ) lfsr_system_wrapper_inst1 (
        .i_clk(CLK1),
        .i_rst_n(rst_n),
        .i_state_tx(i_state_tx_for_ashour_inst1), // Example state, adjust as needed
        .i_state_rx(i_state_rx_for_ashour_inst1),
        .i_enable_scrambeling_pattern(1'b0), // Example enable signal, adjust as needed
        .i_functional_tx_lanes(mbinit_inst1_o_Functional_Lanes_out_tx),
        .i_enable_reversal(mbinit_inst1_o_MBINIT_REVERSALMB_ApplyReversal_En),
        .i_lane_0(32'h0), .i_lane_1(32'h0), .i_lane_2(32'h0), .i_lane_3(32'h0),
        .i_lane_4(32'h0), .i_lane_5(32'h0), .i_lane_6(32'h0), .i_lane_7(32'h0),
        .i_lane_8(32'h0), .i_lane_9(32'h0), .i_lane_10(32'h0), .i_lane_11(32'h0),
        .i_lane_12(32'h0), .i_lane_13(32'h0), .i_lane_14(32'h0), .i_lane_15(32'h0),
        .i_enable_Descrambeling_pattern(1'b0), // Example enable signal, adjust as needed
        // .i_enable_buffer(1'b1), // Example enable signal, adjust as needed
        .i_functional_rx_lanes(mbinit_inst1_o_Functional_Lanes_out_rx),
        .i_Type_comp(1'b0), // Example comparator type, adjust as needed
        .i_Max_error_Threshold_per_lane(12'hFFF), // Example threshold, adjust as needed
        .i_Max_error_Threshold_aggregate(16'hFFFF), // Example threshold, adjust as needed
        .o_Lfsr_tx_done(o_Lfsr_tx_done_inst1), // Leave unconnected or connect as needed
        .o_enable_frame(), // Leave unconnected or connect as needed
        .o_per_lane_error(o_per_lane_error_inst1), // Leave unconnected or connect as needed
        .o_error_done() // Leave unconnected or connect as needed
    );

    // Instantiate LFSR_System_Wrapper for instance 2
    LFSR_System_Wrapper #(
        .WIDTH(32)
    ) lfsr_system_wrapper_inst2 (
        .i_clk(CLK1),
        .i_rst_n(rst_n),
        .i_state_tx(i_state_tx_for_ashour_inst2), // Example state, adjust as needed
        .i_state_rx(i_state_rx_for_ashour_inst2),
        .i_enable_scrambeling_pattern(1'b0), // Example enable signal, adjust as needed
        .i_functional_tx_lanes(mbinit_inst2_o_Functional_Lanes_out_tx),
        .i_enable_reversal(mbinit_inst2_o_MBINIT_REVERSALMB_ApplyReversal_En),
        .i_lane_0(32'h0), .i_lane_1(32'h0), .i_lane_2(32'h0), .i_lane_3(32'h0),
        .i_lane_4(32'h0), .i_lane_5(32'h0), .i_lane_6(32'h0), .i_lane_7(32'h0),
        .i_lane_8(32'h0), .i_lane_9(32'h0), .i_lane_10(32'h0), .i_lane_11(32'h0),
        .i_lane_12(32'h0), .i_lane_13(32'h0), .i_lane_14(32'h0), .i_lane_15(32'h0),
        .i_enable_Descrambeling_pattern(1'b0), // Example enable signal, adjust as needed
        // .i_enable_buffer(1'b1), // Example enable signal, adjust as needed
        .i_functional_rx_lanes(mbinit_inst2_o_Functional_Lanes_out_rx),
        .i_Type_comp(1'b0), // Example comparator type, adjust as needed
        .i_Max_error_Threshold_per_lane(12'hFFF), // Example threshold, adjust as needed
        .i_Max_error_Threshold_aggregate(16'hFFFF), // Example threshold, adjust as needed
        .o_Lfsr_tx_done(o_Lfsr_tx_done_inst2), // Leave unconnected or connect as needed
        .o_enable_frame(), // Leave unconnected or connect as needed
        .o_per_lane_error(o_per_lane_error_inst2), // Leave unconnected or connect as needed
        .o_error_done() // Leave unconnected or connect as needed
    );
    // UCIe_Clock_Mode_Generator uci_clk_gen_inst1 (
    //     .i_clk1(CLK1),
    //     .i_clk2(CLK2),
    //     .i_rst_n(rst_n),
    //     .i_valid(1'b0),
    //     .i_mode(o_Final_ClockMode_1), // Example mode, adjust as needed
    //     .i_state_indicator(1), // Example state indicator, adjust as needed
    //     .CKP(CKP_1),
    //     .CKN(CKN_1),
    //     .Track(Track_1),
    //     .o_done(CLK_Track_done_inst1),
    //     .enable_detector_CKP(enable_detector_CKP_1),
    //     .enable_detector_CKN(enable_detector_CKN_1),
    //     .enable_detector_Track(enable_detector_Track_1)
    // );

    // UCIe_Clock_Mode_Generator uci_clk_gen_inst2 (
    //     .i_clk1(CLK1),
    //     .i_clk2(CLK2),
    //     .i_rst_n(rst_n),
    //     .i_valid(1'b0),
    //     .i_mode(o_Final_ClockMode_2), // Example mode, adjust as needed
    //     .i_state_indicator(mbinit_inst2_o_MBINIT_REPAIRCLK_Pattern_En), // Example state indicator, adjust as needed
    //     .CKP(CKP_2),
    //     .CKN(CKN_2),
    //     .Track(Track_2),
    //     .o_done(CLK_Track_done_inst2),
    //     .enable_detector_CKP(enable_detector_CKP_2),
    //     .enable_detector_CKN(enable_detector_CKN_2),
    //     .enable_detector_Track(enable_detector_Track_2)
    // );


    // // /* ----------------------------------------------------------------
    // //                                  for the CLK PATTERN DETECTION 
    // // -------------------------------------------------------------------------------*/

    // UCIe_Clock_Pattern_Detector uci_clk_pattern_detector_inst1 (
    //     .i_clk(CLK1),
    //     .i_rst_n(rst_n),
    //     .RCKP_L(CKP_1), // Connect appropriate signal for RCKP_L
    //     .RCKN_L(CKN_1), // Connect appropriate signal for RCKN_L
    //     .RTRK_L(Track_1), // Connect appropriate signal for RTRK_L
    //     .enable_detector_CKP(enable_detector_CKP_1), // Connect appropriate signal for enable_detector_CKP
    //     .enable_detector_CKN(enable_detector_CKN_1), // Connect appropriate signal for enable_detector_CKN
    //     .enable_detector_Track(enable_detector_Track_1), // Connect appropriate signal for enable_detector_Track
    //     .i_Clock_track_result_logged(i_logged_clk_result_inst1)
    // );

    // UCIe_Clock_Pattern_Detector uci_clk_pattern_detector_inst2 (
    //     .i_clk(CLK1),
    //     .i_rst_n(rst_n),
    //     .RCKP_L(CKP_2), // Connect appropriate signal for RCKP_L
    //     .RCKN_L(CKN_2), // Connect appropriate signal for RCKN_L
    //     .RTRK_L(Track_2), // Connect appropriate signal for RTRK_L
    //     .enable_detector_CKP(enable_detector_CKP_2), // Connect appropriate signal for enable_detector_CKP
    //     .enable_detector_CKN(enable_detector_CKN_2), // Connect appropriate signal for enable_detector_CKN
    //     .enable_detector_Track(enable_detector_Track_2), // Connect appropriate signal for enable_detector_Track
    //     .i_Clock_track_result_logged(i_logged_clk_result_inst2)
    // );

    // Testbench Logic
initial begin
    // Initialize Signals
    // Reset sequence
    CLK1=0;
    CLK2=1;
    i_MBINIT_Start_en=0;
    #20 rst_n = 1;
    #20 rst_n = 0;
    #20 rst_n = 1;
    i_MBINIT_Start_en=1;
    // i_logged_clk_result_inst1=3'b111;
    // i_logged_clk_result_inst2=3'b111;
    // i_logged_val_result_inst1=1'b1;
    // i_logged_val_result_inst2=1'b1;
    // i_logged_lane_id_result_inst1='1;
    // i_logged_lane_id_result_inst2='1;
    // i_Transmitter_initiated_Data_to_CLK_Result_inst1=16'b00011101_11111111;
    // i_Transmitter_initiated_Data_to_CLK_Result_inst2=16'b00011101_11111111;
    #60000;
    i_MBINIT_Start_en=0;
    #10;
        i_MBINIT_Start_en=1;
    // i_logged_clk_result_inst1=3'b111;
    // i_logged_clk_result_inst2=3'b111;
    // i_logged_val_result_inst1=1'b1;
    // i_logged_val_result_inst2=1'b1;
    // i_logged_lane_id_result_inst1='1;
    // i_logged_lane_id_result_inst2='1;
    // i_Transmitter_initiated_Data_to_CLK_Result_inst1=16'b00011101_11111111;
    // i_Transmitter_initiated_Data_to_CLK_Result_inst2=16'b00011101_11111111;
    #60000;

    $stop;
end


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


    // /* ----------------------------------------------------------------
    //                                  for the sideband message 
    // -------------------------------------------------------------------------------*/
    // typedef enum {
    //     MBINIT_PARAM_configuration_req=1,
    //     MBINIT_PARAM_configuration_resp=2
    // }sideband_message_param;

    // typedef enum {
    //     MBINIT_CAL_Done_req=1,
    //     MBINIT_CAL_Done_resp=2
    // } sideband_message_cal;

    // typedef enum {
    //     MBINI_REPAIRCLK_init_req     = 1,
    //     MBINIT_REPAIRCLK_init_resp   ,
    //     MBINIT_REPAIRCLK_result_req  ,
    //     MBINIT_REPAIRCLK_result_resp ,
    //     MBINIT_REPAIRCLK_done_req   ,
    //     MBINIT_REPAIRCLK_done_resp   
    // } sideband_message_clk;

    // typedef enum {
    //     MBINI_REPAIRVAL_init_req     = 1,
    //     MBINIT_REPAIRVAL_init_resp   ,
    //     MBINIT_REPAIRVAL_result_req  ,
    //     MBINIT_REPAIRVAL_result_resp ,
    //     MBINIT_REPAIRVAL_done_req   ,
    //     MBINIT_REPAIRVAL_done_resp   
    // } sideband_message_val;

    // typedef enum {
    //     MBINI_REVERSALMB_init_req =1,
    //     MBINIT_REVERSALMB_init_resp,
    //     MBINIT_REVERSALMB_clear_error_req,
    //     MBINIT_REVERSALMB_clear_error_resp,
    //     MBINIT_REVERSALMB_result_req,
    //     MBINIT_REVERSALMB_result_resp,
    //     MBINIT_REVERSALMB_done_req,
    //     MBINIT_REVERSALMB_done_resp
    // } sideband_message_reversal;

    // typedef enum {
    //     MBINIT_REPAIRMB_start_req=1,
    //     MBINIT_REPAIRMB_start_resp,
    //     MBINIT_REPAIRMB_apply_degrade_req,
    //     MBINIT_REPAIRMB_apply_degrade_resp,
    //     MBINIT_REPAIRMB_end_req,
    //     MBINIT_REPAIRMB_end_resp
    // } sideband_message_repairmb;


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

	// /*------------------------------------------------------------------------------
	// --  for sideband_messages
	// ------------------------------------------------------------------------------*/

    // // param
    // sideband_message_param  tx_message_param_inst1,rx_message_param_inst1,tx_message_param_inst2,rx_message_param_inst2;
    // // cal
    // sideband_message_cal  tx_message_cal_inst1,rx_message_cal_inst1,tx_message_cal_inst2,rx_message_cal_inst2;
    // //clk
    // sideband_message_clk  tx_message_clk_inst1,rx_message_clk_inst1,tx_message_clk_inst2,rx_message_clk_inst2;
    // // val
    // sideband_message_val  tx_message_val_inst1,rx_message_val_inst1,tx_message_val_inst2,rx_message_val_inst2;
    // // reversal
    // sideband_message_reversal  tx_message_reversal_inst1,rx_message_reversal_inst1,tx_message_reversal_inst2,rx_message_reversal_inst2;
    // // repairemb
    // sideband_message_repairmb  tx_message_repairmb_inst1,rx_message_repairmb_inst1,tx_message_repairmb_inst2,rx_message_repairmb_inst2;
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

	// /*------------------------------------------------------------------------------
	// --  for sideband_messages
	// ------------------------------------------------------------------------------*/

    //     // PARAM
    //     tx_message_param_inst1=sideband_message_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_Module.o_TX_SbMessage);
    //     rx_message_param_inst1=sideband_message_param'(mbinit_inst1.PARAM_Wrapper_inst.u_PARAM_ModulePartner.i_RX_SbMessage);
    //     tx_message_param_inst2=sideband_message_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_Module.o_TX_SbMessage);
    //     rx_message_param_inst2=sideband_message_param'(mbinit_inst2.PARAM_Wrapper_inst.u_PARAM_ModulePartner.i_RX_SbMessage);
    //     // CAL   
    //     tx_message_cal_inst1=sideband_message_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_inst.o_TX_SbMessage);
    //     rx_message_cal_inst1=sideband_message_cal'(mbinit_inst1.CAL_ModuleWrapper_inst.cal_module_partner_inst.i_RX_SbMessage);
    //     tx_message_cal_inst2=sideband_message_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_inst.o_TX_SbMessage);
    //     rx_message_cal_inst2=sideband_message_cal'(mbinit_inst2.CAL_ModuleWrapper_inst.cal_module_partner_inst.i_RX_SbMessage);
    //     //clk
    //     tx_message_clk_inst1=sideband_message_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u1.o_TX_SbMessage);
    //     rx_message_clk_inst1=sideband_message_clk'(mbinit_inst1.RepairCLK_Wrapper_inst.u2.i_RX_SbMessage);
    //     tx_message_clk_inst2=sideband_message_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u1.o_TX_SbMessage);
    //     rx_message_clk_inst2=sideband_message_clk'(mbinit_inst2.RepairCLK_Wrapper_inst.u2.i_RX_SbMessage);
    //     //val
    //     tx_message_val_inst1=sideband_message_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u1.o_TX_SbMessage);
    //     rx_message_val_inst1=sideband_message_val'(mbinit_inst1.REPAIRVAL_Wrapper_inst.u2.i_Rx_SbMessage);
    //     tx_message_val_inst2=sideband_message_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u1.o_TX_SbMessage);
    //     rx_message_val_inst2=sideband_message_val'(mbinit_inst2.REPAIRVAL_Wrapper_inst.u2.i_Rx_SbMessage);

    //     //reversal

    //     tx_message_reversal_inst1=sideband_message_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u1.o_TX_SbMessage);
    //     rx_message_reversal_inst1=sideband_message_reversal'(mbinit_inst1.REVERSALMB_Wrapper_inst.u2.i_Rx_SbMessage);
    //     tx_message_reversal_inst2=sideband_message_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u1.o_TX_SbMessage);
    //     rx_message_reversal_inst2=sideband_message_reversal'(mbinit_inst2.REVERSALMB_Wrapper_inst.u2.i_Rx_SbMessage);
        
    //     // repairemb
        
    //     tx_message_repairmb_inst1=sideband_message_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.o_TX_SbMessage);
    //     rx_message_repairmb_inst1=sideband_message_repairmb'(mbinit_inst1.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.i_RX_SbMessage);
    //     tx_message_repairmb_inst2=sideband_message_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_inst.o_TX_SbMessage);
    //     rx_message_repairmb_inst2=sideband_message_repairmb'(mbinit_inst2.REPAIRMB_Wrapper_inst.REPAIRMB_Module_Partner_inst.i_RX_SbMessage);
	end


// /* ----------------------------------------------------------------
//                                  for the sideband message 
// -------------------------------------------------------------------------------*/

/////////////////////////////////////////////////
// module _inputs_rx
/////////////////////////////////////////////////

// module 
always @ (*) begin
i_rx_msg_no_string_1 = "UNKNOWN"; // Default case
i_state_tx_for_ashour_inst1=0;
i_state_rx_for_ashour_inst1=0;
        case (mbinit_inst1_cs)
            PARAM: begin
                case (mbinit_inst1.i_rx_msg_no)
                    1: i_rx_msg_no_string_1 = "PARAM_CONFIG_REQ";
                    2: i_rx_msg_no_string_1 = "PARAM_CONFIG_RESP";
                endcase
            end
            CAL: begin
                case (mbinit_inst1.i_rx_msg_no)
                    1: i_rx_msg_no_string_1 = "CAL_DONE_REQ";
                    2: i_rx_msg_no_string_1 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (mbinit_inst1.i_rx_msg_no)
                    1: i_rx_msg_no_string_1 = "REPAIRCLK_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRCLK_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRCLK_RESULT_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRCLK_RESULT_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRCLK_DONE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (mbinit_inst1.i_rx_msg_no)
                    1: i_rx_msg_no_string_1 = "REPAIRVAL_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRVAL_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRVAL_RESULT_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRVAL_RESULT_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRVAL_DONE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (mbinit_inst1.i_rx_msg_no)
                    1: i_rx_msg_no_string_1 = "REVERSALMB_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REVERSALMB_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: i_rx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: i_rx_msg_no_string_1 = "REVERSALMB_RESULT_REQ";
                    6: i_rx_msg_no_string_1 = "REVERSALMB_RESULT_RESP";
                    7: i_rx_msg_no_string_1 = "REVERSALMB_DONE_REQ";
                    8: i_rx_msg_no_string_1 = "REVERSALMB_DONE_RESP";
                endcase
                i_state_tx_for_ashour_inst1=mbinit_inst1_o_MBINIT_REVERSALMB_LaneID_Pattern_En;
                i_state_rx_for_ashour_inst1=mbinit_inst1_o_Clear_Pattern_Comparator;
                i_logged_lane_id_result_inst1=o_per_lane_error_inst1;
                if (mbinit_inst1_o_MBINIT_REVERSALMB_ApplyReversal_En)
                    REVERSAL_done_inst1=o_Lfsr_tx_done_inst1;
                else begin 
                    LaneID_Pattern_done_inst1=o_Lfsr_tx_done_inst1;
                end
            end
            REPAIRMB: begin
                case (mbinit_inst1.i_rx_msg_no)
                    1: i_rx_msg_no_string_1 = "REPAIRMB_START_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRMB_START_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRMB_END_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRMB_END_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
                i_state_tx_for_ashour_inst1=mbinit_inst1_o_Transmitter_initiated_Data_to_CLK_en;
                Transmitter_initiated_Data_to_CLK_done_inst1=o_Lfsr_tx_done_inst1;
                i_Transmitter_initiated_Data_to_CLK_Result_inst1=o_per_lane_error_inst1;
            end
        endcase
end


// module_partner 
always @ (*) begin
i_rx_msg_no_string_2 = "UNKNOWN"; // Default case
i_state_tx_for_ashour_inst2=0;
i_state_rx_for_ashour_inst2=0;
rx_data_final_bus_inst1=rx_data_bus_inst1;
        case (mbinit_inst2_cs)
            PARAM: begin
                case (mbinit_inst2.i_rx_msg_no)
                    1: i_rx_msg_no_string_2 = "PARAM_CONFIG_REQ";
                    2: i_rx_msg_no_string_2 = "PARAM_CONFIG_RESP";
                    3: i_rx_msg_no_string_2 = "PARAM_SBFE_REQ";
                    4: i_rx_msg_no_string_2 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (mbinit_inst2.i_rx_msg_no)
                    1: i_rx_msg_no_string_2 = "CAL_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (mbinit_inst2.i_rx_msg_no)
                    1: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (mbinit_inst2.i_rx_msg_no)
                    1: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (mbinit_inst2.i_rx_msg_no)
                    1: i_rx_msg_no_string_2 = "REVERSALMB_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REVERSALMB_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_REQ";
                    6: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_RESP";
                    7: i_rx_msg_no_string_2 = "REVERSALMB_DONE_REQ";
                    8: i_rx_msg_no_string_2 = "REVERSALMB_DONE_RESP";
                endcase
                i_state_tx_for_ashour_inst2=mbinit_inst2_o_MBINIT_REVERSALMB_LaneID_Pattern_En;
                i_state_rx_for_ashour_inst2=mbinit_inst2_o_Clear_Pattern_Comparator;
                i_logged_lane_id_result_inst2=o_per_lane_error_inst2;
                rx_data_final_bus_inst1=o_per_lane_error_inst1;
                if (mbinit_inst2_o_MBINIT_REVERSALMB_ApplyReversal_En) 
                    REVERSAL_done_inst2=o_Lfsr_tx_done_inst2;
                else begin 
                    LaneID_Pattern_done_inst2=o_Lfsr_tx_done_inst2;
                end
            end
            REPAIRMB: begin
                case (mbinit_inst2.i_rx_msg_no)
                    1: i_rx_msg_no_string_2 = "REPAIRMB_START_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRMB_START_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRMB_END_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRMB_END_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
                i_state_tx_for_ashour_inst2=mbinit_inst2_o_Transmitter_initiated_Data_to_CLK_en;
                Transmitter_initiated_Data_to_CLK_done_inst2=o_Lfsr_tx_done_inst2;
                i_Transmitter_initiated_Data_to_CLK_Result_inst2=o_per_lane_error_inst2;
            end
        endcase
end



/////////////////////////////////////////////////
// module _ouputs_tx
/////////////////////////////////////////////////

always @ (*) begin
o_tx_msg_no_string_1 = "UNKNOWN"; // Default case
        case (mbinit_inst1_cs)
            PARAM: begin
                case (mbinit_inst1.o_tx_msg_no)
                    1: o_tx_msg_no_string_1 = "PARAM_CONFIG_REQ";
                    2: o_tx_msg_no_string_1 = "PARAM_CONFIG_RESP";
                    3: o_tx_msg_no_string_1 = "PARAM_SBFE_REQ";
                    4: o_tx_msg_no_string_1 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (mbinit_inst1.o_tx_msg_no)
                    1: o_tx_msg_no_string_1 = "CAL_DONE_REQ";
                    2: o_tx_msg_no_string_1 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (mbinit_inst1.o_tx_msg_no)
                    1: o_tx_msg_no_string_1 = "REPAIRCLK_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRCLK_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRCLK_RESULT_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRCLK_RESULT_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRCLK_DONE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (mbinit_inst1.o_tx_msg_no)
                    1: o_tx_msg_no_string_1 = "REPAIRVAL_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRVAL_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRVAL_RESULT_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRVAL_RESULT_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRVAL_DONE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (mbinit_inst1.o_tx_msg_no)
                    1: o_tx_msg_no_string_1 = "REVERSALMB_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REVERSALMB_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: o_tx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: o_tx_msg_no_string_1 = "REVERSALMB_RESULT_REQ";
                    6: o_tx_msg_no_string_1 = "REVERSALMB_RESULT_RESP";
                    7: o_tx_msg_no_string_1 = "REVERSALMB_DONE_REQ";
                    8: o_tx_msg_no_string_1 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (mbinit_inst1.o_tx_msg_no)
                    1: o_tx_msg_no_string_1 = "REPAIRMB_START_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRMB_START_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRMB_END_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRMB_END_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
end


// module_partner 
always @ (*) begin
i_rx_msg_no_string_2 = "UNKNOWN"; // Default case
        case (mbinit_inst2_cs)
            PARAM: begin
                case (mbinit_inst2.o_tx_msg_no)
                    1: i_rx_msg_no_string_2 = "PARAM_CONFIG_REQ";
                    2: i_rx_msg_no_string_2 = "PARAM_CONFIG_RESP";
                    3: i_rx_msg_no_string_2 = "PARAM_SBFE_REQ";
                    4: i_rx_msg_no_string_2 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (mbinit_inst2.o_tx_msg_no)
                    1: i_rx_msg_no_string_2 = "CAL_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (mbinit_inst2.o_tx_msg_no)
                    1: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (mbinit_inst2.o_tx_msg_no)
                    1: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (mbinit_inst2.o_tx_msg_no)
                    1: i_rx_msg_no_string_2 = "REVERSALMB_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REVERSALMB_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_REQ";
                    6: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_RESP";
                    7: i_rx_msg_no_string_2 = "REVERSALMB_DONE_REQ";
                    8: i_rx_msg_no_string_2 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (mbinit_inst2.o_tx_msg_no)
                    1: i_rx_msg_no_string_2 = "REPAIRMB_START_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRMB_START_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRMB_END_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRMB_END_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
end







    // // Monitor FSM state and set done_result
    // always @(posedge CLK1 or negedge rst_n ) begin
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
    // always @(posedge CLK1 or negedge rst_n ) begin
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
