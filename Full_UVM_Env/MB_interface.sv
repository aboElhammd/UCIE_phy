interface MB_interface (input i_clk);
	parameter SER_WIDTH = 32;
	

	/*************************************************************************
    * INPUTS OF DUT
    *************************************************************************/
	// clocks and resets 
    logic                       i_ckp;      // module local CKP 
    logic                       i_ckn;      // module local CKN
    logic                       i_CKP;      // Received CKP
    logic                       i_CKN;      // Received CKN
    logic                       i_TRACK;    // Received TRACK
    logic                       i_rst_n;  
    // valid lane
    logic       [SER_WIDTH-1:0] i_RVLD_L; 
    logic                       i_deser_valid_val;  // a valid signal from valid deserilaizer
    // Main band data lanes
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_0;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_1;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_2;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_3;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_4;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_5;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_6;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_7;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_8;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_9;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_10;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_11;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_12;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_13;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_14;
    logic       [SER_WIDTH-1:0] i_lfsr_rx_lane_15;
    logic                       i_deser_valid_data; // data lane deserializer
    /*************************************************************************
    * OUTPUTS OF DUT
    *************************************************************************/
    // Clock lanes : CKP; CKN; TRACK
    logic                      o_CKP;
    logic                      o_CKN;
    logic                      o_TRACK;
    // valid lane
    logic      [SER_WIDTH-1:0] o_TVLD_L;
    logic                      o_serliazer_valid_en; 
    // Main band data lanes
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_0;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_1;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_2;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_3;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_4;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_5;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_6;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_7;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_8;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_9;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_10;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_11;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_12;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_13;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_14;
    logic      [SER_WIDTH-1:0] o_lfsr_tx_lane_15;
    logic                      o_serliazer_data_en;
    // communicating with analog domain
    logic                      o_diff_or_quad_clk;
    logic      [3:0]           o_reciever_ref_volatge;
    logic      [3:0]           o_pi_step;




    /////////////////////////////////////////
    //////////        FLAGS       //////////
    ///////////////////////////////////////

    //Flags to know what i'm driving

    // This is a ONEHOT Encoding bus to know which typr of seq i drive
    // 1000 -> LFSR Pattern || 0100 -> Per-lane ID Pattern || 0010 -> Valid Pattern || 0001 -> CLK Pattern || 0000 - > No Pattern
    // We need this in diver as in case of Valid and CLK patterns
    // we don't need to enable the deser enables of data and valid in case of CLK pattern 
    // we don't need to enable the deser data in case of Valid pattern
    // We don't need to model desers delay in case of CLK pattern 
    logic [3:0] seq_type;
    
 endinterface : MB_interface