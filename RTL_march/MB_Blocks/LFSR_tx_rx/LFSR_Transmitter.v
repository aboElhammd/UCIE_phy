module LFSR_Transmitter #(
    parameter WIDTH = 32 // Parameter for signal width
)(
    input wire i_clk,                      // Clock signal
    input wire i_rst_n,                    // Active-low reset signal
    input wire [1:0] i_state,              // State input (IDLE, Clear_lfsr, PATTERN_LFSR, PER_LANE_IDE)
    input wire i_enable_scrambeling_pattern, // Enable scrambling pattern (1: scrambler, 0: pattern)
    input wire [1:0] i_functional_tx_lanes, // Lane mapping code
    input wire i_enable_reversal,          // input for lane reversal
    // 16 input signals
    input wire [WIDTH-1:0] i_lane_0, input wire [WIDTH-1:0] i_lane_1,
    input wire [WIDTH-1:0] i_lane_2, input wire [WIDTH-1:0] i_lane_3,
    input wire [WIDTH-1:0] i_lane_4, input wire [WIDTH-1:0] i_lane_5,
    input wire [WIDTH-1:0] i_lane_6, input wire [WIDTH-1:0] i_lane_7,
    input wire [WIDTH-1:0] i_lane_8, input wire [WIDTH-1:0] i_lane_9,
    input wire [WIDTH-1:0] i_lane_10, input wire [WIDTH-1:0] i_lane_11,
    input wire [WIDTH-1:0] i_lane_12, input wire [WIDTH-1:0] i_lane_13,
    input wire [WIDTH-1:0] i_lane_14, input wire [WIDTH-1:0] i_lane_15,
    // 16 output signals
    output reg [WIDTH-1:0] o_lane_0, output reg [WIDTH-1:0] o_lane_1,
    output reg [WIDTH-1:0] o_lane_2, output reg [WIDTH-1:0] o_lane_3,
    output reg [WIDTH-1:0] o_lane_4, output reg [WIDTH-1:0] o_lane_5,
    output reg [WIDTH-1:0] o_lane_6, output reg [WIDTH-1:0] o_lane_7,
    output reg [WIDTH-1:0] o_lane_8, output reg [WIDTH-1:0] o_lane_9,
    output reg [WIDTH-1:0] o_lane_10, output reg [WIDTH-1:0] o_lane_11,
    output reg [WIDTH-1:0] o_lane_12, output reg [WIDTH-1:0] o_lane_13,
    output reg [WIDTH-1:0] o_lane_14, output reg [WIDTH-1:0] o_lane_15,
    output reg o_Lfsr_tx_done,
    output reg o_enable_frame           
);

    // State and lane mapping parameters
    localparam IDLE           = 2'b00;
    localparam Clear_lfsr     = 2'b01;
    localparam PATTERN_LFSR   = 2'b10;
    localparam PER_LANE_IDE   = 2'b11;

    localparam DEGRADE_LANES_0_TO_7   = 2'b01;
    localparam DEGRADE_LANES_8_TO_15  = 2'b10;
    localparam DEGRADE_LANES_0_TO_15  = 2'b11;

    // Counters
    reg [6:0] counter_lfsr;        // 7-bit counter (0 to 127)
    reg [5:0] counter_per_lane;    // 6-bit counter (0 to 63)

    // Lane IDs with prepended and appended 1010
    localparam LANE_ID_0  = 16'b1010_00000000_1010;
    localparam LANE_ID_1  = 16'b1010_00000001_1010;
    localparam LANE_ID_2  = 16'b1010_00000010_1010;
    localparam LANE_ID_3  = 16'b1010_00000011_1010;
    localparam LANE_ID_4  = 16'b1010_00000100_1010;
    localparam LANE_ID_5  = 16'b1010_00000101_1010;
    localparam LANE_ID_6  = 16'b1010_00000110_1010;
    localparam LANE_ID_7  = 16'b1010_00000111_1010;
    localparam LANE_ID_8  = 16'b1010_00001000_1010;
    localparam LANE_ID_9  = 16'b1010_00001001_1010;
    localparam LANE_ID_10 = 16'b1010_00001010_1010;
    localparam LANE_ID_11 = 16'b1010_00001011_1010;
    localparam LANE_ID_12 = 16'b1010_00001100_1010;
    localparam LANE_ID_13 = 16'b1010_00001101_1010;
    localparam LANE_ID_14 = 16'b1010_00001110_1010;
    localparam LANE_ID_15 = 16'b1010_00001111_1010;

    // LFSR registers for each lane
    reg [22:0] tx_lfsr_lane_0, tx_lfsr_lane_1, tx_lfsr_lane_2, tx_lfsr_lane_3;
    reg [22:0] tx_lfsr_lane_4, tx_lfsr_lane_5, tx_lfsr_lane_6, tx_lfsr_lane_7;

    // Bit 23 storage for LFSR outputs
    reg [8:0] o_lane_0_23, o_lane_1_23, o_lane_2_23, o_lane_3_23;
    reg [8:0] o_lane_4_23, o_lane_5_23, o_lane_6_23, o_lane_7_23;

    // New register to store reversal state
    reg lane_reversal_enabled;
    wire Not_Rev_Degrade;

// Assign Not_Rev_Degrade to 1 only when i_functional_tx_lanes is DEGRADE_LANES_0_TO_15
assign Not_Rev_Degrade = (i_functional_tx_lanes == 2'b11) ? 1'b1 : 1'b0;

    // Function to compute the next LFSR state (unchanged)
    function [31:0] next_lfsr_state;
        input [22:0] current_state;
        reg [31:0] next_state;
        begin
            next_state[0]  = current_state[1] ^ current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[7] ^ current_state[8] ^ current_state[10] ^ current_state[14] ^ current_state[15] ^ current_state[17] ^ current_state[18] ^ current_state[19] ^ current_state[20] ^ current_state[22];
            next_state[1]  = current_state[0] ^ current_state[3] ^ current_state[4] ^ current_state[9] ^ current_state[11] ^ current_state[15] ^ current_state[18] ^ current_state[19] ^ current_state[20];
            next_state[2]  = current_state[1] ^ current_state[4] ^ current_state[5] ^ current_state[10] ^ current_state[12] ^ current_state[16] ^ current_state[19] ^ current_state[20] ^ current_state[21];
            next_state[3]  = current_state[2] ^ current_state[5] ^ current_state[6] ^ current_state[11] ^ current_state[13] ^ current_state[17] ^ current_state[20] ^ current_state[21] ^ current_state[22];
            next_state[4]  = current_state[0] ^ current_state[2] ^ current_state[3] ^ current_state[5] ^ current_state[6] ^ current_state[7] ^ current_state[8] ^ current_state[12] ^ current_state[14] ^ current_state[16] ^ current_state[18] ^ current_state[22];
            next_state[5]  = current_state[0] ^ current_state[1] ^ current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[6] ^ current_state[7] ^ current_state[9] ^ current_state[13] ^ current_state[15] ^ current_state[16] ^ current_state[17] ^ current_state[19] ^ current_state[21];
            next_state[6] = current_state[1] ^  current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[6] ^ current_state[7] ^ current_state[8] ^ current_state[10] ^ current_state[14] ^ current_state[16] ^ current_state[17] ^ current_state[18] ^ current_state[20] ^ current_state[22];            next_state[7]  = current_state[0] ^ current_state[3] ^ current_state[4] ^ current_state[6] ^ current_state[7] ^ current_state[9] ^ current_state[11] ^ current_state[15] ^ current_state[16] ^ current_state[17] ^ current_state[18] ^ current_state[19];
            next_state[8]  = current_state[1] ^ current_state[4] ^ current_state[5] ^ current_state[7] ^ current_state[8] ^ current_state[10] ^ current_state[12] ^ current_state[16] ^ current_state[17] ^ current_state[18] ^ current_state[19] ^ current_state[20];
            next_state[9]  = current_state[2] ^ current_state[5] ^ current_state[6] ^ current_state[8] ^ current_state[9] ^ current_state[11] ^ current_state[13] ^ current_state[17] ^ current_state[18] ^ current_state[19] ^ current_state[20] ^ current_state[21];
            next_state[10] = current_state[3] ^ current_state[6] ^ current_state[7] ^ current_state[9] ^ current_state[10] ^ current_state[12] ^ current_state[14] ^ current_state[18] ^ current_state[19] ^ current_state[20] ^ current_state[21] ^ current_state[22];
            next_state[11] = current_state[0] ^ current_state[2] ^ current_state[4] ^ current_state[5] ^ current_state[7] ^ current_state[10] ^ current_state[11] ^ current_state[13] ^ current_state[15] ^ current_state[16] ^ current_state[19] ^ current_state[20] ^ current_state[22];
            next_state[12] = current_state[0] ^ current_state[1] ^ current_state[2] ^ current_state[3] ^ current_state[6] ^ current_state[11] ^ current_state[12] ^ current_state[14] ^ current_state[17] ^ current_state[20];
            next_state[13] = current_state[1] ^ current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[7] ^ current_state[12] ^ current_state[13] ^ current_state[15] ^ current_state[18] ^ current_state[21];
            next_state[14] = current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[8] ^ current_state[13] ^ current_state[14] ^ current_state[16] ^ current_state[19] ^ current_state[22];
            next_state[15] = current_state[0] ^ current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[6] ^ current_state[8] ^ current_state[9] ^ current_state[14] ^ current_state[15] ^ current_state[16] ^ current_state[17] ^ current_state[20] ^ current_state[21];
            next_state[16] = current_state[1] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[7] ^ current_state[9] ^ current_state[10] ^ current_state[15] ^ current_state[16] ^ current_state[17] ^ current_state[18] ^ current_state[21] ^ current_state[22];
            next_state[17] = current_state[0] ^ current_state[4] ^ current_state[6] ^ current_state[10] ^ current_state[11] ^ current_state[17] ^ current_state[18] ^ current_state[19] ^ current_state[21] ^ current_state[22];
            next_state[18] = current_state[0] ^ current_state[1] ^ current_state[2] ^ current_state[7] ^ current_state[8] ^ current_state[11] ^ current_state[12] ^ current_state[16] ^ current_state[18] ^ current_state[19] ^ current_state[20] ^ current_state[21] ^ current_state[22];
            next_state[19] = current_state[0] ^ current_state[1] ^ current_state[3] ^ current_state[5] ^ current_state[9] ^ current_state[12] ^ current_state[13] ^ current_state[16] ^ current_state[17] ^ current_state[19] ^ current_state[20] ^ current_state[22];
            next_state[20] = current_state[0] ^ current_state[1] ^ current_state[4] ^ current_state[5] ^ current_state[6] ^ current_state[8] ^ current_state[10] ^ current_state[13] ^ current_state[14] ^ current_state[16] ^ current_state[17] ^ current_state[18] ^ current_state[20];
            next_state[21] = current_state[1] ^ current_state[2] ^ current_state[5] ^ current_state[6] ^ current_state[7] ^ current_state[9] ^ current_state[11] ^ current_state[14] ^ current_state[15] ^ current_state[17] ^ current_state[18] ^ current_state[19] ^ current_state[21];
            next_state[22] = current_state[2] ^ current_state[3] ^ current_state[6] ^ current_state[7] ^ current_state[8] ^ current_state[10] ^ current_state[12] ^ current_state[15] ^ current_state[16] ^ current_state[18] ^ current_state[19] ^ current_state[20] ^ current_state[22];
            next_state[23] = current_state[0] ^ current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[7] ^ current_state[9] ^ current_state[11] ^ current_state[13] ^ current_state[17] ^ current_state[19] ^ current_state[20];
            next_state[24] = current_state[1] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[6] ^ current_state[8] ^ current_state[10] ^ current_state[12] ^ current_state[14] ^ current_state[18] ^ current_state[20] ^ current_state[21];
            next_state[25] = current_state[2] ^ current_state[4] ^ current_state[5] ^ current_state[6] ^ current_state[7] ^ current_state[9] ^ current_state[11] ^ current_state[13] ^ current_state[15] ^ current_state[19] ^ current_state[21] ^ current_state[22];
            next_state[26] = current_state[0] ^ current_state[2] ^ current_state[3] ^ current_state[6] ^ current_state[7] ^ current_state[10] ^ current_state[12] ^ current_state[14] ^ current_state[20] ^ current_state[21] ^ current_state[22];
            next_state[27] = current_state[0] ^ current_state[1] ^ current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[7] ^ current_state[11] ^ current_state[13] ^ current_state[15] ^ current_state[16] ^ current_state[22];
            next_state[28] = current_state[0] ^ current_state[1] ^ current_state[3] ^ current_state[4] ^ current_state[6] ^ current_state[12] ^ current_state[14] ^ current_state[17] ^ current_state[21];
            next_state[29] = current_state[1] ^ current_state[2] ^ current_state[4] ^ current_state[5] ^ current_state[7] ^ current_state[13] ^ current_state[15] ^ current_state[18] ^ current_state[22];
            next_state[30] = current_state[0] ^ current_state[3] ^ current_state[6] ^ current_state[14] ^ current_state[19] ^ current_state[21];
            next_state[31] = current_state[1] ^ current_state[4] ^ current_state[7] ^ current_state[15] ^ current_state[20] ^ current_state[22];
            next_lfsr_state = next_state;
        end
    endfunction

    // Main always block for state machine and logic
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            counter_lfsr <= 0;
            counter_per_lane <= 0;
            o_Lfsr_tx_done <= 0;
            o_enable_frame <= 0;
            lane_reversal_enabled <= 0; // Reset reversal state
            o_lane_0 <= 0; o_lane_1 <= 0; o_lane_2 <= 0; o_lane_3 <= 0;
            o_lane_4 <= 0; o_lane_5 <= 0; o_lane_6 <= 0; o_lane_7 <= 0;
            o_lane_8 <= 0; o_lane_9 <= 0; o_lane_10 <= 0; o_lane_11 <= 0;
            o_lane_12 <= 0; o_lane_13 <= 0; o_lane_14 <= 0; o_lane_15 <= 0;
            o_lane_0_23 <= 0; o_lane_1_23 <= 0; o_lane_2_23 <= 0; o_lane_3_23 <= 0;
            o_lane_4_23 <= 0; o_lane_5_23 <= 0; o_lane_6_23 <= 0; o_lane_7_23 <= 0;
            // Normal initial values
            tx_lfsr_lane_0 <= 23'h1DBFBC; tx_lfsr_lane_1 <= 23'h0607BB;
            tx_lfsr_lane_2 <= 23'h1EC760; tx_lfsr_lane_3 <= 23'h18C0DB;
            tx_lfsr_lane_4 <= 23'h010F12; tx_lfsr_lane_5 <= 23'h19CFC9;
            tx_lfsr_lane_6 <= 23'h0277CE; tx_lfsr_lane_7 <= 23'h1BB807;
        end
        else begin
            // Default outputs
            o_lane_0 <= 0; o_lane_1 <= 0; o_lane_2 <= 0; o_lane_3 <= 0;
            o_lane_4 <= 0; o_lane_5 <= 0; o_lane_6 <= 0; o_lane_7 <= 0;
            o_lane_8 <= 0; o_lane_9 <= 0; o_lane_10 <= 0; o_lane_11 <= 0;
            o_lane_12 <= 0; o_lane_13 <= 0; o_lane_14 <= 0; o_lane_15 <= 0;

            case (i_state)
                IDLE: begin
                    counter_lfsr <= 0;
                    counter_per_lane <= 0;
                    o_enable_frame <= 0;
                if (i_enable_reversal && Not_Rev_Degrade ) begin
                    lane_reversal_enabled<=1;
                    o_Lfsr_tx_done <= 1;
                    end
            else begin
         o_Lfsr_tx_done <= 0;
            end
                end
                Clear_lfsr: begin
                        tx_lfsr_lane_0 <= 23'h1DBFBC; tx_lfsr_lane_1 <= 23'h0607BB;
                        tx_lfsr_lane_2 <= 23'h1EC760; tx_lfsr_lane_3 <= 23'h18C0DB;
                        tx_lfsr_lane_4 <= 23'h010F12; tx_lfsr_lane_5 <= 23'h19CFC9;
                        tx_lfsr_lane_6 <= 23'h0277CE; tx_lfsr_lane_7 <= 23'h1BB807;
                        o_lane_0_23 <= 0;
                        o_lane_1_23 <= 0;
                        o_lane_2_23 <= 0;
                        o_lane_3_23 <= 0;
                        o_lane_4_23 <= 0;
                        o_lane_5_23 <= 0;
                        o_lane_6_23 <= 0;
                        o_lane_7_23 <= 0;
                        o_Lfsr_tx_done <= 1;
                end

                PATTERN_LFSR: begin
                    // Update LFSR states
                    {o_lane_0_23, tx_lfsr_lane_0} <= next_lfsr_state(tx_lfsr_lane_0);
                    {o_lane_1_23, tx_lfsr_lane_1} <= next_lfsr_state(tx_lfsr_lane_1);
                    {o_lane_2_23, tx_lfsr_lane_2} <= next_lfsr_state(tx_lfsr_lane_2);
                    {o_lane_3_23, tx_lfsr_lane_3} <= next_lfsr_state(tx_lfsr_lane_3);
                    {o_lane_4_23, tx_lfsr_lane_4} <= next_lfsr_state(tx_lfsr_lane_4);
                    {o_lane_5_23, tx_lfsr_lane_5} <= next_lfsr_state(tx_lfsr_lane_5);
                    {o_lane_6_23, tx_lfsr_lane_6} <= next_lfsr_state(tx_lfsr_lane_6);
                    {o_lane_7_23, tx_lfsr_lane_7} <= next_lfsr_state(tx_lfsr_lane_7);

                    if (i_enable_scrambeling_pattern) begin
                        o_enable_frame <= 1;
                        case (i_functional_tx_lanes)
                            DEGRADE_LANES_0_TO_7: begin
                                o_lane_0 <= {o_lane_0_23, tx_lfsr_lane_0} ^ i_lane_0;
                                o_lane_1 <= {o_lane_1_23, tx_lfsr_lane_1} ^ i_lane_1;
                                o_lane_2 <= {o_lane_2_23, tx_lfsr_lane_2} ^ i_lane_2;
                                o_lane_3 <= {o_lane_3_23, tx_lfsr_lane_3} ^ i_lane_3;
                                o_lane_4 <= {o_lane_4_23, tx_lfsr_lane_4} ^ i_lane_4;
                                o_lane_5 <= {o_lane_5_23, tx_lfsr_lane_5} ^ i_lane_5;
                                o_lane_6 <= {o_lane_6_23, tx_lfsr_lane_6} ^ i_lane_6;
                                o_lane_7 <= {o_lane_7_23, tx_lfsr_lane_7} ^ i_lane_7;
                            end
                            DEGRADE_LANES_8_TO_15: begin
                                o_lane_8  <= {o_lane_0_23, tx_lfsr_lane_0} ^ i_lane_8;
                                o_lane_9  <= {o_lane_1_23, tx_lfsr_lane_1} ^ i_lane_9;
                                o_lane_10 <= {o_lane_2_23, tx_lfsr_lane_2} ^ i_lane_10;
                                o_lane_11 <= {o_lane_3_23, tx_lfsr_lane_3} ^ i_lane_11;
                                o_lane_12 <= {o_lane_4_23, tx_lfsr_lane_4} ^ i_lane_12;
                                o_lane_13 <= {o_lane_5_23, tx_lfsr_lane_5} ^ i_lane_13;
                                o_lane_14 <= {o_lane_6_23, tx_lfsr_lane_6} ^ i_lane_14;
                                o_lane_15 <= {o_lane_7_23, tx_lfsr_lane_7} ^ i_lane_15;
                            end
                               DEGRADE_LANES_0_TO_15: begin
                                if (lane_reversal_enabled) begin
                                    o_lane_0  <= {o_lane_7_23, tx_lfsr_lane_7} ^ i_lane_15;
                                    o_lane_1  <= {o_lane_6_23, tx_lfsr_lane_6} ^ i_lane_14;
                                    o_lane_2  <= {o_lane_5_23, tx_lfsr_lane_5} ^ i_lane_13;
                                    o_lane_3  <= {o_lane_4_23, tx_lfsr_lane_4} ^ i_lane_12;
                                    o_lane_4  <= {o_lane_3_23, tx_lfsr_lane_3} ^ i_lane_11;
                                    o_lane_5  <= {o_lane_2_23, tx_lfsr_lane_2} ^ i_lane_10;
                                    o_lane_6  <= {o_lane_1_23, tx_lfsr_lane_1} ^ i_lane_9;
                                    o_lane_7  <= {o_lane_0_23, tx_lfsr_lane_0} ^ i_lane_8;
                                    o_lane_8  <= {o_lane_7_23, tx_lfsr_lane_7} ^ i_lane_7;
                                    o_lane_9  <= {o_lane_6_23, tx_lfsr_lane_6} ^ i_lane_6;
                                    o_lane_10 <= {o_lane_5_23, tx_lfsr_lane_5} ^ i_lane_5;
                                    o_lane_11 <= {o_lane_4_23, tx_lfsr_lane_4} ^ i_lane_4;
                                    o_lane_12 <= {o_lane_3_23, tx_lfsr_lane_3} ^ i_lane_3;
                                    o_lane_13 <= {o_lane_2_23, tx_lfsr_lane_2} ^ i_lane_2;
                                    o_lane_14 <= {o_lane_1_23, tx_lfsr_lane_1} ^ i_lane_1;
                                    o_lane_15 <= {o_lane_0_23, tx_lfsr_lane_0} ^ i_lane_0;
                                end else begin
                                    o_lane_0  <= {o_lane_0_23, tx_lfsr_lane_0} ^ i_lane_0;
                                    o_lane_1  <= {o_lane_1_23, tx_lfsr_lane_1} ^ i_lane_1;
                                    o_lane_2  <= {o_lane_2_23, tx_lfsr_lane_2} ^ i_lane_2;
                                    o_lane_3  <= {o_lane_3_23, tx_lfsr_lane_3} ^ i_lane_3;
                                    o_lane_4  <= {o_lane_4_23, tx_lfsr_lane_4} ^ i_lane_4;
                                    o_lane_5  <= {o_lane_5_23, tx_lfsr_lane_5} ^ i_lane_5;
                                    o_lane_6  <= {o_lane_6_23, tx_lfsr_lane_6} ^ i_lane_6;
                                    o_lane_7  <= {o_lane_7_23, tx_lfsr_lane_7} ^ i_lane_7;
                                    o_lane_8  <= {o_lane_0_23, tx_lfsr_lane_0} ^ i_lane_8;
                                    o_lane_9  <= {o_lane_1_23, tx_lfsr_lane_1} ^ i_lane_9;
                                    o_lane_10 <= {o_lane_2_23, tx_lfsr_lane_2} ^ i_lane_10;
                                    o_lane_11 <= {o_lane_3_23, tx_lfsr_lane_3} ^ i_lane_11;
                                    o_lane_12 <= {o_lane_4_23, tx_lfsr_lane_4} ^ i_lane_12;
                                    o_lane_13 <= {o_lane_5_23, tx_lfsr_lane_5} ^ i_lane_13;
                                    o_lane_14 <= {o_lane_6_23, tx_lfsr_lane_6} ^ i_lane_14;
                                    o_lane_15 <= {o_lane_7_23, tx_lfsr_lane_7} ^ i_lane_15;
                                end
                            end
                        endcase
                    end
                    else begin
                        case (i_functional_tx_lanes)
                            DEGRADE_LANES_0_TO_7: begin
                                if (counter_lfsr == 127) begin
                                    counter_lfsr <= 0;
                                    o_Lfsr_tx_done <= 1;
                                    o_enable_frame <= 0;
                                end else begin
                                    o_lane_0 <= {o_lane_0_23, tx_lfsr_lane_0};
                                    o_lane_1 <= {o_lane_1_23, tx_lfsr_lane_1};
                                    o_lane_2 <= {o_lane_2_23, tx_lfsr_lane_2};
                                    o_lane_3 <= {o_lane_3_23, tx_lfsr_lane_3};
                                    o_lane_4 <= {o_lane_4_23, tx_lfsr_lane_4};
                                    o_lane_5 <= {o_lane_5_23, tx_lfsr_lane_5};
                                    o_lane_6 <= {o_lane_6_23, tx_lfsr_lane_6};
                                    o_lane_7 <= {o_lane_7_23, tx_lfsr_lane_7};
                                    counter_lfsr <= counter_lfsr + 1;
                                    o_Lfsr_tx_done <= 0;
                                    o_enable_frame <= 1;
                                end
                            end
                            DEGRADE_LANES_8_TO_15: begin
                                if (counter_lfsr == 127) begin
                                    counter_lfsr <= 0;
                                    o_Lfsr_tx_done <= 1;
                                    o_enable_frame <= 0;
                                end else begin
                                    o_lane_8  <= {o_lane_0_23, tx_lfsr_lane_0};
                                    o_lane_9  <= {o_lane_1_23, tx_lfsr_lane_1};
                                    o_lane_10 <= {o_lane_2_23, tx_lfsr_lane_2};
                                    o_lane_11 <= {o_lane_3_23, tx_lfsr_lane_3};
                                    o_lane_12 <= {o_lane_4_23, tx_lfsr_lane_4};
                                    o_lane_13 <= {o_lane_5_23, tx_lfsr_lane_5};
                                    o_lane_14 <= {o_lane_6_23, tx_lfsr_lane_6};
                                    o_lane_15 <= {o_lane_7_23, tx_lfsr_lane_7};
                                    counter_lfsr <= counter_lfsr + 1;
                                    o_Lfsr_tx_done <= 0;
                                    o_enable_frame <= 1;
                                end
                            end
                            DEGRADE_LANES_0_TO_15: begin
                                if (counter_lfsr == 127) begin
                                    counter_lfsr <= 0;
                                    o_Lfsr_tx_done <= 1;
                                    o_enable_frame <= 0;
                                end else begin
                                    if (lane_reversal_enabled) begin
                                        o_lane_0  <= {o_lane_7_23, tx_lfsr_lane_7};
                                        o_lane_1  <= {o_lane_6_23, tx_lfsr_lane_6};
                                        o_lane_2  <= {o_lane_5_23, tx_lfsr_lane_5};
                                        o_lane_3  <= {o_lane_4_23, tx_lfsr_lane_4};
                                        o_lane_4  <= {o_lane_3_23, tx_lfsr_lane_3};
                                        o_lane_5  <= {o_lane_2_23, tx_lfsr_lane_2};
                                        o_lane_6  <= {o_lane_1_23, tx_lfsr_lane_1};
                                        o_lane_7  <= {o_lane_0_23, tx_lfsr_lane_0};
                                        o_lane_8  <= {o_lane_7_23, tx_lfsr_lane_7};
                                        o_lane_9  <= {o_lane_6_23, tx_lfsr_lane_6};
                                        o_lane_10 <= {o_lane_5_23, tx_lfsr_lane_5};
                                        o_lane_11 <= {o_lane_4_23, tx_lfsr_lane_4};
                                        o_lane_12 <= {o_lane_3_23, tx_lfsr_lane_3};
                                        o_lane_13 <= {o_lane_2_23, tx_lfsr_lane_2};
                                        o_lane_14 <= {o_lane_1_23, tx_lfsr_lane_1};
                                        o_lane_15 <= {o_lane_0_23, tx_lfsr_lane_0};
                                    end else begin
                                        o_lane_0  <= {o_lane_0_23, tx_lfsr_lane_0};
                                        o_lane_1  <= {o_lane_1_23, tx_lfsr_lane_1};
                                        o_lane_2  <= {o_lane_2_23, tx_lfsr_lane_2};
                                        o_lane_3  <= {o_lane_3_23, tx_lfsr_lane_3};
                                        o_lane_4  <= {o_lane_4_23, tx_lfsr_lane_4};
                                        o_lane_5  <= {o_lane_5_23, tx_lfsr_lane_5};
                                        o_lane_6  <= {o_lane_6_23, tx_lfsr_lane_6};
                                        o_lane_7  <= {o_lane_7_23, tx_lfsr_lane_7};
                                        o_lane_8  <= {o_lane_0_23, tx_lfsr_lane_0};
                                        o_lane_9  <= {o_lane_1_23, tx_lfsr_lane_1};
                                        o_lane_10 <= {o_lane_2_23, tx_lfsr_lane_2};
                                        o_lane_11 <= {o_lane_3_23, tx_lfsr_lane_3};
                                        o_lane_12 <= {o_lane_4_23, tx_lfsr_lane_4};
                                        o_lane_13 <= {o_lane_5_23, tx_lfsr_lane_5};
                                        o_lane_14 <= {o_lane_6_23, tx_lfsr_lane_6};
                                        o_lane_15 <= {o_lane_7_23, tx_lfsr_lane_7};
                                    end
                                    counter_lfsr <= counter_lfsr + 1;
                                    o_Lfsr_tx_done <= 0;
                                    o_enable_frame <= 1;
                                end
                            end
                        endcase
                    end
                end

                PER_LANE_IDE: begin
                    case (i_functional_tx_lanes)
                        DEGRADE_LANES_0_TO_7: begin
                            if (counter_per_lane == 63) begin
                                counter_per_lane <= 0;
                                o_Lfsr_tx_done <= 1;
                                o_enable_frame <= 0;
                            end else begin
                                o_lane_0  <= {LANE_ID_0, LANE_ID_0};
                                o_lane_1  <= {LANE_ID_1, LANE_ID_1};
                                o_lane_2  <= {LANE_ID_2, LANE_ID_2};
                                o_lane_3  <= {LANE_ID_3, LANE_ID_3};
                                o_lane_4  <= {LANE_ID_4, LANE_ID_4};
                                o_lane_5  <= {LANE_ID_5, LANE_ID_5};
                                o_lane_6  <= {LANE_ID_6, LANE_ID_6};
                                o_lane_7  <= {LANE_ID_7, LANE_ID_7};
                                counter_per_lane <= counter_per_lane + 1;
                                o_Lfsr_tx_done <= 0;
                                o_enable_frame <= 1;
                            end
                        end
                        DEGRADE_LANES_8_TO_15: begin
                            if (counter_per_lane == 63) begin
                                counter_per_lane <= 0;
                                o_Lfsr_tx_done <= 1;
                                o_enable_frame <= 0;
                            end else begin
                                o_lane_8  <= {LANE_ID_8, LANE_ID_8};
                                o_lane_9  <= {LANE_ID_9, LANE_ID_9};
                                o_lane_10 <= {LANE_ID_10, LANE_ID_10};
                                o_lane_11 <= {LANE_ID_11, LANE_ID_11};
                                o_lane_12 <= {LANE_ID_12, LANE_ID_12};
                                o_lane_13 <= {LANE_ID_13, LANE_ID_13};
                                o_lane_14 <= {LANE_ID_14, LANE_ID_14};
                                o_lane_15 <= {LANE_ID_15, LANE_ID_15};
                                counter_per_lane <= counter_per_lane + 1;
                                o_Lfsr_tx_done <= 0;
                                o_enable_frame <= 1;
                            end
                        end
                      DEGRADE_LANES_0_TO_15: begin
                            if (counter_per_lane == 63) begin
                                counter_per_lane <= 0;
                                o_Lfsr_tx_done <= 1;
                                o_enable_frame <= 0;
                            end else begin
                                if (lane_reversal_enabled) begin
                                    o_lane_0  <= {LANE_ID_15, LANE_ID_15};
                                    o_lane_1  <= {LANE_ID_14, LANE_ID_14};
                                    o_lane_2  <= {LANE_ID_13, LANE_ID_13};
                                    o_lane_3  <= {LANE_ID_12, LANE_ID_12};
                                    o_lane_4  <= {LANE_ID_11, LANE_ID_11};
                                    o_lane_5  <= {LANE_ID_10, LANE_ID_10};
                                    o_lane_6  <= {LANE_ID_9, LANE_ID_9};
                                    o_lane_7  <= {LANE_ID_8, LANE_ID_8};
                                    o_lane_8  <= {LANE_ID_7, LANE_ID_7};
                                    o_lane_9  <= {LANE_ID_6, LANE_ID_6};
                                    o_lane_10 <= {LANE_ID_5, LANE_ID_5};
                                    o_lane_11 <= {LANE_ID_4, LANE_ID_4};
                                    o_lane_12 <= {LANE_ID_3, LANE_ID_3};
                                    o_lane_13 <= {LANE_ID_2, LANE_ID_2};
                                    o_lane_14 <= {LANE_ID_1, LANE_ID_1};
                                    o_lane_15 <= {LANE_ID_0, LANE_ID_0};
                                end else begin
                                    o_lane_0  <= {LANE_ID_0, LANE_ID_0};
                                    o_lane_1  <= {LANE_ID_1, LANE_ID_1};
                                    o_lane_2  <= {LANE_ID_2, LANE_ID_2};
                                    o_lane_3  <= {LANE_ID_3, LANE_ID_3};
                                    o_lane_4  <= {LANE_ID_4, LANE_ID_4};
                                    o_lane_5  <= {LANE_ID_5, LANE_ID_5};
                                    o_lane_6  <= {LANE_ID_6, LANE_ID_6};
                                    o_lane_7  <= {LANE_ID_7, LANE_ID_7};
                                    o_lane_8  <= {LANE_ID_8, LANE_ID_8};
                                    o_lane_9  <= {LANE_ID_9, LANE_ID_9};
                                    o_lane_10 <= {LANE_ID_10, LANE_ID_10};
                                    o_lane_11 <= {LANE_ID_11, LANE_ID_11};
                                    o_lane_12 <= {LANE_ID_12, LANE_ID_12};
                                    o_lane_13 <= {LANE_ID_13, LANE_ID_13};
                                    o_lane_14 <= {LANE_ID_14, LANE_ID_14};
                                    o_lane_15 <= {LANE_ID_15, LANE_ID_15};
                                end
                                counter_per_lane <= counter_per_lane + 1;
                                o_Lfsr_tx_done <= 0;
                                o_enable_frame <= 1;
                            end
                        end
                    endcase
                end
            endcase
        end
    end
endmodule