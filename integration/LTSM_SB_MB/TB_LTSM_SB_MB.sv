`timescale 1ps/100fs
module TB_LTSM_SB_MB;

///////////////////////////////////
//////////// PARAMETERS ///////////
///////////////////////////////////
localparam SER_WIDTH = 32;
localparam DELAY_CYCLES = 3;
localparam ERROR_LANE = 32'h00000810;
///////////////////////////////////
//////////// SIGNALS //////////////
///////////////////////////////////
/*--------------------------------
    * Module
--------------------------------*/
// Inputs
logic                 i_ser_clk_4G;
logic                 i_clk;      
logic                 i_rst_n;
logic                 i_clk_sb;   
logic                 i_ckp_1;      
logic                 i_ckn_1;      
logic [8*63:0]        i_lp_data_1;
logic                 i_start_training_RDI_1;
logic [SER_WIDTH-1:0] i_RVLD_L_1; 
logic                 i_deser_valid_val_1;  // a valid signal from valid deserilaizer      /////////////////////////////
logic                 i_deser_valid_data_1; // a valid signal from data lane deserializer  /////////////////////////
logic [63:0]          i_deser_data_sb_1; 
logic                 i_deser_done_sb_1;    // when sideband deserializer finishs deseriliazing
// outputs
logic                 o_CKP_1;
logic                 o_CKN_1;
logic                 o_TRACK_1;
logic [SER_WIDTH-1:0] o_TVLD_L_1; 
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_0_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_1_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_2_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_3_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_4_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_5_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_6_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_7_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_8_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_9_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_10_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_11_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_12_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_13_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_14_1;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_15_1;
logic [8*63:0]        o_pl_data_1;
logic                 o_deser_done_sampled_sb_1;
logic                 o_ser_done_sampled_sb_1;
logic                 o_pack_finished_sb_1;
logic                 o_clk_ser_en_sb_1;
logic                 o_SBCLK_1;
logic  [63:0]         o_sb_fifo_data_1;
logic                 o_serliazer_en_1;
logic                 o_diff_or_quad_clk_1;
logic  [3:0]          o_reciever_ref_volatge_1;
logic  [3:0]          o_pi_step_1;
logic                 o_serliazer_valid_en_1;
/*--------------------------------
    * Module Partner
--------------------------------*/
// Inputs
logic                 i_ckp_2;       
logic                 i_ckn_2;      
logic [8*63:0]        i_lp_data_2;
logic                 i_start_training_RDI_2;
logic [SER_WIDTH-1:0] i_RVLD_L_2; 
logic                 i_deser_valid_val_2;  // a valid signal from valid deserilaizer
logic                 i_deser_valid_data_2; // a valid signal from data lane deserializer
logic [63:0]          i_deser_data_sb_2; 
logic                 i_deser_done_sb_2;    // when sideband deserializer finishs deseriliazing
// outputs
logic                 o_CKP_2;
logic                 o_CKN_2;
logic                 o_TRACK_2;
logic [SER_WIDTH-1:0] o_TVLD_L_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_0_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_1_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_2_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_3_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_4_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_5_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_6_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_7_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_8_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_9_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_10_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_11_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_12_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_13_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_14_2;
logic [SER_WIDTH-1:0] o_lfsr_tx_lane_15_2;
logic [8*63:0]        o_pl_data_2;
logic                 o_deser_done_sampled_sb_2;
logic                 o_ser_done_sampled_sb_2;
logic                 o_pack_finished_sb_2;
logic                 o_clk_ser_en_sb_2;
logic                 o_SBCLK_2;
logic  [63:0]         o_sb_fifo_data_2;
logic                 o_serliazer_en_2;
logic                 o_diff_or_quad_clk_2;
logic  [3:0]          o_reciever_ref_volatge_2;
logic  [3:0]          o_pi_step_2;
logic                 o_serliazer_valid_en_2;

// Internal signals
string sub_state_1, sub_state_2;
string i_rx_msg_no_string_1, i_rx_msg_no_string_2;
string o_tx_msg_no_string_1, o_tx_msg_no_string_2;
logic SB_SER_DATA_1, SB_SER_DATA_2;
logic [SER_WIDTH-1:0] module_tx_lane_0  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_1  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_2  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_3  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_4  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_5  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_6  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_7  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_8  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_9  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_10 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_11 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_12 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_13 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_14 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] module_tx_lane_15 [DELAY_CYCLES-1:0];

logic [SER_WIDTH-1:0] partner_tx_lane_0  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_1  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_2  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_3  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_4  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_5  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_6  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_7  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_8  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_9  [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_10 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_11 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_12 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_13 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_14 [DELAY_CYCLES-1:0];
logic [SER_WIDTH-1:0] partner_tx_lane_15 [DELAY_CYCLES-1:0];

logic [SER_WIDTH-1:0] module_TVLD_L    [DELAY_CYCLES-1:0];

logic [SER_WIDTH-1:0] partner_TVLD_L   [DELAY_CYCLES-1:0];

logic module_CKP   [DELAY_CYCLES-1:0];
logic module_CKN   [DELAY_CYCLES-1:0];
logic module_TRACK [DELAY_CYCLES-1:0];

logic partner_CKP   [DELAY_CYCLES-1:0];
logic partner_CKN   [DELAY_CYCLES-1:0];
logic partner_TRACK [DELAY_CYCLES-1:0];

logic module_serliazer_en  [DELAY_CYCLES-1:0];
logic module_serliazer_valid_en  [DELAY_CYCLES-1:0];
logic partner_serliazer_en [DELAY_CYCLES-1:0];
logic partner_serliazer_valid_en [DELAY_CYCLES-1:0];
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// DUT INSTANTIATION /////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LTSM_SB_MB LTSM_SB_MB_inst_1 (
    // Input Ports
    .i_clk                     (i_ser_clk_4G),
    .i_clk_sb                  (i_clk_sb),
    .i_ckp                     (i_ckp_1),
    .i_ckn                     (i_ckn_1),
    .i_CKP                     (o_CKP_2),//partner_CKP   [DELAY_CYCLES-1]),
    .i_CKN                     (o_CKN_2),//partner_CKN   [DELAY_CYCLES-1]),
    .i_TRACK                   (o_TRACK_2),//partner_TRACK [DELAY_CYCLES-1]),
    .i_rst_n                   (i_rst_n),
    .i_lp_data                 (i_lp_data_1),
    .i_start_training_RDI      (i_start_training_RDI_1),
    .i_RVLD_L                  (partner_TVLD_L [DELAY_CYCLES-1]),
    .i_deser_valid_val         (module_serliazer_valid_en [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_0          (partner_tx_lane_0  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_1          (partner_tx_lane_1  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_2          (partner_tx_lane_2  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_3          (partner_tx_lane_3  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_4          (partner_tx_lane_4  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_5          (partner_tx_lane_5  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_6          (partner_tx_lane_6  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_7          (partner_tx_lane_7  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_8          (partner_tx_lane_8  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_9          (partner_tx_lane_9  [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_10         (partner_tx_lane_10 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_11         (partner_tx_lane_11 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_12         (partner_tx_lane_12 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_13         (partner_tx_lane_13 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_14         (partner_tx_lane_14 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_15         (partner_tx_lane_15 [DELAY_CYCLES-1]),
    .i_deser_valid_data        (module_serliazer_en [DELAY_CYCLES-1]),
    .i_deser_data_sb           (i_deser_data_sb_1),
    .i_deser_done_sb           (i_deser_done_sb_1),
    // Output Ports
    .o_CKP                     (o_CKP_1),
    .o_CKN                     (o_CKN_1),
    .o_TRACK                   (o_TRACK_1),
    .o_TVLD_L                  (o_TVLD_L_1),
    .o_lfsr_tx_lane_0          (o_lfsr_tx_lane_0_1),
    .o_lfsr_tx_lane_1          (o_lfsr_tx_lane_1_1),
    .o_lfsr_tx_lane_2          (o_lfsr_tx_lane_2_1),
    .o_lfsr_tx_lane_3          (o_lfsr_tx_lane_3_1),
    .o_lfsr_tx_lane_4          (o_lfsr_tx_lane_4_1),
    .o_lfsr_tx_lane_5          (o_lfsr_tx_lane_5_1),
    .o_lfsr_tx_lane_6          (o_lfsr_tx_lane_6_1),
    .o_lfsr_tx_lane_7          (o_lfsr_tx_lane_7_1),
    .o_lfsr_tx_lane_8          (o_lfsr_tx_lane_8_1),
    .o_lfsr_tx_lane_9          (o_lfsr_tx_lane_9_1),
    .o_lfsr_tx_lane_10         (o_lfsr_tx_lane_10_1),
    .o_lfsr_tx_lane_11         (o_lfsr_tx_lane_11_1),
    .o_lfsr_tx_lane_12         (o_lfsr_tx_lane_12_1),
    .o_lfsr_tx_lane_13         (o_lfsr_tx_lane_13_1),
    .o_lfsr_tx_lane_14         (o_lfsr_tx_lane_14_1),
    .o_lfsr_tx_lane_15         (o_lfsr_tx_lane_15_1),
    .o_pl_data                 (o_pl_data_1),
    .o_deser_done_sampled_sb   (o_deser_done_sampled_sb_1),
    .o_ser_done_sampled_sb     (o_ser_done_sampled_sb_1),
    .o_pack_finished_sb        (o_pack_finished_sb_1),
    .o_clk_ser_en_sb           (o_clk_ser_en_sb_1),
    .o_SBCLK                   (o_SBCLK_1),
    .o_sb_fifo_data            (o_sb_fifo_data_1),
    .o_serliazer_data_en       (o_serliazer_en_1),
    .o_diff_or_quad_clk        (o_diff_or_quad_clk_1),
    .o_reciever_ref_volatge    (o_reciever_ref_volatge_1),
    .o_pi_step                 (o_pi_step_1),
    .o_serliazer_valid_en      (o_serliazer_valid_en_1)
);

LTSM_SB_MB LTSM_SB_MB_inst_2 (
    // Input Ports
    .i_clk                     (i_ser_clk_4G),
    .i_clk_sb                  (i_clk_sb),
    .i_ckp                     (i_ckp_2),
    .i_ckn                     (i_ckn_2),
    .i_CKP                     (o_CKP_1),//module_CKP   [DELAY_CYCLES-1]),
    .i_CKN                     (o_CKN_1),//module_CKN   [DELAY_CYCLES-1]),
    .i_TRACK                   (o_TRACK_1),//module_TRACK [DELAY_CYCLES-1]),
    .i_rst_n                   (i_rst_n),
    .i_lp_data                 (i_lp_data_2),
    .i_start_training_RDI      (i_start_training_RDI_2),
    .i_RVLD_L                  (module_TVLD_L [DELAY_CYCLES-1]),
    .i_deser_valid_val         (partner_serliazer_valid_en [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_0          (module_tx_lane_0  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_1          (module_tx_lane_1  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_2          (module_tx_lane_2  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_3          (module_tx_lane_3  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_4          (module_tx_lane_4  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_5          (module_tx_lane_5  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_6          (module_tx_lane_6  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_7          (module_tx_lane_7  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_8          (module_tx_lane_8  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_9          (module_tx_lane_9  [DELAY_CYCLES-1] ),//& ERROR_LANE),
    .i_lfsr_rx_lane_10         (module_tx_lane_10 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_11         (module_tx_lane_11 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_12         (module_tx_lane_12 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_13         (module_tx_lane_13 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_14         (module_tx_lane_14 [DELAY_CYCLES-1]),
    .i_lfsr_rx_lane_15         (module_tx_lane_15 [DELAY_CYCLES-1]),
    .i_deser_valid_data        (partner_serliazer_en [DELAY_CYCLES-1]),
    .i_deser_data_sb           (i_deser_data_sb_2),
    .i_deser_done_sb           (i_deser_done_sb_2),
    // Output Ports
    .o_CKP                     (o_CKP_2),
    .o_CKN                     (o_CKN_2),
    .o_TRACK                   (o_TRACK_2),
    .o_TVLD_L                  (o_TVLD_L_2),
    .o_lfsr_tx_lane_0          (o_lfsr_tx_lane_0_2),
    .o_lfsr_tx_lane_1          (o_lfsr_tx_lane_1_2),
    .o_lfsr_tx_lane_2          (o_lfsr_tx_lane_2_2),
    .o_lfsr_tx_lane_3          (o_lfsr_tx_lane_3_2),
    .o_lfsr_tx_lane_4          (o_lfsr_tx_lane_4_2),
    .o_lfsr_tx_lane_5          (o_lfsr_tx_lane_5_2),
    .o_lfsr_tx_lane_6          (o_lfsr_tx_lane_6_2),
    .o_lfsr_tx_lane_7          (o_lfsr_tx_lane_7_2),
    .o_lfsr_tx_lane_8          (o_lfsr_tx_lane_8_2),
    .o_lfsr_tx_lane_9          (o_lfsr_tx_lane_9_2),
    .o_lfsr_tx_lane_10         (o_lfsr_tx_lane_10_2),
    .o_lfsr_tx_lane_11         (o_lfsr_tx_lane_11_2),
    .o_lfsr_tx_lane_12         (o_lfsr_tx_lane_12_2),
    .o_lfsr_tx_lane_13         (o_lfsr_tx_lane_13_2),
    .o_lfsr_tx_lane_14         (o_lfsr_tx_lane_14_2),
    .o_lfsr_tx_lane_15         (o_lfsr_tx_lane_15_2),
    .o_pl_data                 (o_pl_data_2),
    .o_deser_done_sampled_sb   (o_deser_done_sampled_sb_2),
    .o_ser_done_sampled_sb     (o_ser_done_sampled_sb_2),
    .o_pack_finished_sb        (o_pack_finished_sb_2),
    .o_clk_ser_en_sb           (o_clk_ser_en_sb_2),
    .o_SBCLK                   (o_SBCLK_2),
    .o_sb_fifo_data            (o_sb_fifo_data_2),
    .o_serliazer_data_en       (o_serliazer_en_2),
    .o_diff_or_quad_clk        (o_diff_or_quad_clk_2),
    .o_reciever_ref_volatge    (o_reciever_ref_volatge_2),
    .o_pi_step                 (o_pi_step_2),
    .o_serliazer_valid_en      (o_serliazer_valid_en_2)
);

/******************************************************************************
 * MAINBAND DATA SERIALIZERS
/******************************************************************************/
// MB_TX_SERIALIZER MB_TX_SERIALIZER_inst_1_1( 
//     .CLK                (i_ser_clk_4G),
//     .RST                (i_rst_n),
//     .P_DATA             (o_lfsr_tx_lane_0_1),
//     .SER_EN             (o_serliazer_en_1),
//     .SER_OUT            (SB_SER_DATA_1)
// );
/******************************************************************************
 * SIDEBAND DATA SERIALIZERS
/******************************************************************************/
SB_TX_SERIALIZER SB_TX_SERIALIZER_inst_1( 
    .i_pll_clk          (i_clk_sb),   
    .i_rst_n            (i_rst_n),
    .i_data_in  	    (o_sb_fifo_data_1),
    .i_enable		    (o_clk_ser_en_sb_1),
    .i_pack_finished    (o_pack_finished_sb_1),
    .TXDATASB           (SB_SER_DATA_1)
);

SB_TX_SERIALIZER SB_TX_SERIALIZER_inst_2( 
    .i_pll_clk          (i_clk_sb),   
    .i_rst_n            (i_rst_n),
    .i_data_in  	    (o_sb_fifo_data_2),
    .i_enable		    (o_clk_ser_en_sb_2),
    .i_pack_finished    (o_pack_finished_sb_2),
    .TXDATASB           (SB_SER_DATA_2)
);

/******************************************************************************
 * SIDEBAND DATA DESERIALIZERS
/******************************************************************************/
SB_RX_DESER SB_RX_DESER_inst_1 (
    .i_clk                  (o_SBCLK_2),               
    .i_clk_pll              (i_clk_sb),
    .i_rst_n                (i_rst_n),
    .ser_data_in            (SB_SER_DATA_2),
    .i_de_ser_done_sampled  (o_deser_done_sampled_sb_1),
    .par_data_out           (i_deser_data_sb_1),
    .de_ser_done            (i_deser_done_sb_1)
);

SB_RX_DESER SB_RX_DESER_inst_2 (
    .i_clk                  (o_SBCLK_1),               
    .i_clk_pll              (i_clk_sb),
    .i_rst_n                (i_rst_n),
    .ser_data_in            (SB_SER_DATA_1),
    .i_de_ser_done_sampled  (o_deser_done_sampled_sb_2),
    .par_data_out           (i_deser_data_sb_2),
    .de_ser_done            (i_deser_done_sb_2)
);
// just for modelling
clock_div_32 clock_div_32_inst_1 (
    .i_clk             (i_ser_clk_4G),
    .i_rst_n           (i_rst_n),
    .o_div_clk         (i_clk)
);   

// clock divider by 2
reg clk_div_2;
always @ (posedge i_ser_clk_4G or negedge i_rst_n) begin
    if (~i_rst_n) begin
        clk_div_2 <= 0;
    end else begin
        clk_div_2 <= ~clk_div_2;
    end
end
/**************************************************************************************************************************************************
*************************************************************** STIMILUS GENERATION ***************************************************************
**************************************************************************************************************************************************/
///////////////////////////////////
//////// CLOCK GENERATION /////////
///////////////////////////////////

 initial begin
    i_ser_clk_4G = 0;
    forever #125 i_ser_clk_4G = ~i_ser_clk_4G; // 0.25ns period = 4GHz
 end


assign i_ckp_1 = clk_div_2;
assign i_ckp_2 = clk_div_2;
assign i_ckn_1 = ~ clk_div_2;
assign i_ckn_2 = ~ clk_div_2;

initial begin
    i_clk_sb =  0;
    forever #625 i_clk_sb = ~ i_clk_sb; // 1.25ns period = 800MHz
end

///////////////////////////////////
///////// INITIAL BLOCK ///////////
///////////////////////////////////
// Reset generation
initial begin
    i_rst_n = 0;
    #20;
    i_rst_n = 1;
end

// Initiliaze inputs 
initial begin
    i_deser_valid_val_1 = 0;
    i_deser_valid_val_2 = 0;
    i_deser_valid_data_1 = 0;
    i_deser_valid_data_2 = 0;
end

// generating stimilus
wire start_train_RDI ;
initial begin
    DELAY (3);
    i_start_training_RDI_1 = 1;
    DELAY (1);
    i_start_training_RDI_1 = 0;
    DELAY (50000);
    $stop;
end

///////////////////////////////////
////////////// TASKS //////////////
///////////////////////////////////  
/**********************************
* delay task 
**********************************/
task DELAY (input integer delay);
    repeat (delay) @(posedge i_clk);
endtask

/**********************************
* modelling valid deserializer 
**********************************/
always @ (partner_TVLD_L [DELAY_CYCLES-1]) begin
    i_deser_valid_val_1 = 1;
    DELAY (1);
    i_deser_valid_val_1 = 0;
end

always @ (module_TVLD_L [DELAY_CYCLES-1]) begin
    i_deser_valid_val_2 = 1;
    DELAY (1);
    i_deser_valid_val_2 = 0;
end

/**********************************
* modelling data deserializer 
**********************************/
always @ (partner_tx_lane_0 [DELAY_CYCLES-1]) begin
    i_deser_valid_data_1 = 1;
    DELAY (1);
    i_deser_valid_data_1 = 0;
end

always @ (module_tx_lane_0 [DELAY_CYCLES-1]) begin
    i_deser_valid_data_2 = 1;
    DELAY (1);
    i_deser_valid_data_2 = 0;
end

/**************************************
 * modelling channel transfer delay
**************************************/
always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        for (int i = 0; i < DELAY_CYCLES; i = i + 1) begin 
            module_tx_lane_0  [i] <= 0;
            module_tx_lane_1  [i] <= 0;
            module_tx_lane_2  [i] <= 0;
            module_tx_lane_3  [i] <= 0;
            module_tx_lane_4  [i] <= 0;
            module_tx_lane_5  [i] <= 0;
            module_tx_lane_6  [i] <= 0;
            module_tx_lane_7  [i] <= 0;
            module_tx_lane_8  [i] <= 0;
            module_tx_lane_9  [i] <= 0;
            module_tx_lane_10 [i] <= 0;
            module_tx_lane_11 [i] <= 0;
            module_tx_lane_12 [i] <= 0;
            module_tx_lane_13 [i] <= 0;
            module_tx_lane_14 [i] <= 0;
            module_tx_lane_15 [i] <= 0;

            module_TVLD_L     [i] <= 0;

            module_CKP        [i] <= 0;
            module_CKN        [i] <= 0;
            module_TRACK      [i] <= 0;

            module_serliazer_en  [i] <= 0;
            module_serliazer_valid_en  [i] <= 0;

            partner_tx_lane_0  [i] <= 0;
            partner_tx_lane_1  [i] <= 0;
            partner_tx_lane_2  [i] <= 0;
            partner_tx_lane_3  [i] <= 0;
            partner_tx_lane_4  [i] <= 0;
            partner_tx_lane_5  [i] <= 0;
            partner_tx_lane_6  [i] <= 0;
            partner_tx_lane_7  [i] <= 0;
            partner_tx_lane_8  [i] <= 0;
            partner_tx_lane_9  [i] <= 0;
            partner_tx_lane_10 [i] <= 0;
            partner_tx_lane_11 [i] <= 0;
            partner_tx_lane_12 [i] <= 0;
            partner_tx_lane_13 [i] <= 0;
            partner_tx_lane_14 [i] <= 0;
            partner_tx_lane_15 [i] <= 0;

            partner_TVLD_L     [i] <= 0;

            partner_CKP        [i] <= 0;
            partner_CKN        [i] <= 0;
            partner_TRACK      [i] <= 0;

            partner_serliazer_en [i] <= 0;
            partner_serliazer_valid_en [i] <= 0;
        end
    end else begin
        for (int i = DELAY_CYCLES-1; i > 0; i = i - 1) begin
            module_tx_lane_0  [i] <= module_tx_lane_0  [i-1];
            module_tx_lane_1  [i] <= module_tx_lane_1  [i-1];
            module_tx_lane_2  [i] <= module_tx_lane_2  [i-1];
            module_tx_lane_3  [i] <= module_tx_lane_3  [i-1];
            module_tx_lane_4  [i] <= module_tx_lane_4  [i-1];
            module_tx_lane_5  [i] <= module_tx_lane_5  [i-1];
            module_tx_lane_6  [i] <= module_tx_lane_6  [i-1];
            module_tx_lane_7  [i] <= module_tx_lane_7  [i-1];
            module_tx_lane_8  [i] <= module_tx_lane_8  [i-1];
            module_tx_lane_9  [i] <= module_tx_lane_9  [i-1];
            module_tx_lane_10 [i] <= module_tx_lane_10 [i-1];
            module_tx_lane_11 [i] <= module_tx_lane_11 [i-1];
            module_tx_lane_12 [i] <= module_tx_lane_12 [i-1];
            module_tx_lane_13 [i] <= module_tx_lane_13 [i-1];
            module_tx_lane_14 [i] <= module_tx_lane_14 [i-1];
            module_tx_lane_15 [i] <= module_tx_lane_15 [i-1];

            module_TVLD_L     [i] <= module_TVLD_L [i-1];

            module_CKP        [i] <= module_CKP   [i-1];
            module_CKN        [i] <= module_CKN   [i-1];
            module_TRACK      [i] <= module_TRACK [i-1];

            module_serliazer_en [i] <= module_serliazer_en [i-1];
            module_serliazer_valid_en  [i] <= module_serliazer_valid_en [i-1];

            partner_tx_lane_0  [i] <= partner_tx_lane_0  [i-1];
            partner_tx_lane_1  [i] <= partner_tx_lane_1  [i-1];
            partner_tx_lane_2  [i] <= partner_tx_lane_2  [i-1];
            partner_tx_lane_3  [i] <= partner_tx_lane_3  [i-1];
            partner_tx_lane_4  [i] <= partner_tx_lane_4  [i-1];
            partner_tx_lane_5  [i] <= partner_tx_lane_5  [i-1];
            partner_tx_lane_6  [i] <= partner_tx_lane_6  [i-1];
            partner_tx_lane_7  [i] <= partner_tx_lane_7  [i-1];
            partner_tx_lane_8  [i] <= partner_tx_lane_8  [i-1];
            partner_tx_lane_9  [i] <= partner_tx_lane_9  [i-1];
            partner_tx_lane_10 [i] <= partner_tx_lane_10 [i-1];
            partner_tx_lane_11 [i] <= partner_tx_lane_11 [i-1];
            partner_tx_lane_12 [i] <= partner_tx_lane_12 [i-1];
            partner_tx_lane_13 [i] <= partner_tx_lane_13 [i-1];
            partner_tx_lane_14 [i] <= partner_tx_lane_14 [i-1];
            partner_tx_lane_15 [i] <= partner_tx_lane_15 [i-1];

            partner_TVLD_L     [i] <= partner_TVLD_L [i-1];

            partner_CKP        [i] <= partner_CKP   [i-1];
            partner_CKN        [i] <= partner_CKN   [i-1];
            partner_TRACK      [i] <= partner_TRACK [i-1];

            partner_serliazer_en [i] <= partner_serliazer_en [i-1];
            partner_serliazer_valid_en [i] <= partner_serliazer_valid_en [i-1];
        end 
            module_tx_lane_0  [0] <= o_lfsr_tx_lane_0_1;
            module_tx_lane_1  [0] <= o_lfsr_tx_lane_1_1;
            module_tx_lane_2  [0] <= o_lfsr_tx_lane_2_1;
            module_tx_lane_3  [0] <= o_lfsr_tx_lane_3_1;
            module_tx_lane_4  [0] <= o_lfsr_tx_lane_4_1;
            module_tx_lane_5  [0] <= o_lfsr_tx_lane_5_1;
            module_tx_lane_6  [0] <= o_lfsr_tx_lane_6_1;
            module_tx_lane_7  [0] <= o_lfsr_tx_lane_7_1;
            module_tx_lane_8  [0] <= o_lfsr_tx_lane_8_1;
            module_tx_lane_9  [0] <= o_lfsr_tx_lane_9_1;
            module_tx_lane_10 [0] <= o_lfsr_tx_lane_10_1;
            module_tx_lane_11 [0] <= o_lfsr_tx_lane_11_1;
            module_tx_lane_12 [0] <= o_lfsr_tx_lane_12_1;
            module_tx_lane_13 [0] <= o_lfsr_tx_lane_13_1;
            module_tx_lane_14 [0] <= o_lfsr_tx_lane_14_1;
            module_tx_lane_15 [0] <= o_lfsr_tx_lane_15_1;

            module_TVLD_L     [0] <= o_TVLD_L_1;

            module_CKP        [0] <= o_CKP_1;
            module_CKN        [0] <= o_CKN_1;
            module_TRACK      [0] <= o_TRACK_1;

            module_serliazer_en [0] <= o_serliazer_en_2;
            module_serliazer_valid_en [0] <= o_serliazer_valid_en_2;

            partner_tx_lane_0  [0] <= o_lfsr_tx_lane_0_2;
            partner_tx_lane_1  [0] <= o_lfsr_tx_lane_1_2;
            partner_tx_lane_2  [0] <= o_lfsr_tx_lane_2_2;
            partner_tx_lane_3  [0] <= o_lfsr_tx_lane_3_2;
            partner_tx_lane_4  [0] <= o_lfsr_tx_lane_4_2;
            partner_tx_lane_5  [0] <= o_lfsr_tx_lane_5_2;
            partner_tx_lane_6  [0] <= o_lfsr_tx_lane_6_2;
            partner_tx_lane_7  [0] <= o_lfsr_tx_lane_7_2;
            partner_tx_lane_8  [0] <= o_lfsr_tx_lane_8_2;
            partner_tx_lane_9  [0] <= o_lfsr_tx_lane_9_2;
            partner_tx_lane_10 [0] <= o_lfsr_tx_lane_10_2;
            partner_tx_lane_11 [0] <= o_lfsr_tx_lane_11_2;
            partner_tx_lane_12 [0] <= o_lfsr_tx_lane_12_2;
            partner_tx_lane_13 [0] <= o_lfsr_tx_lane_13_2;
            partner_tx_lane_14 [0] <= o_lfsr_tx_lane_14_2;
            partner_tx_lane_15 [0] <= o_lfsr_tx_lane_15_2;

            partner_TVLD_L     [0] <= o_TVLD_L_2;

            partner_CKP        [0] <= o_CKP_2;
            partner_CKN        [0] <= o_CKN_2;
            partner_TRACK      [0] <= o_TRACK_2;

            partner_serliazer_en [0] <= o_serliazer_en_1;
            partner_serliazer_valid_en [0] <= o_serliazer_valid_en_1;
    end
end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// FOR DEBUGGING ONLY ////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////
//////////// FSM STATES ///////////
///////////////////////////////////
/*---------------------------------
* FSM main States
---------------------------------*/
typedef enum {  
    RESET                = 0,
    FINISH_RESET         = 1,
    SBINIT               = 2,
    MBINIT               = 3,
    MBTRAIN              = 4,
    LINKINIT             = 5,
    ACTIVE               = 6,
    TRAINERROR_HS        = 7,
    TRAINERROR           = 8,
    LINKMGMT_RETRAIN     = 9,
    PHYRETRAIN           = 10,
    L1_L2                = 11
} states_tx;

/*---------------------------------
* FSM sub States
---------------------------------*/
localparam PARAM                = 0;
localparam CAL                  = 1;
localparam REPAIRCLK            = 2;
localparam REPAIRVAL            = 3;
localparam REVERSALMB           = 4;
localparam REPAIRMB             = 5;

localparam VALVREF              = 0;
localparam DATAVREF             = 1;
localparam SPEEDIDLE            = 2;
localparam TXSELFCAL            = 3;
localparam RXCLKCAL             = 4;
localparam VALTRAINCENTER       = 5;
localparam VALTRAINVREF         = 6;
localparam DATATRAINCENTER1     = 7;
localparam DATATRAINVREF        = 8;
localparam RXDESKEW             = 9;
localparam DATATRAINCENTER2     = 10;
localparam LINKSPEED            = 11;
localparam REPAIR               = 12;


states_tx CS_top_1, NS_top_1, CS_top_2, NS_top_2;

always @ (*) begin
CS_top_1 = states_tx'(LTSM_SB_MB_inst_1.LTSM_TOP_inst.CS);
NS_top_1 = states_tx'(LTSM_SB_MB_inst_1.LTSM_TOP_inst.NS);
CS_top_2 = states_tx'(LTSM_SB_MB_inst_2.LTSM_TOP_inst.CS);
NS_top_2 = states_tx'(LTSM_SB_MB_inst_2.LTSM_TOP_inst.NS);
end
// module 
always @ (*) begin
sub_state_1 = "UNKNOWN";
case (CS_top_1) 
    MBINIT: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_tx_sub_state)
            0: sub_state_1 = "PARAM";
            1: sub_state_1 = "CAL";
            2: sub_state_1 = "REPAIRCLK";
            3: sub_state_1 = "REPAIRVAL";
            4: sub_state_1 = "REVERSALMB";
            5: sub_state_1 = "REPAIRMB";
            default: sub_state_1 = "UNKNOWN";
        endcase
    end
    MBTRAIN: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_tx_sub_state)
            0: sub_state_1 = "VALVREF";
            1: sub_state_1 = "DATAVREF";
            2: sub_state_1 = "SPEEDIDLE";
            3: sub_state_1 = "TXSELFCAL";
            4: sub_state_1 = "RXCLKCAL";
            5: sub_state_1 = "VALTRAINCENTER";
            6: sub_state_1 = "VALTRAINVREF";
            7: sub_state_1 = "DATATRAINCENTER1";
            8: sub_state_1 = "DATATRAINVREF";
            9: sub_state_1 = "RXDESKEW";
            10: sub_state_1 = "DATATRAINCENTER2";
            11: sub_state_1 = "LINKSPEED";
            12: sub_state_1 = "REPAIR";
            default : sub_state_1 = "UNKNOWN";
        endcase
    end
endcase
end

//partner
always @ (*) begin
sub_state_2 = "UNKNOWN";
case (CS_top_2) 
    MBINIT: begin
        case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_tx_sub_state)
            0: sub_state_2 = "PARAM";
            1: sub_state_2 = "CAL";
            2: sub_state_2 = "REPAIRCLK";
            3: sub_state_2 = "REPAIRVAL";
            4: sub_state_2 = "REVERSALMB";
            5: sub_state_2 = "REPAIRMB";
            default: sub_state_2 = "UNKNOWN";
        endcase
    end
    MBTRAIN: begin
        case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_tx_sub_state)
            0: sub_state_2 = "VALVREF";
            1: sub_state_2 = "DATAVREF";
            2: sub_state_2 = "SPEEDIDLE";
            3: sub_state_2 = "TXSELFCAL";
            4: sub_state_2 = "RXCLKCAL";
            5: sub_state_2 = "VALTRAINCENTER";
            6: sub_state_2 = "VALTRAINVREF";
            7: sub_state_2 = "DATATRAINCENTER1";
            8: sub_state_2 = "DATATRAINVREF";
            9: sub_state_2 = "RXDESKEW";
            10: sub_state_2 = "DATATRAINCENTER2";
            11: sub_state_2 = "LINKSPEED";
            12: sub_state_2 = "REPAIR";
            default : sub_state_2 = "UNKOWN";
        endcase
    end
endcase
end

// module 
always @ (*) begin
if (!LTSM_SB_MB_inst_1.tx_d2c_pt_en && !LTSM_SB_MB_inst_1.rx_d2c_pt_en) begin
i_rx_msg_no_string_1 = "UNKNOWN"; // Default case
case (CS_top_1)
    SBINIT: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
            3: i_rx_msg_no_string_1 = "SBINIT_OUT_OF_RESET_MSG";
            1: i_rx_msg_no_string_1 = "SBINIT_DONE_REQ_MSG";
            2: i_rx_msg_no_string_1 = "SBINIT_DONE_RESP_MSG";
        endcase
    end
    MBINIT: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_tx_sub_state)
            PARAM: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "PARAM_CONFIG_REQ";
                    2: i_rx_msg_no_string_1 = "PARAM_CONFIG_RESP";
                    3: i_rx_msg_no_string_1 = "PARAM_SBFE_REQ";
                    4: i_rx_msg_no_string_1 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "CAL_DONE_REQ";
                    2: i_rx_msg_no_string_1 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIRCLK_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRCLK_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRCLK_RESULT_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRCLK_RESULT_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRCLK_DONE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIRVAL_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRVAL_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRVAL_RESULT_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRVAL_RESULT_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRVAL_DONE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REVERSALMB_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REVERSALMB_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: i_rx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: i_rx_msg_no_string_1 = "REVERSALMB_RESULT_REQ";
                    6: i_rx_msg_no_string_1 = "REVERSALMB_RESULT_RESP";
                    7: i_rx_msg_no_string_1 = "REVERSALMB_DONE_REQ";
                    8: i_rx_msg_no_string_1 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIRMB_START_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIRMB_START_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIRMB_END_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIRMB_END_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    MBTRAIN: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_tx_sub_state)
            VALVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "VALVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "VALVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "VALVREF_END_REQ";
                    4: i_rx_msg_no_string_1 = "VALVREF_END_RESP";
                endcase
            end
            DATAVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATAVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATAVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATAVREF_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATAVREF_END_RESP";
                endcase
            end
            SPEEDIDLE: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "SPEEDIDLE_DONE_REQ";
                    2: i_rx_msg_no_string_1 = "SPEEDIDLE_DONE_RESP";
                endcase
            end
            TXSELFCAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "TXSELFCAL_DONE_REQ";
                    2: i_rx_msg_no_string_1 = "TXSELFCAL_DONE_RESP";
                endcase
            end
            RXCLKCAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "RXCLKCAL_START_REQ";
                    2: i_rx_msg_no_string_1 = "RXCLKCAL_START_RESP";
                    3: i_rx_msg_no_string_1 = "RXCLKCAL_DONE_REQ";
                    4: i_rx_msg_no_string_1 = "RXCLKCAL_DONE_RESP";
                endcase
            end
            VALTRAINCENTER: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "VALTRAINCENTER_START_REQ";
                    2: i_rx_msg_no_string_1 = "VALTRAINCENTER_START_RESP";
                    3: i_rx_msg_no_string_1 = "VALTRAINCENTER_DONE_REQ";
                    4: i_rx_msg_no_string_1 = "VALTRAINCENTER_DONE_RESP";
                endcase
            end
            VALTRAINVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "VALTRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "VALTRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "VALTRAINVREF_DONE_REQ";
                    4: i_rx_msg_no_string_1 = "VALTRAINVREF_DONE_RESP";
                endcase
            end
            DATATRAINCENTER1: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATATRAINCENTER1_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATATRAINCENTER1_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATATRAINCENTER1_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATATRAINCENTER1_END_RESP";
                endcase
            end
            DATATRAINVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATATRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATATRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATATRAINVREF_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATATRAINVREF_END_RESP";
                endcase
            end
            RXDESKEW: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "RXDESKEW_START_REQ";
                    2: i_rx_msg_no_string_1 = "RXDESKEW_START_RESP";
                    3: i_rx_msg_no_string_1 = "RXDESKEW_END_REQ";
                    4: i_rx_msg_no_string_1 = "RXDESKEW_END_RESP";
                endcase
            end
            DATATRAINCENTER2: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "DATATRAINCENTER2_START_REQ";
                    2: i_rx_msg_no_string_1 = "DATATRAINCENTER2_START_RESP";
                    3: i_rx_msg_no_string_1 = "DATATRAINCENTER2_END_REQ";
                    4: i_rx_msg_no_string_1 = "DATATRAINCENTER2_END_RESP";
                endcase
            end
            LINKSPEED: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "LINKSPEED_START_REQ";
                    2: i_rx_msg_no_string_1 = "LINKSPEED_START_RESP";
                    3: i_rx_msg_no_string_1 = "LINKSPEED_ERROR_REQ";
                    4: i_rx_msg_no_string_1 = "LINKSPEED_ERROR_RESP";
                    5: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                    6: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                    7: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                    8: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                    9: i_rx_msg_no_string_1 = "LINKSPEED_DONE_REQ";
                    10: i_rx_msg_no_string_1 = "LINKSPEED_DONE_RESP";
                    11: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                    12: i_rx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                endcase
            end
            REPAIR: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_1 = "REPAIR_INIT_REQ";
                    2: i_rx_msg_no_string_1 = "REPAIR_INIT_RESP";
                    3: i_rx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_REQ";
                    4: i_rx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_RESP";
                    5: i_rx_msg_no_string_1 = "REPAIR_END_REQ";
                    6: i_rx_msg_no_string_1 = "REPAIR_END_RESP";
                    7: i_rx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_REQ";
                    8: i_rx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    TRAINERROR_HS: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
            15: i_rx_msg_no_string_1 = "TRAINERROR_REQ";
            14: i_rx_msg_no_string_1 = "TRAINERROR_RESP";
        endcase
    end
    PHYRETRAIN: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.i_decoded_SB_msg)
            1: i_rx_msg_no_string_1 = "PHYRETRAIN_START_REQ";
            2: i_rx_msg_no_string_1 = "PHYRETRAIN_START_RESP";
        endcase
    end
endcase
end
end

always @ (*) begin
if (!LTSM_SB_MB_inst_1.tx_d2c_pt_en && !LTSM_SB_MB_inst_1.rx_d2c_pt_en) begin
o_tx_msg_no_string_1 = "UNKNOWN"; // Default case
case (CS_top_1)
    SBINIT: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
            3: o_tx_msg_no_string_1 = "SBINIT_OUT_OF_RESET_MSG";
            1: o_tx_msg_no_string_1 = "SBINIT_DONE_REQ_MSG";
            2: o_tx_msg_no_string_1 = "SBINIT_DONE_RESP_MSG";
        endcase
    end
    MBINIT: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_tx_sub_state)
            PARAM: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "PARAM_CONFIG_REQ";
                    2: o_tx_msg_no_string_1 = "PARAM_CONFIG_RESP";
                    3: o_tx_msg_no_string_1 = "PARAM_SBFE_REQ";
                    4: o_tx_msg_no_string_1 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "CAL_DONE_REQ";
                    2: o_tx_msg_no_string_1 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIRCLK_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRCLK_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRCLK_RESULT_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRCLK_RESULT_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRCLK_DONE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIRVAL_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRVAL_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRVAL_RESULT_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRVAL_RESULT_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRVAL_DONE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REVERSALMB_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REVERSALMB_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: o_tx_msg_no_string_1 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: o_tx_msg_no_string_1 = "REVERSALMB_RESULT_REQ";
                    6: o_tx_msg_no_string_1 = "REVERSALMB_RESULT_RESP";
                    7: o_tx_msg_no_string_1 = "REVERSALMB_DONE_REQ";
                    8: o_tx_msg_no_string_1 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIRMB_START_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIRMB_START_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIRMB_END_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIRMB_END_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    MBTRAIN: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_tx_sub_state)
            VALVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "VALVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "VALVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "VALVREF_END_REQ";
                    4: o_tx_msg_no_string_1 = "VALVREF_END_RESP";
                endcase
            end
            DATAVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATAVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATAVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATAVREF_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATAVREF_END_RESP";
                endcase
            end
            SPEEDIDLE: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "SPEEDIDLE_DONE_REQ";
                    2: o_tx_msg_no_string_1 = "SPEEDIDLE_DONE_RESP";
                endcase
            end
            TXSELFCAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "TXSELFCAL_DONE_REQ";
                    2: o_tx_msg_no_string_1 = "TXSELFCAL_DONE_RESP";
                endcase
            end
            RXCLKCAL: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "RXCLKCAL_START_REQ";
                    2: o_tx_msg_no_string_1 = "RXCLKCAL_START_RESP";
                    3: o_tx_msg_no_string_1 = "RXCLKCAL_DONE_REQ";
                    4: o_tx_msg_no_string_1 = "RXCLKCAL_DONE_RESP";
                endcase
            end
            VALTRAINCENTER: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "VALTRAINCENTER_START_REQ";
                    2: o_tx_msg_no_string_1 = "VALTRAINCENTER_START_RESP";
                    3: o_tx_msg_no_string_1 = "VALTRAINCENTER_DONE_REQ";
                    4: o_tx_msg_no_string_1 = "VALTRAINCENTER_DONE_RESP";
                endcase
            end
            VALTRAINVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "VALTRAINVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "VALTRAINVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "VALTRAINVREF_DONE_REQ";
                    4: o_tx_msg_no_string_1 = "VALTRAINVREF_DONE_RESP";
                endcase
            end
            DATATRAINCENTER1: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATATRAINCENTER1_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATATRAINCENTER1_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATATRAINCENTER1_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATATRAINCENTER1_END_RESP";
                endcase
            end
            DATATRAINVREF: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATATRAINVREF_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATATRAINVREF_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATATRAINVREF_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATATRAINVREF_END_RESP";
                endcase
            end
            RXDESKEW: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "RXDESKEW_START_REQ";
                    2: o_tx_msg_no_string_1 = "RXDESKEW_START_RESP";
                    3: o_tx_msg_no_string_1 = "RXDESKEW_END_REQ";
                    4: o_tx_msg_no_string_1 = "RXDESKEW_END_RESP";
                endcase
            end
            DATATRAINCENTER2: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "DATATRAINCENTER2_START_REQ";
                    2: o_tx_msg_no_string_1 = "DATATRAINCENTER2_START_RESP";
                    3: o_tx_msg_no_string_1 = "DATATRAINCENTER2_END_REQ";
                    4: o_tx_msg_no_string_1 = "DATATRAINCENTER2_END_RESP";
                endcase
            end
            LINKSPEED: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "LINKSPEED_START_REQ";
                    2: o_tx_msg_no_string_1 = "LINKSPEED_START_RESP";
                    3: o_tx_msg_no_string_1 = "LINKSPEED_ERROR_REQ";
                    4: o_tx_msg_no_string_1 = "LINKSPEED_ERROR_RESP";
                    5: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                    6: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                    7: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                    8: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                    9: o_tx_msg_no_string_1 = "LINKSPEED_DONE_REQ";
                    10: o_tx_msg_no_string_1 = "LINKSPEED_DONE_RESP";
                    11: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                    12: o_tx_msg_no_string_1 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                endcase
            end
            REPAIR: begin
                case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
                    1: o_tx_msg_no_string_1 = "REPAIR_INIT_REQ";
                    2: o_tx_msg_no_string_1 = "REPAIR_INIT_RESP";
                    3: o_tx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_REQ";
                    4: o_tx_msg_no_string_1 = "REPAIR_APPLY_REPAIR_RESP";
                    5: o_tx_msg_no_string_1 = "REPAIR_END_REQ";
                    6: o_tx_msg_no_string_1 = "REPAIR_END_RESP";
                    7: o_tx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_REQ";
                    8: o_tx_msg_no_string_1 = "REPAIR_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    TRAINERROR_HS: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
            15: o_tx_msg_no_string_1 = "TRAINERROR_REQ";
            14: o_tx_msg_no_string_1 = "TRAINERROR_RESP";
        endcase
    end
    PHYRETRAIN: begin
        case (LTSM_SB_MB_inst_1.LTSM_TOP_inst.o_encoded_SB_msg)
            1: o_tx_msg_no_string_1 = "PHYRETRAIN_START_REQ";
            2: o_tx_msg_no_string_1 = "PHYRETRAIN_START_RESP";
        endcase
    end
endcase
end
end

// partner
always @ (*) begin
if (!LTSM_SB_MB_inst_2.tx_d2c_pt_en && !LTSM_SB_MB_inst_2.rx_d2c_pt_en) begin
i_rx_msg_no_string_2 = "UNKNOWN"; // Default case
case (CS_top_2)
    SBINIT: begin
        case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
            3: i_rx_msg_no_string_2 = "SBINIT_OUT_OF_RESET_MSG";
            1: i_rx_msg_no_string_2 = "SBINIT_DONE_REQ_MSG";
            2: i_rx_msg_no_string_2 = "SBINIT_DONE_RESP_MSG";
        endcase
    end
    MBINIT: begin
        case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_tx_sub_state)
            PARAM: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "PARAM_CONFIG_REQ";
                    2: i_rx_msg_no_string_2 = "PARAM_CONFIG_RESP";
                    3: i_rx_msg_no_string_2 = "PARAM_SBFE_REQ";
                    4: i_rx_msg_no_string_2 = "PARAM_SBFE_RESP";
                endcase
            end
            CAL: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "CAL_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "CAL_DONE_RESP";
                endcase
            end
            REPAIRCLK: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRCLK_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRCLK_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRCLK_DONE_RESP";
                endcase
            end
            REPAIRVAL: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRVAL_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRVAL_RESULT_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRVAL_DONE_RESP"; 
                endcase
            end
            REVERSALMB: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REVERSALMB_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REVERSALMB_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_REQ";
                    4: i_rx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_RESP";
                    5: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_REQ";
                    6: i_rx_msg_no_string_2 = "REVERSALMB_RESULT_RESP";
                    7: i_rx_msg_no_string_2 = "REVERSALMB_DONE_REQ";
                    8: i_rx_msg_no_string_2 = "REVERSALMB_DONE_RESP";
                endcase
            end
            REPAIRMB: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIRMB_START_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIRMB_START_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIRMB_END_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIRMB_END_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    MBTRAIN: begin
        case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_tx_sub_state)
            VALVREF: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "VALVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "VALVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "VALVREF_END_REQ";
                    4: i_rx_msg_no_string_2 = "VALVREF_END_RESP";
                endcase
            end
            DATAVREF: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATAVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATAVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATAVREF_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATAVREF_END_RESP";
                endcase
            end
            SPEEDIDLE: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "SPEEDIDLE_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "SPEEDIDLE_DONE_RESP";
                endcase
            end
            TXSELFCAL: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "TXSELFCAL_DONE_REQ";
                    2: i_rx_msg_no_string_2 = "TXSELFCAL_DONE_RESP";
                endcase
            end
            RXCLKCAL: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "RXCLKCAL_START_REQ";
                    2: i_rx_msg_no_string_2 = "RXCLKCAL_START_RESP";
                    3: i_rx_msg_no_string_2 = "RXCLKCAL_DONE_REQ";
                    4: i_rx_msg_no_string_2 = "RXCLKCAL_DONE_RESP";
                endcase
            end
            VALTRAINCENTER: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "VALTRAINCENTER_START_REQ";
                    2: i_rx_msg_no_string_2 = "VALTRAINCENTER_START_RESP";
                    3: i_rx_msg_no_string_2 = "VALTRAINCENTER_DONE_REQ";
                    4: i_rx_msg_no_string_2 = "VALTRAINCENTER_DONE_RESP";
                endcase
            end
            VALTRAINVREF: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "VALTRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "VALTRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "VALTRAINVREF_DONE_REQ";
                    4: i_rx_msg_no_string_2 = "VALTRAINVREF_DONE_RESP";
                endcase
            end
            DATATRAINCENTER1: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATATRAINCENTER1_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATATRAINCENTER1_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATATRAINCENTER1_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATATRAINCENTER1_END_RESP";
                endcase
            end
            DATATRAINVREF: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATATRAINVREF_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATATRAINVREF_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATATRAINVREF_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATATRAINVREF_END_RESP";
                endcase
            end
            RXDESKEW: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "RXDESKEW_START_REQ";
                    2: i_rx_msg_no_string_2 = "RXDESKEW_START_RESP";
                    3: i_rx_msg_no_string_2 = "RXDESKEW_END_REQ";
                    4: i_rx_msg_no_string_2 = "RXDESKEW_END_RESP";
                endcase
            end
            DATATRAINCENTER2: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "DATATRAINCENTER2_START_REQ";
                    2: i_rx_msg_no_string_2 = "DATATRAINCENTER2_START_RESP";
                    3: i_rx_msg_no_string_2 = "DATATRAINCENTER2_END_REQ";
                    4: i_rx_msg_no_string_2 = "DATATRAINCENTER2_END_RESP";
                endcase
            end
            LINKSPEED: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "LINKSPEED_START_REQ";
                    2: i_rx_msg_no_string_2 = "LINKSPEED_START_RESP";
                    3: i_rx_msg_no_string_2 = "LINKSPEED_ERROR_REQ";
                    4: i_rx_msg_no_string_2 = "LINKSPEED_ERROR_RESP";
                    5: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                    6: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                    7: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                    8: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                    9: i_rx_msg_no_string_2 = "LINKSPEED_DONE_REQ";
                    10: i_rx_msg_no_string_2 = "LINKSPEED_DONE_RESP";
                    11: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                    12: i_rx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                endcase
            end
            REPAIR: begin
                case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
                    1: i_rx_msg_no_string_2 = "REPAIR_INIT_REQ";
                    2: i_rx_msg_no_string_2 = "REPAIR_INIT_RESP";
                    3: i_rx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_REQ";
                    4: i_rx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_RESP";
                    5: i_rx_msg_no_string_2 = "REPAIR_END_REQ";
                    6: i_rx_msg_no_string_2 = "REPAIR_END_RESP";
                    7: i_rx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_REQ";
                    8: i_rx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_RESP";
                endcase
            end
        endcase
    end
    TRAINERROR_HS: begin
        case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
            15: i_rx_msg_no_string_2 = "TRAINERROR_REQ";
            14: i_rx_msg_no_string_2 = "TRAINERROR_RESP";
        endcase
    end
    PHYRETRAIN: begin
        case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.i_decoded_SB_msg)
            1: i_rx_msg_no_string_2 = "PHYRETRAIN_START_REQ";
            2: i_rx_msg_no_string_2 = "PHYRETRAIN_START_RESP";
        endcase
    end
endcase
end
end

always @ (*) begin
if (!LTSM_SB_MB_inst_2.tx_d2c_pt_en && !LTSM_SB_MB_inst_2.rx_d2c_pt_en) begin
o_tx_msg_no_string_2 = "UNKNOWN"; // Default case
    case (CS_top_2)
        SBINIT: begin
            case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                3: o_tx_msg_no_string_2 = "SBINIT_OUT_OF_RESET_MSG";
                1: o_tx_msg_no_string_2 = "SBINIT_DONE_REQ_MSG";
                2: o_tx_msg_no_string_2 = "SBINIT_DONE_RESP_MSG";
            endcase
        end
        MBINIT: begin
            case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_tx_sub_state)
                PARAM: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "PARAM_CONFIG_REQ";
                        2: o_tx_msg_no_string_2 = "PARAM_CONFIG_RESP";
                        3: o_tx_msg_no_string_2 = "PARAM_SBFE_REQ";
                        4: o_tx_msg_no_string_2 = "PARAM_SBFE_RESP";
                    endcase
                end
                CAL: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "CAL_DONE_REQ";
                        2: o_tx_msg_no_string_2 = "CAL_DONE_RESP";
                    endcase
                end
                REPAIRCLK: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "REPAIRCLK_INIT_REQ";
                        2: o_tx_msg_no_string_2 = "REPAIRCLK_INIT_RESP";
                        3: o_tx_msg_no_string_2 = "REPAIRCLK_RESULT_REQ";
                        4: o_tx_msg_no_string_2 = "REPAIRCLK_RESULT_RESP";
                        5: o_tx_msg_no_string_2 = "REPAIRCLK_DONE_REQ";
                        6: o_tx_msg_no_string_2 = "REPAIRCLK_DONE_RESP";
                    endcase
                end
                REPAIRVAL: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "REPAIRVAL_INIT_REQ";
                        2: o_tx_msg_no_string_2 = "REPAIRVAL_INIT_RESP";
                        3: o_tx_msg_no_string_2 = "REPAIRVAL_RESULT_REQ";
                        4: o_tx_msg_no_string_2 = "REPAIRVAL_RESULT_RESP";
                        5: o_tx_msg_no_string_2 = "REPAIRVAL_DONE_REQ";
                        6: o_tx_msg_no_string_2 = "REPAIRVAL_DONE_RESP"; 
                    endcase
                end
                REVERSALMB: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "REVERSALMB_INIT_REQ";
                        2: o_tx_msg_no_string_2 = "REVERSALMB_INIT_RESP";
                        3: o_tx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_REQ";
                        4: o_tx_msg_no_string_2 = "REVERSALMB_CLEAR_ERROR_RESP";
                        5: o_tx_msg_no_string_2 = "REVERSALMB_RESULT_REQ";
                        6: o_tx_msg_no_string_2 = "REVERSALMB_RESULT_RESP";
                        7: o_tx_msg_no_string_2 = "REVERSALMB_DONE_REQ";
                        8: o_tx_msg_no_string_2 = "REVERSALMB_DONE_RESP";
                    endcase
                end
                REPAIRMB: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "REPAIRMB_START_REQ";
                        2: o_tx_msg_no_string_2 = "REPAIRMB_START_RESP";
                        3: o_tx_msg_no_string_2 = "REPAIRMB_END_REQ";
                        4: o_tx_msg_no_string_2 = "REPAIRMB_END_RESP";
                        5: o_tx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_REQ";
                        6: o_tx_msg_no_string_2 = "REPAIRMB_APPLY_DEGRADE_RESP";
                    endcase
                end
            endcase
        end
        MBTRAIN: begin
            case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_tx_sub_state)
                VALVREF: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "VALVREF_START_REQ";
                        2: o_tx_msg_no_string_2 = "VALVREF_START_RESP";
                        3: o_tx_msg_no_string_2 = "VALVREF_END_REQ";
                        4: o_tx_msg_no_string_2 = "VALVREF_END_RESP";
                    endcase
                end
                DATAVREF: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "DATAVREF_START_REQ";
                        2: o_tx_msg_no_string_2 = "DATAVREF_START_RESP";
                        3: o_tx_msg_no_string_2 = "DATAVREF_END_REQ";
                        4: o_tx_msg_no_string_2 = "DATAVREF_END_RESP";
                    endcase
                end
                SPEEDIDLE: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "SPEEDIDLE_DONE_REQ";
                        2: o_tx_msg_no_string_2 = "SPEEDIDLE_DONE_RESP";
                    endcase
                end
                TXSELFCAL: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "TXSELFCAL_DONE_REQ";
                        2: o_tx_msg_no_string_2 = "TXSELFCAL_DONE_RESP";
                    endcase
                end
                RXCLKCAL: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "RXCLKCAL_START_REQ";
                        2: o_tx_msg_no_string_2 = "RXCLKCAL_START_RESP";
                        3: o_tx_msg_no_string_2 = "RXCLKCAL_DONE_REQ";
                        4: o_tx_msg_no_string_2 = "RXCLKCAL_DONE_RESP";
                    endcase
                end
                VALTRAINCENTER: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "VALTRAINCENTER_START_REQ";
                        2: o_tx_msg_no_string_2 = "VALTRAINCENTER_START_RESP";
                        3: o_tx_msg_no_string_2 = "VALTRAINCENTER_DONE_REQ";
                        4: o_tx_msg_no_string_2 = "VALTRAINCENTER_DONE_RESP";
                    endcase
                end
                VALTRAINVREF: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "VALTRAINVREF_START_REQ";
                        2: o_tx_msg_no_string_2 = "VALTRAINVREF_START_RESP";
                        3: o_tx_msg_no_string_2 = "VALTRAINVREF_DONE_REQ";
                        4: o_tx_msg_no_string_2 = "VALTRAINVREF_DONE_RESP";
                    endcase
                end
                DATATRAINCENTER1: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "DATATRAINCENTER1_START_REQ";
                        2: o_tx_msg_no_string_2 = "DATATRAINCENTER1_START_RESP";
                        3: o_tx_msg_no_string_2 = "DATATRAINCENTER1_END_REQ";
                        4: o_tx_msg_no_string_2 = "DATATRAINCENTER1_END_RESP";
                    endcase
                end
                DATATRAINVREF: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "DATATRAINVREF_START_REQ";
                        2: o_tx_msg_no_string_2 = "DATATRAINVREF_START_RESP";
                        3: o_tx_msg_no_string_2 = "DATATRAINVREF_END_REQ";
                        4: o_tx_msg_no_string_2 = "DATATRAINVREF_END_RESP";
                    endcase
                end
                RXDESKEW: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "RXDESKEW_START_REQ";
                        2: o_tx_msg_no_string_2 = "RXDESKEW_START_RESP";
                        3: o_tx_msg_no_string_2 = "RXDESKEW_END_REQ";
                        4: o_tx_msg_no_string_2 = "RXDESKEW_END_RESP";
                    endcase
                end
                DATATRAINCENTER2: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "DATATRAINCENTER2_START_REQ";
                        2: o_tx_msg_no_string_2 = "DATATRAINCENTER2_START_RESP";
                        3: o_tx_msg_no_string_2 = "DATATRAINCENTER2_END_REQ";
                        4: o_tx_msg_no_string_2 = "DATATRAINCENTER2_END_RESP";
                    endcase
                end
                LINKSPEED: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "LINKSPEED_START_REQ";
                        2: o_tx_msg_no_string_2 = "LINKSPEED_START_RESP";
                        3: o_tx_msg_no_string_2 = "LINKSPEED_ERROR_REQ";
                        4: o_tx_msg_no_string_2 = "LINKSPEED_ERROR_RESP";
                        5: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_REQ";
                        6: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_REPAIR_RESP";
                        7: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
                        8: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
                        9: o_tx_msg_no_string_2 = "LINKSPEED_DONE_REQ";
                        10: o_tx_msg_no_string_2 = "LINKSPEED_DONE_RESP";
                        11: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
                        12: o_tx_msg_no_string_2 = "LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
                    endcase
                end
                REPAIR: begin
                    case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                        1: o_tx_msg_no_string_2 = "REPAIR_INIT_REQ";
                        2: o_tx_msg_no_string_2 = "REPAIR_INIT_RESP";
                        3: o_tx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_REQ";
                        4: o_tx_msg_no_string_2 = "REPAIR_APPLY_REPAIR_RESP";
                        5: o_tx_msg_no_string_2 = "REPAIR_END_REQ";
                        6: o_tx_msg_no_string_2 = "REPAIR_END_RESP";
                        7: o_tx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_REQ";
                        8: o_tx_msg_no_string_2 = "REPAIR_APPLY_DEGRADE_RESP";
                    endcase
                end
            endcase
        end
        TRAINERROR_HS: begin
            case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                15: o_tx_msg_no_string_2 = "TRAINERROR_REQ";
                14: o_tx_msg_no_string_2 = "TRAINERROR_RESP";
            endcase
        end
        PHYRETRAIN: begin
            case (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_encoded_SB_msg)
                1: o_tx_msg_no_string_2 = "PHYRETRAIN_START_REQ";
                2: o_tx_msg_no_string_2 = "PHYRETRAIN_START_RESP";
            endcase
        end
    endcase
end
end

always @ (*) begin
    if (LTSM_SB_MB_inst_1.tx_d2c_pt_en) begin
        case (LTSM_SB_MB_inst_1.sb_rx_msg_no)
            1: i_rx_msg_no_string_1 = "TX_D2C_PT_START_REQ";
            2: i_rx_msg_no_string_1 = "TX_D2C_PT_START_RESP";
            3: i_rx_msg_no_string_1 = "LFSR_CLEAR_ERROR_REQ";
            4: i_rx_msg_no_string_1 = "LFSR_CLEAR_ERROR_RESP";
            5: i_rx_msg_no_string_1 = "TX_D2C_PT_RESULT_REQ";
            6: i_rx_msg_no_string_1 = "TX_D2C_PT_RESULT_RESP";
            7: i_rx_msg_no_string_1 = "TX_D2C_PT_END_REQ";
            8: i_rx_msg_no_string_1 = "TX_D2C_PT_END_RESP";
            default: i_rx_msg_no_string_1 = "TX_D2C_PT_UNKOWN";
        endcase

        case (LTSM_SB_MB_inst_1.sb_tx_msg_no)
            1: o_tx_msg_no_string_1 = "TX_D2C_PT_START_REQ";
            2: o_tx_msg_no_string_1 = "TX_D2C_PT_START_RESP";
            3: o_tx_msg_no_string_1 = "LFSR_CLEAR_ERROR_REQ";
            4: o_tx_msg_no_string_1 = "LFSR_CLEAR_ERROR_RESP";
            5: o_tx_msg_no_string_1 = "TX_D2C_PT_RESULT_REQ";
            6: o_tx_msg_no_string_1 = "TX_D2C_PT_RESULT_RESP";
            7: o_tx_msg_no_string_1 = "TX_D2C_PT_END_REQ";
            8: o_tx_msg_no_string_1 = "TX_D2C_PT_END_RESP";
            default: o_tx_msg_no_string_1 = "TX_D2C_PT_UNKOWN";
        endcase
    end

    if (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_Transmitter_initiated_Data_to_CLK_en) begin
        case (LTSM_SB_MB_inst_2.sb_rx_msg_no)
            1: i_rx_msg_no_string_2 = "TX_D2C_PT_START_REQ";
            2: i_rx_msg_no_string_2 = "TX_D2C_PT_START_RESP";
            3: i_rx_msg_no_string_2 = "LFSR_CLEAR_ERROR_REQ";
            4: i_rx_msg_no_string_2 = "LFSR_CLEAR_ERROR_RESP";
            5: i_rx_msg_no_string_2 = "TX_D2C_PT_RESULT_REQ";
            6: i_rx_msg_no_string_2 = "TX_D2C_PT_RESULT_RESP";
            7: i_rx_msg_no_string_2 = "TX_D2C_PT_END_REQ";
            8: i_rx_msg_no_string_2 = "TX_D2C_PT_END_RESP";
            default: i_rx_msg_no_string_2 = "TX_D2C_PT_UNKOWN";
        endcase

        case (LTSM_SB_MB_inst_2.sb_tx_msg_no)
            1: o_tx_msg_no_string_2 = "TX_D2C_PT_START_REQ";
            2: o_tx_msg_no_string_2 = "TX_D2C_PT_START_RESP";
            3: o_tx_msg_no_string_2 = "LFSR_CLEAR_ERROR_REQ";
            4: o_tx_msg_no_string_2 = "LFSR_CLEAR_ERROR_RESP";
            5: o_tx_msg_no_string_2 = "TX_D2C_PT_RESULT_REQ";
            6: o_tx_msg_no_string_2 = "TX_D2C_PT_RESULT_RESP";
            7: o_tx_msg_no_string_2 = "TX_D2C_PT_END_REQ";
            8: o_tx_msg_no_string_2 = "TX_D2C_PT_END_RESP";
            default: o_tx_msg_no_string_2 = "TX_D2C_PT_UNKOWN";
        endcase
    end
end

always @ (*) begin
    if (LTSM_SB_MB_inst_1.rx_d2c_pt_en) begin
        case (LTSM_SB_MB_inst_1.sb_rx_msg_no)
            1: i_rx_msg_no_string_1 = "RX_D2C_PT_START_REQ";
            2: i_rx_msg_no_string_1 = "RX_D2C_PT_START_RESP";
            3: i_rx_msg_no_string_1 = "LFSR_CLEAR_ERROR_REQ";
            4: i_rx_msg_no_string_1 = "LFSR_CLEAR_ERROR_RESP";
            5: i_rx_msg_no_string_1 = "COUNT_DONE_REQ";
            6: i_rx_msg_no_string_1 = "COUNT_DONE_RESP";
            7: i_rx_msg_no_string_1 = "RX_D2C_PT_END_REQ";
            8: i_rx_msg_no_string_1 = "RX_D2C_PT_END_RESP";
            default: i_rx_msg_no_string_1 = "RX_D2C_PT_UNKOWN";
        endcase

        case (LTSM_SB_MB_inst_1.sb_tx_msg_no)
            1: o_tx_msg_no_string_1 = "RX_D2C_PT_START_REQ";
            2: o_tx_msg_no_string_1 = "RX_D2C_PT_START_RESP";
            3: o_tx_msg_no_string_1 = "LFSR_CLEAR_ERROR_REQ";
            4: o_tx_msg_no_string_1 = "LFSR_CLEAR_ERROR_RESP";
            5: o_tx_msg_no_string_1 = "COUNT_DONE_REQ";
            6: o_tx_msg_no_string_1 = "COUNT_DONE_RESP";
            7: o_tx_msg_no_string_1 = "RX_D2C_PT_END_REQ";
            8: o_tx_msg_no_string_1 = "RX_D2C_PT_END_RESP";
            default: o_tx_msg_no_string_1 = "RX_D2C_PT_UNKOWN";
        endcase
    end

    if (LTSM_SB_MB_inst_2.LTSM_TOP_inst.o_MBTRAIN_Receiver_initiated_Data_to_CLK_en) begin
        case (LTSM_SB_MB_inst_2.sb_rx_msg_no)
            1: i_rx_msg_no_string_2 = "RX_D2C_PT_START_REQ";
            2: i_rx_msg_no_string_2 = "RX_D2C_PT_START_RESP";
            3: i_rx_msg_no_string_2 = "LFSR_CLEAR_ERROR_REQ";
            4: i_rx_msg_no_string_2 = "LFSR_CLEAR_ERROR_RESP";
            5: i_rx_msg_no_string_2 = "COUNT_DONE_REQ";
            6: i_rx_msg_no_string_2 = "COUNT_DONE_RESP";
            7: i_rx_msg_no_string_2 = "RX_D2C_PT_END_REQ";
            8: i_rx_msg_no_string_2 = "RX_D2C_PT_END_RESP";
            default: i_rx_msg_no_string_2 = "RX_D2C_PT_UNKOWN";
        endcase

        case (LTSM_SB_MB_inst_2.sb_tx_msg_no)
            1: o_tx_msg_no_string_2 = "RX_D2C_PT_START_REQ";
            2: o_tx_msg_no_string_2 = "RX_D2C_PT_START_RESP";
            3: o_tx_msg_no_string_2 = "LFSR_CLEAR_ERROR_REQ";
            4: o_tx_msg_no_string_2 = "LFSR_CLEAR_ERROR_RESP";
            5: o_tx_msg_no_string_2 = "COUNT_DONE_REQ";
            6: o_tx_msg_no_string_2 = "COUNT_DONE_RESP";
            7: o_tx_msg_no_string_2 = "RX_D2C_PT_END_REQ";
            8: o_tx_msg_no_string_2 = "RX_D2C_PT_END_RESP";
            default: o_tx_msg_no_string_2 = "RX_D2C_PT_UNKOWN";
        endcase
    end
end



endmodule 