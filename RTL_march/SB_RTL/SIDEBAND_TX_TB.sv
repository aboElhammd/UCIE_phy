`timescale 1ns/1ps

module SIDEBAND_WRAPPER_TB;

    // Testbench signals
    logic pll_clk;          // Input clock from PLL (800 MHz)
    logic rst_n;            // Active-low reset
    logic TXCKSB;          // Gated clock output
    logic TXDATASB;        // Serialized output
    logic [63:0] data_in;		   // Data from fifo 
    logic enable;	       // enable from fifo that it is not empty

    // Instantiate the wrapper
    SIDEBAND_TX_WRAPPER sideband_tx_dut (
        .pll_clk(pll_clk),
        .rst_n(rst_n),
        .data_in (data_in),
        .enable  (enable),
        .TXCKSB(TXCKSB),
        .TXDATASB(TXDATASB)
    );

    // Generate PLL clock (800 MHz)
    initial begin
        pll_clk = 0;
        forever #625 pll_clk = ~pll_clk; // 1.25 ns period (800 MHz)
    end

    initial begin
        rst_n = 0;       
        data_in = 64'hA5A5A5A5A5A5A5A5; 
        enable = 0;       
        repeat(8) @(posedge pll_clk);

        // Release reset and enable the system
        rst_n = 1;       
        enable = 1;      
        repeat(2*96) @(posedge pll_clk);

        data_in = 64'hB4B4B4B4B4B4B4B4; 
        repeat(2) @(posedge pll_clk);
        data_in = 0; 
        repeat(2*96) @(posedge pll_clk);
        // Disable the system
        enable = 0;      
        repeat(2*96) @(posedge pll_clk);          

        // End simulation
        $stop;
    end

endmodule
