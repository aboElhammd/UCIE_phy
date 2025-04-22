`timescale 1ns/1ps

module SB_CLK_TB ;

	bit pll_clk;
	logic rst_n;
	logic divided_clk;
	logic TXCKSB;
	logic ser_en;
	logic enable;

	Clock_Divider_by_8 clk_div_dut (.*);
	SB_CLOCK_CONTROLLER clk_ctrl_dut (.*);

	// Generate PLL clock (800 MHz)
    initial begin
        pll_clk = 0; // Initialize clock to 0
        forever #625 pll_clk = ~pll_clk; // Toggle clock every 625 ps (0.625 ns)
    end

    initial begin
        rst_n = 0;
        #1000;    
        rst_n = 1; 
        enable = 1;
        #1000000;  
        $stop;     
    end

endmodule : SB_CLK_TB
