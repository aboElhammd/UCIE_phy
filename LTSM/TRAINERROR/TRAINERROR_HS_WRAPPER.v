/*********************************************************************************
* any signal starts with " wp_ " : this is an internal signal inside the wrapper *
**********************************************************************************/

module TRAINERROR_HS_WRAPPER # (
    parameter SB_MSG_WIDTH = 4
) (
	input										i_clk,
	input  										i_rst_n,
	input										i_trainerror_en, 		// eli gyaly mn module el LTSM 34an abd2 asasn di el enable bta3t this module
    input                                       i_rx_msg_valid,
    input                                       i_SB_Busy,              // 1: means SB shaghal mtb3tloosh 7aga, 0: means SB fady
    input                                       i_falling_edge_busy,
    input                                       i_partner_req_trainerror,
	input			[SB_MSG_WIDTH-1:0]			i_decoded_SB_msg, 		// gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 
	output 	reg		[SB_MSG_WIDTH-1:0]			o_encoded_SB_msg, 	    // sent to SB 34an 22olo haystkhdm anhy encoding 
	output	    								o_TRAINERROR_HS_end,    // sent to LTSM 34an ykhush el MBINIT w 22olo eni khalst
    output                                      o_tx_msg_valid
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////
		
wire 			                wp_tx_valid , wp_rx_valid;
wire    [SB_MSG_WIDTH-1:0]      wp_tx_encoded_SB_msg, wp_rx_encoded_SB_msg; 	
wire                            wp_tx_TRAINERROR_end, wp_rx_TRAINERROR_end;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

assign o_TRAINERROR_HS_end = wp_tx_TRAINERROR_end & wp_rx_TRAINERROR_end;
assign o_tx_msg_valid      = wp_rx_valid | wp_tx_valid;

/////////////////////////////////////////
//////////// Instantsiations ////////////
///////////////////////////////////////// 

/************
* TX SBINIT *
*************/

TX_TRAINERROR_HS  #(
    .SB_MSG_WIDTH(SB_MSG_WIDTH)
) U_TX_TRAINERROR_HS (
    .i_clk                      (i_clk),
    .i_rst_n                    (i_rst_n),
    .i_trainerror_en            (i_trainerror_en),
    .i_rx_msg_valid             (i_rx_msg_valid),
    .i_falling_edge_busy        (i_falling_edge_busy),
    .i_partner_req_trainerror   (i_partner_req_trainerror),
    .i_rx_valid                 (wp_rx_valid),
    .i_decoded_SB_msg           (i_decoded_SB_msg),
    .o_encoded_SB_msg_tx        (wp_tx_encoded_SB_msg),
    .o_trainerror_end_tx        (wp_tx_TRAINERROR_end),
    .o_valid_tx                 (wp_tx_valid)
);

/************
* RX SBINIT *
*************/

RX_TRAINERROR_HS  #(
    .SB_MSG_WIDTH(SB_MSG_WIDTH)
) U_RX_TRAINERROR_HS (
    .i_clk                      (i_clk),
    .i_rst_n                    (i_rst_n),
    .i_trainerror_en            (i_trainerror_en),
    .i_rx_msg_valid             (i_rx_msg_valid),
    .i_SB_Busy                  (i_SB_Busy),
    .i_falling_edge_busy        (i_falling_edge_busy),
    .i_partner_req_trainerror   (i_partner_req_trainerror),
    .i_tx_valid                 (wp_tx_valid),
    .i_decoded_SB_msg           (i_decoded_SB_msg),
    .o_encoded_SB_msg_rx        (wp_rx_encoded_SB_msg),
    .o_trainerror_end_rx        (wp_rx_TRAINERROR_end),
    .o_valid_rx                 (wp_rx_valid)
);

/////////////////////////////////////////
//// Handling SB encoded priorities /////
///////////////////////////////////////// 

always @ (*) begin
    case ({wp_tx_valid, wp_rx_valid})
        2'b00: begin
            o_encoded_SB_msg = 4'b0000;
        end
        2'b01: begin
            o_encoded_SB_msg = wp_rx_encoded_SB_msg;
        end
        2'b10: begin
            o_encoded_SB_msg = wp_tx_encoded_SB_msg;
        end
        2'b11: begin
            o_encoded_SB_msg = wp_rx_encoded_SB_msg;
        end
        default: begin
            o_encoded_SB_msg = 4'b0000;
        end
    endcase
end

endmodule 