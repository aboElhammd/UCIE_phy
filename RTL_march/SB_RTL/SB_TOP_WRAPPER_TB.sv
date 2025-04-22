`timescale 1ns/1ps

import pkg::*;

module SB_TOP_WRAPPER_TB;

    // Clock and Reset (shared between Module and Partner)
    reg               i_clk;
    reg               i_rst_n;

    // Signals for Module instance
    reg               module_start_pattern_req;
    reg               module_rdi_msg;
    reg               module_data_valid;
    reg               module_msg_valid;
    reg       [2:0]   module_state;
    reg       [3:0]   module_sub_state;
    reg       [3:0]   module_msg_no;
    reg       [2:0]   module_msg_info;
    reg       [15:0]  module_data_bus;
    reg               module_ser_done;
    reg               module_stop_cnt;
    reg               module_tx_point_sweep_test_en;
    reg       [1:0]   module_tx_point_sweep_test;
    reg       [1:0]   module_rdi_msg_code;
    reg       [3:0]   module_rdi_msg_sub_code;
    reg       [1:0]   module_rdi_msg_info;
    reg               module_de_ser_done;
    reg       [63:0]  module_deser_data;

    wire              module_start_pattern_done;
    wire              module_time_out;
    wire      [63:0]  module_tx_data_out;
    wire              module_busy;
    wire              module_rx_sb_start_pattern;
    wire              module_rdi_msg_out;
    wire              module_msg_valid_out;
    wire              module_parity_error;
    wire              module_adapter_enable;
    wire      [1:0]   module_tx_point_sweep_test_out;
    wire      [3:0]   module_msg_no_out;
    wire      [2:0]   module_msg_info_out;
    wire      [15:0]  module_data_out;
    wire      [1:0]   module_rdi_msg_code_out;
    wire      [3:0]   module_rdi_msg_sub_code_out;
    wire      [1:0]   module_rdi_msg_info_out;

    // Signals for Partner instance
    reg               partner_start_pattern_req;
    reg               partner_rdi_msg;
    reg               partner_data_valid;
    reg               partner_msg_valid;
    reg       [2:0]   partner_state;
    reg       [3:0]   partner_sub_state;
    reg       [3:0]   partner_msg_no;
    reg       [2:0]   partner_msg_info;
    reg       [15:0]  partner_data_bus;
    reg               partner_ser_done;
    reg               partner_stop_cnt;
    reg               partner_tx_point_sweep_test_en;
    reg       [1:0]   partner_tx_point_sweep_test;
    reg       [1:0]   partner_rdi_msg_code;
    reg       [3:0]   partner_rdi_msg_sub_code;
    reg       [1:0]   partner_rdi_msg_info;
    reg               partner_de_ser_done;
    reg       [63:0]  partner_deser_data;

    wire              partner_start_pattern_done;
    wire              partner_time_out;
    wire      [63:0]  partner_tx_data_out;
    wire              partner_busy;
    wire              partner_rx_sb_start_pattern;
    wire              partner_rdi_msg_out;
    wire              partner_msg_valid_out;
    wire              partner_parity_error;
    wire              partner_adapter_enable;
    wire      [1:0]   partner_tx_point_sweep_test_out;
    wire      [3:0]   partner_msg_no_out;
    wire      [2:0]   partner_msg_info_out;
    wire      [15:0]  partner_data_out;
    wire      [1:0]   partner_rdi_msg_code_out;
    wire      [3:0]   partner_rdi_msg_sub_code_out;
    wire      [1:0]   partner_rdi_msg_info_out;

    logic [63:0] TX_module_data, RX_module_data, TX_partner_data, RX_partner_data;

    int err_cnt = 0;
    int crrct_cnt = 0;

    reg module_busy_reg, partner_busy_reg;
    wire falling_edge_busy_module = (module_busy_reg != Module.o_busy) && !Module.o_busy;
    wire falling_edge_busy_partner = (partner_busy_reg != Partner.o_busy) && !Partner.o_busy;

    // Instantiate the Module
    SB_TOP_WRAPPER Module (
        .i_clk                    (i_clk),
        .i_rst_n                  (i_rst_n),
        .i_start_pattern_req      (module_start_pattern_req),
        .i_rdi_msg                (module_rdi_msg),
        .i_data_valid             (module_data_valid),
        .i_msg_valid              (module_msg_valid),
        .i_state                  (module_state),
        .i_sub_state              (module_sub_state),
        .i_msg_no                 (module_msg_no),
        .i_msg_info               (module_msg_info),
        .i_data_bus               (module_data_bus),
        .i_ser_done               (module_ser_done),
        .i_stop_cnt               (module_stop_cnt),
        .i_tx_point_sweep_test_en (module_tx_point_sweep_test_en),
        .i_tx_point_sweep_test    (module_tx_point_sweep_test),
        .i_rdi_msg_code           (module_rdi_msg_code),
        .i_rdi_msg_sub_code       (module_rdi_msg_sub_code),
        .i_rdi_msg_info           (module_rdi_msg_info),
        .i_de_ser_done            (module_de_ser_done),
        .i_deser_data             (RX_partner_data),
        .o_start_pattern_done     (module_start_pattern_done),
        .o_time_out              (module_time_out),
        .o_tx_data_out           (TX_module_data),
        .o_busy                  (module_busy),
        .o_rx_sb_start_pattern    (module_rx_sb_start_pattern),
        .o_rdi_msg                (module_rdi_msg_out),
        .o_msg_valid              (module_msg_valid_out),
        .o_parity_error           (module_parity_error),
        .o_adapter_enable         (module_adapter_enable),
        .o_tx_point_sweep_test    (module_tx_point_sweep_test_out),
        .o_msg_no                (module_msg_no_out),
        .o_msg_info              (module_msg_info_out),
        .o_data                  (module_data_out),
        .o_rdi_msg_code          (module_rdi_msg_code_out),
        .o_rdi_msg_sub_code      (module_rdi_msg_sub_code_out),
        .o_rdi_msg_info          (module_rdi_msg_info_out)
    );

    // Instantiate the Partner
    SB_TOP_WRAPPER Partner (
        .i_clk                    (i_clk),
        .i_rst_n                  (i_rst_n),
        .i_start_pattern_req      (partner_start_pattern_req),
        .i_rdi_msg                (partner_rdi_msg),
        .i_data_valid             (partner_data_valid),
        .i_msg_valid              (partner_msg_valid),
        .i_state                  (partner_state),
        .i_sub_state              (partner_sub_state),
        .i_msg_no                 (partner_msg_no),
        .i_msg_info               (partner_msg_info),
        .i_data_bus               (partner_data_bus),
        .i_ser_done               (partner_ser_done),
        .i_stop_cnt               (partner_stop_cnt),
        .i_tx_point_sweep_test_en (partner_tx_point_sweep_test_en),
        .i_tx_point_sweep_test    (partner_tx_point_sweep_test),
        .i_rdi_msg_code           (partner_rdi_msg_code),
        .i_rdi_msg_sub_code       (partner_rdi_msg_sub_code),
        .i_rdi_msg_info           (partner_rdi_msg_info),
        .i_de_ser_done            (partner_de_ser_done),
        .i_deser_data             (RX_module_data),
        .o_start_pattern_done     (partner_start_pattern_done),
        .o_time_out               (partner_time_out),
        .o_tx_data_out            (TX_partner_data),
        .o_busy                   (partner_busy),
        .o_rx_sb_start_pattern    (partner_rx_sb_start_pattern),
        .o_rdi_msg                (partner_rdi_msg_out),
        .o_msg_valid              (partner_msg_valid_out),
        .o_parity_error           (partner_parity_error),
        .o_adapter_enable         (partner_adapter_enable),
        .o_tx_point_sweep_test    (partner_tx_point_sweep_test_out),
        .o_msg_no                 (partner_msg_no_out),
        .o_msg_info               (partner_msg_info_out),
        .o_data                   (partner_data_out),
        .o_rdi_msg_code           (partner_rdi_msg_code_out),
        .o_rdi_msg_sub_code       (partner_rdi_msg_sub_code_out),
        .o_rdi_msg_info           (partner_rdi_msg_info_out)
    );

    typedef struct {
        logic [3:0]     msg_no;
        logic [2:0]     msg_info;
        logic [15:0]    msg_data;
        logic           data_valid;
    } packet_t;

    packet_t TX_PKT;


    // Clock generation
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk; // 100 MHz clock
    end

    // Reset generation
    initial begin
        // Initialize logics
        init();

        // Reset 
        rst();

        //Pattern generation stage
        pattern_gen();

        //Messages Handshake stage
        Drive_in_module();

        repeat(100) @(posedge i_clk);

        $display("ERROR COUNT %0d",err_cnt);
        $display("CORRECT COUNT %0d",crrct_cnt);

        $stop;

    end

    task init();
        // Initialize all inputs for Module
        module_start_pattern_req = 0;
        module_rdi_msg = 0;
        module_data_valid = 0;
        module_msg_valid = 0;
        module_state = 0;
        module_sub_state = 0;
        module_msg_no = 0;
        module_msg_info = 0;
        module_data_bus = 0;
        module_ser_done = 1;
        module_stop_cnt = 0;
        module_tx_point_sweep_test_en = 0;
        module_tx_point_sweep_test = 0;
        module_rdi_msg_code = 0;
        module_rdi_msg_sub_code = 0;
        module_rdi_msg_info = 0;
        module_de_ser_done = 0;
        module_deser_data = 0;

        // Initialize all inputs for Partner
        partner_start_pattern_req = 0;
        partner_rdi_msg = 0;
        partner_data_valid = 0;
        partner_msg_valid = 0;
        partner_state = 0;
        partner_sub_state = 0;
        partner_msg_no = 0;
        partner_msg_info = 0;
        partner_data_bus = 0;
        partner_ser_done = 1;
        partner_stop_cnt = 0;
        partner_tx_point_sweep_test_en = 0;
        partner_tx_point_sweep_test = 0;
        partner_rdi_msg_code = 0;
        partner_rdi_msg_sub_code = 0;
        partner_rdi_msg_info = 0;
        partner_de_ser_done = 0;
        partner_deser_data = 0;
    endtask : init

    task rst();
        i_rst_n = 0;
        repeat (10) @(negedge i_clk);
        i_rst_n = 1;
    endtask : rst

    task pattern_gen();
        module_state = 1; // SBINIT
        partner_state = 0; // RESET

        // Start pattern request for Module
        module_start_pattern_req = 1;
        @(posedge i_clk)
        module_start_pattern_req = 0;

        // Test Pattern Detection for Partner
        wait (partner_rx_sb_start_pattern);
        partner_start_pattern_req = 1;
        @(posedge i_clk);
        partner_start_pattern_req = 0;
        repeat(20) @(posedge i_clk);
    endtask : pattern_gen

    task Drive_in_module();
        GenStates_DRV = GenStates_DRV.first();
        for (int i = 0; i < GenStates_DRV.num(); i++) begin
            module_state = GenStates_DRV;
            $display("////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
            $display("/////////////////////////////////////////////// %s  ", GenStates_DRV, "/////////////////////////////////////////////");
            $display("////////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
            case (GenStates_DRV)
                SBINIT      : begin
                    SBINIT_MSGs = SBINIT_MSGs.last();
                    for (int i = 0; i < SBINIT_MSGs.num(); i++) begin
                        $display("i_msg_no: %s", SBINIT_MSGs);
                        pkt_construct();
                        pkt_drive();
                        @(posedge partner_msg_valid_out);
                        pkt_check();
                        SBINIT_MSGs = SBINIT_MSGs.next();                           
                    end
                end

                MBINIT      : begin
                    MBINIT_SubStates_DRV        = MBINIT_SubStates_DRV.first();
                    for (int i = 0; i < MBINIT_SubStates_DRV.num(); i++) begin
                        $display("///////////////////////////////////////////////////////////////////////////////");
                        $display("/////////////////////// %s ", MBINIT_SubStates_DRV, "//////////////////////////");
                        $display("///////////////////////////////////////////////////////////////////////////////");
                        module_sub_state = MBINIT_SubStates_DRV;
                        case (MBINIT_SubStates_DRV)
                            PARAM: 
                                begin
                                    MBINIT_PARAM_MSGs = MBINIT_PARAM_MSGs.first();
                                    for (int i = 0; i < MBINIT_PARAM_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBINIT_PARAM_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBINIT_PARAM_MSGs = MBINIT_PARAM_MSGs.next();                           
                                    end
                                end
                            
                            CAL: 
                                begin
                                    MBINIT_CAL_MSGs = MBINIT_CAL_MSGs.first();
                                    for (int i = 0; i < MBINIT_CAL_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBINIT_CAL_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBINIT_CAL_MSGs = MBINIT_CAL_MSGs.next();
                                    end
                            end

                            REPAIRCLK: 
                                begin
                                    MBINIT_REPAIRCLK_MSGs = MBINIT_REPAIRCLK_MSGs.first();
                                    for (int i = 0; i < MBINIT_REPAIRCLK_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBINIT_REPAIRCLK_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBINIT_REPAIRCLK_MSGs = MBINIT_REPAIRCLK_MSGs.next();
                                    end
                                end
                            
                            REPAIRVAL: 
                                begin
                                    MBINIT_REPAIRVAL_MSGs = MBINIT_REPAIRVAL_MSGs.first();
                                    for (int i = 0; i < MBINIT_REPAIRVAL_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBINIT_REPAIRVAL_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBINIT_REPAIRVAL_MSGs = MBINIT_REPAIRVAL_MSGs.next();
                                    end
                            end

                            REVERSALMB: 
                                begin
                                    MBINIT_REVERSALMB_MSGs = MBINIT_REVERSALMB_MSGs.first();
                                    for (int i = 0; i < MBINIT_REVERSALMB_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBINIT_REVERSALMB_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBINIT_REVERSALMB_MSGs = MBINIT_REVERSALMB_MSGs.next();
                                    end
                                end
                            
                            REPAIRMB: 
                                begin
                                    MBINIT_REPAIRMB_MSGs = MBINIT_REPAIRMB_MSGs.first();
                                    for (int i = 0; i < MBINIT_REPAIRMB_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBINIT_REPAIRMB_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBINIT_REPAIRMB_MSGs = MBINIT_REPAIRMB_MSGs.next();
                                    end
                            end
                        endcase
                        MBINIT_SubStates_DRV = MBINIT_SubStates_DRV.next();
                    end 
                end

                MBTRAIN     : begin
                    MBTRAIN_SubStates_DRV       = MBTRAIN_SubStates_DRV.first();
                    for (int i = 0; i < MBTRAIN_SubStates_DRV.num(); i++) begin
                        $display("////////////////////////////////////////////////////////////////////////////////");
                        $display("/////////////////////// %s ", MBTRAIN_SubStates_DRV, "//////////////////////////");
                        $display("////////////////////////////////////////////////////////////////////////////////");
                        module_sub_state = MBTRAIN_SubStates_DRV;
                        case (MBTRAIN_SubStates_DRV)
                            VALREF          : 
                                begin
                                    MBTRAIN_VALVREF_MSGs = MBTRAIN_VALVREF_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_VALVREF_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_VALVREF_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_VALVREF_MSGs = MBTRAIN_VALVREF_MSGs.next();                     
                                    end
                                end
                            
                            DATAVREF        : 
                                begin
                                    MBTRAIN_DATAVREF_MSGs = MBTRAIN_DATAVREF_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_DATAVREF_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_DATAVREF_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_DATAVREF_MSGs = MBTRAIN_DATAVREF_MSGs.next();
                                    end
                                end

                            SPEEDIDLE       : 
                                begin
                                    MBTRAIN_SPEEDIDLE_MSGs = MBTRAIN_SPEEDIDLE_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_SPEEDIDLE_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_SPEEDIDLE_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_SPEEDIDLE_MSGs = MBTRAIN_SPEEDIDLE_MSGs.next();
                                    end
                                end
                            
                            TXSELFCAL       : 
                                begin
                                    MBTRAIN_TXSELFCAL_MSGs = MBTRAIN_TXSELFCAL_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_TXSELFCAL_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_TXSELFCAL_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_TXSELFCAL_MSGs = MBTRAIN_TXSELFCAL_MSGs.next();
                                    end
                            end

                            RXCLKCAL        : 
                                begin
                                    MBTRAIN_RXCLKCAL_MSGs = MBTRAIN_RXCLKCAL_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_RXCLKCAL_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_RXCLKCAL_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_RXCLKCAL_MSGs = MBTRAIN_RXCLKCAL_MSGs.next();
                                    end
                                end
                            
                            VALTRAINCENTER  : 
                                begin
                                    MBTRAIN_VALTRAINCENTER_MSGs = MBTRAIN_VALTRAINCENTER_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_VALTRAINCENTER_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_VALTRAINCENTER_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_VALTRAINCENTER_MSGs = MBTRAIN_VALTRAINCENTER_MSGs.next();
                                    end
                            end

                            VALTRAINVREF    : 
                                begin
                                    MBTRAIN_VALTRAINVREF_MSGs = MBTRAIN_VALTRAINVREF_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_VALTRAINVREF_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_VALTRAINVREF_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_VALTRAINVREF_MSGs = MBTRAIN_VALTRAINVREF_MSGs.next();
                                    end
                            end

                            DATATRAINCENTER1 : 
                                begin
                                    MBTRAIN_DATATRAINCENTER1_MSGs = MBTRAIN_DATATRAINCENTER1_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_DATATRAINCENTER1_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_DATATRAINCENTER1_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_DATATRAINCENTER1_MSGs = MBTRAIN_DATATRAINCENTER1_MSGs.next();
                                    end
                            end

                            DATATRAINVREF   : 
                                begin
                                    MBTRAIN_DATATRAINVREF_MSGs = MBTRAIN_DATATRAINVREF_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_DATATRAINVREF_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_DATATRAINVREF_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_DATATRAINVREF_MSGs = MBTRAIN_DATATRAINVREF_MSGs.next();
                                    end
                            end

                            RXDESKEW        : 
                                begin
                                    MBTRAIN_RXDESKEW_MSGs = MBTRAIN_RXDESKEW_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_RXDESKEW_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_RXDESKEW_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_RXDESKEW_MSGs = MBTRAIN_RXDESKEW_MSGs.next();
                                    end
                            end

                            DATATRAINCENTER2 : 
                                begin
                                    MBTRAIN_DATATRAINCENTER2_MSGs = MBTRAIN_DATATRAINCENTER2_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_DATATRAINCENTER2_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_DATATRAINCENTER2_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_DATATRAINCENTER2_MSGs = MBTRAIN_DATATRAINCENTER2_MSGs.next();
                                    end
                            end

                            LINKSPEED       : 
                                begin
                                    MBTRAIN_LINKSPEED_MSGs = MBTRAIN_LINKSPEED_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_LINKSPEED_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_LINKSPEED_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_LINKSPEED_MSGs = MBTRAIN_LINKSPEED_MSGs.next();
                                    end
                            end

                            REPAIR          : 
                                begin
                                    MBTRAIN_REPAIR_MSGs = MBTRAIN_REPAIR_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_REPAIR_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_REPAIR_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_msg_valid_out);
                                        pkt_check();
                                        MBTRAIN_REPAIR_MSGs = MBTRAIN_REPAIR_MSGs.next();
                                    end
                            end
                        endcase
                        MBTRAIN_SubStates_DRV = MBTRAIN_SubStates_DRV.next();
                    end 
                end

                PHYRETRAIN  : begin
                    PHYRETRAIN_MSGs = PHYRETRAIN_MSGs.first();
                    for (int i = 0; i < PHYRETRAIN_MSGs.num(); i++) begin
                        $display("i_msg_no: %s", PHYRETRAIN_MSGs);
                        pkt_construct();
                        pkt_drive();
                        @(posedge partner_msg_valid_out);
                        pkt_check();
                        PHYRETRAIN_MSGs = PHYRETRAIN_MSGs.next();                       
                    end
                end
            endcase
            GenStates_DRV = GenStates_DRV.next();
        end
    endtask : Drive_in_module

    task pkt_construct();
        case (GenStates_DRV) 
            SBINIT  : begin
                case (SBINIT_MSGs)
                    SBINIT_OUT_OF_RESET : begin
                        TX_PKT.msg_no       = 3;
                        TX_PKT.msg_info     = 0;
                        TX_PKT.msg_data     = 0;
                        TX_PKT.data_valid   = 0;
                    end
                    SBINIT_DONE_REQ     : begin
                        TX_PKT.msg_no       = 1;
                        TX_PKT.msg_info     = 0;
                        TX_PKT.msg_data     = 0;
                        TX_PKT.data_valid   = 0;
                    end
                    SBINIT_DONE_RESP    : begin
                        TX_PKT.msg_no       = 2;
                        TX_PKT.msg_info     = 0;
                        TX_PKT.msg_data     = 0;
                        TX_PKT.data_valid   = 0;
                    end 
                endcase
            end

            MBINIT  : begin
                case (MBINIT_SubStates_DRV)
                    PARAM       : begin
                        case (MBINIT_PARAM_MSGs) 
                            MBINIT_PARAM_CONFIGURATION_REQ  : begin 
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 3;
                                TX_PKT.data_valid   = 1;
                            end
                            MBINIT_PARAM_CONFIGURATION_RESP : begin 
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 3;
                                TX_PKT.data_valid   = 1;
                            end                      
                        endcase
                    end
                    CAL         : begin
                        case (MBINIT_CAL_MSGs) 
                            MBINIT_CAL_DONE_REQ     : begin 
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_CAL_DONE_RESP    : begin 
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                      
                        endcase
                    end
                    REPAIRCLK   : begin
                        case (MBINIT_REPAIRCLK_MSGs) 
                            MBINIT_REPAIRCLK_INIT_REQ       : begin 
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRCLK_INIT_RESP      : begin 
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRCLK_RESULT_REQ     : begin 
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRCLK_RESULT_RESP    : begin 
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 3;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRCLK_DONE_REQ       : begin 
                                TX_PKT.msg_no       = 5;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRCLK_DONE_RESP      : begin 
                                TX_PKT.msg_no       = 6;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                         
                        endcase
                    end
                    REPAIRVAL   : begin
                        case (MBINIT_REPAIRVAL_MSGs) 
                            MBINIT_REPAIRVAL_INIT_REQ       : begin 
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRVAL_INIT_RESP      : begin 
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBINIT_REPAIRVAL_RESULT_REQ     : begin 
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRVAL_RESULT_RESP    : begin 
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 1;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRVAL_DONE_REQ       : begin 
                                TX_PKT.msg_no       = 5;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRVAL_DONE_RESP      : begin 
                                TX_PKT.msg_no       = 6;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                         
                        endcase
                    end
                    REVERSALMB  : begin
                        case (MBINIT_REVERSALMB_MSGs) 
                            MBINIT_REVERSALMB_INIT_REQ          : begin 
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REVERSALMB_INIT_RESP         : begin 
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REVERSALMB_CLEAR_ERROR_REQ   : begin 
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REVERSALMB_CLEAR_ERROR_RESP  : begin 
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REVERSALMB_RESULT_REQ        : begin 
                                TX_PKT.msg_no       = 5;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REVERSALMB_RESULT_RESP       : begin 
                                TX_PKT.msg_no       = 6;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REVERSALMB_DONE_REQ          : begin 
                                TX_PKT.msg_no       = 7;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REVERSALMB_DONE_RESP         : begin 
                                TX_PKT.msg_no       = 8;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                        
                        endcase
                    end
                    REPAIRMB    : begin
                        case (MBINIT_REPAIRMB_MSGs) 
                            MBINIT_REPAIRMB_START_REQ           : begin 
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRMB_START_RESP          : begin 
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRMB_END_REQ             : begin 
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRMB_END_RESP            : begin 
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRMB_APPLY_DEGRADE_REQ   : begin 
                                TX_PKT.msg_no       = 5;
                                TX_PKT.msg_info     = 3;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBINIT_REPAIRMB_APPLY_DEGRADE_RESP  : begin 
                                TX_PKT.msg_no       = 6;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                         
                        endcase
                    end
                endcase
            end

            MBTRAIN     : begin
                case (MBTRAIN_SubStates_DRV)
                    VALREF  : begin
                        case (MBTRAIN_VALVREF_MSGs) 
                            MBTRAIN_VALVREF_START_REQ   : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_VALVREF_START_RESP  : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_VALVREF_END_REQ     : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_VALVREF_END_RESP    : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase
                    end
                            
                    DATAVREF         : begin
                        case (MBTRAIN_DATAVREF_MSGs) 
                            MBTRAIN_DATAVREF_START_REQ  : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATAVREF_START_RESP : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_DATAVREF_END_REQ    : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATAVREF_END_RESP   : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase
                    end

                    SPEEDIDLE        : begin
                        case (MBTRAIN_SPEEDIDLE_MSGs) 
                            MBTRAIN_TXSELFCAL_DONE_REQ  : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_TXSELFCAL_DONE_RESP : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                         
                        endcase 
                    end
                            
                    TXSELFCAL        : begin
                        case (MBTRAIN_TXSELFCAL_MSGs) 
                            MBTRAIN_SPEEDIDLE_DONE_REQ  : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_SPEEDIDLE_DONE_RESP : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                         
                        endcase         
                    end

                    RXCLKCAL         : begin
                        case (MBTRAIN_RXCLKCAL_MSGs) 
                            MBTRAIN_RXCLKCAL_START_REQ  : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_RXCLKCAL_START_RESP : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_RXCLKCAL_DONE_REQ   : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_RXCLKCAL_DONE_RESP  : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase 
                    end
                            
                    VALTRAINCENTER   : begin
                        case (MBTRAIN_VALTRAINCENTER_MSGs) 
                            MBTRAIN_VALTRAINCENTER_START_REQ    : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_VALTRAINCENTER_START_RESP   : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_VALTRAINCENTER_DONE_REQ     : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_VALTRAINCENTER_DONE_RESP    : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase         
                    end

                    VALTRAINVREF     : begin
                        case (MBTRAIN_VALTRAINVREF_MSGs) 
                            MBTRAIN_VALTRAINVREF_START_REQ  : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_VALTRAINVREF_START_RESP : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_VALTRAINVREF_DONE_REQ   : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_VALTRAINVREF_DONE_RESP  : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase     
                    end

                    DATATRAINCENTER1 : begin
                        case (MBTRAIN_DATATRAINCENTER1_MSGs) 
                            MBTRAIN_DATATRAINCENTER1_START_REQ  : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATATRAINCENTER1_START_RESP : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_DATATRAINCENTER1_END_REQ    : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATATRAINCENTER1_END_RESP   : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase 
                    end

                    DATATRAINVREF    : begin
                        case (MBTRAIN_DATATRAINVREF_MSGs) 
                            MBTRAIN_DATATRAINVREF_START_REQ     : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATATRAINVREF_START_RESP    : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_DATATRAINVREF_END_REQ       : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATATRAINVREF_END_RESP      : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase 
                    end

                    RXDESKEW         : begin
                        case (MBTRAIN_RXDESKEW_MSGs) 
                            MBTRAIN_RXDESKEW_START_REQ      : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_RXDESKEW_START_RESP     : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_RXDESKEW_END_REQ        : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_RXDESKEW_END_RESP       : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase 
                    end

                    DATATRAINCENTER2 : begin
                        case (MBTRAIN_DATATRAINCENTER2_MSGs) 
                            MBTRAIN_DATATRAINCENTER2_START_REQ  : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATATRAINCENTER2_START_RESP : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_DATATRAINCENTER2_END_REQ    : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_DATATRAINCENTER2_END_RESP   : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase
                    end

                    LINKSPEED        : begin
                        case (MBTRAIN_LINKSPEED_MSGs) 
                            MBTRAIN_LINKSPEED_START_REQ                 : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_LINKSPEED_START_RESP                : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_LINKSPEED_ERROR_REQ                 : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_LINKSPEED_ERROR_RESP                : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_REQ        : begin
                                TX_PKT.msg_no       = 5;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_RESP       : begin
                                TX_PKT.msg_no       = 6;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEDRADE_REQ : begin
                                TX_PKT.msg_no       = 7;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEDRADE_RESP: begin
                                TX_PKT.msg_no       = 8;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_LINKSPEED_DONE_REQ                  : begin
                                TX_PKT.msg_no       = 9;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_LINKSPEED_DONE_RESP                 : begin
                                TX_PKT.msg_no       = 10;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            /*MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ     : begin
                                TX_PKT.msg_no       = 11;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP  : begin
                                TX_PKT.msg_no       = 12;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end*/                       
                        endcase 
                    end

                    REPAIR          : begin
                        case (MBTRAIN_REPAIR_MSGs) 
                            MBTRAIN_REPAIR_INIT_REQ             : begin
                                TX_PKT.msg_no       = 1;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_REPAIR_INIT_RESP            : begin
                                TX_PKT.msg_no       = 2;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_REPAIR_APPLY_REPAIR_REQ     : begin
                                TX_PKT.msg_no       = 3;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_REPAIR_APPLY_REPAIR_RESP    : begin
                                TX_PKT.msg_no       = 4;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_REPAIR_END_REQ              : begin
                                TX_PKT.msg_no       = 5;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_REPAIR_END_RESP             : begin
                                TX_PKT.msg_no       = 6;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end 
                            MBTRAIN_REPAIR_APPLY_DEGRADE_REQ    : begin
                                TX_PKT.msg_no       = 7;
                                TX_PKT.msg_info     = 3;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end
                            MBTRAIN_REPAIR_APPLY_DEGRADE_RESP   : begin
                                TX_PKT.msg_no       = 8;
                                TX_PKT.msg_info     = 0;
                                TX_PKT.msg_data     = 0;
                                TX_PKT.data_valid   = 0;
                            end                     
                        endcase             
                    end
                endcase
            end

            PHYRETRAIN  : begin
                case (PHYRETRAIN_MSGs)
                    PHYRETRAIN_RETRAIN_START_REQ    : begin
                        TX_PKT.msg_no       = 1;
                        TX_PKT.msg_info     = 3;
                        TX_PKT.msg_data     = 0;
                        TX_PKT.data_valid   = 0;
                    end
                    PHYRETRAIN_RETRAIN_START_RESP   : begin
                        TX_PKT.msg_no       = 2;
                        TX_PKT.msg_info     = 3;
                        TX_PKT.msg_data     = 0;
                        TX_PKT.data_valid   = 0;
                    end
                endcase
            end
        endcase
    endtask : pkt_construct

    task pkt_drive();
        module_msg_no       = TX_PKT.msg_no;
        module_msg_info     =TX_PKT.msg_info;
        module_msg_valid    = 1;
        module_data_valid   = TX_PKT.data_valid;
        module_data_bus     = TX_PKT.msg_data;
        @(posedge i_clk);
        module_msg_valid    = 0; 
        module_data_valid   = 0;
    endtask : pkt_drive

    task pkt_check();
        if(partner_msg_no_out != TX_PKT.msg_no) begin
            $display("%0t: ERROR at MsgNo As TX_MsgNo = %d while RX_MsgNo = %d",$time(), TX_PKT.msg_no, partner_msg_no_out);
            err_cnt ++;
        end
        else if (partner_msg_info_out != TX_PKT.msg_info) begin
            $display("%0t: ERROR at MsgNo As TX_MsgInfo = %d while RX_MsgInfo = %d",$time(), TX_PKT.msg_info, partner_msg_info_out);
            err_cnt ++;
        end
        else if ( TX_PKT.data_valid && (partner_data_out != TX_PKT.msg_data)) begin
            $display("%0t: ERROR at MsgNo As TX_MsgData = %d while RX_MsgData = %d",$time(), TX_PKT.msg_data, partner_data_out);
            err_cnt ++;
        end
        else begin
            crrct_cnt ++;
        end
    endtask : pkt_check

   

    

/*******************************************************************************************
 ************************************ MODELING *********************************************
*******************************************************************************************/

/**************************************
 * falling edge detector
**************************************/
always @ (posedge i_clk or negedge  i_rst_n) begin
    if (!i_rst_n) begin
        module_busy_reg <= 0;
        partner_busy_reg <= 0;
    end else begin
        module_busy_reg <= Module.o_busy;
        partner_busy_reg <= Partner.o_busy;
    end
end



/**************************************
 * modelling channel transfer delay
**************************************/
// Module
reg [63:0] mod_tx_data_reg1;
reg [63:0] mod_tx_data_reg2;
reg [63:0] mod_tx_data_reg3;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        mod_tx_data_reg1 <= 0;
        mod_tx_data_reg2 <= 0;
        mod_tx_data_reg3 <= 0;
    end else begin
        if (TX_module_data != 0) begin
            mod_tx_data_reg1 <= TX_module_data;
        end
        else begin
            mod_tx_data_reg1 <= 0;
        end
            mod_tx_data_reg2 <= mod_tx_data_reg1;
            mod_tx_data_reg3 <= mod_tx_data_reg2;
    end
end

assign RX_module_data =  mod_tx_data_reg3; // output from module , input to partner after 3 clk cycles

// partner
reg [63:0] partner_tx_data_reg1;
reg [63:0] partner_tx_data_reg2;
reg [63:0] partner_tx_data_reg3;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        partner_tx_data_reg1 <= 0;
        partner_tx_data_reg2 <= 0;
        partner_tx_data_reg3 <= 0;
    end else begin
        if (TX_partner_data != 0) begin
            partner_tx_data_reg1 <= TX_partner_data;
        end
        else begin
            partner_tx_data_reg1 <= 0;
        end
            partner_tx_data_reg2 <= partner_tx_data_reg1;
            partner_tx_data_reg3 <= partner_tx_data_reg2;            
    end
end

assign RX_partner_data = partner_tx_data_reg3; // output from partner , input to module after 3 clk cycles

/**************************************
 * modelling deserlizar
**************************************/
// to detect that data change and we can take anothe data for rx
always @(Module.rx_wrapper.i_deser_data) begin
    module_de_ser_done = 1;
    repeat(2) @(posedge i_clk);
    module_de_ser_done = 0;
end

always @(Partner.rx_wrapper.i_deser_data) begin
    partner_de_ser_done = 1;
    repeat(2) @(posedge i_clk);
    partner_de_ser_done = 0;
end

/**************************************
 * modelling serelizar 
**************************************/
always @ (posedge Module.tx_wrapper.packet_encoder_dut.gen_dut.o_pattern_valid, posedge Module.tx_wrapper.packet_framing_dut.o_packet_valid) begin
        module_ser_done = 0;
        repeat(2) @(posedge i_clk);
        module_ser_done = 1;

end

always @ (posedge i_clk) begin
    if (Partner.tx_wrapper.packet_encoder_dut.gen_dut.o_pattern_valid || Partner.tx_wrapper.packet_framing_dut.o_packet_valid) begin
        partner_ser_done = 0;
        repeat(2) @(posedge i_clk);
        partner_ser_done = 1;
    end 

end



/****************************************************************
 * modelling change of partner state after receving pattern
****************************************************************/
always @(Partner.rx_wrapper.rx_fsm_dut.cs) begin 
    if (Partner.rx_wrapper.rx_fsm_dut.cs == 2) begin
        partner_state = 1;
    end
end

endmodule

//typedef enum {RESET, SBINIT, MBINIT, MBTRAIN, LINKINIT, ACTIVE, PHYRETRAIN, TRAINERROR} state_e;
//typedef enum {RESET, SBINIT, MBINIT, MBTRAIN, LINKINIT, ACTIVE, PHYRETRAIN, TRAINERROR} state_e;
//typedef enum {PARAM, CAL, REPAIRCLK, REPAIRVAL, REVERSALMB, REPAIRMB} MBINIT_SubState_e;


 /* task Drive_in_module();
        // Test another cases
        for (int i = 1; i < 3; i++) begin
            module_state = i; //enter state
            Module_state = state_e'(i); // enter state
            if (Module_state == SBINIT) begin
                Module_Message = "SBINIT_OUT_OF_RESET";
                module_msg_no = 3;
                module_msg_valid = 1;
                @(posedge i_clk);
                module_msg_valid = 0;

                //Module_Monitor();   

                @(negedge falling_edge_busy_module);
                Module_Message = "SBINIT_DONE_REQ";
                module_msg_no = 1;
                module_msg_valid = 1;
                @(posedge i_clk);
                module_msg_valid = 0;
                
                //Module_Monitor();

               @(negedge falling_edge_busy_module);
                Module_Message = "SBINIT_DONE_RESP";
                module_msg_no = 2;
                module_msg_valid = 1;
                @(posedge i_clk);
                module_msg_valid = 0;
                
                //Module_Monitor();

                @(negedge falling_edge_busy_module);
            end
            else if (Module_state == MBINIT) begin
                for (int j = 0; j < 3; j++) begin
                    module_sub_state = j; // enter sub state
                    Module_sub_state = MBINIT_SubState_e'(j); // enter sub state
                    if (Module_sub_state == PARAM) begin
                        Module_Message = "MBINIT_PARAM_configuration_req";
                        module_msg_no = 1;
                        module_msg_valid = 1;
                        module_data_valid = 1;
                        module_data_bus = 3;
                        @(posedge i_clk);
                        module_msg_valid = 0; 
                        module_data_valid = 0;
                        //module_data_bus = 1;

                        @(negedge falling_edge_busy_module);
                        Module_Message = "MBINIT_PARAM_configuration_resp";
                        module_msg_no = 2;
                        module_msg_valid = 1;
                        module_data_valid = 1;
                        module_data_bus = 3;
                        @(posedge i_clk);
                        module_msg_valid = 0; 
                        module_data_valid = 0;

                        @(negedge falling_edge_busy_module);
                    end
                    else if (Module_sub_state == CAL) begin
                        Module_Message = "MBINIT_CAL_DONE_REQ";
                        module_msg_no = 1;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                        Module_Message = "MBINIT_CAL_DONE_RESP";
                        module_msg_no = 2;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                    end
                    else if (Module_sub_state == REPAIRCLK) begin
                        Module_Message = "MBINIT_REPAIRCLK_init_req";
                        module_msg_no = 1;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                        Module_Message = "MBINIT_REPAIRCLK_init_resp";
                        module_msg_no = 2;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                        Module_Message = "MBINIT_REPAIRCLK_resule_req";
                        module_msg_no = 3;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                        Module_Message = "MBINIT_REPAIRCLK_resule_resp";
                        module_msg_no = 4;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                        Module_Message = "MBINIT_REPAIRCLK_DONE_req";
                        module_msg_no = 5;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                        Module_Message = "MBINIT_REPAIRCLK_DONE_resp";
                        module_msg_no = 6;
                        module_msg_valid = 1;
                        @(posedge i_clk);
                        module_msg_valid = 0; 

                        @(negedge falling_edge_busy_module);
                    end
                    
                end    
            end 
        end
    endtask : Drive_in_module */


/*
    task Module_Monitor();
        packet_t module_packet;
        module_packet.msg_no = module_msg_no;
        module_packet.msg_info = module_msg_info;
        module_packet.msg_data_bus = module_data_bus;
        module_packet.message_type = Module_Message;
        queue_module_packet.push_back(module_packet);
        $display(queue_module_packet);
    endtask : Module_Monitor

    always @(partner_msg_valid_out) begin 
        packet_t partner_packet;
        if(partner_msg_valid_out) begin
            partner_packet.msg_no = partner_msg_no_out;
            partner_packet.msg_info = partner_msg_info;
            partner_packet.msg_data_bus = partner_data_bus;
            queue_partner_packet.push_back(partner_packet);
            $display(queue_module_packet);
        end
    end

    //packet_t  queue_module_packet [$];
    //packet_t  queue_partner_packet [$];

    //state_e Module_state;
    //MBINIT_SubState_e Module_sub_state;

    //string Module_Message;

    task Check();
        packet_t tx_packet, rx_packet;

        // Check if queues are empty
        if (queue_module_packet.size() == 0 || queue_partner_packet.size() == 0) begin
            $display("Error: One or both queues are empty.");
            return;
        end

        // Ensure both queues have the same size
        if (queue_module_packet.size() != queue_partner_packet.size()) begin
            $display("Error: Queues have different sizes. Module Queue Size: %0d, Partner Queue Size: %0d", 
                     queue_module_packet.size(), queue_partner_packet.size());
            return;
        end

        // Loop through all elements in the queues
        for (int i = 0; i < queue_module_packet.size(); i++) begin
            tx_packet = queue_module_packet[i];
            rx_packet = queue_partner_packet[i];

            // Display detailed information for debugging
            $display("--------------------------------------------------");
            $display("Time: %0t | Packet %0d", $time, i);
            $display("Message Type: %s", tx_packet.message_type);
            $display("--------------------------------------------------");

            // Compare the packets
            if (tx_packet.msg_no != rx_packet.msg_no) begin
                $display("Error: Mismatch in msg_no. Expected: %h, Received: %h", 
                         tx_packet.msg_no, rx_packet.msg_no);
                $display("Error in sending %s", tx_packet.message_type);
            end else if (tx_packet.msg_info != rx_packet.msg_info) begin
                $display("Error: Mismatch in msg_info. Expected: %h, Received: %h", 
                         tx_packet.msg_info, rx_packet.msg_info);
                $display("Error in sending %s", tx_packet.message_type);
            end else if (tx_packet.msg_data_bus != rx_packet.msg_data_bus) begin
                $display("Error: Mismatch in msg_data_bus. Expected: %h, Received: %h", 
                         tx_packet.msg_data_bus, rx_packet.msg_data_bus);
                $display("Error in sending %s", tx_packet.message_type);
            end else begin
                $display("Message %s is received successfully", tx_packet.message_type);
            end
        end
    endtask : Check

    /*
 always @ (posedge Partner.tx_wrapper.sb_fsm_dut.cs or Partner.tx_wrapper.packet_encoder_dut.gen_dut.o_pattern_valid or Partner.o_busy  ) begin
    if (Partner.tx_wrapper.sb_fsm_dut.cs == 0 || falling_edge_busy_partner) begin
        partner_ser_done = 1;
    end else if (Partner.tx_wrapper.packet_encoder_dut.gen_dut.o_pattern_valid) begin
        partner_ser_done = 0;
    end  
end
*/
