/*********************************************************************************
* any signal starts with " wp_ " : this is an internal signal inside the wrapper *
**********************************************************************************/

module PHYRETRAIN_WRAPPER #(
    parameter SB_MSG_WIDTH = 4
) (
    /*************************************************************************
    * INPUTS
    *************************************************************************/
	input										i_clk,
	input  										i_rst_n,
    // LTSM related signals
	input										i_phyretrain_en, 		// eli gyaly mn module el LTSM 34an abd2 asasn di el enable bta3t this module
    input                                       i_enter_from_active_or_mbtrain, // 0h: entered from ACTIVE state , 1h: entered from MBTRAIN.LINKSPEED state
    input           [1:0]                       i_linkspeed_lanes_status,   // from linkspeed  0h: IDLE , 1h: No Lane errors, 2h: Lane errors & faulty Lanes are repairable, 3h: Lane errors & faulty Lanes cannot be repaired
    input                                       i_clear_resolved_state, // to reset resolved state upon each new training so that MBTRAIN starts from first state as normal
    // Sideband related signals
    input                                       i_SB_Busy,              // 1: means SB shaghal mtb3tloosh 7aga, 0: means SB fady
    input                                       i_falling_edge_busy,
    input                                       i_rx_msg_valid,
    input           [2:0]                       i_rx_msg_info,          // gayly mn SB, 3ubara 3n el encoding fi el partner req
    input			[SB_MSG_WIDTH-1:0]			i_decoded_SB_msg, 		// gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha 
    /*************************************************************************
    * OUTPUTS
    *************************************************************************/	
    // Sideband related signals
    output 	reg		[SB_MSG_WIDTH-1:0]			o_encoded_SB_msg, 	    // sent to SB 34an 22olo haystkhdm anhy encoding 
    output                                      o_tx_msg_valid,
    output          [2:0]                       o_tx_msg_info,
    // LTSM related signals
	output	    								o_PHYRETRAIN_end,    // sent to LTSM 34an ykhush el MBINIT w 22olo eni khalst
    output          [1:0]                       o_resolved_state         // sent to LTSM 34an 22olo yru7 l anhy state after resolving (0h: IDLE, 1h:MBTRAIN.TXSELFCAL, 2h:MBTRAIN.REPAIR, 3h: MBTRAIN.SPEEDIDLE)
);

/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////
		
wire 			                wp_tx_valid , wp_rx_valid;
wire    [SB_MSG_WIDTH-1:0]      wp_tx_encoded_SB_msg, wp_rx_encoded_SB_msg; 	
wire                            wp_tx_PHYRETRAIN_end, wp_rx_PHYRETRAIN_end;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

assign o_PHYRETRAIN_end   = wp_tx_PHYRETRAIN_end & wp_rx_PHYRETRAIN_end;
assign o_tx_msg_valid     = wp_rx_valid | wp_tx_valid;

/////////////////////////////////////////
//////////// Instantsiations ////////////
///////////////////////////////////////// 

/************
* TX SBINIT *
*************/

TX_PHYRETRAIN  #(
    .SB_MSG_WIDTH(SB_MSG_WIDTH)
) TX_inst (
    .i_clk                          (i_clk),
    .i_rst_n                        (i_rst_n),
    .i_phyretrain_en                (i_phyretrain_en),
    .i_enter_from_active_or_mbtrain (i_enter_from_active_or_mbtrain),
    .i_linkspeed_lanes_status       (i_linkspeed_lanes_status),
    .i_falling_edge_busy            (i_falling_edge_busy),
    .i_rx_valid                     (wp_rx_valid),
    .i_rx_msg_valid                 (i_rx_msg_valid),
    .i_decoded_SB_msg               (i_decoded_SB_msg),
    .o_encoded_SB_msg_tx            (wp_tx_encoded_SB_msg),
    .o_msg_info                     (o_tx_msg_info),
    .o_phyretrain_end_tx            (wp_tx_PHYRETRAIN_end),
    .o_valid_tx                     (wp_tx_valid)
);

/************
* RX SBINIT *
*************/

RX_PHYRETRAIN  #(
    .SB_MSG_WIDTH(SB_MSG_WIDTH)
) RX_inst (
    .i_clk                      (i_clk),
    .i_rst_n                    (i_rst_n),
    .i_phyretrain_en            (i_phyretrain_en),
    .i_falling_edge_busy        (i_falling_edge_busy),
    .i_SB_Busy                  (i_SB_Busy),
    .i_tx_valid                 (wp_tx_valid),
    .i_rx_msg_valid             (i_rx_msg_valid),
    .i_local_retrain_encoding   (o_tx_msg_info),
    .i_retrain_encoding_partner (i_rx_msg_info),
    .i_clear_resolved_state     (i_clear_resolved_state),
    .i_decoded_SB_msg           (i_decoded_SB_msg),
    .o_encoded_SB_msg_rx        (wp_rx_encoded_SB_msg),
    .o_phyretrain_end_rx        (wp_rx_PHYRETRAIN_end),
    .o_resolved_state           (o_resolved_state),
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