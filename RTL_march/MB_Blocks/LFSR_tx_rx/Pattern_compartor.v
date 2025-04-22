module pattern_comparator #(
    parameter WIDTH = 32 // Parameter for signal WIDTH
)(
    input i_clk,                  // Clock signal
    input i_rst_n,                // Asynchronous active-low reset
    input i_Type_comp,            // 1 = Per-lane mode, 0 = Aggregate mode
    input [1:0] i_state,          // State input
    input enable_pattern_comparitor, // New input: Enable signal from LFSR_Receiver

    // Locally generated patterns (16 lanes)
    input wire [WIDTH-1:0] i_local_gen_0, i_local_gen_1, i_local_gen_2, i_local_gen_3,
    input wire [WIDTH-1:0] i_local_gen_4, i_local_gen_5, i_local_gen_6, i_local_gen_7,
    input wire [WIDTH-1:0] i_local_gen_8, i_local_gen_9, i_local_gen_10, i_local_gen_11,
    input wire [WIDTH-1:0] i_local_gen_12, i_local_gen_13, i_local_gen_14, i_local_gen_15,

    // Received patterns (16 lanes)
    input wire [WIDTH-1:0] i_Data_by_0, i_Data_by_1, i_Data_by_2, i_Data_by_3,
    input wire [WIDTH-1:0] i_Data_by_4, i_Data_by_5, i_Data_by_6, i_Data_by_7,
    input wire [WIDTH-1:0] i_Data_by_8, i_Data_by_9, i_Data_by_10, i_Data_by_11,
    input wire [WIDTH-1:0] i_Data_by_12, i_Data_by_13, i_Data_by_14, i_Data_by_15,

    // Error threshold inputs
    input [11:0] i_Max_error_Threshold_per_lane,  // Per-lane comparison threshold (12-bit)
    input [15:0] i_Max_error_Threshold_aggregate, // Aggregate error threshold (16-bit)

    // Error outputs
    output reg [15:0] o_per_lane_error,   // Per-lane error bits (1 = good, 0 = faulty)
    output reg [15:0] o_error_counter,    // Aggregate error counter
    output wire o_error_done              // Error done signal (at aggregate)
);

    // Internal signals and registers
    integer i, j;
    reg done;
    reg [4:0] count_success; // 4-bit counter for successful matches
    reg [11:0] bit_mismatch_temp [15:0]; // Cumulative bit mismatch counts (12-bit wide)
    reg [11:0] mismatch_count [15:0];    // Temporary combinational mismatch count (12-bit wide)
    wire [15:0] lane_mismatch_part_1;    // Lane mismatch for bits [0:15] of each lane
    wire [15:0] lane_mismatch_part_2;    // Lane mismatch for bits [16:31] of each lane
    reg [WIDTH-1:0] bit_mismatch_or;     // OR of mismatches for each bit position across all lanes
    reg [5:0] comb_bit_count;            // Combinational count of mismatches

    // State definitions
    localparam IDLE         = 2'b00;  // Idle state
    localparam CLEAR_LFSR   = 2'b01;  // Clear LFSR state
    localparam PATTERN_LFSR = 2'b10;  // Pattern LFSR state
    localparam PER_LANE_IDE = 2'b11;  // Per-lane IDE state

    // Assign lane mismatch signals for bits [0:15] (lane_mismatch_part_1)
    assign lane_mismatch_part_1[0]  = (i_Data_by_0[15:0] == i_local_gen_0[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[1]  = (i_Data_by_1[15:0] == i_local_gen_1[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[2]  = (i_Data_by_2[15:0] == i_local_gen_2[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[3]  = (i_Data_by_3[15:0] == i_local_gen_3[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[4]  = (i_Data_by_4[15:0] == i_local_gen_4[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[5]  = (i_Data_by_5[15:0] == i_local_gen_5[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[6]  = (i_Data_by_6[15:0] == i_local_gen_6[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[7]  = (i_Data_by_7[15:0] == i_local_gen_7[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[8]  = (i_Data_by_8[15:0] == i_local_gen_8[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[9]  = (i_Data_by_9[15:0] == i_local_gen_9[15:0])  ? 1 : 0;
    assign lane_mismatch_part_1[10] = (i_Data_by_10[15:0]== i_local_gen_10[15:0]) ? 1 : 0;
    assign lane_mismatch_part_1[11] = (i_Data_by_11[15:0]== i_local_gen_11[15:0]) ? 1 : 0;
    assign lane_mismatch_part_1[12] = (i_Data_by_12[15:0]== i_local_gen_12[15:0]) ? 1 : 0;
    assign lane_mismatch_part_1[13] = (i_Data_by_13[15:0]== i_local_gen_13[15:0]) ? 1 : 0;
    assign lane_mismatch_part_1[14] = (i_Data_by_14[15:0]== i_local_gen_14[15:0]) ? 1 : 0;
    assign lane_mismatch_part_1[15] = (i_Data_by_15[15:0]== i_local_gen_15[15:0]) ? 1 : 0;

    // Assign lane mismatch signals for bits [16:31] (lane_mismatch_part_2)
    assign lane_mismatch_part_2[0]  = (i_Data_by_0[31:16] == i_local_gen_0[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[1]  = (i_Data_by_1[31:16] == i_local_gen_1[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[2]  = (i_Data_by_2[31:16] == i_local_gen_2[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[3]  = (i_Data_by_3[31:16] == i_local_gen_3[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[4]  = (i_Data_by_4[31:16] == i_local_gen_4[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[5]  = (i_Data_by_5[31:16] == i_local_gen_5[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[6]  = (i_Data_by_6[31:16] == i_local_gen_6[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[7]  = (i_Data_by_7[31:16] == i_local_gen_7[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[8]  = (i_Data_by_8[31:16] == i_local_gen_8[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[9]  = (i_Data_by_9[31:16] == i_local_gen_9[31:16])  ? 1 : 0;
    assign lane_mismatch_part_2[10] = (i_Data_by_10[31:16]== i_local_gen_10[31:16]) ? 1 : 0;
    assign lane_mismatch_part_2[11] = (i_Data_by_11[31:16]== i_local_gen_11[31:16]) ? 1 : 0;
    assign lane_mismatch_part_2[12] = (i_Data_by_12[31:16]== i_local_gen_12[31:16]) ? 1 : 0;
    assign lane_mismatch_part_2[13] = (i_Data_by_13[31:16]== i_local_gen_13[31:16]) ? 1 : 0;
    assign lane_mismatch_part_2[14] = (i_Data_by_14[31:16]== i_local_gen_14[31:16]) ? 1 : 0;
    assign lane_mismatch_part_2[15] = (i_Data_by_15[31:16]== i_local_gen_15[31:16]) ? 1 : 0;

    // Combinational assignment for o_error_done
    assign o_error_done = (o_error_counter > i_Max_error_Threshold_aggregate) ? 0 : 1;

    // Combinational block to calculate mismatch_count for each lane
    always @(*) begin
        if (i_Type_comp) begin // Only execute when i_Type_comp is 1
            for (i = 0; i < 16; i = i + 1) begin
                mismatch_count[i] = 0; // Reset temporary count for combinational logic
                for (j = 0; j < WIDTH; j = j + 1) begin
                    case (i)
                        0:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_0[j]  ^ i_local_gen_0[j]);
                        1:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_1[j]  ^ i_local_gen_1[j]);
                        2:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_2[j]  ^ i_local_gen_2[j]);
                        3:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_3[j]  ^ i_local_gen_3[j]);
                        4:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_4[j]  ^ i_local_gen_4[j]);
                        5:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_5[j]  ^ i_local_gen_5[j]);
                        6:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_6[j]  ^ i_local_gen_6[j]);
                        7:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_7[j]  ^ i_local_gen_7[j]);
                        8:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_8[j]  ^ i_local_gen_8[j]);
                        9:  mismatch_count[i] = mismatch_count[i] + (i_Data_by_9[j]  ^ i_local_gen_9[j]);
                        10: mismatch_count[i] = mismatch_count[i] + (i_Data_by_10[j] ^ i_local_gen_10[j]);
                        11: mismatch_count[i] = mismatch_count[i] + (i_Data_by_11[j] ^ i_local_gen_11[j]);
                        12: mismatch_count[i] = mismatch_count[i] + (i_Data_by_12[j] ^ i_local_gen_12[j]);
                        13: mismatch_count[i] = mismatch_count[i] + (i_Data_by_13[j] ^ i_local_gen_13[j]);
                        14: mismatch_count[i] = mismatch_count[i] + (i_Data_by_14[j] ^ i_local_gen_14[j]);
                        15: mismatch_count[i] = mismatch_count[i] + (i_Data_by_15[j] ^ i_local_gen_15[j]);
                    endcase
                end
            end
        end else begin
            // When i_Type_comp is 0, reset mismatch_count to 0
            for (i = 0; i < 16; i = i + 1) begin
                mismatch_count[i] = 0;
            end
        end
    end

    // Combinational block to calculate OR of mismatches and count bits
    always @(*) begin
        comb_bit_count = 0; // Reset combinational count
        for (j = 0; j < WIDTH; j = j + 1) begin
            bit_mismatch_or[j] = (i_Data_by_0[j]  ^ i_local_gen_0[j])  |
                                 (i_Data_by_1[j]  ^ i_local_gen_1[j])  |
                                 (i_Data_by_2[j]  ^ i_local_gen_2[j])  |
                                 (i_Data_by_3[j]  ^ i_local_gen_3[j])  |
                                 (i_Data_by_4[j]  ^ i_local_gen_4[j])  |
                                 (i_Data_by_5[j]  ^ i_local_gen_5[j])  |
                                 (i_Data_by_6[j]  ^ i_local_gen_6[j])  |
                                 (i_Data_by_7[j]  ^ i_local_gen_7[j])  |
                                 (i_Data_by_8[j]  ^ i_local_gen_8[j])  |
                                 (i_Data_by_9[j]  ^ i_local_gen_9[j])  |
                                 (i_Data_by_10[j] ^ i_local_gen_10[j]) |
                                 (i_Data_by_11[j] ^ i_local_gen_11[j]) |
                                 (i_Data_by_12[j] ^ i_local_gen_12[j]) |
                                 (i_Data_by_13[j] ^ i_local_gen_13[j]) |
                                 (i_Data_by_14[j] ^ i_local_gen_14[j]) |
                                 (i_Data_by_15[j] ^ i_local_gen_15[j]);
            comb_bit_count = comb_bit_count + bit_mismatch_or[j]; // Accumulate count
        end
    end

    // Sequential block to manage bit_mismatch_temp
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= 0; // Reset on active-low reset
            end
        end else if ((i_state == CLEAR_LFSR)) begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= 0; // Reset in CLEAR_LFSR state
            end
        end else if (enable_pattern_comparitor) begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= bit_mismatch_temp[i] + mismatch_count[i]; // Accumulate
            end
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= bit_mismatch_temp[i]; // Hold value
            end
        end
    end

    // Main state machine (sequential logic)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Reset all registers on active-low reset
            o_error_counter    <= 0;
            o_per_lane_error   <= 16'hFFFF; // All lanes good (1) at reset
            count_success      <= 0;
            done               <= 0;
        end else if (enable_pattern_comparitor) begin
            case (i_state)
                IDLE: begin
                    if (i_Type_comp) begin
                        // Per-lane mode: Sticky behavior for o_per_lane_error
                        for (i = 0; i < 16; i = i + 1) begin
                            if (o_per_lane_error[i] == 0) begin
                                o_per_lane_error[i] <= 0; // Once faulty (0), stays 0
                            end else if (bit_mismatch_temp[i] > i_Max_error_Threshold_per_lane) begin
                                o_per_lane_error[i] <= 0; // Set to 0 if threshold exceeded (faulty)
                            end else begin
                                o_per_lane_error[i] <= 1; // Set to 1 if below threshold (good)
                            end
                        end
                    end else begin
                        // Aggregate mode: Use combinational count directly
                        o_error_counter <= o_error_counter + comb_bit_count;
                    end
                end

                CLEAR_LFSR: begin
                    // Clear aggregate counter and o_per_lane_error
                    o_error_counter    <= 0;
                    o_per_lane_error   <= 16'hFFFF; // All lanes good (1) after clear
                    count_success      <= 0;
                    done               <= 0;
                end

                PATTERN_LFSR: begin
                    if (i_Type_comp) begin
                        // Per-lane mode: Sticky behavior for o_per_lane_error
                        for (i = 0; i < 16; i = i + 1) begin
                            if (o_per_lane_error[i] == 0) begin
                                o_per_lane_error[i] <= 0; // Once faulty (0), stays 0
                            end else if (bit_mismatch_temp[i] > i_Max_error_Threshold_per_lane) begin
                                o_per_lane_error[i] <= 0; // Set to 0 if threshold exceeded (faulty)
                            end else begin
                                o_per_lane_error[i] <= 1; // Set to 1 if below threshold (good)
                            end
                        end
                    end else begin
                        // Aggregate mode: Use combinational count directly
                        o_error_counter <= o_error_counter + comb_bit_count;
                    end
                end

                PER_LANE_IDE: begin
                    if (i_Type_comp) begin
                        if (!done) begin
                            // Per-lane mode: Sticky behavior for o_per_lane_error
                            for (i = 0; i < 16; i = i + 1) begin
                                if (o_per_lane_error[i] == 0) begin
                                    o_per_lane_error[i] <= 0; // Once faulty (0), stays 0
                                end else if (bit_mismatch_temp[i] > i_Max_error_Threshold_per_lane) begin
                                    o_per_lane_error[i] <= 0; // Set to 0 if threshold exceeded (faulty)
                                end else begin
                                    o_per_lane_error[i] <= 1; // Set to 1 if below threshold (good)
                                end
                            end
                            // Custom logic for count_success based on lane_mismatch parts
                            if (&lane_mismatch_part_1 && &lane_mismatch_part_2) begin
                                count_success <= count_success + 2;
                            end
                            else if (!(&lane_mismatch_part_1) && &lane_mismatch_part_2) begin
                                count_success <= 1;
                            end
                            else begin
                                count_success <= 0;
                            end
                            if (count_success >=15) begin
                                done <= 1; // Set done signal
                            end
                        end
                    end else begin
                        // Aggregate mode: Use combinational count directly
                        o_error_counter <= o_error_counter + comb_bit_count;
                        // Custom logic for count_success based on lane_mismatch parts
                        if (&lane_mismatch_part_1 && &lane_mismatch_part_2) begin
                            count_success <= count_success + 2;
                        end
                        else if (!(&lane_mismatch_part_1) && &lane_mismatch_part_2) begin
                            count_success <= 1;
                        end
                        else begin
                            count_success <= 0;
                        end
                        if (count_success >=15) begin
                            done <= 1; // Set done signal
                        end
                    end
                end

                default: begin
                    // Default case: Hold previous values
                    o_error_counter   <= o_error_counter;
                    o_per_lane_error  <= o_per_lane_error;
                    count_success     <= count_success;
                    done              <= done;
                end
            endcase
        end else begin
            // When enable_pattern_comparitor is 0, hold all outputs
            o_error_counter   <= o_error_counter;
            o_per_lane_error  <= o_per_lane_error;
            count_success     <= count_success;
            done              <= done;
        end
    end

endmodule