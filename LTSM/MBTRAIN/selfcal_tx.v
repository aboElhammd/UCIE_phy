module selfcal_tx (
	//inputs
		input clk,    // Clock
		input rst_n,  // Asynchronous reset active low
		input i_en, 
		input i_sideband_valid,
		//communcating with sideband 
		input [3:0]  i_decoded_sideband_message ,
		//handling_mux_priorities 
		input        i_busy_negedge_detected,i_valid_rx, 
	//output 
		//communcting with sideband
		output reg [3:0] o_sideband_message,
		output reg       o_valid_tx,
		output reg o_test_ack
);
/*------------------------------------------------------------------------------
--fsm states   
------------------------------------------------------------------------------*/
parameter IDLE =0;
parameter CAL_ALGO=1;
parameter END_REQ=2;
parameter TEST_FINISHED=3;
/*------------------------------------------------------------------------------
--variables declaration   
------------------------------------------------------------------------------*/
reg [2:0] cs,ns ;
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
				ns=CAL_ALGO;
			end else begin
				ns=IDLE;
			end
		end
		CAL_ALGO:begin
			ns=END_REQ;
		end
		END_REQ:begin
			if (i_decoded_sideband_message==4'b0010 && i_sideband_valid ) begin
				ns=TEST_FINISHED;
			end else begin
				ns=END_REQ;
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
		o_sideband_message<=0;
		o_test_ack<=0;
	end else begin
		case (cs)
			IDLE:begin
				o_sideband_message<=0;
				o_test_ack<=0;
			end
			CAL_ALGO: begin
				if(ns==END_REQ) begin
					o_sideband_message<=4'b0001;
				end
			end
			END_REQ:begin
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
--valid handling   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_valid_tx
	if( ~rst_n ) begin
		o_valid_tx <= 0;
	end  else if(cs[0] != ns[0] && ns ==END_REQ ) begin
			o_valid_tx <= 1;
	end else if(i_busy_negedge_detected && ~i_valid_rx) begin
			o_valid_tx<=0;
	end
end
endmodule 

