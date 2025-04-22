module UCIe_Clock_System_Wrapper (
    // External Inputs
    input wire        i_sys_clk,        // System clock for detector
    input wire        i_clk1,          // Clock 1 input (CKP source)
    input wire        i_clk2,          // Clock 2 input (CKN source)
    input             i_CKP,
    input             i_CKN,
    input             i_TRACK,
    input wire        i_rst_n,         // Active-low reset
    input wire        i_valid,         // Valid signal for strobe mode
    input wire        i_mode,          // Mode select (0: strobe, 1: continuous)
    input wire        i_state_indicator, // Repair mode indicator
    input wire        clear_out,        // New signal to clear outputs
    
    // External Outputs
    output wire       o_CKP,           // Generated CKP signal
    output wire       o_CKN,           // Generated CKN signal
    output wire       o_Track,         // Generated Track signal
    output wire       o_done,          // Repair mode completion signal
    output [2:0]      o_Clock_track_result_logged
);

    // Internal wires for connecting generator to detector
    wire       w_enable_detector_CKP;
    wire       w_enable_detector_CKN;
    wire       w_enable_detector_Track;
    wire       w_CKP;
    wire       w_CKN;
    wire       w_Track;

    // Instantiate the Clock Mode Generator
    UCIe_Clock_Mode_Generator clock_gen (
        .i_clk1(i_clk1),
        .i_clk2(i_clk2),
        .i_rst_n(i_rst_n),
        .i_valid(i_valid),
        .i_mode(i_mode),
        .i_state_indicator(i_state_indicator),
      //  .clear_out(clear_out),              // Propagate clear_out
        .CKP(w_CKP),
        .CKN(w_CKN),
        .Track(w_Track),
        .o_done(o_done),
        .enable_detector_CKP(w_enable_detector_CKP),
        .enable_detector_CKN(w_enable_detector_CKN),
        .enable_detector_Track(w_enable_detector_Track)
    );

    // Instantiate the Clock Pattern Detector
    UCIe_Clock_Pattern_Detector clock_det (
        .i_clk(i_sys_clk),
        .i_rst_n(i_rst_n),
        .RCKP_L(i_CKP),                  
        .RCKN_L(i_CKN),                   
        .RTRK_L(i_TRACK),                
        .enable_detector_CKP(w_enable_detector_CKP),
        .enable_detector_CKN(w_enable_detector_CKN),
        .enable_detector_Track(w_enable_detector_Track),
        .clear_out(clear_out),            // Propagate clear_out
        .o_Clock_track_result_logged(o_Clock_track_result_logged)
    );

    // Output assignments
    assign o_CKP   = w_CKP;
    assign o_CKN   = w_CKN;
    assign o_Track = w_Track;

endmodule