`timescale 1ns/1ps

import pkg::*;

module tb_SB_TOP_WRAPPER;

    // Clock and reset (shared)
    reg               i_clk;
    reg               i_rst_n;
    
    // Inputs for module instance
    reg               module_i_start_pattern_req;
    reg               module_i_rdi_msg;
    reg               module_i_data_valid;
    reg               module_i_msg_valid;
    reg       [3:0]   module_i_state;
    reg       [3:0]   module_i_sub_state;
    reg       [3:0]   module_i_msg_no;
    reg       [2:0]   module_i_msg_info;
    reg       [15:0]  module_i_data_bus;
    reg               module_i_stop_cnt;
    reg               module_i_tx_point_sweep_test_en;
    reg       [1:0]   module_i_tx_point_sweep_test;
    reg       [1:0]   module_i_rdi_msg_code;
    reg       [3:0]   module_i_rdi_msg_sub_code;
    reg       [1:0]   module_i_rdi_msg_info;
    reg               module_i_de_ser_done;
    reg       [63:0]  module_i_deser_data;
    
    // Outputs for module instance
    wire              module_o_de_ser_done_sampled;
    wire              module_o_start_pattern_done;
    wire              module_o_time_out;
    wire              module_o_busy;
    wire              module_o_rx_sb_start_pattern;
    wire              module_o_rdi_msg;
    wire              module_o_msg_valid;
    wire              module_o_parity_error;
    wire              module_o_adapter_enable;
    wire      [1:0]   module_o_tx_point_sweep_test;
    wire      [3:0]   module_o_msg_no;
    wire      [2:0]   module_o_msg_info;
    wire      [15:0]  module_o_data;
    wire      [1:0]   module_o_rdi_msg_code;
    wire      [3:0]   module_o_rdi_msg_sub_code;
    wire      [1:0]   module_o_rdi_msg_info;
    wire              module_TXCKSB;    
    wire      [63:0]  module_o_fifo_data;
    wire              module_o_ser_done_sampled;
    wire              module_o_pack_finished;
    wire              module_o_clk_ser_en;
    
    // Inputs for partner instance
    reg               partner_i_start_pattern_req;
    reg               partner_i_rdi_msg;
    reg               partner_i_data_valid;
    reg               partner_i_msg_valid;
    reg       [3:0]   partner_i_state;
    reg       [3:0]   partner_i_sub_state;
    reg       [3:0]   partner_i_msg_no;
    reg       [2:0]   partner_i_msg_info;
    reg       [15:0]  partner_i_data_bus;
    reg               partner_i_stop_cnt;
    reg               partner_i_tx_point_sweep_test_en;
    reg       [1:0]   partner_i_tx_point_sweep_test;
    reg       [1:0]   partner_i_rdi_msg_code;
    reg       [3:0]   partner_i_rdi_msg_sub_code;
    reg       [1:0]   partner_i_rdi_msg_info;
    reg               partner_i_de_ser_done;
    reg       [63:0]  partner_i_deser_data;
    
    // Outputs for partner instance
    wire              partner_o_de_ser_done_sampled;
    wire              partner_o_start_pattern_done;
    wire              partner_o_time_out;
    wire              partner_o_busy;
    wire              partner_o_rx_sb_start_pattern;
    wire              partner_o_rdi_msg;
    wire              partner_o_msg_valid;
    wire              partner_o_parity_error;
    wire              partner_o_adapter_enable;
    wire      [1:0]   partner_o_tx_point_sweep_test;
    wire      [3:0]   partner_o_msg_no;
    wire      [2:0]   partner_o_msg_info;
    wire      [15:0]  partner_o_data;
    wire      [1:0]   partner_o_rdi_msg_code;
    wire      [3:0]   partner_o_rdi_msg_sub_code;
    wire      [1:0]   partner_o_rdi_msg_info;
    wire              partner_TXCKSB;    
    wire      [63:0]  partner_o_fifo_data;
    wire              partner_o_ser_done_sampled;
    wire              partner_o_pack_finished;
    wire              partner_o_clk_ser_en;

    int err_cnt = 0;
    int crrct_cnt = 0;

    // Instantiate module
    SB_TOP_WRAPPER Module (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_start_pattern_req(module_i_start_pattern_req),
        .i_rdi_msg(module_i_rdi_msg),
        .i_data_valid(module_i_data_valid),
        .i_msg_valid(module_i_msg_valid),
        .i_state(module_i_state),
        .i_sub_state(module_i_sub_state),
        .i_msg_no(module_i_msg_no),
        .i_msg_info(module_i_msg_info),
        .i_data_bus(module_i_data_bus),
        .i_stop_cnt(module_i_stop_cnt),
        .i_tx_point_sweep_test_en(module_i_tx_point_sweep_test_en),
        .i_tx_point_sweep_test(module_i_tx_point_sweep_test),
        .i_rdi_msg_code(module_i_rdi_msg_code),
        .i_rdi_msg_sub_code(module_i_rdi_msg_sub_code),
        .i_rdi_msg_info(module_i_rdi_msg_info),
        .i_de_ser_done(module_i_de_ser_done),
        .i_deser_data(module_i_deser_data),
        .o_de_ser_done_sampled(module_o_de_ser_done_sampled),
        .o_start_pattern_done(module_o_start_pattern_done),
        .o_time_out(module_o_time_out),
        .o_busy(module_o_busy),
        .o_rx_sb_start_pattern(module_o_rx_sb_start_pattern),
        .o_rdi_msg(module_o_rdi_msg),
        .o_msg_valid(module_o_msg_valid),
        .o_parity_error(module_o_parity_error),
        .o_adapter_enable(module_o_adapter_enable),
        .o_tx_point_sweep_test(module_o_tx_point_sweep_test),
        .o_msg_no(module_o_msg_no),
        .o_msg_info(module_o_msg_info),
        .o_data(module_o_data),
        .o_rdi_msg_code(module_o_rdi_msg_code),
        .o_rdi_msg_sub_code(module_o_rdi_msg_sub_code),
        .o_rdi_msg_info(module_o_rdi_msg_info),
        .TXCKSB(module_TXCKSB),
        .o_fifo_data(module_o_fifo_data),
        .o_ser_done_sampled(module_o_ser_done_sampled),
        .o_pack_finished(module_o_pack_finished),
        .o_clk_ser_en(module_o_clk_ser_en)
    );
    
    // Instantiate partner
    SB_TOP_WRAPPER Partner (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_start_pattern_req(partner_i_start_pattern_req),
        .i_rdi_msg(partner_i_rdi_msg),
        .i_data_valid(partner_i_data_valid),
        .i_msg_valid(partner_i_msg_valid),
        .i_state(partner_i_state),
        .i_sub_state(partner_i_sub_state),
        .i_msg_no(partner_i_msg_no),
        .i_msg_info(partner_i_msg_info),
        .i_data_bus(partner_i_data_bus),
        .i_stop_cnt(partner_i_stop_cnt),
        .i_tx_point_sweep_test_en(partner_i_tx_point_sweep_test_en),
        .i_tx_point_sweep_test(partner_i_tx_point_sweep_test),
        .i_rdi_msg_code(partner_i_rdi_msg_code),
        .i_rdi_msg_sub_code(partner_i_rdi_msg_sub_code),
        .i_rdi_msg_info(partner_i_rdi_msg_info),
        .i_de_ser_done(partner_i_de_ser_done),
        .i_deser_data(partner_i_deser_data),
        .o_de_ser_done_sampled(partner_o_de_ser_done_sampled),
        .o_start_pattern_done(partner_o_start_pattern_done),
        .o_time_out(partner_o_time_out),
        .o_busy(partner_o_busy),
        .o_rx_sb_start_pattern(partner_o_rx_sb_start_pattern),
        .o_rdi_msg(partner_o_rdi_msg),
        .o_msg_valid(partner_o_msg_valid),
        .o_parity_error(partner_o_parity_error),
        .o_adapter_enable(partner_o_adapter_enable),
        .o_tx_point_sweep_test(partner_o_tx_point_sweep_test),
        .o_msg_no(partner_o_msg_no),
        .o_msg_info(partner_o_msg_info),
        .o_data(partner_o_data),
        .o_rdi_msg_code(partner_o_rdi_msg_code),
        .o_rdi_msg_sub_code(partner_o_rdi_msg_sub_code),
        .o_rdi_msg_info(partner_o_rdi_msg_info),
        .TXCKSB(partner_TXCKSB),
        .o_fifo_data(partner_o_fifo_data),
        .o_ser_done_sampled(partner_o_ser_done_sampled),
        .o_pack_finished(partner_o_pack_finished),
        .o_clk_ser_en(partner_o_clk_ser_en)
    );

    //-------------------------------------------------------------------------//
    //----------------------- Analog modelling blocks -------------------------//
    //-------------------------------------------------------------------------//
    wire TXDATASB_module;
    wire TXDATASB_partner;

    SB_TX_SERIALIZER module_serializer_dut (
        .i_pll_clk      (i_clk), // 
        .i_rst_n        (i_rst_n), // 
        .i_data_in      (module_o_fifo_data), //
        .i_enable       (module_o_clk_ser_en), //
        .i_pack_finished(module_o_pack_finished), //
        .TXDATASB       (TXDATASB_module) //
    );

    SB_RX_DESER module_deser_dut (
        .i_clk       (partner_TXCKSB),
        .i_clk_pll   (i_clk),
        .i_rst_n     (i_rst_n),
        .ser_data_in (TXDATASB_partner),
        .i_de_ser_done_sampled(module_o_de_ser_done_sampled),
        .par_data_out(module_i_deser_data),
        .de_ser_done (module_i_de_ser_done)
    );

    SB_TX_SERIALIZER partner_serializer_dut (
        .i_pll_clk      (i_clk), // 
        .i_rst_n        (i_rst_n), // 
        .i_data_in      (partner_o_fifo_data), //
        .i_enable       (partner_o_clk_ser_en), //
        .i_pack_finished(partner_o_pack_finished), //
        .TXDATASB       (TXDATASB_partner) //
    );

    SB_RX_DESER partner_deser_dut (
        .i_clk       (module_TXCKSB),
        .i_clk_pll   (i_clk),
        .i_rst_n     (i_rst_n),
        .ser_data_in (TXDATASB_module),
        .i_de_ser_done_sampled(partner_o_de_ser_done_sampled),
        .par_data_out(partner_i_deser_data),
        .de_ser_done (partner_i_de_ser_done)
    );

    ////////////////////////////////////////////////////////////////////////////

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
        // Initialize all inputs for Module instance
        module_i_start_pattern_req = 0;
        module_i_rdi_msg = 0;
        module_i_data_valid = 0;
        module_i_msg_valid = 0;
        module_i_state = 0;
        module_i_sub_state = 0;
        module_i_msg_no = 0;
        module_i_msg_info = 0;
        module_i_data_bus = 0;
        module_i_stop_cnt = 0;
        module_i_tx_point_sweep_test_en = 0;
        module_i_tx_point_sweep_test = 0;
        module_i_rdi_msg_code = 0;
        module_i_rdi_msg_sub_code = 0;
        module_i_rdi_msg_info = 0;

        // Initialize all inputs for Partner instance
        partner_i_start_pattern_req = 0;
        partner_i_rdi_msg = 0;
        partner_i_data_valid = 0;
        partner_i_msg_valid = 0;
        partner_i_state = 0;
        partner_i_sub_state = 0;
        partner_i_msg_no = 0;
        partner_i_msg_info = 0;
        partner_i_data_bus = 0;
        partner_i_stop_cnt = 0;
        partner_i_tx_point_sweep_test_en = 0;
        partner_i_tx_point_sweep_test = 0;
        partner_i_rdi_msg_code = 0;
        partner_i_rdi_msg_sub_code = 0;
        partner_i_rdi_msg_info = 0;
    endtask : init

    task rst();
        i_rst_n = 0;
        repeat (8*10) @(posedge i_clk);
        i_rst_n = 1;
    endtask : rst

    task pattern_gen();
        // Set states
        module_i_state = 4'b0001; // SBINIT 
        partner_i_state = 4'b0000; // RESET
        
        // Start pattern request for Module
        module_i_start_pattern_req = 1;
        repeat(8) @(posedge i_clk);
        module_i_start_pattern_req = 0;

        // Test Pattern Detection for Partner
        wait (partner_o_rx_sb_start_pattern);
        repeat(8) @(posedge i_clk);
        partner_i_start_pattern_req = 1;
        repeat(8) @(posedge i_clk);
        partner_i_start_pattern_req = 0;
        
        repeat(60*8) @(posedge i_clk);
    endtask : pattern_gen

    task Drive_in_module();
        GenStates_DRV = GenStates_DRV.first();
        for (int i = 0; i < GenStates_DRV.num(); i++) begin
            module_i_state = GenStates_DRV;
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
                        @(posedge partner_o_msg_valid);
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
                        module_i_sub_state = MBINIT_SubStates_DRV;
                        case (MBINIT_SubStates_DRV)
                            PARAM: 
                                begin
                                    MBINIT_PARAM_MSGs = MBINIT_PARAM_MSGs.first();
                                    for (int i = 0; i < MBINIT_PARAM_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBINIT_PARAM_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                        module_i_sub_state = MBTRAIN_SubStates_DRV;
                        case (MBTRAIN_SubStates_DRV)
                            VALREF          : 
                                begin
                                    MBTRAIN_VALVREF_MSGs = MBTRAIN_VALVREF_MSGs.first();
                                    for (int i = 0; i < MBTRAIN_VALVREF_MSGs.num(); i++) begin
                                        $display("i_msg_no: %s", MBTRAIN_VALVREF_MSGs);
                                        pkt_construct();
                                        pkt_drive();
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                                        @(posedge partner_o_msg_valid);
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
                        @(posedge partner_o_msg_valid);
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
        module_i_msg_no       = TX_PKT.msg_no;
        module_i_msg_info     =TX_PKT.msg_info;
        module_i_msg_valid    = 1;
        module_i_data_valid   = TX_PKT.data_valid;
        module_i_data_bus     = TX_PKT.msg_data;
        repeat(8*2) @(posedge i_clk);
        module_i_msg_valid    = 0; 
        module_i_data_valid   = 0;
    endtask : pkt_drive

    task pkt_check();
        if(partner_o_msg_no != TX_PKT.msg_no) begin
            $display("%0t: ERROR at MsgNo As TX_MsgNo = %d while RX_MsgNo = %d",$time(), TX_PKT.msg_no, partner_o_msg_no);
            err_cnt ++;
        end
        else if (partner_o_msg_info != TX_PKT.msg_info) begin
            $display("%0t: ERROR at MsgNo As TX_MsgInfo = %d while RX_MsgInfo = %d",$time(), TX_PKT.msg_info, partner_o_msg_info);
            err_cnt ++;
        end
        else if ( TX_PKT.data_valid && (partner_o_data != TX_PKT.msg_data)) begin
            $display("%0t: ERROR at MsgNo As TX_MsgData = %d while RX_MsgData = %d",$time(), TX_PKT.msg_data, partner_o_data);
            err_cnt ++;
        end
        else begin
            crrct_cnt ++;
        end
    endtask : pkt_check

    /****************************************************************
     * modelling change of partner state after receving pattern
    ****************************************************************/
    always @(Partner.rx_wrapper.rx_fsm_dut.cs) begin 
        if (Partner.rx_wrapper.rx_fsm_dut.cs == 2) begin
            partner_i_state = 1;
        end
    end

endmodule
