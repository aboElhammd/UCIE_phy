module SB_RX_RDI_DECODER (
	input 					i_clk,
	input 					i_rst_n,
	input 					i_rdi_start_EN,
	input			[63:0]  i_rdi_header,
	output	reg 			o_rdi_msg,
	output	reg 	[1:0]	o_rdi_msg_code,
	output	reg 	[3:0] 	o_rdi_msg_sub_code,
	output	reg 	[1:0] 	o_rdi_msg_info,
	output 	reg 			o_rdi_msg_valid
);

//RDI MsgCode
localparam Nop  	= 0;
localparam Req  	= 1;
localparam Resp 	= 2;

wire [7:0] MsgCode;
wire [7:0] MsgSubCode;
wire [15:0] MsgInfo;

assign MsgCode 		= i_rdi_header [21:14];
assign MsgSubCode 	= i_rdi_header [39:32];
assign MsgInfo 		= i_rdi_header [55:40];


always @(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		o_rdi_msg_valid 	<= 0;
		o_rdi_msg 			<= 0;
		o_rdi_msg_code 		<= 0;
		o_rdi_msg_sub_code 	<= 0;
		o_rdi_msg_info  	<= 0;
		o_rdi_msg_info  	<= 0;
	end 
	else if (i_rdi_start_EN) begin
		o_rdi_msg_valid 	<= 1;
		o_rdi_msg 			<= 1;
		o_rdi_msg_code 		<= MsgCode [1:0];
		o_rdi_msg_sub_code 	<= MsgSubCode [3:0];

		if (MsgCode == Nop) begin
			o_rdi_msg_info  <= MsgInfo [1:0];
		end
		else if (MsgCode == Resp) begin
			o_rdi_msg_info  <= {1'b0, MsgInfo [0]};
		end
		else begin
			o_rdi_msg_info 	<= 0;
		end
	end
	else if (o_rdi_msg_valid) begin
		o_rdi_msg_valid 	<= 0;
	end
end

endmodule : SB_RX_RDI_DECODER