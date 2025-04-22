module SB_RX_DESER (
    input                i_clk,                     // Recieved clock to sample data (800 MHz)
    input                i_clk_pll,                 // Local pll clock (800 MHz)
    input                i_rst_n,                   // Active-low reset
    input                ser_data_in,               // Serial input data 
    input                i_de_ser_done_sampled,     // Signal to indicated that de ser done sampled by the slow clock in digital domain
    output reg [63:0]    par_data_out,              // Parallel output data 
    output reg           de_ser_done                // Signal to indicate deserialization is done
);

/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
reg [6:0] bit_count;     // Counter to track the number of bits received
reg [63:0] shift_reg;    // Shift register to store the incoming bits

/*------------------------------------------------------------------------------
-- Serial to Parallel   
------------------------------------------------------------------------------*/
always @(negedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        bit_count <= 0;
        shift_reg <= 0;
        par_data_out <= 0;
    end 
    else begin
        if (bit_count < 7'd63) begin
            shift_reg <= {shift_reg[62:0], ser_data_in}; 
            bit_count <= bit_count + 1;
        end else begin
            par_data_out <= {shift_reg[62:0], ser_data_in}; 
            bit_count <= 0;   
            shift_reg <= 0;  
        end
    end
end

/*------------------------------------------------------------------------------
-- De-serialization done indication  
------------------------------------------------------------------------------*/
always @(posedge i_clk_pll or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		de_ser_done <= 0; 
	end else begin
		if (bit_count == 7'd62) begin
			de_ser_done <= 1;
		end
		else if(i_de_ser_done_sampled) begin
			de_ser_done <= 0;
		end
	end
end

endmodule
