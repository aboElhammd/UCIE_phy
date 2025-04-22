module signal_delay #(
    parameter int DELAY_CYCLES = 6,  // Number of clock cycles to delay
    parameter int SIGNAL_WIDTH = 4   // Width of the input/output signals
)(
    input  logic clk,                // Clock signal
    input  logic rst_n,              // Active-low reset
    input  logic [SIGNAL_WIDTH-1:0] in_signal, // Input signal
    output logic [SIGNAL_WIDTH-1:0] out_signal // Delayed output signal
);

    // Internal shift register to implement the delay
    logic [SIGNAL_WIDTH-1:0] delay_reg [DELAY_CYCLES-1:0];

    // Shift register logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to 0
            for (int i = 0; i < DELAY_CYCLES; i = i + 1) begin
                delay_reg[i] <= {SIGNAL_WIDTH{1'b0}}; // Fill with zeros
            end
        end else begin
            // Shift the values through the delay registers
            for (int i = DELAY_CYCLES-1; i > 0; i = i - 1) begin
                delay_reg[i] <= delay_reg[i-1];
            end
            // Load the input signal into the first register
            delay_reg[0] <= in_signal;
        end
    end

    // Assign the delayed output signal
    assign out_signal = delay_reg[DELAY_CYCLES-1];

endmodule