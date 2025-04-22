module SB_TX_SERIALIZER_TB;

    // Testbench signals
    reg pll_clk;           // Input clock from PLL (800 MHz)
    reg rst_n;             // Active-low reset
    reg [63:0] data_in;    // 64-bit parallel input
    reg data_valid;        // Indicates valid data_in
    reg enable;            // Enable signal for serializer
    wire TXDATASB;         // Serialized output

    // Instantiate the serializer
    SB_TX_SERIALIZER ser_dut (
        .pll_clk(pll_clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_valid(data_valid),
        .enable(enable),
        .TXDATASB(TXDATASB)
    );

    // Generate PLL clock (800 MHz)
    initial begin
        pll_clk = 0;
        forever #625 pll_clk = ~pll_clk; // 1.25 ns period (800 MHz)
    end

    // Apply reset and run simulation
    initial begin
        rst_n = 0; // Assert reset
        #10000;    // Wait for 10 ns (10,000 ps)
        rst_n = 1; // Release reset

        // Test case 1: Serialize a 64-bit data packet
        @(posedge pll_clk);
        data_in = 64'hA5A5A5A5A5A5A5A5; // Example data
        data_valid = 1; // Assert data_valid
        enable = 1; // Enable serializer
        #80000; // Wait for 80 ns (64 cycles at 800 MHz)

        // Test case 2: Disable serializer
        enable = 0;
        #40000; // Wait for 40 ns (32 cycles at 800 MHz)

        // End simulation
        $stop;
    end

endmodule
