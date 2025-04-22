module SB_PACKET_ENCODER_MUX (
	input 		[63:0] 	i_pattern,                // Pattern to be send
	input 		[63:0] 	i_framed_packet_phase,    // Packet to be send
	input 				i_pattern_valid,          // Indication that pattern valid
	input				i_packet_valid,           // Indication that packet valid
	output reg 	[63:0] 	o_final_packet            // Muxed output
);

/*------------------------------------------------------------------------------
-- Muxing between pattern and packet
------------------------------------------------------------------------------*/
always @(*) begin 
	if (i_pattern_valid) begin
		o_final_packet = i_pattern;
	end
	else if (i_packet_valid) begin
		o_final_packet = i_framed_packet_phase;
	end
	else begin
		o_final_packet = 0;
	end
end

endmodule : SB_PACKET_ENCODER_MUX
