module PARAM_ModulePartner (
    input wire          CLK,
    input wire          rst_n,
    input wire          i_MBINIT_Start_en,
    input wire [3:0]    i_RX_SbMessage,
    input wire          i_falling_edge_busy,
    input wire          i_Busy_SideBand,
    input wire [4:0]    i_RX_VoltageSwing,
    input wire [2:0]    i_RX_MaxDataRate,
    input wire          i_RX_ClockMode,
    input wire          i_RX_PhaseClock,
    input wire          i_rx_msg_valid,

    output reg [2:0]    o_MaxDataRate,
    output reg          o_TX_ClockMode,
    output reg          o_TX_PhaseClock,
    output reg          o_MBINIT_PARAM_ModulePartner_end,
    output reg [3:0]    o_TX_SbMessage,
    output reg          o_ValidOutDatat_ModulePartner,
    output reg          o_ValidDataFieldParameters
);

reg          o_Enable_Ehecker; // for checking

// Define the states for the state machine
reg [2:0] CS, NS;   // CS current state, NS next state
// Internal signals for instantiation
wire [2:0] w_Max_DataRate_AfterChecker;
wire w_Clock_Mode_AfterChecker;
wire w_Phase_Clock_AfterChecker;
wire w_Finish_Checker;

// Instantiation of CHECKER_PARAM_Partner
CHECKER_PARAM_Partner u_CHECKER_PARAM_Partner (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_Enable_Ehecker(o_Enable_Ehecker),
    .i_voltage_swing(i_RX_VoltageSwing),
    .i_Max_DataRate(i_RX_MaxDataRate),
    .i_Clock_Mode(i_RX_ClockMode),
    .i_Phase_Clock(i_RX_PhaseClock),

    .o_Max_DataRate_AfterChecker(w_Max_DataRate_AfterChecker),
    .o_Clock_Mode_AfterChecker(w_Clock_Mode_AfterChecker),
    .o_Phase_Clock_AfterChecker(w_Phase_Clock_AfterChecker),
    .o_Finish_Checker(w_Finish_Checker)
);

////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////
    localparam MBINIT_PARAM_configuration_req = 4'b0001;
    localparam MBINIT_PARAM_configuration_resp = 4'b0010;


////////////////////////////////////////////////////////////////////////////////
// State machine states
////////////////////////////////////////////////////////////////////////////////
    localparam IDLE                             = 0;
    localparam PARAM_CHECK_REQ                  = 1;
    localparam PARAM_CHECK_PARAMTERS            = 2;
    localparam PARAM_CHECK_BUSY                 = 3;
    localparam PARAM_RESP                       = 4;
    localparam PARAM_DONE                       = 5;

////////////////////////////////////////////////////////////////////////////////
// State machine logic for the PARAM_MODULEPartner
////////////////////////////////////////////////////////////////////////////////
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            CS <= IDLE;
        end else begin
            CS <= NS;
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Next state logic for the PARAM_ModulePartner
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    NS = CS; // Default to hold state
    case (CS)
        IDLE: begin
            if (i_MBINIT_Start_en) NS = PARAM_CHECK_REQ;
        end
        PARAM_CHECK_REQ: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
            else if (i_RX_SbMessage == MBINIT_PARAM_configuration_req && i_rx_msg_valid) NS = PARAM_CHECK_PARAMTERS;
        end
        PARAM_CHECK_PARAMTERS: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
            else if (w_Finish_Checker) NS = PARAM_CHECK_BUSY;
        end
        PARAM_CHECK_BUSY: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
            else if (~i_Busy_SideBand) NS = PARAM_RESP;
        end
        PARAM_RESP: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
            else if (i_falling_edge_busy) NS = PARAM_DONE;
        end
        PARAM_DONE: begin
            if (~i_MBINIT_Start_en) NS = IDLE;
        end
        default: begin
            NS = IDLE;
        end
    endcase
end

////////////////////////////////////////////////////////////////////////////////
// Output logic for the PARAM_ModulePartner
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_Enable_Ehecker <= 1'b0;
        o_MaxDataRate <= 3'b0;
        o_TX_ClockMode <= 1'b0;
        o_TX_PhaseClock <= 1'b0;
        o_MBINIT_PARAM_ModulePartner_end <= 1'b0;
        o_TX_SbMessage <= 4'b0;
        o_ValidOutDatat_ModulePartner <= 1'b0;
        o_ValidDataFieldParameters <= 1'b0;
    end else begin
        o_Enable_Ehecker <= 1'b0;
        o_MaxDataRate <= 3'b0;
        o_TX_ClockMode <= 1'b0;
        o_TX_PhaseClock <= 1'b0;
        o_MBINIT_PARAM_ModulePartner_end <= 1'b0;
        o_TX_SbMessage <= 4'b0;
        o_ValidOutDatat_ModulePartner <= 1'b0;
        o_ValidDataFieldParameters <= 1'b0;
        case (NS)
            PARAM_CHECK_PARAMTERS: begin
                o_Enable_Ehecker <= 1'b1;
            end
            PARAM_CHECK_BUSY: begin
                o_Enable_Ehecker <= 1'b1;
            end
            PARAM_RESP: begin
                o_MaxDataRate <= w_Max_DataRate_AfterChecker;
                o_TX_ClockMode <= w_Clock_Mode_AfterChecker;
                o_TX_PhaseClock <= w_Phase_Clock_AfterChecker;
                o_TX_SbMessage <= MBINIT_PARAM_configuration_resp;
                o_ValidOutDatat_ModulePartner <= 1'b1;
                o_ValidDataFieldParameters <= 1'b1;
            end
            PARAM_DONE: begin
                o_MBINIT_PARAM_ModulePartner_end <= 1'b1;
            end
            default: begin
                o_Enable_Ehecker <= 1'b0;
                o_MaxDataRate <= 3'b0;
                o_TX_ClockMode <= 1'b0;
                o_TX_PhaseClock <= 1'b0;
                o_MBINIT_PARAM_ModulePartner_end <= 1'b0;
                o_TX_SbMessage <= 4'b0;
                o_ValidOutDatat_ModulePartner <= 1'b0;
                o_ValidDataFieldParameters <= 1'b0;
            end
        endcase
    end
end

// ////////////////////////////////////////////////////////////////////////////////
// // Output logic for the PARAM_ModulePartner
// ////////////////////////////////////////////////////////////////////////////////
// always @(*) begin
//     o_Enable_Ehecker = 1'b0;
//     o_MaxDataRate = 4'b0;
//     o_TX_ClockMode = 1'b0;
//     o_TX_PhaseClock = 1'b0;
//     o_MBINIT_PARAM_ModulePartner_end = 1'b0;
//     o_TX_SbMessage = 4'b0;
//     o_ValidOutDatat_ModulePartner = 1'b0;
//     o_ValidDataFieldParameters = 1'b0;
//     case (NS)
//         PARAM_CHECK_PARAMTERS: begin
//             o_Enable_Ehecker = 1'b1;
//         end
//         PARAM_CHECK_BUSY: begin
//             o_Enable_Ehecker = 1'b1;
//         end
//         PARAM_RESP: begin
//             o_MaxDataRate = w_Max_DataRate_AfterChecker;
//             o_TX_ClockMode = w_Clock_Mode_AfterChecker;
//             o_TX_PhaseClock = w_Phase_Clock_AfterChecker;
//             o_TX_SbMessage = MBINIT_PARAM_configuration_resp;
//             o_ValidOutDatat_ModulePartner = 1'b1;
//             o_ValidDataFieldParameters    =1'b1;
//         end
//         PARAM_DONE: begin
//             o_MBINIT_PARAM_ModulePartner_end = 1'b1;
//         end
//         default begin
//             o_Enable_Ehecker = 1'b0;
//             o_MaxDataRate = 4'b0;
//             o_TX_ClockMode = 1'b0;
//             o_TX_PhaseClock = 1'b0;
//             o_MBINIT_PARAM_ModulePartner_end = 1'b0;
//             o_TX_SbMessage = 4'b0;
//             o_ValidOutDatat_ModulePartner = 1'b0;
//             o_ValidDataFieldParameters = 1'b0;
//         end
            
//     endcase
// end
endmodule