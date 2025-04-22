module SIDEBAND_TX_WRAPPER (
    input     	 	pll_clk,          // Input clock from PLL (800 MHz)
    input      		rst_n,            // Active-low reset
    input [63:0]	data_in,
    input           enable,
    output     		TXCKSB,           // Clock output
    output     		TXDATASB          // Data output
);

    // Internal signals
    wire divided_clk;            // Divided clock (100 MHz)
    reg pack_finished;

    // Instantiate Clock Divider by 8
    Clock_Divider_by_8 clock_divider_inst (
        .pll_clk(pll_clk),
        .rst_n(rst_n),
        .divided_clk(divided_clk)
    );

    // Instantiate SB_CLOCK_CONTROLLER
    SB_CLOCK_CONTROLLER clock_controller_inst (
        .pll_clk(pll_clk),
        .rst_n(rst_n),
        .enable(enable),
        .pack_finished(pack_finished),
        .TXCKSB(TXCKSB)
    );

    // Instantiate SB_TX_SERIALIZER
    SB_TX_SERIALIZER tx_serializer_inst (
        .pll_clk(pll_clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .enable(enable),
        .pack_finished(pack_finished),
        .TXDATASB(TXDATASB)
    );

endmodule

