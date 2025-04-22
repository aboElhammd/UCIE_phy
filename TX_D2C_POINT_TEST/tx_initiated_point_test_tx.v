module tx_initiated_point_test_tx (
	//inputs 
		input 		 clk,rst_n,
		//enable and test parameters     
		input 		 i_en, 
		input 		 i_mainband_or_valtrain_test, //0 means mainbadnd 1 means valpattern
		input 		 i_lfsr_or_perlane  ,   // 0 means lfsr test 1 means perlane 
		//communcating with pattern generators 
		input 		 i_pattern_finished , 
		//talking with sideband 
		input [3:0]  i_sideband_message,
		input [15:0] i_sideband_data,
		input 		 i_sideband_message_valid,
		//handling muxing priorties 
		input 		 i_busy_negedge_detected, i_valid_rx,
	//outputs
		//sideband outputs 
		output reg [3:0]  o_sideband_message,
		output reg 		  o_valid_tx,
		output     [15:0] o_sideband_data,
		output reg 		  o_data_valid,		
		//controling pattern generator 
		output reg 		o_val_pattern_en,
		output reg [1:0]o_mainband_pattern_generator_cw,
		//communicating with ltsm 
		output reg 		o_test_ack_tx

);

/*------------------------------------------------------------------------------
--fsm states   
------------------------------------------------------------------------------*/
parameter START_REQ=0;
parameter LFSR_CLEAR_REQ=1;
parameter SEND_PATTERN=2;
parameter RESULT_REQ=3;
parameter END_REQ=4;
parameter IDLE=5;
parameter TEST_FINISHED=6;
/*------------------------------------------------------------------------------
--variables  
------------------------------------------------------------------------------*/
reg [2:0]cs,ns;
reg message_complete;
wire valid_cond;
reg  sb_data_pattern , sb_burst_count , sb_comparison_mode , data_valid_went_high;
assign valid_cond=cs[0] != ns[0] && ns != TEST_FINISHED &&  ns!=SEND_PATTERN && ns != IDLE;
assign o_sideband_data= { 11'h000 , sb_comparison_mode , sb_burst_count , 3'b000 , sb_data_pattern };
/*------------------------------------------------------------------------------
-- state transistion block   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_
	if(~rst_n) begin
		cs <= IDLE;
	end else begin
		cs <= ns;
	end
end
/*------------------------------------------------------------------------------
--next state encoding block  
------------------------------------------------------------------------------*/
always @(*) begin 
	case (cs)
		IDLE:begin
			if(i_en) 
				ns=START_REQ;
			else 
				ns=IDLE;
		end
		START_REQ:begin
			if (~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b0010 && i_sideband_message_valid)
				ns=LFSR_CLEAR_REQ;
			else 
				ns=START_REQ;
		end
		LFSR_CLEAR_REQ:begin
			if (~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b0100 && i_sideband_message_valid)
				ns=SEND_PATTERN;
			else 
				ns=LFSR_CLEAR_REQ;
		end 
		SEND_PATTERN:begin
			if (~i_en) begin
				ns=IDLE;
			end else if(i_pattern_finished==1)
				ns=RESULT_REQ;
			else 
				ns=SEND_PATTERN;
		end
		RESULT_REQ:begin
			if (~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b0110 && i_sideband_message_valid)
				ns=END_REQ;
			else 
				ns=RESULT_REQ;
		end
		END_REQ:begin
			if (~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b1000 && i_sideband_message_valid)
				ns=TEST_FINISHED;
			else 
				ns=END_REQ;
		end
		TEST_FINISHED:begin
			if (i_en==0) begin
				ns=IDLE;
			end
			else begin
				ns=TEST_FINISHED;
			end
		end
	endcase
end
/*------------------------------------------------------------------------------
-- output block   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		// o_valid_tx<=0;
		o_sideband_message<=4'b0000;
		o_test_ack_tx<=0;
		sb_data_pattern<=0;
		sb_burst_count<=0;
		sb_comparison_mode<=0;
		o_mainband_pattern_generator_cw<=2'b00;
		o_val_pattern_en<=0;
	end
		case (cs)
			IDLE:begin
				// o_valid_tx<=0;
				o_sideband_message<=4'b0000;
				o_test_ack_tx<=0;
				sb_data_pattern<=0;
				sb_burst_count<=0;
				sb_comparison_mode<=0;
				o_mainband_pattern_generator_cw<=2'b00;
				o_val_pattern_en<=0;
				if(ns==START_REQ) begin
					o_sideband_message<=4'b0001;
					// o_valid_tx<=message_complete?0:1;
					//setting sideband data 
					sb_comparison_mode<=0;
					if (!i_mainband_or_valtrain_test) begin 
						sb_data_pattern<=0;
						sb_burst_count<=0;
					end
					else begin
						sb_data_pattern<=1;
						sb_burst_count<=1;
					end
				end
			end
			START_REQ:begin
				if(ns==LFSR_CLEAR_REQ) begin
					o_sideband_message<=4'b0011;
					// o_valid_tx<=message_complete?1:0;
					if(~i_mainband_or_valtrain_test)
						o_mainband_pattern_generator_cw<=2'b01;
				end
			end
			LFSR_CLEAR_REQ:begin
				if(ns==SEND_PATTERN) begin
					//enable patten generators
					case ({i_mainband_or_valtrain_test, i_lfsr_or_perlane})
						2'b00:begin
							o_mainband_pattern_generator_cw<=2'b10; //lfsr pattern generation
							o_val_pattern_en<=0;
						end
						2'b01:begin
							o_mainband_pattern_generator_cw<=2'b11;//per lane id 
							o_val_pattern_en<=0;
						end
						default : begin
							o_val_pattern_en<=1;
							o_mainband_pattern_generator_cw<=2'b00;
						end
					endcase
				end
			end	
			SEND_PATTERN:begin
				if(ns==RESULT_REQ)begin
					//truning off pattern generators 
					o_val_pattern_en<=0;
					o_mainband_pattern_generator_cw<=2'b00;
					//sending the new message 
					o_sideband_message<=4'b0101;
					// o_valid_tx<=message_complete?0:1;
				end
			end
			RESULT_REQ:begin
				if(ns==END_REQ)begin
					o_sideband_message<=4'b0111;
					// o_valid_tx<=message_complete?1:0;
				end
			end	
			END_REQ:begin
				if(ns==TEST_FINISHED) begin
					o_sideband_message<=4'b0000;
					// o_valid_tx<=0;
					o_test_ack_tx<=1;
				end
			end
			TEST_FINISHED:begin
				
			end
		endcase
	end

/*------------------------------------------------------------------------------
--valid output handling   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_valid_tx
	if( ~rst_n ) begin
		o_valid_tx <= 0;
	end else
		if(i_busy_negedge_detected && ~i_valid_rx)
			o_valid_tx<=0;
	 	else if(valid_cond) begin
			o_valid_tx <= 1;
	end
end
/*------------------------------------------------------------------------------
--data valid handling   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_data_valid
	if(~rst_n) begin
		o_data_valid <= 0;
	end else begin
		if(i_busy_negedge_detected && ~i_valid_rx)begin
			o_data_valid<=0;
	 	end else if(ns==START_REQ && ~data_valid_went_high) begin
			o_data_valid<=1;
		end
	end
end
always @(posedge clk or negedge rst_n) begin : proc_data_valid_went_high
	if(~rst_n) begin
		data_valid_went_high <= 0;
	end else if (cs==IDLE) begin
		data_valid_went_high <= 0 ;
	end else if(ns==START_REQ) begin
		data_valid_went_high <= 1;
	end
end
endmodule 
