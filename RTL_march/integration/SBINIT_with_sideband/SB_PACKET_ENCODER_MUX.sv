module SB_PACKET_ENCODER_MUX (
	input 		[63:0] 	i_pattern,
	input 		[63:0] 	i_framed_packet_phase,
	input 				i_pattern_valid,
	input				i_packet_valid,
	output reg 	[63:0] 	o_final_packet
);

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
