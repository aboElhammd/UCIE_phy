///////////////////////////////////////////////////////////////////////////////////
// CAL_Module
// Author: Ayman Sayed
// Date: 17/2/2025
// Version: 1.0
//
// This module implements a state machine for a calibration process in a digital
// system. The module interfaces with sideband messages to coordinate the 
// calibration process and signals when the calibration is complete.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_MBINIT_PARAM_end: Enable signal for the calibration process
// - i_train_error_req: Signal indicating a training error request
// - i_Busy_SideBand: Signal indicating if the sideband is busy
// - i_RX_SbMessage: 4-bit input sideband message
//
// Outputs:
// - o_TX_SbMessage: 4-bit output sideband message
// - o_ValidOutDatat_Module: Signal indicating if the module is valid
// - o_MBINIT_CAL_Module_end: Signal indicating the end of the calibration process
//
// The state machine has three states:
// - IDLE: Initial state, waiting for the calibration enable signal
// - MBINIT_CAL_REQ: State indicating a calibration request
// - MBINIT_CAL_Module_DONE: State indicating the calibration process is complete
//
// The state transitions are based on the input signals and the current state.
// The output signals are driven based on the current state.
////////////////////////////////////////////////////////////////////////////////

module CAL_Module #(parameter SB_MSG_WIDTH = 4) (
    input                               CLK,
    input                               rst_n,
    input                               i_MBINIT_PARAM_end,
    input 								i_falling_edge_busy,	// 34an 23rf lma yege el rising edge bta3 el busy bit
    input                               i_Busy_SideBand,
    input      [SB_MSG_WIDTH-1:0]       i_RX_SbMessage,
    input                               i_msg_valid,
    
    output reg [SB_MSG_WIDTH-1:0]       o_TX_SbMessage,
    output reg                          o_ValidOutDatat_Module,
    output reg                          o_MBINIT_CAL_Module_end
);

reg [1:0] CS, NS;   // CS current state, NS next state



////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////
localparam MBINIT_CAL_Done_req = 4'b0001;
localparam MBINIT_CAL_Done_resp = 4'b0010;

////////////////////////////////////////////////////////////////////////////////
// State machine states module
////////////////////////////////////////////////////////////////////////////////
localparam IDLE = 0;
localparam MBINIT_CAL_REQ = 1;
localparam MBINIT_HANDLE_VALID=2;
localparam MBINIT_CAL_Module_DONE = 3;


////////////////////////////////////////////////////////////////////////////////
// State machine logic for the CAL_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE;
    end else begin
        CS <= NS;
    end
end

////////////////////////////////////////////////////////////////////////////////
// Next state logic for the CAL_Module && ouput state
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    case (CS)

// hen mesh hab3t tool ma elbasy =1; fmesh hatneql ll ba3dy
        IDLE: begin
            if (i_MBINIT_PARAM_end  && !(i_Busy_SideBand) ) begin
                NS = MBINIT_CAL_REQ;
            end else begin
                NS = IDLE;
            end
        end
// mesh mehtag hena state handle sending 3shan keda keda ethandlet fe ele qably
        MBINIT_CAL_REQ: begin
            if (!i_MBINIT_PARAM_end) begin
                NS = IDLE;
            end else if (i_falling_edge_busy) begin
                NS = MBINIT_HANDLE_VALID;
            end else begin
                NS = MBINIT_CAL_REQ;
            end
        end
// de 3lshan lma egely falling wmeglesh resp lsa wda 3shan mrg3sh tany req
        MBINIT_HANDLE_VALID: begin
            if (!i_MBINIT_PARAM_end) begin
                NS = IDLE;
            end else if (i_RX_SbMessage == MBINIT_CAL_Done_resp && i_msg_valid ) begin
                NS = MBINIT_CAL_Module_DONE;
            end else begin
                NS = MBINIT_HANDLE_VALID;
            end
        end
        MBINIT_CAL_Module_DONE: begin
            if (!(i_MBINIT_PARAM_end)) begin
                NS = IDLE;
            end else begin
                NS = MBINIT_CAL_Module_DONE;
            end
        end
        default: begin
            NS = IDLE;
        end
    endcase
end

////////////////////////////////////////////////////////////////////////////////
// Registered output logic for the CAL_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_TX_SbMessage <= 4'b0000;
        o_MBINIT_CAL_Module_end <= 1'b0;
        o_ValidOutDatat_Module <= 1'b0;
    end else begin
        o_TX_SbMessage <= 4'b0000;
        o_MBINIT_CAL_Module_end <= 1'b0;
        o_ValidOutDatat_Module <= 1'b0;
        case (NS)
            IDLE: begin
                o_TX_SbMessage <= 4'b0000;
                o_MBINIT_CAL_Module_end <= 1'b0;
                o_ValidOutDatat_Module <= 1'b0;
            end
            MBINIT_CAL_REQ: begin
                o_MBINIT_CAL_Module_end <= 1'b0;
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_CAL_Done_req;
            end
            MBINIT_HANDLE_VALID: begin
                o_MBINIT_CAL_Module_end <= 1'b0;
                o_ValidOutDatat_Module <= 1'b0;
                o_TX_SbMessage <= 0;
            end
            MBINIT_CAL_Module_DONE: begin
                o_TX_SbMessage <= 4'b0000;
                o_MBINIT_CAL_Module_end <= 1'b1;
                o_ValidOutDatat_Module <= 1'b0;
            end
            default: begin
                o_TX_SbMessage <= 4'b0000;
                o_MBINIT_CAL_Module_end <= 1'b0;
                o_ValidOutDatat_Module <= 1'b0;
            end
        endcase
    end
end
endmodule