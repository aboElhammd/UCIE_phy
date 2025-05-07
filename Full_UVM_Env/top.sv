module top ();
import uvm_pkg::*;
import pack1::*;
bit i_clk , i_clk_sb , i_rst_n , i_ser_clk_4G;
bit clk_div_2;
/*------------------------------------------------------------------------------
--instantiations   
------------------------------------------------------------------------------*/
sideband_interface sb_intf(i_clk_sb);
MB_interface MB_intf(i_ser_clk_4G);  ///// IS THAT RIGHT ?
LTSM_SB_MB LTSM_SB_MB_inst_1 (
    
    /*************************************************************************
    * INPUTS
    *************************************************************************/

    ///////////////////////////////////////
    // clocks and resets 
    .i_pll_mb_clk                     (i_ser_clk_4G),
    .i_pll_sb_clk                  (i_clk_sb),
    .i_RCKP                     (MB_intf.i_CKP),
    .i_RCKN                     (MB_intf.i_CKN),
    .i_RTRACK                   (MB_intf.i_TRACK),
    .i_rst_n                   (i_rst_n),
    ///////////////////////////////////////

    ///////////////////////////////////////
    // RDI
    // .i_lp_data                 (i_lp_data_1),
    // .i_start_training_RDI      (i_start_training_RDI_1),
    ///////////////////////////////////////
   
    ///////////////////////////////////////
    // valid lane
    .i_RVLD_L                  (MB_intf.i_RVLD_L),
    .i_deser_valid_val         (MB_intf.i_deser_valid_val),
    ///////////////////////////////////////

    ///////////////////////////////////////
    // Main band data lanes
    .i_lfsr_rx_lane_0          (MB_intf.i_lfsr_rx_lane_0),
    .i_lfsr_rx_lane_1          (MB_intf.i_lfsr_rx_lane_1),
    .i_lfsr_rx_lane_2          (MB_intf.i_lfsr_rx_lane_2),
    .i_lfsr_rx_lane_3          (MB_intf.i_lfsr_rx_lane_3),
    .i_lfsr_rx_lane_4          (MB_intf.i_lfsr_rx_lane_4),
    .i_lfsr_rx_lane_5          (MB_intf.i_lfsr_rx_lane_5),
    .i_lfsr_rx_lane_6          (MB_intf.i_lfsr_rx_lane_6),
    .i_lfsr_rx_lane_7          (MB_intf.i_lfsr_rx_lane_7),
    .i_lfsr_rx_lane_8          (MB_intf.i_lfsr_rx_lane_8),
    .i_lfsr_rx_lane_9          (MB_intf.i_lfsr_rx_lane_9),
    .i_lfsr_rx_lane_10         (MB_intf.i_lfsr_rx_lane_10),
    .i_lfsr_rx_lane_11         (MB_intf.i_lfsr_rx_lane_11),
    .i_lfsr_rx_lane_12         (MB_intf.i_lfsr_rx_lane_12),
    .i_lfsr_rx_lane_13         (MB_intf.i_lfsr_rx_lane_13),
    .i_lfsr_rx_lane_14         (MB_intf.i_lfsr_rx_lane_14),
    .i_lfsr_rx_lane_15         (MB_intf.i_lfsr_rx_lane_15),
    .i_deser_valid_data        (MB_intf.i_deser_valid_data),
    ///////////////////////////////////////
    
    ///////////////////////////////////////
    // sideband
    .i_deser_data_sb           (sb_intf.deser_data),
    .i_deser_done_sb           (sb_intf.de_ser_done),
    ///////////////////////////////////////
    
    /*************************************************************************
    * OUTPUTS
    *************************************************************************/

    ///////////////////////////////////////
    // Clock lanes : CKP, CKN, TRACK
    .o_CKP                     (MB_intf.o_CKP),
    .o_CKN                     (MB_intf.o_CKN),
    .o_TRACK                   (MB_intf.o_TRACK),
    ///////////////////////////////////////

    ///////////////////////////////////////
    // valid lane
    .o_TVLD_L                  (MB_intf.o_TVLD_L),
    .o_serliazer_valid_en      (MB_intf.o_serliazer_valid_en),
    ///////////////////////////////////////
    
    ///////////////////////////////////////
    // Main band data lanes
    .o_lfsr_tx_lane_0          (MB_intf.o_lfsr_tx_lane_0),
    .o_lfsr_tx_lane_1          (MB_intf.o_lfsr_tx_lane_1),
    .o_lfsr_tx_lane_2          (MB_intf.o_lfsr_tx_lane_2),
    .o_lfsr_tx_lane_3          (MB_intf.o_lfsr_tx_lane_3),
    .o_lfsr_tx_lane_4          (MB_intf.o_lfsr_tx_lane_4),
    .o_lfsr_tx_lane_5          (MB_intf.o_lfsr_tx_lane_5),
    .o_lfsr_tx_lane_6          (MB_intf.o_lfsr_tx_lane_6),
    .o_lfsr_tx_lane_7          (MB_intf.o_lfsr_tx_lane_7),
    .o_lfsr_tx_lane_8          (MB_intf.o_lfsr_tx_lane_8),
    .o_lfsr_tx_lane_9          (MB_intf.o_lfsr_tx_lane_9),
    .o_lfsr_tx_lane_10         (MB_intf.o_lfsr_tx_lane_10),
    .o_lfsr_tx_lane_11         (MB_intf.o_lfsr_tx_lane_11),
    .o_lfsr_tx_lane_12         (MB_intf.o_lfsr_tx_lane_12),
    .o_lfsr_tx_lane_13         (MB_intf.o_lfsr_tx_lane_13),
    .o_lfsr_tx_lane_14         (MB_intf.o_lfsr_tx_lane_14),
    .o_lfsr_tx_lane_15         (MB_intf.o_lfsr_tx_lane_15),
    .o_serliazer_data_en       (MB_intf.o_serliazer_data_en),
    ///////////////////////////////////////
    
    ///////////////////////////////////////
    // RDI
    // .o_pl_data                 (o_pl_data_1),
    ///////////////////////////////////////
    
    ///////////////////////////////////////
    // sideband
    .o_deser_done_sampled_sb   (sb_intf.de_ser_done_sampled),
    // .o_ser_done_sampled_sb     (o_ser_done_sampled_sb_1),
    .o_pack_finished_sb        (sb_intf.pack_finished),
    .o_clk_ser_en_sb           (sb_intf.clk_ser_en),
    .o_SBCLK                   (sb_intf.TXCKSB),
    .o_sb_fifo_data            (sb_intf.fifo_data_out)
    ///////////////////////////////////////
    
    ///////////////////////////////////////
    // communicating with analog domain
    // .o_diff_or_quad_clk        (o_diff_or_quad_clk_1),
    // .o_reciever_ref_volatge    (o_reciever_ref_volatge_1),
    // .o_pi_step                 (o_pi_step_1)
    ///////////////////////////////////////
);

////////////////////////////////////
//////// CLOCK GENERATION /////////
//////////////////////////////////
 initial begin
    i_ser_clk_4G = 0;
    forever #125 i_ser_clk_4G = ~i_ser_clk_4G; // 0.25ns period = 4GHz
 end


initial begin
    i_clk_sb =  0;
    forever #625 i_clk_sb = ~ i_clk_sb; // 1.25ns period
end

// clock divider by 2
always @ (posedge i_ser_clk_4G or negedge i_rst_n) begin
    if (~i_rst_n) begin
        clk_div_2 <= 0;
    end else begin
        clk_div_2 <= ~clk_div_2;
    end
end

initial begin

    uvm_config_db#(virtual MB_interface)::set(null, "uvm_test_top", "my_MB_vif", MB_intf);
    uvm_config_db#(virtual sideband_interface)::set(null, "uvm_test_top", "my_SB_vif", sb_intf);
    fork
    //run_test("PHY_test");
    //run_test("linkspeed_speed_degrade_vs_done_test");
    // run_test("linkspeed_done_vs_speed_degrade_test");
    // run_test("linkspeed_done_vs_repair_test");
    // run_test("linkspeed_done_vs_phyretrain_test");  
    // run_test("linkspeed_repair_vs_done_test");
    // run_test("linkspeed_repair_vs_repair_test");
    // run_test("linkspeed_repair_vs_speed_degrade_test");
    // run_test("linkspeed_repair_vs_phyretrain_test");
    //run_test("linkspeed_speed_degrade_vs_repair_test");
    run_test("linkspeed_speed_degrade_vs_phyretrain_test");
    //run_test("linkspeed_speed_degrade_vs_speed_degrade_test");
    begin
        i_rst_n=0;
        #50
        i_rst_n=1;
    end
    join

end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////// FOR DEBUGGING ONLY ////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string sub_state_1, sub_state_2;
string i_rx_msg_no_string_1, i_rx_msg_no_string_2;
string o_tx_msg_no_string_1, o_tx_msg_no_string_2;
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


// module 
always @ (*) begin
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

always @ (*) begin
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

   
end

endmodule : top
