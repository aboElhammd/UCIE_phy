module PARAM_Module (
    input wire          CLK,
    input wire          rst_n,
    input wire          i_MBINIT_Start_en,
    input wire [3:0]    i_RX_SbMessage,
    input wire          i_Busy_SideBand,
    input wire          i_falling_edge_busy,
    input wire [2:0]    i_RX_MaxDataRate,
    input wire          i_RX_ClockMode,
    input wire          i_RX_PhaseClock,
    input wire          i_msg_valid,

    output reg [4:0]    o_TX_VoltageSwing,
    output reg [2:0]    o_MaxDataRate,
    output reg          o_TX_ClockMode,
    output reg          o_TX_PhaseClock,
    output reg          o_MBINIT_PARAM_Module_end,
    output reg          o_ValidOutDatat_Module,
    output reg          o_ValidDataFieldParameters,
    output reg          o_train_error_req,
    output reg [3:0]    o_TX_SbMessage,
    output     [2:0]    o_Final_MaxDataRate,
    output              o_Final_ClockMode,
    output              o_Final_ClockPhase
);

    wire [4:0]    TX_VoltageSwing_REG;
    wire [2:0]    MaxDataRate_REG;
    wire          TX_ClockMode_REG;
    wire          TX_PhaseClock_REG;
    wire          w_Finish_Checker;
        // Define the states for the state machine
    reg [2:0] CS, NS;   // CS current state, NS next state
    reg            o_Enable_Ehecker; // for checking
    wire           Successful_Param;   // Parameter check is successful 
    wire [2:0]     i_Final_MaxDataRate;
    assign i_Final_MaxDataRate =(Successful_Param)?i_RX_MaxDataRate:0; 
    PARAM_REG PARAM_REG_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .o_TX_VoltageSwing(TX_VoltageSwing_REG),
    .i_Enable_Ehecker(o_Enable_Ehecker),
    .i_Final_MaxDataRate(i_Final_MaxDataRate),
    .o_MaxDataRate(MaxDataRate_REG),
    .o_TX_ClockMode(TX_ClockMode_REG),
    .o_TX_PhaseClock(TX_PhaseClock_REG),
    .o_Final_MaxDataRate(o_Final_MaxDataRate)
    );

    assign o_Final_ClockMode= TX_ClockMode_REG;
    assign o_Final_ClockPhase=TX_PhaseClock_REG;

    CHECKER_PARAM_Module CHECKER_PARAM_Module_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_Enable_Ehecker(o_Enable_Ehecker),
    .i_RX_MaxDataRate(i_RX_MaxDataRate),
    .i_RX_ClockMode(i_RX_ClockMode),
    .i_RX_PhaseClock(i_RX_PhaseClock),
    .o_Finish_Checker(w_Finish_Checker),
    .o_Successful_Param(Successful_Param)
    );

////////////////////////////////////////////////////////////////////////////////
// State machine states
////////////////////////////////////////////////////////////////////////////////
localparam IDLE                 = 0;
localparam PARAM_REQ            = 1;
localparam PARAM_HANDLE_VALID   = 2;
localparam PARAM_CHECK_RESP     = 3;
// localparam PARAM_DONE_CHECK     = 4;
localparam PARAM_DONE           = 4;

////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////
localparam MBINIT_PARAM_configuration_req = 4'b0001;
localparam MBINIT_PARAM_configuration_resp = 4'b0010;

////////////////////////////////////////////////////////////////////////////////
// State machine logic for the PARAM_MODULE
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE;
    end else begin
        CS <= NS;
    end
end
////////////////////////////////////////////////////////////////////////////////
// Next state logic for the PARAM_Module
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    NS = CS; // Default to hold state
    case (CS)
        IDLE: begin
            if (i_MBINIT_Start_en && ~i_Busy_SideBand) NS = PARAM_REQ;
        end
        PARAM_REQ: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
            else if (i_falling_edge_busy) NS = PARAM_HANDLE_VALID;
        end
        PARAM_HANDLE_VALID: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
            else if (i_RX_SbMessage == MBINIT_PARAM_configuration_resp && i_msg_valid) NS = PARAM_CHECK_RESP;
        end
        PARAM_CHECK_RESP: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
            else if (w_Finish_Checker) begin
                if (Successful_Param)NS = PARAM_DONE;
                else NS= IDLE;
            end
        end

        // PARAM_DONE_CHECK:begin
        //     if (~i_MBINIT_Start_en || (~Successful_Param)) NS = IDLE;
        //     else if (Successful_Param) NS = PARAM_DONE;
        // end
        
        PARAM_DONE: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
        end
        default: begin
            NS = IDLE;
        end
    endcase
end

////////////////////////////////////////////////////////////////////////////////
// Output logic for the PARAM_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_TX_VoltageSwing <= 5'b00000;
        o_MaxDataRate <= 4'b0000;
        o_TX_ClockMode <= 1'b0;
        o_TX_PhaseClock <= 1'b0;
        o_MBINIT_PARAM_Module_end <= 1'b0;
        o_ValidOutDatat_Module <= 1'b0;
        o_ValidDataFieldParameters <= 1'b0;
        o_train_error_req <= 1'b0;
        o_TX_SbMessage <= 4'b0000;
        o_Enable_Ehecker <= 1'b0;
    end else begin
        o_TX_VoltageSwing <= 5'b00000;
        o_MaxDataRate <= 4'b0000;
        o_TX_ClockMode <= 1'b0;
        o_TX_PhaseClock <= 1'b0;
        o_MBINIT_PARAM_Module_end <= 1'b0;
        o_ValidOutDatat_Module <= 1'b0;
        o_ValidDataFieldParameters <= 1'b0;
        o_train_error_req <= 1'b0;
        o_TX_SbMessage <= 4'b0000;
        o_Enable_Ehecker <= 1'b0;

        if (CS == PARAM_CHECK_RESP) begin
            if (~Successful_Param) begin
                o_train_error_req <= 1'b1;
            end
        end

        case (NS)
            PARAM_REQ: begin
                o_ValidDataFieldParameters <= 1'b1;
                o_ValidOutDatat_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_PARAM_configuration_req;
                o_TX_VoltageSwing <= TX_VoltageSwing_REG;
                o_MaxDataRate <= MaxDataRate_REG;
                o_TX_ClockMode <= TX_ClockMode_REG;
                o_TX_PhaseClock <= TX_PhaseClock_REG;
            end
            PARAM_CHECK_RESP: begin
              o_Enable_Ehecker <= 1'b1;
            end
            PARAM_DONE: begin
                o_MBINIT_PARAM_Module_end <= 1'b1;
            end
            default: begin
                o_TX_VoltageSwing <= 5'b00000;
                o_MaxDataRate <= 4'b0000;
                o_TX_ClockMode <= 1'b0;
                o_TX_PhaseClock <= 1'b0;
                o_MBINIT_PARAM_Module_end <= 1'b0;
                o_ValidOutDatat_Module <= 1'b0;
                o_ValidDataFieldParameters <= 1'b0;
                o_train_error_req <= 1'b0;
                o_TX_SbMessage <= 4'b0000;
                o_Enable_Ehecker <= 1'b0;
            end
        endcase
    end
end

// ////////////////////////////////////////////////////////////////////////////////
// // Output logic for the PARAM_Module
// ////////////////////////////////////////////////////////////////////////////////
// always @(*) begin
//     // Default values for the outputs
//     o_TX_VoltageSwing = 5'b00000;
//     o_MaxDataRate = 4'b0000;
//     o_TX_ClockMode = 1'b0;
//     o_TX_PhaseClock = 1'b0;
//     o_MBINIT_PARAM_Module_end = 1'b0;
//     o_ValidOutDatat_Module = 1'b0;
//     o_ValidDataFieldParameters = 1'b0;
//     o_train_error_req = 1'b0;
//     o_TX_SbMessage = 4'b0000;
//     o_Enable_Ehecker=0;
//     case (NS)
//         PARAM_REQ: begin
//         o_ValidDataFieldParameters  = 1'b1;
//         o_ValidOutDatat_Module      = 1'b1;
//         o_TX_SbMessage              = MBINIT_PARAM_configuration_req;
//         o_TX_VoltageSwing           = TX_VoltageSwing_REG;
//         o_MaxDataRate               = MaxDataRate_REG;
//         o_TX_ClockMode              = TX_ClockMode_REG;
//         o_TX_PhaseClock             = TX_PhaseClock_REG;
//         end
//         PARAM_CHECK_RESP: begin
//             o_Enable_Ehecker=1;
//             if (~Successful_Param) begin
//                 o_train_error_req=1;
//             end
//         end
//         // PARAM_DONE_CHECK: begin
//         //     o_Enable_Ehecker=1;
//         //     if (~Successful_Param) begin
//         //         o_train_error_req=1;
//         //     end
//         // end
//         PARAM_DONE: begin
//             o_MBINIT_PARAM_Module_end = 1'b1;
//         end
//         default : begin
//             o_TX_VoltageSwing = 5'b00000;
//             o_MaxDataRate = 4'b0000;
//             o_TX_ClockMode = 1'b0;
//             o_TX_PhaseClock = 1'b0;
//             o_MBINIT_PARAM_Module_end = 1'b0;
//             o_ValidOutDatat_Module = 1'b0;
//             o_ValidDataFieldParameters = 1'b0;
//             o_train_error_req = 1'b0;
//             o_TX_SbMessage = 4'b0000;
//             o_Enable_Ehecker=0;
//         end
//     endcase
// end


endmodule