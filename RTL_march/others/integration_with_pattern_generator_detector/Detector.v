module pattern_comparison (
    input clk,                  // Clock signal
    input rst_n,                // Asynchronous active-low reset
    input Type_comp,            // 1 = Per-lane mode, 0 = Aggregate mode
    input [1:0] i_state,        // State input
    input enable_buffer,        // Enable

    // Locally generated patterns (16 lanes)
    input o_generated_0, input o_generated_1, input o_generated_2, input o_generated_3,
    input o_generated_4, input o_generated_5, input o_generated_6, input o_generated_7,
    input o_generated_8, input o_generated_9, input o_generated_10, input o_generated_11,
    input o_generated_12, input o_generated_13, input o_generated_14, input o_generated_15,

    // Received patterns (16 lanes)
    input o_pattern_0, input o_pattern_1, input o_pattern_2, input o_pattern_3,
    input o_pattern_4, input o_pattern_5, input o_pattern_6, input o_pattern_7,
    input o_pattern_8, input o_pattern_9, input o_pattern_10, input o_pattern_11,
    input o_pattern_12, input o_pattern_13, input o_pattern_14, input o_pattern_15,

    // Error threshold inputs
    input [11:0] Max_error_Threshold_per_lane,  // Per-lane comparison threshold (12-bit)
    input [15:0] Max_error_Threshold_aggregate, // Aggregate error threshold (16-bit)

    // Error outputs
    output reg [15:0] per_lane_error,   // Per-lane error bits (if each bit indicates this lane is faulty)
    output reg [15:0] error_counter,    // Aggregate error counter
    output wire done_result              // Done signal (1 when test completes)
);

    // State definitions
    localparam IDLE         = 2'b00;  // Idle state
    localparam CLEAR_LFSR   = 2'b01;  // Clear LFSR state
    localparam PATTERN_LFSR = 2'b10;  // Pattern LFSR state
    localparam PER_LANE_IDE = 2'b11;  // Per-lane IDE state

    // ernal signals for XOR results between generated and received patterns
    wire [15:0] lane_mismatch;
    assign lane_mismatch[0]  = o_generated_0  ^ o_pattern_0;  // XOR for lane 0
    assign lane_mismatch[1]  = o_generated_1  ^ o_pattern_1;  // XOR for lane 1
    assign lane_mismatch[2]  = o_generated_2  ^ o_pattern_2;  // XOR for lane 2
    assign lane_mismatch[3]  = o_generated_3  ^ o_pattern_3;  // XOR for lane 3
    assign lane_mismatch[4]  = o_generated_4  ^ o_pattern_4;  // XOR for lane 4
    assign lane_mismatch[5]  = o_generated_5  ^ o_pattern_5;  // XOR for lane 5
    assign lane_mismatch[6]  = o_generated_6  ^ o_pattern_6;  // XOR for lane 6
    assign lane_mismatch[7]  = o_generated_7  ^ o_pattern_7;  // XOR for lane 7
    assign lane_mismatch[8]  = o_generated_8  ^ o_pattern_8;  // XOR for lane 8
    assign lane_mismatch[9]  = o_generated_9  ^ o_pattern_9;  // XOR for lane 9
    assign lane_mismatch[10] = o_generated_10 ^ o_pattern_10; // XOR for lane 10
    assign lane_mismatch[11] = o_generated_11 ^ o_pattern_11; // XOR for lane 11
    assign lane_mismatch[12] = o_generated_12 ^ o_pattern_12; // XOR for lane 12
    assign lane_mismatch[13] = o_generated_13 ^ o_pattern_13; // XOR for lane 13
    assign lane_mismatch[14] = o_generated_14 ^ o_pattern_14; // XOR for lane 14
    assign lane_mismatch[15] = o_generated_15 ^ o_pattern_15; // XOR for lane 15

    // Concatenate generated patterns o a single 16-bit vector
    wire [15:0] lane_pattern = { 
        o_generated_15, o_generated_14, o_generated_13, o_generated_12, 
        o_generated_11, o_generated_10, o_generated_9,  o_generated_8, 
        o_generated_7,  o_generated_6,  o_generated_5,  o_generated_4,  
        o_generated_3,  o_generated_2,  o_generated_1,  o_generated_0  
    };
   integer i;

    // Counter for 4059 comparisons
    reg [12:0] comparison_count;  // 13-bit counter for 4059 comparisons
    reg [10:0] per_lane_count;    // 11-bit counter for per-lane comparisons
    reg [3:0] count_success;      // 4-bit counter for successful matches

    // Counter for 2048 consecutive correct matches per lane
    reg [15:0] consecutive_match_counter [15:0]; // 16 counters, each 16-bit wide
    reg [11:0] lane_error_counter [15:0];       // 16 counters, each 12-bit wide

    // Define the done signal
    reg done;

    // Sequential logic for state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers on active-low reset
            per_lane_error     <= 16'b0;
            error_counter      <= 16'b0;
            comparison_count   <= 13'b0;
            per_lane_count     <= 11'b0;
            count_success      <= 4'b0;
            done               <= 1'b0;
            for ( i = 0; i < 16; i = i + 1) begin
                consecutive_match_counter[i] <= 16'b0;
                lane_error_counter[i] <= 12'b0;
            end
        end else begin
      
            case (i_state)
                IDLE: begin
                    if (Type_comp) begin
                        // Per-lane mode: Check for mismatches and update counters
                        for ( i = 0; i < 16; i = i + 1) begin
                            if (lane_mismatch[i]) begin
                                // Increment error counter for the lane if mismatch occurs
                                lane_error_counter[i] <= lane_error_counter[i] + 1;
                            end
                            // Check if the error counter exceeds the threshold
                            if (lane_error_counter[i] > Max_error_Threshold_per_lane) begin
                                per_lane_error[i] <= 1'b1; // Set error bit for the lane
                            end
                        end
                    end else begin
                        // Aggregate mode: Count total mismatches
                        if (|lane_mismatch) begin
                            error_counter <= error_counter + 1;
                            
                        end
                    if (error_counter > Max_error_Threshold_aggregate) begin
                        done <= 1'b0;
                    end else begin
                        done <= 1'b1;
                    end
                    end
                    // Check if error counter is within the threshold
                  
                end

                CLEAR_LFSR: begin
                    // Reset only the aggregate error counter
                    error_counter <= 16'b0;

                end

                PATTERN_LFSR: begin
                    if (enable_buffer) begin
                        if (comparison_count < 13'd4059) begin
                            // Increment comparison counter
                            comparison_count <= comparison_count + 1;
                            if (Type_comp) begin
                                for ( i = 0; i < 16; i = i + 1) begin
                                    if (lane_mismatch[i]) begin
                                        // Increment error counter for the lane if mismatch occurs
                                        lane_error_counter[i] <= lane_error_counter[i] + 1;
                                    end
                                    // Check if the error counter exceeds the threshold
                                    if (lane_error_counter[i] > Max_error_Threshold_per_lane) begin
                                        per_lane_error[i] <= 1'b0; // Set error bit for the lane
                                    end else begin
                                        per_lane_error[i] <= 1'b1;
                                    end
                                end
                            end else begin
                                // Aggregate mode: count total mismatches
                                if (|lane_mismatch) begin
                                    error_counter <= error_counter + 1;
                                end
                                 // After 4059 comparisons, check error threshold
                        if (error_counter > Max_error_Threshold_aggregate) begin
                            done <= 1'b0;
                        end else begin
                            done <= 1'b1;
                        end
                            end
                        end
                       
                    end
                end

                PER_LANE_IDE: begin
                       if (enable_buffer) begin
                    if (per_lane_count < 11'd2047) begin
                        // Increment per-lane counter
                        per_lane_count <= per_lane_count + 1;
                            // Check if any mismatch occurred

                        for ( i = 0; i < 16; i = i + 1) 
                        begin
                                    if (lane_mismatch[i]) begin
                                        // Increment error counter for the lane if mismatch occurs
                                        lane_error_counter[i] <= lane_error_counter[i] + 1;
                                    end
                                    // Check if the error counter exceeds the threshold
                                    if (lane_error_counter[i] > Max_error_Threshold_per_lane) begin
                                        per_lane_error[i] <= 1'b0; // Set error bit for the lane
                                    end else begin
                                        per_lane_error[i] <= 1'b1;
                                    end
                        end
                        if (!done) begin
                            if (|lane_mismatch) begin  
                                // If any mismatch, reset all counters to 0
                                for ( i = 0; i < 16; i = i + 1) begin
                                    consecutive_match_counter[i] <= 16'b0;
                                end
                                count_success <= 4'b0; // Reset success counter
                                done <= 1'b0; // Keep done low if reset happens
                            end else begin
                                // No mismatch, increment success counter
                                count_success <= count_success + 1;
                                // Store lane mismatch result (which should be 0)
                                consecutive_match_counter[count_success] <= lane_pattern;
                                // Set done when all 16 spaces are filled
                                if (count_success == 4'd15)  
                                    done <= 1'b1;  // Lock done signal at 1
                            end
                        end
                    end
                end
                end
                default: begin
                    // Default case: Hold previous values
                    per_lane_error    <= per_lane_error;
                    error_counter     <= error_counter;
                end
            endcase
        end
    end

    // Assign the done signal to the output
    assign done_result = done;

endmodule