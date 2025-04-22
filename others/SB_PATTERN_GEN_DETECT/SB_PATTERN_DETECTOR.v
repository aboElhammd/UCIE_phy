module SB_PATTERN_DETECTOR (
	input 				i_clk,    
	input 				i_rst_n, 
	input      [63:0] 	i_de_ser_data,
	input 		    	i_de_ser_valid,
	input      [2:0] 	i_state,
	output reg          o_rx_sb_pattern_samp_done,
	output reg [63:0]   o_pattern_out,             // da el bus ely h3mlo bypass ll message decoder lw fe ay state tanya 8er el RESET aw SBINIT
	output reg          o_pattern_out_valid,       // de ely ht2ol ll message decoder eny ha bypass leh el packet lw ana fe ay state tanya 8er RESET aw SBINIT
	output reg          o_rx_sb_start_pattern // de signal ray7a le sa3dany in case en el partner die hya ely bt inialize el communication we b3tt pattern el awl fa ana 3mltlo detect we  
);

// parameters for the general states
localparam RESET = 0;
localparam SBINIT = 1;

reg [1:0] counter_sbinit; // counter to count two packets of pattern are recieved successfully
reg pattern_passed; // variable return from function as indication that the recieved pattern is correct

always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		o_rx_sb_pattern_samp_done <= 0;
		o_pattern_out_valid <= 0;
		o_pattern_out <= 0;
		counter_sbinit <= 0;
		pattern_passed <= 0;
	end 
	else begin
		o_rx_sb_pattern_samp_done <= 0;
		o_pattern_out_valid <= 0;
		o_pattern_out <= 0;
		o_rx_sb_start_pattern <= 0;

		case (i_state)

			RESET : begin
				if (i_de_ser_valid) begin
					if (counter_sbinit < 1) begin
						pattern_passed = correct_pattern(i_de_ser_data);
						if (pattern_passed) begin
							counter_sbinit <= counter_sbinit + 1;
						end
					end
					else if (counter_sbinit == 1) begin
						pattern_passed = correct_pattern(i_de_ser_data);
						if (pattern_passed) begin
							o_rx_sb_start_pattern <= 1;
							counter_sbinit <= 0;
						end
					end
				end
				else begin
					o_rx_sb_start_pattern <= 0;
					o_pattern_out_valid <= 0;
					o_pattern_out <= 0;
				end
			end

			SBINIT : begin
				if (i_de_ser_valid) begin
					if (counter_sbinit < 1) begin
						pattern_passed = correct_pattern(i_de_ser_data);
						if (pattern_passed) begin
							counter_sbinit <= counter_sbinit + 1;
						end
						else begin
							o_pattern_out_valid <= 1;
							o_pattern_out <= i_de_ser_data;
						end
					end
					else if (counter_sbinit == 1) begin
						pattern_passed = correct_pattern(i_de_ser_data);
						if (pattern_passed) begin
							o_rx_sb_pattern_samp_done <= 1;
							counter_sbinit <= 0;
						end
						else begin
							o_pattern_out_valid <= 1;
							o_pattern_out <= i_de_ser_data;
						end
					end
				end
				else begin
					o_rx_sb_pattern_samp_done <= 0;
					o_pattern_out_valid <= 0;
					o_pattern_out <= 0;
				end
			end
			
			default : begin // in any other state after SBINIT pattern detector will be inactive -> bypass to message decoder
				o_rx_sb_pattern_samp_done <= 0;
				o_rx_sb_start_pattern <= 0;
				o_pattern_out_valid <= 1;
				o_pattern_out <= i_de_ser_data;
			end 
		endcase
	end
end

// Function to detect pattern 
function correct_pattern (input [63:0] data);
	integer i;
    begin
        correct_pattern = 1; 
        for (i = 0; i < 62; i = i + 1) begin
            if (data[i] == data[i+1]) begin
                correct_pattern = 0; 
            end
        end
        if (data[63] != 1) begin
            correct_pattern = 0;
        end     
    end
endfunction

endmodule : SB_PATTERN_DETECTOR

