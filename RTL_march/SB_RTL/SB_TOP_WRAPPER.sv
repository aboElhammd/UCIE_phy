module SB_TOP_WRAPPER (
    input               i_clk,
    input               i_rst_n,
    input               i_start_pattern_req,
    input               i_rdi_msg,
    input               i_data_valid,
    input               i_msg_valid,
    input       [3:0]   i_state,
    input       [3:0]   i_sub_state,
    input       [3:0]   i_msg_no,
    input       [2:0]   i_msg_info,
    input       [15:0]  i_data_bus,
    //input               i_rx_sb_pattern_samp_done,
    //input               i_rx_sb_rsp_delivered,
    input               i_ser_done,
    input               i_stop_cnt,
    input               i_tx_point_sweep_test_en,
    input       [1:0]   i_tx_point_sweep_test,
    input       [1:0]   i_rdi_msg_code,
    input       [3:0]   i_rdi_msg_sub_code,
    input       [1:0]   i_rdi_msg_info,
    input               i_de_ser_done,
    input       [63:0]  i_deser_data,
    input               RXCKSB,
    input               RXDATASB,
    output              o_start_pattern_done,
    output              o_time_out,
    output      [63:0]  o_tx_data_out,
    output              o_busy,
    output              o_rx_sb_start_pattern,
    //output              o_rx_sb_pattern_samp_done,
    output              o_rdi_msg,
    output              o_msg_valid,
    output              o_parity_error,
    //output              o_rx_rsp_delivered,
    output              o_adapter_enable,
    output      [1:0]   o_tx_point_sweep_test,
    output      [3:0]   o_msg_no,
    output      [2:0]   o_msg_info,
    output      [15:0]  o_data,
    output      [1:0]   o_rdi_msg_code,
    output      [3:0]   o_rdi_msg_sub_code,
    output      [1:0]   o_rdi_msg_info,
    output              TXCKSB,          
    output              TXDATASB 
);

wire rx_sb_rsp_delivered;
wire rx_sb_pattern_samp_done;
wire divided_clk;

    Clock_Divider_by_8 clk_div_dut (
        .i_rst_n      (i_rst_n),
        .i_pll_clk    (i_clk),
        .o_divided_clk(divided_clk)
    );

    // Instantiate the TX wrapper
    SB_TX_WRAPPER tx_wrapper (
        .i_clk                    (i_clk),
        .i_rst_n                  (i_rst_n),
        .i_start_pattern_req      (i_start_pattern_req),
        .i_rdi_msg                (i_rdi_msg),
        .i_data_valid            (i_data_valid),
        .i_msg_valid             (i_msg_valid),
        .i_state                 (i_state),
        .i_sub_state             (i_sub_state),
        .i_msg_no                (i_msg_no),
        .i_msg_info              (i_msg_info),
        .i_data_bus              (i_data_bus),
        .i_rx_sb_pattern_samp_done(rx_sb_pattern_samp_done),
        .i_rx_sb_rsp_delivered   (rx_sb_rsp_delivered),
        // .i_ser_done              (i_ser_done),
        .i_stop_cnt              (i_stop_cnt),
        .i_tx_point_sweep_test_en(i_tx_point_sweep_test_en),
        .i_tx_point_sweep_test   (i_tx_point_sweep_test),
        .i_rdi_msg_code          (i_rdi_msg_code),
        .i_rdi_msg_sub_code      (i_rdi_msg_sub_code),
        .i_rdi_msg_info          (i_rdi_msg_info),
        .o_start_pattern_done   (o_start_pattern_done),
        .o_time_out              (o_time_out),
        // .o_tx_data_out          (o_tx_data_out),
        .o_busy                  (o_busy),
        .TXCKSB                   (TXCKSB),
        .TXDATASB                 (TXDATASB)
    );

    // Instantiate the RX wrapper
    SB_RX_WRAPPER rx_wrapper (
        .i_clk                    (divided_clk),
        .i_clk_pll                (i_clk),
        .i_rst_n                  (i_rst_n),
        // .i_de_ser_done            (i_de_ser_done),
        // .i_deser_data             (i_deser_data),
        .i_state                 (i_state),
        .o_rx_sb_start_pattern    (o_rx_sb_start_pattern),
        .o_rx_sb_pattern_samp_done(rx_sb_pattern_samp_done),
        .o_rdi_msg                (o_rdi_msg),
        .o_msg_valid              (o_msg_valid),
        .o_parity_error           (o_parity_error),
        .o_rx_rsp_delivered      (rx_sb_rsp_delivered),
        .o_adapter_enable         (o_adapter_enable),
        .o_tx_point_sweep_test_en (o_tx_point_sweep_test_en),
        .o_tx_point_sweep_test    (o_tx_point_sweep_test),
        .o_msg_no                (o_msg_no),
        .o_msg_info              (o_msg_info),
        .o_data                  (o_data),
        .o_rdi_msg_code          (o_rdi_msg_code),
        .o_rdi_msg_sub_code      (o_rdi_msg_sub_code),
        .o_rdi_msg_info          (o_rdi_msg_info),
        .RXDATASB                 (RXDATASB),
        .RXCKSB                   (RXCKSB)
    );

endmodule : SB_TOP_WRAPPER