module SB_PATTERN_GEN (
	input 				i_clk,
	input 				i_rst_n, 
	input 				i_start_pattern_req,
	input 				i_rx_sb_pattern_samp_done,
	input 				i_ser_done,
	output 	reg			o_start_pattern_done,
	output	reg 		o_pattern_time_out,
	output 	reg	[63:0] 	o_pattern,	
	output 	reg			o_pattern_valid
);

reg [2:0] more_four_ittr_cntr; // for last more four itterations after receing sample done from my RX
reg 	  more_four_ittr_cntr_en; // signal to enable the above counter to work till send the more four pattern itterations
reg [6:0] 	one_ms_counter; //will assume that each 100 count (clk cycle) represents 1ms till now
reg			one_ms_counter_en; // will enable the above counter till done sent to LTSM or time out occurs
reg			send_pattern; // when high i know that this is the 1ms when is sends the pettern and when low i know that this is the 1ms when is i sleep
reg	[2:0]	eight_ms_counter; //pattern generator time out counter
	
//////////////////////////////////////////////////
/////// Logic to send pattern done to LTSM 
//////////////////////////////////////////////////	
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		more_four_ittr_cntr 	<= 0;
		more_four_ittr_cntr_en 	<= 0;
		o_start_pattern_done 	<= 0;
	end 
	else if (i_rx_sb_pattern_samp_done || (more_four_ittr_cntr_en && more_four_ittr_cntr < 3)) begin
		more_four_ittr_cntr_en 	<= 1;
		more_four_ittr_cntr 	<= more_four_ittr_cntr +1;
	end
	else if (more_four_ittr_cntr == 3) begin
		o_start_pattern_done 	<= 1;
		more_four_ittr_cntr 	<= 0;
		more_four_ittr_cntr_en 	<= 0;
	end
	else begin
		o_start_pattern_done 	<= 0;
		more_four_ittr_cntr 	<= 0;
		more_four_ittr_cntr_en 	<= 0;
	end
end


//////////////////////////////////////////////////
/////// Counters and time out logic
//////////////////////////////////////////////////	
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		one_ms_counter 				<= 0;
		one_ms_counter_en 			<= 0;
		send_pattern				<= 0;
		eight_ms_counter			<= 0;
		o_pattern_time_out			<= 0;
	end 
	else if (more_four_ittr_cntr == 3) begin // if we sent the last more 4 reset all counters and stop them and sleep
		one_ms_counter 				<= 0;
		send_pattern 				<= 0;
		one_ms_counter_en 			<= 0;
		eight_ms_counter 			<= 0;
	end
	else if (i_start_pattern_req || one_ms_counter_en) begin
		one_ms_counter_en 			<= 1;
		if (i_start_pattern_req) begin
			send_pattern 			<= 1;
		end
		if (one_ms_counter < 99) begin
			one_ms_counter 			<= one_ms_counter + 1;
		end
		else if (one_ms_counter == 99) begin // means that is a 1ms count
			one_ms_counter 			<= 0;
			eight_ms_counter 		<= eight_ms_counter + 1;
			if (eight_ms_counter == 7) begin // if time out send to LTSM and rest all counters and everything then do nothing
				o_pattern_time_out 	<= 1;
				send_pattern 		<= 0;
				one_ms_counter_en 	<= 0;
				eight_ms_counter 	<= 0;
			end
			else begin
				send_pattern = ~send_pattern; // if was sending the past ms then sleep and if was sleeping then start sending this 1ms
			end
		end
	end
	else begin
		o_pattern_time_out 			<= 0;
		one_ms_counter_en			<= 0;
		send_pattern 				<= 0;
		one_ms_counter_en 			<= 0;
		eight_ms_counter 			<= 0;
	end
end


//////////////////////////////////////////////////
/////// Pattern and its valod logic
//////////////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		o_pattern <= 0;
		o_pattern_valid <= 0;
	end 
	else if (send_pattern && i_ser_done) begin
		o_pattern <= {32{2'b10}};
		o_pattern_valid <= 1;
	end
	else begin
		o_pattern_valid <= 0;
	end
end

endmodule : SB_PATTERN_GEN
