module SB_PACKET_FRAMING (
	input 				i_clk,
	input 				i_rst_n,
	input		[61:0]	i_header,
	input		[63:0]	i_data,
	input				i_header_valid,
	input 				i_data_valid,
	input 				i_d_valid,
	input 				i_ser_done,
	output	reg	[63:0]	o_framed_packet_phase,
	output 	reg			o_timeout_ctr_start,
	output 	reg			o_packet_valid
);

/*------------------------------------------------------------------------------
-- Internal Regs 
------------------------------------------------------------------------------*/
reg [63:0] total_header;
reg cp, dp;
reg cp_ready, dp_ready;
reg msg_with_data;
reg header_phase_sent;

/*------------------------------------------------------------------------------
-- Conditions
------------------------------------------------------------------------------*/
assign READY_TO_SEND_HEADER = cp_ready && dp_ready && i_ser_done && !header_phase_sent;
assign READY_TO_SEND_DATA 	= header_phase_sent && i_ser_done && msg_with_data;


/*------------------------------------------------------------------------------
-- Control partity calculation 
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		cp 			<= 0;
		cp_ready 	<= 0;
	end 
	else if (i_header_valid) begin
		cp 			<= ^i_header;
		cp_ready 	<=	1;
	end
	else if (header_phase_sent) begin
		cp_ready 	<= 0;
	end
end


/*------------------------------------------------------------------------------
-- Data partity calculation 
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		dp 					<= 0;
		dp_ready 			<= 0;
		msg_with_data 		<= 0;
	end 
	else if (i_d_valid) begin
		dp 					<= ^i_data;
		dp_ready 			<=	1;
		if (i_data_valid) begin
			msg_with_data 	<= 1;
		end
		else begin
			msg_with_data	<= 0;
		end
	end
	else if (header_phase_sent) begin
		dp_ready 			<= 0;
	end
end


always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		o_framed_packet_phase 		<= 0;
		o_timeout_ctr_start			<= 0; 
		o_packet_valid 				<= 0;
		header_phase_sent 			<= 0;
	end 
	else begin
		if (READY_TO_SEND_HEADER) begin
			o_framed_packet_phase 	<= {dp, cp, i_header}; 
			o_packet_valid 			<= 1;
			header_phase_sent 		<= 1;
			if (i_header[17:14] == 5) begin
				o_timeout_ctr_start		<= 1;
			end
		end
		else if (READY_TO_SEND_DATA) begin
			o_framed_packet_phase 	<= i_data;
			o_timeout_ctr_start		<= 0;
			header_phase_sent 		<= 0;
			o_packet_valid 		  	<= 1;
		end
		else if (header_phase_sent && !msg_with_data) begin
			o_timeout_ctr_start		<= 0; 
			o_packet_valid 			<= 0;
			header_phase_sent 		<= 0;
		end
		else begin
			o_timeout_ctr_start		<= 0; 
			o_packet_valid 			<= 0;
		end
	end
end

endmodule : SB_PACKET_FRAMING