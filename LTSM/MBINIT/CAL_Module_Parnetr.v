////////////////////////////////////////////////////////////////////////////////
// CAL_ModulePartner
// Author: Ayman Sayed
// Date: 17/2/2025
// Version: 1.0
//
// This module implements a state machine for a partner calibration process in a digital
// system. The module interfaces with sideband messages to coordinate the 
// calibration process and signals when the calibration is complete.
//
// Inputs:
// - CLK: Clock signal
// - rst_n: Active low reset signal
// - i_MBINIT_PARAM_end: Enable signal for the calibration process
// - i_train_error_req: Signal indicating a training error request
// - i_RX_SbMessage: 4-bit input sideband message
// - i_Busy_SideBand: Signal indicating if the sideband is busy
//
// Outputs:
// - o_TX_SbMessage: 4-bit output sideband message
// - o_ValidOutDatat_ModulePartner: Signal indicating if the module partner is valid
// - o_MBINIT_CAL_ModulePartner_end: Signal indicating the end of the calibration process
//
// The state machine has three states:
// - IDLE: Initial state, waiting for the calibration enable signal
// - MBINIT_CAL_Check_Req: State indicating a calibration request check
// - MBINIT_CAL_resp: State indicating the calibration process is complete
//
// The state transitions are based on the input signals and the current state.
// The output signals are driven based on the current state.
////////////////////////////////////////////////////////////////////////////////

module CAL_ModulePartner (
    input               CLK,
    input               rst_n,
    input               i_MBINIT_PARAM_end,
    input [3:0]         i_RX_SbMessage,
    input               i_msg_valid,
    input               i_Busy_SideBand,
    input 				i_falling_edge_busy,	// 34an 23rf lma yege el rising edge bta3 el busy bit

    output reg          o_MBINIT_CAL_ModulePartner_end,
    output reg          o_ValidOutDatat_ModulePartner,
    output reg [3:0]    o_TX_SbMessage
);

reg [2:0] CS, NS;   // CS current state, NS next state

////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////
localparam MBINIT_CAL_Done_req = 4'b0001;
localparam MBINIT_CAL_Done_resp = 4'b0010;

////////////////////////////////////////////////////////////////////////////////
// State machine states Partner
////////////////////////////////////////////////////////////////////////////////
localparam IDLE = 0;
localparam MBINIT_CAL_Check_Req = 1;
localparam MBINIT_CAL_resp = 2;
localparam MBINIT_HANDLE_SENDEING = 3;
localparam MBINIT_CAL_ModulePartner_DONE = 4;

////////////////////////////////////////////////////////////////////////////////
// State machine logic for the CAL_ModulePartner
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE;
    end else begin
        CS <= NS;
    end
end

////////////////////////////////////////////////////////////////////////////////
// Next state logic for the CAL_ModulePartner
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    case (CS)
        IDLE: begin
            if (i_MBINIT_PARAM_end ) begin
                NS = MBINIT_CAL_Check_Req;
            end else begin
                NS = IDLE;
            end
        end

        MBINIT_CAL_Check_Req: begin
        if (!i_MBINIT_PARAM_end) begin
            NS=IDLE;
        end else if (i_RX_SbMessage == MBINIT_CAL_Done_req && i_msg_valid) begin
                NS = MBINIT_HANDLE_SENDEING;
            end else begin
                NS = MBINIT_CAL_Check_Req;
            end
        end

        MBINIT_HANDLE_SENDEING: begin
        if (!i_MBINIT_PARAM_end) begin
            NS=IDLE;  
        end else if (!(i_Busy_SideBand)) begin
                NS = MBINIT_CAL_resp;
            end else begin
                NS = MBINIT_HANDLE_SENDEING;
            end
        end
        MBINIT_CAL_resp: begin
            if (!i_MBINIT_PARAM_end) begin
                NS = IDLE;
            end else if (i_falling_edge_busy) begin
                NS = MBINIT_CAL_ModulePartner_DONE;
            end else begin
                NS = MBINIT_CAL_resp;
            end
        end
        //// tab3an mesh mehtag handle elvalid wda 3shan tb3an elvalid =0 fe ele b3do
        MBINIT_CAL_ModulePartner_DONE: begin
            if (!(i_MBINIT_PARAM_end)) begin
                NS = IDLE;
            end else begin
                NS = MBINIT_CAL_ModulePartner_DONE;
            end
        end
        default: begin
            NS = IDLE;
        end
    endcase
end

////////////////////////////////////////////////////////////////////////////////
// Registered output logic for the CAL_ModulePartner
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_MBINIT_CAL_ModulePartner_end      <= 0;
        o_TX_SbMessage                      <= 4'b0000;
        o_ValidOutDatat_ModulePartner       <= 0;
    end else begin
        o_MBINIT_CAL_ModulePartner_end      <= 0;
        o_TX_SbMessage                      <= 4'b0000;
        o_ValidOutDatat_ModulePartner       <= 0;
        case (NS)
            IDLE: begin
                o_MBINIT_CAL_ModulePartner_end      <= 0;
                o_TX_SbMessage                      <= 4'b0000;
                o_ValidOutDatat_ModulePartner       <= 0;
            end
            MBINIT_CAL_Check_Req: begin
                o_MBINIT_CAL_ModulePartner_end      <= 0;
                o_TX_SbMessage                      <= 4'b0000;
                o_ValidOutDatat_ModulePartner       <= 0;
            end
            MBINIT_HANDLE_SENDEING: begin
                o_MBINIT_CAL_ModulePartner_end      <= 0;
                o_TX_SbMessage                      <= 4'b0000;
                o_ValidOutDatat_ModulePartner       <= 0;        
            end
            MBINIT_CAL_resp: begin
                o_ValidOutDatat_ModulePartner <= 1'b1;
                o_TX_SbMessage <= MBINIT_CAL_Done_resp;
            end
            MBINIT_CAL_ModulePartner_DONE: begin
                o_MBINIT_CAL_ModulePartner_end <= 1;
            end
            default : begin 
            o_MBINIT_CAL_ModulePartner_end      <= 0;
            o_TX_SbMessage                      <= 4'b0000;
            o_ValidOutDatat_ModulePartner       <= 0;
            
            end
        endcase
    end
end

endmodule