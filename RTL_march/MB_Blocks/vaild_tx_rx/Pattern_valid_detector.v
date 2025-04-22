module Pattern_valid_detector (
    // Input Ports
    input wire i_clk,               // System clock input
    input wire i_rst_n,             // Active-low asynchronous reset
    input wire [31:0] RVLD_L,       // 32-bit input pattern to monitor
    input wire [11:0] error_threshold,  // 12-bit threshold for max allowed errors
    input wire i_enable_cons,       // Enable signal for CONSEC_16 mode
    input wire i_enable_128,        // Enable signal for ITER_128 mode
    input wire i_enable_detector,   // Enable signal for detector operation
    
    output reg detection_result,    // Detection result (1 = success, 0 = failure)
    output reg o_valid_en
);

    // Parameters
    localparam VALID_8BIT = 8'b00001111;  // The "VALTRAIN" pattern to detect
    localparam VALID_PATTERN = {VALID_8BIT, VALID_8BIT, VALID_8BIT, VALID_8BIT}; // 32-bit pattern
    
    localparam MIN_CONSECUTIVE = 5'd16;   // Minimum consecutive iterations for 16 consec mode
    localparam MAX_ITERATIONS = 128;      // Max iterations for 128 iteration mode
    localparam ERROR_MAX     = 12'hFFF;   // Maximum value for error_counter
    
    // Mode Definitions
    localparam IDLE          = 2'b00;
    localparam ITER_128      = 2'b01;
    localparam CONSEC_16     = 2'b10;
    localparam CHECK_PATTERN = 2'b11;               // or iDle .................

    // Internal Registers
    reg [7:0] consec_counter;             // 5-bit counter for consecutive matches
    reg [11:0] error_counter;             // 12-bit counter for bit mismatches
    reg [5:0] mismatch_count;             // 6-bit to count up to 32 mismatches in one cycle
    
    // Mode selection as combinational logic
    wire [1:0] mode_select;
    assign mode_select = {i_enable_cons, i_enable_128};  // Concatenate inputs
    
    // Split RVLD_L into four 8-bit segments
    wire [7:0] segment0 = RVLD_L[7:0];    // Bits 0-7
    wire [7:0] segment1 = RVLD_L[15:8];   // Bits 8-15
    wire [7:0] segment2 = RVLD_L[23:16];  // Bits 16-23
    wire [7:0] segment3 = RVLD_L[31:24];  // Bits 24-31
    
    // Check each segment against VALID_8BIT only in CONSEC_16 mode
    wire match0 = (mode_select == CONSEC_16) && (segment0 == VALID_8BIT);
    wire match1 = (mode_select == CONSEC_16) && (segment1 == VALID_8BIT);
    wire match2 = (mode_select == CONSEC_16) && (segment2 == VALID_8BIT);
    wire match3 = (mode_select == CONSEC_16) && (segment3 == VALID_8BIT);

    // Calculate bit mismatches in combinational logic
    integer i;
    always @(*) begin
        if (mode_select == ITER_128) begin
            mismatch_count = 6'b0;
            for (i = 0; i < 32; i = i + 1) begin
                mismatch_count = mismatch_count + (RVLD_L[i] ^ VALID_PATTERN[i]);
            end
        end else begin
            mismatch_count = 6'b0;
        end
    end
    
    // Sequential Logic
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Asynchronous Reset
            consec_counter   <= 7'b00000;
            error_counter    <= 12'b000000000000;
            detection_result <= 1'b1;
            o_valid_en       <= 1'b0;
        end 
        else if (i_enable_detector) begin  // Check i_enable_detector
            case (mode_select)
                IDLE: begin
                    consec_counter   <= 7'b00000;
                    error_counter    <= 12'b000000000000;
                    detection_result <= 1'b0;
                end
                
                ITER_128: begin
                    error_counter <= error_counter + mismatch_count;
                    if (error_counter > error_threshold) begin
                        detection_result <= 1'b0;
                    end else begin
                        detection_result <= 1'b1;
                    end
                end
                
                CONSEC_16: begin
                    if (match0 && match1 && match2 && match3) begin
                         consec_counter <= consec_counter + 4;
                    end
                    else if (!match0 && match1 && match2 && match3) begin
                        consec_counter <= 3;
                    end
                    else if (!match1 && match2 && match3) begin
                        consec_counter <= 2;
                    end
                    else if (!match2 && match3) begin
                        consec_counter <= 1;
                    end
                    else if (!match3) begin
                        consec_counter <= 0;
                    end

                    if (consec_counter >= MIN_CONSECUTIVE) begin
                        detection_result <= 1;
                    end
                    else begin
                        detection_result <= 1'b0;
                    end
                end
                
                CHECK_PATTERN: begin
                    o_valid_en <= (mismatch_count == 6'b0);
                    consec_counter   <= 7'b00000;
                    error_counter    <= 12'b000000000000;
                end
                
                default: begin
                    consec_counter   <= 7'b00000;
                    error_counter    <= 12'b000000000000;
                    detection_result <= 1'b0;
                end
            endcase
        end
    end

endmodule