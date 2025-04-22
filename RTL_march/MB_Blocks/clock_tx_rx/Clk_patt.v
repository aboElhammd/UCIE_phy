module UCIe_Clock_Mode_Generator (
    input  wire        i_clk1,           // Clock 1 for CKP
    input  wire        i_clk2,           // Clock 2 for CKN
    input  wire        i_rst_n,
    input  wire        i_valid,
    input  wire        i_mode,
    input  wire        i_state_indicator,
    output wire        CKP,
    output wire        CKN,
    output wire        Track,
    output reg         o_done,
    output reg         enable_detector_CKP,    // Enable detector for CKP
    output reg         enable_detector_CKN,    // Enable detector for CKN
    output reg         enable_detector_Track   // Enable detector for Track
);

    // Registers for repair mode (sequential)
    reg        clk_state;
    reg        phase_shift_state;
    reg [5:0]  repair_cycle_count;
    reg [12:0] repair_iter_count;

    // Combinatorial signals
    reg        comb_clk_state;
    reg        comb_phase_shift_state;

    localparam REPAIR_CYCLES_HIGH = 6'd32;
    localparam REPAIR_CYCLES_LOW  = 5'd16;
    localparam REPAIR_ITERATIONS  = 6144;

    // Combinatorial logic for non-repair mode with nested if-else
    always @(*) begin
        // Logic for comb_clk_state (CKP)
        if (i_mode == 1'b0) begin  // Strobe mode
            if (i_valid == 1'b1) begin
                comb_clk_state = i_clk1;  // Forward i_clk1 when i_valid = 1
            end
            else begin
                comb_clk_state = 1'b0;    // 0 when i_valid = 0
            end
        end
        else begin  // Continuous mode
            comb_clk_state = i_clk1;      // Directly forward i_clk1
        end

        // Logic for comb_phase_shift_state (CKN)
        if (i_mode == 1'b0) begin  // Strobe mode
            if (i_valid == 1'b1) begin
                comb_phase_shift_state = i_clk2;  // Forward i_clk2 when i_valid = 1
            end
            else begin
                comb_phase_shift_state = 1'b0;    // 0 when i_valid = 0
            end
        end
        else begin  // Continuous mode
            comb_phase_shift_state = i_clk2;      // Directly forward i_clk2
        end
    end

    // Output assignments: use sequential state in repair mode, combinatorial otherwise
    assign CKP = i_state_indicator ? clk_state : comb_clk_state;
    assign CKN = i_state_indicator ? phase_shift_state : comb_phase_shift_state;
    assign Track = CKP;

    // Sequential logic for repair mode (CKP) - i_clk1 domain
    always @(posedge i_clk1 or negedge i_rst_n) begin
        if (!i_rst_n) begin
            clk_state            <= 1'b0;
            repair_cycle_count   <= 6'd0;
            repair_iter_count    <= 13'd0;
            o_done               <= 1'b0;
            enable_detector_CKP  <= 1'b0;  // Reset CKP enable detector
            enable_detector_Track<= 1'b0;  // Reset Track enable detector
        end
        else if (i_state_indicator) begin
            if (repair_iter_count < REPAIR_ITERATIONS) begin
                repair_iter_count <= repair_iter_count + 1'b1;
                o_done <= 1'b0;
                enable_detector_CKP <= 1'b1;    // CKP pattern is being sent
                enable_detector_Track <= 1'b1;  // Track follows CKP
                if (repair_cycle_count < REPAIR_CYCLES_HIGH) begin
                    clk_state <= ~clk_state;
                    repair_cycle_count <= repair_cycle_count + 1'b1;
                end
                else if (repair_cycle_count < (REPAIR_CYCLES_HIGH + REPAIR_CYCLES_LOW)) begin
                    clk_state <= 1'b0;
                    repair_cycle_count <= repair_cycle_count + 1'b1;
                end
                else begin
                    repair_cycle_count <= 6'd0;
                end
            end
            else begin
                clk_state            <= 1'b0;
                repair_iter_count    <= 13'd0;
                repair_cycle_count   <= 6'd0;
                o_done               <= 1'b1;
                enable_detector_CKP  <= 1'b0;  // CKP pattern sending complete
                enable_detector_Track<= 1'b0;  // Track pattern sending complete
            end
        end
        else begin
            enable_detector_CKP   <= i_valid & ~i_mode;  // Active in strobe mode when valid
            enable_detector_Track <= i_valid & ~i_mode;  // Track follows CKP
        end
    end

    // Sequential logic for repair mode (CKN) - i_clk2 domain
    always @(posedge i_clk2 or negedge i_rst_n) begin
        if (!i_rst_n) begin
            phase_shift_state   <= 1'b0;
            enable_detector_CKN <= 1'b0;  // Reset CKN enable detector
        end
        else if (i_state_indicator) begin
            if (repair_iter_count < REPAIR_ITERATIONS) begin
                enable_detector_CKN <= 1'b1;  // CKN pattern is being sent
                if (repair_cycle_count < REPAIR_CYCLES_HIGH) begin
                    phase_shift_state <= ~phase_shift_state;
                end
                else if (repair_cycle_count < (REPAIR_CYCLES_HIGH + REPAIR_CYCLES_LOW)) begin
                    phase_shift_state <= 1'b0;
                end
            end
            else begin
                phase_shift_state   <= 1'b0;
                enable_detector_CKN <= 1'b0;  // CKN pattern sending complete
            end
        end
        else begin
            enable_detector_CKN <= i_valid & ~i_mode;  // Active in strobe mode when valid
        end
    end

endmodule