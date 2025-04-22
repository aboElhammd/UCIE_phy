module Byte_To_lane_mapping #(
    parameter WIDTH = 32,         // Width of each lane (32 bits = 4 bytes)
    parameter N_BYTES = 1024,     // Total number of input bytes
    parameter NUM_LANES = 16      // Number of output lanes
) (
    input wire i_clk,             // Clock signal
    input wire i_rst_n,           // Active-low reset
    input wire [8*N_BYTES-1:0] i_in_data, // Input data (8192 bits)
    input wire enable_mapper,     // Enable signal (0: IDLE, 1: DEGRADE)
    input wire [1:0] i_functional_tx_lanes, // Lane mapping mode
    output reg [WIDTH-1:0] o_lane_0, o_lane_1, o_lane_2, o_lane_3,
    output reg [WIDTH-1:0] o_lane_4, o_lane_5, o_lane_6, o_lane_7,
    output reg [WIDTH-1:0] o_lane_8, o_lane_9, o_lane_10, o_lane_11,
    output reg [WIDTH-1:0] o_lane_12, o_lane_13, o_lane_14, o_lane_15
);
    // Local parameters
    localparam BYTES_PER_LANE = WIDTH/8;  // 4 bytes per lane
    localparam TOTAL_CHUNKS = N_BYTES/BYTES_PER_LANE;  // 256 chunks
    
    localparam DEGRADE_LANES_0_TO_7   = 2'b01;
    localparam DEGRADE_LANES_8_TO_15  = 2'b10;
    localparam DEGRADE_LANES_0_TO_15  = 2'b11;
    
    localparam CLOCK_CYCLES_8_LANES  = (N_BYTES/BYTES_PER_LANE)/(8);   // 32 cycles
    localparam CLOCK_CYCLES_16_LANES = (N_BYTES/BYTES_PER_LANE)/(16);  // 16 cycles

    integer i;
    // Internal registers
    reg [WIDTH-1:0] lane_data [0:NUM_LANES-1];
    reg [$clog2(CLOCK_CYCLES_8_LANES)-1:0] cycle_count;
    reg [8*N_BYTES-1:0] data_shift_reg;

    // Sequential logic for data mapping
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            cycle_count <= 0;
            data_shift_reg <= 0;
            for (i = 0; i < NUM_LANES; i = i + 1) begin
                lane_data[i] <= {WIDTH{1'b0}};
            end
        end
        else if (enable_mapper) begin
            // Clear all lanes before assignment
            for (i = 0; i < NUM_LANES; i = i + 1) begin
                lane_data[i] <= {WIDTH{1'b0}};
            end

            case (i_functional_tx_lanes)
                DEGRADE_LANES_0_TO_7: begin
                    if (cycle_count < CLOCK_CYCLES_8_LANES) begin
                        if (cycle_count == 0) begin
                            // First cycle: Load from i_in_data
                            for (i = 0; i < 8; i = i + 1) begin
                                lane_data[i] <= i_in_data[i*WIDTH +: WIDTH];
                            end
                            data_shift_reg <= i_in_data >> (8*WIDTH);  // Shift by 256 bits
                        end
                        else begin
                            // Subsequent cycles: Use shift register
                            for (i = 0; i < 8; i = i + 1) begin
                                lane_data[i] <= data_shift_reg[i*WIDTH +: WIDTH];
                            end
                            data_shift_reg <= data_shift_reg >> (8*WIDTH);
                        end
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                DEGRADE_LANES_8_TO_15: begin
                    if (cycle_count < CLOCK_CYCLES_8_LANES) begin
                        if (cycle_count == 0) begin
                            for (i = 0; i < 8; i = i + 1) begin
                                lane_data[8 + i] <= i_in_data[i*WIDTH +: WIDTH];
                            end
                            data_shift_reg <= i_in_data >> (8*WIDTH);
                        end
                        else begin
                            for (i = 0; i < 8; i = i + 1) begin
                                lane_data[8 + i] <= data_shift_reg[i*WIDTH +: WIDTH];
                            end
                            data_shift_reg <= data_shift_reg >> (8*WIDTH);
                        end
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                DEGRADE_LANES_0_TO_15: begin
                    if (cycle_count < CLOCK_CYCLES_16_LANES) begin
                        if (cycle_count == 0) begin
                            for (i = 0; i < NUM_LANES; i = i + 1) begin
                                lane_data[i] <= i_in_data[i*WIDTH +: WIDTH];
                            end
                            data_shift_reg <= i_in_data >> (NUM_LANES*WIDTH);  // Shift by 512 bits
                        end
                        else begin
                            for (i = 0; i < NUM_LANES; i = i + 1) begin
                                lane_data[i] <= data_shift_reg[i*WIDTH +: WIDTH];
                            end
                            data_shift_reg <= data_shift_reg >> (NUM_LANES*WIDTH);
                        end
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                default: begin
                    for (i = 0; i < NUM_LANES; i = i + 1) begin
                        lane_data[i] <= {WIDTH{1'b0}};
                    end
                    data_shift_reg <= 0;
                end
            endcase
        end
        else begin
            // IDLE state
            for (i = 0; i < NUM_LANES; i = i + 1) begin
                lane_data[i] <= {WIDTH{1'b0}};
            end
            cycle_count <= 0;
            data_shift_reg <= 0;
        end
    end

    // Combinational logic for lane assignments
    always @(*) begin
        o_lane_0  = lane_data[0];
        o_lane_1  = lane_data[1];
        o_lane_2  = lane_data[2];
        o_lane_3  = lane_data[3];
        o_lane_4  = lane_data[4];
        o_lane_5  = lane_data[5];
        o_lane_6  = lane_data[6];
        o_lane_7  = lane_data[7];
        o_lane_8  = lane_data[8];
        o_lane_9  = lane_data[9];
        o_lane_10 = lane_data[10];
        o_lane_11 = lane_data[11];
        o_lane_12 = lane_data[12];
        o_lane_13 = lane_data[13];
        o_lane_14 = lane_data[14];
        o_lane_15 = lane_data[15];
    end

endmodule