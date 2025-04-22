module Valtrain_Controller (
    // Input Ports
    input wire i_clk,                  // System clock input
    input wire i_rst_n,                // Active-low asynchronous reset
    input wire Valid_pattern_enable,   // Enable signal for pattern generator mode
    input wire valid_frame_enable,     // Enable signal for valid frame mode
    
    // Output Ports
    output  [31:0] o_TVLD_L,          // 32-bit valid pattern output (concatenated 4 times)
    output reg o_done,                 // Done signal indicating operation completion
    output reg enable_detector         // 1 when module is in any valid state
);

    // Internal Signals
    wire [1:0] i_current_state;        // 2-bit state indicator based on enable signals
    reg [31:0] TVLD_L;
    // State Encoding
    assign i_current_state = {Valid_pattern_enable, valid_frame_enable};
    assign o_TVLD_L = (i_current_state == 2'b10)? TVLD_L : (i_current_state == 2'b01)? 32'hf0f0f0f0 : 32'hf0f0f0f0;
    // 00: Idle Mode
    // 01: Valid Frame Mode
    // 10: Pattern Generator Mode
    // 11: Not used (treated as invalid in default case)

    // Parameters
    localparam VALID_8BIT = 8'b11110000;         // Base 8-bit pattern: 4 ones, 4 zeros
    localparam VALID_PATTERN = {VALID_8BIT, VALID_8BIT, VALID_8BIT, VALID_8BIT}; // 32-bit pattern: concatenate 4 times
    localparam MAX_COUNT = 31;              // Maximum counter value (7-bit counter)

    // Internal Registers
    reg [4:0] counter;                          // 4-bit counter for pattern transmission timing
    
    // Sequential Logic
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Asynchronous Reset: Initialize all registers to known states
            TVLD_L          <= 32'b0;          // Clear 32-bit pattern output
            counter         <= 7'b0;           // Reset counter to 0
            o_done          <= 1'b0;           // Clear done signal
            enable_detector <= 1'b0;           // Clear enable_detector during reset
        end 
        else begin
            // Synchronous Behavior based on current state
            case (i_current_state)
                2'b00: begin  // Idle Mode: Both enables are low
                    TVLD_L          <= 32'b0;          // Output all zeros (32-bit)
                    o_done          <= 1'b0;           // Not done in idle state
                    counter         <= 7'b0;           // Reset counter
                    enable_detector <= 1'b0;           // Active in idle mode
                end
                
                2'b01: begin  // Valid Frame Mode: valid_frame_enable = 1, Valid_pattern_enable = 0
                    TVLD_L          <= VALID_PATTERN;  // Output the 32-bit concatenated pattern
                    // o_done       <= 1'b1;           // Signal immediate completion (commented as in original)
                    counter         <= 7'b0;           // Keep counter reset
                    enable_detector <= 1'b1;           // Active in valid frame mode
                end
                
                2'b10: begin  // Pattern Generator Mode: Valid_pattern_enable = 1, valid_frame_enable = 0
                    counter <= counter + 1'b1;         // Increment counter each clock cycle
                    if (counter < MAX_COUNT) begin
                        TVLD_L          <= VALID_PATTERN; // Output the 32-bit concatenated pattern
                        o_done          <= 1'b0;          // Not done yet
                        enable_detector <= 1'b1;          // Active during pattern generation
                    end 
                    else begin  // counter == MAX_COUNT
                        TVLD_L          <= VALID_PATTERN; // Last cycle with concatenated pattern
                        o_done          <= 1'b1;          // Signal completion
                        enable_detector <= 1'b0;          // Still active at completion
                    end
                end
                
                2'b11: begin  // Invalid State: Both enables high (not intended in design)
                    TVLD_L          <= 32'b0;          // Default to all zeros (32-bit)
                    o_done          <= 1'b0;           // Not done
                    counter         <= 7'b0;           // Reset counter
                    enable_detector <= 1'b0;           // Inactive in invalid state
                end
                
                default: begin  // Catch-all for any unexpected state
                    TVLD_L          <= 32'b0;          // Safety default (32-bit)
                    o_done          <= 1'b0;
                    counter         <= 7'b0;
                    enable_detector <= 1'b0;           // Inactive in default case
                end
            endcase
        end
    end

endmodule