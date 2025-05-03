class MB_sequence_item extends  uvm_sequence_item;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	parameter SER_WIDTH = 32;

	/*************************************************************************
    * INPUTS OF DUT
    *************************************************************************/
	// clocks and resets 
    bit                         i_CKP;      // Received CKP
    bit                         i_CKN;      // Received CKN
    bit                         i_TRACK;    // Received TRACK
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
    // communicating with analog domain
    logic                      o_serliazer_en;
    logic                      o_diff_or_quad_clk;
    logic      [3:0]           o_reciever_ref_volatge;
    logic      [3:0]           o_pi_step;



    //Flags to know what i'm driving

    // This is a ONEHOT Encoding bus to know which typr of seq i drive
    // 1000 -> LFSR Pattern || 0100 -> Per-lane ID Pattern || 0010 -> Valid Pattern || 0001 -> CLK Pattern
    // We need this in diver as in case of Valid and CLK patterns
    // we don't need to enable the deser enables of data and valid in case of CLK pattern 
    // we don't need to enable the deser data in case of Valid pattern
    // We don't need to model desers delay in case of CLK pattern 
    logic [3:0] seq_type;

    // Flag to know that i'm sending last seq in perlane ID to make deser_valid_val low at last seq pattern
    bit last_seq;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(MB_sequence_item)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "MB_sequence_item");
		super.new(name);
	endfunction : new

	// function string convert2string();
	// 		//return $sformatf("%s rst_n = 0b%0b, SS_n = 0b%0b, MOSI = 0b%0b, MISO = 0b%0b, MISO_gm = 0b%0b", super.convert2string(), 
	// 						  rst_n, SS_n, MOSI, MISO, MISO_gm);
	// 	endfunction : convert2string

	// function string convert2string_stimulus();
	// 	//return $sformatf("rst_n = 0b%0b, SS_n = 0b%0b, MOSI = 0b%0b", 
	// 					  rst_n, SS_n, MOSI);
	// endfunction : convert2string_stimulus

endclass : MB_sequence_item

