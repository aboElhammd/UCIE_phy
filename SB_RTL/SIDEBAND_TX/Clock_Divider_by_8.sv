module Clock_Divider_by_8 (
    input      i_pll_clk,          // Input clock from PLL (800 MHz)
    input      i_rst_n,            // Active-low reset
    output reg o_divided_clk       // Divided clock (100 MHz)
);

/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
reg [1:0] counter;       

/*------------------------------------------------------------------------------
-- Clock Divider logic   
------------------------------------------------------------------------------*/
always @(posedge i_pll_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        counter <= 0;
        o_divided_clk <= 0;
    end else begin
        if (counter == 3) begin
            counter <= 0;        
            o_divided_clk <= ~o_divided_clk; 
        end else begin
            counter <= counter + 1; 
        end
    end
end

endmodule
