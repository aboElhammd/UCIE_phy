module UCIe_Clock_Pattern_Detector (
    // Inputs
    input wire        i_clk,           // System clock
    input wire        i_rst_n,         // Active-low reset
    input wire        RCKP_L,          // Received Clock Positive
    input wire        RCKN_L,          // Received Clock Negative
    input wire        RTRK_L,          // Received Track signal
    input wire        enable_detector_CKP,  // Enable signal for CKP
    input wire        enable_detector_CKN,  // Enable signal for CKN
    input wire        enable_detector_Track,// Enable signal for Track
    input wire        clear_out,       // New signal to clear outputs
    
    output [2:0]      o_Clock_track_result_logged
);


     reg        detect_RCKP;     // Detection result for RCKP_L
     reg        detect_RCKN;     // Detection result for RCKN_L
     reg        detect_RTRK;     // Detection result for RTRK_L

assign o_Clock_track_result_logged={detect_RCKP,detect_RCKN,detect_RTRK} ; 
    // Parameters
    localparam DETECT_PATTERN = 48'b000000000000000001010101010101010101010101010101;
    localparam PATTERN_LENGTH = 48;
    localparam DETECT_THRESHOLD = 16;

    // Internal registers for RCKP
    reg [47:0] shift_reg_RCKP_1;
    reg [47:0] shift_reg_RCKP_2;
    reg [5:0]  pattern_counter_RCKP;
    reg [4:0]  match_count_RCKP;
    reg        toggle_RCKP;

    // Internal registers for RCKN
    reg [47:0] shift_reg_RCKN_1;
    reg [47:0] shift_reg_RCKN_2;
    reg [5:0]  pattern_counter_RCKN;
    reg [4:0]  match_count_RCKN;
    reg        toggle_RCKN;

    // Internal registers for RTRK
    reg [47:0] shift_reg_RTRK_1;
    reg [47:0] shift_reg_RTRK_2;
    reg [5:0]  pattern_counter_RTRK;
    reg [4:0]  match_count_RTRK;
    reg        toggle_RTRK;

    // Always block for detect_RCKP
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            shift_reg_RCKP_1 <= 48'b0;
            shift_reg_RCKP_2 <= 48'b0;
            pattern_counter_RCKP <= 6'b0;
            match_count_RCKP <= 5'b0;
            detect_RCKP <= 1'b0;
            toggle_RCKP <= 1'b0;
        end
        else if (clear_out) begin
            shift_reg_RCKP_1 <= 48'b0;
            shift_reg_RCKP_2 <= 48'b0;
            pattern_counter_RCKP <= 6'b0;
            match_count_RCKP <= 5'b0;
            detect_RCKP <= 1'b0;
            toggle_RCKP <= 1'b0;
        end
        else if (enable_detector_CKP) begin
            if (!toggle_RCKP) begin
                shift_reg_RCKP_1 <= {RCKP_L, shift_reg_RCKP_1[47:1]};
                shift_reg_RCKP_2 <= 48'b0;
            end
            else begin
                shift_reg_RCKP_2 <= {RCKP_L, shift_reg_RCKP_2[47:1]};
                shift_reg_RCKP_1 <= 48'b0;
            end

            if (pattern_counter_RCKP < PATTERN_LENGTH)
                pattern_counter_RCKP <= pattern_counter_RCKP + 1;
            else begin
                pattern_counter_RCKP <= 6'b0;
                toggle_RCKP <= ~toggle_RCKP;
                
                if ((!toggle_RCKP && shift_reg_RCKP_1 == DETECT_PATTERN) ||
                    (toggle_RCKP && shift_reg_RCKP_2 == DETECT_PATTERN)) begin
                    if (match_count_RCKP < DETECT_THRESHOLD)
                        match_count_RCKP <= match_count_RCKP + 1;
                end
                else
                    match_count_RCKP <= 5'b0;
            end
            
            // if (detect_RCKP == 1'b1) begin
            //     detect_RCKP <= 1'b1;  // Keep it 1 if already detected
            // end
            // else begin
            //     detect_RCKP <= (match_count_RCKP >= DETECT_THRESHOLD);
            // end
               detect_RCKP <= detect_RCKP || (match_count_RCKP >= DETECT_THRESHOLD);
        end
    end

    // Always block for detect_RCKN
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            shift_reg_RCKN_1 <= 48'b0;
            shift_reg_RCKN_2 <= 48'b0;
            pattern_counter_RCKN <= 6'b0;
            match_count_RCKN <= 5'b0;
            detect_RCKN <= 1'b0;
            toggle_RCKN <= 1'b0;
        end
        else if (clear_out) begin
            shift_reg_RCKN_1 <= 48'b0;
            shift_reg_RCKN_2 <= 48'b0;
            pattern_counter_RCKN <= 6'b0;
            match_count_RCKN <= 5'b0;
            detect_RCKN <= 1'b0;
            toggle_RCKN <= 1'b0;
        end
        else if (enable_detector_CKN) begin
            if (!toggle_RCKN) begin
                shift_reg_RCKN_1 <= {RCKN_L, shift_reg_RCKN_1[47:1]};
                shift_reg_RCKN_2 <= 48'b0;
            end
            else begin
                shift_reg_RCKN_2 <= {RCKN_L, shift_reg_RCKN_2[47:1]};
                shift_reg_RCKN_1 <= 48'b0;
            end

            if (pattern_counter_RCKN < PATTERN_LENGTH)
                pattern_counter_RCKN <= pattern_counter_RCKN + 1;
            else begin
                pattern_counter_RCKN <= 6'b0;
                toggle_RCKN <= ~toggle_RCKN;
                
                if ((!toggle_RCKN && shift_reg_RCKN_1 == DETECT_PATTERN) ||
                    (toggle_RCKN && shift_reg_RCKN_2 == DETECT_PATTERN)) begin
                    if (match_count_RCKN < DETECT_THRESHOLD)
                        match_count_RCKN <= match_count_RCKN + 1;
                end
                else
                    match_count_RCKN <= 5'b0;
            end
            
            // if (detect_RCKN == 1'b1) begin
            //     detect_RCKN <= 1'b1;  // Keep it 1 if already detected
            // end
            // else begin
            //     detect_RCKN <= (match_count_RCKN >= DETECT_THRESHOLD);
            // end
            detect_RCKN <= detect_RCKN || (match_count_RCKN >= DETECT_THRESHOLD);
        end
    end

    // Always block for detect_RTRK
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            shift_reg_RTRK_1 <= 48'b0;
            shift_reg_RTRK_2 <= 48'b0;
            pattern_counter_RTRK <= 6'b0;
            match_count_RTRK <= 5'b0;
            detect_RTRK <= 1'b0;
            toggle_RTRK <= 1'b0;
        end
        else if (clear_out) begin
            shift_reg_RTRK_1 <= 48'b0;
            shift_reg_RTRK_2 <= 48'b0;
            pattern_counter_RTRK <= 6'b0;
            match_count_RTRK <= 5'b0;
            detect_RTRK <= 1'b0;
            toggle_RTRK <= 1'b0;
        end
        else if (enable_detector_Track) begin
            if (!toggle_RTRK) begin
                shift_reg_RTRK_1 <= {RTRK_L, shift_reg_RTRK_1[47:1]};
                shift_reg_RTRK_2 <= 48'b0;
            end
            else begin
                shift_reg_RTRK_2 <= {RTRK_L, shift_reg_RTRK_2[47:1]};
                shift_reg_RTRK_1 <= 48'b0;
            end

            if (pattern_counter_RTRK < PATTERN_LENGTH)
                pattern_counter_RTRK <= pattern_counter_RTRK + 1;
            else begin
                pattern_counter_RTRK <= 6'b0;
                toggle_RTRK <= ~toggle_RTRK;
                
                if ((!toggle_RTRK && shift_reg_RTRK_1 == DETECT_PATTERN) ||
                    (toggle_RTRK && shift_reg_RTRK_2 == DETECT_PATTERN)) begin
                    if (match_count_RTRK < DETECT_THRESHOLD)
                        match_count_RTRK <= match_count_RTRK + 1;
                end
                else
                    match_count_RTRK <= 5'b0;
            end
            
            // if (detect_RTRK == 1'b1) begin
            //     detect_RTRK <= 1'b1;  // Keep it 1 if already detected
            // end
            // else begin
            //     detect_RTRK <= (match_count_RTRK >= DETECT_THRESHOLD);
            // end
            detect_RTRK <= detect_RTRK || (match_count_RTRK >= DETECT_THRESHOLD);
        end
    end

endmodule