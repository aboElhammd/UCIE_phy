module SB_CLOCK_CONTROLLER (

    input      i_pll_clk,          // Input clock from PLL (800 MHz)
    input      i_rst_n,            // Active-low reset
    input      i_enable,           // enable that there is a packet want to be send
    input      i_ser_done_sampled,
    output reg o_pack_finished,
    output reg o_ser_done,
    output reg last_pack,
    output     TXCKSB              // Gated clock output
);

    reg [8:0] counter;    
    reg clock_enable; 
    wire ser_en;
    reg ser_en_latched; // Latched version of ser_en
    reg last_pack_sent;

    // Gated clock output
    assign TXCKSB = (i_pll_clk && ser_en_latched);  
    assign ser_en = ((i_enable || clock_enable) && counter < 9'd64);

    // Latch for clock gating
    always @(*) begin
        if (!i_pll_clk) begin
            ser_en_latched = ser_en; // Latch ser_en when clock is low
        end
    end

    always @(posedge i_pll_clk or negedge i_rst_n) begin 
        if(~i_rst_n) begin
            o_ser_done <= 0;
        end 
        else begin
            if (counter == 9'd64) begin
                o_ser_done <= 1;
            end
            // else if(i_ser_done_sampled) begin
            //     o_ser_done <= 0;
            // end
            else begin
                o_ser_done <= 0;
            end
        end
    end    

    always @(posedge i_pll_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            counter <= 9'b0;
            o_pack_finished <= 0;
            clock_enable <= 0;
            last_pack_sent <= 0;
        end 
        else begin
        	if (i_enable || clock_enable) begin
                // handle last pack
                // if (last_pack && counter == 1) begin
                //     last_pack_sent <= 1;
                // end
                // else if(i_enable) begin
                //     last_pack_sent <= 0;
                // end

                // handle clock enable
        		clock_enable <= 1;
        		if (counter > 9'd64) begin
	                // Gated clock for 32 cycles
	                o_pack_finished <= 1;
	            end
                else begin
                    o_pack_finished <= 0;
                end

	            // Counter for 96 cycle to be repeated
	            counter <= counter + 1;
	            if (counter == 9'd96) begin
	                counter <= 8'b0;
	                o_pack_finished <= 0; 
                    clock_enable <= 0;
	            end

        	end  
        end
    end

    always @(posedge i_pll_clk or negedge i_rst_n) begin 
        if(~i_rst_n) begin
            last_pack <= 0;
        end 
        else begin
            // if (last_pack) begin
            //     last_pack <= 0;
            // end
            if (~i_enable && counter == 0 && !last_pack_sent) begin
                last_pack <= 1;
            end
            else begin
                last_pack <= 0;
            end
        end
    end

endmodule
