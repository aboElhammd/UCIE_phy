module repair_rx (
	//inputs 
		//main control signals 
		    input clk,
		    input rst_n,
		    input i_en,
	    ///communicating with side band 
		    input [3:0] i_sideband_message,
		    input [2:0]i_sideband_data_lanes_encoding,
		    input i_busy_negedge_detected,
	    //communicating with tx
		    input i_valid_tx,
    //outputs 
	    //communicating with sideband 
		    output reg [3:0] o_sideband_message,
		    output reg o_valid_rx,
	    //communicating with mbtrain 
		    output reg o_test_ack,
	    //results from remote link partner given back to mbtrain  
		    output reg o_remote_partner_first_8_lanes_result , o_remote_partner_second_8_lanes_result 

);
/*------------------------------------------------------------------------------
-- sideband messages    
------------------------------------------------------------------------------*/
parameter INIT_REQUEST = 4'b0001;
parameter INIT_RESPONSE = 4'b0010;
parameter APPLY_DEGRADE_REQUEST = 4'b0111;
parameter APPLY_DEGRADE_RESPONSE = 4'b1000;
parameter END_REQUEST = 4'b0101;
parameter END_RESPONSE = 4'b0110;
/*------------------------------------------------------------------------------
-- FSM States   
------------------------------------------------------------------------------*/
parameter IDLE = 0;
parameter WAIT_FOR_INIT_REQUEST = 1;
parameter WAIT_FOR_APPLY_DEGRADE_REQUEST = 2;
parameter WAIT_FOR_END_REQUEST = 3;
parameter SEND_END_RESPONSE = 4;
parameter TEST_FINISH = 5;
/*------------------------------------------------------------------------------
-- Variables Declaration  
------------------------------------------------------------------------------*/
reg [2:0] cs, ns;
reg valid_reg , valid_should_go_high;
wire valid_negedge_detected , valid_cond;
assign valid_cond=cs[0]!=ns[0] && (ns==WAIT_FOR_APPLY_DEGRADE_REQUEST || ns==WAIT_FOR_END_REQUEST || ns==SEND_END_RESPONSE) ;
assign valid_negedge_detected = ~o_valid_rx &&valid_reg; 
/*------------------------------------------------------------------------------
-- Current State Update  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_cs
    if (~rst_n) cs <= IDLE;
    else  cs <= ns;
end
/*------------------------------------------------------------------------------
-- Next State Logic   
------------------------------------------------------------------------------*/
always @(*) begin
    case (cs)
        IDLE:begin
        	if(i_en) begin
        		ns=WAIT_FOR_INIT_REQUEST;
        	end else begin
        		ns=IDLE;
        	end
		end
		WAIT_FOR_INIT_REQUEST:begin
			if(i_en==0) begin
				ns=IDLE;
			end else if(i_sideband_message == INIT_REQUEST) begin
				ns= WAIT_FOR_APPLY_DEGRADE_REQUEST;
			end else begin
				ns= WAIT_FOR_INIT_REQUEST;
			end
		end
		WAIT_FOR_APPLY_DEGRADE_REQUEST:begin
			if(i_en==0) begin
				ns=IDLE;
			end else if(i_sideband_message == APPLY_DEGRADE_REQUEST) begin
				ns=WAIT_FOR_END_REQUEST;
			end else begin
				ns=WAIT_FOR_APPLY_DEGRADE_REQUEST;
			end
		end
		WAIT_FOR_END_REQUEST:begin
			if(i_en==0) begin
				ns=IDLE;
			end else if(i_sideband_message ==END_REQUEST ) begin
				ns=SEND_END_RESPONSE;
			end else begin
				ns=WAIT_FOR_END_REQUEST;
			end
		end
		SEND_END_RESPONSE:begin
			if(i_en==0) begin
				ns=IDLE;
			end else if(valid_negedge_detected) begin
				ns=TEST_FINISH;
			end else begin
				ns=SEND_END_RESPONSE;
			end
		end
		TEST_FINISH:begin
			if(i_en==0) begin
				ns=IDLE;
			end else begin
				ns=TEST_FINISH;
			end
		end
        default: ns = cs;
    endcase
end
/*------------------------------------------------------------------------------
-- Output Logic  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_output
    if (~rst_n) begin
        o_sideband_message <= 1'b0;
        o_test_ack <= 1'b0;
        o_remote_partner_first_8_lanes_result<=1'b0;
		o_remote_partner_second_8_lanes_result<=1'b0;
    end
    else begin
        case (cs)
            IDLE:begin
            	o_sideband_message<=4'b0000;
            	o_test_ack<=1'b0;
            	if(ns==WAIT_FOR_INIT_REQUEST) begin 
            		o_remote_partner_first_8_lanes_result<=1'b0;
					o_remote_partner_second_8_lanes_result<=1'b0;
				end
			end
			WAIT_FOR_INIT_REQUEST:begin
				if(ns==WAIT_FOR_APPLY_DEGRADE_REQUEST) begin
					o_sideband_message<= INIT_RESPONSE;
				end
			end
			WAIT_FOR_APPLY_DEGRADE_REQUEST:begin
				if(ns==WAIT_FOR_END_REQUEST) begin
					o_sideband_message<=APPLY_DEGRADE_RESPONSE;
					if(i_sideband_data_lanes_encoding==3'b011) begin
						o_remote_partner_first_8_lanes_result<=1'b1;
						o_remote_partner_second_8_lanes_result<=1'b1;
					end else if(i_sideband_data_lanes_encoding==3'b001)begin
						o_remote_partner_first_8_lanes_result<=1'b1;
						o_remote_partner_second_8_lanes_result<=1'b0;
					end else if(i_sideband_data_lanes_encoding==3'b010) begin
						o_remote_partner_first_8_lanes_result<=1'b0;
						o_remote_partner_second_8_lanes_result<=1'b1;
					end
				end
			end
			WAIT_FOR_END_REQUEST:begin
				if(ns==SEND_END_RESPONSE) begin
					o_sideband_message<=END_RESPONSE;
				end
			end
			SEND_END_RESPONSE:begin
				if(ns==TEST_FINISH) begin
					o_test_ack<=1'b1;
					o_sideband_message<=4'b0000;
				end
			end
			TEST_FINISH:begin
				if(ns==IDLE) begin
					o_test_ack<=1'b0;
				end
			end
        endcase
    end
end
/*------------------------------------------------------------------------------
--valid registering   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_valid_reg
	if(~rst_n) begin
		valid_reg <= 0;
	end else begin
		valid_reg <= o_valid_rx;
	end
end
/*------------------------------------------------------------------------------
-- valid handling  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_valid_rx
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
endmodule 