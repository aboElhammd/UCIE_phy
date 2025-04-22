module SB_DATA_ENCODER (
	input 				i_clk,
	input 				i_rst_n, 
	input 				i_data_valid,
	input 				i_msg_valid,
	input 		[3:0] 	i_state,
	input 		[3:0] 	i_sub_state,
	input 		[3:0] 	i_msg_no,
	input 		[15:0] 	i_data_bus,
	// TEST Signals 
	input 				i_tx_point_sweep_test_en,
	input 		[1:0]  	i_tx_point_sweep_test,
	// RDI Signals 
	input 				i_rdi_msg,
	output reg 	[63:0] 	o_data_encoded,
	output reg 			o_d_valid      // valid to tell packet framing that there is valid data on the bus afte encoded it

);


/*------------------------------------------------------------------------------
--  LOCAL PARAMETERS
------------------------------------------------------------------------------*/
// States parameters
localparam RESET 	            	= 0;
localparam FINISH_RESET         	= 1;
localparam SBINIT 		 			= 2;
localparam MBINIT					= 3;
localparam MBTRAIN              	= 4;
localparam LINKINIT             	= 5;
localparam ACTIVE               	= 6;
localparam TRAINERROR_HS        	= 7;
localparam TRAINERROR           	= 8;
localparam LINKMGMT_RETRAIN     	= 9;
localparam PHYRETRAIN           	= 10;
localparam L1_L2                	= 11;

// Sub-States parameters of MBINIT
localparam PARAM 		 			= 0;
localparam CAL 			 			= 1;
localparam REPAIRCLK 		 		= 2;
localparam REPAIRVAL 		 		= 3;
localparam REVERSALMB 		 		= 4;
localparam REPAIRMB 			 	= 5;

// Sub-States parameters of MBTRIIN
localparam VALREF 		 			= 0;
localparam DATAVREF 	 			= 1;
localparam SPEEDIDLE  				= 2;
localparam TXSELFCAL 		 		= 3;
localparam RXCLKCAL 				= 4;
localparam VALTRAINCENTER 		 	= 5;
localparam VALTRAINVREF 			= 6;
localparam DATATRAINCENTER1 		= 7;
localparam DATATRAINVREF 			= 8;
localparam RXDESKEW 				= 9;
localparam DATATRAINCENTER2 		= 10;
localparam LINKSPEED 				= 11;
localparam REPAIR 					= 12;

// Point Test / Eye Sweep parameters
localparam TX_POINT_TEST  			= 0;
localparam TX_EYE_SWEEP  			= 1;
localparam RX_POINT_TEST  			= 2;
localparam RX_EYE_SWEEP  			= 3;

/*------------------------------------------------------------------------------
--  Outputs
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		o_data_encoded <= 0;
		o_d_valid <= 0;
	end else begin
		if (i_msg_valid) begin

			// RDI Message  (all rdi messages without data so padding with zeros)
			if (i_rdi_msg) begin
				o_d_valid <= 1;
				o_data_encoded <= {64{1'b0}};
			end

			// Point Test / Eye Sweep tests
			else if (i_tx_point_sweep_test_en && i_data_valid) begin

				// repeated in all four cases
				if (i_msg_no == 1) begin
					o_d_valid <= 1;
					o_data_encoded <= {{4{1'b0}},i_data_bus[4],{16{1'b1}},{16{1'b0}},{15{1'b0}},i_data_bus[3],{1{1'b0}},{2{1'b0}},i_data_bus[2:1],{3{1'b0}},{2{1'b0}},i_data_bus[0]}; 
				end
				else begin
					case (i_tx_point_sweep_test)

						TX_POINT_TEST: begin
							if (i_msg_no == 6) begin
								o_d_valid <= 1;
								o_data_encoded <= {{48{1'b0}},i_data_bus[15:0]};
							end
							else begin
								o_d_valid <= 1;
								o_data_encoded <= {64{1'b0}};
							end
						end 

						TX_EYE_SWEEP: begin
							o_d_valid <= 1;
							o_data_encoded <= {64{1'b0}};
						end 

						RX_POINT_TEST: begin
							if (i_msg_no == 6) begin
								o_d_valid <= 1;
								o_data_encoded <= {{48{1'b0}},i_data_bus[15:0]};
							end
							else begin
								o_d_valid <= 1;
								o_data_encoded <= {64{1'b0}};
							end
						end 

						RX_EYE_SWEEP: begin
							if (i_msg_no == 9) begin
								o_d_valid <= 1;
								o_data_encoded <= {{48{1'b0}},i_data_bus[15:0]};
							end
							else begin
								o_d_valid <= 1;
								o_data_encoded <= {64{1'b0}};
							end
						end 

					endcase
				end
				
			end

			else if (i_data_valid) begin
				// reset/idle state in each msg number 
				if (i_msg_no == 0) begin
					o_d_valid <= 0;
				end

				else begin
					case (i_state)

						MBINIT : begin
							case (i_sub_state)

								PARAM: begin
									o_d_valid <= 1;
									o_data_encoded <= {{53{1'b0}},i_data_bus[10:0]};  
								end 

								REVERSALMB : begin
								// i think we dont need to put if condition to chech mnsg_no = 5 as it is the only case inside this sub-state that send data 
									if (i_msg_no == 6) begin
										o_d_valid <= 1;
										o_data_encoded <= {{48{1'b0}},i_data_bus[15:0]};
									end
								end 

								default : begin 
									o_d_valid <= 0;
									o_data_encoded <= {64{1'b0}};
								end 
							endcase
						end
					
						default : begin 
							o_d_valid <= 0;
							o_data_encoded <= {64{1'b0}};
						end 
					endcase
				end	
			end

			else begin
				o_d_valid <= 1;
				o_data_encoded <= {64{1'b0}};
			end
		end
		

		else begin
			o_d_valid <= 0;
		end
	end
end

endmodule : SB_DATA_ENCODER
