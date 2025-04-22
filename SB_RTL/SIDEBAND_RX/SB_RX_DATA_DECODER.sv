module SB_DATA_DECODER (
	input 				i_clk,
	input 				i_rst_n,
	input 				i_data_enable,
	input 				i_header_is_valid_on_bus,
	input		[63:0]  i_data,
	output 	reg			o_data_valid,
	output  reg [15:0]  o_data
);


/*------------------------------------------------------------------------------
-- INTERNAL WIRES & REGS   
------------------------------------------------------------------------------*/
reg 	[7:0] 	MsgCode;
reg 	[7:0] 	MsgSubCode;


/*------------------------------------------------------------------------------
-- Conditions
------------------------------------------------------------------------------*/
assign TEST_REQ_MESSAGE_WITH_DATA 		= MsgSubCode[3:0] == 4'h1 || MsgSubCode[3:0] == 4'h5 || MsgSubCode[3:0] == 4'h7 || MsgSubCode[3:0] == 4'hA;
assign TEST_RESP_MESSAGE_WITH_DATA 		= MsgSubCode[3:0] == 4'h3 || MsgSubCode[3:0] == 4'hB;


/*------------------------------------------------------------------------------
-- Messge Code / SubCode registering  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		MsgSubCode 	<= 0;
		MsgCode 	<= 0; 
	end else if (i_header_is_valid_on_bus) begin
		MsgSubCode 	<= i_data [39:32];
 		MsgCode 	<= i_data [21:14];
	end
end

/*------------------------------------------------------------------------------
-- Output Valid  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		o_data_valid <= 0;
	end 
	else begin
		if (i_data_enable) begin
			o_data_valid <= 1;
		end
		else begin
			if (o_data_valid) begin
				o_data_valid <= 0;
			end
		end
	end
end 

/*------------------------------------------------------------------------------
-- Output Data  
------------------------------------------------------------------------------*/
always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		o_data <= 0;
	end else begin
		if (i_data_enable) begin
			case (MsgCode)
				8'h85: begin
					if (TEST_REQ_MESSAGE_WITH_DATA) begin
						o_data <= {{11{1'b0}},i_data[59], i_data[11], i_data[7:6], i_data[0]};
					end
				end 

				8'h8A, 8'h81: begin
					if (TEST_RESP_MESSAGE_WITH_DATA) begin
						o_data <= i_data[15:0];
					end
				end 

				8'hA5: begin
					if (MsgSubCode[3:0] == 4'h0) begin
						o_data <= {{5{1'b0}}, i_data[10:0]};
					end
				end 

				8'hAA: begin
					if (MsgSubCode[3:0] == 4'h0) begin
						o_data <= {{5{1'b0}}, i_data[10:0]};
					end
					else if (MsgSubCode[3:0] == 4'hF) begin
						o_data <= i_data[15:0];
					end
				end 
			
				default : begin
					o_data <= 0;
				end 
			endcase
		end 
    end 
end 

endmodule 