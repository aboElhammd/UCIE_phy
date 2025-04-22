module Lane_To_Byte_Demapping #(
    parameter WIDTH = 32,         // Width of each lane (32 bits = 4 bytes)
    parameter N_BYTES = 64,       // Total number of output bytes (changed to 64)
    parameter NUM_LANES = 16      // Number of input lanes
) (
    input wire i_clk,             // Clock signal
    input wire i_rst_n,           // Active-low reset
    input wire [WIDTH-1:0] i_lane_0, i_lane_1, i_lane_2, i_lane_3,
    input wire [WIDTH-1:0] i_lane_4, i_lane_5, i_lane_6, i_lane_7,
    input wire [WIDTH-1:0] i_lane_8, i_lane_9, i_lane_10, i_lane_11,
    input wire [WIDTH-1:0] i_lane_12, i_lane_13, i_lane_14, i_lane_15,
    input wire enable_demapper,   // Enable signal (0: IDLE, 1: DEGRADE)
    input wire [1:0] i_functional_rx_lanes, // Lane mapping mode
    output reg [8*N_BYTES-1:0] o_out_data   // Output data (512 bits)
);

    // Local parameters
    localparam BYTES_PER_LANE = WIDTH/8;  // 4 bytes per lane
    localparam TOTAL_CHUNKS = N_BYTES/BYTES_PER_LANE;  // 16 chunks
    
    localparam DEGRADE_LANES_0_TO_7   = 2'b01;
    localparam DEGRADE_LANES_8_TO_15  = 2'b10;
    localparam DEGRADE_LANES_0_TO_15  = 2'b11;
    
    localparam CLOCK_CYCLES_8_LANES  = (N_BYTES/BYTES_PER_LANE)/8;   // 2 cycles
    localparam CLOCK_CYCLES_16_LANES = (N_BYTES/BYTES_PER_LANE)/16;  // 1 cycle

    // Internal registers
    reg [WIDTH-1:0] lane_data [0:NUM_LANES-1];
    reg [5:0] cycle_count;  // 6 bits enough for 32 (still sufficient for 2)
    reg [8*N_BYTES-1:0] data_shift_reg;  // Now 512 bits
    reg [8*N_BYTES-1:0] accumulated_data;  // Now 512 bits
    reg accumulation_done;  // Flag to indicate accumulation complete
    
    integer i;

    // Combinational logic for output data assignment
    always @(*) begin
        if (accumulation_done) begin
            case (i_functional_rx_lanes)
                DEGRADE_LANES_0_TO_7: begin
                    o_out_data = accumulated_data;
                end
                DEGRADE_LANES_8_TO_15: begin
                    o_out_data = accumulated_data;
                end
                DEGRADE_LANES_0_TO_15: begin
                    o_out_data = accumulated_data;
                end
                default: begin
                    o_out_data = 0;
                end
            endcase
        end
        else begin
            o_out_data = 0;  // Output 0 until accumulation is complete
        end
    end

    // Sequential logic for data demapping and accumulation
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            cycle_count <= 0;
           
            accumulated_data <= 0;
            accumulation_done <= 0;
            for (i = 0; i < NUM_LANES; i = i + 1) begin
                lane_data[i] <= 0;
            end
        end
        else if (enable_demapper) begin
            case (i_functional_rx_lanes)
                DEGRADE_LANES_0_TO_7: begin
                    if (cycle_count < CLOCK_CYCLES_8_LANES) begin
                        // Load new data from lanes 0 to 7 every cycle (lane 7 at MSB)
                        lane_data[0] <= i_lane_0;
                        lane_data[1] <= i_lane_1;
                        lane_data[2] <= i_lane_2;
                        lane_data[3] <= i_lane_3;
                        lane_data[4] <= i_lane_4;
                        lane_data[5] <= i_lane_5;
                        lane_data[6] <= i_lane_6;
                        lane_data[7] <= i_lane_7;
                        // Accumulate data into the correct position
                        accumulated_data[(cycle_count * 8 * WIDTH) + 8*WIDTH-1 -: 8*WIDTH] <= 
                            {i_lane_7, i_lane_6, i_lane_5, i_lane_4,
                             i_lane_3, i_lane_2, i_lane_1, i_lane_0};
                        cycle_count <= cycle_count + 1;
                        if (cycle_count == CLOCK_CYCLES_8_LANES - 1) begin
                            accumulation_done <= 1;  // Set flag when accumulation completes
                        end
                    end
                end
                
                DEGRADE_LANES_8_TO_15: begin
                    if (cycle_count < CLOCK_CYCLES_8_LANES) begin
                        // Load new data from lanes 8 to 15 every cycle (lane 15 at MSB)
                        lane_data[8]  <= i_lane_8;
                        lane_data[9]  <= i_lane_9;
                        lane_data[10] <= i_lane_10;
                        lane_data[11] <= i_lane_11;
                        lane_data[12] <= i_lane_12;
                        lane_data[13] <= i_lane_13;
                        lane_data[14] <= i_lane_14;
                        lane_data[15] <= i_lane_15;
                        accumulated_data[(cycle_count * 8 * WIDTH) + 8*WIDTH-1 -: 8*WIDTH] <= 
                            {i_lane_15, i_lane_14, i_lane_13, i_lane_12,
                             i_lane_11, i_lane_10, i_lane_9, i_lane_8};
                        cycle_count <= cycle_count + 1;
                        if (cycle_count == CLOCK_CYCLES_8_LANES - 1) begin
                            accumulation_done <= 1;  // Set flag when accumulation completes
                        end
                    end
                end
                
                DEGRADE_LANES_0_TO_15: begin
                    if (cycle_count < CLOCK_CYCLES_16_LANES) begin
                        // Load new data from all lanes (lane 15 at MSB)
                        lane_data[0]  <= i_lane_0;
                        lane_data[1]  <= i_lane_1;
                        lane_data[2]  <= i_lane_2;
                        lane_data[3]  <= i_lane_3;
                        lane_data[4]  <= i_lane_4;
                        lane_data[5]  <= i_lane_5;
                        lane_data[6]  <= i_lane_6;
                        lane_data[7]  <= i_lane_7;
                        lane_data[8]  <= i_lane_8;
                        lane_data[9]  <= i_lane_9;
                        lane_data[10] <= i_lane_10;
                        lane_data[11] <= i_lane_11;
                        lane_data[12] <= i_lane_12;
                        lane_data[13] <= i_lane_13;
                        lane_data[14] <= i_lane_14;
                        lane_data[15] <= i_lane_15;
                        accumulated_data[16*WIDTH-1:0] <= {i_lane_15, i_lane_14, i_lane_13, i_lane_12,
                                                          i_lane_11, i_lane_10, i_lane_9, i_lane_8,
                                                          i_lane_7, i_lane_6, i_lane_5, i_lane_4,
                                                          i_lane_3, i_lane_2, i_lane_1, i_lane_0};
                        cycle_count <= cycle_count + 1;
                        if (cycle_count == CLOCK_CYCLES_16_LANES - 1) begin
                            accumulation_done <= 1;  // Set flag when accumulation completes
                        end
                    end
                end
                
                default: begin
                    for (i = 0; i < NUM_LANES; i = i + 1) begin
                        lane_data[i] <= 0;
                    end
                   
                    accumulated_data <= 0;
                    accumulation_done <= 0;
                end
            endcase
        end
        else begin
            // IDLE state
            cycle_count <= 0;
            accumulated_data <= 0;
            accumulation_done <= 0;
            for (i = 0; i < NUM_LANES; i = i + 1) begin
                lane_data[i] <= 0;
            end
        end
    end

endmodule