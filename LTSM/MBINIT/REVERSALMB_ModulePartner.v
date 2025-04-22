module REVERSALMB_ModulePartner (
    input wire              CLK,
    input wire              rst_n,
    input wire              i_REPAIRVAL_end,
    input wire [15:0]       i_REVERSAL_Pattern_Result_logged,
    input wire [3:0]        i_Rx_SbMessage,
    input wire              i_falling_edge_busy,
    input wire              i_Busy_SideBand,
    input                   i_msg_valid,
    // input wire              i_valid_REVERSAL_Pattern_result_logged,

    // output reg              o_MBINIT_REVERSAL_Pattern_Detection_En,
    output reg [15:0]       o_REVERSAL_Pattern_Result_logged,
    output reg [3:0]        o_TX_SbMessage,
    output reg [1:0]        o_Clear_Pattern_Comparator,
    output reg              o_MBINIT_REVERSALMB_ModulePartner_end,
    output reg              o_ValidOutDatat_ModulePartner,
    output reg              o_ValidDataFieldParameters_modulePartner
);


reg [3:0] CS, NS;   // CS current state, NS next state

////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////

localparam MBINI_REVERSALMB_init_req            = 4'b0001;
localparam MBINIT_REVERSALMB_init_resp          = 4'b0010;
localparam MBINIT_REVERSALMB_clear_error_req    = 4'b0011;
localparam MBINIT_REVERSALMB_clear_error_resp   = 4'b0100;
localparam MBINIT_REVERSALMB_result_req         = 4'b0101;
localparam MBINIT_REVERSALMB_result_resp        = 4'b0110;
localparam MBINIT_REVERSALMB_done_req           = 4'b0111;
localparam MBINIT_REVERSALMB_done_resp          = 4'b1000;


////////////////////////////////////////////////////////////////////////////////
// State machine states ModulePartner
////////////////////////////////////////////////////////////////////////////////
localparam IDLE                             = 0;
localparam REVERSALMB_CHECK_INIT_REQ        = 1;
localparam REVERSALMB_CHECK_BUSY_INIT_RESP  = 2;
localparam REVERSALMB_INIT_RESP             = 3;
localparam REVERSALMB_HANDLE_VALID          = 4;
localparam REVERSALMB_CHECK_BUSY_CLEAR      = 5;
localparam REVERSALMB_CLEAR_ERROR_RESP      = 6;
// localparam REVERSALMB_GET_COMPARE           = 7;
localparam REVERSALMB_CHECK_BUSY_RESULT     = 7;
localparam REVERSALMB_RESULT_RESP           = 8;
localparam REVERSALMB_CHECK_BUSY_DONE       = 9;
localparam REVERSALMB_DONE_RESP             = 10;
localparam REVERSALMB_DONE                  = 11;


////////////////////////////////////////////////////////////////////////////////
// State machine Transition for the REVERSALMB_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            CS <= IDLE;
        end else begin
            CS <= NS;
        end
    end


////////////////////////////////////////////////////////////////////////////////
// Next state logic for the REVERSALMB_ModulePartner
////////////////////////////////////////////////////////////////////////////////
    always @(*) begin
        NS = CS;
        case (CS)
            IDLE: begin
                if (i_REPAIRVAL_end) NS = REVERSALMB_CHECK_INIT_REQ;
            end
            REVERSALMB_CHECK_INIT_REQ: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (i_Rx_SbMessage == MBINI_REVERSALMB_init_req) NS = REVERSALMB_CHECK_BUSY_INIT_RESP;
            end
            REVERSALMB_CHECK_BUSY_INIT_RESP: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REVERSALMB_INIT_RESP;
            end
            REVERSALMB_INIT_RESP: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REVERSALMB_HANDLE_VALID;
            end
            REVERSALMB_HANDLE_VALID: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (i_Rx_SbMessage == MBINIT_REVERSALMB_clear_error_req && i_msg_valid) NS = REVERSALMB_CHECK_BUSY_CLEAR;
                else if (i_Rx_SbMessage == MBINIT_REVERSALMB_result_req && i_msg_valid) NS = REVERSALMB_CHECK_BUSY_RESULT;
                else if (i_Rx_SbMessage == MBINIT_REVERSALMB_done_req && i_msg_valid) NS = REVERSALMB_CHECK_BUSY_DONE;
            end
            REVERSALMB_CHECK_BUSY_CLEAR: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REVERSALMB_CLEAR_ERROR_RESP;
            end
            REVERSALMB_CLEAR_ERROR_RESP: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REVERSALMB_HANDLE_VALID;
            end
            // REVERSALMB_GET_COMPARE: begin
            //     if (~i_REPAIRVAL_end) NS = IDLE;
            //     else if (i_valid_REVERSAL_Pattern_result_logged) NS = REVERSALMB_CHECK_BUSY_RESULT;
            // end
            REVERSALMB_CHECK_BUSY_RESULT: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REVERSALMB_RESULT_RESP;
            end
            REVERSALMB_RESULT_RESP: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REVERSALMB_HANDLE_VALID;
            end
            REVERSALMB_CHECK_BUSY_DONE: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (~i_Busy_SideBand) NS = REVERSALMB_DONE_RESP;
            end
            REVERSALMB_DONE_RESP: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
                else if (i_falling_edge_busy) NS = REVERSALMB_DONE;
            end
            REVERSALMB_DONE: begin
                if (~i_REPAIRVAL_end) NS = IDLE;
            end
            default: NS = IDLE;
        endcase
    end

    // ////////////////////////////////////////////////////////////////////////////////
    // // Combinational output logic for the REVERSALMB_ModulePartner
    // ////////////////////////////////////////////////////////////////////////////////
    // always @(*) begin
    //     // Default values
    //     o_REVERSAL_Pattern_Result_logged       = 16'b0;
    //     o_TX_SbMessage                         = 4'b0000;
    //     o_Clear_Pattern_Comparator             = 0;
    //     o_MBINIT_REVERSALMB_ModulePartner_end  = 0;
    //     o_ValidOutDatat_ModulePartner          = 0;
    //     o_ValidDataFieldParameters_modulePartner=0;
    //     o_MBINIT_REVERSALMB_Functional_Lanes=0;

    //     case (NS)
    //         REVERSALMB_INIT_RESP: begin
    //             o_ValidOutDatat_ModulePartner = 1'b1;
    //             o_TX_SbMessage = MBINIT_REVERSALMB_init_resp;
    //         end
    //         REVERSALMB_CLEAR_ERROR_RESP: begin
    //             o_ValidOutDatat_ModulePartner = 1'b1;
    //             o_TX_SbMessage = MBINIT_REVERSALMB_clear_error_resp;
    //             o_Clear_Pattern_Comparator=2'b01;
    //             o_MBINIT_REVERSALMB_Functional_Lanes=2'b11;
    //         end       
    //         REVERSALMB_RESULT_RESP: begin
    //             o_ValidOutDatat_ModulePartner = 1'b1;
    //             o_TX_SbMessage = MBINIT_REVERSALMB_result_resp;
    //             o_ValidDataFieldParameters_modulePartner=1'b1;
    //             o_REVERSAL_Pattern_Result_logged = i_REVERSAL_Pattern_Result_logged;
    //         end
    //         REVERSALMB_DONE_RESP: begin
    //             o_ValidOutDatat_ModulePartner = 1'b1;
    //             o_TX_SbMessage = MBINIT_REVERSALMB_done_resp;
    //         end
    //         REVERSALMB_DONE: begin
    //             o_MBINIT_REVERSALMB_ModulePartner_end = 1;
    //         end
    //         default: begin
    //             o_REVERSAL_Pattern_Result_logged       = 16'b0;
    //             o_TX_SbMessage                         = 4'b0000;
    //             o_Clear_Pattern_Comparator             = 0;
    //             o_MBINIT_REVERSALMB_ModulePartner_end  = 0;
    //             o_ValidOutDatat_ModulePartner          = 0;    
    //             o_ValidDataFieldParameters_modulePartner=0; 
    //             o_MBINIT_REVERSALMB_Functional_Lanes=0; 
    //         end
    //     endcase
    // end

    ////////////////////////////////////////////////////////////////////////////////
    // Registered output logic for the REVERSALMB_ModulePartner
    ////////////////////////////////////////////////////////////////////////////////
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            o_REVERSAL_Pattern_Result_logged       <= 16'b0;
            o_TX_SbMessage                         <= 4'b0000;
            o_Clear_Pattern_Comparator             <= 2'b11;
            o_MBINIT_REVERSALMB_ModulePartner_end  <= 0;
            o_ValidOutDatat_ModulePartner          <= 0;
            o_ValidDataFieldParameters_modulePartner<= 0;
        end else begin
            case (NS)
                IDLE: begin
                    o_Clear_Pattern_Comparator  <= 2'b00;
                end
                REVERSALMB_INIT_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REVERSALMB_init_resp;
                end
                REVERSALMB_CLEAR_ERROR_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REVERSALMB_clear_error_resp;
                    o_Clear_Pattern_Comparator <= 2'b01;
                end       
                REVERSALMB_RESULT_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REVERSALMB_result_resp;
                    o_ValidDataFieldParameters_modulePartner <= 1'b1;
                    o_REVERSAL_Pattern_Result_logged <= i_REVERSAL_Pattern_Result_logged;
                end
                REVERSALMB_DONE_RESP: begin
                    o_ValidOutDatat_ModulePartner <= 1'b1;
                    o_TX_SbMessage <= MBINIT_REVERSALMB_done_resp;
                end
                REVERSALMB_DONE: begin
                    o_ValidDataFieldParameters_modulePartner<= 0; 
                    o_ValidOutDatat_ModulePartner <= 1'b0;    
                    o_MBINIT_REVERSALMB_ModulePartner_end <= 1;
                end
                default: begin
                    o_REVERSAL_Pattern_Result_logged       <= 16'b0;
                    o_TX_SbMessage                         <= 4'b0000;
                    o_Clear_Pattern_Comparator             <= 2'b11;
                    o_MBINIT_REVERSALMB_ModulePartner_end  <= 0;
                    o_ValidOutDatat_ModulePartner          <= 0;    
                    o_ValidDataFieldParameters_modulePartner<= 0; 
                end
            endcase
        end
    end
endmodule