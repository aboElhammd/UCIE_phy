module tx_initiated_point_test_rx (
	//inputs 
		input 		clk,    
		input 		rst_n,  
		//handling muxing priority
		input 		i_valid_tx,
		input 		i_busy_negedge_detected,
		//test configurations inputs 
		input  		i_en,i_mainband_or_valtrain_test,i_lfsr_or_perlane,
		//communicting with sideband 
		input [3:0] i_sideband_message,
		input 		i_sideband_message_valid,
		//communictating with pattern compartors 
		input [15:0]i_comparison_results,
		// input i_comparison_ack,
		//communcitaing with analog 
		input [3:0] i_reciever_ref_voltage,
	//outputs
		//communccating with sideband data  
		output reg [3:0]  o_sideband_message ,
		output reg [15:0] o_sideband_data,
		output reg 		  o_valid_rx,
		//communcating with pattern compartors 
		output reg [1:0]  o_mainband_pattern_compartor_cw,
		output reg 		  o_comparison_valid_en,
		//analog componenets control word
		output reg [3:0]  o_reciever_ref_volatge,
		//finishing ack
		output reg 		  o_test_ack_rx

);
/*------------------------------------------------------------------------------
--states  
------------------------------------------------------------------------------*/
parameter IDLE=0;
parameter WAIT_FOR_TEST_REQ=1;
parameter WAIT_FOR_LFSR_CLEAR_REQ=2; // and SENDS TEST RESPONSE
parameter CLEAR_LFSR=3; //and send LFSR_CLEAR_RESP
// parameter COMPARE_RESULT=4; 
parameter WAIT_FOR_RESULT_REQ=4; //no messages is sent in here 
parameter WAIT_FOR_END_REQ=5;     //
parameter END_RESP=6;
parameter TEST_FINISH=7;
/*------------------------------------------------------------------------------
--variables declaration  
------------------------------------------------------------------------------*/
reg [2:0] cs,ns;
reg valid_reg , valid_should_go_high;
wire valid_negedge_detected,valid_cond;
/*------------------------------------------------------------------------------
-- assign statements 
------------------------------------------------------------------------------*/
assign valid_negedge_detected = ~o_valid_rx && valid_reg;
assign valid_cond=  cs[0] != ns[0] &&   ns != IDLE && ns != WAIT_FOR_TEST_REQ && ns != WAIT_FOR_RESULT_REQ && ns!= TEST_FINISH;
/*------------------------------------------------------------------------------
--next state update   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_cs
 	if(~rst_n) begin
 		cs <= IDLE;
 	end else begin
 		cs <=ns;
 	end
 end 
 /*------------------------------------------------------------------------------
 --next state logic   
 ------------------------------------------------------------------------------*/
 always @(*)begin
 	case (cs)
		IDLE:begin
			if(i_en)
				ns=WAIT_FOR_TEST_REQ;
			else 
				ns=IDLE;
		end
		WAIT_FOR_TEST_REQ:begin
			if(~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b0001 && i_sideband_message_valid) 
				ns=WAIT_FOR_LFSR_CLEAR_REQ;
			else 
				ns=WAIT_FOR_TEST_REQ;
		end
		WAIT_FOR_LFSR_CLEAR_REQ:begin
			if(~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b0011) 
				ns=CLEAR_LFSR;
			else 
				ns=WAIT_FOR_LFSR_CLEAR_REQ;
		end
		CLEAR_LFSR:begin
			if(~i_en) begin
				ns=IDLE;
			end else if(valid_negedge_detected)
				ns=WAIT_FOR_RESULT_REQ;
			else
				ns=CLEAR_LFSR;
		end
		// COMPARE_RESULT:begin
		// 	if(i_comparison_ack)
		// 		ns=WAIT_FOR_RESULT_REQ;
		// 	else 
		// 		ns=COMPARE_RESULT;
		// end
		WAIT_FOR_RESULT_REQ:begin
			if(~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b0101)
				ns=WAIT_FOR_END_REQ;
			else 
				ns=WAIT_FOR_RESULT_REQ;
		end
		WAIT_FOR_END_REQ:begin
			if(~i_en) begin
				ns=IDLE;
			end else if(i_sideband_message==4'b0111)
				ns=END_RESP;
			else 
				ns=WAIT_FOR_END_REQ;
		end
		END_RESP:begin
			if(~i_en) begin
				ns=IDLE;
			end else if(valid_negedge_detected)
				ns=TEST_FINISH;
			else 
				ns=END_RESP;
		end 
		TEST_FINISH:begin
			if(i_en==0)
				ns=IDLE;
			else 
				ns=TEST_FINISH;
		end
 	endcase
 end
 /*------------------------------------------------------------------------------
 --output block   
 ------------------------------------------------------------------------------*/
 always @(posedge clk or negedge rst_n) begin : proc_
 	if (~rst_n) begin
		o_sideband_message<=0;
		o_comparison_valid_en<=0;
		o_reciever_ref_volatge<=0;
		o_sideband_data<=0;
		o_test_ack_rx<=0;
 	end else begin
		case (cs)
			IDLE:begin
				o_sideband_message<=0;
				o_comparison_valid_en<=0;
				o_reciever_ref_volatge<=0;
				o_sideband_data<=0;
				o_test_ack_rx<=0;

			end
			WAIT_FOR_TEST_REQ:begin 
				if(ns==WAIT_FOR_LFSR_CLEAR_REQ) begin
					o_sideband_message<=4'b0010;//sending test response
				end
			end
			WAIT_FOR_LFSR_CLEAR_REQ:begin
				if(ns==CLEAR_LFSR)begin
					o_sideband_message<=4'b0100; //sending clear lfsr response 
					o_mainband_pattern_compartor_cw<=2'b01;
				end
			end
			CLEAR_LFSR:begin
				if(ns==WAIT_FOR_RESULT_REQ) begin
					o_reciever_ref_volatge=4'b1000;
					case ({i_mainband_or_valtrain_test, i_lfsr_or_perlane})
							2'b00:begin
								o_mainband_pattern_compartor_cw<=2'b10; //lfsr pattern generation
								o_comparison_valid_en<=0;
							end
							2'b01:begin
								o_mainband_pattern_compartor_cw<=2'b11;//per lane id 
								o_comparison_valid_en<=0;
							end
							default : begin
								o_comparison_valid_en<=1;
								o_mainband_pattern_compartor_cw<=2'b00;
							end
					endcase
				end
			end

			WAIT_FOR_RESULT_REQ:begin
					// o_comparison_valid_en<=0;
					// o_mainband_pattern_compartor_cw<=2'b00;
				if(ns==WAIT_FOR_END_REQ)begin
					o_comparison_valid_en<=0;
					o_mainband_pattern_compartor_cw<=2'b00;
					o_sideband_message<=4'b0110;//sending result response
					o_sideband_data<=i_comparison_results;
				end
			end
			WAIT_FOR_END_REQ:begin
				if(ns==END_RESP)begin
					o_sideband_message<=4'b1000;//sending end test response
				end
			end
			END_RESP:begin
				if(ns==TEST_FINISH) begin
					o_test_ack_rx<=1;
				end
			end
		endcase
	end 
 end
 /*------------------------------------------------------------------------------
 --handling valid signal 
 ------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_valid_rx_rx_rx
	if(~rst_n) begin
		o_valid_rx <= 0;
	end else if (i_busy_negedge_detected)begin
		o_valid_rx<=0;
	end else if ( ( valid_cond || valid_should_go_high )&& !i_valid_tx) begin
		o_valid_rx <= 1;
	end
end
always @(posedge clk or negedge rst_n) begin : proc_valid_should_go_high
	if(~rst_n) begin
		valid_should_go_high <= 0;
	end else if(valid_cond && i_valid_tx)begin
		valid_should_go_high <= 1;
	end else if(i_busy_negedge_detected && !i_valid_tx) begin
		valid_should_go_high<=0;
	end
end
/*------------------------------------------------------------------------------
--valid negedge detection   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_valid_reg
	if(~rst_n) begin
		valid_reg <= 0;
	end else begin
		valid_reg <= o_valid_rx ;
	end
end
endmodule : tx_initiated_point_test_rx
