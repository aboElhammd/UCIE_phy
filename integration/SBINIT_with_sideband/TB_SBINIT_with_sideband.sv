module TB_SBINIT_with_sideband;

/**************************************************************************************************************************************************
*************************************************************** SBINIT RELATED ********************************************************************
**************************************************************************************************************************************************/

///////////////////////////////////
/////////// PARAMETERS ////////////
///////////////////////////////////
localparam SB_MSG_WIDTH = 4;
localparam SBINIT_Out_of_Reset_msg 	= 3;
localparam SBINIT_done_req_msg		= 1;
localparam SBINIT_done_resp_msg		= 2;

typedef enum {IDLE_tx, START_SB_PATTERN, SBINIT_OUT_OF_RESET, SBINIT_DONE_REQ, SBINIT_END_tx} states_tx;
typedef enum {IDLE_rx, WAIT_FOR_DONE_REQ, SBINIT_DONE_RESP, SBINIT_END_rx} states_rx;
typedef enum {SB_OUT_OF_RESET = 3 , DONE_REQ = 1 , DONE_RESP = 2    } sideband_messages;

states_tx CS_tx, NS_tx, CS_tx_partner, NS_tx_partner;
states_rx CS_rx, NS_rx, CS_rx_partner, NS_rx_partner;
sideband_messages i_decoded_sideband_msg_mod, o_encoded_sideband_msg_mod;
sideband_messages i_decoded_sideband_msg_partner, o_encoded_sideband_msg_partner;

///////////////////////////////////
/////// FOR DEBUGGING ONLY ////////
///////////////////////////////////

always @ (*) begin
    CS_tx = states_tx'(dut.U_TX_SBINIT.CS);
    NS_tx = states_tx'(dut.U_TX_SBINIT.NS);
    CS_rx = states_rx'(dut.U_RX_SBINIT.CS);
    NS_rx = states_rx'(dut.U_RX_SBINIT.NS);
    CS_tx_partner = states_tx'(dut_partner.U_TX_SBINIT.CS);
    NS_tx_partner = states_tx'(dut_partner.U_TX_SBINIT.NS);
    CS_rx_partner = states_rx'(dut_partner.U_RX_SBINIT.CS);
    NS_rx_partner = states_rx'(dut_partner.U_RX_SBINIT.NS);
    i_decoded_sideband_msg_mod = sideband_messages'(dut.i_decoded_SB_msg);
    o_encoded_sideband_msg_mod = sideband_messages'(dut.o_encoded_SB_msg);
    i_decoded_sideband_msg_partner = sideband_messages'(dut_partner.i_decoded_SB_msg);
    o_encoded_sideband_msg_partner = sideband_messages'(dut_partner.o_encoded_SB_msg);
end

/******************************************************************
* Back to Back connection
*******************************************************************/

/*********************
* Module
*********************/
// Inputs
logic i_clk;
logic i_rst_n;
logic i_SBINIT_en;
logic i_start_pattern_done;
logic i_SB_Busy;

// Outputs
logic o_start_pattern_req_1;
logic o_SBINIT_end;   


/*********************
* Module partner
*********************/
// Inputs
logic i_SBINIT_en_partner;
logic i_start_pattern_done_partner;
logic i_SB_Busy_partner;

// Outputs
logic o_start_pattern_req_2;
logic o_SBINIT_end_partner;


/**************************************************************************************************************************************************
*************************************************************** SIDEBAND RELATED ******************************************************************
**************************************************************************************************************************************************/
// Signals for Module instance
logic               module_start_pattern_req;
logic               module_rdi_msg;
logic               module_data_valid;
logic               module_msg_valid;
logic       [2:0]   module_state;
logic       [3:0]   module_sub_state;
logic       [3:0]   module_msg_no;
logic       [2:0]   module_msg_info;
logic       [15:0]  module_data_bus;
logic               module_ser_done;
logic               module_stop_cnt;
logic               module_tx_point_sweep_test_en;
logic       [1:0]   module_tx_point_sweep_test;
logic       [1:0]   module_rdi_msg_code;
logic       [3:0]   module_rdi_msg_sub_code;
logic       [1:0]   module_rdi_msg_info;
logic               module_de_ser_done;
logic       [63:0]  module_deser_data;

logic              module_start_pattern_done;
logic              module_time_out;
logic      [63:0]  module_tx_data_out;
logic              module_busy;
logic              module_rx_sb_start_pattern;
logic              module_rdi_msg_out;
logic              module_msg_valid_out;
logic              module_parity_error;
logic              module_adapter_enable;
logic      [1:0]   module_tx_point_sweep_test_out;
logic      [3:0]   module_msg_no_out;
logic      [2:0]   module_msg_info_out;
logic      [15:0]  module_data_out;
logic      [1:0]   module_rdi_msg_code_out;
logic      [3:0]   module_rdi_msg_sub_code_out;
logic      [1:0]   module_rdi_msg_info_out;

// Signals for Partner instance
logic               partner_start_pattern_req;
logic               partner_rdi_msg;
logic               partner_data_valid;
logic               partner_msg_valid;
logic       [2:0]   partner_state;
logic       [3:0]   partner_sub_state;
logic       [3:0]   partner_msg_no;
logic       [2:0]   partner_msg_info;
logic       [15:0]  partner_data_bus;
logic               partner_ser_done;
logic               partner_stop_cnt;
logic               partner_tx_point_sweep_test_en;
logic       [1:0]   partner_tx_point_sweep_test;
logic       [1:0]   partner_rdi_msg_code;
logic       [3:0]   partner_rdi_msg_sub_code;
logic       [1:0]   partner_rdi_msg_info;
logic               partner_de_ser_done;
logic       [63:0]  partner_deser_data;

logic              partner_start_pattern_done;
logic              partner_time_out;
logic      [63:0]  partner_tx_data_out;
logic              partner_busy;
logic              partner_rx_sb_start_pattern;
logic              partner_rdi_msg_out;
logic              partner_msg_valid_out;
logic              partner_parity_error;
logic              partner_adapter_enable;
logic      [1:0]   partner_tx_point_sweep_test_out;
logic      [3:0]   partner_msg_no_out;
logic      [2:0]   partner_msg_info_out;
logic      [15:0]  partner_data_out;
logic      [1:0]   partner_rdi_msg_code_out;
logic      [3:0]   partner_rdi_msg_sub_code_out;
logic      [1:0]   partner_rdi_msg_info_out;

logic [63:0] TX_module_data, RX_module_data, TX_partner_data, RX_partner_data;

int err_cnt = 0;
int crrct_cnt = 0;

logic module_busy_logic, partner_busy_logic;
logic falling_edge_busy_module = (module_busy_logic != Module.o_busy) && !Module.o_busy;
logic falling_edge_busy_partner = (partner_busy_logic != Partner.o_busy) && !Partner.o_busy;

/*********************
* Module
*********************/
SBINIT_WRAPPER #( 
    .SB_MSG_WIDTH(SB_MSG_WIDTH)
) dut (
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .i_SBINIT_en            (i_SBINIT_en),
    .i_start_pattern_done   (module_start_pattern_done),
    .i_SB_Busy              (module_busy),
    .i_decoded_SB_msg       (module_msg_no_out),
    .o_start_pattern_req    (o_start_pattern_req_1),
    .o_encoded_SB_msg       (module_msg_no),
    .o_tx_msg_valid         (module_msg_valid),
    .o_SBINIT_end           (o_SBINIT_end)
);

/*********************
* Module partner
*********************/
SBINIT_WRAPPER #( 
    .SB_MSG_WIDTH(SB_MSG_WIDTH)
) dut_partner (
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .i_SBINIT_en            (i_SBINIT_en_partner),
    .i_start_pattern_done   (partner_start_pattern_done),
    .i_SB_Busy              (partner_busy),
    .i_decoded_SB_msg       (partner_msg_no_out),
    .o_start_pattern_req    (o_start_pattern_req_2),
    .o_encoded_SB_msg       (partner_msg_no),
    .o_tx_msg_valid         (partner_msg_valid),
    .o_SBINIT_end           (o_SBINIT_end_partner)
);


// Instantiate the Module
SB_TOP_WRAPPER Module (
    .i_clk                    (i_clk),
    .i_rst_n                  (i_rst_n),
    .i_start_pattern_req      (o_start_pattern_req_1),
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
    .i_start_pattern_req      (o_start_pattern_req_2),
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


/**************************************************************************************************************************************************
*************************************************************** STIMILUS GENERATION ***************************************************************
**************************************************************************************************************************************************/
///////////////////////////////////
//////// CLOCK GENERATION /////////
///////////////////////////////////

initial begin
    i_clk = 0;
    forever #5 i_clk = ~i_clk;
end

///////////////////////////////////
///////// INITIAL BLOCK ///////////
///////////////////////////////////

initial begin
    i_rst_n = 1;
    i_SBINIT_en = 0;
    i_SBINIT_en_partner = 0;
    RESET_DUT;
    module_state = 1;
    init_SB();
    DELAY (3);
    i_SBINIT_en = 1;
    DELAY (1000);
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
* Reset task 
**********************************/
task RESET_DUT;
    begin
        i_rst_n = 0;
        DELAY (3);
        i_rst_n = 1;
        DELAY (1);
    end
endtask

/**********************************
* modelling partner SBINIT EN
**********************************/
always @ (posedge Partner.o_rx_sb_start_pattern) begin
    DELAY (1);
    i_SBINIT_en_partner = 1;
end

/**********************************
* modelling  SBINIT END
**********************************/
always @ (posedge dut.o_SBINIT_end) begin
    DELAY (1);
    i_SBINIT_en = 0;
end

always @ (posedge dut_partner.o_SBINIT_end) begin
    DELAY (1);
    i_SBINIT_en_partner = 0;
end

/**********************************
* modelling partner state
**********************************/
always @ (posedge Partner.o_rx_sb_start_pattern) begin
    partner_state = 1;
end

task init_SB();
    // Initialize all inputs for Module
    module_start_pattern_req = 0;
    module_rdi_msg = 0;
    module_data_valid = 0;
    module_sub_state = 0;
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
    partner_sub_state = 0;
    partner_state    = 0;
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
endtask


/**************************************
 * modelling channel transfer delay
**************************************/
// Module
logic [63:0] mod_tx_data_logic1;
logic [63:0] mod_tx_data_logic2;
logic [63:0] mod_tx_data_logic3;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        mod_tx_data_logic1 <= 0;
        mod_tx_data_logic2 <= 0;
        mod_tx_data_logic3 <= 0;
    end else begin
        if (TX_module_data != 0) begin
            mod_tx_data_logic1 <= TX_module_data;
        end
            mod_tx_data_logic2 <= mod_tx_data_logic1;
            mod_tx_data_logic3 <= mod_tx_data_logic2;
    end
end

assign RX_module_data =  mod_tx_data_logic3; // output from module , input to partner after 3 clk cycles

// partner
logic [63:0] partner_tx_data_logic1;
logic [63:0] partner_tx_data_logic2;
logic [63:0] partner_tx_data_logic3;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        partner_tx_data_logic1 <= 0;
        partner_tx_data_logic2 <= 0;
        partner_tx_data_logic3 <= 0;
    end else begin
        if (TX_partner_data != 0) begin
            partner_tx_data_logic1 <= TX_partner_data;
        end 
            partner_tx_data_logic2 <= partner_tx_data_logic1;
            partner_tx_data_logic3 <= partner_tx_data_logic2;            
    end
end

assign RX_partner_data = partner_tx_data_logic3; // output from partner , input to module after 3 clk cycles

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

endmodule 