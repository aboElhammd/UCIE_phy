module SB_RX_DESER (
    input    i_clk,          // Clock signal
    input    i_clk_pll,
    input    i_rst_n,        // Reset signal
    input    ser_data_in,  // Serial input data (1 bit per clock cycle)
    input    i_de_ser_done_sampled,
    output reg [63:0] par_data_out, // Parallel output data (64 bits)
    output reg de_ser_done   // Signal to indicate deserialization is done
);

    reg [6:0] bit_count;     // Counter to track the number of bits received
    reg [63:0] shift_reg;    // Shift register to store the incoming bits

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
