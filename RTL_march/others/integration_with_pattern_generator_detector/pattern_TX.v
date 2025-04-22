module LFSR_Transmitter (
    input wire clk,                      // Clock signal
    input wire rst_n,                    // Active-low reset signal
    input wire [1:0] i_state,            // State input (IDLE, SCRAMBLE, PATTERN_LFSR, PER_LANE_IDE)
    input wire enable_scrambeling_pattern, // Enable scrambling pattern
    /**********************************************************************************************************************/
    input wire serial_lane_0,  input wire serial_lane_1, input serial_lane_2,    input wire serial_lane_3,
    input wire serial_lane_4,  input wire serial_lane_5,  input wire serial_lane_6,  input wire serial_lane_7,
    input wire serial_lane_8,  input wire serial_lane_9,  input wire serial_lane_10, input wire serial_lane_11,
    input wire serial_lane_12, input wire serial_lane_13, input wire serial_lane_14, input wire serial_lane_15,
/**********************************************************************************************************************************/

    output reg out_data_lane_0,  output reg out_data_lane_1,  output reg out_data_lane_2,  output reg out_data_lane_3,
    output reg out_data_lane_4,  output reg out_data_lane_5,  output reg out_data_lane_6,  output reg out_data_lane_7,
    output reg out_data_lane_8,  output reg out_data_lane_9,  output reg out_data_lane_10, output reg out_data_lane_11,
    output reg out_data_lane_12, output reg out_data_lane_13, output reg out_data_lane_14, output reg out_data_lane_15,
    output reg done                       // Signal to indicate completion of operation
);

                            /* -------------------------------------------------------------------------- */
                            /*                              // State Encoding                             */
                            /* -------------------------------------------------------------------------- */

localparam IDLE           = 2'b00;         // Idle state 
localparam Clear_lfsr     = 2'b01;         // clrae lfsr pattern 
localparam PATTERN_LFSR   = 2'b10;         // LFSR pattern generation state
localparam PER_LANE_IDE   = 2'b11;         // Per-lane identification state

// 4K UI Counter (Counts 4096 cycles)
reg [11:0] counter_lfsr;  
reg [2:0] counter_scramberler;                                 // Counter for tracking cycles
reg [3:0] count_pattern;    
reg [10:0] counter_per_lane;          // Counter for tracking pattern bits


// Define Lane IDs as parameters with prepended and appended 1010
parameter LANE_ID_0  = 16'b1010_00000000_1010; // Logical Lane Number 0
parameter LANE_ID_1  = 16'b1010_10000000_1010; // Logical Lane Number 1
parameter LANE_ID_2  = 16'b1010_01000000_1010; // Logical Lane Number 2
parameter LANE_ID_3  = 16'b1010_11000000_1010; // Logical Lane Number 3
parameter LANE_ID_4  = 16'b1010_00100000_1010; // Logical Lane Number 4
parameter LANE_ID_5  = 16'b1010_10100000_1010; // Logical Lane Number 5
parameter LANE_ID_6  = 16'b1010_01100000_1010; // Logical Lane Number 6
parameter LANE_ID_7  = 16'b1010_11100000_1010; // Logical Lane Number 7
parameter LANE_ID_8  = 16'b1010_00010000_1010; // Logical Lane Number 8
parameter LANE_ID_9  = 16'b1010_10010000_1010; // Logical Lane Number 9
parameter LANE_ID_10 = 16'b1010_01010000_1010; // Logical Lane Number 10
parameter LANE_ID_11 = 16'b1010_11010000_1010; // Logical Lane Number 11
parameter LANE_ID_12 = 16'b1010_00110000_1010; // Logical Lane Number 12
parameter LANE_ID_13 = 16'b1010_10110000_1010; // Logical Lane Number 13
parameter LANE_ID_14 = 16'b1010_01110000_1010; // Logical Lane Number 14
parameter LANE_ID_15 = 16'b1010_11110000_1010; // Logical Lane Number 15

// Declare LFSR registers for each lane
reg [22:0] lfsr_lane_0,  lfsr_lane_1,  lfsr_lane_2,  lfsr_lane_3;
reg [22:0] lfsr_lane_4,  lfsr_lane_5,  lfsr_lane_6,  lfsr_lane_7;

// Feedback Logic for LFSR (XOR of specific bits for each lane)
wire feedback_lane_0  = lfsr_lane_0[22]  ^ lfsr_lane_0[20]  ^ lfsr_lane_0[15]  ^ lfsr_lane_0[7]  ^ lfsr_lane_0[4]  ^ lfsr_lane_0[1];
wire feedback_lane_1  = lfsr_lane_1[22]  ^ lfsr_lane_1[20]  ^ lfsr_lane_1[15]  ^ lfsr_lane_1[7]  ^ lfsr_lane_1[4]  ^ lfsr_lane_1[1];
wire feedback_lane_2  = lfsr_lane_2[22]  ^ lfsr_lane_2[20]  ^ lfsr_lane_2[15]  ^ lfsr_lane_2[7]  ^ lfsr_lane_2[4]  ^ lfsr_lane_2[1];
wire feedback_lane_3  = lfsr_lane_3[22]  ^ lfsr_lane_3[20]  ^ lfsr_lane_3[15]  ^ lfsr_lane_3[7]  ^ lfsr_lane_3[4]  ^ lfsr_lane_3[1];
wire feedback_lane_4  = lfsr_lane_4[22]  ^ lfsr_lane_4[20]  ^ lfsr_lane_4[15]  ^ lfsr_lane_4[7]  ^ lfsr_lane_4[4]  ^ lfsr_lane_4[1];
wire feedback_lane_5  = lfsr_lane_5[22]  ^ lfsr_lane_5[20]  ^ lfsr_lane_5[15]  ^ lfsr_lane_5[7]  ^ lfsr_lane_5[4]  ^ lfsr_lane_5[1];
wire feedback_lane_6  = lfsr_lane_6[22]  ^ lfsr_lane_6[20]  ^ lfsr_lane_6[15]  ^ lfsr_lane_6[7]  ^ lfsr_lane_6[4]  ^ lfsr_lane_6[1];
wire feedback_lane_7  = lfsr_lane_7[22]  ^ lfsr_lane_7[20]  ^ lfsr_lane_7[15]  ^ lfsr_lane_7[7]  ^ lfsr_lane_7[4]  ^ lfsr_lane_7[1];

// Main always block for state machine and logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers and outputs
        count_pattern <= 0;
        counter_lfsr <= 0;
        counter_per_lane <=0;
        done <= 0;
        counter_scramberler<=0;
        out_data_lane_0  <= 0; out_data_lane_1  <= 0; out_data_lane_2  <= 0; out_data_lane_3  <= 0;
        out_data_lane_4  <= 0; out_data_lane_5  <= 0; out_data_lane_6  <= 0; out_data_lane_7  <= 0;
        out_data_lane_8  <= 0; out_data_lane_9  <= 0; out_data_lane_10 <= 0; out_data_lane_11 <= 0;
        out_data_lane_12 <= 0; out_data_lane_13 <= 0; out_data_lane_14 <= 0; out_data_lane_15 <= 0;

        // Initialize LFSR registers with predefined seeds
        lfsr_lane_0  <= 23'h1DBFBC; lfsr_lane_1  <= 23'h0607BB; lfsr_lane_2  <= 23'h1EC760; lfsr_lane_3  <= 23'h18C0DB;
        lfsr_lane_4  <= 23'h010F12; lfsr_lane_5  <= 23'h19CFC9; lfsr_lane_6  <= 23'h0277CE; lfsr_lane_7  <= 23'h1BB807;
    end
    else begin
        case (i_state)
        IDLE:
        begin    
        count_pattern    <=     0;
        counter_lfsr     <=     0;
        counter_per_lane <=     0;
        done <=                 0;
        counter_scramberler    <=0;
        out_data_lane_0  <= 0; out_data_lane_1  <= 0; out_data_lane_2  <= 0; out_data_lane_3  <= 0;
        out_data_lane_4  <= 0; out_data_lane_5  <= 0; out_data_lane_6  <= 0; out_data_lane_7  <= 0;
        out_data_lane_8  <= 0; out_data_lane_9  <= 0; out_data_lane_10 <= 0; out_data_lane_11 <= 0;
        out_data_lane_12 <= 0; out_data_lane_13 <= 0; out_data_lane_14 <= 0; out_data_lane_15 <= 0;
        end
            /* -------------------------------------------------------------------------- */
            /*                              Clear LFSR lanes                              */
            /* -------------------------------------------------------------------------- */
            Clear_lfsr: begin
                // Reset LFSR registers to initial seeds
                lfsr_lane_0  <= 23'h1DBFBC;
                lfsr_lane_1  <= 23'h0607BB;
                lfsr_lane_2  <= 23'h1EC760;
                lfsr_lane_3  <= 23'h18C0DB;
                lfsr_lane_4  <= 23'h010F12;
                lfsr_lane_5  <= 23'h19CFC9;
                lfsr_lane_6  <= 23'h0277CE; 
                lfsr_lane_7  <= 23'h1BB807;
            end

            /* -------------------------------------------------------------------------- */
            /*                   Scrambling and LFSR Pattern Generation                   */
            /* -------------------------------------------------------------------------- */
           PATTERN_LFSR: begin
                // Update LFSR registers for each lane
                lfsr_lane_0  <= {lfsr_lane_0[21:0], feedback_lane_0};
                lfsr_lane_1  <= {lfsr_lane_1[21:0], feedback_lane_1};
                lfsr_lane_2  <= {lfsr_lane_2[21:0], feedback_lane_2};
                lfsr_lane_3  <= {lfsr_lane_3[21:0], feedback_lane_3};
                lfsr_lane_4  <= {lfsr_lane_4[21:0], feedback_lane_4};
                lfsr_lane_5  <= {lfsr_lane_5[21:0], feedback_lane_5};
                lfsr_lane_6  <= {lfsr_lane_6[21:0], feedback_lane_6};
                lfsr_lane_7  <= {lfsr_lane_7[21:0], feedback_lane_7};

                if (enable_scrambeling_pattern) begin
                    // Scramble data using LFSR output
                    if (counter_scramberler == 12'd7) begin
                        counter_scramberler <= 0;
                        done <= 1;
                        // Reset LFSR registers to initial seeds
                        lfsr_lane_0  <= 23'h1DBFBC; lfsr_lane_1  <= 23'h0607BB; lfsr_lane_2  <= 23'h1EC760; lfsr_lane_3  <= 23'h18C0DB;
                        lfsr_lane_4  <= 23'h010F12; lfsr_lane_5  <= 23'h19CFC9; lfsr_lane_6  <= 23'h0277CE; lfsr_lane_7  <= 23'h1BB807;
                    end
                    else begin
                        // XOR input data with LFSR output
                        out_data_lane_0  <= serial_lane_0  ^ lfsr_lane_0[22];
                        out_data_lane_1  <= serial_lane_1  ^ lfsr_lane_1[22];
                        out_data_lane_2  <= serial_lane_2  ^ lfsr_lane_2[22];
                        out_data_lane_3  <= serial_lane_3  ^ lfsr_lane_3[22];
                        out_data_lane_4  <= serial_lane_4  ^ lfsr_lane_4[22];
                        out_data_lane_5  <= serial_lane_5  ^ lfsr_lane_5[22];
                        out_data_lane_6  <= serial_lane_6  ^ lfsr_lane_6[22];
                        out_data_lane_7  <= serial_lane_7  ^ lfsr_lane_7[22];
                        out_data_lane_8  <= serial_lane_8  ^ lfsr_lane_0[22];
                        out_data_lane_9  <= serial_lane_9  ^ lfsr_lane_1[22];
                        out_data_lane_10 <= serial_lane_10 ^ lfsr_lane_2[22];
                        out_data_lane_11 <= serial_lane_11 ^ lfsr_lane_3[22];
                        out_data_lane_12 <= serial_lane_12 ^ lfsr_lane_4[22];
                        out_data_lane_13 <= serial_lane_13 ^ lfsr_lane_5[22];
                        out_data_lane_14 <= serial_lane_14 ^ lfsr_lane_6[22];
                        out_data_lane_15 <= serial_lane_15 ^ lfsr_lane_7[22];
                        counter_scramberler <= counter_scramberler + 1;
                        done <= 0;
                    end
                end
                else begin
                    // Output LFSR pattern directly
                    if (counter_lfsr == 12'd4095) begin
                        counter_lfsr <= 0;
                        done <= 1;
                    end
                    else begin
                        out_data_lane_0  <= lfsr_lane_0[22];
                        out_data_lane_1  <= lfsr_lane_1[22];
                        out_data_lane_2  <= lfsr_lane_2[22];
                        out_data_lane_3  <= lfsr_lane_3[22];
                        out_data_lane_4  <= lfsr_lane_4[22];
                        out_data_lane_5  <= lfsr_lane_5[22];
                        out_data_lane_6  <= lfsr_lane_6[22];
                        out_data_lane_7  <= lfsr_lane_7[22];
                        out_data_lane_8  <= lfsr_lane_0[22];
                        out_data_lane_9  <= lfsr_lane_1[22];
                        out_data_lane_10 <= lfsr_lane_2[22];
                        out_data_lane_11 <= lfsr_lane_3[22];
                        out_data_lane_12 <= lfsr_lane_4[22];
                        out_data_lane_13 <= lfsr_lane_5[22];
                        out_data_lane_14 <= lfsr_lane_6[22];
                        out_data_lane_15 <= lfsr_lane_7[22];
                        counter_lfsr <= counter_lfsr + 1;
                        done <= 0;
                    end
                end
            end

            /* -------------------------------------------------------------------------- */
            /*                          Per-Lane Identification                          */
            /* -------------------------------------------------------------------------- */
            PER_LANE_IDE: begin
                // Output per-lane identification pattern
                if (counter_per_lane == 12'd2047) begin
                    counter_per_lane <= 0;
                    done <= 1;
                end
                else begin
                    out_data_lane_0  <= LANE_ID_0[count_pattern];
                    out_data_lane_1  <= LANE_ID_1[count_pattern];
                    out_data_lane_2  <= LANE_ID_2[count_pattern];
                    out_data_lane_3  <= LANE_ID_3[count_pattern];
                    out_data_lane_4  <= LANE_ID_4[count_pattern];
                    out_data_lane_5  <= LANE_ID_5[count_pattern];
                    out_data_lane_6  <= LANE_ID_6[count_pattern];
                    out_data_lane_7  <= LANE_ID_7[count_pattern];
                    out_data_lane_8  <= LANE_ID_8[count_pattern];
                    out_data_lane_9  <= LANE_ID_9[count_pattern];
                    out_data_lane_10 <= LANE_ID_10[count_pattern];
                    out_data_lane_11 <= LANE_ID_11[count_pattern];
                    out_data_lane_12 <= LANE_ID_12[count_pattern];
                    out_data_lane_13 <= LANE_ID_13[count_pattern];
                    out_data_lane_14 <= LANE_ID_14[count_pattern];
                    out_data_lane_15 <= LANE_ID_15[count_pattern];
                    counter_per_lane <= counter_per_lane + 1;
                    count_pattern <= count_pattern + 1;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule