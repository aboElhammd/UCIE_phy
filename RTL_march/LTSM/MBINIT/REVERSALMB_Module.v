////////////////////////////////////////////////////////////////////////////////
// REVERSALMB_Module
// Author: Ayman Sayed
// Date: 19/2/2025
// Version: 1.0
//
// This module implements a state machine for a lane reversal process in a digital
// system. The module interfaces with sideband messages to coordinate the 
// lane reversal process and signals when the process is complete.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_REPAIRVAL_end: Signal indicating the end of the REPAIRVAL process
// - i_REVERSAL_done: Signal indicating the reversal process is done
// - i_Rx_SbMessage: 4-bit input sideband message
// - i_Busy_SideBand: Signal indicating if the sideband is busy
// - i_LaneID_Pattern_done: Signal indicating the lane ID pattern is done
// - i_train_error_req: Signal indicating a training error request
// - i_REVERSAL_Result_logged: 16-bit signal indicating the reversal result is logged
//
// Outputs:
// 
// - o_MBINIT_REVERSALMB_LaneID_Pattern_En: Signal enabling the lane ID pattern
// - o_MBINIT_REVERSALMB_ValidFraming_En: Signal enabling valid framing
// - o_MBINIT_REVERSALMB_ApplyReversal_En: Signal enabling the application of reversal
// - o_MBINIT_REVERSALMB_Module_end: Signal indicating the end of the reversal process
// - o_TX_SbMessage: 4-bit output sideband message
// - o_ValidOutDatat_Module: Signal indicating if the module is valid
//
// The state machine has several states:
// - IDLE: Initial state, waiting for the REPAIRVAL end signal
// - REVERSALMB_INIT_REQ: State indicating a lane reversal initialization request
// - REVERSALMB_CLEAR_ERROR_REQ: State indicating a clear error request
// - REVERSALMB_LANEID_PATTER: State indicating the lane ID pattern generation
// - REVERSALMB_RESULT_REQ: State indicating a lane reversal result request
// - REVERSALMB_CHECK_RESULT: State checking the lane reversal result
// - REVERSALMB_APPLY_REVERSAL: State applying the lane reversal
// - REVERSALMB_DONE_REQ: State indicating a lane reversal done request
// - REVERSALMB_DONE: State indicating the lane reversal process is complete
//
// The state transitions are based on the input signals and the current state.
// The output signals are driven based on the current state.
////////////////////////////////////////////////////////////////////////////////
module REVERSALMB_Module (   
    input               CLK,
    input               rst_n,
    input               i_REPAIRVAL_end,
    input               i_REVERSAL_done,
    input [3:0]         i_Rx_SbMessage,
    input               i_Busy_SideBand,
    input               i_msg_valid,
    input               i_LaneID_Pattern_done,
    input               i_falling_edge_busy, 
    input [15:0]        i_REVERSAL_Result_logged, //from rx_sb when it responed with resp on result on i_Rx_SbMessage

    output reg [1:0]    o_MBINIT_REVERSALMB_LaneID_Pattern_En,
    // output reg          o_MBINIT_REVERSALMB_ValidFraming_En, 
    output reg          o_MBINIT_REVERSALMB_ApplyReversal_En,       
    output reg          o_MBINIT_REVERSALMB_Module_end,
    output reg [3:0]    o_TX_SbMessage,
    output reg          o_ValidOutDatat_Module,
    output              o_train_error_req_reversalmb
);

integer  i;
reg [15:0] one_count;
reg DONE_CHECK;
reg [3:0] CS, NS;   // CS current state, NS next state
reg handle_error_req;

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
// State machine states
////////////////////////////////////////////////////////////////////////////////
localparam IDLE                         = 0;
localparam REVERSALMB_INIT_REQ          = 1;
localparam REVERSALMB_CLEAR_ERROR_REQ   = 2;
localparam REVERSALMB_LANEID_PATTER     = 3;
localparam REVERSALMB_RESULT_REQ        = 4;
localparam REVERSALMB_CHECK_RESULT      = 5;
localparam REVERSALMB_APPLY_REVERSAL    = 6;
localparam REVERSALMB_DONE_REQ          = 7;
localparam REVERSALMB_DONE              = 8;
localparam REVERSALMB_HANDLE_VALID      = 9;
localparam REVERSALMB_CHECK_BUSY_CLEAR  = 10;
localparam REVERSALMB_CHECK_BUSY_RESULT = 11;
localparam REVERSALMB_CHECK_BUSY_DONE   = 12;

assign o_train_error_req_reversalmb = (CS == REVERSALMB_CHECK_RESULT && one_count < 8 && DONE_CHECK && handle_error_req);

////////////////////////////////////////////////////////////////////////////////
// State machine logic for the REVERSALMB_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE;
    end else begin
        CS <= NS;
    end
end



////////////////////////////////////////////////////////////////////////////////
// Next state logic for the REPAIR_CLK_Module
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    NS = CS; // Default to hold state
    case (CS)
        IDLE: begin
            if (i_REPAIRVAL_end && ~i_Busy_SideBand) NS = REVERSALMB_INIT_REQ;
        end
        REVERSALMB_INIT_REQ: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REVERSALMB_HANDLE_VALID;
        end
        REVERSALMB_HANDLE_VALID: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (i_Rx_SbMessage == MBINIT_REVERSALMB_init_resp && i_msg_valid) NS = REVERSALMB_CHECK_BUSY_CLEAR;
            else if (i_Rx_SbMessage == MBINIT_REVERSALMB_clear_error_resp && i_msg_valid) NS = REVERSALMB_LANEID_PATTER;            
            else if (i_Rx_SbMessage == MBINIT_REVERSALMB_result_resp && i_msg_valid) NS = REVERSALMB_CHECK_RESULT;
            else if (i_Rx_SbMessage == MBINIT_REVERSALMB_done_resp && i_msg_valid)  NS=REVERSALMB_DONE;
        end

        REVERSALMB_CHECK_BUSY_CLEAR: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REVERSALMB_CLEAR_ERROR_REQ;
        end
        
        REVERSALMB_CLEAR_ERROR_REQ: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REVERSALMB_HANDLE_VALID;
        end

        REVERSALMB_LANEID_PATTER: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (i_LaneID_Pattern_done) NS = REVERSALMB_CHECK_BUSY_RESULT;            
        end
        
        REVERSALMB_CHECK_BUSY_RESULT : begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REVERSALMB_RESULT_REQ;
        end
        
        REVERSALMB_RESULT_REQ: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REVERSALMB_HANDLE_VALID;     
        end

        REVERSALMB_CHECK_RESULT: begin
            if (~i_REPAIRVAL_end) NS = IDLE; 
            else if (one_count >= 8 && DONE_CHECK) NS = REVERSALMB_CHECK_BUSY_DONE;
            else if (one_count < 8 && DONE_CHECK && !handle_error_req) NS = REVERSALMB_APPLY_REVERSAL;
        end

        REVERSALMB_CHECK_BUSY_DONE: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REVERSALMB_DONE_REQ;
        end
        REVERSALMB_APPLY_REVERSAL: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (i_REVERSAL_done) NS = REVERSALMB_CHECK_BUSY_CLEAR;
        end

        REVERSALMB_DONE_REQ: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REVERSALMB_HANDLE_VALID; 
        end

        REVERSALMB_DONE: begin
            if (~i_REPAIRVAL_end) NS = IDLE;
        end

        default: begin
            NS = IDLE;
        end
    endcase
end

always @(*) begin
    one_count = 0;  //initialize count variable.
    for (i = 0; i < 16; i = i + 1) begin
        //for all the bits.
        one_count = one_count + i_REVERSAL_Result_logged[i]; //Add the bit to the count. 
        if (i == 15) DONE_CHECK = 1;
        else DONE_CHECK = 0;
    end   
end

////////////////////////////////////////////////////////////////////////////////
// Registered output logic for the REVERSALMB_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_MBINIT_REVERSALMB_LaneID_Pattern_En <= 0;
        // o_MBINIT_REVERSALMB_ValidFraming_En   <= 0;
        o_MBINIT_REVERSALMB_ApplyReversal_En  <= 0;
        o_MBINIT_REVERSALMB_Module_end        <= 0;
        o_TX_SbMessage                        <= 4'b0000;
        o_ValidOutDatat_Module                <= 0;
        handle_error_req                      <= 0;
    end else begin
        o_MBINIT_REVERSALMB_LaneID_Pattern_En <= 0;
        // o_MBINIT_REVERSALMB_ValidFraming_En   <= 0;
        o_MBINIT_REVERSALMB_ApplyReversal_En  <= 0;
        o_MBINIT_REVERSALMB_Module_end        <= 0;
        o_TX_SbMessage                        <= 4'b0000;
        o_ValidOutDatat_Module                <= 0;
        case (NS)
            REVERSALMB_INIT_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINI_REVERSALMB_init_req;
            end
            REVERSALMB_CLEAR_ERROR_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REVERSALMB_clear_error_req;
            end       
            REVERSALMB_LANEID_PATTER: begin
                o_MBINIT_REVERSALMB_LaneID_Pattern_En <= 2'b11; // PERLANE
            end
            REVERSALMB_RESULT_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REVERSALMB_result_req;
            end
            REVERSALMB_APPLY_REVERSAL: begin
                o_MBINIT_REVERSALMB_ApplyReversal_En <= 1'b1;
                handle_error_req <= 1;
            end
            REVERSALMB_DONE_REQ: begin
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REVERSALMB_done_req;
            end
            REVERSALMB_DONE: begin
                o_MBINIT_REVERSALMB_Module_end <= 1;
            end
            default: begin
                o_MBINIT_REVERSALMB_LaneID_Pattern_En <= 0;
                // o_MBINIT_REVERSALMB_ValidFraming_En   <= 0;
                o_MBINIT_REVERSALMB_ApplyReversal_En  <= 0;
                o_MBINIT_REVERSALMB_Module_end        <= 0;
                o_TX_SbMessage                        <= 4'b0000;
                o_ValidOutDatat_Module                <= 0;    
            end
        endcase
    end
end
endmodule