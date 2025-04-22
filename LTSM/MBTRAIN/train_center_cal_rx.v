module train_center_cal_rx  (
	//inputs 
		input clk,    // Clock
		input rst_n,  // Asynchronous reset active low
		input i_en,
		//communcating with sideband 
		input [3:0]  i_decoded_sideband_message ,
		//handling_mux_priorities 
		input        i_busy_negedge_detected,i_valid_tx,
		//test configurations 
		input        i_mainband_or_valtrain_test, //0 means mainbadnd 1 means valpattern
		input        i_lfsr_or_perlane  ,   // 0 means lfsr test 1 means perlane 
		input 		 i_test_ack,
		//communicating with point test 
		input [15:0] i_tx_lanes_result , //based on the decision will be taken in here or not 
	//output 
		//communcting with sideband
		output reg [3:0] o_sideband_message,
		output reg       o_valid_rx,
		//enabling point test block 
		output reg       o_pt_en,o_eye_width_sweep_en,
		output reg 		 o_test_ack
);
/*------------------------------------------------------------------------------
--fsm states   
------------------------------------------------------------------------------*/
parameter IDLE =0;
parameter WAIT_FOR_START_REQ=1;
parameter CAL_ALGO=2;
parameter WAIT_FOR_END_REQ=3;
parameter SEND_END_RESPONSE=4;
parameter TEST_FINISHED=5;
/*------------------------------------------------------------------------------
--variables declaration   
------------------------------------------------------------------------------*/
reg [2:0] cs,ns ;
wire valid_cond,valid_negedge_detected;
reg valid_should_go_high, valid_reg;
/*------------------------------------------------------------------------------
--assign statemnets   
------------------------------------------------------------------------------*/
assign valid_cond = cs[0] != ns[0] && (ns==CAL_ALGO || ns==SEND_END_RESPONSE);
assign valid_negedge_detected= ~o_valid_rx && valid_reg;
/*------------------------------------------------------------------------------
--current state update   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		cs<=IDLE;
	end else begin
		cs<=ns;
	end
end
/*------------------------------------------------------------------------------
--next state logic  
------------------------------------------------------------------------------*/
always @(*) begin
	case (cs)
		IDLE:begin
			if (i_en) begin
				ns=WAIT_FOR_START_REQ;
			end else begin
				ns=IDLE;
			end
		end
		WAIT_FOR_START_REQ:begin
			if (i_decoded_sideband_message==4'b0001) begin
				ns=CAL_ALGO;
			end else begin
				ns=WAIT_FOR_START_REQ;
			end
		end
		CAL_ALGO:begin
			if(i_test_ack) begin
				ns=WAIT_FOR_END_REQ;
			end else begin
				ns=CAL_ALGO;
			end
		end
		WAIT_FOR_END_REQ:begin
			if (i_decoded_sideband_message==4'b0011) begin
				ns=SEND_END_RESPONSE;
			end else begin
				ns=WAIT_FOR_END_REQ;
			end
		end
		SEND_END_RESPONSE:begin
			if(valid_negedge_detected) begin
				ns=TEST_FINISHED;
			end else begin
				ns=SEND_END_RESPONSE;
			end
		end
		TEST_FINISHED:begin
			if (~i_en) begin
				ns=IDLE;
			end else begin
				ns=TEST_FINISHED;
			end
		end
		default: 
			ns=IDLE;
	endcase
end
/*------------------------------------------------------------------------------
--output logic  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_
	if(~rst_n) begin
		//constant 
		o_sideband_message<=0;
		//may be changed 
		o_pt_en <= 0;
		o_eye_width_sweep_en<=0;
		o_test_ack<=0;
	end else begin
		case (cs)
			IDLE:begin
				o_sideband_message<=0;
				//test parameters 
				o_pt_en <= 0;
				o_eye_width_sweep_en<=0;
				o_test_ack<=0;
			end
			WAIT_FOR_START_REQ:begin
				if(ns==CAL_ALGO) begin
					o_sideband_message<=4'b0010;
					o_pt_en <= 1;
				end 
			end
			CAL_ALGO: begin
				if(ns==WAIT_FOR_END_REQ) begin
					o_pt_en <= 0;					
				end
			end
			WAIT_FOR_END_REQ:begin
				if(ns==SEND_END_RESPONSE) begin
					o_sideband_message<=4'b0100;
				end
			end
			SEND_END_RESPONSE:begin
				if(ns==TEST_FINISHED) begin
					o_sideband_message<=4'b0000;
					o_test_ack<=1;
				end
			end
			TEST_FINISHED:begin
			end
			default : ;
		endcase
	end
end
 /*------------------------------------------------------------------------------
 --handling valid signal 
 ------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_valid_rx_rx
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
	end else if(valid_cond)begin
		valid_should_go_high <= 1;
	end else if(i_busy_negedge_detected && !i_valid_tx) begin
		valid_should_go_high<=0;
	end
end
always @(posedge clk or negedge rst_n) begin : proc_valid_reg
	if(~rst_n) begin
		valid_reg <= 0;
	end else begin
		valid_reg <=o_valid_rx ;
	end
end
endmodule 

