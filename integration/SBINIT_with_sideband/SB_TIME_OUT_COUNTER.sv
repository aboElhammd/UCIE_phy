module TIME_OUT_COUNTER (
	input 		i_clk,
	input 		i_rst_n,
	input 		i_start_cnt,
	input 		i_rx_sb_rsp_delivered,
	input 		i_stop_cnt,
	input       i_pattern_time_out,
	output	reg o_time_out
);

reg [6:0] 	one_ms_counter; //will assume that each 100 count (clk cycle) represents 1ms till now
reg			one_ms_counter_en; // will enable the above counter till done sent to LTSM or time out occurs
reg	[2:0]	eight_ms_counter; //Time out counter

always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		one_ms_counter 				<= 0;
		one_ms_counter_en			<= 0;
		eight_ms_counter			<= 0;
		o_time_out					<= 0;
	end 
	else if (i_pattern_time_out) begin
		o_time_out <= 1;
	end
	else if (i_rx_sb_rsp_delivered || i_stop_cnt) begin
		one_ms_counter 				<= 0;
		one_ms_counter_en			<= 0;
		eight_ms_counter			<= 0;
		//o_time_out					<= 0;
	end
	else if (i_start_cnt || one_ms_counter_en) begin
		one_ms_counter_en			<= 1;
		if (one_ms_counter < 99) begin
			one_ms_counter 			<= one_ms_counter + 1;
		end
		else if (one_ms_counter == 99) begin
			one_ms_counter 			<= 0;
			eight_ms_counter 		<= eight_ms_counter +1;
			if (eight_ms_counter == 7) begin
				o_time_out 			<= 1;
				one_ms_counter_en	<= 0;
				eight_ms_counter	<= 0;
			end
		end
	end
	else begin
		o_time_out 			<= 0;
		one_ms_counter 		<= 0;
		one_ms_counter_en	<= 0;
		eight_ms_counter	<= 0;
	end
end



endmodule : TIME_OUT_COUNTER