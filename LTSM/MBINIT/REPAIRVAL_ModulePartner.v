module REPAIRVAL_ModulePartner (
    input wire              CLK,
    input wire              rst_n,
    input wire              i_REPAIRCLK_end,
    input wire              i_VAL_Result_logged,
    input wire [3:0]        i_Rx_SbMessage,
    input wire              i_falling_edge_busy,
    input wire              i_Busy_SideBand,
    input                   i_msg_valid,
    // input wire              i_valid_val_result_logged,

    // output reg              o_MBINIT_REPAIRVAL_Detection_GetResult,
    output reg              o_VAL_Result_logged,
    output reg [3:0]        o_TX_SbMessage,
    output reg              o_MBINIT_REPAIRVAL_ModulePartner_end,
    output reg              o_ValidOutDatat_ModulePartner,
    output reg              o_enable_cons //for ashour
    // output reg              o_ValidMsgInfoREPAIRVAL_ModulePartner
);
////////////////////////////////////////////////////////////////////////////////
// State machine states MODULE_PARTNER
////////////////////////////////////////////////////////////////////////////////
    localparam IDLE                          = 0;
    localparam REPAIRVAL_CHECK_INIT_REQ      = 1;
    localparam REPAIRVAL_INIT_RESP           = 2;
    // localparam REPAIRVAL_GET_COMPARE         = 3;
    localparam REPAIRVAL_RESULT_RESP         = 3;
    localparam REPAIRVAL_DONE_RESP           = 4;
    localparam REPAIRVAL_DONE                = 5;
    localparam REPAIRVAL_HANDLE_VALID        = 6;
    localparam REPAIRVAL_CHECK_BUSY_INIT     = 7;
    localparam REPAIRVAL_CHECK_BUSY_RESULT   = 8;
    localparam REPAIRVAL_CHECK_BUSY_DONE     = 9;

////////////////////////////////////////////////////////////////////////////////
// Sideband messages 
////////////////////////////////////////////////////////////////////////////////
    localparam MBINI_REPAIRVAL_init_req     = 4'b0001;
    localparam MBINIT_REPAIRVAL_init_resp   = 4'b0010;
    localparam MBINIT_REPAIRVAL_result_req  = 4'b0011;
    localparam MBINIT_REPAIRVAL_result_resp = 4'b0100;
    localparam MBINIT_REPAIRVAL_done_req    = 4'b0101;
    localparam MBINIT_REPAIRVAL_done_resp   = 4'b0110;

    reg [3:0] CS, NS;   // CS current state, NS next state
    // wire go_to_done_resp, go_to_result_resp, go_to_init_resp;

    // assign go_to_init_resp   = (CS == REPAIRVAL_CHECK_INIT_REQ && NS == REPAIRVAL_CHECK_BUSY) ? 1 : 0;
    // assign go_to_result_resp = (CS == REPAIRVAL_GET_COMPARE && NS == REPAIRVAL_CHECK_BUSY) ? 1 : 0;
    // assign go_to_done_resp   = (CS == REPAIRVAL_HANDLE_VALID && NS == REPAIRVAL_CHECK_BUSY) ? 1 : 0;

////////////////////////////////////////////////////////////////////////////////
// State machine Transition for the REPAIR_CLK_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            CS <= IDLE;
        end else begin
            CS <= NS;
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Next state logic for the REPAIR_CLK_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(*) begin
        NS = CS;
        case (CS)
            IDLE: begin
                if (i_REPAIRCLK_end) NS = REPAIRVAL_CHECK_INIT_REQ;
            end
            REPAIRVAL_CHECK_INIT_REQ: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (i_Rx_SbMessage == MBINI_REPAIRVAL_init_req && i_msg_valid) NS = REPAIRVAL_CHECK_BUSY_INIT;
            end
            REPAIRVAL_CHECK_BUSY_INIT: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REPAIRVAL_INIT_RESP;
            end
            REPAIRVAL_INIT_RESP: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REPAIRVAL_HANDLE_VALID;
            end
            REPAIRVAL_HANDLE_VALID: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (i_Rx_SbMessage == MBINIT_REPAIRVAL_result_req && i_msg_valid) NS = REPAIRVAL_CHECK_BUSY_RESULT;
                else if (i_Rx_SbMessage == MBINIT_REPAIRVAL_done_req && i_msg_valid) NS = REPAIRVAL_CHECK_BUSY_DONE;
            end
            // REPAIRVAL_GET_COMPARE: begin
            //     if (~i_REPAIRCLK_end) NS = IDLE;
            //     else if (i_valid_val_result_logged) NS = REPAIRVAL_CHECK_BUSY_RESULT;
            // end
            REPAIRVAL_CHECK_BUSY_RESULT: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REPAIRVAL_RESULT_RESP;
            end
            REPAIRVAL_RESULT_RESP: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REPAIRVAL_HANDLE_VALID;
            end
            REPAIRVAL_CHECK_BUSY_DONE: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REPAIRVAL_DONE_RESP;
            end
            REPAIRVAL_DONE_RESP: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REPAIRVAL_DONE;
            end
            REPAIRVAL_DONE: begin
                if (~i_REPAIRCLK_end) NS = IDLE;
            end
            default: NS = IDLE;
        endcase
    end

////////////////////////////////////////////////////////////////////////////////
// Registered output logic for the REPAIR_CLK_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            // o_MBINIT_REPAIRVAL_Detection_GetResult <= 0;
            o_ValidOutDatat_ModulePartner <= 0;
            o_VAL_Result_logged <= 0;
            o_TX_SbMessage <= 4'b0000;
            o_MBINIT_REPAIRVAL_ModulePartner_end <= 0;
            o_enable_cons<=0;
            // o_ValidMsgInfoREPAIRVAL_ModulePartner <= 0;
        end else begin
                o_ValidOutDatat_ModulePartner <= 0;
                o_VAL_Result_logged <= 0;
                o_TX_SbMessage <= 4'b0000;
                o_MBINIT_REPAIRVAL_ModulePartner_end <= 0;
                o_enable_cons<=1;
            case (NS)
                REPAIRVAL_INIT_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REPAIRVAL_init_resp;
                end
                // REPAIRVAL_GET_COMPARE: begin
                //     o_MBINIT_REPAIRVAL_Detection_GetResult <= 1;
                // end
                REPAIRVAL_RESULT_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    // o_ValidMsgInfoREPAIRVAL_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REPAIRVAL_result_resp;
                    o_VAL_Result_logged <= (CS == REPAIRVAL_CHECK_BUSY_RESULT)? i_VAL_Result_logged : o_VAL_Result_logged;
                end
                REPAIRVAL_DONE_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REPAIRVAL_done_resp;
                end
                REPAIRVAL_DONE: begin
                    o_MBINIT_REPAIRVAL_ModulePartner_end <= 1;
                end
                default : begin
                    o_ValidOutDatat_ModulePartner <= 0;
                    o_VAL_Result_logged <= 0;
                    o_TX_SbMessage <= 4'b0000;
                    o_MBINIT_REPAIRVAL_ModulePartner_end <= 0;
                    // o_ValidMsgInfoREPAIRVAL_ModulePartner <= 0;
                end
            endcase
        end
    end
endmodule
