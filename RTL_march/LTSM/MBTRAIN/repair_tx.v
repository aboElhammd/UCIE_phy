module repair_tx (
	//inputs 
		//main signals 
		    input clk,
		    input rst_n,
		    input i_en,
	    //communicating with sideband 
		    input [3:0] i_sideband_message,
		    input i_busy_negedge_detected,
			input i_rx_msg_valid,
	    //communicating with MBTRAIN
		    input i_first_8_lanes_are_functional , i_second_8_lanes_are_functional,
	    //communicating with rx 
		    input i_valid_rx,
    //outputs
	    //communicating with sideband  
		    output reg [3:0] o_sideband_message,
		    output reg 		 o_valid_tx,
		    output reg[2:0] o_sideband_data_lanes_encoding,
	    // communciating with mbtrain 
		    output reg o_test_ack
);
/*------------------------------------------------------------------------------
-- sideband messages    
------------------------------------------------------------------------------*/
parameter INIT_REQUEST = 4'b0001;
parameter INIT_RESPONSE = 4'b0010;
parameter APPLY_DEGRADE_REQUEST = 4'b0011;
parameter APPLY_DEGRADE_RESPONSE = 4'b0100;
parameter END_REQUEST = 4'b0101;
parameter END_RESPONSE = 4'b0110;
/*------------------------------------------------------------------------------
-- FSM States   
------------------------------------------------------------------------------*/
parameter IDLE = 0;
parameter REPAIR_INIT_REQUEST = 1;
parameter REPAIR_APPLY_DEGRADE_REQUEST = 2;
parameter REPAIR_END_REQUEST = 3;
parameter TEST_FINISH=4;
/*------------------------------------------------------------------------------
-- Variables Declaration  
------------------------------------------------------------------------------*/
reg [3:0] cs, ns;
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
        		ns=REPAIR_INIT_REQUEST;
        	end else begin
        		ns=IDLE;
        	end
		end
		REPAIR_INIT_REQUEST:begin
			if(i_en==0) begin
				ns=IDLE;
			end else if(i_sideband_message == INIT_RESPONSE && i_rx_msg_valid) begin
				ns= REPAIR_APPLY_DEGRADE_REQUEST ;
			end else begin
				ns=REPAIR_INIT_REQUEST;
			end
		end
		REPAIR_APPLY_DEGRADE_REQUEST:begin
			if(i_en==0) begin
				ns=IDLE;
			end else if(i_sideband_message == APPLY_DEGRADE_RESPONSE) begin
				ns= REPAIR_END_REQUEST ;
			end else begin
				ns=REPAIR_APPLY_DEGRADE_REQUEST;
			end		
		end
		REPAIR_END_REQUEST:begin
			if(i_en==0) begin
				ns=IDLE;
			end else if(i_sideband_message== END_RESPONSE) begin
				ns=TEST_FINISH;
			end else begin
				ns=REPAIR_END_REQUEST;
			end
		end
		TEST_FINISH:begin
			if(i_en==0)begin
				ns=IDLE;
			end else begin
				ns=TEST_FINISH;
			end
		end
        default: ns = IDLE;
    endcase
end
/*------------------------------------------------------------------------------
-- Output Logic  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_output
    if (~rst_n) begin
        o_sideband_message <= 0;
        o_test_ack <= 0;
        o_sideband_data_lanes_encoding<=0;
    end
    else begin
        case (cs)
            IDLE:begin
            	o_sideband_message<=0;
            	o_test_ack<=0;
            	o_sideband_data_lanes_encoding<=0;
            	if(ns==REPAIR_INIT_REQUEST) begin
            		o_sideband_message<=INIT_REQUEST;
            	end
			end
			REPAIR_INIT_REQUEST:begin
				if(ns==REPAIR_APPLY_DEGRADE_REQUEST) begin
					o_sideband_message<=APPLY_DEGRADE_REQUEST;
					if(i_first_8_lanes_are_functional && i_second_8_lanes_are_functional)
						o_sideband_data_lanes_encoding<=3'b011;
					else if(i_first_8_lanes_are_functional) 
						o_sideband_data_lanes_encoding<=3'b001;
					else if(i_second_8_lanes_are_functional)
						o_sideband_data_lanes_encoding<=3'b010;
				end
			end
			REPAIR_APPLY_DEGRADE_REQUEST:begin
				if(ns==REPAIR_END_REQUEST) begin
					o_sideband_message<=END_REQUEST;
				end
			end
			REPAIR_END_REQUEST:begin
				if(ns==TEST_FINISH) begin
					o_sideband_message<=4'b0000;
					o_test_ack<=1;
				end
			end
			TEST_FINISH:begin
				if(ns==IDLE) begin
					o_test_ack<=0;
				end
			end
            default: ;
        endcase
    end
end
/*------------------------------------------------------------------------------
--valid handling   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_valid_tx
	if(~rst_n) begin
		o_valid_tx <= 0;
	end else if(cs[0]!=ns[0] && ns!=TEST_FINISH && ns!=IDLE)begin
		o_valid_tx <= 1;
	end else if(i_busy_negedge_detected && ~i_valid_rx) begin
		o_valid_tx <=0;
	end
end
// always @(posedge clk or negedge rst_n) begin : proc_o_data_valid_tx
// 	if(~rst_n) begin
// 		o_data_valid_tx <= 0;
// 	end else if(cs==REPAIR_INIT_REQUEST && ns==REPAIR_APPLY_DEGRADE_REQUEST )begin
// 		o_data_valid_tx <= 1;
// 	end else if(i_busy_negedge_detected && ~i_valid_rx) begin
// 		o_data_valid_tx <=0 ;
// 	end
// end
endmodule 