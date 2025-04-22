module SB_PACKET_FRAMING_TB ();

	logic 			i_clk_tb;
	logic 			i_rst_n_tb;
	logic	[61:0]	i_header_tb;
	logic	[63:0]	i_data_tb;
	logic			i_header_valid_tb;
	logic			i_data_valid_tb;
	logic 			i_ser_done_tb;
	logic	[63:0]	o_framed_packet_phase_tb;
	logic 			o_timeout_ctr_start_tb;
	logic 			o_packet_valid_tb;



		SB_PACKET_FRAMING DUT
		(
			.i_clk                 (i_clk_tb),
			.i_rst_n               (i_rst_n_tb),
			.i_header              (i_header_tb),
			.i_data                (i_data_tb),
			.i_header_valid        (i_header_valid_tb),
			.i_data_valid          (i_data_valid_tb),
			.i_ser_done            (i_ser_done_tb),
			.o_framed_packet_phase (o_framed_packet_phase_tb),
			.o_timeout_ctr_start   (o_timeout_ctr_start_tb),
			.o_packet_valid        (o_packet_valid_tb)
		);


		initial begin
			i_clk_tb = 0;
			forever begin
				#1 i_clk_tb = ~i_clk_tb;
			end
		end

		initial begin
			// Initialize inputs
	    	init();

	    	// Reset 
	    	rst();


			// NORMAL PACKET WITH DATA TEST CASE
			repeat (10) PKT_WiTH_DATA_test_case();

			// NORMAL PACKET WITH DATA BUT NOT IMMEDIATE SER DONE EN HIGH TEST CASE
			repeat (10) PKT_WiTH_DATA_RAND_SER_EN_test_case();

			// NORMAL PACKET WITHOUT DATA
			repeat (10) PKT_WiTHOUT_DATA_test_case();

			$stop;
		end


		task init();
			i_header_tb 		= 0;
			i_data_tb 			= 0;
			i_header_valid_tb	= 0;
			i_data_valid_tb		= 0;
			i_ser_done_tb		= 0;
		endtask

		task rst();
			i_rst_n_tb = 0;
			repeat (10) @(negedge i_clk_tb);
			i_rst_n_tb = 1;
		endtask : rst



		task PKT_WiTH_DATA_test_case();
			i_data_tb = $random();
			i_header_tb = $random();
			i_header_tb [17:14] = $urandom_range(1,10);
			i_header_valid_tb	= 1;
			i_data_valid_tb		= 1;
			i_ser_done_tb		= 1;
			@(negedge i_clk_tb);
			i_header_valid_tb	= 0;
			i_data_valid_tb		= 0;
			@(negedge i_clk_tb);
			if (!o_packet_valid_tb) begin
				$display("t: OUTPUT HEADER VALID ERROR", $time());
			end
			else if ((!o_timeout_ctr_start_tb  && i_header_tb [17:14] == 5) || (o_timeout_ctr_start_tb  && i_header_tb [17:14] != 5)) begin
				$display("t: OUTPUT TIMEOUT COUNTER START ERROR", $time());
			end
			else if (o_framed_packet_phase_tb != {^i_data_tb ,^i_header_tb, i_header_tb}) begin
				$display("t: OUTPUT HEADER PHASE ERROR", $time());
			end
			@(negedge i_clk_tb);
			if (!o_packet_valid_tb) begin
				$display("t: OUTPUT DATA VALID ERROR", $time());
			end
			else if (o_timeout_ctr_start_tb) begin
				$display("t: OUTPUT TIMEOUT COUNTER START ERROR", $time());
			end
			else if (o_framed_packet_phase_tb != i_data_tb) begin
				$display("t: OUTPUT DATA PHASE ERROR", $time());
			end

			repeat (10) @(negedge i_clk_tb);

		endtask : PKT_WiTH_DATA_test_case

		task PKT_WiTH_DATA_RAND_SER_EN_test_case();
			i_data_tb = $random();
			i_header_tb = $random();
			i_header_tb [17:14] = $urandom_range(1,10);
			i_header_valid_tb	= 1;
			i_data_valid_tb		= 1;
			@(negedge i_clk_tb);
			i_header_valid_tb	= 0;
			i_data_valid_tb		= 0;
			i_ser_done_tb = 0;
			repeat (5) @(negedge i_clk_tb);
			i_ser_done_tb = 1;
			@(negedge i_clk_tb);
			if (!o_packet_valid_tb) begin
				$display("t: OUTPUT HEADER VALID ERROR", $time());
			end
			else if ((!o_timeout_ctr_start_tb  && i_header_tb [17:14] == 5) || (o_timeout_ctr_start_tb  && i_header_tb [17:14] != 5)) begin
				$display("t: OUTPUT TIMEOUT COUNTER START ERROR", $time());
			end
			else if (o_framed_packet_phase_tb != {^i_data_tb ,^i_header_tb, i_header_tb}) begin
				$display("t: OUTPUT HEADER PHASE ERROR", $time());
			end
			i_ser_done_tb = 0;
			repeat (5) @(negedge i_clk_tb);
			i_ser_done_tb = 1;
			@(negedge i_clk_tb);
			if (!o_packet_valid_tb) begin
				$display("t: OUTPUT DATA VALID ERROR", $time());
			end
			else if (o_timeout_ctr_start_tb) begin
				$display("t: OUTPUT TIMEOUT COUNTER START ERROR", $time());
			end
			else if (o_framed_packet_phase_tb != i_data_tb) begin
				$display("t: OUTPUT DATA PHASE ERROR", $time());
			end

			repeat (10) @(negedge i_clk_tb);

		endtask : PKT_WiTH_DATA_RAND_SER_EN_test_case


		task PKT_WiTHOUT_DATA_test_case();
			i_data_tb = 64'b0;
			i_header_tb = $random();
			i_header_tb [17:14] = $urandom_range(1,10);
			i_header_valid_tb	= 1;
			i_data_valid_tb		= 1;
			i_ser_done_tb		= 1;
			@(negedge i_clk_tb);
			i_header_valid_tb	= 0;
			i_data_valid_tb		= 0;
			@(negedge i_clk_tb);
			if (!o_packet_valid_tb) begin
				$display("t: OUTPUT HEADER VALID ERROR", $time());
			end
			else if ((!o_timeout_ctr_start_tb  && i_header_tb [17:14] == 5) || (o_timeout_ctr_start_tb  && i_header_tb [17:14] != 5)) begin
				$display("t: OUTPUT TIMEOUT COUNTER START ERROR", $time());
			end
			else if (o_framed_packet_phase_tb != {^i_data_tb ,^i_header_tb, i_header_tb}) begin
				$display("t: OUTPUT HEADER PHASE ERROR", $time());
			end
			@(negedge i_clk_tb);
			if (o_packet_valid_tb) begin
				$display("t: OUTPUT DATA VALID ERROR", $time());
			end

			repeat (10) @(negedge i_clk_tb);

		endtask : PKT_WiTHOUT_DATA_test_case

		


endmodule : SB_PACKET_FRAMING_TB
