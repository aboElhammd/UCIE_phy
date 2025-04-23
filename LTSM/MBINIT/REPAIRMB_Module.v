module REPAIRMB_Module (
    input                   CLK,
    input                   rst_n,
    input                   MBINIT_REVERSALMB_end,
    input [3:0]             i_RX_SbMessage,
    input                   i_Busy_SideBand,
    input                   i_falling_edge_busy,
    input                   i_msg_valid,
    input                   i_Start_Repeater, // from module partner
    // input [1:0]             i_Functional_Lanes_ModulePrtner, // from module partner when asked to initiated data to clk
    input                   i_Transmitter_initiated_Data_to_CLK_done,
    input [15:0]            i_Transmitter_initiated_Data_to_CLK_Result,
    output reg [3:0]        o_TX_SbMessage,
    output reg              o_Done_Repeater,
    output reg              o_MBINIT_REPAIRMB_Module_end,
    output reg              o_ValidOutDatat_REPAIRMB_Module,
    // output reg              o_Width_Degrade_en,   
    output reg [1:0]        o_Functional_Lanes, // to side band && to block of width degrade 
    output reg              o_Transmitter_initiated_Data_to_CLK_en,
    output reg              o_perlane_Transmitter_initiated_Data_to_CLK, //1 bit per lane
    output reg              o_mainband_Transmitter_initiated_Data_to_CLK, //0 bit for mainband
    output reg [2:0]        o_msg_info_repairmb
    // output reg              o_tx_msg_info_valid_repairmb
);

reg [3:0] CS, NS;   // CS current state, NS next state

reg  start_setup;
wire done_setup;

wire [1:0] w_Functional_Lanes;  // Functional lanes from REG

Functional_Lane_Setup Functional_Lane_Setup_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .start_setup(start_setup),
    .i_Transmitter_initiated_Data_to_CLK_Result(i_Transmitter_initiated_Data_to_CLK_Result),
    .done_setup(done_setup),
    .o_Functional_Lanes(w_Functional_Lanes)
);

////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////

localparam MBINIT_REPAIRMB_start_req            = 4'b0001;
localparam MBINIT_REPAIRMB_start_resp           = 4'b0010;
localparam MBINIT_REPAIRMB_apply_degrade_req    = 4'b0101;
localparam MBINIT_REPAIRMB_apply_degrade_resp   = 4'b0110;
localparam MBINIT_REPAIRMB_end_req              = 4'b0011;
localparam MBINIT_REPAIRMB_end_resp             = 4'b0100;


////////////////////////////////////////////////////////////////////////////////
// State machine states MODULE
////////////////////////////////////////////////////////////////////////////////
localparam  IDLE                            = 0;
localparam  REPAIRMB_START_REQ              = 1;
localparam  REPAIRMB_HANDLE_VALID           = 2;
localparam  REPAIRMB_INITIATED_DATA_CLOCK   = 3;
localparam  REPAIRMB_SETUP_FUNCTIONAL_LANES = 4;
localparam  REPAIRMB_CHECK_BUSY_DEGRADE     = 5;
localparam  REPAIRMB_DEGRADE_REQ            = 6;
localparam  REPAIRMB_CHECK_BUSY_END_REQ     = 7;
localparam  REPAIRMB_END_REQ                = 8;
localparam  REPAIRMB_DONE                   = 9;


////////////////////////////////////////////////////////////////////////////////
// State machine logic for the REPAIRMB_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE;
    end else begin
        CS <= NS;
    end
end



////////////////////////////////////////////////////////////////////////////////
// Next state logic for the REPAIRMB_Module
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    NS = CS; // Default to hold state
    case (CS)
        IDLE: begin
            if (MBINIT_REVERSALMB_end && ~i_Busy_SideBand) NS = REPAIRMB_START_REQ;
        end
        REPAIRMB_START_REQ: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REPAIRMB_HANDLE_VALID;
        end
        REPAIRMB_HANDLE_VALID: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if ((i_RX_SbMessage == MBINIT_REPAIRMB_start_resp && i_msg_valid) || i_Start_Repeater) NS = REPAIRMB_INITIATED_DATA_CLOCK;
            else if (i_RX_SbMessage == MBINIT_REPAIRMB_apply_degrade_resp && i_msg_valid) NS = REPAIRMB_CHECK_BUSY_END_REQ;

            else if (i_RX_SbMessage == MBINIT_REPAIRMB_end_resp && i_msg_valid) NS = REPAIRMB_DONE;
        end
        REPAIRMB_INITIATED_DATA_CLOCK: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if ( i_Transmitter_initiated_Data_to_CLK_done) NS = REPAIRMB_SETUP_FUNCTIONAL_LANES;
        end
        REPAIRMB_SETUP_FUNCTIONAL_LANES: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (done_setup) NS = REPAIRMB_CHECK_BUSY_DEGRADE;
        end

        REPAIRMB_CHECK_BUSY_DEGRADE: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRMB_DEGRADE_REQ;
        end
        REPAIRMB_DEGRADE_REQ: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REPAIRMB_HANDLE_VALID;
        end
        REPAIRMB_CHECK_BUSY_END_REQ: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRMB_END_REQ;
        end
        REPAIRMB_END_REQ: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REPAIRMB_HANDLE_VALID;
        end
        REPAIRMB_DONE: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
        end
        default: NS = IDLE;
    endcase
end

////////////////////////////////////////////////////////////////////////////////
// Registered output logic for the REPAIRMB_Module
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_TX_SbMessage                              <= 4'b0000;
        o_MBINIT_REPAIRMB_Module_end                <= 0;
        o_ValidOutDatat_REPAIRMB_Module             <= 0;
        o_Functional_Lanes                          <= 2'b11;
        o_Transmitter_initiated_Data_to_CLK_en      <= 0;
        o_perlane_Transmitter_initiated_Data_to_CLK <= 0;
        o_mainband_Transmitter_initiated_Data_to_CLK<= 0;
        start_setup                                 <= 0;
        o_Done_Repeater                             <= 0;
        o_msg_info_repairmb                         <= 0;


    end else begin
        // Default values
        o_TX_SbMessage                              <= 4'b0000;
        o_MBINIT_REPAIRMB_Module_end                <= 0;
        o_ValidOutDatat_REPAIRMB_Module             <= 0;
        o_Transmitter_initiated_Data_to_CLK_en      <= 0;
        o_perlane_Transmitter_initiated_Data_to_CLK <= 0;
        o_mainband_Transmitter_initiated_Data_to_CLK<= 0;
        start_setup                                 <= 0;
        o_Done_Repeater                             <= 0;
        o_msg_info_repairmb                         <= 0;









        case (NS)
            REPAIRMB_START_REQ: begin
                o_ValidOutDatat_REPAIRMB_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRMB_start_req;
            end
            REPAIRMB_INITIATED_DATA_CLOCK: begin
                // if (i_Start_Repeater) begin
                //     o_Functional_Lanes <= i_Functional_Lanes_ModulePrtner;
                // end else begin
                //     o_Functional_Lanes <= 2'b11;
                // end 
                o_Transmitter_initiated_Data_to_CLK_en <= 1;
                o_perlane_Transmitter_initiated_Data_to_CLK <= 1;
                o_mainband_Transmitter_initiated_Data_to_CLK<= 0;
            end

            REPAIRMB_SETUP_FUNCTIONAL_LANES: begin
                start_setup <= 1;
            end

            REPAIRMB_DEGRADE_REQ: begin
                o_ValidOutDatat_REPAIRMB_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRMB_apply_degrade_req;
                o_Functional_Lanes <= w_Functional_Lanes;
                o_msg_info_repairmb <= {1'b0,w_Functional_Lanes};
                if (i_Start_Repeater) o_Done_Repeater <= 1;
            end
            REPAIRMB_END_REQ: begin
                o_ValidOutDatat_REPAIRMB_Module <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRMB_end_req;


            end
            REPAIRMB_DONE: begin
                o_MBINIT_REPAIRMB_Module_end <= 1;
            end
            default: begin
                o_TX_SbMessage                              <= 4'b0000;
                o_MBINIT_REPAIRMB_Module_end                <= 0;
                o_ValidOutDatat_REPAIRMB_Module             <= 0;
                o_Transmitter_initiated_Data_to_CLK_en      <= 0;
                o_perlane_Transmitter_initiated_Data_to_CLK <= 0;
                o_mainband_Transmitter_initiated_Data_to_CLK<= 0;  
                start_setup                                 <= 0; 
                o_Done_Repeater                             <= 0;
                o_msg_info_repairmb                         <= 0;  
            end
        endcase
    end
end
endmodule