module pattern_comparator #(
    parameter WIDTH = 32
)(
    input i_clk,
    input i_rst_n,
    input i_Type_comp,
    input [1:0] i_state,
    input i_enable_buffer,
    input enable_pattern_comparitor,

    
    input wire [WIDTH-1:0] i_local_gen_0, i_local_gen_1, i_local_gen_2, i_local_gen_3,
    input wire [WIDTH-1:0] i_local_gen_4, i_local_gen_5, i_local_gen_6, i_local_gen_7,
    input wire [WIDTH-1:0] i_local_gen_8, i_local_gen_9, i_local_gen_10, i_local_gen_11,
    input wire [WIDTH-1:0] i_local_gen_12, i_local_gen_13, i_local_gen_14, i_local_gen_15,
    
    input wire [WIDTH-1:0] i_Data_by_0, i_Data_by_1, i_Data_by_2, i_Data_by_3,
    input wire [WIDTH-1:0] i_Data_by_4, i_Data_by_5, i_Data_by_6, i_Data_by_7,
    input wire [WIDTH-1:0] i_Data_by_8, i_Data_by_9, i_Data_by_10, i_Data_by_11,
    input wire [WIDTH-1:0] i_Data_by_12, i_Data_by_13, i_Data_by_14, i_Data_by_15,
    
    input [11:0] i_Max_error_Threshold_per_lane,
    input [15:0] i_Max_error_Threshold_aggregate,
    
    output reg [15:0] o_per_lane_error,
   
    output wire o_error_done
);

    reg [15:0] DONE_PATTERN;
    reg [15:0] o_error_counter;
    reg [4:0] lane_success_count [15:0]; // Separate counter for each lane
    integer i, j;
    reg [11:0] bit_mismatch_temp [15:0];
    reg [11:0] mismatch_count [15:0];
    wire [15:0] lane_mismatch_part_1;
    wire [15:0] lane_mismatch_part_2;
    reg [WIDTH-1:0] bit_mismatch_or;
    reg [5:0] comb_bit_count;
    reg [15:0] o_per_lane_error_reg;
    reg i_enable_buffer_reg;

    localparam IDLE         = 2'b00;
    localparam CLEAR_LFSR   = 2'b01;
    localparam PATTERN_LFSR = 2'b10;
    localparam PER_LANE_IDE = 2'b11;

    assign lane_mismatch_part_1[0]  = enable_pattern_comparitor ? ((i_Data_by_0[15:0]  == i_local_gen_0[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[1]  = enable_pattern_comparitor ? ((i_Data_by_1[15:0]  == i_local_gen_1[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[2]  = enable_pattern_comparitor ? ((i_Data_by_2[15:0]  == i_local_gen_2[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[3]  = enable_pattern_comparitor ? ((i_Data_by_3[15:0]  == i_local_gen_3[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[4]  = enable_pattern_comparitor ? ((i_Data_by_4[15:0]  == i_local_gen_4[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[5]  = enable_pattern_comparitor ? ((i_Data_by_5[15:0]  == i_local_gen_5[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[6]  = enable_pattern_comparitor ? ((i_Data_by_6[15:0]  == i_local_gen_6[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[7]  = enable_pattern_comparitor ? ((i_Data_by_7[15:0]  == i_local_gen_7[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[8]  = enable_pattern_comparitor ? ((i_Data_by_8[15:0]  == i_local_gen_8[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[9]  = enable_pattern_comparitor ? ((i_Data_by_9[15:0]  == i_local_gen_9[15:0])  ? 1 : 0) : 0;
    assign lane_mismatch_part_1[10] = enable_pattern_comparitor ? ((i_Data_by_10[15:0] == i_local_gen_10[15:0]) ? 1 : 0) : 0;
    assign lane_mismatch_part_1[11] = enable_pattern_comparitor ? ((i_Data_by_11[15:0] == i_local_gen_11[15:0]) ? 1 : 0) : 0;
    assign lane_mismatch_part_1[12] = enable_pattern_comparitor ? ((i_Data_by_12[15:0] == i_local_gen_12[15:0]) ? 1 : 0) : 0;
    assign lane_mismatch_part_1[13] = enable_pattern_comparitor ? ((i_Data_by_13[15:0] == i_local_gen_13[15:0]) ? 1 : 0) : 0;
    assign lane_mismatch_part_1[14] = enable_pattern_comparitor ? ((i_Data_by_14[15:0] == i_local_gen_14[15:0]) ? 1 : 0) : 0;
    assign lane_mismatch_part_1[15] = enable_pattern_comparitor ? ((i_Data_by_15[15:0] == i_local_gen_15[15:0]) ? 1 : 0) : 0;

    assign lane_mismatch_part_2[0]  = enable_pattern_comparitor ? ((i_Data_by_0[31:16]  == i_local_gen_0[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[1]  = enable_pattern_comparitor ? ((i_Data_by_1[31:16]  == i_local_gen_1[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[2]  = enable_pattern_comparitor ? ((i_Data_by_2[31:16]  == i_local_gen_2[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[3]  = enable_pattern_comparitor ? ((i_Data_by_3[31:16]  == i_local_gen_3[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[4]  = enable_pattern_comparitor ? ((i_Data_by_4[31:16]  == i_local_gen_4[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[5]  = enable_pattern_comparitor ? ((i_Data_by_5[31:16]  == i_local_gen_5[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[6]  = enable_pattern_comparitor ? ((i_Data_by_6[31:16]  == i_local_gen_6[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[7]  = enable_pattern_comparitor ? ((i_Data_by_7[31:16]  == i_local_gen_7[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[8]  = enable_pattern_comparitor ? ((i_Data_by_8[31:16]  == i_local_gen_8[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[9]  = enable_pattern_comparitor ? ((i_Data_by_9[31:16]  == i_local_gen_9[31:16])  ? 1 : 0) : 0;
    assign lane_mismatch_part_2[10] = enable_pattern_comparitor ? ((i_Data_by_10[31:16] == i_local_gen_10[31:16]) ? 1 : 0) : 0;
    assign lane_mismatch_part_2[11] = enable_pattern_comparitor ? ((i_Data_by_11[31:16] == i_local_gen_11[31:16]) ? 1 : 0) : 0;
    assign lane_mismatch_part_2[12] = enable_pattern_comparitor ? ((i_Data_by_12[31:16] == i_local_gen_12[31:16]) ? 1 : 0) : 0;
    assign lane_mismatch_part_2[13] = enable_pattern_comparitor ? ((i_Data_by_13[31:16] == i_local_gen_13[31:16]) ? 1 : 0) : 0;
    assign lane_mismatch_part_2[14] = enable_pattern_comparitor ? ((i_Data_by_14[31:16] == i_local_gen_14[31:16]) ? 1 : 0) : 0;
    assign lane_mismatch_part_2[15] = enable_pattern_comparitor ? ((i_Data_by_15[31:16] == i_local_gen_15[31:16]) ? 1 : 0) : 0;

    assign o_error_done = enable_pattern_comparitor ? ((o_error_counter > i_Max_error_Threshold_aggregate) ? 0 : 1) : 1;

    always @(*) begin
        if (enable_pattern_comparitor && i_Type_comp) begin
            for (i = 0; i < 16; i = i + 1) begin
                mismatch_count[i] = 0;
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
            for (i = 0; i < 16; i = i + 1) begin
                mismatch_count[i] = 0;
            end
        end
    end

    always @(*) begin
        if (enable_pattern_comparitor) begin
            comb_bit_count = 0;
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
                comb_bit_count = comb_bit_count + bit_mismatch_or[j];
            end
        end else begin
            comb_bit_count = 0;
            for (j = 0; j < WIDTH; j = j + 1) begin
                bit_mismatch_or[j] = 0;
            end
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= 0;
            end
        end else if (i_state == CLEAR_LFSR) begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= 0;
            end
        end else if (enable_pattern_comparitor) begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= bit_mismatch_temp[i] + mismatch_count[i];
            end
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                bit_mismatch_temp[i] <= bit_mismatch_temp[i];
            end
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            o_error_counter    <= 0;
            o_per_lane_error_reg   <= 16'hFFFF;
            DONE_PATTERN       <=0;
            for (i = 0; i < 16; i = i + 1) begin
                lane_success_count[i] <= 0; // Explicit reset for lane_success_count
            end
        end else if (enable_pattern_comparitor) begin
            case (i_state)
                IDLE: begin
                    if (i_Type_comp) begin
                        for (i = 0; i < 16; i = i + 1) begin
                            if (o_per_lane_error_reg[i] == 0) begin
                                o_per_lane_error_reg[i] <= 0;
                            end else if (bit_mismatch_temp[i] > i_Max_error_Threshold_per_lane) begin
                                o_per_lane_error_reg[i] <= 0;
                            end else begin
                                o_per_lane_error_reg[i] <= 1;
                            end
                        end
                    end else begin
                        o_error_counter <= o_error_counter + comb_bit_count;
                    end
                end

                CLEAR_LFSR: begin
                    o_error_counter    <= 0;
                    o_per_lane_error_reg   <= 16'hFFFF;
                    for (i = 0; i < 16; i = i + 1) begin
                        lane_success_count[i] <= 0; // Clear lane_success_count
                    end
                end

                PATTERN_LFSR: begin
                    if (i_Type_comp) begin
                        for (i = 0; i < 16; i = i + 1) begin
                            if (o_per_lane_error_reg[i] == 0) begin
                                o_per_lane_error_reg[i] <= 0;
                            end else if (bit_mismatch_temp[i] > i_Max_error_Threshold_per_lane) begin
                                o_per_lane_error_reg[i] <= 0;
                            end else begin
                                o_per_lane_error_reg[i] <= 1;
                            end
                        end
                    end else begin
                        o_error_counter <= o_error_counter + comb_bit_count;
                    end
                end

                PER_LANE_IDE: begin
                    for (i = 0; i < 16; i = i + 1) begin

                        if (!lane_mismatch_part_2[i]) begin
                            lane_success_count[i] <= 0;
                        end else if (lane_success_count[i] == 15) begin
                            if (lane_mismatch_part_1[i]) begin
                                lane_success_count[i] <= 16;
                            end else begin
                                lane_success_count[i] <= 0;
                            end
                        end else if (!lane_mismatch_part_1[i] && lane_mismatch_part_2[i]) begin
                            lane_success_count[i] <= 1;
                        end else begin
                            lane_success_count[i] <= lane_success_count[i] + 
                                                    (lane_mismatch_part_1[i] & lane_mismatch_part_2[i]);
                        end
                        if (lane_success_count[i] >= 16 ) begin 
                            DONE_PATTERN[i]<=1;
                        end
                        if (DONE_PATTERN[i]) begin
                            o_per_lane_error_reg[i]<=1;
                        end else begin 
                            o_per_lane_error_reg[i]<=0;   
                        end
                        // end else begin
                        //     o_per_lane_error_reg[i] <=0;
                        // end

                        // o_per_lane_error_reg[i] <=  ((lane_success_count[i] >= 16) ? 1 : 0);

                        // // Latch o_per_lane_error_reg[i] once it becomes 1
                        // if (o_per_lane_error_reg[i] == 1) begin
                        //     o_per_lane_error_reg[i] <= 1; // Hold at 1, no further checks
                        // end 
                    end
                    // o_error_counter <= o_error_counter + comb_bit_count; // Commented as per original
                end

                default: begin
                    o_error_counter   <= o_error_counter;
                    o_per_lane_error_reg  <= o_per_lane_error_reg;
                    for (i = 0; i < 16; i = i + 1) begin
                        lane_success_count[i] <= lane_success_count[i];
                    end
                end
            endcase
        end else begin
            o_error_counter   <= o_error_counter;
            o_per_lane_error_reg  <= o_per_lane_error_reg;
            for (i = 0; i < 16; i = i + 1) begin
                lane_success_count[i] <= lane_success_count[i]; // Hold value when not enabled
            end
        end
    end

/***********************************************
* Detecting negative edge of deserializer signal
************************************************/
always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        i_enable_buffer_reg <= 0;
    end else begin
        i_enable_buffer_reg <= i_enable_buffer;
    end
end
assign negedge_enable_buffer_detected = (!i_enable_buffer && i_enable_buffer_reg);
/***********************************************************************************/
wire cond_1 = negedge_enable_buffer_detected && (i_state == PATTERN_LFSR || i_state == PER_LANE_IDE);
always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        o_per_lane_error <= 0;
    end else if (cond_1) begin
        o_per_lane_error <= o_per_lane_error_reg;
    end
end

endmodule