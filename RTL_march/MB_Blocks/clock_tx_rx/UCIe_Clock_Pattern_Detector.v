module UCIe_Clock_Pattern_Detector (
    // Inputs
    input wire        i_clk,           // System clock
    input wire        i_rst_n,         // Active-low reset
    input wire        RCKP_L,          // Received Clock Positive
    input wire        RCKN_L,          // Received Clock Negative
    input wire        RTRK_L,          // Received Track signal
    input wire        enable_detector_CKP,  // Enable signal from generator for CKP
    input wire        enable_detector_CKN,  // Enable signal from generator for CKN
    input wire        enable_detector_Track,// Enable signal from generator for Track
    
    // Outputs
    output reg        detect_RCKP,     // Detection result for RCKP_L
    output reg        detect_RCKN,     // Detection result for RCKN_L
    output reg        detect_RTRK      // Detection result for RTRK_L
);

    // Parameters
   localparam DETECT_PATTERN = 48'b000000000000000001010101010101010101010101010101;  // 16 zeros + 32 alternating 1010...
    localparam DETECT_PATTERN_CKN = ~DETECT_PATTERN;  // Inverted pattern: 48'b111111111111111110101010101010101010101010101010
    localparam PATTERN_LENGTH = 48;       // Total pattern length (32 + 16)
    localparam DETECT_THRESHOLD = 16;     // Threshold for detection

    // Internal registers for RCKP
    reg [47:0] shift_reg_RCKP;           // 48-bit shift register for RCKP_L
    reg [5:0]  pattern_counter_RCKP;     // Counter for RCKP pattern (0-47)
    reg [4:0]  match_count_RCKP;         // Counts consecutive pattern matches for RCKP
    reg        locked_RCKP;              // Lock flag for RCKP after threshold reached

    // Internal registers for RCKN
    reg [47:0] shift_reg_RCKN;           // 48-bit shift register for RCKN_L
    reg [5:0]  pattern_counter_RCKN;     // Counter for RCKN pattern (0-47)
    reg [4:0]  match_count_RCKN;         // Counts consecutive pattern matches for RCKN
    reg        locked_RCKN;              // Lock flag for RCKN after threshold reached

    // Internal registers for RTRK
    reg [47:0] shift_reg_RTRK;           // 48-bit shift register for RTRK_L
    reg [5:0]  pattern_counter_RTRK;     // Counter for RTRK pattern (0-47)
    reg [4:0]  match_count_RTRK;         // Counts consecutive pattern matches for RTRK
    reg        locked_RTRK;              // Lock flag for RTRK after threshold reached

    // Always block for detect_RCKP
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            shift_reg_RCKP <= 48'b0;
            pattern_counter_RCKP <= 6'b0;
            match_count_RCKP <= 5'b0;
            detect_RCKP <= 1'b0;
            locked_RCKP <= 1'b0;  // Reset lock
        end
        else begin
            if (enable_detector_CKP && !locked_RCKP) begin  // Only proceed if not locked
                // Shift in new data and update counter
                shift_reg_RCKP <= {RCKP_L, shift_reg_RCKP[47:1]};
                if (pattern_counter_RCKP < PATTERN_LENGTH - 1)
                    pattern_counter_RCKP <= pattern_counter_RCKP + 1;
                else
                    pattern_counter_RCKP <= 6'b0;

                // When pattern_counter_RCKP == 0, compare directly
                if (pattern_counter_RCKP == 0) begin
                    if (shift_reg_RCKP == DETECT_PATTERN) begin
                        if (match_count_RCKP < DETECT_THRESHOLD)
                            match_count_RCKP <= match_count_RCKP + 1;
                        if (match_count_RCKP == DETECT_THRESHOLD - 1)  // One less since this increments
                            locked_RCKP <= 1'b1;  // Lock when threshold reached
                    end
                    else begin
                        match_count_RCKP <= 5'b0;
                    end
                end
            end
            // Update detection output (remains high once locked)
            detect_RCKP <= (match_count_RCKP >= DETECT_THRESHOLD);
        end
    end

    // Always block for detect_RCKN (now identical to RCKP)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            shift_reg_RCKN <= 48'b0;
            pattern_counter_RCKN <= 6'b0;
            match_count_RCKN <= 5'b0;
            detect_RCKN <= 1'b0;
            locked_RCKN <= 1'b0;  // Reset lock
        end
        else begin
            if (enable_detector_CKN && !locked_RCKN) begin  // Only proceed if not locked
                // Shift in new data and update counter
                shift_reg_RCKN <= {RCKN_L, shift_reg_RCKN[47:1]};
                if (pattern_counter_RCKN < PATTERN_LENGTH - 1)
                    pattern_counter_RCKN <= pattern_counter_RCKN + 1;
                else
                    pattern_counter_RCKN <= 6'b0;

                // When pattern_counter_RCKN == 0, compare directly
                if (pattern_counter_RCKN == 0) begin
                    if (shift_reg_RCKN == DETECT_PATTERN_CKN) begin  // Use DETECT_PATTERN_CKN, not inverted
                        if (match_count_RCKN < DETECT_THRESHOLD)
                            match_count_RCKN <= match_count_RCKN + 1;
                        if (match_count_RCKN == DETECT_THRESHOLD - 1)  // One less since this increments
                            locked_RCKN <= 1'b1;  // Lock when threshold reached
                    end
                    else begin
                        match_count_RCKN <= 5'b0;
                    end
                end
            end
            // Update detection output (remains high once locked)
            detect_RCKN <= (match_count_RCKN >= DETECT_THRESHOLD);
        end
    end

    // Always block for detect_RTRK (now identical to RCKP)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            shift_reg_RTRK <= 48'b0;
            pattern_counter_RTRK <= 6'b0;
            match_count_RTRK <= 5'b0;
            detect_RTRK <= 1'b0;
            locked_RTRK <= 1'b0;  // Reset lock
        end
        else begin
            if (enable_detector_Track && !locked_RTRK) begin  // Only proceed if not locked
                // Shift in new data and update counter
                shift_reg_RTRK <= {RTRK_L, shift_reg_RTRK[47:1]};
                if (pattern_counter_RTRK < PATTERN_LENGTH - 1)
                    pattern_counter_RTRK <= pattern_counter_RTRK + 1;
                else
                    pattern_counter_RTRK <= 6'b0;

                // When pattern_counter_RTRK == 0, compare directly
                if (pattern_counter_RTRK == 0) begin
                    if (shift_reg_RTRK == DETECT_PATTERN) begin
                        if (match_count_RTRK < DETECT_THRESHOLD)
                            match_count_RTRK <= match_count_RTRK + 1;
                        if (match_count_RTRK == DETECT_THRESHOLD - 1)  // One less since this increments
                            locked_RTRK <= 1'b1;  // Lock when threshold reached
                    end
                    else begin
                        match_count_RTRK <= 5'b0;
                    end
                end
            end
            // Update detection output (remains high once locked)
            detect_RTRK <= (match_count_RTRK >= DETECT_THRESHOLD);
        end
    end

endmodule