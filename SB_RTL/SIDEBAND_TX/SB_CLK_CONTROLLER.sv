module SB_CLOCK_CONTROLLER (
    input           i_pll_clk,              // Input clock from PLL (800 MHz)
    input           i_rst_n,                // Active-low reset
    input           i_enable,               // Enable that there is a packet want to be send to active clock
    output reg      o_pack_finished,        // Indicates that packet serializing finished (level signal for 32 clock cycle)
    output reg      o_ser_done,             // Indication that serializer finished serializing 64 bits (pulse level)
    output          TXCKSB                  // Gated clock output
);

/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
reg [8:0] counter;           // Counter for 96 cycle to be repeated
reg clock_enable;            // Clock enable for 96 cycle (64 active and 32 sleep)
wire ser_en;                 // Enable for not gating the clock
reg ser_en_latched;          // Latched version of ser_en

/*------------------------------------------------------------------------------
-- Conditions
------------------------------------------------------------------------------*/
assign ser_en = ((i_enable || clock_enable) && counter < 9'd64);


/*------------------------------------------------------------------------------
-- Gated output clock
------------------------------------------------------------------------------*/
assign TXCKSB = (i_pll_clk && ser_en_latched);  

/*------------------------------------------------------------------------------
-- Latch for Clock Gating
------------------------------------------------------------------------------*/
always @(*) begin
    if (!i_pll_clk) begin
        ser_en_latched = ser_en; // Latch ser_en when clock is low
    end
end

/*------------------------------------------------------------------------------
-- Serializing Done Indication
------------------------------------------------------------------------------*/
always @(posedge i_pll_clk or negedge i_rst_n) begin 
    if(~i_rst_n) begin
        o_ser_done <= 0;
    end 
    else begin
        if (counter == 9'd64) begin
            o_ser_done <= 1;
        end
        else begin
            o_ser_done <= 0;
        end
    end
end    

/*------------------------------------------------------------------------------
-- Packet Serializing Finished Logic
------------------------------------------------------------------------------*/
always @(posedge i_pll_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        counter <= 9'b0;
        o_pack_finished <= 0;
        clock_enable <= 0;
    end 
    else begin
    	if (i_enable || clock_enable) begin
    		clock_enable <= 1;
    		counter <= counter + 1;
            if (counter == 9'd96) begin
                counter <= 9'b0;
                o_pack_finished <= 0; 
                clock_enable <= 0;
            end
            else if (counter > 9'd64) begin
                o_pack_finished <= 1;
            end
            else begin
                o_pack_finished <= 0;
            end           
    	end  
    end
end

endmodule
