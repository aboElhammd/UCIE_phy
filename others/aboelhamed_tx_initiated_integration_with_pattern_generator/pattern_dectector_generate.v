module pattern_detector (
    input i_clk,
    input i_rst_n,
    input [1:0] i_state,
    input wire locally_generated_patterns, // Enable scrambling pattern
    input enable_buffer,                   // Enable for Data Come from buffer
    // Input from Rx data
    input i_pattern_0, i_pattern_1, i_pattern_2, i_pattern_3, i_pattern_4, i_pattern_5,
    input i_pattern_6, i_pattern_7, i_pattern_8, i_pattern_9, i_pattern_10, i_pattern_11,
    input i_pattern_12, i_pattern_13, i_pattern_14, i_pattern_15,

    // Output of pattern bypass
    output reg o_pattern_0, o_pattern_1, o_pattern_2, o_pattern_3, o_pattern_4, o_pattern_5,
    output reg o_pattern_6, o_pattern_7, o_pattern_8, o_pattern_9, o_pattern_10, o_pattern_11,
    output reg o_pattern_12, o_pattern_13, o_pattern_14, o_pattern_15,

    // Output from locally generated parameter

    
    output reg done,
    output reg out_local_pattern_0,out_local_pattern_1,out_local_pattern_2,out_local_pattern_3,out_local_pattern_4,
    output reg out_local_pattern_5,out_local_pattern_6,out_local_pattern_7,out_local_pattern_8,out_local_pattern_9,
    output reg out_local_pattern_10,out_local_pattern_11,out_local_pattern_12,out_local_pattern_13,out_local_pattern_14,
    output reg out_local_pattern_15
);
     reg o_generated_0, o_generated_1, o_generated_2, o_generated_3, o_generated_4;
     reg o_generated_5, o_generated_6, o_generated_7, o_generated_8, o_generated_9;
     reg o_generated_10, o_generated_11, o_generated_12, o_generated_13, o_generated_14,o_generated_15;
    // Declare LFSR registers for each lane
    reg [22:0] lfsr_lane_0, lfsr_lane_1, lfsr_lane_2, lfsr_lane_3;
    reg [22:0] lfsr_lane_4, lfsr_lane_5, lfsr_lane_6, lfsr_lane_7;

    // Feedback Logic for LFSR (XOR of specific bits for each lane)
    wire feedback_lane_0  = lfsr_lane_0[22]  ^ lfsr_lane_0[20]  ^ lfsr_lane_0[15]  ^ lfsr_lane_0[7]  ^ lfsr_lane_0[4]  ^ lfsr_lane_0[1];
    wire feedback_lane_1  = lfsr_lane_1[22]  ^ lfsr_lane_1[20]  ^ lfsr_lane_1[15]  ^ lfsr_lane_1[7]  ^ lfsr_lane_1[4]  ^ lfsr_lane_1[1];
    wire feedback_lane_2  = lfsr_lane_2[22]  ^ lfsr_lane_2[20]  ^ lfsr_lane_2[15]  ^ lfsr_lane_2[7]  ^ lfsr_lane_2[4]  ^ lfsr_lane_2[1];
    wire feedback_lane_3  = lfsr_lane_3[22]  ^ lfsr_lane_3[20]  ^ lfsr_lane_3[15]  ^ lfsr_lane_3[7]  ^ lfsr_lane_3[4]  ^ lfsr_lane_3[1];
    wire feedback_lane_4  = lfsr_lane_4[22]  ^ lfsr_lane_4[20]  ^ lfsr_lane_4[15]  ^ lfsr_lane_4[7]  ^ lfsr_lane_4[4]  ^ lfsr_lane_4[1];
    wire feedback_lane_5  = lfsr_lane_5[22]  ^ lfsr_lane_5[20]  ^ lfsr_lane_5[15]  ^ lfsr_lane_5[7]  ^ lfsr_lane_5[4]  ^ lfsr_lane_5[1];
    wire feedback_lane_6  = lfsr_lane_6[22]  ^ lfsr_lane_6[20]  ^ lfsr_lane_6[15]  ^ lfsr_lane_6[7]  ^ lfsr_lane_6[4]  ^ lfsr_lane_6[1];
    wire feedback_lane_7  = lfsr_lane_7[22]  ^ lfsr_lane_7[20]  ^ lfsr_lane_7[15]  ^ lfsr_lane_7[7]  ^ lfsr_lane_7[4]  ^ lfsr_lane_7[1];


    // State definitions
    localparam IDLE           = 2'b00; // Idle state
    localparam CLEAR_LFSR     = 2'b01; // Clear LFSR pattern
    localparam PATTERN_LFSR   = 2'b10; // LFSR pattern generation state
    localparam PER_LANE_IDE   = 2'b11; // Per-lane identification state

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

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Reset all outputs to 0
               count_pattern <= 0;
                    counter_lfsr <= 0;
                    counter_scramberler<= 0;
                    done<=0;
                    counter_per_lane <= 0;
            o_generated_0  <= 0; o_generated_1  <= 0; o_generated_2  <= 0; o_generated_3  <= 0;
            o_generated_4  <= 0; o_generated_5  <= 0; o_generated_6  <= 0; o_generated_7  <= 0;
            o_generated_8  <= 0; o_generated_9  <= 0; o_generated_10 <= 0; o_generated_11 <= 0;
            o_generated_12 <= 0; o_generated_13 <= 0; o_generated_14 <= 0; o_generated_15 <= 0;

            // Assign o_pattern_* to i_pattern_*
            o_pattern_0  <= 0; o_pattern_1  <= 0; o_pattern_2  <= 0; o_pattern_3  <= 0;
            o_pattern_4  <= 0; o_pattern_5  <= 0; o_pattern_6  <= 0; o_pattern_7  <= 0;
            o_pattern_8  <= 0; o_pattern_9  <= 0; o_pattern_10 <= 0; o_pattern_11 <= 0;
            o_pattern_12 <= 0; o_pattern_13 <= 0; o_pattern_14 <= 0; o_pattern_15 <= 0;

            // Initialize LFSR registers with predefined seeds
            lfsr_lane_0  <= 23'h1DBFBC; lfsr_lane_1  <= 23'h0607BB; lfsr_lane_2  <= 23'h1EC760; lfsr_lane_3  <= 23'h18C0DB;
            lfsr_lane_4  <= 23'h010F12; lfsr_lane_5  <= 23'h19CFC9; lfsr_lane_6  <= 23'h0277CE; lfsr_lane_7  <= 23'h1BB807;
          
        end else begin
            case (i_state)
                IDLE: begin
                    count_pattern <= 0;
                    counter_lfsr <= 0;
                    done<=0;
                     counter_scramberler<= 0;
                    counter_per_lane <=0;
                    // Assign o_pattern_* to i_pattern_*
                    o_pattern_0  <= i_pattern_0; o_pattern_1  <= i_pattern_1; o_pattern_2  <= i_pattern_2; o_pattern_3  <= i_pattern_3;
                    o_pattern_4  <= i_pattern_4; o_pattern_5  <= i_pattern_5; o_pattern_6  <= i_pattern_6; o_pattern_7  <= i_pattern_7;
                    o_pattern_8  <= i_pattern_8; o_pattern_9  <= i_pattern_9; o_pattern_10 <= i_pattern_10; o_pattern_11 <= i_pattern_11;
                    o_pattern_12 <= i_pattern_12; o_pattern_13 <= i_pattern_13; o_pattern_14 <= i_pattern_14; o_pattern_15 <= i_pattern_15;

                    // Reset generated outputs to 0
                    o_generated_0  <= 0; o_generated_1  <= 0; o_generated_2  <= 0; o_generated_3  <= 0;
                    o_generated_4  <= 0; o_generated_5  <= 0; o_generated_6  <= 0; o_generated_7  <= 0;
                    o_generated_8  <= 0; o_generated_9  <= 0; o_generated_10 <= 0; o_generated_11 <= 0;
                    o_generated_12 <= 0; o_generated_13 <= 0; o_generated_14 <= 0; o_generated_15 <= 0;
                end

                CLEAR_LFSR: begin
                    // Reset LFSR registers to initial seeds
                    lfsr_lane_0  <= 23'h1DBFBC; lfsr_lane_1  <= 23'h0607BB; lfsr_lane_2  <= 23'h1EC760; lfsr_lane_3  <= 23'h18C0DB;
                    lfsr_lane_4  <= 23'h010F12; lfsr_lane_5  <= 23'h19CFC9; lfsr_lane_6  <= 23'h0277CE; lfsr_lane_7  <= 23'h1BB807;
                end

                PATTERN_LFSR: begin
                    if (enable_buffer)
             begin
                    // Update LFSR registers for each lane
                    lfsr_lane_0  <= {lfsr_lane_0[21:0], feedback_lane_0};
                    lfsr_lane_1  <= {lfsr_lane_1[21:0], feedback_lane_1};
                    lfsr_lane_2  <= {lfsr_lane_2[21:0], feedback_lane_2};
                    lfsr_lane_3  <= {lfsr_lane_3[21:0], feedback_lane_3};
                    lfsr_lane_4  <= {lfsr_lane_4[21:0], feedback_lane_4};
                    lfsr_lane_5  <= {lfsr_lane_5[21:0], feedback_lane_5};
                    lfsr_lane_6  <= {lfsr_lane_6[21:0], feedback_lane_6};
                    lfsr_lane_7  <= {lfsr_lane_7[21:0], feedback_lane_7};

                    if (locally_generated_patterns) begin
                        // Descrambler: XOR input data with LFSR output
                        if (counter_scramberler == 12'd7) begin
                            counter_scramberler <= 0;
                            done <= 1;
                            // Reset LFSR registers to initial seeds
                            lfsr_lane_0  <= 23'h1DBFBC; lfsr_lane_1  <= 23'h0607BB; lfsr_lane_2  <= 23'h1EC760; lfsr_lane_3  <= 23'h18C0DB;
                            lfsr_lane_4  <= 23'h010F12; lfsr_lane_5  <= 23'h19CFC9; lfsr_lane_6  <= 23'h0277CE; lfsr_lane_7  <= 23'h1BB807;
                        end else begin
                            o_pattern_0  <= i_pattern_0  ^ lfsr_lane_0[22];
                            o_pattern_1  <= i_pattern_1  ^ lfsr_lane_1[22];
                            o_pattern_2  <= i_pattern_2  ^ lfsr_lane_2[22];
                            o_pattern_3  <= i_pattern_3  ^ lfsr_lane_3[22];
                            o_pattern_4  <= i_pattern_4  ^ lfsr_lane_4[22];
                            o_pattern_5  <= i_pattern_5  ^ lfsr_lane_5[22];
                            o_pattern_6  <= i_pattern_6  ^ lfsr_lane_6[22];
                            o_pattern_7  <= i_pattern_7  ^ lfsr_lane_7[22];
                            o_pattern_8  <= i_pattern_8  ^ lfsr_lane_0[22];
                            o_pattern_9  <= i_pattern_9  ^ lfsr_lane_1[22];
                            o_pattern_10 <= i_pattern_10 ^ lfsr_lane_2[22];
                            o_pattern_11 <= i_pattern_11 ^ lfsr_lane_3[22];
                            o_pattern_12 <= i_pattern_12 ^ lfsr_lane_4[22];
                            o_pattern_13 <= i_pattern_13 ^ lfsr_lane_5[22];
                            o_pattern_14 <= i_pattern_14 ^ lfsr_lane_6[22];
                            o_pattern_15 <= i_pattern_15 ^ lfsr_lane_7[22];
                            counter_scramberler <= counter_scramberler + 1;
                            done <= 0;
                        end
                    end else begin
                        // Output LFSR pattern directly
                        if (counter_lfsr == 12'd4095) begin

                            counter_lfsr <= 0;
                            done <= 1;
                        end else begin
                            o_generated_0  <= lfsr_lane_0[22];
                            o_generated_1  <= lfsr_lane_1[22];
                            o_generated_2  <= lfsr_lane_2[22];
                            o_generated_3  <= lfsr_lane_3[22];
                            o_generated_4  <= lfsr_lane_4[22];
                            o_generated_5  <= lfsr_lane_5[22];
                            o_generated_6  <= lfsr_lane_6[22];
                            o_generated_7  <= lfsr_lane_7[22];
                            o_generated_8  <= lfsr_lane_0[22];
                            o_generated_9  <= lfsr_lane_1[22];
                            o_generated_10 <= lfsr_lane_2[22];
                            o_generated_11 <= lfsr_lane_3[22];
                            o_generated_12 <= lfsr_lane_4[22];
                            o_generated_13 <= lfsr_lane_5[22];
                            o_generated_14 <= lfsr_lane_6[22];
                            o_generated_15 <= lfsr_lane_7[22];

                            // Assign o_pattern_* to i_pattern_*
                            o_pattern_0  <= i_pattern_0; o_pattern_1  <= i_pattern_1; o_pattern_2  <= i_pattern_2; o_pattern_3  <= i_pattern_3;
                            o_pattern_4  <= i_pattern_4; o_pattern_5  <= i_pattern_5; o_pattern_6  <= i_pattern_6; o_pattern_7  <= i_pattern_7;
                            o_pattern_8  <= i_pattern_8; o_pattern_9  <= i_pattern_9; o_pattern_10 <= i_pattern_10; o_pattern_11 <= i_pattern_11;
                            o_pattern_12 <= i_pattern_12; o_pattern_13 <= i_pattern_13; o_pattern_14 <= i_pattern_14; o_pattern_15 <= i_pattern_15;

                            counter_lfsr <= counter_lfsr + 1;
                            done <= 0;
                        end
                    end
                end
                end

                PER_LANE_IDE: begin
                    if (enable_buffer) begin
                          // Output per-lane identification pattern
                if (counter_per_lane == 12'd2047) begin
                    counter_per_lane <= 0;
                    done <= 1;
                end
                else begin
                    
                
                    // Output per-lane identification pattern
                    o_generated_0  <= LANE_ID_0[count_pattern];
                    o_generated_1  <= LANE_ID_1[count_pattern];
                    o_generated_2  <= LANE_ID_2[count_pattern];
                    o_generated_3  <= LANE_ID_3[count_pattern];
                    o_generated_4  <= LANE_ID_4[count_pattern];
                    o_generated_5  <= LANE_ID_5[count_pattern];
                    o_generated_6  <= LANE_ID_6[count_pattern];
                    o_generated_7  <= LANE_ID_7[count_pattern];
                    o_generated_8  <= LANE_ID_8[count_pattern];
                    o_generated_9  <= LANE_ID_9[count_pattern];
                    o_generated_10 <= LANE_ID_10[count_pattern];
                    o_generated_11 <= LANE_ID_11[count_pattern];
                    o_generated_12 <= LANE_ID_12[count_pattern];
                    o_generated_13 <= LANE_ID_13[count_pattern];
                    o_generated_14 <= LANE_ID_14[count_pattern];
                    o_generated_15 <= LANE_ID_15[count_pattern];

                    // Assign o_pattern_* to i_pattern_*
                    o_pattern_0  <= i_pattern_0; o_pattern_1  <= i_pattern_1; o_pattern_2  <= i_pattern_2; o_pattern_3  <= i_pattern_3;
                    o_pattern_4  <= i_pattern_4; o_pattern_5  <= i_pattern_5; o_pattern_6  <= i_pattern_6; o_pattern_7  <= i_pattern_7;
                    o_pattern_8  <= i_pattern_8; o_pattern_9  <= i_pattern_9; o_pattern_10 <= i_pattern_10; o_pattern_11 <= i_pattern_11;
                    o_pattern_12 <= i_pattern_12; o_pattern_13 <= i_pattern_13; o_pattern_14 <= i_pattern_14; o_pattern_15 <= i_pattern_15;
                    counter_per_lane<= counter_per_lane+1;
                    count_pattern <= count_pattern + 1;
                    done <= 0;
                end
                end
                end
            endcase
        end
    end
/*************************************************************************************************/
/*  Here to make 2 outputs supposed equel at same inst till Put Deserializer and serializer  */
/************************************************************************************************/

        // Reset signal generation
 
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n)
        begin
            out_local_pattern_0<=0;
            out_local_pattern_1<=0;
            out_local_pattern_2<=0;
            out_local_pattern_3<=0;
            out_local_pattern_4<=0;
            out_local_pattern_5<=0;
            out_local_pattern_6<=0;
            out_local_pattern_7<=0;
            out_local_pattern_8<=0;
            out_local_pattern_9<=0;
            out_local_pattern_10<=0;
            out_local_pattern_11<=0;
            out_local_pattern_12<=0;
            out_local_pattern_13<=0;
            out_local_pattern_14<=0;
            out_local_pattern_15<=0;
        end
else begin
    out_local_pattern_0<=o_generated_0;
    out_local_pattern_1<=o_generated_1;
    out_local_pattern_2<=o_generated_2;
    out_local_pattern_3<=o_generated_3;
    out_local_pattern_4<=o_generated_4;
    out_local_pattern_5<=o_generated_5;
    out_local_pattern_6<=o_generated_6;
    out_local_pattern_7<=o_generated_7;
    out_local_pattern_8<=o_generated_8;
    out_local_pattern_9<=o_generated_9;
    out_local_pattern_10<=o_generated_10;
    out_local_pattern_11<=o_generated_11;
    out_local_pattern_12<=o_generated_12;
    out_local_pattern_13<=o_generated_13;
    out_local_pattern_14<=o_generated_14;
    out_local_pattern_15<=o_generated_15;


end
        end


endmodule