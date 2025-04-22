module valid_busy_control (
    input  logic clk,      // Clock signal
    input  logic rst_n,    // Active-low reset
    input  logic valid,    // Input valid signal
    output logic busy      // Output busy signal
);

    // Internal counter to track the number of clock cycles
    logic [2:0] counter;   // 3-bit counter (enough for 6 cycles)

    // FSM states
    typedef enum logic [1:0] {
        IDLE,               // Waiting for valid to go high
        BUSY_HIGH,          // Busy is high for 5 cycles
        BUSY_LOW            // Busy is low after 6 cycles
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            counter <= 3'b000;
        end else begin
            current_state <= next_state;
            if (current_state == BUSY_HIGH || current_state == BUSY_LOW) begin
                counter <= counter + 1; // Increment counter in BUSY states
            end else begin
                counter <= 3'b000; // Reset counter in IDLE state
            end
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (valid) begin
                    next_state = BUSY_HIGH; // Move to BUSY_HIGH when valid is high
                end else begin
                    next_state = IDLE; // Stay in IDLE if valid is low
                end
            end

            BUSY_HIGH: begin
                if (counter == 4) begin // After 5 cycles (0 to 4), move to BUSY_LOW
                    next_state = BUSY_LOW;
                end else begin
                    next_state = BUSY_HIGH; // Stay in BUSY_HIGH
                end
            end

            BUSY_LOW: begin
                if (counter == 5) begin // After 6 cycles (0 to 5), return to IDLE
                    next_state = IDLE;
                end else begin
                    next_state = BUSY_LOW; // Stay in BUSY_LOW
                end
            end

            default: next_state = IDLE; // Default to IDLE
        endcase
    end

    // Output logic
    assign busy = (current_state == BUSY_HIGH);

endmodule