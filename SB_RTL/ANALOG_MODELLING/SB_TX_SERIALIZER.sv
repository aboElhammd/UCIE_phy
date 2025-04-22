module SB_TX_SERIALIZER (
    input 		 i_pll_clk,           // Input clock from PLL (800 MHz)
    input 		 i_rst_n,             // Active-low reset
    input [63:0] i_data_in,   	      // Parallel input      
    input 	 	 i_enable,		      // Indicates valid data_in
    input        i_pack_finished,     // Indicates that packet serializing finished (level signal for 32 clock cycle)
    output reg 	 TXDATASB             // Serialized output
);

		              
/*------------------------------------------------------------------------------
--  LOCAL PARAMETERS
------------------------------------------------------------------------------*/
localparam IDLE      = 0;
localparam SHIFT     = 1;

/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
reg [63:0] shift_reg;         
reg cs,ns; 

/*------------------------------------------------------------------------------
-- Parallel to Serial   
------------------------------------------------------------------------------*/
always @(posedge i_pll_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		shift_reg <= 0;
		TXDATASB <= 0;
	end 
	else begin
		if (cs == IDLE && ns == SHIFT) begin
			TXDATASB <= i_data_in[63];
			shift_reg <= i_data_in<<1;
		end
		else begin
			if (cs == SHIFT) begin
				TXDATASB <= shift_reg[63];
				shift_reg <= shift_reg<<1;
			end
		end
	end
end

/*------------------------------------------------------------------------------
-- State Transition Logic   
------------------------------------------------------------------------------*/
always @(posedge i_pll_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		cs <= IDLE;
	end 
	else begin
		cs <= ns;
	end
end

/*------------------------------------------------------------------------------
-- Next State Logic   
------------------------------------------------------------------------------*/
always @(*) begin 
	case (cs)
        IDLE: begin
            if (i_enable) begin
                if (i_pack_finished) begin
            		ns = IDLE;
            	end
            	else begin
            		ns = SHIFT;
            	end
            end
        end

        SHIFT: begin
        	if (i_pack_finished) begin
        		ns = IDLE;
        	end
        	else begin
        		ns = SHIFT;
        	end
        end

        default: ns = IDLE;
    endcase
end

endmodule
