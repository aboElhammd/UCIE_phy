/*********************************************************************************
* any signal starts with " wp_ " : this is an internal signal inside the wrapper *
**********************************************************************************/

module rx_initiated_point_test_wrapper #(
	parameter SB_MSG_WIDTH = 4    
)(
    /***************************************************************
    * INPUTS
    ***************************************************************/
	input										i_clk,
	input  										i_rst_n,
    // LTSM related signals            
    input                                       i_rx_d2c_pt_en,         // eli gyaly mn el LTSM 34an abd2 asasn di el enable bta3t this module                           
	input                                       i_datavref_or_valvref,  // (0h: datavref , 1h: valvref)
    // Pattern Generator related signals
    input                                       i_pattern_finished,     // gyaly mn el pattern generator 34an y2olli eni khalast el pattern
    // pattern comparator related signals 
    input           [15:0]                      i_comparison_results,   // still we dont know what to do with it yet !!
    // Sideband related signals
    input   									i_SB_Busy,		 		// gayly mn elSB 34an y2olii enu khalas ba3t el data bta3te fa anzl el valid
    input			[SB_MSG_WIDTH-1:0]			i_decoded_SB_msg, 		// gyaly mn el SB b3d my3ml decode ll msg eli gyalo mn el partner w yb3tli el crossponding format liha	
    /***************************************************************
    * OUTPUTS
    ***************************************************************/
    // Sideband related signals    
    output 	reg		[SB_MSG_WIDTH-1:0]			o_encoded_SB_msg,    	// sent to SB 34an 22olo haystkhdm anhy encoding  
	output                                      o_sb_data_pattern,      // sent to SB 34an el data field (0h: LFSR, 1h: Per Lane ID)
    output                                      o_sb_burst_count,       // sent to SB 34an el data field (0h: 1k, 1h: 4k)
    output                                      o_sb_comparison_mode,   // sent to SB 34an el data field (0h: perlane, 1h:aggregate)
    output          [1:0]                       o_clock_phase,          // sent to SB 34an el data field (0h: eye center, 1h: left edge, 2h: right edge)
    // LTSM related signals 
	output										o_rx_d2c_pt_done, 		// ack to let know the master state that this block has finished
    // Pattern Generator,comparator related signals
    output                                      o_val_pattern_en,       //  if (i_datavref_or_valvref == 1)? 1 : 0
    output          [1:0]                       o_mainband_pattern_generator_cw, // 00: IDLE, 01: CLEAR_LFSR, 10: LFSR, 11: NOP (No per lane ID in this test)
    output                                      o_comparison_valid_en,   // bashaghl biha el local valid pattern generator lw e7na bn optimize el valid lane vref
    output          [1:0]                       o_mainband_pattern_comparator_cw // 00: IDLE, 01: CLEAR_LFSR, 10: LFSR, 11: NOP (No per lane ID in this test)
);


/////////////////////////////////////////
//////////// Internal signals ///////////
/////////////////////////////////////////
		
wire 			                wp_tx_valid , wp_rx_valid;
wire    [SB_MSG_WIDTH-1:0]      wp_tx_encoded_SB_msg, wp_rx_encoded_SB_msg; 	
wire                            wp_rx_d2c_pt_done_tx, wp_rx_d2c_pt_done_rx;
reg                             Busy_reg;

/////////////////////////////////////////
////////// Assign statements ////////////
/////////////////////////////////////////

assign o_rx_d2c_pt_done     = wp_rx_d2c_pt_done_tx & wp_rx_d2c_pt_done_rx;
wire   falling_edge_busy    = (Busy_reg != i_SB_Busy) && !i_SB_Busy;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        Busy_reg <= 0;
    end else begin
        Busy_reg <= i_SB_Busy;
    end
end

/////////////////////////////////////////
//////////// Instantsiations ////////////
///////////////////////////////////////// 

/************
* TX  
*************/

rx_initiated_point_test_tx  #(SB_MSG_WIDTH) TX_inst (
.i_clk                              (i_clk),
.i_rst_n                            (i_rst_n),
.i_falling_edge_busy                (falling_edge_busy),
.i_rx_valid                         (wp_rx_valid),
.i_rx_d2c_pt_en                     (i_rx_d2c_pt_en),
.i_datavref_or_valvref              (i_datavref_or_valvref),
.i_pattern_finished                 (i_pattern_finished),
.i_decoded_SB_msg                   (i_decoded_SB_msg),
.o_encoded_SB_msg_tx                (wp_tx_encoded_SB_msg),
.o_sb_data_pattern                  (o_sb_data_pattern),
.o_sb_burst_count                   (o_sb_burst_count),
.o_sb_comparison_mode               (o_sb_comparison_mode),
.o_clock_phase                      (o_clock_phase),
.o_rx_d2c_pt_done_tx                (wp_rx_d2c_pt_done_tx),
.o_valid_tx                         (wp_tx_valid),
.o_val_pattern_en                   (o_val_pattern_en),
.o_mainband_pattern_generator_cw    (o_mainband_pattern_generator_cw)
);

/************
* RX  
*************/

rx_initiated_point_test_rx  #(SB_MSG_WIDTH) RX_inst (
.i_clk                              (i_clk),
.i_rst_n                            (i_rst_n),
.i_falling_edge_busy                (falling_edge_busy),
.i_tx_valid                         (wp_tx_valid),
.i_SB_Busy                          (i_SB_Busy),
.i_rx_d2c_pt_en                     (i_rx_d2c_pt_en),
.i_datavref_or_valvref              (i_datavref_or_valvref),
.i_decoded_SB_msg                   (i_decoded_SB_msg),
.o_encoded_SB_msg_rx                (wp_rx_encoded_SB_msg),
.o_rx_d2c_pt_done_rx                (wp_rx_d2c_pt_done_rx),
.o_valid_rx                         (wp_rx_valid),
.o_comparison_valid_en              (o_comparison_valid_en),
.o_mainband_pattern_comparator_cw   (o_mainband_pattern_comparator_cw)
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