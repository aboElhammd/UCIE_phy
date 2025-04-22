module LFSR_Receiver #(
    parameter WIDTH = 32 // Parameter for signal WIDTH
)(
    input i_clk,
    input i_rst_n,
    input [1:0] i_state,
    input [1:0] i_functional_rx_lanes, // Lane mapping code
    input wire i_enable_Descrambeling_pattern, // Enable scrambling pattern
    input i_enable_buffer,                   // Enable for Data Come from buffer
    // Input from DESERIALIZER 
    input wire [WIDTH-1:0] i_data_in_0, i_data_in_1, i_data_in_2, i_data_in_3, i_data_in_4, i_data_in_5,
    input wire [WIDTH-1:0] i_data_in_6, i_data_in_7, i_data_in_8, i_data_in_9,
    input wire [WIDTH-1:0] i_data_in_10, i_data_in_11, i_data_in_12, i_data_in_13,
    input wire [WIDTH-1:0] i_data_in_14, i_data_in_15,
    // Output of pattern bypass
    output reg [WIDTH-1:0] o_Data_by_0, o_Data_by_1, o_Data_by_2, o_Data_by_3, o_Data_by_4,
    output reg [WIDTH-1:0] o_Data_by_5, o_Data_by_6, o_Data_by_7, o_Data_by_8,
    output reg [WIDTH-1:0] o_Data_by_9, o_Data_by_10, o_Data_by_11, o_Data_by_12,
    output reg [WIDTH-1:0] o_Data_by_13, o_Data_by_14, o_Data_by_15,
    // Output from locally generated parameter
    output reg [WIDTH-1:0] o_final_gene_0, o_final_gene_1, o_final_gene_2, o_final_gene_3,
    output reg [WIDTH-1:0] o_final_gene_4, o_final_gene_5, o_final_gene_6, o_final_gene_7,
    output reg [WIDTH-1:0] o_final_gene_8, o_final_gene_9, o_final_gene_10, o_final_gene_11,
    output reg [WIDTH-1:0] o_final_gene_12, o_final_gene_13, o_final_gene_14, o_final_gene_15,
    output wire enable_pattern_comparitor
);

assign enable_pattern_comparitor = (i_state == 2'b10 && i_enable_Descrambeling_pattern && !i_enable_buffer) ? 0 : 1;

// Declare LFSR registers for each lane
reg [8:0] o_lane_0_23, o_lane_1_23, o_lane_2_23, o_lane_3_23;
reg [8:0] o_lane_4_23, o_lane_5_23, o_lane_6_23, o_lane_7_23;

// State definitions
localparam IDLE           = 2'b00; // Idle state
localparam CLEAR_LFSR     = 2'b01; // Clear LFSR pattern
localparam PATTERN_LFSR   = 2'b10; // LFSR pattern generation state
localparam PER_LANE_IDE   = 2'b11; // Per-lane identification state

// Lane configuration definitions
localparam DEGRADE_LANES_0_TO_7   = 2'b01;
localparam DEGRADE_LANES_8_TO_15  = 2'b10;
localparam DEGRADE_LANES_0_TO_15  = 2'b11;

// Define Lane IDs as parameters with prepended and appended 1010
parameter LANE_ID_0  = 16'b1010_00000000_1010;
parameter LANE_ID_1  = 16'b1010_00000001_1010;
parameter LANE_ID_2  = 16'b1010_00000010_1010;
parameter LANE_ID_3  = 16'b1010_00000011_1010;
parameter LANE_ID_4  = 16'b1010_00000100_1010;
parameter LANE_ID_5  = 16'b1010_00000101_1010;
parameter LANE_ID_6  = 16'b1010_00000110_1010;
parameter LANE_ID_7  = 16'b1010_00000111_1010;
parameter LANE_ID_8  = 16'b1010_00001000_1010;
parameter LANE_ID_9  = 16'b1010_00001001_1010;
parameter LANE_ID_10 = 16'b1010_00001010_1010;
parameter LANE_ID_11 = 16'b1010_00001011_1010;
parameter LANE_ID_12 = 16'b1010_00001100_1010;
parameter LANE_ID_13 = 16'b1010_00001101_1010;
parameter LANE_ID_14 = 16'b1010_00001110_1010;
parameter LANE_ID_15 = 16'b1010_00001111_1010;

// Internal signals and registers
reg [1:0] delay_counter; // 2-bit counter to track 2 clock cycles
reg cont;
// Declare LFSR registers for each lane
reg [22:0] rx_lfsr_lane_0, rx_lfsr_lane_1, rx_lfsr_lane_2, rx_lfsr_lane_3;
reg [22:0] rx_lfsr_lane_4, rx_lfsr_lane_5, rx_lfsr_lane_6, rx_lfsr_lane_7;

// Temporary registers for delaying o_Data_by_* by 1 clock cycle
reg [WIDTH-1:0] temp_Data_by_0, temp_Data_by_1, temp_Data_by_2, temp_Data_by_3;
reg [WIDTH-1:0] temp_Data_by_4, temp_Data_by_5, temp_Data_by_6, temp_Data_by_7;
reg [WIDTH-1:0] temp_Data_by_8, temp_Data_by_9, temp_Data_by_10, temp_Data_by_11;
reg [WIDTH-1:0] temp_Data_by_12, temp_Data_by_13, temp_Data_by_14, temp_Data_by_15;

// Function to compute the next LFSR state
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
        next_state[6]  = current_state[1] ^ current_state[2] ^ current_state[3] ^ current_state[4] ^ current_state[5] ^ current_state[6] ^ current_state[7] ^ current_state[8] ^ current_state[10] ^ current_state[14] ^ current_state[16] ^ current_state[17] ^ current_state[18] ^ current_state[20] ^ current_state[22];
        next_state[7]  = current_state[0] ^ current_state[3] ^ current_state[4] ^ current_state[6] ^ current_state[7] ^ current_state[9] ^ current_state[11] ^ current_state[15] ^ current_state[16] ^ current_state[17] ^ current_state[18] ^ current_state[19];
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

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        // Reset temporary registers
        {temp_Data_by_0, temp_Data_by_1, temp_Data_by_2, temp_Data_by_3, temp_Data_by_4, temp_Data_by_5, temp_Data_by_6, temp_Data_by_7,
         temp_Data_by_8, temp_Data_by_9, temp_Data_by_10, temp_Data_by_11, temp_Data_by_12, temp_Data_by_13, temp_Data_by_14, temp_Data_by_15} <= 0;
        // Reset output registers
        
        {o_final_gene_0, o_final_gene_1, o_final_gene_2, o_final_gene_3, o_final_gene_4, o_final_gene_5, o_final_gene_6, o_final_gene_7,
         o_final_gene_8, o_final_gene_9, o_final_gene_10, o_final_gene_11, o_final_gene_12, o_final_gene_13, o_final_gene_14, o_final_gene_15} <= 0;
               
        // Initialize LFSR registers with predefined seeds
        rx_lfsr_lane_0  <= 23'h1DBFBC; rx_lfsr_lane_1  <= 23'h0607BB; rx_lfsr_lane_2  <= 23'h1EC760; rx_lfsr_lane_3  <= 23'h18C0DB;
        rx_lfsr_lane_4  <= 23'h010F12; rx_lfsr_lane_5  <= 23'h19CFC9; rx_lfsr_lane_6  <= 23'h0277CE; rx_lfsr_lane_7  <= 23'h1BB807;

        o_lane_0_23 <= 0; o_lane_1_23 <= 0; o_lane_2_23 <= 0; o_lane_3_23 <= 0;
        o_lane_4_23 <= 0; o_lane_5_23 <= 0; o_lane_6_23 <= 0; o_lane_7_23 <= 0;
    end
    else begin  
        {o_final_gene_0, o_final_gene_1, o_final_gene_2, o_final_gene_3, o_final_gene_4, o_final_gene_5, o_final_gene_6, o_final_gene_7,
         o_final_gene_8, o_final_gene_9, o_final_gene_10, o_final_gene_11, o_final_gene_12, o_final_gene_13, o_final_gene_14, o_final_gene_15} <= 0;

        case (i_state)
            IDLE: begin
                temp_Data_by_0 <= i_data_in_0; temp_Data_by_1 <= i_data_in_1; temp_Data_by_2 <= i_data_in_2; temp_Data_by_3 <= i_data_in_3;
                temp_Data_by_4 <= i_data_in_4; temp_Data_by_5 <= i_data_in_5; temp_Data_by_6 <= i_data_in_6; temp_Data_by_7 <= i_data_in_7;
                temp_Data_by_8 <= i_data_in_8; temp_Data_by_9 <= i_data_in_9; temp_Data_by_10 <= i_data_in_10; temp_Data_by_11 <= i_data_in_11;
                temp_Data_by_12 <= i_data_in_12; temp_Data_by_13 <= i_data_in_13; temp_Data_by_14 <= i_data_in_14; temp_Data_by_15 <= i_data_in_15;
            end

            CLEAR_LFSR: begin
                // Reset LFSR registers to initial seeds
                rx_lfsr_lane_0  <= 23'h1DBFBC; rx_lfsr_lane_1  <= 23'h0607BB; rx_lfsr_lane_2  <= 23'h1EC760; rx_lfsr_lane_3  <= 23'h18C0DB;
                rx_lfsr_lane_4  <= 23'h010F12; rx_lfsr_lane_5  <= 23'h19CFC9; rx_lfsr_lane_6  <= 23'h0277CE; rx_lfsr_lane_7  <= 23'h1BB807;
                 temp_Data_by_0 <= i_data_in_0; temp_Data_by_1 <= i_data_in_1; temp_Data_by_2 <= i_data_in_2; temp_Data_by_3 <= i_data_in_3;
                        temp_Data_by_4 <= i_data_in_4; temp_Data_by_5 <= i_data_in_5; temp_Data_by_6 <= i_data_in_6; temp_Data_by_7 <= i_data_in_7;
                        temp_Data_by_8 <= i_data_in_8; temp_Data_by_9 <= i_data_in_9; temp_Data_by_10 <= i_data_in_10; temp_Data_by_11 <= i_data_in_11;
                        temp_Data_by_12 <= i_data_in_12; temp_Data_by_13 <= i_data_in_13; temp_Data_by_14 <= i_data_in_14; temp_Data_by_15 <= i_data_in_15;
            end

            PATTERN_LFSR: begin
                if (i_enable_buffer) begin
                    // First update all LFSR states
                    {o_lane_1_23, rx_lfsr_lane_1} <= next_lfsr_state(rx_lfsr_lane_1);
                    {o_lane_2_23, rx_lfsr_lane_2} <= next_lfsr_state(rx_lfsr_lane_2);
                    {o_lane_3_23, rx_lfsr_lane_3} <= next_lfsr_state(rx_lfsr_lane_3);
                    {o_lane_4_23, rx_lfsr_lane_4} <= next_lfsr_state(rx_lfsr_lane_4);
                    {o_lane_5_23, rx_lfsr_lane_5} <= next_lfsr_state(rx_lfsr_lane_5);
                    {o_lane_6_23, rx_lfsr_lane_6} <= next_lfsr_state(rx_lfsr_lane_6);
                    {o_lane_7_23, rx_lfsr_lane_7} <= next_lfsr_state(rx_lfsr_lane_7);
                    {o_lane_0_23, rx_lfsr_lane_0} <= next_lfsr_state(rx_lfsr_lane_0);

                    // Then check descrambling enable
                    if (i_enable_Descrambeling_pattern) begin
                        // Process based on current state
                        
                        case (i_functional_rx_lanes)
                            DEGRADE_LANES_0_TO_7: begin
                                temp_Data_by_0 <= {o_lane_0_23, rx_lfsr_lane_0} ^ i_data_in_0;
                                temp_Data_by_1 <= {o_lane_1_23, rx_lfsr_lane_1} ^ i_data_in_1;
                                temp_Data_by_2 <= {o_lane_2_23, rx_lfsr_lane_2} ^ i_data_in_2;
                                temp_Data_by_3 <= {o_lane_3_23, rx_lfsr_lane_3} ^ i_data_in_3;
                                temp_Data_by_4 <= {o_lane_4_23, rx_lfsr_lane_4} ^ i_data_in_4;
                                temp_Data_by_5 <= {o_lane_5_23, rx_lfsr_lane_5} ^ i_data_in_5;
                                temp_Data_by_6 <= {o_lane_6_23, rx_lfsr_lane_6} ^ i_data_in_6;
                                temp_Data_by_7 <= {o_lane_7_23, rx_lfsr_lane_7} ^ i_data_in_7;
                            end
                            DEGRADE_LANES_8_TO_15: begin
                                temp_Data_by_8  <= {o_lane_0_23, rx_lfsr_lane_0} ^ i_data_in_8;
                                temp_Data_by_9  <= {o_lane_1_23, rx_lfsr_lane_1} ^ i_data_in_9;
                                temp_Data_by_10 <= {o_lane_2_23, rx_lfsr_lane_2} ^ i_data_in_10;
                                temp_Data_by_11 <= {o_lane_3_23, rx_lfsr_lane_3} ^ i_data_in_11;
                                temp_Data_by_12 <= {o_lane_4_23, rx_lfsr_lane_4} ^ i_data_in_12;
                                temp_Data_by_13 <= {o_lane_5_23, rx_lfsr_lane_5} ^ i_data_in_13;
                                temp_Data_by_14 <= {o_lane_6_23, rx_lfsr_lane_6} ^ i_data_in_14;
                                temp_Data_by_15 <= {o_lane_7_23, rx_lfsr_lane_7} ^ i_data_in_15;
                            end
                            DEGRADE_LANES_0_TO_15: begin
                                temp_Data_by_0  <= {o_lane_0_23, rx_lfsr_lane_0} ^ i_data_in_0;
                                temp_Data_by_1  <= {o_lane_1_23, rx_lfsr_lane_1} ^ i_data_in_1;
                                temp_Data_by_2  <= {o_lane_2_23, rx_lfsr_lane_2} ^ i_data_in_2;
                                temp_Data_by_3  <= {o_lane_3_23, rx_lfsr_lane_3} ^ i_data_in_3;
                                temp_Data_by_4  <= {o_lane_4_23, rx_lfsr_lane_4} ^ i_data_in_4;
                                temp_Data_by_5  <= {o_lane_5_23, rx_lfsr_lane_5} ^ i_data_in_5;
                                temp_Data_by_6  <= {o_lane_6_23, rx_lfsr_lane_6} ^ i_data_in_6;
                                temp_Data_by_7  <= {o_lane_7_23, rx_lfsr_lane_7} ^ i_data_in_7;
                                temp_Data_by_8  <= {o_lane_0_23, rx_lfsr_lane_0} ^ i_data_in_8;
                                temp_Data_by_9  <= {o_lane_1_23, rx_lfsr_lane_1} ^ i_data_in_9;
                                temp_Data_by_10 <= {o_lane_2_23, rx_lfsr_lane_2} ^ i_data_in_10;
                                temp_Data_by_11 <= {o_lane_3_23, rx_lfsr_lane_3} ^ i_data_in_11;
                                temp_Data_by_12 <= {o_lane_4_23, rx_lfsr_lane_4} ^ i_data_in_12;
                                temp_Data_by_13 <= {o_lane_5_23, rx_lfsr_lane_5} ^ i_data_in_13;
                                temp_Data_by_14 <= {o_lane_6_23, rx_lfsr_lane_6} ^ i_data_in_14;
                                temp_Data_by_15 <= {o_lane_7_23, rx_lfsr_lane_7} ^ i_data_in_15;
                            end
                        endcase
                    end
                    else begin
                         temp_Data_by_0 <= i_data_in_0; temp_Data_by_1 <= i_data_in_1; temp_Data_by_2 <= i_data_in_2; temp_Data_by_3 <= i_data_in_3;
                        temp_Data_by_4 <= i_data_in_4; temp_Data_by_5 <= i_data_in_5; temp_Data_by_6 <= i_data_in_6; temp_Data_by_7 <= i_data_in_7;
                        temp_Data_by_8 <= i_data_in_8; temp_Data_by_9 <= i_data_in_9; temp_Data_by_10 <= i_data_in_10; temp_Data_by_11 <= i_data_in_11;
                        temp_Data_by_12 <= i_data_in_12; temp_Data_by_13 <= i_data_in_13; temp_Data_by_14 <= i_data_in_14; temp_Data_by_15 <= i_data_in_15;
                      

                        // Generate local LFSR patterns
                        case (i_functional_rx_lanes)
                            DEGRADE_LANES_0_TO_7: begin
                                o_final_gene_0 <= {o_lane_0_23, rx_lfsr_lane_0};
                                o_final_gene_1 <= {o_lane_1_23, rx_lfsr_lane_1};
                                o_final_gene_2 <= {o_lane_2_23, rx_lfsr_lane_2};
                                o_final_gene_3 <= {o_lane_3_23, rx_lfsr_lane_3};
                                o_final_gene_4 <= {o_lane_4_23, rx_lfsr_lane_4};
                                o_final_gene_5 <= {o_lane_5_23, rx_lfsr_lane_5};
                                o_final_gene_6 <= {o_lane_6_23, rx_lfsr_lane_6};
                                o_final_gene_7 <= {o_lane_7_23, rx_lfsr_lane_7};
                            end
                            DEGRADE_LANES_8_TO_15: begin
                                o_final_gene_8  <= {o_lane_0_23, rx_lfsr_lane_0};
                                o_final_gene_9  <= {o_lane_1_23, rx_lfsr_lane_1};
                                o_final_gene_10 <= {o_lane_2_23, rx_lfsr_lane_2};
                                o_final_gene_11 <= {o_lane_3_23, rx_lfsr_lane_3};
                                o_final_gene_12 <= {o_lane_4_23, rx_lfsr_lane_4};
                                o_final_gene_13 <= {o_lane_5_23, rx_lfsr_lane_5};
                                o_final_gene_14 <= {o_lane_6_23, rx_lfsr_lane_6};
                                o_final_gene_15 <= {o_lane_7_23, rx_lfsr_lane_7};
                            end
                            DEGRADE_LANES_0_TO_15: begin
                                o_final_gene_0  <= {o_lane_0_23, rx_lfsr_lane_0};
                                o_final_gene_1  <= {o_lane_1_23, rx_lfsr_lane_1};
                                o_final_gene_2  <= {o_lane_2_23, rx_lfsr_lane_2};
                                o_final_gene_3  <= {o_lane_3_23, rx_lfsr_lane_3};
                                o_final_gene_4  <= {o_lane_4_23, rx_lfsr_lane_4};
                                o_final_gene_5  <= {o_lane_5_23, rx_lfsr_lane_5};
                                o_final_gene_6  <= {o_lane_6_23, rx_lfsr_lane_6};
                                o_final_gene_7  <= {o_lane_7_23, rx_lfsr_lane_7};
                                o_final_gene_8  <= {o_lane_0_23, rx_lfsr_lane_0};
                                o_final_gene_9  <= {o_lane_1_23, rx_lfsr_lane_1};
                                o_final_gene_10 <= {o_lane_2_23, rx_lfsr_lane_2};
                                o_final_gene_11 <= {o_lane_3_23, rx_lfsr_lane_3};
                                o_final_gene_12 <= {o_lane_4_23, rx_lfsr_lane_4};
                                o_final_gene_13 <= {o_lane_5_23, rx_lfsr_lane_5};
                                o_final_gene_14 <= {o_lane_6_23, rx_lfsr_lane_6};
                                o_final_gene_15 <= {o_lane_7_23, rx_lfsr_lane_7};
                            end
                        endcase
                    end
                end
            end

            PER_LANE_IDE: begin
                if (i_enable_buffer) begin
                    temp_Data_by_0 <= i_data_in_0; temp_Data_by_1 <= i_data_in_1; temp_Data_by_2 <= i_data_in_2; temp_Data_by_3 <= i_data_in_3;
                    temp_Data_by_4 <= i_data_in_4; temp_Data_by_5 <= i_data_in_5; temp_Data_by_6 <= i_data_in_6; temp_Data_by_7 <= i_data_in_7;
                    temp_Data_by_8 <= i_data_in_8; temp_Data_by_9 <= i_data_in_9; temp_Data_by_10 <= i_data_in_10; temp_Data_by_11 <= i_data_in_11;
                    temp_Data_by_12 <= i_data_in_12; temp_Data_by_13 <= i_data_in_13; temp_Data_by_14 <= i_data_in_14; temp_Data_by_15 <= i_data_in_15;
                    case (i_functional_rx_lanes)
                        DEGRADE_LANES_0_TO_7: begin
                            o_final_gene_0 <= {LANE_ID_0, LANE_ID_0};
                            o_final_gene_1 <= {LANE_ID_1, LANE_ID_1};
                            o_final_gene_2 <= {LANE_ID_2, LANE_ID_2};
                            o_final_gene_3 <= {LANE_ID_3, LANE_ID_3};
                            o_final_gene_4 <= {LANE_ID_4, LANE_ID_4};
                            o_final_gene_5 <= {LANE_ID_5, LANE_ID_5};
                            o_final_gene_6 <= {LANE_ID_6, LANE_ID_6};
                            o_final_gene_7 <= {LANE_ID_7, LANE_ID_7};
                        end
                        DEGRADE_LANES_8_TO_15: begin
                            o_final_gene_8  <= {LANE_ID_8, LANE_ID_8};
                            o_final_gene_9  <= {LANE_ID_9, LANE_ID_9};
                            o_final_gene_10 <= {LANE_ID_10, LANE_ID_10};
                            o_final_gene_11 <= {LANE_ID_11, LANE_ID_11};
                            o_final_gene_12 <= {LANE_ID_12, LANE_ID_12};
                            o_final_gene_13 <= {LANE_ID_13, LANE_ID_13};
                            o_final_gene_14 <= {LANE_ID_14, LANE_ID_14};
                            o_final_gene_15 <= {LANE_ID_15, LANE_ID_15};
                        end
                        DEGRADE_LANES_0_TO_15: begin
                            o_final_gene_0  <= {LANE_ID_0, LANE_ID_0};
                            o_final_gene_1  <= {LANE_ID_1, LANE_ID_1};
                            o_final_gene_2  <= {LANE_ID_2, LANE_ID_2};
                            o_final_gene_3  <= {LANE_ID_3, LANE_ID_3};
                            o_final_gene_4  <= {LANE_ID_4, LANE_ID_4};
                            o_final_gene_5  <= {LANE_ID_5, LANE_ID_5};
                            o_final_gene_6  <= {LANE_ID_6, LANE_ID_6};
                            o_final_gene_7  <= {LANE_ID_7, LANE_ID_7};
                            o_final_gene_8  <= {LANE_ID_8, LANE_ID_8};
                            o_final_gene_9  <= {LANE_ID_9, LANE_ID_9};
                            o_final_gene_10 <= {LANE_ID_10, LANE_ID_10};
                            o_final_gene_11 <= {LANE_ID_11, LANE_ID_11};
                            o_final_gene_12 <= {LANE_ID_12, LANE_ID_12};
                            o_final_gene_13 <= {LANE_ID_13, LANE_ID_13};
                            o_final_gene_14 <= {LANE_ID_14, LANE_ID_14};
                            o_final_gene_15 <= {LANE_ID_15, LANE_ID_15};
                        end
                    endcase
                end
            end
        endcase

        // // Assign delayed values to outputs
        // o_Data_by_0 <= temp_Data_by_0; o_Data_by_1 <= temp_Data_by_1; o_Data_by_2 <= temp_Data_by_2; o_Data_by_3 <= temp_Data_by_3;
        // o_Data_by_4 <= temp_Data_by_4; o_Data_by_5 <= temp_Data_by_5; o_Data_by_6 <= temp_Data_by_6; o_Data_by_7 <= temp_Data_by_7;
        // o_Data_by_8 <= temp_Data_by_8; o_Data_by_9 <= temp_Data_by_9; o_Data_by_10 <= temp_Data_by_10; o_Data_by_11 <= temp_Data_by_11;
        // o_Data_by_12 <= temp_Data_by_12; o_Data_by_13 <= temp_Data_by_13; o_Data_by_14 <= temp_Data_by_14; o_Data_by_15 <= temp_Data_by_15;
    end
end
// Assign delayed values to outputs
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        // Reset outputs
        o_Data_by_0 <= 0; o_Data_by_1 <= 0; o_Data_by_2 <= 0; o_Data_by_3 <= 0;
        o_Data_by_4 <= 0; o_Data_by_5 <= 0; o_Data_by_6 <= 0; o_Data_by_7 <= 0;
        o_Data_by_8 <= 0; o_Data_by_9 <= 0; o_Data_by_10 <= 0; o_Data_by_11 <= 0;
        o_Data_by_12 <= 0; o_Data_by_13 <= 0; o_Data_by_14 <= 0; o_Data_by_15 <= 0;
    end
    else begin
        if (i_enable_buffer) begin
            // Assign temp_Data_by_* to o_Data_by_* when i_enable_buffer is 1
            o_Data_by_0 <= temp_Data_by_0; o_Data_by_1 <= temp_Data_by_1; o_Data_by_2 <= temp_Data_by_2; o_Data_by_3 <= temp_Data_by_3;
            o_Data_by_4 <= temp_Data_by_4; o_Data_by_5 <= temp_Data_by_5; o_Data_by_6 <= temp_Data_by_6; o_Data_by_7 <= temp_Data_by_7;
            o_Data_by_8 <= temp_Data_by_8; o_Data_by_9 <= temp_Data_by_9; o_Data_by_10 <= temp_Data_by_10; o_Data_by_11 <= temp_Data_by_11;
            o_Data_by_12 <= temp_Data_by_12; o_Data_by_13 <= temp_Data_by_13; o_Data_by_14 <= temp_Data_by_14; o_Data_by_15 <= temp_Data_by_15;
        end
        else begin
            // Assign 0 or default value when i_enable_buffer is 0
            o_Data_by_0 <= 0; o_Data_by_1 <= 0; o_Data_by_2 <= 0; o_Data_by_3 <= 0;
            o_Data_by_4 <= 0; o_Data_by_5 <= 0; o_Data_by_6 <= 0; o_Data_by_7 <= 0;
            o_Data_by_8 <= 0; o_Data_by_9 <= 0; o_Data_by_10 <= 0; o_Data_by_11 <= 0;
            o_Data_by_12 <= 0; o_Data_by_13 <= 0; o_Data_by_14 <= 0; o_Data_by_15 <= 0;
        end
    end
end
endmodule