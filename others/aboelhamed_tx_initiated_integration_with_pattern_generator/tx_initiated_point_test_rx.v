module tx_initiated_point_test_rx (
	//inputs 
		input clk,    
		input rst_n,  
		//handling muxing priority
		input i_tx_valid,
		input i_busy_negedge_detected,
		//test configurations inputs 
		input  i_en,i_mainband_or_valtrain_test,i_lfsr_or_perlane,
		//communicting with sideband 
		input [3:0] i_decoded_sideband_message,
		//communictating with pattern compartors 
		input [15:0] i_comparison_results,
		input i_comparison_ack,
		//communcitaing with analog 
		input [3:0] i_reciever_ref_voltage,
	//outputs
		//communccating with sideband data  
		output reg [3:0] o_encoded_sideband_message ,
		output reg [15:0] o_sideband_data,
		output reg o_valid,
		//communcating with pattern compartors 
		output reg [1:0]o_mainband_pattern_compartor_cw,
		output reg o_comparison_valid_en,
		//analog componenets control word
		output reg [3:0]o_reciever_ref_volatge


);
/*------------------------------------------------------------------------------
--states  
------------------------------------------------------------------------------*/
parameter IDLE=0;
parameter WAIT_FOR_TEST_REQ=1;
parameter WAIT_FOR_LFSR_CLEAR_REQ=2; // and SENDS TEST RESPONSE
parameter CLEAR_LFSR=3; //and send LFSR_CLEAR_RESP
parameter COMPARE_RESULT=4; 
parameter WAIT_FOR_RESULT_REQ=5; //no messages is sent in here 
parameter WAIT_FOR_END_REQ=6;     //
parameter END_RESP=7;
/*------------------------------------------------------------------------------
--variables declaration  
------------------------------------------------------------------------------*/
reg [2:0] cs,ns;
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
			if(i_decoded_sideband_message==4'b0001) 
				ns=WAIT_FOR_LFSR_CLEAR_REQ;
			else 
				ns=WAIT_FOR_TEST_REQ;
		end
		WAIT_FOR_LFSR_CLEAR_REQ:begin
			if(i_decoded_sideband_message==4'b0011) 
				ns=CLEAR_LFSR;
			else 
				ns=WAIT_FOR_LFSR_CLEAR_REQ;
		end
		CLEAR_LFSR:begin
			if(i_busy_negedge_detected && ~i_tx_valid)
				ns=COMPARE_RESULT;
			else
				ns=CLEAR_LFSR;

		end
		COMPARE_RESULT:begin
			if(i_comparison_ack)
				ns=WAIT_FOR_RESULT_REQ;
			else 
				ns=COMPARE_RESULT;
		end
		WAIT_FOR_RESULT_REQ:begin
			if(i_decoded_sideband_message==4'b0101)
				ns=WAIT_FOR_END_REQ;
			else 
				ns=WAIT_FOR_RESULT_REQ;
		end
		WAIT_FOR_END_REQ:begin
			if(i_decoded_sideband_message==4'b0111)
				ns=END_RESP;
			else 
				ns=WAIT_FOR_END_REQ;
		end
		END_RESP:begin
			if(i_en==0)
				ns=IDLE;
			else 
				ns=END_RESP;
		end
 	endcase
 end
 /*------------------------------------------------------------------------------
 --output block   
 ------------------------------------------------------------------------------*/
 always @(posedge clk or negedge rst_n) begin : proc_
 	if (~rst_n) begin
 		o_valid<=0;
		o_encoded_sideband_message<=0;
		o_comparison_valid_en<=0;
		o_reciever_ref_volatge<=0;
		o_sideband_data<=0;
 	end else begin
		case (cs)
			IDLE:begin
				o_valid<=0;
				o_encoded_sideband_message<=0;
				o_comparison_valid_en<=0;
				o_reciever_ref_volatge<=0;
				o_sideband_data<=0;
			end
			WAIT_FOR_TEST_REQ:begin 
				if(ns==WAIT_FOR_LFSR_CLEAR_REQ) begin
					o_encoded_sideband_message<=4'b0010;//sending test response
				end
			end
			WAIT_FOR_LFSR_CLEAR_REQ:begin
				if(ns==CLEAR_LFSR)begin
					o_encoded_sideband_message<=4'b0100; //sending clear lfsr response 
					o_mainband_pattern_compartor_cw<=2'b01;
				end
			end
			CLEAR_LFSR:begin
				if(ns==COMPARE_RESULT) begin
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
			COMPARE_RESULT:begin

			end
			WAIT_FOR_RESULT_REQ:begin
				o_comparison_valid_en<=0;
				o_mainband_pattern_compartor_cw<=2'b00;
				if(ns==WAIT_FOR_END_REQ)begin
					o_encoded_sideband_message<=4'b0110;//sending result response
					o_sideband_data<=i_comparison_results;
				end
			end
			WAIT_FOR_END_REQ:begin
				if(ns==END_RESP)begin
					o_encoded_sideband_message<=4'b1000;//sending end test response
				end
			end
			END_RESP:begin

			end
		endcase
	end 
 end
 /*------------------------------------------------------------------------------
 --handling valid signal 
 ------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_valid
	if( ~rst_n ) begin
		o_valid <= 0;
	end else
		if(cs[0] != ns[0] && ns !=COMPARE_RESULT &&   ns != IDLE && ns != WAIT_FOR_TEST_REQ && ns != WAIT_FOR_RESULT_REQ)
			o_valid <= 1;
		else if (i_busy_negedge_detected && ~i_tx_valid)
			o_valid<=0;
		else if(cs==CLEAR_LFSR)
			o_valid<=1;
end
endmodule : tx_initiated_point_test_rx
